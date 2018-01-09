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
  uJobsForm in 'forms\uJobsForm.pas' {JobsForm},
  uSettingForm in 'forms\uSettingForm.pas' {SettingsForm},
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uProjectForm in 'forms\uProjectForm.pas' {ProjectForm},
  uProject in 'comm\uProject.pas',
  uDesignTimeDefines in 'comm\uDesignTimeDefines.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uStepCondition in 'steps\uStepCondition.pas',
  uStepConditionForm in 'steps\uStepConditionForm.pas' {StepConditionForm},
  uStepDatasetSpliter in 'steps\uStepDatasetSpliter.pas',
  uStepDefines in 'steps\uStepDefines.pas',
  uStepFormFactory in 'steps\uStepFormFactory.pas',
  uStepHttpRequest in 'steps\uStepHttpRequest.pas',
  uStepHttpRequestForm in 'steps\uStepHttpRequestForm.pas' {StepHttpRequestForm},
  uStepVarDefine in 'steps\uStepVarDefine.pas',
  uStepVarDefineForm in 'steps\uStepVarDefineForm.pas' {StepVarDefineForm},
  uStepIniWrite in 'steps\uStepIniWrite.pas',
  uStepIniWriteForm in 'steps\uStepIniWriteForm.pas' {StepIniWriteForm},
  uStepNullForm in 'steps\uStepNullForm.pas' {StepNullForm},
  uStepQuery in 'steps\uStepQuery.pas',
  uStepQueryForm in 'steps\uStepQueryForm.pas' {StepQueryForm},
  uStepSubTask in 'steps\uStepSubTask.pas',
  uStepSubTaskForm in 'steps\uStepSubTaskForm.pas' {StepSubTaskForm},
  uStepFileDelete in 'steps\uStepFileDelete.pas',
  uStepFileDeleteForm in 'steps\uStepFileDeleteForm.pas' {StepFileDeleteForm},
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uJobScheduleForm in 'forms\uJobScheduleForm.pas' {JobScheduleForm},
  uStepFactory in 'steps\uStepFactory.pas',
  uEnterForm in 'forms\uEnterForm.pas' {EnterForm},
  uServiceControlForm in 'forms\uServiceControlForm.pas' {ServiceControlForm},
  uStepIniRead in 'steps\uStepIniRead.pas',
  uStepIniReadForm in 'steps\uStepIniReadForm.pas' {StepIniReadForm},
  uMakeDirForm in 'forms\uMakeDirForm.pas' {MakeDirForm},
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uFileCleaner in '..\..\core\lib\uFileCleaner.pas',
  uStepDatasetSpliterForm in 'steps\uStepDatasetSpliterForm.pas' {StepDatasetSpliterForm},
  uStepWriteTxtFile in 'steps\uStepWriteTxtFile.pas',
  uStepWriteTxtFileForm in 'steps\uStepWriteTxtFileForm.pas' {StepWriteTxtFileForm},
  uThreadSafeFile in 'comm\uThreadSafeFile.pas',
  uServiceConfig in '..\etl_service\uServiceConfig.pas',
  uServiceRunner in '..\etl_service\uServiceRunner.pas',
  uGlobalVar in 'comm\uGlobalVar.pas',
  uGlobalVarSettingForm in 'forms\uGlobalVarSettingForm.pas' {GlobalVarSettingForm},
  uStepFieldsOper in 'steps\uStepFieldsOper.pas',
  uStepFieldsOperForm in 'steps\uStepFieldsOperForm.pas' {StepFieldsOperForm},
  uStepFastReport in 'steps\uStepFastReport.pas',
  uStepFastReportForm in 'steps\uStepFastReportForm.pas' {StepFastReportForm},
  uStepFormSettings in 'steps\uStepFormSettings.pas',
  uStepJson2DataSet in 'steps\uStepJson2DataSet.pas',
  uStepJson2DataSetForm in 'steps\uStepJson2DataSetForm.pas' {StepJsonDataSetForm},
  uDBQueryResultForm in 'steps\database\uDBQueryResultForm.pas' {DBQueryResultForm},
  uBasicLogForm in '..\..\core\basic\uBasicLogForm.pas' {BasicLogForm};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := DebugHook<>0;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  ExePath := ExtractFilePath(Application.ExeName);
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\app\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;

  Application.CreateForm(TProjectForm, ProjectForm);
  Application.CreateForm(TBasicLogForm, BasicLogForm);
  ProjectForm.WindowState := wsMaximized;
  Application.Run;


  FileCritical.Free;
  AppLogger.Free;
end.
