unit donix.steps.uStepVarDefine;
interface

uses
  uStepBasic, System.JSON, System.IniFiles;

type
  TStepVarDefine = class (TStepBasic)
  private
    FFieldParams: string;
  protected
    procedure StartSelf; override;

  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property FieldParams: string read FFieldParams write FFieldParams;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions,
  uStepDefines;

{ TStepQuery }

procedure TStepVarDefine.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('field_params', FFieldParams));
end;


procedure TStepVarDefine.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFieldParams := GetJsonObjectValue(StepConfig.ConfigJson, 'field_params');
end;


procedure TStepVarDefine.StartSelf;
var
  i: Integer;
  LOutDataJson, LFieldJson: TJSONObject;
  LFieldParamsJsonArray: TJSONArray;
begin
  try
    CheckTaskStatus;

    LFieldParamsJsonArray := TJSONObject.ParseJSONValue(FFieldParams) as TJSONArray;
    if LFieldParamsJsonArray = nil then Exit;

    //入参
    LOutDataJson := TJSONObject.Create;
    try
      //处理
      for i := 0 to LFieldParamsJsonArray.Count - 1 do
      begin
        LFieldJson := LFieldParamsJsonArray.Items[i] as TJSONObject;
        if LFieldJson = nil then Continue;

        LOutDataJson.AddPair(TJSONPair.Create(
                   GetJsonObjectValue(LFieldJson, 'param_name'),
                   GetParamValue(LFieldJson)));
      end;

      //出参
      //Edited by ToString
      FOutData.DataType := sdtText;
      FOutData.Data := LOutDataJson.ToJSON;
    finally
      LOutDataJson.Free;
      //LIniFile := nil;
      LFieldParamsJsonArray.Free;
    end;
  finally

  end;
end;



end.
