unit donix.steps.uStepTest;

interface

uses
  uStepBasic, System.JSON, System.IniFiles, Vcl.ExtCtrls;

type
  TStepTest = class (TStepBasic)
  private
    FTimer: TTimer;

    FFileName: string;
    FRealAbsFileName: string;
    FFieldParams: string;
    FIniFile: TIniFile;

    Count: Integer;
    procedure OnTimerEvent(Sender: TObject);
  protected
    procedure StartSelf; override;

  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property FileName: string read FFileName write FFileName;
    property FieldParams: string read FFieldParams write FFieldParams;

    destructor Destroy; override;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions,
  uStepDefines, uThreadSafeFile, uTaskDefine, Vcl.Forms, Winapi.Windows;

{ TStepQuery }

destructor TStepTest.Destroy;
begin
  if FTimer <> nil then
  begin
    FTimer.Enabled := False;
    FTimer.Free;
  end;
  if FIniFile <> nil then
  begin
    FIniFile.Free;
  end;
  inherited;
end;


procedure TStepTest.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('file_name', FFileName));
  AToConfig.AddPair(TJSONPair.Create('field_params', FFieldParams));
end;


procedure TStepTest.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FFileName := GetJsonObjectValue(StepConfig.ConfigJson, 'file_name');
  FFieldParams := GetJsonObjectValue(StepConfig.ConfigJson, 'field_params');
  FRealAbsFileName := GetRealAbsolutePath(FFileName);
end;


procedure TStepTest.OnTimerEvent(Sender: TObject);
var
  LEventDataRec: PEventDataRec;
begin
  Count := Count + 1;
  New(LEventDataRec);
  LEventDataRec.JobName := TaskVar.RunInJob;
  LEventDataRec.EventName := 'onTimer';
  LEventDataRec.ContentLength := -1;
  LEventDataRec.ContentBody := TaskVar.RunInJob + '.' + LEventDataRec.EventName + '：你好' + IntToStr(Count);

  TaskVar.EventDataPool.Add(LEventDataRec);

  //发送数据出来消息，或者定时保存文件数据
  //FIniFile.WriteDateTime('data', 'date' + IntToStr(Count), Now);
end;


procedure TStepTest.StartSelf;
var
  i: Integer;
  LMsg: TMsg;
begin
  try
    CheckTaskStatus;
    FIniFile := TIniFile.Create('d:/test.txt');

    FTimer := TTimer.Create(nil);
    FTimer.Interval := 500;
    FTimer.OnTimer := OnTimerEvent;
    FTimer.Enabled := True;

    //timer创建，然后hold
    while FTaskVar.TaskStatus <> trsStop do
    begin
      Application.ProcessMessages;
      //获取消息，然后进行事物的处理
      if PeekMessage(LMsg, 0, 0, 0, PM_REMOVE) then
      begin
        case LMsg.message of
          2024:
          begin

          end
          else
          begin
            TranslateMessage(LMsg);
            DispatchMessage(LMsg);
          end;
        end;
      end;
    end;

  finally

  end;
end;

end.
