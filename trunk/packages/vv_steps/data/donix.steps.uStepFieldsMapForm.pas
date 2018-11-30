unit donix.steps.uStepFieldsMapForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, Data.DB, Datasnap.DBClient,
  RzLabel;

type
  TStepFieldsMapForm = class(TStepBasicForm)
    lbl2: TLabel;
    edtDataRef: TEdit;
    cdsParams: TClientDataSet;
    dsParams: TDataSource;
    dbnvgrParams: TDBNavigator;
    dbgrdhInputParams: TDBGridEh;
    lblParams: TLabel;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepFieldsMapForm: TStepFieldsMapForm;

implementation

uses uFunctions, uDesignTimeDefines, uStepFieldsMap;

{$R *.dfm}

procedure TStepFieldsMapForm.btnOKClick(Sender: TObject);
begin
  inherited;
  if Trim(edtDataRef.Text) = '' then
  begin
    ShowMsg('数据来源不能为空');
    Exit;
  end;

  with Step as TStepFieldsMap do
  begin
    DataRef := edtDataRef.Text;
    MapConfigJsonStr := DataSetToJsonStr(cdsParams);
  end;
end;

procedure TStepFieldsMapForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepFieldsMap;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepFieldsMap(Step);
  edtDataRef.Text := LStep.DataRef;
  JsonToDataSet(LStep.MapConfigJsonStr, cdsParams);
end;


initialization
RegisterClass(TStepFieldsMapForm);

finalization
UnRegisterClass(TStepFieldsMapForm);

end.


