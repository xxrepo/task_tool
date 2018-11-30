unit donix.steps.uStepTxtFileWriter;

interface

uses
  uStepBasic, System.JSON;

type
  TStepTxtFileWriter = class (TStepBasic)
  private
    FFileName: string;
    FRealAbsFileName: string;
    FDataRef: string; //默认是
    FRewriteExist: Boolean;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property DataRef: string read FDataRef write FDataRef;
    property ToFileName: string read FFileName write FFileName;
    property RewriteExist: Boolean read FRewriteExist write FRewriteExist;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines;

{ TStepQuery }

procedure TStepTxtFileWriter.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('data_ref', FDataRef));
  AToConfig.AddPair(TJSONPair.Create('to_file_name', FFileName));
  AToConfig.AddPair(TJSONPair.Create('rewrite_exist', BoolToStr(FRewriteExist)));
end;


procedure TStepTxtFileWriter.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDataRef := GetJsonObjectValue(StepConfig.ConfigJson, 'data_ref', 'parent.*');
  FFileName := GetJsonObjectValue(StepConfig.ConfigJson, 'to_file_name');
  FRealAbsFileName := GetRealAbsolutePath(FFileName);
  FRewriteExist := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'rewrite_exist'), False);
end;


procedure TStepTxtFileWriter.StartSelf;
var
  F: TextFile;
  LDir: string;
begin
  try
    CheckTaskStatus;

    if FRealAbsFileName = '' then
    begin
      StopExceptionRaise('目标文件名为空');
    end;
    
    LDir := ExtractFileDir(FRealAbsFileName);
    if not DirectoryExists(LDir) then
    begin
      if not ForceDirectories(LDir) then
      begin
        Exit;
      end;
    end;

    AssignFile(F, FRealAbsFileName);

    TaskVar.Logger.Debug(FormatLogMsg('写入文件：' + FRealAbsFileName));

    if (not FileExists(FRealAbsFileName)) or (FRewriteExist) then
      Rewrite(F)
    else
      Append(F);

    Writeln(F, GetParamValue(DataRef, 'string', ''));

    CloseFile(F);

  finally

  end;
end;


initialization
RegisterClass(TStepTxtFileWriter);

finalization
UnRegisterClass(TStepTxtFileWriter);

end.
