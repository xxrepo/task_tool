unit donix.steps.uStepServiceCtrl;

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
    function CheckStatus(AStartTime: TDateTime; AToStatus: string): Boolean;
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
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines, uServiceUtil, System.DateUtils;

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
  LServiceStatusStr: string;
begin
  try
    CheckTaskStatus;

    LCtrlType := TServiceCtrlType(FCtrlType);
    LResult := True;

    //查询服务状态
    LServiceStatusStr := TServiceUtil.QueryServiceStatusStr(FServiceName);
    case LCtrlType of
      sctInstall:
      begin
        if LServiceStatusStr = '未安装' then
        begin
          LAbsServcieExeFile := GetRealAbsolutePath(FServiceExeFile);
          LResult := TServiceUtil.InstallServices(FServiceName, FDisplayName, LAbsServcieExeFile);

          //执行异常检查
          LResult := CheckStatus(Now, '已停止');
        end;
      end;
      sctStart:
      begin
        if LServiceStatusStr = '已停止' then
        begin
          LResult := TServiceUtil.StartServices(FServiceName);

          //执行异常检查
          LResult := CheckStatus(Now, '已启动');
        end;
      end;
      sctStop:
      begin
        if LServiceStatusStr = '已启动' then
        begin
          TServiceUtil.StopServices(FServiceName);
          //要执行等待检查，否则需要记录异常
          LResult := CheckStatus(Now, '已停止');
        end;
      end;
      sctUninstall:
      begin
        if LServiceStatusStr = '已停止' then
        begin
          TServiceUtil.UnInstallServices(FServiceName);

          //要执行检查，否则需要记录异常
          LResult := CheckStatus(Now, '未安装');
        end;
      end;
    end;

    if not LResult then
    begin
      StopExceptionRaise('服务命令执行失败');
    end;
  finally

  end;
end;


function TStepServiceCtrl.CheckStatus(AStartTime: TDateTime; AToStatus: string): Boolean;
var
  LServerStatusStr: string;
begin
  while SecondsBetween(Now, AStartTime) < 120 do
  begin
    Sleep(1000);
    LServerStatusStr := TServiceUtil.QueryServiceStatusStr(FServiceName);
    if LServerStatusStr = AToStatus then
    begin
      Break;
    end;
  end;

  Result := LServerStatusStr = AToStatus;
end;

end.
