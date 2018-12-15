unit donix.steps.uStepQueryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, RzLabel, RzEdit, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Data.DB, Datasnap.DBClient, MemDS, DBAccess, Uni;

type
  TStepQueryForm = class(TStepBasicForm)
    mmoQuerySQL: TRzMemo;
    lbl2: TRzLabel;
    btnDbConfig: TBitBtn;
    cbbDbCon: TComboBox;
    lblDb: TRzLabel;
    rztbshtParams: TRzTabSheet;
    unqrySql: TUniQuery;
    cdsInputParams: TClientDataSet;
    dsInputParams: TDataSource;
    lblParams: TLabel;
    dbgrdhInputParams: TDBGridEh;
    btnParseSqlParams: TBitBtn;
    btnPreview: TBitBtn;
    procedure btnDbConfigClick(Sender: TObject);
    procedure btnParseSqlParamsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
  private
    procedure ReLoadDBs;
  protected

    { Private declarations }
  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string = ''); override;
  end;

var
  StepQueryForm: TStepQueryForm;

implementation

uses
  uStepQuery, uDbConMgr, uDesignTimeDefines, uDatabasesForm, uFunctions, uDBQueryResultForm;

{$R *.dfm}

procedure TStepQueryForm.btnDbConfigClick(Sender: TObject);
begin
  inherited;
  with TDatabasesForm.Create(nil) do
  try
    ConfigDatabases(CurrentProject.DbsFile);
    ShowModal;
    Step.TaskVar.DbConMgr.LoadDbConfigs(CurrentProject.DbsFile);
    ReLoadDBs;
  finally
    Free;
  end;
end;

procedure TStepQueryForm.btnOKClick(Sender: TObject);
var
  LStep: TStepQuery;
begin
  inherited;
  //赋值到step
  LStep := (Step as TStepQuery);
  LStep.DBConTitle := cbbDbCon.Text;
  LStep.QuerySql := mmoQuerySQL.Text;
  LStep.SqlParamsConfigJsonStr := DataSetToJsonStr(cdsInputParams);
end;

procedure TStepQueryForm.btnParseSqlParamsClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  //默认情况为上次填写的配置参数，需要给与提示
  if cdsInputParams.RecordCount > 0 then
  begin
    if ShowMsg('您确定要重新从SQL获取参数条件吗？', MB_OKCANCEL) = mrCancel then
    begin
      Exit;
    end;
  end;

  if unqrySql.Active then
    unqrySql.Close;

  unqrySql.SQL.Text := mmoQuerySQL.Text;
  cdsInputParams.EmptyDataSet;
  for i := 0 to unqrySql.Params.Count - 1 do
  begin
    cdsInputParams.Append;
    cdsInputParams.FieldByName('param_name').AsString := unqrySql.Params[i].Name;
    cdsInputParams.FieldByName('param_type').AsString := 'string';
    cdsInputParams.FieldByName('default_value').AsString := '';
    cdsInputParams.Post;
  end;
end;

procedure TStepQueryForm.btnPreviewClick(Sender: TObject);
begin
  inherited;
  with TDBQueryResultForm.Create(nil) do
  try
    if mmoQuerySQL.SelLength > 0 then
      redtSQL.Text := mmoQuerySQL.SelText
    else
      redtSQL.Text := mmoQuerySQL.Text;
    DBConTitle := cbbDbCon.Text;
    DBConMgr := TaskVar.DbConMgr;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TStepQueryForm.FormShow(Sender: TObject);
begin
  inherited;
  ReLoadDBs;
end;

procedure TStepQueryForm.ReLoadDBs;
begin
  cbbDbCon.Items.Clear;
  cbbDbCon.Items.CommaText := Step.TaskVar.DbConMgr.GetDBTitles;
  if cbbDbCon.Items.Count > 0 then
  begin
    if (Step = nil) or ((Step as TStepQuery).DBConTitle = '') then
      cbbDbCon.ItemIndex := 0
    else
      cbbDbCon.ItemIndex := cbbDbCon.Items.IndexOf((Step as TStepQuery).DBConTitle);
  end;
end;


procedure TStepQueryForm.ParseStepConfig(AConfigJsonStr: string);
begin
  //给Step对象赋值
  inherited ParseStepConfig(AConfigJsonStr);

  ReLoadDBs;
  edtStepTitle.Text := Step.StepConfig.StepTitle;
  mmoQuerySQL.Text := (Step as TStepQuery).QuerySql;
  JsonToDataSet((Step as TStepQuery).SqlParamsConfigJsonStr, cdsInputParams);
end;

end.
