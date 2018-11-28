unit uStepUnzipForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepUnzipForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnSaveToPath: TRzButtonEdit;
    lblSaveTo: TLabel;
    edtSrcFileUrl: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnSaveToPathButtonClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepUnzipForm: TStepUnzipForm;

implementation

uses uDesignTimeDefines, uDefines, uStepUnzip, uFunctions, uSelectFolderForm;

{$R *.dfm}

procedure TStepUnzipForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepUnzip do
  begin
    SrcFile := edtSrcFileUrl.Text;
    ToPath := btnSaveToPath.Text;
  end;
end;

procedure TStepUnzipForm.btnSaveToPathButtonClick(Sender: TObject);
begin
  inherited;
  with TSelectFolderForm.Create(nil) do
  try
    RootDir := ExePath;
    if ShowModal = mrOk then
    begin
       btnSaveToPath.Text := TDesignUtil.GetRelativePathToProject(SelectedPath);
    end;
  finally
    Free;
  end;
end;

procedure TStepUnzipForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepUnzip;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepUnzip(Step);
  edtSrcFileUrl.Text := LStep.SrcFile;
  btnSaveToPath.Text := LStep.ToPath;
end;


initialization
RegisterClass(TStepUnzipForm);

finalization
UnRegisterClass(TStepUnzipForm);

end.


