unit uStepUnzip;

interface

uses
  uStepBasic, System.JSON;

type
  TStepUnzip = class (TStepBasic)
  private
    FSrcFile: string;
    FToPath: string;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property SrcFile: string read FSrcFile write FSrcFile;
    property ToPath: string read FToPath write FToPath;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uTask,
  uStepDefines, System.Zip;

{ TStepQuery }

procedure TStepUnzip.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('src_file', FSrcFile));
  AToConfig.AddPair(TJSONPair.Create('to_path', FToPath));
end;


procedure TStepUnzip.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FSrcFile := GetJsonObjectValue(StepConfig.ConfigJson, 'src_file');
  FToPath := GetJsonObjectValue(StepConfig.ConfigJson, 'to_path');
end;


procedure TStepUnzip.StartSelf;
var
  LTarget, LSrcFile: string;
begin
  try
    CheckTaskStatus;

    LSrcFile := GetParamValue(FSrcFile, 'string', FSrcFile);
    LTarget := GetRealAbsolutePath(FToPath);

    //加载任务文件
    TZipFile.ExtractZipFile(LSrcFile, LTarget);
  finally

  end;
end;


initialization
RegisterClass(TStepUnzip);

finalization
UnRegisterClass(TStepUnzip);

end.
