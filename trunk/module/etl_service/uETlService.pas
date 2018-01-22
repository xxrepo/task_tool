unit uETlService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, uServiceRunner;

type
  TCGTEtlSrv = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
    FServiceRunner: TServiceRunner;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  CGTEtlSrv: TCGTEtlSrv;

implementation

uses uDefines, uFileLogger, System.SyncObjs, uServiceConfig;

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  CGTEtlSrv.Controller(CtrlCode);
end;

function TCGTEtlSrv.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


procedure TCGTEtlSrv.ServiceStart(Sender: TService; var Started: Boolean);
var
  LServiceConfig: TServiceConfig;
begin
  ExePath := ExtractFilePath(ParamStr(0));
  LServiceConfig := TServiceConfig.Create(ExePath + 'config\service.ini');
  try
    FileCritical := TCriticalSection.Create;
    AppLogger := TThreadFileLog.Create(1, ExePath + 'log\service\', 'yyyymmdd\hh', LServiceConfig.LogLevel);
    AppLogger.Force('启动服务');
    FServiceRunner := TServiceRunner.Create(ExePath, LServiceConfig);
    FServiceRunner.Start;
  finally
    LServiceConfig.Free;
    Started := True;
  end;
end;


procedure TCGTEtlSrv.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  try
    AppLogger.Force('停止服务');
    if FServiceRunner <> nil then
      FreeAndNil(FServiceRunner);
    if FileCritical <> nil then
      FreeAndNil(FileCritical);
    if AppLogger <> nil then
      FreeAndNil(AppLogger);
  finally
    Stopped := True;
  end;
end;

end.
