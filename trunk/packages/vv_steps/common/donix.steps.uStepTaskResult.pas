unit donix.steps.uStepTaskResult;
interface

uses
  uStepBasic, System.JSON, System.IniFiles;

type
  TStepTaskResult = class (TStepBasic)
  private
    FCode: string;
    FMsg: string;
    FFieldParams: string;
    FExitTask: Boolean;
  protected
    procedure StartSelf; override;
    procedure StartSelfDesign; override;

  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property Code: string read FCode write FCode;
    property Msg: string read FMsg write FMsg;
    property FieldParams: string read FFieldParams write FFieldParams;
    property ExitTask: Boolean read FExitTask write FExitTask;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions,
  uStepDefines;

{ TStepQuery }

procedure TStepTaskResult.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('out_params', FFieldParams));
  AToConfig.AddPair(TJSONPair.Create('code', FCode));
  AToConfig.AddPair(TJSONPair.Create('msg', FMsg));
  AToConfig.AddPair(TJSONPair.Create('exit', BoolToStr(FExitTask)));
end;


procedure TStepTaskResult.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFieldParams := GetJsonObjectValue(StepConfig.ConfigJson, 'out_params');
  FCode := GetJsonObjectValue(StepConfig.ConfigJson, 'code');
  FMsg := GetJsonObjectValue(StepConfig.ConfigJson, 'msg');
  FExitTask := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'exit'), True);
end;


procedure TStepTaskResult.StartSelfDesign;
begin
  StartSelf;
end;


procedure TStepTaskResult.StartSelf;
var
  i: Integer;
  LFieldJson: TJSONObject;
  LFieldParamsJsonArray: TJSONArray;
begin
  try
    CheckTaskStatus;

    LFieldParamsJsonArray := TJSONObject.ParseJSONValue(FFieldParams) as TJSONArray;
    if LFieldParamsJsonArray = nil then Exit;

    try
      //处理
      for i := 0 to LFieldParamsJsonArray.Count - 1 do
      begin
        LFieldJson := LFieldParamsJsonArray.Items[i] as TJSONObject;
        if LFieldJson = nil then Continue;
        TaskVar.TaskResult.Values[GetJsonObjectValue(LFieldJson, 'param_name')] := StrToJsonValue(GetParamValue(LFieldJson));
      end;
    finally
      LFieldParamsJsonArray.Free;
    end;
  finally
    TaskVar.TaskResult.Code := StrToIntDef(FCode, 0);
    TaskVar.TaskResult.Msg := FMsg;

    //判断是否要退出Task
    if ExitTask then
      raise StopTaskGracefulException.Create(FormatLogMsg('Exit Task'));
  end;
end;


end.
