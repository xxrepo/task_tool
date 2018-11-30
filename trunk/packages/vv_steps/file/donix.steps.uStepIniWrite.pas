unit donix.steps.uStepIniWrite;
interface

uses
  uStepBasic, System.JSON;

type
  TStepIniWrite = class (TStepBasic)
  private
    FFileName: string;
    FRealAbsFileName: string;
    FFieldParams: string;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property FileName: string read FFileName write FFileName;
    property FieldParams: string read FFieldParams write FFieldParams;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions,
  System.IniFiles, System.StrUtils, uStepDefines, uThreadSafeFile;

{ TStepQuery }

procedure TStepIniWrite.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('file_name', FFileName));
  AToConfig.AddPair(TJSONPair.Create('field_params', FFieldParams));
end;


procedure TStepIniWrite.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFileName := GetJsonObjectValue(StepConfig.ConfigJson, 'file_name');
  FFieldParams := GetJsonObjectValue(StepConfig.ConfigJson, 'field_params');
  FRealAbsFileName := GetRealAbsolutePath(FFileName);
end;


procedure TStepIniWrite.StartSelf;
var
  LIniFile: TIniFile;
  LDir: string;
  i: Integer;
  LFieldJson: TJSONObject;
  LFieldParamsJsonArray: TJSONArray;
  LSectionFieldPath: TStringList;
  LFieldValue: Variant;
begin
  try
    CheckTaskStatus;

    //判断参数配置正确与否
    LFieldParamsJsonArray := TJSONObject.ParseJSONValue(FFieldParams) as TJSONArray;
    if LFieldParamsJsonArray = nil then Exit;

    //判断文件夹存不存在
    if not FileExists(FRealAbsFileName) then
    begin
      LDir := ExtractFileDir(FRealAbsFileName);
      if (not DirectoryExists(LDir)) and (not ForceDirectories(LDir)) then
      begin
        StopExceptionRaise('文件夹路径创建失败：' + LDir);
      end;
    end;

    //入参
    TaskVar.Logger.Debug(FormatLogMsg('写入ini目标文件：' + FRealAbsFileName));

    LIniFile := TIniFile.Create(FRealAbsFileName);
    LSectionFieldPath := TStringList.Create;
    try
      //处理
      for i := 0 to LFieldParamsJsonArray.Count - 1 do
      begin
        LFieldJson := LFieldParamsJsonArray.Items[i] as TJSONObject;
        if LFieldJson = nil then Continue;

        LSectionFieldPath.Delimiter := '.';
        LSectionFieldPath.DelimitedText := GetJsonObjectValue(LFieldJson, 'param_name', '');
        if LSectionFieldPath.Count <> 2 then
        begin
          StopExceptionRaise('INI文件写入参数必须是Seciotn.ParamName的格式');
          Continue;
        end;

        LFieldValue := GetParamValue(LFieldJson);

        TThreadSafeFile.WriteStringTo(LIniFile, LSectionFieldPath.Strings[0],
                             LSectionFieldPath.Strings[1],
                             LFieldValue);

        TaskVar.Logger.Debug(FormatLogMsg('写入Ini文件参数值：' + LSectionFieldPath.Strings[0]
                                           + '.' + LSectionFieldPath.Strings[1]
                                           + ':' + LFieldValue));
      end;

      //出参
      FOutData.DataType := sdtText;
      FOutData.Data := FInData.Data;
    finally
      LSectionFieldPath.Free;
      LIniFile.Free;
      LFieldParamsJsonArray.Free;
    end;
  finally

  end;
end;


initialization
RegisterClass(TStepIniWrite);

finalization
UnRegisterClass(TStepIniWrite);

end.
