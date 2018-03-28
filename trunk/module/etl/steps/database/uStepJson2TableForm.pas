unit uStepJson2TableForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, RzLabel, RzEdit, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh,
  Data.DB, Datasnap.DBClient, MemDS, DBAccess, Uni;

type
  TStepJson2TableForm = class(TStepBasicForm)
    lbl2: TRzLabel;
    btnDbConfig: TBitBtn;
    cbbDbCon: TComboBox;
    lblDb: TRzLabel;
    unqrySql: TUniQuery;
    edtTableName: TEdit;
    lbl3: TRzLabel;
    edtUniqueKeyFields: TEdit;
    chkSkipExist: TCheckBox;
    procedure btnDbConfigClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ReLoadDBs;
  protected

    { Private declarations }
  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string = ''); override;
  end;

var
  StepJson2TableForm: TStepJson2TableForm;

implementation

uses
  uStepJson2Table, uDbConMgr, uDesignTimeDefines, uDatabasesForm, uFunctions, uDBQueryResultForm;

{$R *.dfm}

procedure TStepJson2TableForm.btnDbConfigClick(Sender: TObject);
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

procedure TStepJson2TableForm.btnOKClick(Sender: TObject);
var
  LStep: TStepJson2Table;
begin
  inherited;
  //赋值到step
  LStep := (Step as TStepJson2Table);
  LStep.DBConTitle := cbbDbCon.Text;
  LStep.TableName := edtTableName.Text;
  LStep.UniqueKeyFields := edtUniqueKeyFields.Text;
  LStep.SkipExists := chkSkipExist.Checked;
end;

procedure TStepJson2TableForm.FormShow(Sender: TObject);
begin
  inherited;
  ReLoadDBs;
end;

procedure TStepJson2TableForm.ReLoadDBs;
begin
  cbbDbCon.Items.Clear;
  cbbDbCon.Items.CommaText := Step.TaskVar.DbConMgr.GetDBTitles;
  if cbbDbCon.Items.Count > 0 then
  begin
    if (Step = nil) or ((Step as TStepJson2Table).DBConTitle = '') then
      cbbDbCon.ItemIndex := 0
    else
      cbbDbCon.ItemIndex := cbbDbCon.Items.IndexOf((Step as TStepJson2Table).DBConTitle);
  end;
end;


procedure TStepJson2TableForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepJson2Table;
begin
  //给Step对象赋值
  inherited ParseStepConfig(AConfigJsonStr);

  ReLoadDBs;

  LStep := (Step as TStepJson2Table);
  edtStepTitle.Text := LStep.StepConfig.StepTitle;
  edtTableName.Text := LStep.TableName;
  edtUniqueKeyFields.Text := LStep.UniqueKeyFields;
  chkSkipExist.Checked := LStep.SkipExists;
end;


initialization
RegisterClass(TStepJson2TableForm);

finalization
UnRegisterClass(TStepJson2TableForm);

end.
