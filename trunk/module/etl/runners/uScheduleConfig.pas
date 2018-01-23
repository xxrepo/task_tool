unit uScheduleConfig;

interface

uses System.IniFiles, uFileLogger;

type
  TScheduleConfig = class
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

constructor TScheduleConfig.Create(AIniFileName: string);
begin
  FIniFileName := AIniFileName;
  IniFile := TIniFile.Create(AIniFileName);
end;

destructor TScheduleConfig.Destroy;
begin
  IniFile.Free;
  inherited;
end;

function TScheduleConfig.GetAllowedTime: string;
begin
  Result := IniFile.ReadString('project', 'allowed_times', '');
end;

function TScheduleConfig.GetDisallowedTimes: string;
begin
  Result := IniFile.ReadString('project', 'disallowed_times', '');
end;

function TScheduleConfig.GetJobsFile: string;
begin
  Result := IniFile.ReadString('project', 'jobs', '');
end;

function TScheduleConfig.GetLogLevel: TLogLevel;
begin
  Result := TLogLevel(IniFile.ReadInteger('log', 'log_level', 0));
end;

function TScheduleConfig.GetThreadCount: Integer;
begin
  Result := IniFile.ReadInteger('project', 'handler_count', 1);
  if Result > 10 then
  begin
    Result := 10;
  end;
end;

end.
