unit donix.steps.uStepExceptionCatchForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles,
  RzPanel, RzRadGrp;

type
  TStepExceptionCatchForm = class(TStepBasicForm)
    lbl4: TLabel;
    rzrdgrpCtrlType: TRzRadioGroup;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  protected

  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepExceptionCatchForm: TStepExceptionCatchForm;

implementation

uses uStepExceptionCatch, uFunctions, uDesignTimeDefines;

{$R *.dfm}

procedure TStepExceptionCatchForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepExceptionCatch do
  begin
    Act := rzrdgrpCtrlType.ItemIndex;
  end;
end;

procedure TStepExceptionCatchForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepExceptionCatch;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepExceptionCatch(Step);
  rzrdgrpCtrlType.ItemIndex := LStep.Act;
end;

initialization
RegisterClass(TStepExceptionCatchForm);

finalization
UnRegisterClass(TStepExceptionCatchForm);

end.


