unit uStepReportMachine;

interface

uses
  uStepBasic, System.JSON, Datasnap.DBClient, Data.DB,
  RM_GridReport, RM_Class, RM_Common, RM_Designer, RM_DsgGridReport, RM_Dataset,
  System.Classes, uTaskVar;

type
  TStepReportMachine = class(TStepBasic)
  private
    FReporter: TRMReport;
    FDBDatasets: TStringList;
    FDBVariables: TJSONObject;

    //
    FDBDataSetsConfigStr: string;
    FDBVariablesConfigStr: string;
    FPreview: Boolean;
    FPrinterName: string;
    FReportFile: string;
    FAbsoluteReportFile: string;
    procedure OnReporterGetValue(const VarName: string; var Value: Variant);
    function NewReporteInstance: TRMReport;
    function GetReporter: TRMReport;
  protected
    procedure StartSelf; override;
    procedure StartSelfDesign; override;
  public
    constructor Create(ATaskVar: TTaskVar); override;
    destructor Destroy; override;

    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;


    procedure ClearRptDatasets;

    property DBDataSetsConfigStr: string read FDBDataSetsConfigStr write FDBDataSetsConfigStr;
    property DBVariablesConfigStr: string read FDBVariablesConfigStr write FDBVariablesConfigStr;
    property Preview: Boolean read FPreview write FPreview;
    property PrinterName: string read FPrinterName write FPrinterName;
    property ReportFile: string read FReportFile write FReportFile;

    property Reporter: TRMReport read GetReporter write FReporter;
  end;

implementation

uses
  uDefines, uFunctions, System.SysUtils, uExceptions, uStepDefines, Winapi.Windows,
  Vcl.Controls, Vcl.Forms;

{ TStepQuery }

constructor TStepReportMachine.Create(ATaskVar: TTaskVar);
begin
  inherited Create(ATaskVar);
  FDBDatasets := TStringList.Create;
end;

destructor TStepReportMachine.Destroy;

begin
  //释放掉所有的dbdataset
  if FReporter <> nil then
  begin
    FreeAndNil(FReporter);
  end;
  if FDBDatasets <> nil then
  begin
    ClearRptDatasets;
    FreeAndNil(FDBDatasets);
  end;
  if FDBVariables <> nil then
    FreeAndNil(FDBVariables);
  inherited;
end;


function TStepReportMachine.GetReporter: TRMReport;
begin
  Result := FReporter;
end;

procedure TStepReportMachine.ClearRptDatasets;
var
  i: Integer;
begin
  for i := FDBDatasets.Count - 1 downto 0 do
  begin
    if FDBDatasets.Objects[i] <> nil then
      TRMDataset(FDBDatasets.Objects[i]).Free;
  end;
  FDBDatasets.Clear;
end;


procedure TStepReportMachine.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('datasets', FDBDataSetsConfigStr));
  AToConfig.AddPair(TJSONPair.Create('variables', FDBVariablesConfigStr));
  AToConfig.AddPair(TJSONPair.Create('preview', BoolToStr(FPreview)));
  AToConfig.AddPair(TJSONPair.Create('printer_name', FPrinterName));
  AToConfig.AddPair(TJSONPair.Create('report_file', FReportFile));
end;


procedure TStepReportMachine.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDBDataSetsConfigStr := GetJsonObjectValue(StepConfig.ConfigJson, 'datasets');
  FDBVariablesConfigStr := GetJsonObjectValue(StepConfig.ConfigJson, 'variables');
  FPreview := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'preview'), False);
  FPrinterName := GetJsonObjectValue(StepConfig.ConfigJson, 'printer_name');
  FReportFile := GetJsonObjectValue(StepConfig.ConfigJson, 'report_file');

  FAbsoluteReportFile := GetRealAbsolutePath(FReportFile);
end;


procedure TStepReportMachine.StartSelfDesign;
var
  LDataSet: TClientDataSet;
  LRptDataSet: TRMDBDataSet;
  LDBDataSetsJsonArray, LDBVarJsonArray: TJSONArray;
  LDBDataSetConfigJson, LDBVarJsonObj: TJSONObject;
  i: Integer;
