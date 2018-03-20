unit uGlobalVar;

interface

uses System.SyncObjs, System.Classes;

type
  TGlobalVar = class
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

constructor TGlobalVar.Create;
begin
  inherited;
  FCritical := TCriticalSection.Create;
  FParams := TStringList.Create;
end;


function TGlobalVar.DelParam(AIndex: Integer): string;
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


destructor TGlobalVar.Destroy;
begin
  FParams.Free;
  FCritical.Free;
  inherited;
end;


function TGlobalVar.AddParam(AParam: string): Integer;
begin
  FCritical.Enter;
  try
    Result := FParams.Add(AParam);
  finally
    FCritical.Leave;
  end;
end;


function TGlobalVar.GetParam(AIndex: Integer): string;
begin
  try
    Result := '';
    if (AIndex > -1) and (AIndex < FParams.Count) then
      Result := FParams.Strings[AIndex];
  finally

  end;
end;


end.
