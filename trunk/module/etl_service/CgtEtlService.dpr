program CgtEtlService;

uses
  Vcl.SvcMgr,
  uETlService in 'uETlService.pas' {CGTEtlSrv: TService},
  uFunctions in '..\..\common\uFunctions.pas',
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uStepBasic in '..\etl\basic\uStepBasic.pas',
  uDbConMgr in '..\etl\comm\uDbConMgr.pas',
  uDefines in '..\etl\comm\uDefines.pas',
  uExceptions in '..\etl\comm\uExceptions.pas',
  uJob in '..\etl\comm\uJob.pas',
  uTask in '..\etl\comm\uTask.pas',
  uTaskVar in '..\etl\comm\uTaskVar.pas',
  uStepCondition in '..\etl\steps\uStepCondition.pas',
  uStepDatasetSpliter in '..\etl\steps\uStepDatasetSpliter.pas',
  uStepDefines in '..\etl\steps\uStepDefines.pas',
  uStepFactory in '..\etl\steps\uStepFactory.pas',
  uStepHttpRequest in '..\etl\steps\uStepHttpRequest.pas',
  uStepIniWrite in '..\etl\steps\uStepIniWrite.pas',
  uStepQuery in '..\etl\steps\uStepQuery.pas',
  uStepSubTask in '..\etl\steps\uStepSubTask.pas',
  uStepIniRead in '..\etl\steps\uStepIniRead.pas',
  uStepFileDelete in '..\etl\steps\uStepFileDelete.pas',
  uStepWriteTxtFile in '..\etl\steps\uStepWriteTxtFile.pas',
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uThreadSafeFile in '..\etl\comm\uThreadSafeFile.pas',
  uGlobalVar in '..\etl\comm\uGlobalVar.pas',
  uStepFieldsOper in '..\etl\steps\uStepFieldsOper.pas',
  uStepFormSettings in '..\etl\steps\uStepFormSettings.pas',
  uStepJson2DataSet in '..\etl\steps\uStepJson2DataSet.pas',
  uTaskDefine in '..\etl\comm\uTaskDefine.pas',
  uHttpServerConfig in '..\etl\runners\uHttpServerConfig.pas',
  uHttpServerRunner in '..\etl\runners\uHttpServerRunner.pas',
  uJobStarter in '..\etl\comm\uJobStarter.pas',
  uJobDispatcher in '..\etl\comm\uJobDispatcher.pas',
  uScheduleConfig in '..\etl\runners\uScheduleConfig.pas',
  uScheduleRunner in '..\etl\runners\uScheduleRunner.pas',
  uStepTaskResult in '..\etl\steps\uStepTaskResult.pas',
  uTaskResult in '..\etl\comm\uTaskResult.pas',
  uStepVarDefine in '..\etl\steps\uStepVarDefine.pas',
  uUserNotify in '..\..\common\uUserNotify.pas',
  uUserNotifyMsgForm in '..\..\common\uUserNotifyMsgForm.pas' {UserNotifyMsgForm},
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uStepUiBasic in '..\etl\basic\uStepUiBasic.pas',
  uStepReportMachine in '..\etl\steps\report\uStepReportMachine.pas',
  uStepFastReport in '..\etl\steps\report\uStepFastReport.pas';

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TCGTEtlSrv, CGTEtlSrv);
  Application.CreateForm(TUserNotifyMsgForm, UserNotifyMsgForm);
  Application.CreateForm(TBasicForm, BasicForm);
  Application.Run;
end.
