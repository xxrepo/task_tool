unit uStepFastReport;

interface

uses
  uStepUiBasic, System.JSON, Datasnap.DBClient, Data.DB, frxClass, frxBarcode, frxDBSet, frxRich,
  System.Classes, uTaskVar;

type
  TStepFastReport = class (TStepUiBasic)
  private
    FReporter: TfrxReport;
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
    procedure ClearRptDatasets;
  protected
    procedure StartSelf; override;
    procedure StartSelfDesign; override;
  public
    constructor Create(ATaskVar: TTaskVar); override;
    destructor Destroy; override;

    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property DBDataSetsConfigStr: string read FDBDataSetsConfigStr write FDBDataSetsConfigStr;
    property DBVariablesConfigStr: string read FDBVariablesConfigStr write FDBVariablesConfigStr;
    property Preview: Boolean read FPreview write FPreview;
    property PrinterName: string read FPrinterName write FPrinterName;
    property ReportFile: string read FReportFile write FReportFile;

    property Reporter: TfrxReport read FReporter;
  end;

implementation

uses
  uDefines, uFunctions, System.SysUtils, uExceptions, uStepDefines, Winapi.Windows, uUserNotify, Vcl.Controls;

{ TStepQuery }

constructor TStepFastReport.Create(ATaskVar: TTaskVar);
begin
  inherited Create(ATaskVar);
  FDBDatasets := TStringList.Create;
end;


destructor TStepFastReport.Destroy;
var
  i: Integer;
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

procedure TStepFastReport.ClearRptDatasets;
var
  i: Integer;
begin
  for i := FDBDatasets.Count - 1 downto 0 do
  begin
    if FDBDatasets.Objects[i] <> nil then
      TfrxDataset(FDBDatasets.Objects[i]).Free;
  end;
  FDBDatasets.Clear;
end;


procedure TStepFastReport.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('datasets', FDBDataSetsConfigStr));
  AToConfig.AddPair(TJSONPair.Create('variables', FDBVariablesConfigStr));
  AToConfig.AddPair(TJSONPair.Create('preview', BoolToStr(FPreview)));
  AToConfig.AddPair(TJSONPair.Create('printer_name', FPrinterName));
  AToConfig.AddPair(TJSONPair.Create('report_file', FReportFile));
end;


procedure TStepFastReport.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDBDataSetsConfigStr := GetJsonObjectValue(StepConfig.ConfigJson, 'datasets');
  FDBVariablesConfigStr := GetJsonObjectValue(StepConfig.ConfigJson, 'variables');
  FPreview := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'preview'), False);
  FPrinterName := GetJsonObjectValue(StepConfig.ConfigJson, 'printer_name');
  FReportFile := GetJsonObjectValue(StepConfig.ConfigJson, 'report_file');

  FAbsoluteReportFile := GetRealAbsolutePath(FReportFile);
end;


procedure TStepFastReport.StartSelfDesign;
var
  LDBDataSet: TfrxDBDataset;
  LDBDataSetUserName: string;
  LDBDataSetsJsonArray, LDBVarJsonArray: TJSONArray;
  LDBDataSetConfigJson, LDBVarJsonObj: TJSONObject;
  i: Integer;
begin
  try
    FReporter := TfrxReport.Create(nil);

    //创建datasets
    FReporter.DataSets.Clear;
    LDBDataSetsJsonArray := TJSONObject.ParseJSONValue(FDBDataSetsConfigStr) as TJSONArray;
    if LDBDataSetsJsonArray <> nil then
    begin
      ClearRptDatasets;
      for i := 0 to LDBDataSetsJsonArray.Count - 1 do
      begin
        LDBDataSetConfigJson := LDBDataSetsJsonArray.Items[i] as TJSONObject;
        LDBDataSetUserName := GetJsonObjectValue(LDBDataSetConfigJson, 'rpt_dataset_name');
        LDBDataSet := TfrxDBDataset.Create(nil);
        if LDBDataSetUserName <> '' then
          LDBDataSet.UserName := LDBDataSetUserName;
        LDBDataSet.DataSet := TClientDataSet(TaskVar.GetObject(GetJsonObjectValue(LDBDataSetConfigJson, 'dataset_object_ref')));

        FReporter.DataSets.Add(LDBDataSet);
        FDBDatasets.AddObject(LDBDataSet.UserName, LDBDataSet);
      end;
    end;

    LDBVarJsonArray := TJSONObject.ParseJSONValue(FDBVariablesConfigStr) as TJSONArray;
    if LDBVarJsonArray <> nil then
    begin
      for i := 0 to LDBVarJsonArray.Count - 1 do
      begin
        LDBVarJsonObj := LDBVarJsonArray.Items[i] as TJSONObject;
        if LDBVarJsonObj = nil then Continue;

        with FReporter.Variables.Add do
        begin
          Name := GetJsonObjectValue(LDBVarJsonObj, 'param_name');
          //Value := QuotedStr(GetParamValue(LDBVarJsonObj));
        end;
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

