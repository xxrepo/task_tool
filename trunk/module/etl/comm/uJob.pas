unit uJob;

interface

uses System.Classes, uThreadQueueUtil, System.JSON, System.SysUtils, uTask, uStepDefines,
    System.SyncObjs, uFileLogger, uGlobalVar, uTaskDefine;

type
  PJobRequest = ^TJobRequest;

  TJobRequest = record
    JobName: string;
    TaskConfig: TTaskConfigRec;
  end;

  TJobHandleStatus = (jhsNone, jhsWaited, jhsRun);

  TJobConfig = class
  private
    FTaskConfigRec: TTaskConfigRec;
    FHandleStatus: TJobHandleStatus;
    FCritical: TCriticalSection;
    function GetTaskStepsStr: string;
    function GetTaskConfigRec: TTaskConfigRec;
    function GetHandleStatus: TJobHandleStatus;
    procedure SetHandleStatus(const Value: TJobHandleStatus);
  public
    JobName: string;
    TaskFile: string;

    Interval: Integer;
    LastStartTime: TDateTime;
    AllowedTimes: TStringList;
    DisallowedTimes: TStringList;
    TimeOut: Integer;
    Status: Integer;

    //线程不安全参数，仅作为临时的记录
    Task: TTask;
    RunThread: TThread;
    JobRequest: PJobRequest;

    property TaskConfigRec: TTaskConfigRec read GetTaskConfigRec;
    property TaskStepsStr: string read GetTaskStepsStr;
    property HandleStatus: TJobHandleStatus read GetHandleStatus write SetHandleStatus;

    constructor Create;
    destructor Destroy; override;

    procedure ParseScheduleConfig(AScheduleJsonStr: string);
    function CheckSchedule: Boolean;
    function IsTimeOut: Boolean;

    function ToString: string;
    procedure FreeTask;
  end;





implementation

uses uDefines, uFunctions, uTaskVar, Winapi.Windows, uFileUtil, System.DateUtils, uThreadSafeFile;

{ TJobConfig }

constructor TJobConfig.Create;
begin
  inherited;
  FCritical := TCriticalSection.Create;
  AllowedTimes := TStringList.Create;
  DisallowedTimes := TStringList.Create;
end;


destructor TJobConfig.Destroy;
begin
  AllowedTimes.Free;
  DisallowedTimes.Free;
  FCritical.Free;
  inherited;
end;


function TJobConfig.GetHandleStatus: TJobHandleStatus;
begin
  Result := FHandleStatus;
end;

function TJobConfig.GetTaskConfigRec: TTaskConfigRec;
begin
  if FTaskConfigRec.TaskName = '' then
  begin
    FTaskConfigRec := TTaskUtil.ReadConfigFrom(TaskFile);
  end;
  Result := FTaskConfigRec;
end;


function TJobConfig.GetTaskStepsStr: string;
begin
  if FTaskConfigRec.TaskName = '' then
  begin
    FTaskConfigRec := TTaskUtil.ReadConfigFrom(TaskFile);
  end;

  Result := FTaskConfigRec.StepsStr;
end;



procedure TJobConfig.ParseScheduleConfig(AScheduleJsonStr: string);
var
  LScheduleJson: TJSONObject;
begin
  LScheduleJson := TJSONObject.ParseJSONValue(AScheduleJsonStr) as TJSONObject;
  LastStartTime := 0;
  if LScheduleJson = nil then
  begin
    Interval := 3600;
    TimeOut := 7200;
  end
  else
  begin
    try
      Interval := GetJsonObjectValue(LScheduleJson, 'interval', '3600', 'int');
      TimeOut := GetJsonObjectValue(LScheduleJson, 'time_out', '7200', 'int');
      AllowedTimes.NameValueSeparator := '-';
      AllowedTimes.DelimitedText := GetJsonObjectValue(LScheduleJson, 'allowed_time');
      DisallowedTimes.NameValueSeparator := '-';
      DisallowedTimes.DelimitedText := GetJsonObjectValue(LScheduleJson, 'disallowed_time');
    finally
      LScheduleJson.Free;
    end;
  end;
end;


procedure TJobConfig.SetHandleStatus(const Value: TJobHandleStatus);
begin
  FCritical.Enter;
  try
    FHandleStatus := Value;
  finally
    FCritical.Leave;
  end;
end;

function TJobConfig.ToString: string;
begin
  Result := '[Job：' + JobName + '][LastStartTime：' + FormatDateTime('yyyy-mm-dd hh:nn:ss', LastStartTime)
            + '][Interval: ' + IntToStr(Interval)
            + '][TaskFile: ' + TaskFile + '][Allowed Times: ' + AllowedTimes.DelimitedText
            + '][Disallowed Times: ' + DisallowedTimes.DelimitedText
            + '][' + IntToStr(Ord(HandleStatus)) + ']';
  if Task <> nil then
    Result := Result + '[Task Is not nil]';
end;

function TJobConfig.CheckSchedule: Boolean;
var
  LNow: TDateTime;
  LNowStr: string;

  function IsAllowed: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if AllowedTimes.Count = 0 then
    begin
      Result := True;
      Exit;
    end;

    for i := 0 to AllowedTimes.Count - 1 do
    begin
      if (LNowStr >= AllowedTimes.Names[i])
        and (LNowStr <= AllowedTimes.ValueFromIndex[i]) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  function IsDisallowed: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if DisallowedTimes.Count = 0 then
    begin
      Exit;
    end;

    for i := 0 to DisallowedTimes.Count - 1 do
    begin
      if (LNowStr >= DisallowedTimes.Names[i])
        and (LNowStr <= DisallowedTimes.ValueFromIndex[i]) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
begin
  Result := True;
  if Status = 0 then
  begin
    AppLogger.Debug(JobName + '执行状态为禁止');
    Result := False;
    Exit;
  end;

  LNow := Now;
  if SecondsBetween(LNow, LastStartTime) < Interval then
  begin
    AppLogger.Debug(JobName + '尚未到达执行时间:' + FormatDateTime('yyyy-mm-dd hh:nn:ss', LastStartTime));
    Result := False;
    Exit;
  end;

  LNowStr := FormatDateTime('hh:nn:ss', LNow);
  if not IsAllowed then
  begin
    AppLogger.Debug(JobName + '不在允许的执行时间');
    Result := False;
    Exit;
  end;

  if IsDisallowed then
  begin
    AppLogger.Debug(JobName + '时间段禁止执行');
    Result := False;
    Exit;
  end;
end;


function TJobConfig.IsTimeOut: Boolean;
begin
  Result := False;
  if TimeOut < 1  then Exit;

  if (LastStartTime = 0) or (Task = nil) then Exit; //未运行过或未运行，不进行检查

  if (SecondsBetween(Now, LastStartTime) >= TimeOut) and (Task <> nil) then
    Result := True;
end;


procedure TJobConfig.FreeTask;
begin
  HandleStatus := jhsNone;
  if Task <> nil then
    FreeAndNil(Task);
  RunThread := nil;
end;

end.