begin
  try
    FReporter := NewReporteInstance;

    //创建datasets
    FReporter.Dictionary.Clear;
    LDBDataSetsJsonArray := TJSONObject.ParseJSONValue(FDBDataSetsConfigStr) as TJSONArray;
    if LDBDataSetsJsonArray <> nil then
    begin
      ClearRptDatasets;
      for i := 0 to LDBDataSetsJsonArray.Count - 1 do
      begin
        LDBDataSetConfigJson := LDBDataSetsJsonArray.Items[i] as TJSONObject;

        LDataSet := TClientDataSet(TaskVar.GetObject(GetJsonObjectValue(LDBDataSetConfigJson, 'dataset_object_ref')));
        if LDataSet <> nil then
        begin
          LRptDataSet := TRMDBDataSet.Create(Application.MainForm);
          LRptDataSet.DataSet := LDataSet;
          LRptDataSet.AliasName := GetJsonObjectValue(LDBDataSetConfigJson, 'rpt_dataset_name');
          FDBDatasets.AddObject(LRptDataSet.AliasName, LRptDataSet);

          //FReporter.Dictionary.AddDataSet(LDataSet, LRptDataSet.AliasName);
        end;
      end;
    end;

    LDBVarJsonArray := TJSONObject.ParseJSONValue(FDBVariablesConfigStr) as TJSONArray;
    if LDBVarJsonArray <> nil then
    begin
      FReporter.Dictionary.Variables.AddCategory('自定义变量');
      for i := 0 to LDBVarJsonArray.Count - 1 do
      begin
        LDBVarJsonObj := LDBVarJsonArray.Items[i] as TJSONObject;
        if LDBVarJsonObj = nil then Continue;

        FReporter.Dictionary.Variables[GetJsonObjectValue(LDBVarJsonObj, 'param_name')] := GetParamValue(LDBVarJsonObj);
      end;
    end;

    //创建加载各个variables  (TaskVar.ToStepId = StepConfig.StepId) and
    if FileExists(FAbsoluteReportFile) then
      FReporter.LoadFromFile(FAbsoluteReportFile);
  finally
    if LDBDataSetsJsonArray <> nil then
      FreeAndNil(LDBDataSetsJsonArray);
    if LDBVarJsonArray <> nil then
      FreeAndNil(LDBVarJsonArray);
  end;
end;

procedure TStepReportMachine.StartSelf;
var
  LDataSet: TClientDataset;
  LRptDataSet: TRMDBDataSet;
  LDBDataSetsJsonArray, LDBVarJsonArray: TJSONArray;
  LDBDataSetConfigJson, LDBVarJsonObj: TJSONObject;
  i: Integer;
begin
  try
    CheckTaskStatus;

    FReporter := NewReporteInstance;
    FReporter.OnGetValue := OnReporterGetValue;

    //创建datasets
    //FReporter.Dictionary.Clear;
    LDBDataSetsJsonArray := TJSONObject.ParseJSONValue(FDBDataSetsConfigStr) as TJSONArray;
    if LDBDataSetsJsonArray <> nil then
    begin
      ClearRptDatasets;
      for i := 0 to LDBDataSetsJsonArray.Count - 1 do
      begin
        LDBDataSetConfigJson := LDBDataSetsJsonArray.Items[i] as TJSONObject;
        LDataSet := TClientDataSet(TaskVar.GetObject(GetJsonObjectValue(LDBDataSetConfigJson, 'dataset_object_ref')));
        if LDataSet <> nil then
        begin
          LRptDataSet := TRMDBDataSet.Create(Application.MainForm);
          LRptDataSet.DataSet := LDataSet;
          LRptDataSet.AliasName := GetJsonObjectValue(LDBDataSetConfigJson, 'rpt_dataset_name');
          FDBDatasets.AddObject(LRptDataSet.AliasName, LRptDataSet);

          //FReporter.Dictionary.AddDataSet(LDataSet, LRptDataSet.AliasName);
        end;
      end;
    end;

    LDBVarJsonArray := TJSONObject.ParseJSONValue(FDBVariablesConfigStr) as TJSONArray;
    if LDBVarJsonArray <> nil then
    begin
      FDBVariables := TJSONObject.Create;
      //FReporter.Dictionary.Variables.AddCategory('自定义变量');
      for i := 0 to LDBVarJsonArray.Count - 1 do
      begin
        LDBVarJsonObj := LDBVarJsonArray.Items[i] as TJSONObject;
        if LDBVarJsonObj = nil then Continue;
        FDBVariables.AddPair(TJSONPair.Create(GetJsonObjectValue(LDBVarJsonObj, 'param_name'),
                                  LDBVarJsonObj.Clone as TJSONObject));
        //FReporter.Dictionary.Variables.Add(GetJsonObjectValue(LDBVarJsonObj, 'param_name'), GetParamValue(LDBVarJsonObj));
      end;
    end;

    //创建加载各个variables
    FReporter.LoadFromFile(FAbsoluteReportFile);

    //根据预览进行打印输出，运行在service的情况下不能提供预览功能，只能直接输出到指定的文件夹
    FReporter.PrepareReport;

    FReporter.ShowReport;
  finally
    if LDBDataSetsJsonArray <> nil then
      FreeAndNil(LDBDataSetsJsonArray);
    if LDBVarJsonArray <> nil then
      FreeAndNil(LDBVarJsonArray);
  end;
end;


function TStepReportMachine.NewReporteInstance: TRMReport;
begin
  Result := TRMReport.Create(nil);
  Result.ReportInfo.Title := '测试报表sdfa';
end;


procedure TStepReportMachine.OnReporterGetValue(const VarName: string;
  var Value: Variant);
var
  LVarJsonDefine: TJSONObject;
begin
  if FDBVariables = nil then Exit;

  LVarJsonDefine := FDBVariables.GetValue(VarName) as TJSONObject;
  if LVarJsonDefine <> nil then
  begin
    Value := GetParamValue(LVarJsonDefine);
  end;
end;

end.

