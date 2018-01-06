unit uFileUtil;

interface

type
  TFileUtil = class
  private

  public
    class procedure DeleteDir(ADirName: string; ARecursive: Boolean = True); static;
    class function CreateFile(AFileName: string; AThenClose: Boolean = True): THandle; static;
    class function CreateDir(ADirName: string): Boolean; static;
    class function GetRelativePath(ABasePath, AFile: string): string; static;
    class function GetAbsolutePathEx(ABasePath, ARelativePath: string): string; static;
  end;

implementation

uses Winapi.ShLwApi, Winapi.Windows, System.SysUtils, System.IOUtils;

{ TFileUtil }

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
  TDirectory.Delete(ADirName, ARecursive);
end;

class function TFileUtil.CreateFile(AFileName: string; AThenClose: Boolean): THandle;
begin
  Result := INVALID_HANDLE_VALUE;
  if not TFileUtil.CreateDir(ExtractFileDir(AFileName)) then Exit;

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
   p: array[0..MAX_PATH] of Char;
begin
   PathRelativePathTo(p, PChar(ABasePath), GetAttr(False), PChar(AFile), GetAttr(True));
   Result := StrPas(p);
end;


class function TFileUtil.GetAbsolutePathEx(ABasePath, ARelativePath:string):string;
var
   Dest:array [0..MAX_PATH] of char;
begin
   FillChar(Dest, MAX_PATH+1,0);
   PathCombine(Dest, PChar(ABasePath), PChar(ARelativePath));
   Result := string(Dest);
end;

end.
