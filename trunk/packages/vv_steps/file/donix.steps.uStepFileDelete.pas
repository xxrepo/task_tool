unit donix.steps.uStepFileDelete;

interface

uses
  uStepBasic, System.JSON, System.Classes;

type
  TStepFileDelete = class (TStepBasic)
  private
    FFilterList: TStringList;

    FPath: string;
    FFilter: string;
    FRecursive: Boolean;
    FDeleteBeforeTime: Integer;

    FRealAbsPath: string;
    procedure OnFileFound(AFileName: string; AFinder: TObject);
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property Path: string read FPath write FPath;
    property Filter: string read FFilter write FFilter;
    property Recursive: Boolean read FRecursive write FRecursive;
    property DeleteBeforeTime: Integer read FDeleteBeforeTime write FDeleteBeforeTime;
  end;

implementation

uses
  uDefines, uFunctions, System.SysUtils, uExceptions,
  uStepDefines, System.DateUtils, System.IOUtils, uFileFinder;

{ TStepQuery }

procedure TStepFileDelete.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('path', FPath));
  AToConfig.AddPair(TJSONPair.Create('filter', FFilter));
  AToConfig.AddPair(TJSONPair.Create('recursive', BoolToStr(FRecursive)));
  AToConfig.AddPair(TJSONPair.Create('delete_before_time', IntToStr(FDeleteBeforeTime)));
end;


procedure TStepFileDelete.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FPath := GetJsonObjectValue(StepConfig.ConfigJson, 'path');
  FFilter := GetJsonObjectValue(StepConfig.ConfigJson, 'filter');
  FRecursive := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'recursive'), True);
  FDeleteBeforeTime := StrToIntDef(GetJsonObjectValue(StepConfig.ConfigJson, 'delete_before_time'), 86400 * 7);
  FRealAbsPath := GetRealAbsolutePath(FPath);
end;


procedure TStepFileDelete.StartSelf;
var
  LFileFinder: TVVFileFinder;
begin
  FFilterList := TStringList.Create;
  FFilterList.Delimiter := ';';
  FFilterList.DelimitedText := FFilter;

  LFileFinder := TVVFileFinder.Create;
  try
    CheckTaskStatus;

    LFileFinder.Dir := FRealAbsPath;
    LFileFinder.Recursive := FRecursive;
    LFileFinder.OnFileFound := OnFileFound;
    LFileFinder.Find;
  finally
    LFileFinder.Free;
    FFilterList.Free;
  end;
end;


procedure TStepFileDelete.OnFileFound(AFileName: string; AFinder: TObject);
var
  LExt: string;
begin
  CheckTaskStatus;

  //获取文件后缀是否是log
  if FFilterList.Count = 0 then Exit;

  if FFilterList.IndexOf('.*') = -1 then
  begin
    LExt := ExtractFileExt(AFileName);
    if FFilterList.IndexOf(LExt) = -1  then Exit;
  end;

  if FDeleteBeforeTime > 0 then
  begin
    if SecondsBetween(Now, TFile.GetLastWriteTime(AFileName)) <= FDeleteBeforeTime then
    begin
      Exit;
    end;
  end;

  try
    TFile.Delete(AFileName);
    TaskVar.Logger.Warn(FormatLogMsg('删除文件：' + AFileName));
  finally

  end;
end;

end.
