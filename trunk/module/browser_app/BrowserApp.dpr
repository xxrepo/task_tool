program BrowserApp;

uses
  Vcl.Forms,
  Winapi.Windows,
  System.SysUtils,
  System.SyncObjs,
  uCEFApplication,
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uFunctions in '..\..\common\uFunctions.pas',
  uSelectFolderForm in '..\..\common\uSelectFolderForm.pas' {SelectFolderForm},
  uRENDER_JsCallbackList in 'comm\uRENDER_JsCallbackList.pas',
  uRENDER_ProcessProxy in 'comm\uRENDER_ProcessProxy.pas',
  uBasicChromeForm in 'basic\uBasicChromeForm.pas' {BasicChromeForm},
  uBaseJsBinding in 'bindings\uBaseJsBinding.pas',
  uAppDefines in 'comm\uAppDefines.pas',
  uVVCefFunction in 'comm\uVVCefFunction.pas',
  uAppForm in 'forms\uAppForm.pas' {AppForm},
  uBROWSER_EventJsListnerList in 'comm\uBROWSER_EventJsListnerList.pas',
  uVVConstants in 'comm\uVVConstants.pas',
  uSerialPortBinding in 'bindings\uSerialPortBinding.pas',
  uBindingProxy in 'bindings\uBindingProxy.pas',
  uBROWSER_GlobalVar in 'comm\uBROWSER_GlobalVar.pas',
  uBaseJsObjectBinding in 'bindings\uBaseJsObjectBinding.pas',
  uJobDispatcher in '..\etl\comm\uJobDispatcher.pas',
  uDbConMgr in '..\etl\comm\uDbConMgr.pas',
  uDefines in '..\etl\comm\uDefines.pas',
  uExceptions in '..\etl\comm\uExceptions.pas',
  uGlobalVar in '..\etl\comm\uGlobalVar.pas',
  uJob in '..\etl\comm\uJob.pas',
  uJobStarter in '..\etl\comm\uJobStarter.pas',
  uStepCommon in '..\etl\comm\uStepCommon.pas',
  uTask in '..\etl\comm\uTask.pas',
  uTaskDefine in '..\etl\comm\uTaskDefine.pas',
  uTaskResult in '..\etl\comm\uTaskResult.pas',
  uTaskVar in '..\etl\comm\uTaskVar.pas',
  uThreadSafeFile in '..\etl\comm\uThreadSafeFile.pas',
  uStepFactory in '..\etl\steps\uStepFactory.pas',
  uStepDefines in '..\etl\steps\uStepDefines.pas',
  uStepBasic in '..\etl\basic\uStepBasic.pas',
  uStepExceptionCatch in '..\etl\steps\control\uStepExceptionCatch.pas',
  uStepCondition in '..\etl\steps\common\uStepCondition.pas',
  uStepSubTask in '..\etl\steps\common\uStepSubTask.pas',
  uStepTaskResult in '..\etl\steps\common\uStepTaskResult.pas',
  uStepVarDefine in '..\etl\steps\common\uStepVarDefine.pas',
  uStepDatasetSpliter in '..\etl\steps\data\uStepDatasetSpliter.pas',
  uStepFieldsMap in '..\etl\steps\data\uStepFieldsMap.pas',
  uStepFieldsOper in '..\etl\steps\data\uStepFieldsOper.pas',
  uStepJson2DataSet in '..\etl\steps\data\uStepJson2DataSet.pas',
  uStepJson2Table in '..\etl\steps\database\uStepJson2Table.pas',
  uStepQuery in '..\etl\steps\database\uStepQuery.pas',
  uStepSQL in '..\etl\steps\database\uStepSQL.pas',
  uStepFileDelete in '..\etl\steps\file\uStepFileDelete.pas',
  uStepFolderCtrl in '..\etl\steps\file\uStepFolderCtrl.pas',
  uStepIniRead in '..\etl\steps\file\uStepIniRead.pas',
  uStepIniWrite in '..\etl\steps\file\uStepIniWrite.pas',
  uStepTxtFileReader in '..\etl\steps\file\uStepTxtFileReader.pas',
  uStepTxtFileWriter in '..\etl\steps\file\uStepTxtFileWriter.pas',
  uStepUnzip in '..\etl\steps\file\uStepUnzip.pas',
  uStepDownloadFile in '..\etl\steps\network\uStepDownloadFile.pas',
  uStepHttpRequest in '..\etl\steps\network\uStepHttpRequest.pas',
  uStepFastReport in '..\etl\steps\report\uStepFastReport.pas',
  uStepReportMachine in '..\etl\steps\report\uStepReportMachine.pas',
  CVRDLL in '..\etl\steps\tools\CVRDLL.pas',
  uStepIdCardHS100UC in '..\etl\steps\tools\uStepIdCardHS100UC.pas',
  uStepExeCtrl in '..\etl\steps\util\uStepExeCtrl.pas',
  uStepServiceCtrl in '..\etl\steps\util\uStepServiceCtrl.pas',
  uStepWaitTime in '..\etl\steps\util\uStepWaitTime.pas',
  uAlertSound in '..\..\core\lib\uAlertSound.pas',
  uExeUtil in '..\..\core\lib\uExeUtil.pas',
  uFileCleaner in '..\..\core\lib\uFileCleaner.pas',
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uPYCode in '..\..\core\lib\uPYCode.pas',
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uXpFunctions in 'comm\uXpFunctions.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  ExePath := ExtractFilePath(Application.ExeName);
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\app\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;

  BROWSER_GlobalVar := TBROWSER_GlobalVar.Create;
  BROWSER_EventJsListnerList := TBROWSER_EventJsListnerList.Create;
  BROWSER_JobDispatcherMgr := TJobDispatcherList.Create;
  BROWSER_SerialPortMgr := TSerialPortMgr.Create;

  RENDER_JsCallbackList := TRENDER_JsCallbackList.Create;
  RENDER_RenderHelper := TRENDER_ProcessProxy.Create;


  GlobalCEFApp                  := TCefApplication.Create;
  GlobalCEFApp.OnContextCreated := RENDER_RenderHelper.OnContextCreated;
  GlobalCEFApp.OnContextReleased := RENDER_RenderHelper.OnContextReleased;
  GlobalCEFApp.OnProcessMessageReceived := RENDER_RenderHelper.OnProcessMessageReceived;
  GlobalCEFApp.SingleProcess := False;

  if GlobalCEFApp.StartMainProcess then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;

    Application.CreateForm(TAppForm, AppForm);
  AppForm.WindowState := wsMaximized;
    Application.Run;
  end;


  RENDER_RenderHelper.Free;
  RENDER_JsCallbackList.Free;

  BROWSER_SerialPortMgr.Free;
  BROWSER_JobDispatcherMgr.Free;
  BROWSER_EventJsListnerList.Free;
  BROWSER_GlobalVar.Free;

  FileCritical.Free;
  AppLogger.Free;

  GlobalCEFApp.Free;
end.
