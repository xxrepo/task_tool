unit donix.steps.uStepDownloadFileForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepDownloadFileForm = class(TStepBasicForm)
    lbl2: TLabel;
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    lblParams: TLabel;
    dbnvgrParams: TDBNavigator;
    dbgrdhInputParams: TDBGridEh;
    cdsRspParams: TClientDataSet;
    dsRspParams: TDataSource;
    mmoUrl: TMemo;
    btnSaveToPath: TRzButtonEdit;
    lblSaveTo: TLabel;
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

uses uStepDownloadFile, uDefines, uFunctions, uDesignTimeDefines, uSelectFolderForm;

{$R *.dfm}

procedure TStepDownloadFileForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepDownloadFile do
  begin
    Url := mmoUrl.Text;
    RequestParams := DataSetToJsonStr(cdsParams);
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
  mmoUrl.Text := LStep.Url;
  JsonToDataSet(LStep.RequestParams, cdsParams);
  btnSaveToPath.Text := LStep.SaveToPath;
end;

initialization
RegisterClass(TStepDownloadFileForm);

finalization
UnRegisterClass(TStepDownloadFileForm);

end.


