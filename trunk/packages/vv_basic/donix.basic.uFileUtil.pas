unit donix.basic.uFileUtil;

interface

type
  TFileUtil = class
  private

  public
    class function CreateFile(AFileName: string; AThenClose: Boolean = True): THandle; static;
    class procedure DeleteFile(AFileName: string); static;
    class function CopyFile(AFileName: string; AToFileName: string; AOverWirte: Boolean = True): Boolean; static;
    class function RenameFile(AFileName: string; AToFileName: string): Boolean; static;

    class function CreateDir(ADirName: string): Boolean; static;
    class procedure DeleteDir(ADirName: string; ARecursive: Boolean = True); static;
    class function CopyDir(ADirName: string; AToDir: string; nLx: Integer = 1): Boolean; static;

    class function GetRelativePath(ABasePath, AFile: string): string; static;
    class function GetAbsolutePathEx(ABasePath, ARelativePath: string): string; static;
  end;

implementation

uses Winapi.ShLwApi, Winapi.Windows, System.SysUtils, System.IOUtils, Winapi.ShellAPI;

{ TFileUtil }

class function TFileUtil.CopyDir(ADirName, AToDir: string; nLx:Integer): Boolean;
Var
  Opstruc: TshFileOpStruct;
  frombuf, tobuf: Array [0 .. 128] of Char;
begin
  FillChar(frombuf, Sizeof(frombuf), 0);
  FillChar(tobuf, Sizeof(tobuf), 0);
  StrPcopy(frombuf, ADirName);
  Case nLx of
    1:
      StrPcopy(tobuf, AToDir);
  end;
  With Opstruc Do
  Begin
    Wnd := 0;
    Case nLx of
      1:
        wFunc := FO_COPY;
      2:
        wFunc := FO_DELETE;
    Else
      wFunc := FO_COPY;
    end;
    pFrom := @frombuf;
    pTo := @tobuf;
    fFlags := FOF_NOCONFIRMATION;
    fAnyOperationsAborted := False;
    hNameMappings := Nil;
    lpszProgressTitle := Nil;
  end;
  try
    ShFileOperation(Opstruc);
    Result := True;
  except
    Result := False;
  end;
end;

class function TFileUtil.CopyFile(AFileName, AToFileName: string; AOverWirte: Boolean = True): Boolean;
begin
  Winapi.Windows.CopyFile(PChar(AFileName), PChar(AToFileName), not AOverWirte);
end;

class function TFileUtil.CreateDir(ADirName: string): Boolean;
begin
  Result := True;
  if not DirectoryExists(ADirName) then
  begin
    Result := ForceDirectories(ADirName);
  end;
end;

class procedure TFileUtil.DeleteDir(ADirName: string; ARecursive: Boolean = True);
begin
  if DirectoryExists(ADirName) then
    TDirectory.Delete(ADirName, ARecursive);
end;

class procedure TFileUtil.DeleteFile(AFileName: string);
begin
  if FileExists(AFileName) then
    Winapi.Windows.DeleteFile(PChar(AFileName));
end;

class function TFileUtil.CreateFile(AFileName: string; AThenClose: Boolean): THandle;
begin
  Result := INVALID_HANDLE_VALUE;
  if not TFileUtil.CreateDir(ExtractFileDir(AFileName)) then
    Exit;

  Result := FileCreate(AFileName);
  if Result <> INVALID_HANDLE_VALUE then
  begin
    if AThenClose then
      FileClose(Result);
  end;
end;

class function TFileUtil.GetRelativePath(ABasePath, AFile: string): string;
  function GetAttr(IsDir: Boolean): DWORD;
  begin
    if IsDir then
      Result := FILE_ATTRIBUTE_DIRECTORY
    else
      Result := FILE_ATTRIBUTE_NORMAL;
  end;

var
  p: array [0 .. MAX_PATH] of Char;
begin
  PathRelativePathTo(p, PChar(ABasePath), GetAttr(False), PChar(AFile), GetAttr(True));
  Result := StrPas(p);
end;

class function TFileUtil.RenameFile(AFileName, AToFileName: string): Boolean;
begin
  Result := MoveFile(PChar(AFileName), PChar(AToFileName));
end;

class function TFileUtil.GetAbsolutePathEx(ABasePath, ARelativePath: string): string;
var
  Dest: array [0 .. MAX_PATH] of Char;
begin
  FillChar(Dest, MAX_PATH + 1, 0);
  PathCombine(Dest, PChar(ABasePath), PChar(ARelativePath));
  Result := string(Dest);
end;

end.
