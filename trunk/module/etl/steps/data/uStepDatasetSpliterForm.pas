unit uStepDatasetSpliterForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepDatasetSpliter, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepDatasetSpliterForm = class(TStepBasicForm)
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtDataRef: TEdit;
    rbSingleObject: TRadioButton;
    rbSubArray: TRadioButton;
    edtCountLimit: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure rbSubArrayClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepDatasetSpliterForm: TStepDatasetSpliterForm;

implementation

{$R *.dfm}

procedure TStepDatasetSpliterForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepDatasetSpliter do
  begin
    DatasetRef := edtDataRef.Text;
    if rbSingleObject.Checked then
    begin
      SplitType := 'single_obj';
    end
    else
      SplitType := 'sub_array';
    CountLimit := StrToIntDef(edtCountLimit.Text, 1);
  end;
end;

procedure TStepDatasetSpliterForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepDatasetSpliter;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepDatasetSpliter(Step);
  edtDataRef.Text := LStep.DatasetRef;
  if LStep.SplitType = 'sub_array' then
  begin
    rbSubArray.Checked := True;
    edtCountLimit.ReadOnly := False;
  end
  else
  begin
    rbSingleObject.Checked := True;
    edtCountLimit.ReadOnly := True;
  end;

  edtCountLimit.Text := IntToStr(LStep.CountLimit);
end;


procedure TStepDatasetSpliterForm.rbSubArrayClick(Sender: TObject);
begin
  inherited;
  if rbSubArray.Checked then
  begin
    edtCountLimit.ReadOnly := False;
  end
  else
  begin
    edtCountLimit.ReadOnly := True;
    edtCountLimit.Text := '1';
  end;
end;

initialization
RegisterClass(TStepDatasetSpliterForm);

finalization
UnRegisterClass(TStepDatasetSpliterForm);

end.