procedure TStepFastReport.StartSelf;
var
  LDBDataSet: TfrxDBDataset;
  LDBDataSetUserName: string;
  LDBDataSetsJsonArray, LDBVarJsonArray: TJSONArray;
  LDBDataSetConfigJson, LDBVarJsonObj: TJSONObject;
  i: Integer;
begin
  try
    CheckTaskStatus;

    FReporter := TfrxReport.Create(nil);
    FReporter.OnGetValue := OnReporterGetValue;

    //创建datasets
    FReporter.DataSets.Clear;
    LDBDataSetsJsonArray := TJSONObject.ParseJSONValue(FDBDataSetsConfigStr) as TJSONArray;
    if LDBDataSetsJsonArray <> nil then
    begin
      ClearRptDatasets;
      for i := 0 to LDBDataSetsJsonArray.Count - 1 do
      begin
        LDBDataSetConfigJson := LDBDataSetsJsonArray.Items[i] as TJSONObject;

        LDBDataSetUserName := GetJsonObjectValue(LDBDataSetConfigJson, 'rpt_dataset_name');
        LDBDataSet := TfrxDBDataset.Create(nil);
        if LDBDataSetUserName <> '' then
          LDBDataSet.UserName := LDBDataSetUserName;
        LDBDataSet.DataSet := TClientDataSet(TaskVar.GetObject(GetJsonObjectValue(LDBDataSetConfigJson, 'dataset_object_ref')));


        if LDBDataSet.DataSet <> nil then
        begin
          FReporter.DataSets.Add(LDBDataSet);
          FDBDatasets.AddObject(LDBDataSet.UserName, LDBDataSet);
          TaskVar.Logger.Debug('数据集记录：' + LDBDataSet.UserName + '；' + IntToStr(LDBDataSet.DataSet.RecordCount));
        end
        else
        begin
          LDBDataSet.Free;
        end;
      end;
    end;

    LDBVarJsonArray := TJSONObject.ParseJSONValue(FDBVariablesConfigStr) as TJSONArray;
    if LDBVarJsonArray <> nil then
    begin
      FDBVariables := TJSONObject.Create;
      for i := 0 to LDBVarJsonArray.Count - 1 do
      begin
        LDBVarJsonObj := LDBVarJsonArray.Items[i] as TJSONObject;
        if LDBVarJsonObj = nil then Continue;

        FDBVariables.AddPair(TJSONPair.Create(GetJsonObjectValue(LDBVarJsonObj, 'param_name'),
                                  LDBVarJsonObj.Clone as TJSONObject));
      end;
    end;

    //创建加载各个variables
    FReporter.LoadFromFile(FAbsoluteReportFile);

    //根据预览进行打印输出，运行在service的情况下不能提供预览功能，只能直接输出到指定的文件夹
    FReporter.PrepareReport;

    //通知Application主窗口已经需要展示ReportPreview，通常由web通知即可
    //TUserNotify.BlockUiNotify('正在为您准备报表 ' + StepConfig.Description);

    FReporter.ShowReport;
  finally
    if LDBDataSetsJsonArray <> nil then
      FreeAndNil(LDBDataSetsJsonArray);
    if LDBVarJsonArray <> nil then
      FreeAndNil(LDBVarJsonArray);
  end;
end;


procedure TStepFastReport.OnReporterGetValue(const VarName: string;
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

