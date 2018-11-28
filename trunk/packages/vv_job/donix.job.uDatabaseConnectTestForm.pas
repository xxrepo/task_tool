unit donix.job.uDatabaseConnectTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, RzLabel, Vcl.Mask, RzEdit, MySQLUniProvider,
  SQLServerUniProvider, OracleUniProvider, SQLiteUniProvider, UniProvider,
  ODBCUniProvider, Uni;

type
  TDatabaseConnectTestForm = class(TBasicDlgForm)
    lblProvider: TRzLabel;
    lbl1: TRzLabel;
    lblServer: TRzLabel;
    lblPort: TRzLabel;
    lbl2: TRzLabel;
    lbl3: TRzLabel;
    lbl4: TRzLabel;
    edtDbTitle: TRzEdit;
    cbbProvider: TComboBox;
    edtServer: TRzEdit;
    edtPort: TRzEdit;
    edtDatabase: TRzEdit;
    edtUserName: TRzEdit;
    edtPassword: TRzMaskEdit;
    lblSpecificStr: TRzLabel;
    mmoSpecificStr: TMemo;
    btnTest: TBitBtn;
    procedure btnTestClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    procedure AssignData;
    { Private declarations }
  public
    { Public declarations }
    Connect: TUniConnection;
  end;

var
  DatabaseConnectTestForm: TDatabaseConnectTestForm;

implementation

uses uDesignTimeDefines;

{$R *.dfm}

procedure TDatabaseConnectTestForm.btnOKClick(Sender: TObject);
begin
  inherited;
  AssignData;
end;


procedure TDatabaseConnectTestForm.AssignData;
begin
  Connect.ProviderName := cbbProvider.Text;
  Connect.Server := edtServer.Text;
  Connect.Port := StrToIntDef(edtPort.Text, 0);
  Connect.Database := edtDatabase.Text;
  Connect.Username := edtUserName.Text;
  Connect.Password := edtPassword.Text;
  Connect.SpecificOptions.Text := mmoSpecificStr.Text;
end;

procedure TDatabaseConnectTestForm.btnTestClick(Sender: TObject);
begin
  inherited;
  if Connect.Connected then
    Connect.Close;

  AssignData;

  try
    Connect.Connect;
    if Connect.Connected then
    begin
      ShowMsg('数据库连接成功!');
    end
    else
    begin
      ShowMsg('数据库连接失败');
    end;
  except
    on E: Exception do
    begin
      ShowMsg(E.Message);
    end;
  end;
end;

end.
