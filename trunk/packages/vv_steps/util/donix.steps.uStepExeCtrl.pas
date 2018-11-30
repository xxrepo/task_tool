unit donix.steps.uStepExeCtrl;

interface

uses
  uStepBasic, System.JSON;

type
  TStepExeCtrl = class (TStepBasic)
  private
    FCtrlType: Integer;
    FExeFile: string;
    FStartArgs: string;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property CtrlType: Integer read FCtrlType write FCtrlType;
    property ExeFile: string read FExeFile write FExeFile;
    property StartArgs: string read FStartArgs write FStartArgs;
  end;

implementation

uses
  uDefines, uFunctions, system.Classes, System.SysUtils, uExceptions, uStepDefines, Winapi.ShellAPI, Winapi.Windows;

type
  TCtrlType = (sctStart, sctStop);

{ TStepQuery }

procedure TStepExeCtrl.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('ctrl_type', IntToStr(FCtrlType)));
  AToConfig.AddPair(TJSONPair.Create('exe_file', FExeFile));
  AToConfig.AddPair(TJSONPair.Create('start_args', FStartArgs));
end;


procedure TStepExeCtrl.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FCtrlType := GetJsonObjectValue(StepConfig.ConfigJson, 'ctrl_type', '-1', 'int');
  FExeFile := GetJsonObjectValue(StepConfig.ConfigJson, 'exe_file');
  FStartArgs := GetJsonObjectValue(StepConfig.ConfigJson, 'start_args');
end;


procedure TStepExeCtrl.StartSelf;
var
  LAbsExeFile: string;
  LCtrlType: TCtrlType;
  LResult: Boolean;
begin
  try
    CheckTaskStatus;

    LCtrlType := TCtrlType(FCtrlType);
    LAbsExeFile := GetRealAbsolutePath(FExeFile);

    LResult := False;
    case LCtrlType of
      sctStart:
      begin
        DebugMsg('启动应用程序：' + LAbsExeFile + '; 参数：' + FStartArgs);
        if ShellExecute(GetDesktopWindow, 'open', PChar(LAbsExeFile), PChar(FStartArgs), nil, SW_SHOWNORMAL) >= 32 then
          LResult := True;
      end;
      sctStop:
      begin
        DebugMsg('终止应用程序：' + LAbsExeFile);
        KillProcess(LAbsExeFile);
        LResult := True;
      end;
    end;

    if not LResult then
    begin
      StopExceptionRaise('EXE应用程序命令执行失败');
    end;
  finally

  end;
end;


initialization
System.Classes.RegisterClass(TStepExeCtrl);

finalization
System.Classes.UnRegisterClass(TStepExeCtrl);

end.
