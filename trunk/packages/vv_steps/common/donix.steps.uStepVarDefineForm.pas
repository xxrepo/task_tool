unit donix.steps.uStepVarDefineForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepVarDefineForm = class(TStepBasicForm)
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    lblParams: TLabel;
    dbgrdhInputParams: TDBGridEh;
    dbnvgrParams: TDBNavigator;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  protected

  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepVarDefineForm: TStepVarDefineForm;

implementation

uses uStepVarDefine, uFunctions, uDesignTimeDefines, uProject;

{$R *.dfm}

procedure TStepVarDefineForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepVarDefine do
  begin
    FieldParams := DataSetToJsonStr(cdsParams);
  end;
end;

procedure TStepVarDefineForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepVarDefine;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepVarDefine(Step);
  JsonToDataSet(LStep.FieldParams, cdsParams);
end;

initialization
RegisterClass(TStepVarDefineForm);

finalization
UnRegisterClass(TStepVarDefineForm);

end.


