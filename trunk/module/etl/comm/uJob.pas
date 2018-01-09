unit uJob;

interface

uses System.Classes, uThreadQueueUtil, System.JSON, System.SysUtils, uTask, uStepDefines,
    System.SyncObjs, uFileLogger, uGlobalVar;

type
  PJobRequest = ^TJobRequest;

  TJobRequest = record
    JobName: string;
    TaskConfig: TTaskCongfigRec;
  end;

  TJobHandleStatus = (jhsNone, jhsWaited, jhsRun);

  TJobConfig = class
  private
    FTaskConfigRec: TTaskCongfigRec;
    function GetTaskStepsStr: string;
    function GetTaskConfigRec: TTaskCongfigRec;
    procedure FreeTask;
  public
    JobName: string;
    TaskFile: string;

    Interval: Integer;
    LastStartTime: TDateTime;
    AllowedTimes: TStringList;
    DisallowedTimes: TStringList;
    TimeOut: Integer;
    Status: Integer;

    HandleStatus: TJobHandleStatus;

    //线程不安全参数，仅作为临时的记录
    Task: TTask;
    RunThread: TThread;
    JobRequest: PJobRequest;

    property TaskConfigRec: TTaskCongfigRec read GetTaskConfigRec;
    property TaskStepsStr: string read GetTaskStepsStr;

    constructor Create;
    destructor Destroy; override;

    procedure ParseScheduleConfig(AScheduleJsonStr: string);
    function CheckSchedule: Boolean;
    function IsTimeOut: Boolean;
  end;


  //本类用于实际运行时对任务的处理和管理
  TJobMgr = class
  private
    FRunBasePath: string;
    FJobs: TStringList;

    FGlobalVar: TGlobalVar;

    FThreadPool: TThreadPool;
    FThreadCount: Integer;

    FLogLevel: TLogLevel;

    FUnHandledCount: Integer;

    Critical: TCriticalSection;

    //在线程中实际处理task_request的方法
    procedure PopJobRequest(Data: Pointer; AThread: TThread);
    //加入到线程池中执行
    procedure PushJobRequest(AJobRequest: TJobRequest);

    function GetJob(AJobName: string): TJobConfig;
    function CheckJobTask(AJob: TJobConfig): Boolean;
    function GetDbsConfigFile: string;

    procedure StartJob(AJob: TJobConfig); overload;
    procedure StopJob(AJob: TJobConfig); overload;

  public
    CallerHandle: THandle;
    constructor Create(AJobsFileName: string; AThreadCount: Integer = 1; const ALogLevel: TLogLevel = llAll);
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure StartJob(AJobName: string); overload;
    procedure StopJob(AJobName: string); overload;

    function LoadConfigFrom(AJobsFileName: string): Boolean;

    property DbsConfigFile: string read GetDbsConfigFile;
  end;


implementation

uses uDefines, uFunctions, uTaskVar, Winapi.Windows, uFileUtil, System.DateUtils, uThreadSafeFile;

{ TJobConfig }

constructor TJobConfig.Create;
begin
  inherited;
  AllowedTimes := TStringList.Create;
  DisallowedTimes := TStringList.Create;
end;


destructor TJobConfig.Destroy;
begin
  AllowedTimes.Free;
  DisallowedTimes.Free;
  inherited;
end;


function TJobConfig.GetTaskConfigRec: TTaskCongfigRec;
begin
  if FTaskConfigRec.TaskName = '' then
  begin
    FTaskConfigRec := TTaskUtil.ReadConfigFrom(TaskFile);
  end;
  Result := FTaskConfigRec;
end;


function TJobConfig.GetTaskStepsStr: string;
begin
  if FTaskConfigRec.TaskName = '' then
  begin
    FTaskConfigRec := TTaskUtil.ReadConfigFrom(TaskFile);
  end;

  Result := FTaskConfigRec.StepsStr;
end;



procedure TJobConfig.ParseScheduleConfig(AScheduleJsonStr: string);
var
  LScheduleJson: TJSONObject;
