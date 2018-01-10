unit uTaskVar;

interface

uses
  uDbConMgr, System.Classes, uDefines, uTaskDefine, uStepDefines, uFileLogger, uGlobalVar,
  System.SysUtils, System.JSON;

type
  TTaskVarRec = record
    FileName: string;
    TaskName: string;
    RunBasePath: string;
    DbsFileName: string;
  end;

  PTaskBlock = ^TTaskBlock;

  TTaskBlock = record
    BlockName: string;
    _ENTRY_FILE: string; //用于标记任务最开始执行的入口文件，主要对子任务调试时使用
  end;

  TTaskStep = record
    OwnerBlock: TTaskBlock;
    Id: Integer;
  end;

  TTaskMode = (tmNormal, tmDesigning, tmDebug);

  TTaskVar = class
  private
    FOwner: TObject;
    FStepDataList: TStringList;
    FRegistedObjectList: TStringList;

    FStepStack: TStringList;

    FToStep: TTaskStep;

    FTaskMode: TTaskMode;

    function PushStep(const ATaskStep: TTaskStep; const AStep: TObject): Integer;
    procedure PopStep(const ATaskStep: TTaskStep);
    procedure PopSteps;
    function GetTaskStepIdxName(ATaskStep: TTaskStep): string;
  public
    TaskVarRec: TTaskVarRec;
    GlobalVar: TGlobalVar;

    Logger: TThreadFileLog;

    DbConMgr: TDbConMgr;
    TaskStatus: TTaskRunStatus;

    function RegStepData(ADataRef: string; ADataValue: TStepData): Integer;
    function GetStepData(ADataRef: string): TStepData;
    function GetContextStepData(ADataRef: string): TStepData;
    function RegObject(ARef: string; AObject: TObject): Integer;
    function GetObject(ARef: string): TObject;

    constructor Create(AOwner: TObject; ATaskVarRec: TTaskVarRec);
    destructor Destroy; override;


    procedure InitStartContext;
    procedure StartStep(const ATaskBlock: TTaskBlock; const AStepConfigJson: TJSONObject; const AInData: PStepData);

    function IsToStep(ATaskStep: TTaskStep): Boolean;
    function GetStepFromStack(ATaskStep: TTaskStep): TObject;

    procedure DesignToStep(AStepId: Integer; ABlock: TTaskBlock);
    procedure DebugToStep(AStepId: Integer; ABlock: TTaskBlock);

    property Owner: TObject read FOwner;
    property RegistedObjectList: TStringList read FRegistedObjectList;
    property ToStep: TTaskStep read FToStep;
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

  FToStep.OwnerBlock.BlockName := '';
  FToStep.Id := -1;

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


procedure TTaskVar.DebugToStep(AStepId: Integer; ABlock: TTaskBlock);
begin
  FToStep.Id := AStepId;
  FToStep.OwnerBlock := ABlock;
  FTaskMode := tmDebug;
end;

procedure TTaskVar.DesignToStep(AStepId: Integer; ABlock: TTaskBlock);
begin
  FToStep.Id := AStepId;
  FToStep.OwnerBlock := ABlock;
  FTaskMode := tmDesigning;
end;

function TTaskVar.IsToStep(ATaskStep: TTaskStep): Boolean;
begin
  Result := (ATaskStep.OwnerBlock.BlockName = FToStep.OwnerBlock.BlockName) and (ATaskStep.Id = FToStep.Id);
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


function TTaskVar.GetStepFromStack(ATaskStep: TTaskStep): TObject;
var
  idx: Integer;
begin
  Result := nil;
  idx := FStepStack.IndexOf(GetTaskStepIdxName(ATaskStep));
  if idx > -1 then
    Result := FStepStack.Objects[idx];
end;

function TTaskVar.GetTaskStepIdxName(ATaskStep: TTaskStep): string;
begin
   Result := ATaskStep.OwnerBlock.BlockName + '/' + IntToStr(ATaskStep.Id);
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

function TTaskVar.GetContextStepData(ADataRef: string): TStepData;
var
  i: Integer;
  LStep: TStepBasic;
