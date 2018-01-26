unit uTaskResult;

interface

uses System.Generics.Collections, System.JSON;

type
  TTaskResult = class
  private
    FCode: Integer;
    FMsg: string;
    FData: TJSONValue;

    function GetData: TJSONValue;
    function GetValues(const Name: string): TJsonValue;
    procedure SetValues(const Name: string; Value: TJSONValue);
    procedure SetData(const Value: TJSONValue);
    function GetDataStr: string;
  public
    constructor Create;
    destructor Destroy; override;

    property Code: Integer read FCode write FCode;
    property Msg: string read FMsg write FMsg;
    property Data: TJSONValue read GetData write SetData;
    property Values[const Name: string]: TJSONValue read GetValues write SetValues;
    property DataStr: string read GetDataStr;

    function ToJsonString: string;
  end;

implementation

uses uFunctions;

{ TTaskResult }

constructor TTaskResult.Create;
begin
  inherited;
  FCode := -1;
  FMsg := '很抱歉，暂未处理您的任务';
  FData := TJSONString.Create;
end;


destructor TTaskResult.Destroy;
begin
  FData.Free;
  inherited;
end;


function TTaskResult.GetData: TJsonValue;
begin
  if FData = nil then
    FData := TJSONString.Create;

  Result := FData;
end;

function TTaskResult.GetDataStr: string;
begin
  Result := JsonValueToStr(FData);
end;

function TTaskResult.GetValues(const Name: string): TJSONValue;
begin
  Result := nil;
  if (FData as TJSONObject) <> nil then
    Result := (FData as TJSONObject).GetValue(Name) as TJSONValue;
end;

procedure TTaskResult.SetData(const Value: TJSONValue);
begin
  if FData <> nil then
    FData.Free;

  FData := Value.Clone as TJSONValue;
end;

procedure TTaskResult.SetValues(const Name: string; Value: TJSONValue);
begin
  if not (FData is TJSONObject) then
  begin
    if FData <> nil then
      FData.Free;
    FData := TJSONObject.Create;
  end;

  (FData as TJSONObject).AddPair(TJSONPair.Create(Name, Value));
end;


function TTaskResult.ToJsonString: string;
var
  LJson: TJSONObject;
begin
  LJson := TJSONObject.Create;
  try
    LJson.AddPair(TJSONPair.Create('code', TJSONNumber.Create(FCode)));
    LJson.AddPair(TJSONPair.Create('msg', FMsg));
    LJson.AddPair(TJSONPair.Create('data', Data));

    Result := LJson.ToJSON;
  finally
    LJson.Free;
  end;
end;

end.
