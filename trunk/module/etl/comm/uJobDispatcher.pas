unit uJobDispatcher;

interface

uses uJobMgr, uJob, uFileLogger;

type
  PJobDispatcherRec = ^TJobdispatcherRec;

  TJobDispatcherRec = record
    ProjectFile: string;
    JobName: string;
    InParams: string;
  end;

  //仅支持单线程模式，支持对结果的输出，支持入参，仅仅单实例支持启动一个任务
  TJobDispatcher = class(TJobMgr)
  private
    FInParams: string;
    FOutResult: string;
  protected
    procedure StartJob(AJob: TJobConfig); override;
  public
    constructor Create(const ALogLevel: TLogLevel = llAll); overload;

    procedure StartProjectJob(const AJobDispatcherRec: PJobDispatcherRec);
  end;

implementation

uses
  uTaskDefine, uDefines, uTask, System.SysUtils;

{ TJobDispatcher }

constructor TJobDispatcher.Create(const ALogLevel: TLogLevel);
begin
  inherited Create(0, ALogLevel);
end;
//
//
procedure TJobDispatcher.StartJob(AJob: TJobConfig);
var
  LTaskConfigRec: TTaskConfigRec;
begin
  if not CheckJobTask(AJob) then
  begin
    AppLogger.Debug('Pop Job 任务异常：' + AJob.JobName);
    Exit;
  end;

  //重新生成task，执行
  LTaskConfigRec := AJob.TaskConfigRec;
  LTaskConfigRec.RunBasePath := FRunBasePath;
  LTaskConfigRec.DBsConfigFile := DbsConfigFile;
  AJob.Task := TTask.Create(LTaskConfigRec);
  try
    AJob.HandleStatus := jhsRun;
    AJob.Task.TaskVar.GlobalVar := FGlobalVar;
    AJob.Task.TaskVar.Logger.LogLevel := FLogLevel;
    AJob.Task.TaskVar.Logger.NoticeHandle := CallerHandle;
    try
      AJob.LastStartTime := Now;
      AJob.RunThread := nil;
      AJob.JobRequest := nil;

      AJob.Task.TaskVar.Logger.Force('任务开始'+ AJob.JobName);
      AppLogger.Force('开始执行工作：' + AJob.JobName);
      AJob.Task.Start;
      AppLogger.Force('结束执行工作：' + AJob.JobName);
      AJob.Task.TaskVar.Logger.Force('任务结束'+ AJob.JobName);
    except
      on E: Exception do
      begin
        AJob.LastStartTime := 0;
        AppLogger.Fatal('执行工作异常退出：' + AJob.JobName + '，原因：' + E.Message);
      end;
    end;
  finally
    AJob.FreeTask;
  end;
end;



procedure TJobDispatcher.StartProjectJob(const AJobDispatcherRec: PJobDispatcherRec);
begin
  //在这里进行释放
  try
    if LoadConfigFrom(AJobDispatcherRec.ProjectFile, AJobDispatcherRec.JobName) then
    begin
      StartJob(AJobDispatcherRec.JobName);
    end
    else
    begin
      AppLogger.Fatal('加载Project文件失败');
      Exit;
    end;
  finally
    if AJobDispatcherRec <> nil then
      Dispose(AJobDispatcherRec);
  end;
end;

end.
