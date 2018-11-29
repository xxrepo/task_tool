unit uStepTxtFileReaderForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepTxtFileReader, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepTxtFileReaderForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnToFileName: TRzButtonEdit;
    dlgOpenToFileName: TOpenDialog;
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
  StepTxtFileReaderForm: TStepTxtFileReaderForm;

implementation

uses uDesignTimeDefines;

{$R *.dfm}

procedure TStepTxtFileReaderForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepTxtFileReader do
  begin
    ToFileName := btnToFileName.Text;
  end;
end;

procedure TStepTxtFileReaderForm.btnToFileNameButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenToFileName.InitialDir := ExtractFileDir(TDesignUtil.GetRealAbsolutePath(btnToFileName.Text));
  if dlgOpenToFileName.Execute then
  begin
    btnToFileName.Text := TDesignUtil.GetRelativePathToProject(dlgOpenToFileName.FileName);
  end;
end;

procedure TStepTxtFileReaderForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepTxtFileReader;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepTxtFileReader(Step);
  btnToFileName.Text := LStep.ToFileName;
end;


initialization
RegisterClass(TStepTxtFileReaderForm);

finalization
UnRegisterClass(TStepTxtFileReaderForm);

end.


