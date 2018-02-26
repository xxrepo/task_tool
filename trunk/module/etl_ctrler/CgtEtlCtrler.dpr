program CgtEtlCtrler;

uses
  Vcl.Forms,
  MidasLib,
  System.SyncObjs,
  System.SysUtils,
  uFunctions in '..\..\common\uFunctions.pas',
  uSelectFolderForm in '..\..\common\uSelectFolderForm.pas' {SelectFolderForm},
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uBasicLogForm in '..\..\core\basic\uBasicLogForm.pas' {BasicLogForm},
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uCtrlMainForm in 'forms\uCtrlMainForm.pas' {CtrlMainForm},
  uStepBasic in '..\etl\basic\uStepBasic.pas',
  uHttpServerConfig in '..\etl\runners\uHttpServerConfig.pas',
  uHttpServerRunner in '..\etl\runners\uHttpServerRunner.pas',
  uHttpServerControlForm in '..\etl\ctrl_forms\uHttpServerControlForm.pas' {HttpServerControlForm},
  uDbConMgr in '..\etl\comm\uDbConMgr.pas',
  uDefines in '..\etl\comm\uDefines.pas',
  uExceptions in '..\etl\comm\uExceptions.pas',
  uGlobalVar in '..\etl\comm\uGlobalVar.pas',
  uJob in '..\etl\comm\uJob.pas',
  uJobDispatcher in '..\etl\comm\uJobDispatcher.pas',
  uJobStarter in '..\etl\comm\uJobStarter.pas',
  uTask in '..\etl\comm\uTask.pas',
  uTaskDefine in '..\etl\comm\uTaskDefine.pas',
  uTaskResult in '..\etl\comm\uTaskResult.pas',
  uTaskVar in '..\etl\comm\uTaskVar.pas',
  uThreadSafeFile in '..\etl\comm\uThreadSafeFile.pas',
  uStepCondition in '..\etl\steps\common\uStepCondition.pas',
  uStepDatasetSpliter in '..\etl\steps\data\uStepDatasetSpliter.pas',
  uStepDefines in '..\etl\steps\uStepDefines.pas',
  uStepFactory in '..\etl\steps\uStepFactory.pas',
  uStepFieldsOper in '..\etl\steps\data\uStepFieldsOper.pas',
  uStepFileDelete in '..\etl\steps\file\uStepFileDelete.pas',
  uStepHttpRequest in '..\etl\steps\network\uStepHttpRequest.pas',
  uStepIniRead in '..\etl\steps\file\uStepIniRead.pas',
  uStepIniWrite in '..\etl\steps\file\uStepIniWrite.pas',
  uStepJson2DataSet in '..\etl\steps\data\uStepJson2DataSet.pas',
  uStepQuery in '..\etl\steps\database\uStepQuery.pas',
  uStepTaskResult in '..\etl\steps\common\uStepTaskResult.pas',
  uStepVarDefine in '..\etl\steps\common\uStepVarDefine.pas',
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uDesignTimeDefines in '..\etl\comm\uDesignTimeDefines.pas',
  uProject in '..\etl\comm\uProject.pas',
  Vcl.Themes,
  Vcl.Styles,
  uUserNotify in '..\..\common\uUserNotify.pas',
  uUserNotifyMsgForm in '..\..\common\uUserNotifyMsgForm.pas' {UserNotifyMsgForm},
  uStepUiBasic in '..\etl\basic\uStepUiBasic.pas',
  uStepFastReport in '..\etl\steps\report\uStepFastReport.pas',
  uStepReportMachine in '..\etl\steps\report\uStepReportMachine.pas',
  uExeUtil in '..\..\core\lib\uExeUtil.pas',
  uStepSubTask in '..\etl\steps\common\uStepSubTask.pas',
  uStepDownloadFile in '..\etl\steps\network\uStepDownloadFile.pas',
  uStepUnzip in '..\etl\steps\file\uStepUnzip.pas',
  uStepWriteTxtFile in '..\etl\steps\file\uStepWriteTxtFile.pas',
  uStepExeCtrl in '..\etl\steps\util\uStepExeCtrl.pas',
  uStepServiceCtrl in '..\etl\steps\util\uStepServiceCtrl.pas',
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uStepFolderCtrl in '..\etl\steps\file\uStepFolderCtrl.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  ExePath := ExtractFilePath(Application.ExeName);
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\app\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;


  Application.Title := '采购通智能助手1.0';
  Application.CreateForm(TCtrlMainForm, CtrlMainForm);
  CtrlMainForm.Close;
  Application.Run;

  //全局单实例判断释放
  if HttpServerRunner <> nil then
  begin
    FreeAndNil(HttpServerRunner);
  end;
  FileCritical.Free;
  AppLogger.Free;
end.
