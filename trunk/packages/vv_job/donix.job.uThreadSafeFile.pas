unit donix.job.uThreadSafeFile;

interface

uses System.IniFiles, System.SyncObjs;

type
  TThreadSafeFile = class
  private
  public
    class function ReadStringFrom(const AIniFile: TIniFile; const ASection: string;
                    const AName: string; const ADefault: string): string; static;
    class procedure WriteStringTo(const AIniFile: TIniFile; const ASection: string;
                    const AName: string; const AValue: string); static;
    class function ReadContentFrom(const AFileName: string; const ADefault: string = ''): string; static;
    class procedure WriteContentTo(const AFileName, AContent: string); static;
  end;

implementation

uses uDefines, System.Classes, uFileUtil, System.SysUtils;

//需要使用其中的IniFileCritical

{ TThreadIniFile }

class function TThreadSafeFile.ReadContentFrom(const AFileName: string; const ADefault: string = ''): string;
var
  LStrings: TStringList;
begin
  Result := ADefault;
  LStrings := TStringList.Create;
  FileCritical.Enter;
  try
    if FileExists(AFileName) then
    begin
      LStrings.LoadFromFile(AFileName);
      Result := LStrings.Text;
    end;
  finally
    FileCritical.Leave;
    LStrings.Free;
  end;
end;


class procedure TThreadSafeFile.WriteContentTo(const AFileName: string; const AContent: string);
var
  LStrings: TStringList;
begin
  LStrings := TStringList.Create;
  FileCritical.Enter;
  try
    TFileUtil.CreateDir(ExtractFileDir(AFileName));

    LStrings.Text := AContent;
    LStrings.SaveToFile(AFileName);
  finally
    FileCritical.Leave;
    LStrings.Free;
  end;
end;


class function TThreadSafeFile.ReadStringFrom(const AIniFile: TIniFile;
  const ASection, AName, ADefault: string): string;
begin
  FileCritical.Enter;
  try
    Result := AIniFile.ReadString(ASection, AName, ADefault);
  finally
    FileCritical.Leave;
  end;
end;


class procedure TThreadSafeFile.WriteStringTo(const AIniFile: TIniFile;
  const ASection, AName, AValue: string);
begin
  FileCritical.Enter;
  try
    AIniFile.WriteString(ASection, AName, AValue);
  finally
    FileCritical.Leave;
  end;
end;

end.
