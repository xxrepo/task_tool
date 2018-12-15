unit donix.steps.uStepTaskResultForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepTaskResultForm = class(TStepBasicForm)
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    lblParams: TLabel;
    dbgrdhInputParams: TDBGridEh;
    dbnvgrParams: TDBNavigator;
    lbl2: TLabel;
    edtCode: TEdit;
    lbl3: TLabel;
    edtMsg: TEdit;
    lbl4: TLabel;
    chkExitTask: TCheckBox;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  protected

  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepTaskResultForm: TStepTaskResultForm;

implementation

uses uStepTaskResult, uFunctions, uDesignTimeDefines, uProject;

{$R *.dfm}

procedure TStepTaskResultForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepTaskResult do
  begin
    FieldParams := DataSetToJsonStr(cdsParams);
    Code := edtCode.Text;
    Msg := edtMsg.Text;
    ExitTask := chkExitTask.Checked;
  end;
end;

procedure TStepTaskResultForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepTaskResult;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepTaskResult(Step);
  JsonToDataSet(LStep.FieldParams, cdsParams);
  edtCode.Text := LStep.Code;
  edtMsg.Text := LStep.Msg;
  chkExitTask.Checked := LStep.ExitTask;
end;


end.


