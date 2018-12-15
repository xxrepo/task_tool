unit donix.steps.uStepConditionForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepConditionForm = class(TStepBasicForm)
    dsConditionParams: TDataSource;
    cdsConditionParams: TClientDataSet;
    lblParams: TLabel;
    dbnvgrParams: TDBNavigator;
    dbgrdhConditionParams: TDBGridEh;
    cdsConditionResults: TClientDataSet;
    dsConditionResults: TDataSource;
    dbnvgr1: TDBNavigator;
    dbgrdhConditionResults: TDBGridEh;
    lbl4: TLabel;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  protected

  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepConditionForm: TStepConditionForm;

implementation

uses uStepCondition, uFunctions, uDesignTimeDefines;

{$R *.dfm}

procedure TStepConditionForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepCondition do
  begin
    ConditionParams := DataSetToJsonStr(cdsConditionParams);
    ConditionResults := DataSetToJsonStr(cdsConditionResults);
  end;
end;

procedure TStepConditionForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepCondition;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepCondition(Step);
  JsonToDataSet(LStep.ConditionParams, cdsConditionParams);
  JsonToDataSet(LStep.ConditionResults, cdsConditionResults);
end;

end.


