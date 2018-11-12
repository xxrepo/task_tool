unit uStepJson2DataSet;

interface

uses
  uStepBasic, System.JSON, Datasnap.DBClient, Data.DB, System.Classes;

type
  TStepJsonDataSet = class (TStepBasic)
  private
    FClientDataSet: TClientDataSet;
    FDataSource: TDataSource;

    //
    FDataRef: string;
    FFieldsDefStr: string;
    FMasterSourceName: string;
    FIndexedFieldNames: string;
    FMasterFields: string;
    FCreateDataSource: Boolean;

    function CreateDataSet: Boolean;

  protected
    procedure StartSelf; override;
    procedure StartSelfDesign; override;

  public
    destructor Destroy; override;

    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property DataRef: string read FDataRef write FDataRef;
    property FieldsDefStr: string read FFieldsDefStr write FFieldsDefStr;
    property IndexedFieldNames: string read FIndexedFieldNames write FIndexedFieldNames;
    property MasterSourceName: string read FMasterSourceName write FMasterSourceName;
    property MasterFields: string read FMasterFields write FMasterFields;
    property CreateDataSource: Boolean read FCreateDataSource write FCreateDataSource;
  end;

implementation

uses
  uDefines, uFunctions, System.SysUtils, uExceptions, uStepDefines;

{ TStepQuery }

destructor TStepJsonDataSet.Destroy;
begin
  if FDataSource <> nil then
    FreeAndNil(FDataSource);
  if FClientDataSet <> nil then
    FreeAndNil(FClientDataSet);
  inherited;
end;

procedure TStepJsonDataSet.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('data_ref', FDataRef));
  AToConfig.AddPair(TJSONPair.Create('fields_def', FFieldsDefStr));
  AToConfig.AddPair(TJSONPair.Create('indexed_field_names', FIndexedFieldNames));
  AToConfig.AddPair(TJSONPair.Create('create_data_source', BoolToStr(FCreateDataSource)));
  AToConfig.AddPair(TJSONPair.Create('master_source_name', FMasterSourceName));
  AToConfig.AddPair(TJSONPair.Create('master_fields', FMasterFields));
end;


procedure TStepJsonDataSet.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDataRef := GetJsonObjectValue(StepConfig.ConfigJson, 'data_ref');
  FFieldsDefStr := GetJsonObjectValue(StepConfig.ConfigJson, 'fields_def');
  FIndexedFieldNames := GetJsonObjectValue(StepConfig.ConfigJson, 'indexed_field_names');
  FCreateDataSource := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'create_data_source'), False);
  FMasterSourceName := GetJsonObjectValue(StepConfig.ConfigJson, 'master_source_name');
  FMasterFields := GetJsonObjectValue(StepConfig.ConfigJson, 'master_fields');
end;



function TStepJsonDataSet.CreateDataSet: Boolean;
var
  LFieldsDefJson: TJSONArray;
  LFieldDefJson: TJSONObject;
  i: Integer;
begin
  Result := False;
  if FClientDataSet <> nil then
    FreeAndNil(FClientDataSet);

  LFieldsDefJson := TJSONObject.ParseJSONValue(FFieldsDefStr) as TJSONArray;
  if LFieldsDefJson = nil then Exit;

  try
    FClientDataSet := TClientDataSet.Create(nil);
    FClientDataSet.Name := 'cds_' + IntToStr(StepConfig.StepId);
    for i := 0 to LFieldsDefJson.Count - 1 do
    begin
      LFieldDefJson := LFieldsDefJson.Items[i] as TJSONObject;
      if LFieldDefJson = nil then
        StopExceptionRaise(Self.ClassName + ' 异常：数据集定义错误');

      with FClientDataSet.FieldDefs.AddFieldDef do
      begin
        Name := GetJsonObjectValue(LFieldDefJson, 'field_name');
        DataType := TFieldType(GetJsonObjectValue(LFieldDefJson, 'data_type'));
        if DataType = ftString then
          Size := GetJsonObjectValue(LFieldDefJson, 'size', '32', 'int');
      end;
    end;

    if FClientDataSet.FieldDefs.Count > 0 then
    begin
      FClientDataSet.CreateDataSet;
      FClientDataSet.Open;
      Result := True;
    end;
  finally
    LFieldsDefJson.Free;
  end;

end;


procedure TStepJsonDataSet.StartSelfDesign;
begin
  if not CreateDataSet then
  begin
    Exit;
  end;

  //设置ClientDataSet的各种属性
  FClientDataSet.MasterSource := TDataSource(TaskVar.GetObject(FMasterSourceName + '_DATASOURCE'));

  if TaskVar.RegObject(StepConfig.StepTitle, FClientDataSet) = -1 then
      StopExceptionRaise('注册数据集失败');

  if FCreateDataSource then
  begin
    FDataSource := TDataSource.Create(nil);
    FDataSource.DataSet := FClientDataSet;
    TaskVar.RegObject(StepConfig.StepTitle + '_DATASOURCE', FDataSource);
  end;
end;


procedure TStepJsonDataSet.StartSelf;
var
  LDataSetStr: string;
begin
  try
    CheckTaskStatus;

    //创建ClientDataSet
    if not CreateDataSet then
    begin
      StopExceptionRaise('打开DataSet数据集失败');
    end;

    //设置ClientDataSet的各种属性
    FClientDataSet.MasterFields := FMasterFields;
    FClientDataSet.IndexFieldNames := FIndexedFieldNames;
    FClientDataSet.MasterSource := TDataSource(TaskVar.GetObject(FMasterSourceName + '_DATASOURCE'));

    //赋值数据
    LDataSetStr := GetParamValue(FDataRef, 'string', '');
    TaskVar.Logger.Debug(FormatLogMsg('DataSet加载源数据：' + FDataRef + '：' + LDataSetStr));
    JsonToDataSet(LDataSetStr, FClientDataSet);

    //本身注册到Task中，相当于一个临时变量
    if TaskVar.RegObject(StepConfig.StepTitle, FClientDataSet) = -1 then
      StopExceptionRaise('注册数据集失败');

    if FCreateDataSource then
    begin
      FDataSource := TDataSource.Create(nil);
      FDataSource.DataSet := FClientDataSet;
      TaskVar.RegObject(StepConfig.StepTitle + '_DATASOURCE', FDataSource);
    end;
  finally

  end;
end;

end.

