unit uStepDownloadFileForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, uStepDownloadFile, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TStepDownloadFileForm = class(TStepBasicForm)
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
  StepDownloadFileForm: TStepDownloadFileForm;

implementation

uses uDesignTimeDefines, uDefines, uFunctions, uSelectFolderForm;

{$R *.dfm}

procedure TStepDownloadFileForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepDownloadFile do
  begin
    SrcFileUrl := edtSrcFileUrl.Text;
    SaveToPath := btnSaveToPath.Text;
  end;
end;

procedure TStepDownloadFileForm.btnSaveToPathButtonClick(Sender: TObject);
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

procedure TStepDownloadFileForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepDownloadFile;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepDownloadFile(Step);
  edtSrcFileUrl.Text := LStep.SrcFileUrl;
  btnSaveToPath.Text := LStep.SaveToPath;
end;


initialization
RegisterClass(TStepDownloadFileForm);

finalization
UnRegisterClass(TStepDownloadFileForm);

end.


