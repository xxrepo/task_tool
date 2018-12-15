unit donix.steps.uStepFastReportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, Data.DB, Datasnap.DBClient,
  RzLabel, frxClass, frxDesgn, frxBarcode, frxDBSet, frxRich;

type
  TStepFastReportForm = class(TStepBasicForm)
    lbl2: TLabel;
    cdsDatasetParams: TClientDataSet;
    dsDatasetParams: TDataSource;
    lbl5: TLabel;
    edtPrinterName: TEdit;
    chkPreview: TCheckBox;
    btnReportFile: TRzButtonEdit;
    dlgOpenFileName: TOpenDialog;
    btnDesign: TButton;
    rztbshtData: TRzTabSheet;
    lblParams: TLabel;
    dbnvgrDatasetParams: TDBNavigator;
    dbgrdhDatasetParams: TDBGridEh;
    lbl3: TLabel;
    dbnvgrVarParams: TDBNavigator;
    dbgrdhVarParams: TDBGridEh;
    dsVarParams: TDataSource;
    cdsVarParams: TClientDataSet;
    frxrprt1: TfrxReport;
    procedure btnOKClick(Sender: TObject);
    procedure btnReportFileButtonClick(Sender: TObject);
    procedure btnDesignClick(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepFastReportForm: TStepFastReportForm;

implementation

uses uFunctions, uDesignTimeDefines, uStepFastReport, uStepFormSettings;

{$R *.dfm}

procedure TStepFastReportForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepFastReport do
  begin
    DBDataSetsConfigStr := DataSetToJsonStr(cdsDatasetParams);
    DBVariablesConfigStr := DataSetToJsonStr(cdsVarParams);
    ReportFile := btnReportFile.Text;
    Preview := chkPreview.Checked;
    PrinterName := edtPrinterName.Text;
  end;
end;

procedure TStepFastReportForm.btnReportFileButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenFileName.InitialDir := ExtractFileDir(btnReportFile.Text);
  if dlgOpenFileName.Execute then
  begin
    btnReportFile.Text := TDesignUtil.GetRelativePathToProject(dlgOpenFileName.FileName);
  end;
end;

procedure TStepFastReportForm.btnDesignClick(Sender: TObject);
var
  LStep: TStepFastReport;
begin
  inherited;
  LStep := TStepFastReport(Step);

  LStep.Reporter.DesignReport;
end;

procedure TStepFastReportForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepFastReport;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepFastReport(Step);
  chkPreview.Checked := LStep.Preview;
  edtPrinterName.Text := LStep.PrinterName;
  btnReportFile.Text := LStep.ReportFile;
  JsonToDataSet(LStep.DBDataSetsConfigStr, cdsDatasetParams);
  JsonToDataSet(LStep.DBVariablesConfigStr, cdsVarParams);

  dbgrdhDatasetParams.Columns.FindColumnByName('Column_1_dataset_object_ref').PickList.Text :=
           TStepFormSettings.GetRegistedObjectStrings(TaskVar).PickList;
end;


end.


