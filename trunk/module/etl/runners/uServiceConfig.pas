unit uServiceConfig;

interface

uses System.IniFiles, uFileLogger;

type
  TServiceConfig = class
  private
    FIniFileName: string;

    function GetJobsFile: string;
    function GetThreadCount: Integer;
    function GetLogLevel: TLogLevel;
    function GetAllowedTime: string;
    function GetDisallowedTimes: string;
  public
    IniFile: TIniFile;

    property JobsFile: string read GetJobsFile;
    property ThreadCount: Integer read GetThreadCount;
    property LogLevel: TLogLevel read GetLogLevel;
    property AllowedTimes: string read GetAllowedTime;
    property DisAllowedTimes: string read GetDisallowedTimes;

    constructor Create(AIniFileName: string);
    destructor Destroy; override;
  end;

implementation

{ TAppConfig }

constructor TServiceConfig.Create(AIniFileName: string);
begin
  FIniFileName := AIniFileName;
  IniFile := TIniFile.Create(AIniFileName);
end;

destructor TServiceConfig.Destroy;
begin
  IniFile.Free;
  inherited;
end;

function TServiceConfig.GetAllowedTime: string;
begin
  Result := IniFile.ReadString('project', 'allowed_times', '');
end;

function TServiceConfig.GetDisallowedTimes: string;
begin
  Result := IniFile.ReadString('project', 'disallowed_times', '');
end;

function TServiceConfig.GetJobsFile: string;
begin
  Result := IniFile.ReadString('project', 'jobs', '');
end;

function TServiceConfig.GetLogLevel: TLogLevel;
begin
  Result := TLogLevel(IniFile.ReadInteger('log', 'log_level', 0));
end;

function TServiceConfig.GetThreadCount: Integer;
begin
  Result := IniFile.ReadInteger('project', 'handler_count', 1);
  if Result > 10 then
  begin
    Result := 10;
  end;
end;

end.
