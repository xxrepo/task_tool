unit uBROWSER_GlobalVar;

interface

uses System.SyncObjs, System.Classes;

type
  TBROWSER_GlobalVar = class
  private
    FCritical: TCriticalSection;
    FParams: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function AddParam(AParam: string): Integer;
    function GetParam(AIndex: Integer): string;
    function DelParam(AIndex: Integer): string;

  end;

implementation

uses System.SysUtils;

{ TGlobalVar }

constructor TBROWSER_GlobalVar.Create;
begin
  inherited;
  FCritical := TCriticalSection.Create;
  FParams := TStringList.Create;
end;


function TBROWSER_GlobalVar.DelParam(AIndex: Integer): string;
begin
  FCritical.Enter;
  try
    Result := '';
    if (AIndex > -1) and (AIndex < FParams.Count) then
    begin
      Result := FParams.Strings[AIndex];
      FParams.Delete(AIndex);
    end;
  finally
    FCritical.Leave;
  end;
end;


destructor TBROWSER_GlobalVar.Destroy;
begin
  FParams.Free;
  FCritical.Free;
  inherited;
end;


function TBROWSER_GlobalVar.AddParam(AParam: string): Integer;
begin
  FCritical.Enter;
  try
    Result := FParams.Add(AParam);
  finally
    FCritical.Leave;
  end;
end;


function TBROWSER_GlobalVar.GetParam(AIndex: Integer): string;
begin
  try
    Result := '';
    if (AIndex > -1) and (AIndex < FParams.Count) then
      Result := FParams.Strings[AIndex];
  finally

  end;
end;


end.
