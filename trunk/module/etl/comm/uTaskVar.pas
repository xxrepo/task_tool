unit uTaskVar;

interface

uses
  uDbConMgr, System.Classes, uDefines, uStepDefines, uFileLogger, uGlobalVar;

type
  TTaskVarRec = record
    FileName: string;
    TaskName: string;
    RunBasePath: string;
    DbsFileName: string;
  end;

  TTaskVar = class
  private
    FOwner: TObject;
    FStepDataList: TStringList;
  public
    TaskVarRec: TTaskVarRec;
    GlobalVar: TGlobalVar;

    Logger: TThreadFileLog;

    DbConMgr: TDbConMgr;
    TaskStatus: TTaskRunStatus;

    function RegStepData(ADataRef: string; ADataValue: TStepData): Integer;
    function GetStepData(ADataRef: string): TStepData;

    constructor Create(AOwner: TObject; ATaskVarRec: TTaskVarRec);
    destructor Destroy; override;
  end;

implementation

type
  TStepDataStore = class
  public
    DataRef: string;
    Value: TStepData;
  end;

{ TTaskVar }

constructor TTaskVar.Create(AOwner: TObject; ATaskVarRec: TTaskVarRec);
begin
  FOwner := AOwner;
  TaskVarRec := ATaskVarRec;

  Logger := TThreadFileLog.Create(0,
                       TaskVarRec.RunBasePath + 'task_log\'+ TaskVarRec.TaskName,
                       '_yyyymmdd');
  FStepDataList := TStringList.Create;
  DbConMgr := TDbConMgr.Create;
  DbConMgr.LoadDbConfigs(TaskVarRec.DbsFileName);
end;


destructor TTaskVar.Destroy;
var
  i: Integer;
  LStepData: TStepDataStore;
begin
  DbConMgr.Free;
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

end.
