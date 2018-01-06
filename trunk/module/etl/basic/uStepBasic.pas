unit uStepBasic;

interface

uses
  System.JSON, uStepDefines, uTaskVar, System.Classes, System.SysUtils, System.Types;

type
  TStepClass = class of TStepBasic;

  TStepBasic = class(TPersistent)
  private
    FStepConfig: TStepConfig;
    //FStepDefine: TStepDefine;
    FInDataJson: TJSONValue;

    function GetInData: TStepData;
    function GetOutData: TStepData;
    procedure SetInData(const Value: TStepData);
    procedure SetOutData(const Value: TStepData);
    function GetTaskVar: TTaskVar;
    procedure SetTaskVar(const Value: TTaskVar);
    function GetInDataJson: TJSONValue;

    function GetStepDataFrom(AData: TStepData; AParamsRef: TStringList): TStepData; overload;
    function GetInParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; virtual;
    function GetTaskParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; virtual;
  protected
    FSubSteps: TJSONArray;
    FTaskVar: TTaskVar;
    FInData: TStepData;
    FOutData: TStepData;

    property InDataJson: TJSONValue read GetInDataJson;

    procedure StopExceptionRaise(AMsg: string);

    procedure CheckTaskStatus;
    procedure StartSelf; virtual;
    procedure StartChildren(AChildStepTitle: string = ''); virtual;
    procedure RegOutDataToTaskVar; virtual; //ToDo

    function FormatLogMsg(ALogMsg: string): string;

    function GetStepDataFrom(ADataRef: string): TStepData; overload;

    function GetParamValue(AParamConfig: TJSONObject): Variant; overload;
    function GetParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; overload;
    function GetSelfParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; virtual;
  public
    property StepConfig: TStepConfig read FStepConfig write FStepConfig;
    property SubSteps: TJSONArray read FSubSteps write FSubSteps;
    property TaskVar: TTaskVar read GetTaskVar write SetTaskVar;
    property InData: TStepData read GetInData write SetInData;
    property OudData: TStepData read GetOutData write SetOutData;

    procedure ParseStepConfig(AConfigJsonStr: string); virtual;

    procedure Start; virtual;

    procedure MakeStepConfigJson(var AToConfig: TJSONObject); virtual;

    constructor Create(ATaskVar: TTaskVar);
    destructor Destroy; override;


    function GetRealAbsolutePath(APath: string): string;
  end;

  TStepNull = type TStepBasic;

  procedure StartStep(AStepConfigJson: TJSONObject; AInData: PStepData; const ATaskVar: TTaskVar);

implementation

uses uFunctions, uDefines, uExceptions, uStepFactory, System.StrUtils, uFileUtil;


procedure StartStep(AStepConfigJson: TJSONObject; AInData: PStepData; const ATaskVar: TTaskVar);
var
  LStep: TStepBasic;
  LStepType: string;
begin
  if AStepConfigJson = nil then
  begin
    ATaskVar.Logger.Error('[' + ATaskVar.TaskVarRec.TaskName + ']Step配置解析异常退出');
    Exit;
  end;

  //获取当前Step的相关参数
  try
    if StrToInt(GetJsonObjectValue(AStepConfigJson, 'step_status', '0')) > 1 then //checked or partialy checked
    begin
      //调用工厂类
      LStepType := GetJsonObjectValue(AStepConfigJson, 'step_type');
      LStep := TStepFactory.GetStep(LStepType, ATaskVar);
      if (LStep <> nil) then
      begin
        try
          //处理入参和初始设置
          LStep.TaskVar := ATaskVar;
          LStep.InData := AInData^;
          LStep.SubSteps := AStepConfigJson.GetValue('sub_steps') as TJSONArray;
          LStep.StepConfig.StepType := GetJsonObjectValue(AStepConfigJson, 'step_type');
          LStep.StepConfig.StepTitle := GetJsonObjectValue(AStepConfigJson, 'step_title');
          LStep.StepConfig.StepStatus := StrToInt(GetJsonObjectValue(AStepConfigJson, 'step_status', '0'));
          LStep.ParseStepConfig(GetJsonObjectValue(AStepConfigJson, 'step_config'));

          ATaskVar.Logger.Debug(LStep.FormatLogMsg('任务执行：入参数据：' + LStep.InData.Data));

          LStep.Start;
        finally
          LStep.Free;
        end;
      end
      else
      begin
        ATaskVar.Logger.Error('Step Factory中未有匹配到对应的step_type:' + LStepType);
        raise StopTaskException.Create('Step Factory中未有匹配到对应的step_type:' + LStepType);
      end;
    end;
  finally

  end;
