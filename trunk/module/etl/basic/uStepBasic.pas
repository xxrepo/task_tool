unit uStepBasic;

interface

uses
  System.JSON, uStepDefines, uTaskVar, System.Classes, System.SysUtils, System.Types, uFileLogger;

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
    function GetParamValueFromStepData(AStepData: TStepData; AFieldName,
      ADefaultValue, AParamType: string): Variant;
    function GetContextParamValue(AParamRef, AParamType: string;
      ADefaultValue: Variant): Variant;
  protected
    FSubSteps: TJSONArray;
    FTaskBlock: TTaskBlock; //表明本step运行的所在的任务块
    FTaskVar: TTaskVar;     //表明整个task的全局context环境
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
    function GetParamValue(AParamRef: string; AParamType: string; ADefaultValue: Variant): Variant; overload;
    function GetSelfParamValue(AParamRef, AParamType: string; ADefaultValue: Variant): Variant; virtual;

    procedure StartSelfDesign; virtual;
  public
    property StepConfig: TStepConfig read FStepConfig write FStepConfig;
    property SubSteps: TJSONArray read FSubSteps write FSubSteps;
    property TaskBlock: TTaskBlock read FTaskBlock write FTaskBlock;
    property TaskVar: TTaskVar read GetTaskVar write SetTaskVar;
    property InData: TStepData read GetInData write SetInData;
    property OudData: TStepData read GetOutData write SetOutData;

    procedure ParseStepConfig(AConfigJsonStr: string); virtual;

    procedure Start; virtual;
    procedure StartDesign; virtual;

    procedure MakeStepConfigJson(var AToConfig: TJSONObject); virtual;

    constructor Create(ATaskVar: TTaskVar);
    destructor Destroy; override;


    function GetRealAbsolutePath(APath: string): string;
    procedure LogMsg(AMsg: string; ALogLevel: TLogLevel = llAll);
  end;

  TStepNull = type TStepBasic;

implementation

uses uFunctions, uDefines, uExceptions, uStepFactory, System.StrUtils, uFileUtil, uTaskDefine;


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
  Result := '[' + TaskVar.TaskVarRec.TaskName + '][' + FTaskBlock.BlockName + '][' + FStepConfig.StepTitle + ']：' + ALogMsg;
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
      end
      else if LParamRef = 'context' then
      begin
        Result := GetContextParamValue(LParamNames.DelimitedText, AParamType, ADefaultValue);
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



function TStepBasic.GetContextParamValue(AParamRef, AParamType: string;
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
    if LParamNames.Count = 1 then
      LParamNames.Add('*');

    if LParamNames.Count > 1 then
    begin
      LFieldName := LParamNames.Strings[LParamNames.Count - 1];
      LParamNames.Delete(LParamNames.Count - 1);
      LStepData := GetStepDataFrom('context.' + LParamNames.DelimitedText);

      Result := GetParamValueFromStepData(LStepData, LFieldName, ADefaultValue, AParamType);
    end;
  finally
    LParamNames.Free;
  end;
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

    Result := GetParamValueFromStepData(LStepData, LFieldName, ADefaultValue, AParamType);
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

    if LParamNames.Count = 1 then
      LParamNames.Add('*');

    if LParamNames.Count > 1 then
    begin
      LFieldName := LParamNames.Strings[LParamNames.Count - 1];
      LParamNames.Delete(LParamNames.Count - 1);
      LStepData := GetStepDataFrom('task.' + LParamNames.DelimitedText);

      Result := GetParamValueFromStepData(LStepData, LFieldName, ADefaultValue, AParamType);
    end;
  finally
    LParamNames.Free;
  end;
end;

function TStepBasic.GetParamValueFromStepData(AStepData: TStepData; AFieldName: string; ADefaultValue: string; AParamType: string): Variant;
var
  LJson: TJSONObject;
begin
  Result := ADefaultValue;

  if AFieldName = '*' then
  begin
    Result := AStepData.Data;
  end
  else
  begin
    LJson := TJSONObject.ParseJSONValue(AStepData.Data) as TJSONObject;
    if LJson <> nil then
    begin
      Result := GetJsonObjectValue(LJson, AFieldName, ADefaultValue, AParamType);

      LJson.Free;
    end;
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
      end
      else if LParamRef = 'context' then
      begin
        if LParamNames.Count = 0 then
        begin
          StopExceptionRaise('获取context.的数据必须包含具体Step的名称');
        end
        else
        begin
          Result := TaskVar.GetContextStepData(LParamNames.Strings[0]);
          LParamNames.Delete(0);
        end;
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


procedure TStepBasic.LogMsg(AMsg: string; ALogLevel: TLogLevel);
begin
  TaskVar.Logger.Log(FormatLogMsg(AMsg), ALogLevel);
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

      TaskVar.StartStep(TaskBlock, LStepConfigJson, @FOutData);
    end;
  end;
end;




//对于Step提供设计阶段的支持，后续可以优化成独立的类
procedure TStepBasic.StartDesign;
begin
  StartSelfDesign;

  //注册数据
  if FStepConfig.RegDataToTask then
    RegOutDataToTaskVar;

  StartChildren();
end;


procedure TStepBasic.StartSelfDesign;
begin

end;


initialization
RegisterClass(TStepNull);


finalization
UnRegisterClass(TStepNull);



end.
