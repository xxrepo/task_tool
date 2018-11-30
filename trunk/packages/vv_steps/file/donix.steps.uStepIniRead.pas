unit donix.steps.uStepIniRead;
interface

uses
  uStepBasic, System.JSON, System.IniFiles;

type
  TStepIniRead = class (TStepBasic)
  private
    FFileName: string;
    FRealAbsFileName: string;
    FFieldParams: string;
    FIniFile: TIniFile;

    function GetIniFile: TIniFile;
  protected
    procedure StartSelf; override;

    function GetSelfParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property FileName: string read FFileName write FFileName;
    property FieldParams: string read FFieldParams write FFieldParams;

    destructor Destroy; override;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions,
  uStepDefines, uThreadSafeFile;

{ TStepQuery }

destructor TStepIniRead.Destroy;
begin
  if FIniFile <> nil then
    FIniFile.Free;
  inherited;
end;

function TStepIniRead.GetIniFile: TIniFile;
begin
  if FIniFile = nil then
    FIniFile := TIniFile.Create(FRealAbsFileName);

  Result := FIniFile;
end;

function TStepIniRead.GetSelfParamValue(AParamRef, AParamType: string;
  ADefaultValue: Variant): Variant;
var
  LParamRef: TStringList;
begin
  Result := ADefaultValue;

  LParamRef := TStringList.Create;
  try
    LParamRef.Delimiter := '.';
    LParamRef.DelimitedText := AParamRef;
    if LParamRef.Count = 2 then
    begin
      Result := TThreadSafeFile.ReadStringFrom(GetIniFile, LParamRef.Strings[0], LParamRef.Strings[1], ADefaultValue);
    end;
  finally
    LParamRef.Free;
  end;
end;

procedure TStepIniRead.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('file_name', FFileName));
  AToConfig.AddPair(TJSONPair.Create('field_params', FFieldParams));
end;


procedure TStepIniRead.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFileName := GetJsonObjectValue(StepConfig.ConfigJson, 'file_name');
  FFieldParams := GetJsonObjectValue(StepConfig.ConfigJson, 'field_params');
  FRealAbsFileName := GetRealAbsolutePath(FFileName);
end;


procedure TStepIniRead.StartSelf;
var
  i: Integer;
  LOutDataJson, LFieldJson: TJSONObject;
  LFieldParamsJsonArray: TJSONArray;
begin
  try
    CheckTaskStatus;

    //判断文件夹存不存在
    if FRealAbsFileName = '' then
    begin
      StopExceptionRaise('INI文件未设置：' + FRealAbsFileName);
    end;

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
      //Edited by ToString;
      FOutData.DataType := sdtText;
      FOutData.Data := LOutDataJson.ToJSON
    finally
      LOutDataJson.Free;
      //LIniFile := nil;
      LFieldParamsJsonArray.Free;
    end;
  finally

  end;
end;


initialization
RegisterClass(TStepIniRead);

finalization
UnRegisterClass(TStepIniRead);

end.
