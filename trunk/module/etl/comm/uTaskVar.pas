unit uTaskVar;

interface

uses
  uDbConMgr, System.Classes, uDefines, uStepDefines, uFileLogger, uGlobalVar,
  System.SysUtils, System.JSON;

type
  TTaskVarRec = record
    FileName: string;
    TaskName: string;
    RunBasePath: string;
    DbsFileName: string;
  end;

  TTaskMode = (tmNormal, tmDesigning, tmDebug);

  TTaskVar = class
  private
    FOwner: TObject;
    FStepDataList: TStringList;
    FRegistedObjectList: TStringList;

    FStepStack: TStringList;

    FToStepId: Integer;

    FTaskMode: TTaskMode;

    function PushStep(AStep: TObject): Integer;
    procedure PopStep(AStep: TObject);
    procedure PopSteps;

  public
    TaskVarRec: TTaskVarRec;
    GlobalVar: TGlobalVar;

    Logger: TThreadFileLog;

    DbConMgr: TDbConMgr;
    TaskStatus: TTaskRunStatus;

    function RegStepData(ADataRef: string; ADataValue: TStepData): Integer;
    function GetStepData(ADataRef: string): TStepData;
    function RegObject(ARef: string; AObject: TObject): Integer;
    function GetObject(ARef: string): TObject;

    constructor Create(AOwner: TObject; ATaskVarRec: TTaskVarRec);
    destructor Destroy; override;


    procedure InitStartContext;
    procedure StartStep(AStepConfigJson: TJSONObject; AInData: PStepData);


    procedure DesignToStep(AStepId: Integer);
    procedure DebugToStep(AStepId: Integer);

    property RegistedObjectList: TStringList read FRegistedObjectList;
    property StepStack: TStringList read FStepStack;
    property ToStepId: Integer read FToStepId;
  end;

implementation

uses uStepBasic, uFunctions, uStepFactory, uExceptions;

type
  TStepDataStore = class
  public
    DataRef: string;
    Value: TStepData;
  end;

{ TTaskVar }

constructor TTaskVar.Create(AOwner: TObject; ATaskVarRec: TTaskVarRec);
begin
  FStepStack := TStringList.Create;

  FToStepId := -1;
  FTaskMode := tmNormal;

  FOwner := AOwner;
  TaskVarRec := ATaskVarRec;

  Logger := TThreadFileLog.Create(0,
                       TaskVarRec.RunBasePath + 'task_log\'+ TaskVarRec.TaskName,
                       '_yyyymmdd');
  FStepDataList := TStringList.Create;
  FRegistedObjectList := TStringList.Create;

  DbConMgr := TDbConMgr.Create;
  DbConMgr.LoadDbConfigs(TaskVarRec.DbsFileName);
end;


procedure TTaskVar.DebugToStep(AStepId: Integer);
begin
  FToStepId := AStepId;
  FTaskMode := tmDebug;
end;

procedure TTaskVar.DesignToStep(AStepId: Integer);
begin
  FToStepId := AStepId;
  FTaskMode := tmDesigning;
end;

destructor TTaskVar.Destroy;
var
  i: Integer;
  LStepData: TStepDataStore;
begin
  //释放各个Step
  PopSteps;
  FStepStack.Free;

  DbConMgr.Free;
  FRegistedObjectList.Free;

  for i := 0 to FStepDataList.Count - 1 do
  begin
    LStepData := TStepDataStore(FStepDataList.Objects[i]);
    if LStepData <> nil then
      LStepData.Free;
  end;
  FStepDataList.Free;

  Logger.Free;
  GlobalVar := nil;
  inherited;
end;


function TTaskVar.GetStepData(ADataRef: string): TStepData;
var
  idx: Integer;
  LStepData: TStepDataStore;
begin
  idx := FStepDataList.IndexOf(ADataRef);
  if idx > -1 then
  begin
    LStepData := TStepDataStore(FStepDataList.Objects[idx]);
    if LStepData <> nil then
    begin
      Result := LStepData.Value;
    end;
  end;
end;


function TTaskVar.RegStepData(ADataRef: string; ADataValue: TStepData): Integer;
var
  LStepData: TStepDataStore;
  Idx: Integer;
begin
  Idx := FStepDataList.IndexOf(ADataRef);
  if Idx > -1 then
  begin
    LStepData := TStepDataStore(FStepDataList.Objects[Idx]);
    if LStepData <> nil then
      LStepData.Free;
    FStepDataList.Delete(Idx);
  end;

  LStepData := TStepDataStore.Create;
  LStepData.DataRef := ADataRef;
  LStepData.Value := ADataValue;
  Result := FStepDataList.AddObject(ADataRef, LStepData);
end;

function TTaskVar.GetObject(ARef: string): TObject;
var
  idx: Integer;
  LRefs: TStringList;
