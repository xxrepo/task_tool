unit donix.steps.uStepReportMachineForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, Data.DB, Datasnap.DBClient,
  RzLabel, RM_GridReport,
  RM_Common, RM_Class, RM_Designer, RM_DsgGridReport, RM_Dataset;

type
  TStepReportMachineForm = class(TStepBasicForm)
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
    procedure btnOKClick(Sender: TObject);
    procedure btnReportFileButtonClick(Sender: TObject);
    procedure btnDesignClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepReportMachineForm: TStepReportMachineForm;

implementation

uses uFunctions, uDesignTimeDefines, uStepReportMachine, uStepFormSettings;

{$R *.dfm}

procedure TStepReportMachineForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepReportMachine do
  begin
    DBDataSetsConfigStr := DataSetToJsonStr(cdsDatasetParams);
    DBVariablesConfigStr := DataSetToJsonStr(cdsVarParams);
    ReportFile := btnReportFile.Text;
    Preview := chkPreview.Checked;
    PrinterName := edtPrinterName.Text;
  end;
end;

procedure TStepReportMachineForm.btnReportFileButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenFileName.InitialDir := ExtractFileDir(btnReportFile.Text);
  if dlgOpenFileName.Execute then
  begin
    btnReportFile.Text := TDesignUtil.GetRelativePathToProject(dlgOpenFileName.FileName);
  end;
end;

procedure TStepReportMachineForm.FormDestroy(Sender: TObject);
begin
  inherited;
  TStepReportMachine(Step).ClearRptDatasets;
end;

procedure TStepReportMachineForm.btnDesignClick(Sender: TObject);
var
  LStep: TStepReportMachine;
begin
  inherited;
  LStep := TStepReportMachine(Step);

  LStep.Reporter.DesignReport;
end;

procedure TStepReportMachineForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepReportMachine;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepReportMachine(Step);
  chkPreview.Checked := LStep.Preview;
  edtPrinterName.Text := LStep.PrinterName;
  btnReportFile.Text := LStep.ReportFile;
  JsonToDataSet(LStep.DBDataSetsConfigStr, cdsDatasetParams);
  JsonToDataSet(LStep.DBVariablesConfigStr, cdsVarParams);

  dbgrdhDatasetParams.Columns.FindColumnByName('Column_1_dataset_object_ref').PickList.Text :=
           TStepFormSettings.GetRegistedObjectStrings(TaskVar).PickList;
end;

end.


