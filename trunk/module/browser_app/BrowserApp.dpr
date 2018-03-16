program BrowserApp;

uses
  Vcl.Forms,
  Winapi.Windows,
  System.SysUtils,
  System.SyncObjs,
  uCEFApplication,
  uBasicForm in '..\..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uFunctions in '..\..\common\uFunctions.pas',
  uSelectFolderForm in '..\..\common\uSelectFolderForm.pas' {SelectFolderForm},
  uRENDER_JsCallbackList in 'comm\uRENDER_JsCallbackList.pas',
  uRENDER_ProcessProxy in 'comm\uRENDER_ProcessProxy.pas',
  uBasicChromeForm in 'basic\uBasicChromeForm.pas' {BasicChromeForm},
  uBasicJsBridge in 'basic\uBasicJsBridge.pas',
  uDefines in 'comm\uDefines.pas',
  uVVCefFunction in 'comm\uVVCefFunction.pas',
  uAppForm in 'forms\uAppForm.pas' {AppForm},
  uBROWSER_EventListnerList in 'comm\uBROWSER_EventListnerList.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  ExePath := ExtractFilePath(Application.ExeName);
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\app\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;

  PRENDER_JsCallbackMgr := TRENDER_JsCallbackMgr.Create;
  PRENDER_RenderHelper := TRENDER_ProcessProxy.Create;

  GlobalCEFApp                  := TCefApplication.Create;
  GlobalCEFApp.OnContextCreated := PRENDER_RenderHelper.OnContextCreated;
  GlobalCEFApp.OnContextReleased := PRENDER_RenderHelper.OnContextReleased;
  GlobalCEFApp.OnProcessMessageReceived := PRENDER_RenderHelper.OnProcessMessageReceived;
  GlobalCEFApp.SingleProcess := False;

  if GlobalCEFApp.StartMainProcess then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;

    Application.CreateForm(TAppForm, AppForm);
  AppForm.WindowState := wsMaximized;
    Application.Run;
  end;

  GlobalCEFApp.Free;
  PRENDER_RenderHelper.Free;
  PRENDER_JsCallbackMgr.Free;

  FileCritical.Free;
  AppLogger.Free;
end.
