unit uStepWaitTimeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepWaitTimeForm = class(TStepBasicForm)
    lbl2: TLabel;
    edtMiniSeconds: TEdit;
    lbl3: TLabel;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepWaitTimeForm: TStepWaitTimeForm;

implementation

uses uDesignTimeDefines, uStepWaitTime;

{$R *.dfm}

procedure TStepWaitTimeForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepWaitTime do
  begin
    MiniSeconds := StrToIntDef(edtMiniSeconds.Text, 1000);
  end;
end;

procedure TStepWaitTimeForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepWaitTime;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepWaitTime(Step);
  edtMiniSeconds.Text := IntToStr(LStep.MiniSeconds);
end;


initialization
RegisterClass(TStepWaitTimeForm);

finalization
UnRegisterClass(TStepWaitTimeForm);

end.


