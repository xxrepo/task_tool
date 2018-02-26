unit uStepWriteTxtFileForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepWriteTxtFile, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepWriteTxtFileForm = class(TStepBasicForm)
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
  StepWriteTxtFileForm: TStepWriteTxtFileForm;

implementation

uses uDesignTimeDefines;

{$R *.dfm}

procedure TStepWriteTxtFileForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepWriteTxtFile do
  begin
    ToFileName := btnToFileName.Text;
  end;
end;

procedure TStepWriteTxtFileForm.btnToFileNameButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenToFileName.InitialDir := ExtractFileDir(TDesignUtil.GetRealAbsolutePath(btnToFileName.Text));
  if dlgOpenToFileName.Execute then
  begin
    btnToFileName.Text := TDesignUtil.GetRelativePathToProject(dlgOpenToFileName.FileName);
  end;
end;

procedure TStepWriteTxtFileForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepWriteTxtFile;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepWriteTxtFile(Step);
  btnToFileName.Text := LStep.ToFileName;
end;


initialization
RegisterClass(TStepWriteTxtFileForm);

finalization
UnRegisterClass(TStepWriteTxtFileForm);

end.


