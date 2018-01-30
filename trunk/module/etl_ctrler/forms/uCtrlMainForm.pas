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
    tmrMsg: TTimer;
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
    FMsgThread: TThread;

    procedure HideForm;
    procedure CloseAppForms;
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
  //Application.ShowMainForm := False;
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

procedure TCtrlMainForm.CloseAppForms;
var
  i: Integer;
  LForm: TCustomForm;
begin
  inherited;
  for i := Screen.FormCount - 1 downto 0 do begin
    LForm := Screen.Forms[i] as TForm;
    if LForm <> nil then
      SendMessage(LForm.Handle, WM_CLOSE, 0, 0);
  end;

  for i := Screen.CustomFormCount - 1 downto 0 do begin
    LForm := Screen.CustomForms[i];
    if LForm <> nil then
      SendMessage(LForm.Handle, WM_CLOSE, 0, 0);
  end;
end;

procedure TCtrlMainForm.N9Click(Sender: TObject);
begin
  CloseAppForms;
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
  i: Integer;
  LFormHandle: THandle;
  LMsg: TMessage;
begin
  //如果已经在运行Interactive任务，则继续发送一条重复的消息给app，等待下次消息循环开始时进行调用
  if FInteractiveJobDispatcher.UnHandledCount > 0 then
  begin
    CloseAppForms;

    //启用匿名函数
    if AMsg.LParam < 4 then
    begin
      LFormHandle := Handle;
      LMsg := AMsg;
      LMsg.LParam := LMsg.LParam + 1;
      try
        if LMsg.LParam = 2 then
        begin
          FInteractiveJobDispatcher.Stop;
        end
        else if LMsg.LParam = 3 then
        begin
          FInteractiveJobDispatcher.ClearTaskStacks;
        end;
      finally

      end;
      TThread.CreateAnonymousThread(procedure
      begin
        Sleep(200);
        PostMessage(LFormHandle, VVMSG_INTERACTIVE_JOB_REQUEST, LMsg.WParam, LMsg.LParam);
      end).Start;
    end;

    Exit;
  end;


  FormStyle := fsStayOnTop;
  Application.Restore;
  SetForegroundWindow(Handle);

  if AMsg.Msg <> VVMSG_INTERACTIVE_JOB_REQUEST then Exit;

  LJobDispatcherRec := PJobDispatcherRec(AMsg.WParam);
  if LJobDispatcherRec = nil then Exit;

  FInteractiveJobDispatcher.StartProjectJob(LJobDispatcherRec, False);
end;

end.
