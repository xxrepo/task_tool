unit uJobDispatcher;

interface

uses uJobMgr, uJob, uFileLogger, System.Classes, uStepDefines;

type
  PJobDispatcherRec = ^TJobdispatcherRec;

  TJobDispatcherRec = record
    ProjectFile: string;
    JobName: string;
    InParams: string;

    LogLevel: TLogLevel;
    LogNoticeHandle: THandle;
  end;

  TOutResult = record
    Code: Integer;
    Msg: string;
    Data: string;
  end;


  //仅支持单线程模式，支持对结果的输出，支持入参，仅仅单实例支持启动一个任务
  TJobDispatcher = class(TJobMgr)
  private
    FInParams: string;
    FOutResult: TOutResult;

    procedure StartJobSync(AJobName: string);

  protected
    function GetTaskInitParams: PStepData; override;
  public
    constructor Create(AThreadCount: Integer = 0; const ALogLevel: TLogLevel = llAll); override;

    procedure StartProjectJob(const AJobDispatcherRec: PJobDispatcherRec; const ASync: Boolean = True);

    property OutResult: TOutResult read FOutResult;
  end;

implementation

uses
  uTaskDefine, uDefines, uTask, System.SysUtils, Winapi.Windows;

{ TJobDispatcher }

constructor TJobDispatcher.Create(AThreadCount: Integer = 0; const ALogLevel: TLogLevel = llAll);
begin
  inherited Create(AThreadCount, ALogLevel);
  FOutResult.Code := -1;
  FOutResult.Msg := '处理失败';
end;


function TJobDispatcher.GetTaskInitParams: PStepData;
begin
  FCritical.Enter;
  try
    New(Result);
    Result^.DataType := sdtText;
    Result^.Data := FInParams;
  finally
    FCritical.Leave;
  end;
end;


procedure TJobDispatcher.StartJobSync(AJobName: string);
var
  LTaskConfigRec: TTaskConfigRec;
  LJob: TJobConfig;
begin
  LJob := GetJob(AJobName);
  if not CheckJobTask(LJob) then
  begin
    AppLogger.Debug('Pop Job 任务异常');
    Exit;
  end;

  InterlockedIncrement(FUnHandledCount);

  //重新生成task，执行
  LTaskConfigRec := LJob.TaskConfigRec;
  LTaskConfigRec.RunBasePath := FRunBasePath;
  LTaskConfigRec.DBsConfigFile := DbsConfigFile;

  LJob.Task := TTask.Create(LTaskConfigRec);
  try
    LJob.HandleStatus := jhsRun;
    LJob.LastStartTime := Now;
    LJob.RunThread := nil;
    LJob.JobRequest := nil;
    LJob.Task.TaskVar.GlobalVar := FGlobalVar;
    LJob.Task.TaskVar.SetUserNotifier(FUserNotifier);
    LJob.Task.TaskVar.Logger.LogLevel := FLogLevel;
    LJob.Task.TaskVar.Logger.NoticeHandle := LogNoticeHandle;

    try
      AppLogger.Force('开始执行工作：' + LJob.JobName);

      LJob.Task.TaskVar.Logger.Force('任务开始'+ LJob.JobName);
      LJob.Task.Start(GetTaskInitParams);

      //从Task获取执行结果
      if LJob.Task <> nil then
      begin
        FOutResult.Code := LJob.Task.TaskVar.TaskResult.Code;
        FOutResult.Msg := LJob.Task.TaskVar.TaskResult.Msg;
        FOutResult.Data := LJob.Task.TaskVar.TaskResult.DataStr;
        LJob.Task.TaskVar.Logger.Force('任务结束'+ LJob.JobName);
      end;

      AppLogger.Force('结束执行工作：' + LJob.JobName);
    except
      on E: Exception do
      begin
        FOutResult.Msg := '执行工作异常退出：' + LJob.JobName + '，原因：' + E.Message;

        LJob.LastStartTime := 0;
        AppLogger.Fatal(FOutResult.Msg);
      end;
    end;
  finally
    InterlockedDecrement(FUnHandledCount);
    if LJob <> nil then
      LJob.FreeTask;
  end;
end;



procedure TJobDispatcher.StartProjectJob(const AJobDispatcherRec: PJobDispatcherRec; const ASync: Boolean = True);
begin
  //在这里进行释放
  try
    if LoadConfigFrom(AJobDispatcherRec.ProjectFile, AJobDispatcherRec.JobName) then
    begin
      FInParams := AJobDispatcherRec.InParams;
      FLogLevel := AJobDispatcherRec.LogLevel;
      LogNoticeHandle := AJobDispatcherRec.LogNoticeHandle;

      if ASync then
      begin
        StartJobSync(AJobDispatcherRec.JobName);
      end
      else
        StartJob(AJobDispatcherRec.JobName);
    end
    else
    begin
      FOutResult.Msg := '加载Project文件失败：' + AJobDispatcherRec.ProjectFile
                        + '; Job: ' + AJobDispatcherRec.JobName
                        + '; InParams: ' + AJobDispatcherRec.InParams;
      AppLogger.Fatal(FOutResult.Msg);
    end;
  finally
    if AJobDispatcherRec <> nil then
      Dispose(AJobDispatcherRec);
  end;
end;

end.