begin
  LScheduleJson := TJSONObject.ParseJSONValue(AScheduleJsonStr) as TJSONObject;
  LastStartTime := 0;
  if LScheduleJson = nil then
  begin
    Interval := 3600;
    TimeOut := 7200;
  end
  else
  begin
    try
      Interval := GetJsonObjectValue(LScheduleJson, 'interval', '3600', 'int');
      TimeOut := GetJsonObjectValue(LScheduleJson, 'time_out', '7200', 'int');
      AllowedTimes.NameValueSeparator := '-';
      AllowedTimes.Text := GetJsonObjectValue(LScheduleJson, 'allowed_time');
      DisallowedTimes.NameValueSeparator := '-';
      DisallowedTimes.Text := GetJsonObjectValue(LScheduleJson, 'disallowed_time');
    finally
      LScheduleJson.Free;
    end;
  end;
end;


function TJobConfig.CheckSchedule: Boolean;
var
  LNow: TDateTime;
  LNowStr: string;

  function IsAllowed: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if AllowedTimes.Count = 0 then
    begin
      Result := True;
      Exit;
    end;

    for i := 0 to AllowedTimes.Count - 1 do
    begin
      if (LNowStr >= AllowedTimes.Names[i])
        and (LNowStr <= AllowedTimes.ValueFromIndex[i]) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  function IsDisallowed: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if DisallowedTimes.Count = 0 then
    begin
      Exit;
    end;

    for i := 0 to DisallowedTimes.Count - 1 do
    begin
      if (LNowStr >= DisallowedTimes.Names[i])
        and (LNowStr <= DisallowedTimes.ValueFromIndex[i]) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
begin
  Result := True;
  if Status = 0 then
  begin
    Result := False;
    Exit;
  end;

  LNow := Now;
  if SecondsBetween(LNow, LastStartTime) < Interval then
  begin
    AppLogger.Debug(JobName + '尚未到达执行时间:' + FormatDateTime('yyyy-mm-dd hh:nn:ss', LastStartTime));
    Result := False;
    Exit;
  end;

  LNowStr := FormatDateTime('hh:nn:ss', LNow);
  if not IsAllowed then
  begin
    AppLogger.Debug(JobName + '不在允许的执行时间');
    Result := False;
    Exit;
  end;

  if IsDisallowed then
  begin
    AppLogger.Debug(JobName + '时间段禁止执行');
    Result := False;
    Exit;
  end;
end;


function TJobConfig.IsTimeOut: Boolean;
begin
  Result := False;
  if TimeOut < 1  then Exit;

  if (LastStartTime = 0) or (Task = nil) then Exit; //未运行过或未运行，不进行检查

  if (SecondsBetween(Now, LastStartTime) >= TimeOut) and (Task <> nil) then
    Result := True;
end;


procedure TJobConfig.FreeTask;
begin
  if Task <> nil then
    FreeAndNil(Task);
  RunThread := nil;
  HandleStatus := jhsNone;
end;


{ TJobMgr }

constructor TJobMgr.Create(AJobsFileName: string; AThreadCount: Integer = 1; const ALogLevel: TLogLevel = llAll);
begin
  CallerHandle := 0;
  FLogLevel := ALogLevel;

  Critical := TCriticalSection.Create;
  FJobs := TStringList.Create;
  FUnHandledCount := 0;
  FThreadCount := AThreadCount;
  FThreadPool := TThreadPool.Create(PopJobRequest, FThreadCount);

  LoadConfigFrom(AJobsFileName);

  FGlobalVar := TGlobalVar.Create;
  FGlobalVar.LoadFromFile((FRunBasePath + 'project.global'));
end;

destructor TJobMgr.Destroy;
var
  i: Integer;
begin
  Stop;

  FThreadPool.Free;
 
  //循环遍历释放task中的配置类
  for i := 0 to FJobs.Count - 1 do
  begin
    if FJobs.Objects[i] <> nil then
      TJobConfig(FJobs.Objects[i]).Free;
  end;
  FreeAndNil(FJobs);
  FreeAndNil(FGlobalVar);
  FreeAndNil(Critical);
  inherited;
end;

function TJobMgr.GetDbsConfigFile: string;
begin
  Result := FRunBasePath + 'project.dbs';
end;


function TJobMgr.GetJob(AJobName: string): TJobConfig;
var
  i: Integer;
