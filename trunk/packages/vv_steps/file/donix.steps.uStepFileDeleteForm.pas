unit donix.steps.uStepFileDeleteForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  RzShellDialogs;

type
  TStepFileDeleteForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnPath: TRzButtonEdit;
    dlgfldSelectorPath: TRzSelectFolderDialog;
    lbl3: TLabel;
    lbl4: TLabel;
    edtFilter: TEdit;
    edtDeleteBeforeTime: TEdit;
    chkRecursive: TCheckBox;
    lbl5: TLabel;
    lbl6: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnPathButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepFileDeleteForm: TStepFileDeleteForm;

implementation

uses uDesignTimeDefines, uDefines, uStepFileDelete;

{$R *.dfm}

procedure TStepFileDeleteForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepFileDelete do
  begin
    Path := btnPath.Text;
    Filter := edtFilter.Text;
    Recursive := chkRecursive.Checked;
    DeleteBeforeTime := StrToIntDef(edtDeleteBeforeTime.Text, 86400 * 7);
  end;
end;

procedure TStepFileDeleteForm.btnPathButtonClick(Sender: TObject);
begin
  inherited;
  dlgfldSelectorPath.BaseFolder.PathName := ExePath;
  if dlgfldSelectorPath.Execute then
  begin
    btnPath.Text := TDesignUtil.GetRelativePathToProject(dlgfldSelectorPath.SelectedPathName);
  end;
end;

procedure TStepFileDeleteForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepFileDelete;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepFileDelete(Step);
  btnPath.Text := LStep.Path;
  chkRecursive.Checked := LStep.Recursive;
  edtFilter.Text := LStep.Filter;
  edtDeleteBeforeTime.Text := IntToStr(LStep.DeleteBeforeTime);
end;


initialization
RegisterClass(TStepFileDeleteForm);

finalization
UnRegisterClass(TStepFileDeleteForm);

end.


