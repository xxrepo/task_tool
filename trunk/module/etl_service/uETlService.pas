unit uETlService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, uScheduleRunner;

type
  TCGTEtlSrv = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
    FServiceRunner: TScheduleRunner;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  CGTEtlSrv: TCGTEtlSrv;

implementation

uses uDefines, uFileLogger, System.SyncObjs, uScheduleConfig;

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
  LScheduleConfig: TScheduleConfig;
begin
  ExePath := ExtractFilePath(ParamStr(0));
  LScheduleConfig := TScheduleConfig.Create(ExePath + 'config\service.ini');
  try
    FileCritical := TCriticalSection.Create;
    AppLogger := TThreadFileLog.Create(1, ExePath + 'log\service\', 'yyyymmdd\hh', LScheduleConfig.LogLevel);
    AppLogger.Force('启动服务');
    FServiceRunner := TScheduleRunner.Create(ExePath, LScheduleConfig);
    FServiceRunner.Start;
  finally
    LScheduleConfig.Free;
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
