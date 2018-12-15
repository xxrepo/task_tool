unit donix.steps.uStepNullForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TStepNullForm = class(TStepBasicForm)
  private
    { Private declarations }
  public
    { Public declarations }
    //procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepNullForm: TStepNullForm;

implementation

uses uStepBasic;

{$R *.dfm}


end.
