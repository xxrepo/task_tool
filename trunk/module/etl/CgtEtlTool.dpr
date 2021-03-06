program CgtEtlTool;

uses
  Vcl.Forms,
  MidasLib,
  System.SysUtils,
  Vcl.Controls,
  System.SyncObjs,
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uFunctions in '..\..\common\uFunctions.pas',
  uDefines in 'comm\uDefines.pas',
  uTaskEditForm in 'forms\uTaskEditForm.pas' {TaskEditForm},
  uAlertSound in '..\..\core\lib\uAlertSound.pas',
  uStepTypeSelectForm in 'forms\uStepTypeSelectForm.pas' {StepTypeSelectForm},
  uStepBasicForm in 'basic\uStepBasicForm.pas' {StepBasicForm},
  uDatabasesForm in 'forms\uDatabasesForm.pas' {DatabasesForm},
  uDatabaseConnectTestForm in 'forms\uDatabaseConnectTestForm.pas' {DatabaseConnectTestForm},
  uDbConMgr in 'comm\uDbConMgr.pas',
  uStepBasic in 'basic\uStepBasic.pas',
  uTaskVar in 'comm\uTaskVar.pas',
  uTask in 'comm\uTask.pas',
  uExceptions in 'comm\uExceptions.pas',
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uJob in 'comm\uJob.pas',
  uJobsMgrForm in 'forms\uJobsMgrForm.pas' {JobsForm},
  uSettingForm in 'forms\uSettingForm.pas' {SettingsForm},
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uProjectForm in 'forms\uProjectForm.pas' {ProjectForm},
  uProject in 'comm\uProject.pas',
  uDesignTimeDefines in 'comm\uDesignTimeDefines.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uStepExceptionCatch in 'steps\control\uStepExceptionCatch.pas',
  uStepExceptionCatchForm in 'steps\control\uStepExceptionCatchForm.pas' {StepExceptionCatchForm},
  uStepDatasetSpliter in 'steps\data\uStepDatasetSpliter.pas',
  uStepDefines in 'steps\uStepDefines.pas',
  uStepFormFactory in 'steps\uStepFormFactory.pas',
  uStepHttpRequest in 'steps\network\uStepHttpRequest.pas',
  uStepDownloadFileForm in 'steps\network\uStepDownloadFileForm.pas' {StepDownloadFileForm},
  uStepTaskResult in 'steps\common\uStepTaskResult.pas',
  uStepTaskResultForm in 'steps\common\uStepTaskResultForm.pas' {StepTaskResultForm},
  uStepIniWrite in 'steps\file\uStepIniWrite.pas',
  uStepIniWriteForm in 'steps\file\uStepIniWriteForm.pas' {StepIniWriteForm},
  uStepNullForm in 'steps\common\uStepNullForm.pas' {StepNullForm},
  uStepJson2Table in 'steps\database\uStepJson2Table.pas',
  uStepJson2TableForm in 'steps\database\uStepJson2TableForm.pas' {StepJson2TableForm},
  uStepUnzip in 'steps\file\uStepUnzip.pas',
  uStepUnzipForm in 'steps\file\uStepUnzipForm.pas' {StepUnzipForm},
  uStepFileDelete in 'steps\file\uStepFileDelete.pas',
  uStepFileDeleteForm in 'steps\file\uStepFileDeleteForm.pas' {StepFileDeleteForm},
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uJobScheduleForm in 'forms\uJobScheduleForm.pas' {JobScheduleForm},
  uStepFactory in 'steps\uStepFactory.pas',
  uEnterForm in 'forms\uEnterForm.pas' {EnterForm},
  uServiceControlForm in 'ctrl_forms\uServiceControlForm.pas' {ServiceControlForm},
  uStepIniRead in 'steps\file\uStepIniRead.pas',
  uStepIniReadForm in 'steps\file\uStepIniReadForm.pas' {StepIniReadForm},
  uMakeDirForm in 'forms\uMakeDirForm.pas' {MakeDirForm},
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uFileCleaner in '..\..\core\lib\uFileCleaner.pas',
  uStepDatasetSpliterForm in 'steps\data\uStepDatasetSpliterForm.pas' {StepDatasetSpliterForm},
  uThreadSafeFile in 'comm\uThreadSafeFile.pas',
  uScheduleConfig in 'runners\uScheduleConfig.pas',
  uScheduleRunner in 'runners\uScheduleRunner.pas',
  uGlobalVar in 'comm\uGlobalVar.pas',
  uGlobalVarSettingForm in 'forms\uGlobalVarSettingForm.pas' {GlobalVarSettingForm},
  uStepFieldsMap in 'steps\data\uStepFieldsMap.pas',
  uStepFieldsMapForm in 'steps\data\uStepFieldsMapForm.pas' {StepFieldsMapForm},
  uStepReportMachine in 'steps\report\uStepReportMachine.pas',
  uStepReportMachineForm in 'steps\report\uStepReportMachineForm.pas' {StepReportMachineForm},
  uStepFormSettings in 'steps\uStepFormSettings.pas',
  uStepJson2DataSet in 'steps\data\uStepJson2DataSet.pas',
  uStepJson2DataSetForm in 'steps\data\uStepJson2DataSetForm.pas' {StepJsonDataSetForm},
  uDBQueryResultForm in 'steps\database\uDBQueryResultForm.pas' {DBQueryResultForm},
  uBasicLogForm in '..\..\core\basic\uBasicLogForm.pas' {BasicLogForm},
  uTaskDefine in 'comm\uTaskDefine.pas',
  uTaskStepSourceForm in 'forms\uTaskStepSourceForm.pas' {TaskStepSourceForm},
  uHttpServerControlForm in 'ctrl_forms\uHttpServerControlForm.pas' {HttpServerControlForm},
  uHttpServerRunner in 'runners\uHttpServerRunner.pas',
  uHttpServerConfig in 'runners\uHttpServerConfig.pas',
  uSelectFolderForm in '..\..\common\uSelectFolderForm.pas' {SelectFolderForm},
  uJobDispatcher in 'comm\uJobDispatcher.pas',
  uTaskResult in 'comm\uTaskResult.pas',
  uStepVarDefine in 'steps\common\uStepVarDefine.pas',
  uStepVarDefineForm in 'steps\common\uStepVarDefineForm.pas' {StepVarDefineForm},
  uUserNotify in '..\..\common\uUserNotify.pas',
  uUserNotifyMsgForm in '..\..\common\uUserNotifyMsgForm.pas' {UserNotifyMsgForm},
  uJobStarter in 'comm\uJobStarter.pas',
  uStepFastReport in 'steps\report\uStepFastReport.pas',
  uStepFastReportForm in 'steps\report\uStepFastReportForm.pas' {StepFastReportForm},
  uStepSubTask in 'steps\common\uStepSubTask.pas',
  uStepSubTaskForm in 'steps\common\uStepSubTaskForm.pas' {StepSubTaskForm},
  uStepDownloadFile in 'steps\network\uStepDownloadFile.pas',
  uStepWaitTime in 'steps\util\uStepWaitTime.pas',
  uStepWaitTimeForm in 'steps\util\uStepWaitTimeForm.pas' {StepWaitTimeForm},
  uStepFolderCtrl in 'steps\file\uStepFolderCtrl.pas',
  uStepFolderCtrlForm in 'steps\file\uStepFolderCtrlForm.pas' {StepFolderCtrlForm},
  uStepServiceCtrl in 'steps\util\uStepServiceCtrl.pas',
  uStepServiceCtrlForm in 'steps\util\uStepServiceCtrlForm.pas' {StepServiceCtrlForm},
  uStepExeCtrl in 'steps\util\uStepExeCtrl.pas',
  uStepExeCtrlForm in 'steps\util\uStepExeCtrlForm.pas' {StepExeCtrlForm},
  uStepHttpRequestForm in 'steps\network\uStepHttpRequestForm.pas' {StepHttpRequestForm},
  uStepTxtFileReader in 'steps\file\uStepTxtFileReader.pas',
  uStepTxtFileReaderForm in 'steps\file\uStepTxtFileReaderForm.pas' {StepTxtFileReaderForm},
  uStepCondition in 'steps\common\uStepCondition.pas',
  uStepConditionForm in 'steps\common\uStepConditionForm.pas' {StepConditionForm},
  uPackageHelperForm in 'forms\uPackageHelperForm.pas' {PackageHelperForm},
  uStepTxtFileWriter in 'steps\file\uStepTxtFileWriter.pas',
  uStepTxtFileWriterForm in 'steps\file\uStepTxtFileWriterForm.pas' {StepTxtFileWriterForm},
  uStepFieldsOper in 'steps\data\uStepFieldsOper.pas',
  uStepFieldsOperForm in 'steps\data\uStepFieldsOperForm.pas' {StepFieldsOperForm},
  uStepSQL in 'steps\database\uStepSQL.pas',
  uStepSQLForm in 'steps\database\uStepSQLForm.pas' {StepSQLForm},
  uStepQuery in 'steps\database\uStepQuery.pas',
  uStepQueryForm in 'steps\database\uStepQueryForm.pas' {StepQueryForm},
  uStepIdCardHS100UCForm in 'steps\tools\uStepIdCardHS100UCForm.pas' {StepIdCardHS100UCForm},
  uStepIdCardHS100UC in 'steps\tools\uStepIdCardHS100UC.pas',
  CVRDLL in 'steps\tools\CVRDLL.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  ExePath := ExtractFilePath(Application.ExeName);
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\app\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;





  if (FormatDateTime('yyyymmdd', Now) < '20191231') then
  begin
    Application.CreateForm(TProjectForm, ProjectForm);
  Application.CreateForm(TStepTxtFileWriterForm, StepTxtFileWriterForm);
  Application.CreateForm(TStepFieldsOperForm, StepFieldsOperForm);
  Application.CreateForm(TStepSQLForm, StepSQLForm);
  Application.CreateForm(TStepQueryForm, StepQueryForm);
  Application.CreateForm(TStepIdCardHS100UCForm, StepIdCardHS100UCForm);
  ProjectForm.WindowState := wsMaximized;
  end;
  Application.Run;

  //全局单实例判断释放
  if HttpServerRunner <> nil then
  begin
    FreeAndNil(HttpServerRunner);
  end;


  FileCritical.Free;
  AppLogger.Free;
end.
