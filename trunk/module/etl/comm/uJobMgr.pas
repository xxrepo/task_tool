unit uJobMgr;

interface

uses
  uJob, System.SysUtils, System.SyncObjs, uThreadQueueUtil, System.Classes, uFileLogger,
  uGlobalVar, uStepDefines;

type
  //本类用于实际运行时对任务的处理和管理
  TJobMgr = class
  private
    FJobs: TStringList;


    FThreadPool: TThreadPool;
    FThreadCount: Integer;



    FUnHandledCount: Integer;



    function GetDbsConfigFile: string;
    procedure HandleJobRequest(Data: Pointer; AThread: TThread); virtual;

  protected
    FLogLevel: TLogLevel;
    FRunBasePath: string;
    FGlobalVar: TGlobalVar;
    FCritical: TCriticalSection;

    function GetJob(AJobName: string): TJobConfig;
    function CheckJobTask(AJob: TJobConfig): Boolean;
    procedure StartJob(AJob: TJobConfig); overload; virtual;
    procedure StopJob(AJob: TJobConfig); overload;

    function GetTaskInitParams: PStepData; virtual;
  public
    LogNoticeHandle: THandle;
    constructor Create(AThreadCount: Integer = 1; const ALogLevel: TLogLevel = llAll); virtual;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure StartJob(AJobName: string); overload;
    procedure StopJob(AJobName: string); overload;

    function LoadConfigFrom(AJobsFileName: string; AJobName: string = ''): Boolean;

    property DbsConfigFile: string read GetDbsConfigFile;
  end;

implementation

uses System.JSON, uThreadSafeFile, uFunctions, uDefines, uTaskDefine, uFileUtil, uTask, Winapi.Windows;

{ TJobMgr }

constructor TJobMgr.Create(AThreadCount: Integer = 1; const ALogLevel: TLogLevel = llAll);
begin
  LogNoticeHandle := 0;
  FLogLevel := ALogLevel;

  FCritical := TCriticalSection.Create;
  FJobs := TStringList.Create;
  FUnHandledCount := 0;
  FThreadCount := AThreadCount;
  if FThreadCount > 0 then
    FThreadPool := TThreadPool.Create(HandleJobRequest, FThreadCount);
end;


destructor TJobMgr.Destroy;
var
  i: Integer;
begin
  Stop;

  if FThreadPool <> nil then
    FreeAndNil(FThreadPool);

  //循环遍历释放task中的配置类
  for i := 0 to FJobs.Count - 1 do
  begin
    if FJobs.Objects[i] <> nil then
      TJobConfig(FJobs.Objects[i]).Free;
  end;
  FreeAndNil(FJobs);

  if FGlobalVar <> nil then
    FreeAndNil(FGlobalVar);

  FreeAndNil(FCritical);
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


function TJobMgr.GetTaskInitParams: PStepData;
begin
  Result := nil;
end;

//这个一但load完成，不允许再次变更配置，因此，建议本配置在本类创建时进行处理，不再运行中开放给外部
function TJobMgr.LoadConfigFrom(AJobsFileName: string; AJobName: string = ''): Boolean;
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

  if FGlobalVar <> nil then
    FreeAndNil(FGlobalVar);
  FGlobalVar := TGlobalVar.Create;
  FGlobalVar.LoadFromFile((FRunBasePath + 'project.global'));

  if LJobConfigs = nil then Exit;
  try
    for i := 0 to LJobConfigs.Count - 1 do
    begin
      LJobConfigJson := LJobConfigs.Items[i] as TJSONObject;
      if LJobConfigJson <> nil then
      begin
        if (AJobName = '') or (AJobName = GetJsonObjectValue(LJobConfigJson, 'job_name', '')) then
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
        end;
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
  FCritical.Enter;
  try
    if AJob = nil then
    begin
      AppLogger.Error('TJobMgr.FJobs中未匹配任务配置，线程退出');
    end
    else if AJob.Task <> nil then
    begin
      AppLogger.Error('TJobMgr中该任务正在执行，本次工作执行退出：' + AJob.ToString);
    end
    else
      Result := True;
  finally
    FCritical.Leave;
  end;
end;


//这里必须线程安全，因为会存在若干的线程来操作同一段代码，要么都是局部变量
//要么是线程安全的变量
procedure TJobMgr.HandleJobRequest(Data: Pointer; AThread: TThread);
var
  LRequest: PJobRequest;
  LJob: TJobConfig;
begin
  //很可能需要引入critical类
  LRequest := Data;
  LJob := GetJob(LRequest.JobName);

  if not CheckJobTask(LJob) then
  begin
    AppLogger.Error('Pop Job 任务异常：' + LRequest.JobName);
    Dispose(LRequest);
    InterlockedDecrement(FUnHandledCount);
    if LJob <> nil then
    begin
      LJob.FreeTask;
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
    LJob.Task.TaskVar.Logger.NoticeHandle := LogNoticeHandle;
    {$ENDIF}
    try
      LJob.LastStartTime := Now;
      LJob.RunThread := AThread;
      LJob.JobRequest := Data;

      LJob.Task.TaskVar.Logger.Force('任务开始'+ LRequest.JobName);
      AppLogger.Force('开始执行工作：' + LRequest.JobName);
      LJob.Task.Start(GetTaskInitParams);
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
    //AppLogger.Debug('[GetJob][' + IntToStr(i) + ']' + LJob.ToString);

    //检查是否超时，如果超时呢？先尝试stop，然后等待？如果stop失败，证明整个Task已经异常了
    //这个时候可以尝试直接free掉这个task，必然引起这个线程内部的异常
    //如果是这个线程本身调度就死掉了呢？尝试terminate？
    //对于超时的任务，必须提前进行检查，从而提前终止掉这个任务，便于重新启动
    if LJob.IsTimeOut then
    try
      //这里需要区分任务是继续执行中，还是已经完全处于没有响应的状态
      LJob.LastStartTime := 0;
      StopJob(LJob);

      //释放内存空间
//      Dispose(LJob.JobRequest);
//      InterlockedDecrement(FUnHandledCount);
//      LJob.FreeTask;
//      FThreadPool.EndThread(LJob.RunThread);

      AppLogger.Error('任务执行超时：' + Ljob.JobName);
    except
      on E: Exception do
        AppLogger.Error('TimeOutCheck Failed：' + Ljob.JobName + '： ' + E.Message);
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
  StartJob(LJob);
end;


procedure TJobMgr.StartJob(AJob: TJobConfig);
var
  LRequest: PJobRequest;
begin
  if not CheckJobTask(AJob) then
  begin
    AppLogger.Error('[CheckJobTask Failed]');
    Exit;
  end;

  if AJob.HandleStatus = jhsNone then
  begin
    AJob.HandleStatus := jhsWaited;
    InterlockedIncrement(FUnHandledCount);
    New(LRequest);
    LRequest^.JobName := AJob.JobName;
    LRequest^.TaskConfig := AJob.TaskConfigRec;
    LRequest^.TaskConfig.RunBasePath := FRunBasePath;
    LRequest^.TaskConfig.DBsConfigFile := DbsConfigFile;

    AppLogger.Debug('[StartJob]' + AJob.ToString);

    if FThreadPool <> nil then
    begin
      FThreadPool.Add(LRequest);
    end
    else
      HandleJobRequest(LRequest, nil);
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