end;


{ TStepBasic }

procedure TStepBasic.StopExceptionRaise(AMsg: string);
var
  LMsg: string;
begin
  LMsg := FormatLogMsg(AMsg);
  TaskVar.Logger.Error(LMsg);
  raise StopTaskException.Create(LMsg);
end;

procedure TStepBasic.CheckTaskStatus;
begin
  if FTaskVar.TaskStatus = trsStop then
  begin
    StopExceptionRaise('检测到任务状态为trsStop，任务退出');
  end;
end;


constructor TStepBasic.Create(ATaskVar: TTaskVar);
begin
  FStepConfig := TStepConfig.Create;
  FTaskVar := ATaskVar;
end;


destructor TStepBasic.Destroy;
begin
  FStepConfig.Free;
  if FInDataJson <> nil then
    FInDataJson.Free;
  inherited;
end;

function TStepBasic.FormatLogMsg(ALogMsg: string): string;
begin
  Result := '[' + TaskVar.TaskVarRec.TaskName + '][' + FStepConfig.StepTitle + ']：' + ALogMsg;
end;

function TStepBasic.GetInData: TStepData;
begin
  Result := FInData;
end;


function TStepBasic.GetInDataJson: TJSONValue;
begin
  if FInDataJson = nil then
    FInDataJson := TJSONObject.ParseJSONValue(FInData.Data);
  Result := FInDataJson;
end;



function TStepBasic.GetOutData: TStepData;
begin
  Result := FOutData;
end;


function TStepBasic.GetRealAbsolutePath(APath: string): string;
begin
  //TODO 需要进行解析，有可能包含有某些字段，也有可能包含有一些task. parent. 等等的参数信息
  Result := '';
  if APath <> '' then
    Result := TFileUtil.GetAbsolutePathEx(TaskVar.TaskVarRec.RunBasePath, APath);
end;

function TStepBasic.GetParamValue(AParamConfig: TJSONObject): Variant;
begin
  Result := GetParamValue(GetJsonObjectValue(AParamConfig, 'param_value_ref'),
                          GetJsonObjectValue(AParamConfig, 'param_type'),
                          GetJsonObjectValue(AParamConfig, 'default_value'));
end;


function TStepBasic.GetParamValue(AParamRef: string; AParamType: string; ADefaultValue: Variant): Variant;
var
  LParamNames: TStringList;
  LParamRef: string;

  function GetSystemValue(AParamName: string): Variant;
  begin
    Result := ADefaultValue;
    if AParamName = 'time' then
    begin
      Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
    end
    else if AParamName = 'timestamp' then
    begin
      Result := FloatToStr(Now);
    end;
  end;

begin
  Result := ADefaultValue;
  LParamNames := TStringList.Create;
  try
    LParamNames.Delimiter := '.';
    LParamNames.DelimitedText := AParamRef;

    if LParamNames.Count >= 2 then
    begin
      LParamRef := LParamNames[0];
      LParamNames.Delete(0);
      if LParamRef = 'system' then
      begin
        Result := GetSystemValue(LParamNames.DelimitedText);
      end
      else if LParamRef = 'parent' then
      begin
        Result := GetInParamValue(LParamNames.DelimitedText, AParamType, ADefaultValue);
      end
      else if LParamRef = 'self' then
      begin
        Result := GetSelfParamValue(LParamNames.DelimitedText, AParamType, ADefaultValue);
      end
      else if LParamRef = 'task' then
      begin
        Result := GetTaskParamValue(LParamNames.DelimitedText, AParamType, ADefaultValue);
      end
      else if LParamRef = 'global' then
      begin
        Result := TaskVar.GlobalVar.GetParamValue(LParamNames.DelimitedText, AParamType, ADefaultValue);
      end;
    end
    else if LParamNames.Count = 1 then
    begin
      Result := AParamRef;
    end;
  finally
    LParamNames.Free;
  end;

  Result := VariantValueByDataType(Result, AParamType);