begin
  Result := nil;
  LRefs := TStringList.Create;
  try
    LRefs.Delimiter := '.';
    LRefs.DelimitedText := ARef;
    if LRefs.Count = 2 then
    begin
      idx := FRegistedObjectList.IndexOf(LRefs.Strings[1]);
    end
    else
      idx := FRegistedObjectList.IndexOf(ARef);

    if idx > -1 then
    begin
      Result := FRegistedObjectList.Objects[idx];
    end;
  finally
    LRefs.Free;
  end;
end;


function TTaskVar.RegObject(ARef: string; AObject: TObject): Integer;
var
  Idx: Integer;
begin
  Idx := FRegistedObjectList.IndexOf(ARef);
  if Idx > -1 then
  begin
    FRegistedObjectList.Delete(Idx);
  end;

  Result := FRegistedObjectList.AddObject(ARef, AObject);
end;



procedure TTaskVar.InitStartContext;
begin
  TaskStatus := trsRunning;
  PopSteps;
end;


procedure TTaskVar.StartStep(AStepConfigJson: TJSONObject; AInData: PStepData);
var
  LStep: TStepBasic;
  LStepType: string;
begin
  if AStepConfigJson = nil then
  begin
    Logger.Error('[' + TaskVarRec.TaskName + ']Step配置解析异常退出');
    Exit;
  end;
  if TaskStatus = trsSuspend then
  begin
    Logger.Warn('任务状态为：trsSuspend，退出');
    Exit;
  end;

  //获取当前Step的相关参数
  try
    if StrToInt(GetJsonObjectValue(AStepConfigJson, 'step_status', '0')) > 1 then //checked or partialy checked
    begin
      //调用工厂类
      LStepType := GetJsonObjectValue(AStepConfigJson, 'step_type');
      LStep := TStepFactory.GetStep(LStepType, Self);
      if (LStep <> nil) then
      begin
        try
          //处理入参和初始设置
          LStep.TaskVar := Self;
          LStep.InData := AInData^;
          LStep.SubSteps := AStepConfigJson.GetValue('sub_steps') as TJSONArray;
          LStep.StepConfig.StepId := GetJsonObjectValue(AStepConfigJson, 'step_abs_id', '-1', 'int');
          LStep.StepConfig.StepType := GetJsonObjectValue(AStepConfigJson, 'step_type');
          LStep.StepConfig.StepTitle := GetJsonObjectValue(AStepConfigJson, 'step_title');
          LStep.StepConfig.StepStatus := StrToInt(GetJsonObjectValue(AStepConfigJson, 'step_status', '0'));
          LStep.ParseStepConfig(GetJsonObjectValue(AStepConfigJson, 'step_config'));

          LStep.LogMsg('任务执行：入参数据：' + LStep.InData.Data, llDebug);

          //在设计模式或者debug模式中，允许运行到指定的步骤，不再执行后面的Step
          if (FToStepId > -1) then
          begin
            if (LStep.StepConfig.StepId <= FToStepId) then
            begin
              //入栈
              PushStep(LStep);

              if FTaskMode = tmDesigning then
                LStep.StartDesign
              else
                LStep.Start;

              //如果已经匹配相等，设置后续的执行状态为Suspend
              if LStep.StepConfig.StepId = FToStepId then
                TaskStatus := trsSuspend
            end
            else
            begin
              //停止入栈和Task的执行，task状态进入到trsSuspend，出栈时并不真实释放LStep，改由Stack进行统一管理
              TaskStatus := trsSuspend;
              //立刻释放掉
              LStep.Free;
            end;
          end
          else
          begin
            //入栈
            PushStep(LStep);
            LStep.Start;
          end;
        finally
          //出栈
          PopStep(LStep);
        end;
      end
      else
      begin
        Logger.Error('Step Factory中未有匹配到对应的step_type:' + LStepType);
        raise StopTaskException.Create('Step Factory中未有匹配到对应的step_type:' + LStepType);
      end;
    end;
  finally

  end;
end;


function TTaskVar.PushStep(AStep: TObject): Integer;
var
  LStep: TStepBasic;
begin
  LStep := TStepBasic(AStep);
  Result := FStepStack.AddObject(IntToStr(LStep.StepConfig.StepId), AStep);
end;

procedure TTaskVar.PopStep(AStep: TObject);
var
  idx: Integer;
  LStep: TStepBasic;
begin
  if TaskStatus = trsSuspend then Exit;

  LStep := TStepBasic(AStep);
  if LStep <> nil then
  begin
    idx := FStepStack.IndexOf(IntToStr(LStep.StepConfig.StepId));
    LStep.Free;
    FStepStack.Delete(idx);
  end;
end;

procedure TTaskVar.PopSteps;
var
  i: Integer;
begin
  for i := FStepStack.Count - 1 downto 0 do
  begin
    PopStep(FStepStack.Objects[i]);
  end;
end;


end.
