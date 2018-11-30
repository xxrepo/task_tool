program CgtEtlTool;

uses
  Vcl.Forms,
  MidasLib,
  System.SysUtils,
  Vcl.Controls,
  System.SyncObjs,
  donix.job.uDefines,
  donix.basic.uFileLogger,
  donix.steps.uStepsRegisterCore,
  uJobsMgrForm in 'forms\uJobsMgrForm.pas' {JobsForm},
  uSettingForm in 'forms\uSettingForm.pas' {SettingsForm},
  uProjectForm in 'forms\uProjectForm.pas' {ProjectForm},
  uJobScheduleForm in 'forms\uJobScheduleForm.pas' {JobScheduleForm},
  uEnterForm in 'forms\uEnterForm.pas' {EnterForm},
  uServiceControlForm in 'ctrl_forms\uServiceControlForm.pas' {ServiceControlForm},
  uMakeDirForm in 'forms\uMakeDirForm.pas' {MakeDirForm},
  uScheduleConfig in 'runners\uScheduleConfig.pas',
  uScheduleRunner in 'runners\uScheduleRunner.pas',
  uGlobalVarSettingForm in 'forms\uGlobalVarSettingForm.pas' {GlobalVarSettingForm},
  uHttpServerControlForm in 'ctrl_forms\uHttpServerControlForm.pas' {HttpServerControlForm},
  uHttpServerRunner in 'runners\uHttpServerRunner.pas',
  uHttpServerConfig in 'runners\uHttpServerConfig.pas',
  uPackageHelperForm in 'forms\uPackageHelperForm.pas' {PackageHelperForm},
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


  TStepsRegisterCore.RegSteps;


  if (FormatDateTime('yyyymmdd', Now) < '20191231') then
  begin
    Application.CreateForm(TProjectForm, ProjectForm);
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