end;



function TStepBasic.GetSelfParamValue(AParamRef, AParamType: string;
  ADefaultValue: Variant): Variant;
begin
  Result := ADefaultValue;
end;


function TStepBasic.GetInParamValue(AParamRef, AParamType: string;
  ADefaultValue: Variant): Variant;
var
  LStepData: TStepData;
  LParamNames: TStringList;
  LFieldName: string;
  LJson: TJSONObject;
begin
  Result := ADefaultValue;
  if (AParamRef = '*') or (Trim(AParamRef) = '') then
  begin
    Result := FInData.Data;
    Exit;
  end;

  LParamNames := TStringList.Create;
  LParamNames.Delimiter := '.';
  LParamNames.DelimitedText := AParamRef;
  try

    if LParamNames.Count > 1  then
    begin
      LFieldName := LParamNames.Strings[LParamNames.Count - 1];
      LParamNames.Delete(LParamNames.Count - 1);
      LStepData := GetStepDataFrom(FInData, LParamNames);
    end
    else if LParamNames.Count = 1 then
    begin
      LFieldName := AParamRef;
      LStepData := FInData;
    end;

    LJson := TJSONObject.ParseJSONValue(LStepData.Data) as TJSONObject;
    if LJson <> nil then
    begin
      Result := GetJsonObjectValue(LJson, LFieldName, ADefaultValue);
      LJson.Free;
    end;
  finally
    LParamNames.Free;
  end;
end;


function TStepBasic.GetTaskParamValue(AParamRef, AParamType: string;
  ADefaultValue: Variant): Variant;
var
  LStepData: TStepData;
  LParamNames: TStringList;
  LJson: TJSONObject;
  LFieldName: string;
begin
  Result := ADefaultValue;
  LParamNames := TStringList.Create;
  try
    LParamNames.Delimiter := '.';
    LParamNames.DelimitedText := AParamRef;

    if LParamNames.Count > 1 then
    begin
      LFieldName := LParamNames.Strings[LParamNames.Count - 1];
      LParamNames.Delete(LParamNames.Count - 1);
      LStepData := GetStepDataFrom('task.' + LParamNames.DelimitedText);
      if LFieldName = '*' then
      begin
        Result := LStepData.Data;
      end
      else
      begin
        LJson := TJSONObject.ParseJSONValue(LStepData.Data) as TJSONObject;
        if LJson <> nil then
        begin
          Result := GetJsonObjectValue(LJson, LFieldName, ADefaultValue, AParamType);

          LJson.Free;
        end;
      end;
    end;
  finally
    LParamNames.Free;
  end;
end;


{修改支持对长路径的实现}
function TStepBasic.GetStepDataFrom(ADataRef: string): TStepData;
var
  LParamNames: TStringList;
  LParamRef: string;
begin
  LParamNames := TStringList.Create;
  try
    LParamNames.Delimiter := '.';
    LParamNames.DelimitedText := ADataRef;

    //目前仅支持task和parent两个数据集的获取

    if LParamNames.Count > 0 then
    begin
      LParamRef := LParamNames[0];
      LParamNames.Delete(0);
      if LParamRef = 'task' then
      begin
        if LParamNames.Count = 0 then
        begin
          StopExceptionRaise('获取task.的数据必须包含具体Step的名称');
        end
        else
        begin
          Result := TaskVar.GetStepData(LParamNames.Strings[0]);
          LParamNames.Delete(0);
        end;
      end
      else if LParamRef = 'parent' then
      begin
        Result := FInData;
      end
      else if LParamRef = 'self' then
      begin
        Result := FOutData;
      end
      else if LParamRef = 'global' then
      begin
        Result.DataType := sdtText;
        Result.Data := TaskVar.GlobalVar.Values;
      end;

      //对于更加有深度的数据集获取，需要调用进一步的路径参数
      if LParamNames.Count > 0 then
      begin
        if LParamNames.Strings[0] <> '*' then
          Result := GetStepDataFrom(Result, LParamNames);
      end;
    end
  finally
    LParamNames.Free;
  end;
