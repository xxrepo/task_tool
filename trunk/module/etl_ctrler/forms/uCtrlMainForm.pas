unit uCtrlMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, RzTray, Vcl.Menus,
  Vcl.StdCtrls, uDefines, Vcl.ExtCtrls;

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
    procedure rztrycnToolLButtonDblClick(Sender: TObject);
    procedure MsgRestoreApplicationHandler(var AMsg: TMessage); message VVMSG_RESTORE_APPLICATION_FORM;
  private
    procedure HideForm;
    { Private declarations }
  public
    { Public declarations }
    procedure ShowTopMost;
  end;

var
  CtrlMainForm: TCtrlMainForm;

implementation

uses uHttpServerControlForm, uDesignTimeDefines, uUserNotifyMsgForm;

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
  rztrycnTool.Hint := Caption;
  N5Click(Sender);
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


procedure TCtrlMainForm.rztrycnToolLButtonDblClick(Sender: TObject);
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
  if Self.Visible then
  begin
    Hide;
  end;
end;


procedure TCtrlMainForm.MsgRestoreApplicationHandler(var AMsg: TMessage);
begin
  rztrycnTool.RestoreApp;
end;




end.
