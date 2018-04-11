unit uCalendarJobConfig;

interface

uses uFileLogger;

type
  TCalendarProjectConfigRec = record
    AbsRootPath: string;
    RootPath: string;
    JobsFile: string;
    DbsFile: string;

    ThreadCount: Integer;
    LogLevel: TLogLevel;
    AllowedTimes: string;
    DisallowedTimes: string;
  end;

  TCalendarProjectConfigUtil = class
  public
    class function ReadConfigFrom(AFile: string): TCalendarProjectConfigRec;
    class procedure WriteConfigTo(AHttpServerConfig: TCalendarProjectConfigRec; AFile: string);
  end;

implementation

uses System.IniFiles, uFileUtil, uDefines, System.SysUtils;

{ TCalendarJobConfigUtil }

class function TCalendarProjectConfigUtil.ReadConfigFrom(
  AFile: string): TCalendarProjectConfigRec;
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AFile);
  try
    Result.RootPath := LIniFile.ReadString('calendar_job', 'root_path', '.\projects\calendar\');
    Result.ThreadCount := LIniFile.ReadInteger('calendar_job', 'thread_count', 1);
    Result.LogLevel := TLogLevel(LIniFile.ReadInteger('calendar_job', 'log_level', 0));
    Result.AllowedTimes := LIniFile.ReadString('calendar_job', 'allowed_times', '');
    Result.DisallowedTimes := LIniFile.ReadString('calendar_job', 'disallowed_times', '');

    Result.AbsRootPath := TFileUtil.GetAbsolutePathEx(ExePath, Result.RootPath);
    Result.JobsFile := Result.AbsRootPath + 'project.jobs';
    Result.DbsFile := Result.AbsRootPath + 'project.dbs';
  finally
    LIniFile.Free;
  end;
end;

class procedure TCalendarProjectConfigUtil.WriteConfigTo(AHttpServerConfig: TCalendarProjectConfigRec; AFile: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(AFile);
  try
    LIniFile.WriteString('calendar_job', 'root_path', AHttpServerConfig.RootPath);
    LIniFile.WriteInteger('calendar_job', 'thread_count', AHttpServerConfig.ThreadCount);
    LIniFile.WriteInteger('calendar_job', 'log_level', Ord(AHttpServerConfig.LogLevel));
    LIniFile.WriteString('calendar_job', 'allowed_times', AHttpServerConfig.AllowedTimes);
    LIniFile.WriteString('calendar_job', 'disallowed_times', AHttpServerConfig.DisallowedTimes);
  finally
    LIniFile.Free;
  end;
end;

end.
