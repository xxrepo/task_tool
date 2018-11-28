unit uStepFieldsOper;

interface

uses
  uStepBasic, System.JSON;

type
  TOutResult = record
    Min: Variant;
    Max: Variant;
    Sum: Variant;
    Count: Integer;
    Concat: string;
    Md5: string;
  end;

  TStepFieldsOper = class (TStepBasic)
  private
    FFieldName: string;
    FFieldDataType: string;
    FOperConfigJsonStr: string;

    FOutResult: TOutResult;
    FScaned: Boolean;

    function ScanData: TOutResult;
  protected

    procedure StartSelf; override;

    function GetSelfParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property FieldName: string read FFieldName write FFieldName;
    property FieldDataType: string read FFieldDataType write FFieldDataType;
    property OperConfigJsonStr: string read FOperConfigJsonStr write FOperConfigJsonStr;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines;

{ TStepQuery }

function TStepFieldsOper.GetSelfParamValue(AParamRef, AParamType: string;
  ADefaultValue: Variant): Variant;
begin
  if not FScaned then
    FOutResult := ScanData;

  if AParamRef = 'MAX' then
    Result := FOutResult.Max
  else if AParamRef = 'MIN' then
    Result := FOutResult.Min
  else if AParamRef = 'SUM' then
    Result := FOutResult.Sum
  else if AParamRef = 'CONCAT' then
    Result := FOutResult.Concat
  else if AParamRef = 'MD5' then
    Result := FOutResult.Md5
  else if AParamRef = 'COUNT' then
    Result := FOutResult.Count
  else
    Result := ADefaultValue;
end;

procedure TStepFieldsOper.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('field_name', FFieldName));
  AToConfig.AddPair(TJSONPair.Create('field_data_type', FFieldDataType));
  AToConfig.AddPair(TJSONPair.Create('oper_config', FOperConfigJsonStr));
end;


procedure TStepFieldsOper.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFieldName := GetJsonObjectValue(StepConfig.ConfigJson, 'field_name');
  FFieldDataType := GetJsonObjectValue(StepConfig.ConfigJson, 'field_data_type');
  FOperConfigJsonStr := GetJsonObjectValue(StepConfig.ConfigJson, 'oper_config');
end;



function TStepFieldsOper.ScanData: TOutResult;
var
  i: Integer;
  LRow: TJSONObject;
  LRows: TJSONArray;
  LFieldValue: Variant;
  LTargetData: TStepData;
  LFieldNames: TStringList;
  LStepDataRef, LFieldName: string;

  function ScanRow(ARowJson: TJSONObject): TOutResult;
  begin
    if ARowJson = nil then Exit;

    Result.Min := GetJsonObjectValue(ARowJson, LFieldName);
    Result.Max := GetJsonObjectValue(ARowJson, LFieldName);
    Result.Sum := GetJsonObjectValue(ARowJson, LFieldName);
    Result.Count := 1;
    if FFieldDataType = 'string' then
      Result.Concat := QuotedStr(GetJsonObjectValue(ARowJson, LFieldName))
    else
      Result.Concat := GetJsonObjectValue(ARowJson, LFieldName);

    //Edited by ToString
    Result.Md5 := Md5String(ARowJson.ToJSON);
  end;
begin
  Result.Count := 0;

  //根据fieldName取数据集
  LFieldNames := TStringList.Create;
  try
    LFieldNames.Delimiter := '.';
    LFieldNames.DelimitedText := FFieldName;
    if LFieldNames.Count = 1  then
    begin
      LStepDataRef := 'parent';
      LFieldName := FFieldName;
    end
    else if LFieldNames.Count > 1 then
    begin
      LFieldName := LFieldNames.Strings[LFieldNames.Count - 1];
      LFieldNames.Delete(LFieldNames.Count - 1);
      LStepDataRef := LFieldNames.DelimitedText;
    end;
  finally
    LFieldNames.Free;
  end;
  LTargetData := GetStepDataFrom(LStepDataRef);

  FScaned := True;

  //循环遍历整个INDATA，依次计算整个min, max, 以及用 , 分隔的concat, 同时计算这个分隔的concat的md5
  LRows := TJSONObject.ParseJSONValue(LTargetData.Data) as TJSONArray;
  if (LRows = nil) then Exit;
  if (LRows.Count = 0) then
  begin
    LRows.Free;
    Exit;
  end;

  try
    Result := ScanRow(LRows.Items[0] as TJSONObject);
    for i := 1 to LRows.Count - 1 do
    begin
      CheckTaskStatus;

      LRow := LRows.Items[i] as TJSONObject;
      LFieldValue := GetJsonObjectValue(LRow, LFieldName);


      if FFieldDataType = 'string' then
        Result.Concat := Result.Concat + ',' + QuotedStr(LFieldValue)
      else
        Result.Concat := Result.Concat + ',' + LFieldValue;

      //数据转换
      LFieldValue := VariantValueByDataType(LFieldValue, FFieldDataType);

      if LFieldValue > VariantValueByDataType(Result.Max, FFieldDataType) then
        Result.Max := LFieldValue;
      if LFieldValue < VariantValueByDataType(Result.Min, FFieldDataType) then
        Result.Min := LFieldValue;
      Result.Sum := VariantValueByDataType(Result.Sum, FFieldDataType) + LFieldValue;
    end;
  finally
    Result.Count := LRows.Count;
    Result.Md5 := Md5String(LTargetData.Data);
    LRows.Free;
  end;
end;


procedure TStepFieldsOper.StartSelf;
var
  i: Integer;
  LOperConfigJson: TJSONArray;
  LOperConfigRow, LOutJson: TJSONObject;
begin
  try
    CheckTaskStatus;

    LOperConfigJson := TJSONObject.ParseJSONValue(FOperConfigJsonStr) as TJSONArray;
    if LOperConfigJson = nil then Exit;

    LOutJson := TJSONObject.Create;
    try
      for i := 0 to LOperConfigJson.Count - 1 do
      begin
        LOperConfigRow := LOperConfigJson.Items[i] as TJSONObject;

        LOutJson.AddPair(TJSONPair.Create(
                  GetJsonObjectValue(LOperConfigRow, 'param_name'),
                  GetParamValue(LOperConfigRow)));
      end;
    finally
      //Edited by ToString
      FOutData.DataType := sdtText;
      FOutData.Data := LOutJson.ToJSON;

      LOutJson.Free;
      LOperConfigJson.Free;
    end;

  finally

  end;
end;

end.

