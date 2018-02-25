unit uStepServiceCtrl;

interface

uses
  uStepBasic, System.JSON;

type
  TStepServiceCtrl = class (TStepBasic)
  private
    FFileName: string;
    FRealAbsFileName: string;
    //FFromField: string; //默认是
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property ToFileName: string read FFileName write FFileName;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines;

{ TStepQuery }

procedure TStepServiceCtrl.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('to_file_name', FFileName));
end;


procedure TStepServiceCtrl.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFileName := GetJsonObjectValue(StepConfig.ConfigJson, 'to_file_name');
  FRealAbsFileName := GetRealAbsolutePath(FFileName);
end;


procedure TStepServiceCtrl.StartSelf;
var
  F: TextFile;
  LDir: string;
begin
  try
    CheckTaskStatus;

    if FRealAbsFileName = '' then
    begin
      StopExceptionRaise('目标txt文件名为空');
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

    TaskVar.Logger.Debug(FormatLogMsg('写如文件：' + FRealAbsFileName));

    if not FileExists(FRealAbsFileName) then
      Rewrite(F)
    else
      Append(F);

    Writeln(F, FInData.Data);

    CloseFile(F);

  finally

  end;
end;


initialization
RegisterClass(TStepServiceCtrl);

finalization
UnRegisterClass(TStepServiceCtrl);

end.