begin
  Result := nil;
  i := FJobs.IndexOf(AJobName);
  if i > -1 then
  begin
    Result := TJobConfig(FJobs.Objects[i]);
  end;
end;


//这个一但load完成，不允许再次变更配置，因此，建议本配置在本类创建时进行处理，不再运行中开放给外部
function TJobMgr.LoadConfigFrom(AJobsFileName: string): Boolean;
var
  LJobConfigs: TJSONArray;
  LJobConfigJson: TJSONObject;
  LJobConfig: TJobConfig;
  i: Integer;
begin
  Result := False;
  //如果直线的任务运行，需要进行释放停止，可以根据状态来处理，或者说根据待运行的线程任务来处理
  if FUnHandledCount > 0 then
  begin
    AppLogger.Error('工作文件加载失败：还有' + IntToStr(FUnHandledCount) + '个任务正在执行');
    Exit;
  end;

  //初始化FTasks
  if not FileExists(AJobsFileName) then Exit;

  LJobConfigs := TJSONObject.ParseJSONValue(TThreadSafeFile.ReadContentFrom(AJobsFileName, '[]')) as TJSONArray;

  FRunBasePath := ExtractFilePath(AJobsFileName);

  //清除Tjobconfig
  for i := 0 to FJobs.Count - 1 do
  begin
    TJobConfig(FJobs.Objects[i]).Free;
  end;
  FJobs.Clear;

  if LJobConfigs = nil then Exit;
  try
    for i := 0 to LJobConfigs.Count - 1 do
    begin
      LJobConfigJson := LJobConfigs.Items[i] as TJSONObject;
      if LJobConfigJson <> nil then
      begin
        LJobConfig := TJobConfig.Create;
        LJobConfig.JobName := GetJsonObjectValue(LJobConfigJson, 'job_name', '');
        LJobConfig.TaskFile := TFileUtil.GetAbsolutePathEx(
                                      FRunBasePath,
                                      GetJsonObjectValue(LJobConfigJson, 'task_file', ''));
        LJobConfig.Status := StrToIntDef(GetJsonObjectValue(LJobConfigJson, 'status', '0'), 0);
        LJobConfig.ParseScheduleConfig(GetJsonObjectValue(LJobConfigJson, 'schedule'));
        LJobConfig.HandleStatus := jhsNone;

        FJobs.AddObject(LJobConfig.JobName, LJobConfig);
      end
      else
      begin
        AppLogger.Error('TJobMgr.LoadConfigFrom解析任务失败');
      end;
    end;
    Result := True;
  finally
    LJobConfigs.Free;
  end;
end;


function TJobMgr.CheckJobTask(AJob: TJobConfig): Boolean;
begin
  Result := False;
  Critical.Enter;
  try
    if AJob = nil then
    begin
      AppLogger.Error('TJobMgr.FJobs中未匹配任务配置，线程退出');
    end
    else if AJob.Task <> nil then
    begin
      AppLogger.Error('TJobMgr中该任务正在执行，本次工作执行退出：' + AJob.JobName);
    end
    else
      Result := True;
  finally
    Critical.Leave;
  end;
end;


//这里必须线程安全，因为会存在若干的线程来操作同一段代码，要么都是局部变量
//要么是线程安全的变量
procedure TJobMgr.PopJobRequest(Data: Pointer; AThread: TThread);
var
  LRequest: PJobRequest;
  LJob: TJobConfig;
