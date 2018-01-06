unit uStepBasicForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, uBasicForm, uStepBasic, RzTabs, uTaskVar;

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
  protected
  public
    { Public declarations }
    TaskVar: TTaskVar;
    Step: TStepBasic;

    function CreateStep(AStepClass: TStepClass): TStepBasic;

    //对step进行赋值，同时可以对本form中的字段进行赋值
    procedure ParseStepConfig(AConfigJsonStr: string = ''); virtual;
  end;

var
  StepBasicForm: TStepBasicForm;

implementation

uses uFunctions, uDesignTimeDefines, uFileUtil;

{$R *.dfm}

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


function TStepBasicForm.CreateStep(AStepClass: TStepClass): TStepBasic;
begin
  Result := (AStepClass.NewInstance as TStepBasic).Create(TaskVar);
end;

procedure TStepBasicForm.FormDestroy(Sender: TObject);
begin
  inherited;
  if Step <> nil then
    FreeAndNil(Step);
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
