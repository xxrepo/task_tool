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
    procedure rzpnl1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserNotifyMsgForm: TUserNotifyMsgForm;

implementation

{$R *.dfm}

procedure TUserNotifyMsgForm.rzpnl1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

end.
