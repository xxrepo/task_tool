unit uTaskResult;

interface

uses System.Generics.Collections;

type
  TTaskResult = class
  private
    FCode: Integer;
    FMsg: string;
    FData: TDictionary<string, string>;

    function GetData: string;
    function GetValues(const Name: string): string;
    procedure SetValues(const Name, Value: string);
    procedure SetData(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property Code: Integer read FCode write FCode;
    property Msg: string read FMsg write FMsg;
    property Data: string read GetData write SetData;
    property Values[const Name: string]: string read GetValues write SetValues;

    function ToJsonString: string;
  end;

implementation

uses uFunctions, System.JSON;

{ TTaskResult }

constructor TTaskResult.Create;
begin
  inherited;
  FCode := -1;
  FMsg := '很抱歉，暂未处理您的任务';
  FData := TDictionary<string, string>.Create;
end;


destructor TTaskResult.Destroy;
begin
  FData.Free;
  inherited;
end;


function TTaskResult.GetData: string;
var
  i: Integer;
  LArray: TArray<TPair<string, string>>;
  LValuesJson: TJsonObject;
begin
  FData.TryGetValue('vv_data_no_meaning_idx', Result);

  if Result = '' then
  begin
    LArray := FData.ToArray;
    try
      LValuesJson := TJSONObject.Create;
      for i := Low(LArray) to High(LArray) do
      begin
        LValuesJson.AddPair(TJSONPair.Create(LArray[i].Key, LArray[i].Value));
      end;
      Result := LValuesJson.ToJSON;
    finally
      LValuesJson.Free;
    end;
  end;
end;

function TTaskResult.GetValues(const Name: string): string;
begin
  FData.TryGetValue(Name, Result);
end;


procedure TTaskResult.SetData(const Value: string);
begin
  FData.AddOrSetValue('vv_data_no_meaning_idx', Value);
end;

procedure TTaskResult.SetValues(const Name, Value: string);
begin
  FData.AddOrSetValue(Name, Value);
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
