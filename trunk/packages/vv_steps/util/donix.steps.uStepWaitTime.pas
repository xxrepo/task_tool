unit donix.steps.uStepWaitTime;

interface

uses
  uStepBasic, System.JSON;

type
  TStepWaitTime = class (TStepBasic)
  private
    FMiniSeconds: Integer;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property MiniSeconds: Integer read FMiniSeconds write FMiniSeconds;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines;

{ TStepQuery }

procedure TStepWaitTime.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('mini_seconds', IntToStr(FMiniSeconds)));
end;


procedure TStepWaitTime.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FMiniSeconds := StrToIntDef(GetJsonObjectValue(StepConfig.ConfigJson, 'mini_seconds'), 1000);
end;


procedure TStepWaitTime.StartSelf;
var
  F: TextFile;
  LDir: string;
begin
  try
    CheckTaskStatus;

    DebugMsg('µ»¥˝ ±º‰£∫' + IntToStr(FMiniSeconds) + '∫¡√Î');
    Sleep(FMiniSeconds);

    FOutData := FInData;
  finally

  end;
end;


initialization
RegisterClass(TStepWaitTime);

finalization
UnRegisterClass(TStepWaitTime);

end.
