unit uHttpServerConfig;

interface

uses System.IniFiles, uFileLogger;

type
  THttpServerConfigRec = record
    IP: string;
    Port: Integer;
    DocRoot: string;
    AbsDocRoot: string;
    MaxConnection: Integer;
    AllowedAccessOrigins: string;
    AllowedTimes: string;
    DisallowedTimes: string;

    LogLevel: TLogLevel;
  end;

  THttpServerConfigUtil = class
  public
    class function ReadConfigFrom(AFile: string): THttpServerConfigRec;
    class procedure WriteConfigTo(AHttpServerConfig: THttpServerConfigRec; AFile: string);
  end;

implementation



{ THttpServerConfigUtil }

class function THttpServerConfigUtil.ReadConfigFrom(
  AFile: string): THttpServerConfigRec;
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AFile);
  try
    Result.IP := LIniFile.ReadString('local_server', 'ip', '127.0.0.1');
    Result.Port := LIniFile.ReadInteger('local_server', 'port', 61288);
    Result.DocRoot := LIniFile.ReadString('local_server', 'document_root', '.\projects\');
    Result.MaxConnection := LIniFile.ReadInteger('local_server', 'max_connection', 0);
    Result.LogLevel := TLogLevel(LIniFile.ReadInteger('local_server', 'log_level', 0));
    Result.AllowedAccessOrigins := LIniFile.ReadString('local_server', 'allowed_access_origins', '');
    Result.AllowedTimes := LIniFile.ReadString('local_server', 'allowed_times', '');
    Result.DisallowedTimes := LIniFile.ReadString('local_server', 'disallowed_times', '');
  finally
    LIniFile.Free;
  end;
end;

class procedure THttpServerConfigUtil.WriteConfigTo(
  AHttpServerConfig: THttpServerConfigRec; AFile: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AFile);
  try
    LIniFile.WriteString('local_server', 'ip', AHttpServerConfig.IP);
    LIniFile.WriteInteger('local_server', 'port', AHttpServerConfig.Port);
    LIniFile.WriteString('local_server', 'document_root', AHttpServerConfig.DocRoot);
    LIniFile.WriteInteger('local_server', 'max_connection', AHttpServerConfig.MaxConnection);
    LIniFile.WriteInteger('local_server', 'log_level', Ord(AHttpServerConfig.LogLevel));
    LIniFile.WriteString('local_server', 'allowed_access_origins', AHttpServerConfig.AllowedAccessOrigins);
    LIniFile.WriteString('local_server', 'allowed_times', AHttpServerConfig.AllowedTimes);
    LIniFile.WriteString('local_server', 'disallowed_times', AHttpServerConfig.DisallowedTimes);
  finally
    LIniFile.Free;
  end;
end;

end.
