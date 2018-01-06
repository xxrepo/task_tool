unit uStepSubTaskForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepSubTask, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepSubTaskForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnFileName: TRzButtonEdit;
    dlgOpenToFileName: TOpenDialog;
    btnEdit: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnFileNameButtonClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepSubTaskForm: TStepSubTaskForm;

implementation

uses uDesignTimeDefines, uFunctions, uTaskEditForm;

{$R *.dfm}

procedure TStepSubTaskForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepSubTask do
  begin
    SubTaskFile := btnFileName.Text;
  end;
end;

procedure TStepSubTaskForm.btnEditClick(Sender: TObject);
begin
  inherited;
  //获取当前的文件
  with TTaskEditForm.Create(nil) do
  try
    ConfigTask(TDesignUtil.GetRealAbsolutePath(btnFileName.Text));
    ShowModal;
  finally
    Free;
  end;
end;

procedure TStepSubTaskForm.btnFileNameButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenToFileName.InitialDir := ExtractFileDir(TDesignUtil.GetRealAbsolutePath(btnFileName.Text));
  if dlgOpenToFileName.Execute then
  begin
    if dlgOpenToFileName.FileName = TaskVar.TaskVarRec.FileName then
    begin
      ShowMsg('子任务不能是任务自身或者循环引用！');
      Exit;
    end;
    btnFileName.Text := TDesignUtil.GetRelativePathToProject(dlgOpenToFileName.FileName);
  end;
end;

procedure TStepSubTaskForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepSubTask;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepSubTask(Step);
  btnFileName.Text := LStep.SubTaskFile;
end;


initialization
RegisterClass(TStepSubTaskForm);

finalization
UnRegisterClass(TStepSubTaskForm);

end.


