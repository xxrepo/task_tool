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
  uStepIdCardHS100UCForm,
  uStepTest,
  uStepTestForm;

{ TStepsRegisterCore }

class procedure TStepsRegisterExt.RegSteps;
var
  LStepRegisterRec: TStepRegisterRec;
begin
  LStepRegisterRec.StepGroup := '设备';
  LStepRegisterRec.StepType := 'ext|DEVICE_IDCARD_HS100UC';
  LStepRegisterRec.StepTypeName := '身份证读卡器-华视100UC';
  LStepRegisterRec.StepClassName := 'TStepIdCardHS100UC';
  LStepRegisterRec.StepClass := TStepIdCardHS100UC;
  LStepRegisterRec.FormClassName := 'TStepIdCardHS100UCForm';
  LStepRegisterRec.FormClass := TStepIdCardHS100UCForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '测试';
  LStepRegisterRec.StepType := 'ext|TEST_EVENT_TIMER';
  LStepRegisterRec.StepTypeName := '测试时间';
  LStepRegisterRec.StepClassName := 'TStepTest';
  LStepRegisterRec.StepClass := TStepTest;
  LStepRegisterRec.FormClassName := 'TStepTestForm';
  LStepRegisterRec.FormClass := TStepTestForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);
end;

initialization
  TStepsRegisterExt.RegSteps;
end.
