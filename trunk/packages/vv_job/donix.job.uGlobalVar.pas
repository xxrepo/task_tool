unit donix.job.uGlobalVar;

interface

uses System.SyncObjs, System.JSON;

type
  TGlobalVar = class
  private
    FCritical: TCriticalSection;
    FValues: TJSONObject;
    function GetValues: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(AFileName: string);

    function GetParamValue(AParamRef: string; AParamType: string; ADefault: Variant): Variant;

    property Values: string read GetValues;
  end;

implementation

uses System.SysUtils, System.Classes, uFunctions, uThreadSafeFile;

{ TGlobalVar }

constructor TGlobalVar.Create;
begin
  inherited;
  FCritical := TCriticalSection.Create;
end;


destructor TGlobalVar.Destroy;
begin
  if FValues <> nil then
    FreeAndNil(FValues);
  FCritical.Free;
  inherited;
end;

function TGlobalVar.GetParamValue(AParamRef, AParamType: string;
  ADefault: Variant): Variant;
begin
  FCritical.Enter;
  try
    Result := GetJsonObjectValue(FValues, AParamRef, ADefault, AParamType);
  finally
    FCritical.Leave;
  end;
end;


function TGlobalVar.GetValues: string;
begin
  Result := '';
  if FValues <> nil then
    Result := FValues.ToJSON;
end;

procedure TGlobalVar.LoadFromFile(AFileName: string);
var
  LJsonArray: TJSONArray;
  LJsonRow: TJSONObject;
  LJsonStr: string;
  i: Integer;
begin
  FCritical.Enter;
  try
    if FValues <> nil then
      FreeAndNil(FValues);

    LJsonStr := TThreadSafeFile.ReadContentFrom(AFileName, '[]');
    LJsonArray := TJsonObject.ParseJSONValue(LJsonStr) as TJSONArray;
    if LJsonArray <> nil then
    try
      FValues := TJSONObject.Create;
      for i := 0 to LJsonArray.Count - 1 do
      begin
        LJsonRow := LJsonArray.Items[i] as TJSONObject;
        FValues.AddPair(TJSONPair.Create(GetJsonObjectValue(LJsonRow, 'param_name'),
                                         GetJsonObjectValue(LJsonRow, 'param_value')));
      end;
    finally
      LJsonArray.Free;
    end;
  finally
    FCritical.Leave;
  end;
end;

end.
