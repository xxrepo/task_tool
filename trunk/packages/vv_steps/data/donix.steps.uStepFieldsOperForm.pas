unit donix.steps.uStepFieldsOperForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepFieldsOper, Vcl.Mask, RzEdit, RzBtnEdt,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, Data.DB, Datasnap.DBClient,
  RzLabel;

type
  TStepFieldsOperForm = class(TStepBasicForm)
    lbl2: TLabel;
    edtFieldName: TEdit;
    cdsParams: TClientDataSet;
    dsParams: TDataSource;
    dbnvgrParams: TDBNavigator;
    dbgrdhInputParams: TDBGridEh;
    lblParams: TLabel;
    lblDb: TRzLabel;
    cbbFieldDataType: TComboBox;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepFieldsOperForm: TStepFieldsOperForm;

implementation

uses uFunctions, uDesignTimeDefines;

{$R *.dfm}

procedure TStepFieldsOperForm.btnOKClick(Sender: TObject);
begin
  inherited;
  if Trim(edtFieldName.Text) = '' then
  begin
    ShowMsg('字段名称不能为空');
    Exit;
  end;

  with Step as TStepFieldsOper do
  begin
    FieldName := edtFieldName.Text;
    FieldDataType := cbbFieldDataType.Text;
    OperConfigJsonStr := DataSetToJsonStr(cdsParams);
  end;
end;

procedure TStepFieldsOperForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepFieldsOper;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepFieldsOper(Step);
  edtFieldName.Text := LStep.FieldName;
  cbbFieldDataType.ItemIndex := cbbFieldDataType.Items.IndexOf(LStep.FieldDataType);
  JsonToDataSet(LStep.OperConfigJsonStr, cdsParams);
end;


end.


