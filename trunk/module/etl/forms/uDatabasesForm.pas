unit uDatabasesForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.ExtCtrls, RzPanel,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, RzCommon, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, DBAccess,
  UniDacVcl, RzButton, Uni, SQLiteUniProvider, OracleUniProvider,
  MySQLUniProvider, UniProvider, SQLServerUniProvider, ODBCUniProvider,
  Vcl.Menus;

type
  TDatabasesForm = class(TBasicForm)
    cdsDatabases: TClientDataSet;
    rzpnlTop: TRzPanel;
    dbgrdhDatabases: TDBGridEh;
    dsDatabases: TDataSource;
    rzbtbtnAddDb: TRzBitBtn;
    uncnctdlgDbs: TUniConnectDialog;
    conDbs: TUniConnection;
    sqlsrvrnprvdr1: TSQLServerUniProvider;
    mysqlnprvdr1: TMySQLUniProvider;
    orclnprvdr1: TOracleUniProvider;
    sqltnprvdr1: TSQLiteUniProvider;
    odbcnprvdr1: TODBCUniProvider;
    pmDatabases: TPopupMenu;
    AddDatabase: TMenuItem;
    EditDatabase: TMenuItem;
    DeleteDatabase: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rzbtbtnAddDbClick(Sender: TObject);
    procedure dbgrdhDatabasesDblClick(Sender: TObject);
    procedure DeleteDatabaseClick(Sender: TObject);
  private
    DataBaseConfigFile: string;
    procedure LoadData;
    { Private declarations }
  public
    { Public declarations }
    procedure ConfigDatabases(AConfigFile: string);
  end;

var
  DatabasesForm: TDatabasesForm;

implementation

uses
  uDefines, uFunctions, System.JSON, uDatabaseConnectTestForm, uThreadSafeFile;


{$R *.dfm}



procedure TDatabasesForm.DeleteDatabaseClick(Sender: TObject);
begin
  inherited;
  if cdsDatabases.Active and (cdsDatabases.RecordCount > 0) then
  begin
    if MessageBox(Handle, PChar('您确定要删除本条数据库配置吗？'), PChar('系统提示'), MB_YESNO) = mrYes then
    begin
      cdsDatabases.Delete;
    end;
  end;
end;


procedure TDatabasesForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LDbJson: TJSONArray;
begin
  inherited;
  try
    LDbJson := DataSetToJson(cdsDatabases);
    if LDbJson <> nil then
    begin
      TThreadSafeFile.WriteContentTo(DataBaseConfigFile, LDbJson.ToJSON);
      LDbJson.Free;
    end;
  finally

  end;
end;


procedure TDatabasesForm.LoadData;
var
  LStringList: TStringList;
begin
  LStringList := TStringList.Create;
  try
    if FileExists(DataBaseConfigFile) then
      LStringList.LoadFromFile(DataBaseConfigFile);
    JsonToDataSet(LStringList.Text, cdsDatabases);
  finally
    LStringList.Free;
  end;
end;

procedure TDatabasesForm.rzbtbtnAddDbClick(Sender: TObject);
begin
  inherited;
  with TDatabaseConnectTestForm.Create(nil) do
  try
    Connect := conDbs;

    if ShowModal = mrOk then
    begin
      if Trim(edtDbTitle.Text) <> '' then
      begin
        cdsDatabases.Append;
        cdsDatabases.FieldByName('db_title').AsString := edtDbTitle.Text;
        cdsDatabases.FieldByName('connection_str').AsString := conDbs.ConnectString;
        cdsDatabases.FieldByName('password').AsString := edtPassword.Text;
        cdsDatabases.FieldByName('specific_str').AsString := conDbs.SpecificOptions.Text;
        cdsDatabases.Post;
      end;
    end;
  finally
    Free;
  end;
end;


procedure TDatabasesForm.ConfigDatabases(AConfigFile: string);
begin
  DataBaseConfigFile := AConfigFile;
  LoadData;
end;

procedure TDatabasesForm.dbgrdhDatabasesDblClick(Sender: TObject);
begin
  inherited;
  //对当前的数据进行编辑
  if cdsDatabases.RecordCount > 0 then
  begin
    with TDatabaseConnectTestForm.Create(nil) do
    try
      Connect := conDbs;
      conDbs.ConnectString := cdsDatabases.FieldByName('connection_str').AsString;
      edtDbTitle.Text := cdsDatabases.FieldByName('db_title').AsString;
      edtDbTitle.Enabled := False;
      cbbProvider.Text := conDbs.ProviderName;
      edtServer.Text := conDbs.Server;
      edtPort.Text := IntToStr(conDbs.Port);
      edtDatabase.Text := conDbs.Database;
      edtUserName.Text := conDbs.Username;
      edtPassword.Text := cdsDatabases.FieldByName('password').AsString;
      mmoSpecificStr.Text := cdsDatabases.FieldByName('specific_str').AsString;

      if ShowModal = mrOk then
      begin
        cdsDatabases.Edit;
        //目前不许允许编辑db_title
        //cdsDatabases.FieldByName('db_title').AsString := edtDbTitle.Text;
        cdsDatabases.FieldByName('connection_str').AsString := conDbs.ConnectString;
        cdsDatabases.FieldByName('password').AsString := edtPassword.Text;
        cdsDatabases.FieldByName('specific_str').AsString := conDbs.SpecificOptions.Text;
        cdsDatabases.Post;
      end;
    finally
      Free;
    end;
  end;
end;


end.
