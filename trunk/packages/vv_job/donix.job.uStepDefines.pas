unit donix.job.uStepDefines;

interface

uses System.JSON, System.SysUtils;

type
  //Step中数据的几个类型，实际上目前仅仅支持文本型，暂时不做其他处理
  TStepDataType = (sdtText, sdtJsonValue, sdtJsonArray, sdtJsonObject);

  PStepData = ^TStepData;

  //用于表明对Step中主要传替的数据的描述
  TStepData = record
    DataType: TStepDataType;
    Data: string;
    JsonValue: TJSONValue;
  end;


  TStepParamValue = string;

  //Step的类型
  TStepType = string;

  //仅仅表明一个Step的定义
  TStepDefine = record
    DllNameSpace: string;
    StepTypeId: Integer;
    StepType: TStepType;
    StepTypeName: string;
    StepClassName: string;
    FormClassName: string;
  end;


  //对一个实际Step配置的描述
  TStepConfig = class
  private
    FConfigJson: TJSONObject;
    FConfigJsonStr: string;
    function GetConfigJson: TJSONObject;
    function GetConfigJsonStr: string;
    procedure SetConfigJsonStr(const Value: string);
  public
    StepId: Integer;

    StepType: TStepType;
    StepTitle: string;
    Description: string;
    RegDataToTask: Boolean;
    StepStatus: Integer;

    property ConfigJsonStr: string read GetConfigJsonStr write SetConfigJsonStr;
    property ConfigJson: TJSONObject read GetConfigJson;

    destructor Destroy; override;
  end;


implementation

uses uFunctions;

{ TStepConfig }

destructor TStepConfig.Destroy;
begin
  if FConfigJson <> nil then
    FreeAndNil(FConfigJson);
  inherited;
end;

function TStepConfig.GetConfigJson: TJSONObject;
begin
  if FConfigJson = nil then
    FConfigJson := TJSONObject.ParseJSONValue(FConfigJsonStr) as TJSONObject;
  Result := FConfigJson;
end;

function TStepConfig.GetConfigJsonStr: string;
begin
  Result := FConfigJsonStr;
end;

procedure TStepConfig.SetConfigJsonStr(const Value: string);
begin
  if FConfigJsonStr <> Value then
  begin
    if FConfigJson <> nil then
      FConfigJson.Free;
    FConfigJsonStr := Value;
  end;
end;

end.
