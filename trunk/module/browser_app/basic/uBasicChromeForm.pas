{**
浏览器的打开窗口必须是在主进程中打开，在render进程中生成本窗口将无法正常打开对应设定的targeturl

**}
unit uBasicChromeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, uCEFChromium, uCEFInterfaces,
  uCEFWindowParent, uCEFTypes, uBasicForm;

const
  MSG_LOAD_TARGET_URL = WM_USER + 9001;

type
  TBasicChromeForm = class(TBasicForm)
    cfwndwprntMain: TCEFWindowParent;
    chrmMain: TChromium;
    tmrChromium: TTimer;
    procedure tmrChromiumTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chrmMainAfterCreated(Sender: TObject; const browser: ICefBrowser);

    procedure MsgLoadUrl(var AMsg: TMessage); message MSG_LOAD_TARGET_URL;
    procedure chrmMainProcessMessageReceived(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean);


    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
    procedure WMEnterSizeMove(var Message: TMessage) ; message WM_ENTERSIZEMOVE;

  private
    procedure OpenForm(AMsg: string);
    { Private declarations }
  protected
    FTargetUrl: string;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ATargetUrl: string); overload;
  end;

var
  BasicChromeForm: TBasicChromeForm;

implementation

uses uBaseJsObjectBinding, uCEFApplication;

{$R *.dfm}

procedure TBasicChromeForm.chrmMainAfterCreated(Sender: TObject;
  const browser: ICefBrowser);
begin
  PostMessage(Handle, MSG_LOAD_TARGET_URL, 0, 0);
end;

procedure TBasicChromeForm.chrmMainProcessMessageReceived(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  TBasicJsObjectBinding.ExecuteInBrowser(Sender, browser, sourceProcess, message, Result);
end;

constructor TBasicChromeForm.Create(AOwner: TComponent; ATargetUrl: string);
begin
  inherited Create(AOwner);
  FTargetUrl := ATargetUrl;
end;

procedure TBasicChromeForm.FormCreate(Sender: TObject);
begin
  tmrChromium.Enabled := True;
end;

procedure TBasicChromeForm.MsgLoadUrl(var AMsg: TMessage);
begin
  if FTargetUrl <> '' then
    chrmMain.LoadURL(FTargetUrl);
end;

procedure TBasicChromeForm.tmrChromiumTimer(Sender: TObject);
begin
  tmrChromium.Enabled := False;
  if (not chrmMain.CreateBrowser(cfwndwprntMain, '')) and (not chrmMain.Initialized) then
    tmrChromium.Enabled := True
end;


procedure TBasicChromeForm.OpenForm(AMsg: string);
begin
  try
    with TBasicChromeForm.Create(nil, FTargetUrl) do
    try
      Caption := AMsg;
      ShowModal;
    finally
      Free;
    end;
  finally

  end;
end;




procedure TBasicChromeForm.WMMove(var aMessage : TWMMove);
begin
  inherited;
  if (chrmMain <> nil) then chrmMain.NotifyMoveOrResizeStarted;
end;

procedure TBasicChromeForm.WMMoving(var aMessage : TMessage);
begin
  inherited;
  if (chrmMain <> nil) then chrmMain.NotifyMoveOrResizeStarted;
end;


procedure TBasicChromeForm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure TBasicChromeForm.WMEnterSizeMove(
  var Message: TMessage);
begin
  if (chrmMain <> nil) then chrmMain.NotifyMoveOrResizeStarted;
end;

procedure TBasicChromeForm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

end.