begin
  //很可能需要引入critical类
  LRequest := Data;
  LJob := GetJob(LRequest.JobName);

  if not CheckJobTask(LJob) then
  begin
    if LJob.Task = nil then
    begin
      LJob.HandleStatus := jhsNone;
    end;
    Exit;
  end;

  //重新生成task，执行
  LJob.Task := TTask.Create(LRequest.TaskConfig);
  try
    LJob.HandleStatus := jhsRun;
    LJob.Task.TaskVar.GlobalVar := FGlobalVar;
    LJob.Task.TaskVar.Logger.LogLevel := FLogLevel;
    {$IFDEF PROJECT_DESIGN_MODE}
    LJob.Task.TaskVar.Logger.NoticeHandle := CallerHandle;
    {$ENDIF}
    try
      LJob.Task.TaskConfigRec := LRequest.TaskConfig;
      LJob.LastStartTime := Now;
      LJob.RunThread := AThread;
      LJob.JobRequest := Data;

      LJob.Task.TaskVar.Logger.Force('任务开始'+ LRequest.JobName);
      AppLogger.Force('开始执行工作：' + LRequest.JobName);
      LJob.Task.Start;
      AppLogger.Force('结束执行工作：' + LRequest.JobName);
      LJob.Task.TaskVar.Logger.Force('任务结束'+ LRequest.JobName);
    except
      on E: Exception do
      begin
        LJob.LastStartTime := 0;
        AppLogger.Fatal('执行工作异常退出：' + LRequest.JobName + '，原因：' + E.Message);
      end;
    end;
  finally
    Dispose(LRequest);
    InterlockedDecrement(FUnHandledCount);
    LJob.FreeTask;
  end;
end;


procedure TJobMgr.PushJobRequest(AJobRequest: TJobRequest);
var
  LRequest: PJobRequest;
begin
  New(LRequest);
  LRequest^.JobName := AJobRequest.JobName;
  LRequest^.TaskConfig := AJobRequest.TaskConfig;
  FThreadPool.Add(LRequest);
  InterlockedIncrement(FUnHandledCount);
end;


procedure TJobMgr.Start;
var
  i: Integer;
  LJob: TJobConfig;
begin
  for i := 0 to FJobs.Count - 1 do
  begin
    LJob := TJobConfig(FJobs.Objects[i]);
    if LJob = nil then
    begin
      AppLogger.Error('TJobMgr.List中未找到对应的Job对象');
      Continue;
    end;

    //检查是否超时，如果超时呢？先尝试stop，然后等待？如果stop失败，证明整个Task已经异常了
    //这个时候可以尝试直接free掉这个task，必然引起这个线程内部的异常
    //如果是这个线程本身调度就死掉了呢？尝试terminate？
    //对于超时的任务，必须提前进行检查，从而提前终止掉这个任务，便于重新启动
    if LJob.IsTimeOut then
    try
      LJob.LastStartTime := 0;
      StopJob(LJob);

      //释放内存空间
//      Dispose(LJob.JobRequest);
//      InterlockedDecrement(FUnHandledCount);
//      LJob.FreeTask;
//      FThreadPool.EndThread(LJob.RunThread);

      AppLogger.Error('任务执行超时：' + Ljob.JobName);
    except

    end;

    if not LJob.CheckSchedule then
    begin
      Continue;
    end;

    StartJob(LJob);
  end;
end;


//PushToJobRequest的调用别名
procedure TJobMgr.StartJob(AJobName: string);
var
  LJob: TJobConfig;
begin
  LJob := GetJob(AJobName);
  if not CheckJobTask(LJob) then Exit;

  StartJob(LJob);
end;


procedure TJobMgr.StartJob(AJob: TJobConfig);
var
  LRequest: TJobRequest;
begin
  if not CheckJobTask(AJob) then Exit;
  if AJob.HandleStatus = jhsNone then
  begin


    LRequest.JobName := AJob.JobName;
    LRequest.TaskConfig := AJob.TaskConfigRec;
    LRequest.TaskConfig.RunBasePath := FRunBasePath;
    LRequest.TaskConfig.DBsConfigFile := DbsConfigFile;

    PushJobRequest(LRequest);
    AJob.HandleStatus := jhsWaited;
  end;
end;


procedure TJobMgr.Stop;
var
  i: Integer;
begin
  for i := 0 to FJobs.Count - 1 do
  begin
    StopJob(TJobConfig(FJobs.Objects[i]));
  end;
end;



procedure TJobMgr.StopJob(AJob: TJobConfig);
begin
  try
    //因为task的释放和本设置是工作在不同的线程中，有可能在子线程中task已经释放
    //但主线程仍然在操作
    if (AJob <> nil) and (AJob.Task <> nil) then
    begin
      AJob.Task.TaskVar.TaskStatus := trsStop;
    end;
  finally

  end;
end;


procedure TJobMgr.StopJob(AJobName: string);
var
  LJob: TJobConfig;
begin
  LJob := GetJob(AJobName);
  StopJob(LJob);
end;

end.
