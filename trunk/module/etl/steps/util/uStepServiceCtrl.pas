unit uStepServiceCtrl;

interface

uses
  uStepBasic, System.JSON;

type
  TStepServiceCtrl = class (TStepBasic)
  private
    FServiceName: string;
    FCtrlType: Integer;
    FServiceExeFile: string;
    FDisplayName: string;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property ServiceName: string read FServiceName write FServiceName;
    property CtrlType: Integer read FCtrlType write FCtrlType;
    property ServiceExeFile: string read FServiceExeFile write FServiceExeFile;
    property DisplayName: string read FDisplayName write FDisplayName;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines, uServiceUtil;

type
  TServiceCtrlType = (sctInstall, sctStart, sctStop, sctUninstall);

{ TStepQuery }

procedure TStepServiceCtrl.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('service_name', FServiceName));
  AToConfig.AddPair(TJSONPair.Create('ctrl_type', IntToStr(FCtrlType)));
  AToConfig.AddPair(TJSONPair.Create('service_exe_file', FServiceExeFile));
  AToConfig.AddPair(TJSONPair.Create('display_name', FDisplayName));
end;


procedure TStepServiceCtrl.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FServiceName := GetJsonObjectValue(StepConfig.ConfigJson, 'service_name');
  FCtrlType := GetJsonObjectValue(StepConfig.ConfigJson, 'ctrl_type', '-1', 'int');
  FServiceExeFile := GetJsonObjectValue(StepConfig.ConfigJson, 'service_exe_file');
  FDisplayName := GetJsonObjectValue(StepConfig.ConfigJson, 'display_name');
end;


procedure TStepServiceCtrl.StartSelf;
var
  LAbsServcieExeFile: string;
  LCtrlType: TServiceCtrlType;
  LResult: Boolean;
begin
  try
    CheckTaskStatus;

    LCtrlType := TServiceCtrlType(FCtrlType);
    LResult := False;
    case LCtrlType of
      sctInstall:
      begin
        LAbsServcieExeFile := GetRealAbsolutePath(FServiceExeFile);
        LResult := TServiceUtil.InstallServices(FServiceName, FDisplayName, LAbsServcieExeFile);
      end;
      sctStart:
      begin
        LResult := TServiceUtil.StartServices(FServiceName);
      end;
      sctStop:
      begin
        LResult := TServiceUtil.StopServices(FServiceName);
      end;
      sctUninstall:
      begin
        LResult := TServiceUtil.UnInstallServices(FServiceName);
      end;
    end;

    if not LResult then
    begin
      StopExceptionRaise('∑˛ŒÒ√¸¡Ó÷¥–– ß∞‹');
    end;
  finally

  end;
end;


initialization
RegisterClass(TStepServiceCtrl);

finalization
UnRegisterClass(TStepServiceCtrl);

end.
