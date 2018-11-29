unit uStepIdCardHS100UCForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TStepIdCardHS100UCForm = class(TStepBasicForm)
    lbl2: TLabel;
    edtWaitTime: TEdit;
    lbl3: TLabel;
    mmoScanPorts: TMemo;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepIdCardHS100UCForm: TStepIdCardHS100UCForm;

implementation

uses uDesignTimeDefines, uStepIdCardHS100UC;

{$R *.dfm}

procedure TStepIdCardHS100UCForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepIdCardHS100UC do
  begin
    WaitTime := StrToIntDef(edtWaitTime.Text, 10);
    ScanPorts := mmoScanPorts.Lines.DelimitedText;
  end;
end;



procedure TStepIdCardHS100UCForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepIdCardHS100UC;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepIdCardHS100UC(Step);
  edtWaitTime.Text := IntToStr(LStep.WaitTime);
  mmoScanPorts.Lines.Delimiter := ',';
  mmoScanPorts.Lines.DelimitedText := LStep.ScanPorts;
end;


initialization
RegisterClass(TStepIdCardHS100UCForm);

finalization
UnRegisterClass(TStepIdCardHS100UCForm);

end.
