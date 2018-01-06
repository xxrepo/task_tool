program CgtEtlService;

uses
  Vcl.SvcMgr,
  uETlService in '..\module\etl_service\uETlService.pas' {CGTEtlSrv: TService},
  uFunctions in '..\common\uFunctions.pas',
  uFileLogger in '..\core\lib\uFileLogger.pas',
  uThreadQueueUtil in '..\core\lib\uThreadQueueUtil.pas',
  uFileUtil in '..\core\lib\uFileUtil.pas',
  uNetUtil in '..\core\lib\uNetUtil.pas',
  uServiceUtil in '..\core\lib\uServiceUtil.pas',
  uStepBasic in '..\module\etl\basic\uStepBasic.pas',
  uDbConMgr in '..\module\etl\comm\uDbConMgr.pas',
  uDefines in '..\module\etl\comm\uDefines.pas',
  uExceptions in '..\module\etl\comm\uExceptions.pas',
  uJob in '..\module\etl\comm\uJob.pas',
  uServiceRunner in '..\module\etl_service\uServiceRunner.pas',
  uTask in '..\module\etl\comm\uTask.pas',
  uTaskVar in '..\module\etl\comm\uTaskVar.pas',
  uStepCondition in '..\module\etl\steps\uStepCondition.pas',
  uStepDatasetSpliter in '..\module\etl\steps\uStepDatasetSpliter.pas',
  uStepDefines in '..\module\etl\steps\uStepDefines.pas',
  uStepFactory in '..\module\etl\steps\uStepFactory.pas',
  uStepFieldsOper in '..\module\etl\steps\uStepFieldsOper.pas',
  uStepHttpRequest in '..\module\etl\steps\uStepHttpRequest.pas',
  uStepIniWrite in '..\module\etl\steps\uStepIniWrite.pas',
  uStepQuery in '..\module\etl\steps\uStepQuery.pas',
  uStepSubTask in '..\module\etl\steps\uStepSubTask.pas',
  uServiceConfig in '..\module\etl_service\uServiceConfig.pas',
  uStepIniRead in '..\module\etl\steps\uStepIniRead.pas',
  uStepVarDefine in '..\module\etl\steps\uStepVarDefine.pas',
  uStepFileDelete in '..\module\etl\steps\uStepFileDelete.pas',
  uStepWriteTxtFile in '..\module\etl\steps\uStepWriteTxtFile.pas',
  uFileFinder in '..\core\lib\uFileFinder.pas',
  uThreadSafeFile in '..\module\etl\comm\uThreadSafeFile.pas',
  uGlobalVar in '..\module\etl\comm\uGlobalVar.pas';

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
