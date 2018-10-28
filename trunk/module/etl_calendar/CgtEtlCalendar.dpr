program CgtEtlCalendar;

uses
  Vcl.Forms,
  System.SysUtils,
  System.SyncObjs,
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uBasicLogForm in '..\..\core\basic\uBasicLogForm.pas' {BasicLogForm},
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uDbConMgr in '..\etl\comm\uDbConMgr.pas',
  uExceptions in '..\etl\comm\uExceptions.pas',
  uJob in '..\etl\comm\uJob.pas',
  uJobDispatcher in '..\etl\comm\uJobDispatcher.pas',
  uJobStarter in '..\etl\comm\uJobStarter.pas',
  uStepCommon in '..\etl\comm\uStepCommon.pas',
  uTask in '..\etl\comm\uTask.pas',
  uTaskDefine in '..\etl\comm\uTaskDefine.pas',
  uTaskResult in '..\etl\comm\uTaskResult.pas',
  uTaskVar in '..\etl\comm\uTaskVar.pas',
  uThreadSafeFile in '..\etl\comm\uThreadSafeFile.pas',
  uDefines in '..\etl\comm\uDefines.pas',
  uFunctions in '..\..\common\uFunctions.pas',
  uStepDefines in '..\etl\steps\uStepDefines.pas',
  uStepFactory in '..\etl\steps\uStepFactory.pas',
  uStepCondition in '..\etl\steps\common\uStepCondition.pas',
  uStepSubTask in '..\etl\steps\common\uStepSubTask.pas',
  uStepTaskResult in '..\etl\steps\common\uStepTaskResult.pas',
  uStepVarDefine in '..\etl\steps\common\uStepVarDefine.pas',
  uStepBasic in '..\etl\basic\uStepBasic.pas',
  uStepExceptionCatch in '..\etl\steps\control\uStepExceptionCatch.pas',
  uStepDatasetSpliter in '..\etl\steps\data\uStepDatasetSpliter.pas',
  uStepFieldsMap in '..\etl\steps\data\uStepFieldsMap.pas',
  uStepFieldsOper in '..\etl\steps\data\uStepFieldsOper.pas',
  uStepJson2DataSet in '..\etl\steps\data\uStepJson2DataSet.pas',
  uGlobalVar in '..\etl\comm\uGlobalVar.pas',
  uStepDownloadFile in '..\etl\steps\network\uStepDownloadFile.pas',
  uStepHttpRequest in '..\etl\steps\network\uStepHttpRequest.pas',
  uStepFileDelete in '..\etl\steps\file\uStepFileDelete.pas',
  uStepFolderCtrl in '..\etl\steps\file\uStepFolderCtrl.pas',
  uStepIniRead in '..\etl\steps\file\uStepIniRead.pas',
  uStepIniWrite in '..\etl\steps\file\uStepIniWrite.pas',
  uStepTxtFileReader in '..\etl\steps\file\uStepTxtFileReader.pas',
  uStepTxtFileWriter in '..\etl\steps\file\uStepTxtFileWriter.pas',
  uStepUnzip in '..\etl\steps\file\uStepUnzip.pas',
  uStepFastReport in '..\etl\steps\report\uStepFastReport.pas',
  uStepReportMachine in '..\etl\steps\report\uStepReportMachine.pas',
  uStepExeCtrl in '..\etl\steps\util\uStepExeCtrl.pas',
  uStepServiceCtrl in '..\etl\steps\util\uStepServiceCtrl.pas',
  uStepWaitTime in '..\etl\steps\util\uStepWaitTime.pas',
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uStepJson2Table in '..\etl\steps\database\uStepJson2Table.pas',
  uStepQuery in '..\etl\steps\database\uStepQuery.pas',
  uStepSQL in '..\etl\steps\database\uStepSQL.pas',
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uCalendarJobForm in 'forms\uCalendarJobForm.pas' {CalendarJobForm},
  uSettingForm in 'forms\uSettingForm.pas' {SettingForm},
  uCalendarJobConfig in 'comm\uCalendarJobConfig.pas',
  uDatabaseConnectTestForm in '..\etl\forms\uDatabaseConnectTestForm.pas' {DatabaseConnectTestForm},
  uDatabasesForm in '..\etl\forms\uDatabasesForm.pas' {DatabasesForm},
  uGlobalVarSettingForm in '..\etl\forms\uGlobalVarSettingForm.pas' {GlobalVarSettingForm},
  uAppDefine in 'comm\uAppDefine.pas',
  uDesignTimeDefines in '..\etl\comm\uDesignTimeDefines.pas',
  uProject in '..\etl\comm\uProject.pas',
  uSelectFolderForm in '..\..\common\uSelectFolderForm.pas' {SelectFolderForm},
  CVRDLL in '..\etl\steps\tools\CVRDLL.pas',
  uStepIdCardHS100UC in '..\etl\steps\tools\uStepIdCardHS100UC.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := False;

  //运行程序启动对应的task
  ExePath := ExtractFilePath(ParamStr(0));
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\once\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;

  Application.CreateForm(TCalendarJobForm, CalendarJobForm);
  Application.CreateForm(TDatabaseConnectTestForm, DatabaseConnectTestForm);
  Application.CreateForm(TDatabasesForm, DatabasesForm);
  Application.CreateForm(TGlobalVarSettingForm, GlobalVarSettingForm);
  Application.CreateForm(TSelectFolderForm, SelectFolderForm);
  CalendarJobForm.WindowState := wsMaximized;

  Application.Run;

  FileCritical.Free;
  AppLogger.Free;
end.
