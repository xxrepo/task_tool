unit uTask;

interface

uses
  uTaskVar, System.JSON, uStepBasic, uStepDefines, System.SysUtils, System.Classes, System.Contnrs,
  uTaskDefine;

type

  TTaskUtil = class
  public
    class function ReadConfigFrom(ATaskFile: string): TTaskCongfigRec;
    class procedure WriteConfigTo(ATaskConfigRec: TTaskCongfigRec; ATaskFile: string);
  end;


  TTask = class
  private
  public
    TaskVar: TTaskVar;
    TaskConfigRec: TTaskCongfigRec;

    constructor Create(ATaskCongfigRec: TTaskCongfigRec);
    destructor Destroy; override;

    //运行
    procedure Start(const AInitData: PStepData = nil);


  end;

implementation

uses uExceptions, uFunctions, uStepFactory, uDefines, uThreadSafeFile;

const
  VER: string = '1.0.0';

{ TStepUtil }


class function TTaskUtil.ReadConfigFrom(ATaskFile: string): TTaskCongfigRec;
var
  LFileText: string;
  LTaskConfigJson: TJSONObject;
begin
  if not FileExists(ATaskFile) then Exit;

  LFileText := TThreadSafeFile.ReadContentFrom(ATaskFile);
  Result.FileName := ATaskFile;
  Result.TaskName := ChangeFileExt(ExtractFileName(ATaskFile), '');
  Result.Version := VER;

  LTaskConfigJson := TJSONObject.ParseJSONValue(LFileText) as TJSONObject;
  if LTaskConfigJson = nil then Exit;

  try
    Result.Auth := GetJsonObjectValue(LTaskConfigJson, 'auth', 'Dony.ZHANG');
    Result.StepsStr := GetJsonObjectValue(LTaskConfigJson, 'steps');
  finally
    LTaskConfigJson.Free;
  end;
end;


class procedure TTaskUtil.WriteConfigTo(ATaskConfigRec: TTaskCongfigRec;
  ATaskFile: string);
var
  LTaskConfigJson: TJSONObject;
begin
  LTaskConfigJson := TJSONObject.Create;
  try
    LTaskConfigJson.AddPair(TJSONPair.Create('task_name', ATaskConfigRec.TaskName));
    LTaskConfigJson.AddPair(TJSONPair.Create('version', VER));
    LTaskConfigJson.AddPair(TJSONPair.Create('auth', 'Dony.ZHANG'));
    LTaskConfigJson.AddPair(TJSONPair.Create('steps', ATaskConfigRec.StepsStr));

    TThreadSafeFile.WriteContentTo(ATaskFile, LTaskConfigJson.ToJSON);
  finally
    LTaskConfigJson.Free;
  end;
end;


{ TTask }

constructor TTask.Create(ATaskCongfigRec: TTaskCongfigRec);
var
  LTaskVarRec: TTaskVarRec;
begin
  inherited Create;

  TaskConfigRec := ATaskCongfigRec;
  LTaskVarRec.FileName := TaskConfigRec.FileName;
  LTaskVarRec.DbsFileName := TaskConfigRec.DBsConfigFile;
  LTaskVarRec.TaskName := TaskConfigRec.TaskName;
  LTaskVarRec.RunBasePath := TaskConfigRec.RunBasePath;
  TaskVar := TTaskVar.Create(self, LTaskVarRec);
end;

destructor TTask.Destroy;
begin
  TaskVar.Free;
  inherited;
end;


procedure TTask.Start(const AInitData: PStepData = nil);
var
  LTaskConfigJson: TJSONObject;
  //LInitInData: TStepData;
  LTaskBlock: TTaskBlock;
begin
  LTaskConfigJson := TJSONObject.ParseJSONValue(TaskConfigRec.StepsStr) as TJSONObject;
  if LTaskConfigJson = nil then
    raise TaskConfigException.Create('task配置文件加载异常，请确认Task文件正常保存后再运行');

  try
    //本入口是顶级BlockName的入口，所有task启动时的起始入口
    LTaskBlock.BlockName := '';
    LTaskBlock._ENTRY_FILE := TaskConfigRec.FileName;

    TaskVar.TaskVarRec.TaskName := TaskConfigRec.TaskName;
    TaskVar.TaskVarRec.RunBasePath := TaskConfigRec.RunBasePath;
    try
      //清空调用栈
      TaskVar.InitStartContext;
      TaskVar.StartStep(LTaskBlock, LTaskConfigJson, AInitData);//@LInitInData);
    except
      on E: StepException do
      begin
        TaskVar.Logger.Error('Task.Start中遇到StepException异常');
      end;
      on E: StopTaskException do
      begin
        TaskVar.Logger.Error('任务执行终止');
      end;
    end;
  finally
    LTaskConfigJson.Free;
    TaskVar.TaskStatus := trsStop;
  end;
end;


end.
