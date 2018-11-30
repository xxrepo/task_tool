unit donix.steps.uStepsRegisterExt;

interface

uses uStepFactory;

type
  TStepsRegisterExt = class
  public
    class procedure RegSteps;
  end;

implementation

uses uFunctions, uDefines,
  uStepIdCardHS100UC,
  uStepIdCardHS100UCForm;

{ TStepsRegisterCore }

class procedure TStepsRegisterExt.RegSteps;
var
  LStepRegisterRec: TStepRegisterRec;
begin
  LStepRegisterRec.StepGroup := '设备';
  LStepRegisterRec.StepType := 'core|DEVICE_IDCARD_HS100UC';
  LStepRegisterRec.StepTypeName := '身份证读卡器-华视100UC';
  LStepRegisterRec.StepClassName := 'TStepIdCardHS100UC';
  LStepRegisterRec.StepClass := TStepIdCardHS100UC;
  LStepRegisterRec.FormClassName := 'TStepIdCardHS100UCForm';
  LStepRegisterRec.FormClass := TStepIdCardHS100UCForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);
end;

initialization
  TStepsRegisterExt.RegSteps;
end.
