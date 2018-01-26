unit uUserNotifyMsgForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.StdCtrls, RzLabel,
  Vcl.ExtCtrls, RzPanel, Vcl.Buttons;

type
  TUserNotifyMsgForm = class(TBasicForm)
    lblMsg: TRzLabel;
    rzpnl1: TRzPanel;
    tmrClose: TTimer;
    procedure rzpnl1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure tmrCloseTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FCount: Integer;
  end;

var
  UserNotifyMsgForm: TUserNotifyMsgForm;

implementation

{$R *.dfm}

procedure TUserNotifyMsgForm.FormCreate(Sender: TObject);
begin
  inherited;
  FCount := 1;
end;

procedure TUserNotifyMsgForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = Char(VK_SPACE)) or (Key = Char(VK_RETURN)) then
    ModalResult := mrOk;
end;

procedure TUserNotifyMsgForm.rzpnl1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TUserNotifyMsgForm.tmrCloseTimer(Sender: TObject);
begin
  inherited;
  FCount := FCount + 1;
  if FCount = 8 then
  begin
    Self.Close;
  end;
end;

end.
