unit uStepJson2DataSetForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, Data.DB, Datasnap.DBClient,
  RzLabel;

type
  TStepJsonDataSetForm = class(TStepBasicForm)
    lbl2: TLabel;
    edtDataRef: TEdit;
    cdsParams: TClientDataSet;
    dsParams: TDataSource;
    dbnvgrParams: TDBNavigator;
    dbgrdhInputParams: TDBGridEh;
    lblParams: TLabel;
    lbl3: TLabel;
    edtMasterSourceName: TEdit;
    lbl4: TLabel;
    edtMasterFields: TEdit;
    lbl5: TLabel;
    edtIndexFieldNames: TEdit;
    btnTest: TButton;
    chkCreateDataSource: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepJsonDataSetForm: TStepJsonDataSetForm;

implementation

uses uFunctions, uDesignTimeDefines, uStepJson2DataSet, uStepFormSettings;

{$R *.dfm}

procedure TStepJsonDataSetForm.btnOKClick(Sender: TObject);
begin
  inherited;
  if Trim(edtDataRef.Text) = '' then
  begin
    ShowMsg('数据来源不能为空');
    Exit;
  end;

  with Step as TStepJsonDataSet do
  begin
    DataRef := edtDataRef.Text;
    FieldsDefStr := DataSetToJsonStr(cdsParams);
    IndexedFieldNames := edtIndexFieldNames.Text;
    MasterSourceName := edtMasterSourceName.Text;
    MasterFields := edtMasterFields.Text;
    CreateDataSource := chkCreateDataSource.Checked;
  end;
end;

procedure TStepJsonDataSetForm.FormCreate(Sender: TObject);
begin
  inherited;
  dbgrdhInputParams.Columns.FindColumnByName('Column_1_data_type').KeyList.Text := TStepFormSettings.GetDataSetFieldTypes.KeyList;
  dbgrdhInputParams.Columns.FindColumnByName('Column_1_data_type').PickList.Text := TStepFormSettings.GetDataSetFieldTypes.PickList;
end;

procedure TStepJsonDataSetForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepJsonDataSet;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepJsonDataSet(Step);
  edtDataRef.Text := LStep.DataRef;
  edtIndexFieldNames.Text := LStep.IndexedFieldNames;
  edtMasterSourceName.Text := LStep.MasterSourceName;
  edtMasterFields.Text := LStep.MasterFields;
  JsonToDataSet(LStep.FieldsDefStr, cdsParams);
  chkCreateDataSource.Checked := LStep.CreateDataSource;
end;


initialization
RegisterClass(TStepJsonDataSetForm);

finalization
UnRegisterClass(TStepJsonDataSetForm);

end.