end;

function TStepBasic.GetStepDataFrom(AData: TStepData; AParamsRef: TStringList): TStepData;
var
  LJsonObject: TJSONObject;
  LParamRef: string;
begin
  if AParamsRef.Count = 0 then Exit;
  if AParamsRef.Strings[0] = '*' then
  begin
    Result := AData;
    Exit;
  end;

  LJsonObject := TJSONObject.ParseJSONValue(AData.Data) as TJSONObject;
  if LJsonObject = nil then Exit;

  try
    LParamRef := AParamsRef[0];
    AParamsRef.Delete(0);
    Result.Data := GetJsonObjectValue(LJsonObject, LParamRef);
    Result.DataType := sdtText;
    if AParamsRef.Count > 0 then
      Result := GetStepDataFrom(Result, AParamsRef);
  finally
    LJsonObject.Free;
  end;

end;



function TStepBasic.GetTaskVar: TTaskVar;
begin
  Result := FTaskVar;
end;


procedure TStepBasic.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  AToConfig.AddPair(TJSONPair.Create('step_title', StepConfig.StepTitle));
  AToConfig.AddPair(TJSONPair.Create('description', StepConfig.Description));
  AToConfig.AddPair(TJSONPair.Create('reg_data_to_task', BoolToStr(FStepConfig.RegDataToTask)));
end;


procedure TStepBasic.ParseStepConfig(AConfigJsonStr: string);
begin
  FStepConfig.ConfigJsonStr := AConfigJsonStr;
  FStepConfig.StepTitle := GetJsonObjectValue(FStepConfig.ConfigJson, 'step_title');
  FStepConfig.Description := GetJsonObjectValue(FStepConfig.ConfigJson, 'description');
  FStepConfig.RegDataToTask := StrToBoolDef(GetJsonObjectValue(FStepConfig.ConfigJson, 'reg_data_to_task'), False);
end;



procedure TStepBasic.RegOutDataToTaskVar;
begin
  TaskVar.RegStepData(StepConfig.StepTitle, FOutData);
end;

procedure TStepBasic.SetInData(const Value: TStepData);
begin
  FInData := Value;
end;

procedure TStepBasic.SetOutData(const Value: TStepData);
begin
  FOutData := Value;
end;

procedure TStepBasic.SetTaskVar(const Value: TTaskVar);
begin
  FTaskVar := Value;
end;


procedure TStepBasic.Start;
begin
  StartSelf;

  //注册数据
  if FStepConfig.RegDataToTask then
    RegOutDataToTaskVar;

  StartChildren;
end;


procedure TStepBasic.StartSelf;
begin

end;


procedure TStepBasic.StartChildren(AChildStepTitle: string = '');
var
  i: Integer;
  LStepConfigJson: TJSONObject;
begin
  //对ChildrenStep进行循环调用
  if (FSubSteps <> nil) then
  begin
    for i := 0 to FSubSteps.Count - 1 do
    begin
      LStepConfigJson := FSubSteps.Items[i] as TJSONObject;

      if (AChildStepTitle <> '')
          and (GetJsonObjectValue(LStepConfigJson, 'step_title') <> AChildStepTitle) then Continue;

      StartStep(LStepConfigJson, @FOutData, TaskVar);
    end;
  end;
end;


initialization
RegisterClass(TStepNull);


finalization
UnRegisterClass(TStepNull);



end.
