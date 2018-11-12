unit uStepBasicForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, uBasicForm, uStepBasic, RzTabs, uTaskVar, uStepDefines;

type
  TStepBasicForm = class(TBasicDlgForm)
    rzpgcntrlStepSettings: TRzPageControl;
    rztbshtCommon: TRzTabSheet;
    lbl1: TLabel;
    edtStepTitle: TEdit;
    lblDescription: TLabel;
    edtDescription: TEdit;
    chkRegDataToTask: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FOwnedStep: Boolean;
  protected

  public
    { Public declarations }
    TaskVar: TTaskVar;
    Step: TStepBasic;

    //对step进行赋值，同时可以对本form中的字段进行赋值
    procedure ParseStepConfig(AConfigJsonStr: string = ''); virtual;
    procedure GetStepFromStepStack(AStepType: TStepType);
  end;

var
  StepBasicForm: TStepBasicForm;

implementation

uses uFunctions, uDesignTimeDefines, uFileUtil, uStepFactory;

{$R *.dfm}

procedure TStepBasicForm.GetStepFromStepStack(AStepType: TStepType);
begin
  FOwnedStep := False;
  Step := TStepBasic(TaskVar.GetStepFromStack(TaskVar.ToStep));
  if Step = nil then
  begin
    Step := TStepFactory.GetStep(AStepType, TaskVar);
    FOwnedStep := True;
  end;
end;


procedure TStepBasicForm.btnOKClick(Sender: TObject);
begin
  inherited;
  if Trim(edtStepTitle.Text) = '' then
  begin
    ShowMsg('Step标题不能为空');
    ModalResult := mrNone;
  end
  else if (Pos('.', edtStepTitle.Text) > 0)
              or (Pos('|', edtStepTitle.Text) > 0)
              or (Pos(':', edtStepTitle.Text) > 0)
              or (Pos(' ', edtStepTitle.Text) > 0)
              or (Pos('　', edtStepTitle.Text) > 0)
              or (Pos('/', edtStepTitle.Text) > 0)
              or (Pos('\', edtStepTitle.Text) > 0)
              or (Pos('>', edtStepTitle.Text) > 0)
              or (Pos('<', edtStepTitle.Text) > 0)
              or (Pos('?', edtStepTitle.Text) > 0)
              or (Pos('~', edtStepTitle.Text) > 0)
              or (Pos('@', edtStepTitle.Text) > 0)
              or (Pos('"', edtStepTitle.Text) > 0) then
  begin
    ShowMsg('Step标题中不能包含". | / \ < > ? ~ @ #"等特殊符号');
    ModalResult := mrNone;
  end
  else
    Step.StepConfig.StepTitle := edtStepTitle.Text;
  Step.StepConfig.Description := edtDescription.Text;
  Step.StepConfig.RegDataToTask := chkRegDataToTask.Checked;
end;

procedure TStepBasicForm.FormDestroy(Sender: TObject);
begin
  inherited;
  if FOwnedStep then
  begin
    if Step <> nil then
      FreeAndNil(Step);
  end;
end;

procedure TStepBasicForm.ParseStepConfig(AConfigJsonStr: string);
begin
  if Step <> nil then
  begin
    Step.ParseStepConfig(AConfigJsonStr);

    edtStepTitle.Text := Step.StepConfig.StepTitle;
//    if edtStepTitle.Text = '' then
//      edtStepTitle.Text := Self.Caption;
    edtDescription.Text := Step.StepConfig.Description;
    chkRegDataToTask.Checked := Step.StepConfig.RegDataToTask;
  end;
end;

end.
