unit uStepFastReport;

interface

uses
  uStepBasic, System.JSON, Datasnap.DBClient, Data.DB, frxClass, frxBarcode, frxDBSet, frxRich,
  System.Classes;

type
  TStepFastReport = class (TStepBasic)
  private
    FReporter: TfrxReport;
    FDBDatasets: TStringList;
    //
    FDBDataSetsConfigStr: string;
    FDBVariablesConfigStr: string;
    FPreview: Boolean;
    FPrinterName: string;
    FReportFile: string;
    FAbsoluteReportFile: string;
  protected
    procedure StartSelf; override;
    procedure StartSelfDesign; override;
  public
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
  uDefines, uFunctions, System.SysUtils, uExceptions, uStepDefines;

{ TStepQuery }

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
    for i := FDBDatasets.Count - 1 downto 0 do
    begin
      TfrxDBDataset(FDBDatasets.Objects[i]).Free;
    end;
    FDBDatasets.Free;
  end;
  inherited;
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
  LDBDataSetsJsonArray: TJSONArray;
  LDBDataSetConfigJson: TJSONObject;
  i: Integer;
begin
  try
    RegisterClass(TfrxDBDataSet);
    FReporter := TfrxReport.Create(nil);

    //创建datasets
    FReporter.DataSets.Clear;
    LDBDataSetsJsonArray := TJSONObject.ParseJSONValue(FDBDataSetsConfigStr) as TJSONArray;
    if LDBDataSetsJsonArray <> nil then
    begin
      FDBDatasets := TStringList.Create;
      for i := 0 to LDBDataSetsJsonArray.Count - 1 do
      begin
        LDBDataSetConfigJson := LDBDataSetsJsonArray.Items[i] as TJSONObject;

        LDBDataSet := TfrxDBDataset.Create(nil);
        LDBDataSet.UserName := GetJsonObjectValue(LDBDataSetConfigJson, 'frx_dataset_name');
        LDBDataSet.DataSet := TClientDataSet(TaskVar.GetObject(GetJsonObjectValue(LDBDataSetConfigJson, 'dataset_object_ref')));

        FReporter.DataSets.Add(LDBDataSet);
        FDBDatasets.AddObject(LDBDataSet.UserName, LDBDataSet);
      end;
    end;

    //创建加载各个variables
    if (TaskVar.ToStepId = StepConfig.StepId) and FileExists(FAbsoluteReportFile) then
      FReporter.LoadFromFile(FAbsoluteReportFile);
  finally
    if LDBDataSetsJsonArray <> nil then
      FreeAndNil(LDBDataSetsJsonArray);
  end;
end;

procedure TStepFastReport.StartSelf;
var
  LDBDataSet: TfrxDBDataset;
  LDBDataSetsJsonArray: TJSONArray;
  LDBDataSetConfigJson: TJSONObject;
  i: Integer;
begin
  try
    CheckTaskStatus;

    RegisterClass(TfrxDBDataSet);
    FReporter := TfrxReport.Create(nil);

    //创建datasets
    FReporter.DataSets.Clear;
    LDBDataSetsJsonArray := TJSONObject.ParseJSONValue(FDBDataSetsConfigStr) as TJSONArray;
    if LDBDataSetsJsonArray <> nil then
    begin
      FDBDatasets := TStringList.Create;
      for i := 0 to LDBDataSetsJsonArray.Count - 1 do
      begin
        LDBDataSetConfigJson := LDBDataSetsJsonArray.Items[i] as TJSONObject;

        LDBDataSet := TfrxDBDataset.Create(nil);
        LDBDataSet.UserName := GetJsonObjectValue(LDBDataSetConfigJson, 'frx_dataset_name');
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


    //创建加载各个variables
    FReporter.LoadFromFile(FAbsoluteReportFile);

    //根据预览进行打印输出，运行在service的情况下不能提供预览功能，只能直接输出到指定的文件夹
    FReporter.PrepareReport;

    FReporter.ShowReport;
  finally
    if LDBDataSetsJsonArray <> nil then
      FreeAndNil(LDBDataSetsJsonArray);
  end;
end;

end.

