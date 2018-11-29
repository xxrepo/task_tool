unit uStepFieldsMap;

interface

uses
  uStepBasic, System.JSON;

type
  TStepFieldsMap = class (TStepBasic)
  private
    FDataRef: string;
    FMapConfigJsonStr: string;
  protected

    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property DataRef: string read FDataRef write FDataRef;
    property MapConfigJsonStr: string read FMapConfigJsonStr write FMapConfigJsonStr;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines, uFileLogger;

{ TStepQuery }

procedure TStepFieldsMap.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('data_ref', FDataRef));
  AToConfig.AddPair(TJSONPair.Create('map_config', FMapConfigJsonStr));
end;


procedure TStepFieldsMap.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDataRef := GetJsonObjectValue(StepConfig.ConfigJson, 'data_ref');
  FMapConfigJsonStr := GetJsonObjectValue(StepConfig.ConfigJson, 'map_config');
end;


procedure TStepFieldsMap.StartSelf;
var
  i, j: Integer;
  LMapConfigJson: TJSONArray;
  LOutJsonRow, LInJsonRow, LMapConfig: TJSONObject;
  LOutJsonArray, LInJsonArray: TJSONArray;
  LParamName, LParamRef, LParamValue, LParamDefault, LParamType: string;
begin
  try
    CheckTaskStatus;

    //获取数据来源，并且解析生成特定的二维数组JsonArray
    LInJsonArray := TJSONObject.ParseJSONValue(GetParamValue(FDataRef, 'string', '')) as TJSONArray;
    if (LInJsonArray = nil) or (LInJsonArray.Count = 0) then
    begin
      LogMsg('没有数据记录被转化', TLogLevel.llWarn);
      Exit;
    end;

    LMapConfigJson := TJSONObject.ParseJSONValue(FMapConfigJsonStr) as TJSONArray;
    if LMapConfigJson = nil then Exit;

    LOutJsonArray := TJSONArray.Create;
    try
      for i := 0 to LInJsonArray.Count - 1 do
      begin
        LOutJsonRow := TJSONObject.Create;
        LInJsonRow := LInJsonArray.Get(i) as TJSONObject;
        //Map
        for j := 0 to LMapConfigJson.Count - 1 do
        begin
          LMapConfig := LMapConfigJson.Get(j) as TJSONObject;
          LParamName := GetJsonObjectValue(LMapConfig, 'param_name');
          LParamRef := GetJsonObjectValue(LMapConfig, 'param_value_ref');
          if LInJsonRow.GetValue(LParamRef) = nil then
          begin
            LParamValue := GetParamValue(LMapConfig);
          end
          else
          begin
            LParamDefault := GetJsonObjectValue(LMapConfig, 'default_value');
            LParamType := GetJsonObjectValue(LMapConfig, 'param_type');
            LParamValue := GetJsonObjectValue(LInJsonRow, LParamRef, LParamDefault, LParamType);
          end;
          LOutJsonRow.AddPair(LParamName, LParamValue);
        end;
        LOutJsonArray.AddElement(LOutJsonRow);
      end;
    finally
      //Edited by ToString
      FOutData.DataType := sdtJsonArray;
      FOutData.Data := LOutJsonArray.ToJSON;
      FOutData.JsonValue := LOutJsonArray;

      if LMapConfigJson <> nil then
        LMapConfigJson.Free;
    end;

  finally
    if LInJsonArray <> nil then
      LInJsonArray.Free;
  end;
end;

end.

