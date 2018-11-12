program CgtEtlService;

uses
  Vcl.SvcMgr,
  MidasLib,
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
  uStepDatasetSpliter in '..\etl\steps\data\uStepDatasetSpliter.pas',
  uStepDefines in '..\etl\steps\uStepDefines.pas',
  uStepFactory in '..\etl\steps\uStepFactory.pas',
  uStepHttpRequest in '..\etl\steps\network\uStepHttpRequest.pas',
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uThreadSafeFile in '..\etl\comm\uThreadSafeFile.pas',
  uGlobalVar in '..\etl\comm\uGlobalVar.pas',
  uStepFieldsMap in '..\etl\steps\data\uStepFieldsMap.pas',
  uStepFormSettings in '..\etl\steps\uStepFormSettings.pas',
  uStepJson2DataSet in '..\etl\steps\data\uStepJson2DataSet.pas',
  uTaskDefine in '..\etl\comm\uTaskDefine.pas',
  uHttpServerConfig in '..\etl\runners\uHttpServerConfig.pas',
  uHttpServerRunner in '..\etl\runners\uHttpServerRunner.pas',
  uJobStarter in '..\etl\comm\uJobStarter.pas',
  uJobDispatcher in '..\etl\comm\uJobDispatcher.pas',
  uScheduleConfig in '..\etl\runners\uScheduleConfig.pas',
  uScheduleRunner in '..\etl\runners\uScheduleRunner.pas',
  uTaskResult in '..\etl\comm\uTaskResult.pas',
  uUserNotify in '..\..\common\uUserNotify.pas',
  uUserNotifyMsgForm in '..\..\common\uUserNotifyMsgForm.pas' {UserNotifyMsgForm},
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uStepUiBasicExt in '..\etl\basic\uStepUiBasicExt.pas',
  uStepReportMachine in '..\etl\steps\report\uStepReportMachine.pas',
  uStepFastReport in '..\etl\steps\report\uStepFastReport.pas',
  uStepDownloadFile in '..\etl\steps\network\uStepDownloadFile.pas',
  uStepSubTask in '..\etl\steps\common\uStepSubTask.pas',
  uStepTaskResult in '..\etl\steps\common\uStepTaskResult.pas',
  uStepVarDefine in '..\etl\steps\common\uStepVarDefine.pas',
  uStepFileDelete in '..\etl\steps\file\uStepFileDelete.pas',
  uStepFolderCtrl in '..\etl\steps\file\uStepFolderCtrl.pas',
  uStepIniRead in '..\etl\steps\file\uStepIniRead.pas',
  uStepIniWrite in '..\etl\steps\file\uStepIniWrite.pas',
  uStepUnzip in '..\etl\steps\file\uStepUnzip.pas',
  uStepWaitTime in '..\etl\steps\util\uStepWaitTime.pas',
  uStepExeCtrl in '..\etl\steps\util\uStepExeCtrl.pas',
  uStepServiceCtrl in '..\etl\steps\util\uStepServiceCtrl.pas',
  uStepCondition in '..\etl\steps\common\uStepCondition.pas',
  uStepExceptionCatch in '..\etl\steps\control\uStepExceptionCatch.pas',
  uStepTxtFileReader in '..\etl\steps\file\uStepTxtFileReader.pas',
  uStepTxtFileWriter in '..\etl\steps\file\uStepTxtFileWriter.pas',
  uStepFieldsOper in '..\etl\steps\data\uStepFieldsOper.pas',
  uStepJson2Table in '..\etl\steps\database\uStepJson2Table.pas',
  uStepSQL in '..\etl\steps\database\uStepSQL.pas',
  uStepQuery in '..\etl\steps\database\uStepQuery.pas',
  CVRDLL in '..\etl\steps\tools\CVRDLL.pas',
  uStepIdCardHS100UC in '..\etl\steps\tools\uStepIdCardHS100UC.pas';

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
  Application.Run;
end.