begin
  Result.DataType := sdtText;
  Result.Data := '';
  for i := FStepStack.Count - 1 downto 0 do
  begin
    LStep := TStepBasic(FStepStack.Objects[i]);
    if LStep <> nil then
    begin
      if LStep.StepConfig.StepTitle = ADataRef then
      begin
        Result := LStep.OudData;
        Break;
      end;
    end;
  end;
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


procedure TTaskVar.StartStep(const ATaskBlock: TTaskBlock; const AStepConfigJson: TJSONObject; const AInData: PStepData);
var
  LStep: TStepBasic;
  LStepType: string;
  LTaskStep: TTaskStep;
  LStepStatus: Integer;
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
    LStepStatus := StrToInt(GetJsonObjectValue(AStepConfigJson, 'step_status', '0'));
    if (LStepStatus > 1) then //checked or partialy checked
    begin
      //调用工厂类
      LStepType := GetJsonObjectValue(AStepConfigJson, 'step_type');
      LStep := TStepFactory.GetStep(LStepType, Self);
      if (LStep <> nil) then
      begin
        try
          //处理入参和初始设置
          LStep.TaskBlock := ATaskBlock;
          LStep.TaskVar := Self;

          LStep.InData := AInData^;
          LStep.SubSteps := AStepConfigJson.GetValue('sub_steps') as TJSONArray;
          LStep.StepConfig.StepId := GetJsonObjectValue(AStepConfigJson, 'step_abs_id', '-1', 'int');
          LStep.StepConfig.StepType := GetJsonObjectValue(AStepConfigJson, 'step_type');
          LStep.StepConfig.StepTitle := GetJsonObjectValue(AStepConfigJson, 'step_title');
          LStep.StepConfig.StepStatus := LStepStatus;
          LStep.ParseStepConfig(GetJsonObjectValue(AStepConfigJson, 'step_config'));

          LStep.LogMsg('任务执行：入参数据：' + LStep.InData.Data, llDebug);

          LTaskStep.OwnerBlock := ATaskBlock;
          LTaskStep.Id := LStep.StepConfig.StepId;

          //在设计模式或者debug模式中，允许运行到指定的步骤，不再执行后面的Step
          if (FToStep.Id > -1) then
          begin
            if (ATaskBlock.BlockName <> FToStep.OwnerBlock.BlockName)
                or (LStep.StepConfig.StepId <= FToStep.Id) then
            begin
              //入栈
              PushStep(LTaskStep, LStep);

              //如果已经匹配相等，设置后续的执行状态为Suspend
              if IsToStep(LTaskStep) then
                TaskStatus := trsSuspend;

              if FTaskMode = tmDesigning then
                LStep.StartDesign
              else
                LStep.Start;
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
            PushStep(LTaskStep, LStep);
            LStep.Start;
          end;
        finally
          //出栈
          PopStep(LTaskStep);
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


function TTaskVar.PushStep(const ATaskStep: TTaskStep; const AStep: TObject): Integer;
var
  LStepIdxName: string;
begin
  LStepIdxName := GetTaskStepIdxName(ATaskStep);
  Result := FStepStack.AddObject(LStepIdxName, AStep);
end;


procedure TTaskVar.PopStep(const ATaskStep: TTaskStep);
var
  idx: Integer;
  LStep: TStepBasic;
  LStepIdxName: string;
begin
  if TaskStatus = trsSuspend then Exit;

  LStepIdxName := GetTaskStepIdxName(ATaskStep);
  idx := FStepStack.IndexOf(LStepIdxName);
  if idx > -1 then
  begin
    LStep := TStepBasic(FStepStack.Objects[idx]);
    if LStep <> nil then
      FreeAndNil(LStep);
    FStepStack.Delete(idx);
  end;
end;

procedure TTaskVar.PopSteps;
var
  i: Integer;
  LStep: TStepBasic;
begin
  for i := FStepStack.Count - 1 downto 0 do
  begin
    LStep := TStepBasic(FStepStack.Objects[i]);
    if LStep <> nil then
      FreeAndNil(LStep);
    FStepStack.Delete(i);
  end;
end;


end.
