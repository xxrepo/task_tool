unit uStepTxtFileWriterForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepTxtFileWriter, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepTxtFileWriterForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnToFileName: TRzButtonEdit;
    dlgOpenToFileName: TOpenDialog;
    chkRewrite: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnToFileNameButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepTxtFileWriterForm: TStepTxtFileWriterForm;

implementation

uses uDesignTimeDefines;

{$R *.dfm}

procedure TStepTxtFileWriterForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepTxtFileWriter do
  begin
    ToFileName := btnToFileName.Text;
    RewriteExist := chkRewrite.Checked;
  end;
end;

procedure TStepTxtFileWriterForm.btnToFileNameButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenToFileName.InitialDir := ExtractFileDir(TDesignUtil.GetRealAbsolutePath(btnToFileName.Text));
  if dlgOpenToFileName.Execute then
  begin
    btnToFileName.Text := TDesignUtil.GetRelativePathToProject(dlgOpenToFileName.FileName);
  end;
end;

procedure TStepTxtFileWriterForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepTxtFileWriter;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepTxtFileWriter(Step);
  btnToFileName.Text := LStep.ToFileName;
  chkRewrite.Checked := LStep.RewriteExist;
end;


initialization
RegisterClass(TStepTxtFileWriterForm);

finalization
UnRegisterClass(TStepTxtFileWriterForm);

end.


