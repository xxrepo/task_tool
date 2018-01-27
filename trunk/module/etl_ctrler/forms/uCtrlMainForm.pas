unit uCtrlMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, RzTray, Vcl.Menus,
  Vcl.StdCtrls, uDefines, Vcl.ExtCtrls, uJobDispatcher;

type
  TCtrlMainForm = class(TBasicForm)
    pmTray: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    lbl1: TLabel;
    N10: TMenuItem;
    N11: TMenuItem;
    rztrycnTool: TRzTrayIcon;
    procedure N9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N7Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rztrycnToolRestoreApp(Sender: TObject);
  private
    FInteractiveJobDispatcher: TJobDispatcher;

    procedure HideForm;
    { Private declarations }
  public
    { Public declarations }
    procedure ShowTopMost;
    procedure MsgInteractiveJobRequestHandler(var AMsg: TMessage); message VVMSG_INTERACTIVE_JOB_REQUEST;

  end;

var
  CtrlMainForm: TCtrlMainForm;

implementation

uses uHttpServerControlForm, uDesignTimeDefines, uFunctions;

{$R *.dfm}

procedure TCtrlMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caNone;
  rztrycnTool.MinimizeApp;
end;

procedure TCtrlMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  Application.ShowMainForm := False;
  FInteractiveJobDispatcher := TJobDispatcher.Create;
  rztrycnTool.Hint := Caption;
  N5Click(Sender);
end;


procedure TCtrlMainForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FInteractiveJobDispatcher.Free;
end;

procedure TCtrlMainForm.N10Click(Sender: TObject);
begin
  inherited;
  rztrycnTool.RestoreApp;
  ShowTopMost;
end;

procedure TCtrlMainForm.N5Click(Sender: TObject);
begin
  inherited;
  if HttpServerRunner <> nil then Exit;

  with THttpServerControlForm.Create(nil) do
  try
    btnStart.Click;
  finally
    Free;
  end;
end;

procedure TCtrlMainForm.N6Click(Sender: TObject);
begin
  inherited;
  if HttpServerRunner <> nil then
  begin
    FreeAndNil(HttpServerRunner);
  end;
end;

procedure TCtrlMainForm.N7Click(Sender: TObject);
begin
  inherited;
  with THttpServerControlForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TCtrlMainForm.N9Click(Sender: TObject);
var
  i: Integer;
  LForm: TForm;
begin
  inherited;
  for i := Screen.FormCount - 1 downto 0 do begin
    LForm := Screen.Forms[i];
    if LForm <> nil then
      SendMessage(LForm.Handle, WM_CLOSE, 0, 0);
  end;

  Application.Terminate;
end;


procedure TCtrlMainForm.rztrycnToolRestoreApp(Sender: TObject);
begin
  inherited;
  HideForm;
end;

procedure TCtrlMainForm.ShowTopMost;
begin
  Show;
end;


procedure TCtrlMainForm.HideForm;
begin
  Self.Visible := False;
end;


procedure TCtrlMainForm.MsgInteractiveJobRequestHandler(var AMsg: TMessage);
var
  LJobDispatcherRec: PJobDispatcherRec;
begin

  //要给与用户适当的提示，并且适度激活本应用程序，主窗口仅仅用于做美化后的消息展示
  //rztrycnTool.RestoreApp;
  FormStyle := fsStayOnTop;
  Application.Restore;
  SetForegroundWindow(Handle);

  if AMsg.Msg <> VVMSG_INTERACTIVE_JOB_REQUEST then Exit;

  LJobDispatcherRec := PJobDispatcherRec(AMsg.WParam);
  if LJobDispatcherRec = nil then Exit;

  //Interactive的Job同样是没有结果输出的，那如何标记Job为Interactive，在Job设计阶段进行标记，否则异常出错
  FInteractiveJobDispatcher.StartProjectJob(LJobDispatcherRec, False);
end;

end.
