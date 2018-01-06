program CgtEtlTool;

uses
  Vcl.Forms,
  MidasLib,
  System.SysUtils,
  Vcl.Controls,
  System.SyncObjs,
  uBasicForm in '..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uFunctions in '..\common\uFunctions.pas',
  uDefines in '..\module\etl\comm\uDefines.pas',
  uTaskEditForm in '..\module\etl\forms\uTaskEditForm.pas' {TaskEditForm},
  uAlertSound in '..\core\lib\uAlertSound.pas',
  uStepTypeSelectForm in '..\module\etl\forms\uStepTypeSelectForm.pas' {StepTypeSelectForm},
  uStepBasicForm in '..\module\etl\basic\uStepBasicForm.pas' {StepBasicForm},
  uDatabasesForm in '..\module\etl\forms\uDatabasesForm.pas' {DatabasesForm},
  uDatabaseConnectTestForm in '..\module\etl\forms\uDatabaseConnectTestForm.pas' {DatabaseConnectTestForm},
  uDbConMgr in '..\module\etl\comm\uDbConMgr.pas',
  uStepBasic in '..\module\etl\basic\uStepBasic.pas',
  uTaskVar in '..\module\etl\comm\uTaskVar.pas',
  uTask in '..\module\etl\comm\uTask.pas',
  uExceptions in '..\module\etl\comm\uExceptions.pas',
  uFileLogger in '..\core\lib\uFileLogger.pas',
  uThreadQueueUtil in '..\core\lib\uThreadQueueUtil.pas',
  uJob in '..\module\etl\comm\uJob.pas',
  uJobsForm in '..\module\etl\forms\uJobsForm.pas' {JobsForm},
  uSettingForm in '..\module\etl\forms\uSettingForm.pas' {SettingsForm},
  uFileUtil in '..\core\lib\uFileUtil.pas',
  uProjectForm in '..\module\etl\forms\uProjectForm.pas' {ProjectForm},
  uProject in '..\module\etl\comm\uProject.pas',
  uDesignTimeDefines in '..\module\etl\comm\uDesignTimeDefines.pas',
  uNetUtil in '..\core\lib\uNetUtil.pas',
  uStepCondition in '..\module\etl\steps\uStepCondition.pas',
  uStepConditionForm in '..\module\etl\steps\uStepConditionForm.pas' {StepConditionForm},
  uStepDatasetSpliter in '..\module\etl\steps\uStepDatasetSpliter.pas',
  uStepDefines in '..\module\etl\steps\uStepDefines.pas',
  uStepFormFactory in '..\module\etl\steps\uStepFormFactory.pas',
  uStepFieldsOper in '..\module\etl\steps\uStepFieldsOper.pas',
  uStepFieldsOperForm in '..\module\etl\steps\uStepFieldsOperForm.pas' {StepFieldsOperForm},
  uStepHttpRequest in '..\module\etl\steps\uStepHttpRequest.pas',
  uStepHttpRequestForm in '..\module\etl\steps\uStepHttpRequestForm.pas' {StepHttpRequestForm},
  uStepVarDefine in '..\module\etl\steps\uStepVarDefine.pas',
  uStepVarDefineForm in '..\module\etl\steps\uStepVarDefineForm.pas' {StepVarDefineForm},
  uStepIniWrite in '..\module\etl\steps\uStepIniWrite.pas',
  uStepIniWriteForm in '..\module\etl\steps\uStepIniWriteForm.pas' {StepIniWriteForm},
  uStepNullForm in '..\module\etl\steps\uStepNullForm.pas' {StepNullForm},
  uStepQuery in '..\module\etl\steps\uStepQuery.pas',
  uStepQueryForm in '..\module\etl\steps\uStepQueryForm.pas' {StepQueryForm},
  uStepSubTask in '..\module\etl\steps\uStepSubTask.pas',
  uStepSubTaskForm in '..\module\etl\steps\uStepSubTaskForm.pas' {StepSubTaskForm},
  uStepFileDelete in '..\module\etl\steps\uStepFileDelete.pas',
  uStepFileDeleteForm in '..\module\etl\steps\uStepFileDeleteForm.pas' {StepFileDeleteForm},
  uServiceUtil in '..\core\lib\uServiceUtil.pas',
  uJobScheduleForm in '..\module\etl\forms\uJobScheduleForm.pas' {JobScheduleForm},
  uStepFactory in '..\module\etl\steps\uStepFactory.pas',
  uEnterForm in '..\module\etl\forms\uEnterForm.pas' {EnterForm},
  uServiceControlForm in '..\module\etl\forms\uServiceControlForm.pas' {ServiceControlForm},
  uStepIniRead in '..\module\etl\steps\uStepIniRead.pas',
  uStepIniReadForm in '..\module\etl\steps\uStepIniReadForm.pas' {StepIniReadForm},
  uMakeDirForm in '..\module\etl\forms\uMakeDirForm.pas' {MakeDirForm},
  uFileFinder in '..\core\lib\uFileFinder.pas',
  uFileCleaner in '..\core\lib\uFileCleaner.pas',
  uStepDatasetSpliterForm in '..\module\etl\steps\uStepDatasetSpliterForm.pas' {StepDatasetSpliterForm},
  uStepWriteTxtFile in '..\module\etl\steps\uStepWriteTxtFile.pas',
  uStepWriteTxtFileForm in '..\module\etl\steps\uStepWriteTxtFileForm.pas' {StepWriteTxtFileForm},
  uThreadSafeFile in '..\module\etl\comm\uThreadSafeFile.pas',
  uServiceConfig in '..\module\etl_service\uServiceConfig.pas',
  uServiceRunner in '..\module\etl_service\uServiceRunner.pas',
  uGlobalVar in '..\module\etl\comm\uGlobalVar.pas',
  uGlobalVarSettingForm in '..\module\etl\forms\uGlobalVarSettingForm.pas' {GlobalVarSettingForm};

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
  Application.CreateForm(TGlobalVarSettingForm, GlobalVarSettingForm);
  ProjectForm.WindowState := wsMaximized;
  Application.Run;


  FileCritical.Free;
  AppLogger.Free;
end.
