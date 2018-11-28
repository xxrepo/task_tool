unit donix.basic.uExeUtil;

interface

type
  TExeUtil = class
  public
    class function AddAutoRun(AAlias, AExeName: string): Boolean; static;
    class function DelAutoRun(AAlias, AExeName: string): Boolean; static;
    class function IsAutoRun(AAlias, AExeName: string): Boolean; static;
  end;

implementation

uses System.Win.Registry, Winapi.Windows, System.SysUtils;


function SetAutoRun(AAlias, AExe: string; AAuto: boolean): Boolean;
var
  Reg:TRegistry; //首先定义一个TRegistry类型的变量Reg
begin
  Result := False;
  if not FileExists(AExe) then Exit;

  Reg := TRegistry.Create;
  try //创建一个新键
    Reg.RootKey := HKEY_LOCAL_MACHINE; //将根键设置为HKEY_LOCAL_MACHINE
    if not Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true) then Exit;

    if AAuto then
    begin
      Reg.WriteString(AAlias, ExpandFileName(AExe)); //在Reg这个键中写入数据名称和数据数值
    end
    else
    begin
      Reg.DeleteValue(AAlias);
    end;
    Reg.CloseKey; //关闭键

    Result := True;
  finally
    Reg.Free;
  end;
end;

{ TExeUtil }

class function TExeUtil.AddAutoRun(AAlias, AExeName: string): Boolean;
begin
  Result := SetAutoRun(AAlias, AExeName, True);
end;

class function TExeUtil.DelAutoRun(AAlias, AExeName: string): Boolean;
begin
  Result := SetAutoRun(AAlias, AExeName, False);
end;

class function TExeUtil.IsAutoRun(AAlias, AExeName: string): Boolean;
var
  Reg:TRegistry; 
begin
  Result := False;

  Reg := TRegistry.Create;
  try //创建一个新键
    Reg.RootKey := HKEY_LOCAL_MACHINE; //将根键设置为HKEY_LOCAL_MACHINE
    if not Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true) then Exit;

    if Reg.ReadString(AAlias) = AExeName then
    begin
      Result := True;
    end;

    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

end.
