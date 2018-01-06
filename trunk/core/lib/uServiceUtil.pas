unit uServiceUtil;

interface

uses Windows, Messages, SysUtils, Winsvc, Dialogs;

type

  TServiceUtil = class
  public
    class function StartServices(Const sServiceName: String): Boolean; static;
    class function StopServices(Const sServiceName: String): Boolean; static;
    class function QueryServiceStatusStr(Const SvrName: String): String; static;
    class function InstallServices(Const SvrName, ADisplayName, FilePath: String): Boolean; static;
    class function UnInstallServices(Const SvrName: String): Boolean; static;
  end;

implementation

// 开启服务
class function TServiceUtil.StartServices(const sServiceName: String): Boolean;//启动某个服务；
var
  schService:SC_HANDLE;
  schSCManager:SC_HANDLE;
  Argv:PChar;
begin
  Result := False;
  schSCManager:=OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager > 0 then
  begin
    try
      schService:=OpenService(schSCManager,Pchar(sServiceName),SERVICE_ALL_ACCESS);
      if schService > 0 then
      try
        Result := StartService(schService,0,Argv);
      finally
        CloseServiceHandle(schService);
      end;
    finally
      CloseServiceHandle(schSCManager);
    end;
  end;
end;

// 停止服务
class function TServiceUtil.StopServices(const sServiceName:String): Boolean;//停止某个服务；
var
  schService:SC_HANDLE;
  schSCManager:SC_HANDLE;
  ssStatus: TServiceStatus;
begin
  Result := False;
  schSCManager:=OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager > 0 then
  begin
    try
      schService:=OpenService(schSCManager,Pchar(sServiceName),SERVICE_ALL_ACCESS);
      if schService > 0 then
      try
        Result := ControlService(schService,SERVICE_CONTROL_STOP,ssStatus);
      finally
        CloseServiceHandle(schService);
      end;
    finally
      CloseServiceHandle(schSCManager);
    end;
  end;
end;


// 查询当前服务的状态
class function TServiceUtil.QueryServiceStatusStr(Const SvrName: String): String;
var
  hService, hSCManager: SC_HANDLE;
  SS: TServiceStatus;
begin
  hSCManager := OpenSCManager(nil, SERVICES_ACTIVE_DATABASE, SC_MANAGER_CONNECT);
  if hSCManager = 0 then
  begin
    result := 'Can not open the service control manager';
    exit;
  end;
  hService := OpenService(hSCManager, PChar(SvrName), SERVICE_QUERY_STATUS);
  if hService = 0 then
  begin
    CloseServiceHandle(hSCManager);
    result := '未安装';
    exit;
  end;
  try
    if not QueryServiceStatus(hService, SS) then
      result := '无法查询服务状态'
    else
    begin
      case SS.dwCurrentState of
        SERVICE_CONTINUE_PENDING:
          result := '重启动中';
        SERVICE_PAUSE_PENDING:
          result := '即将暂停';
        SERVICE_PAUSED:
          result := '已暂停';
        SERVICE_RUNNING:
          result := '已启动';
        SERVICE_START_PENDING:
          result := '即将启动';
        SERVICE_STOP_PENDING:
          result := '即将停止';
        SERVICE_STOPPED:
          result := '已停止';
      else
        result := '未知状态';
      end;
    end;
  finally
    CloseServiceHandle(hSCManager);
    CloseServiceHandle(hService);
  end;
end;



{ 建立服务 }
class function TServiceUtil.InstallServices(Const SvrName, ADisplayName, FilePath: String): Boolean;
var
  a, b: SC_HANDLE;
begin
  Result := False;
  if not FileExists(FilePath) then Exit;

  a := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if a <= 0 then Exit;

  try
    b := CreateService(a, PChar(SvrName), PChar(ADisplayName), SERVICE_ALL_ACCESS,
      SERVICE_INTERACTIVE_PROCESS or SERVICE_WIN32_OWN_PROCESS,
      SERVICE_AUTO_START, SERVICE_ERROR_NORMAL, PChar(FilePath), nil, nil, nil,
      nil, nil);
    if b <= 0 then
    begin
      raise Exception.Create(SysErrorMessage(GetlastError));
    end;

    CloseServiceHandle(b);
    Result := True;
  except
    CloseServiceHandle(a);
  end;
end;



{ 卸载服务 }
class function TServiceUtil.UnInstallServices(Const SvrName: String): Boolean;
var
  a, b: SC_HANDLE;
begin
  Result := False;
  a := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if a <= 0 then Exit;

  try
    b := OpenService(a, PChar(SvrName), STANDARD_RIGHTS_REQUIRED);
    if b > 0 then
    try
      Result := DeleteService(b);
      if not Result then
        raise Exception.Create(SysErrorMessage(GetlastError));
    finally
      CloseServiceHandle(b);
    end;
  finally
    closeServiceHandle(a);
  end;
end;

end.
