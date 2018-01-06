unit uFileLogger;

interface

uses Winapi.Windows, uThreadQueueUtil, System.Classes, System.SyncObjs, Winapi.Messages;

const
  VV_MSG_BASE = WM_USER + 1000;
  VV_MSG_LOGGER = VV_MSG_BASE + 1;


type
  PLogRequest = ^TLogRequest;

  TLogLevel = (llAll, llDebug, llInfo, llWarn, llError, llFatal, llForce);

  TLogRequest = record
    LogLevel: TLogLevel;
    LogText: String;
  end;

  TThreadFileLog = class(TObject)
  private

    Critical: TCriticalSection;
    FLogLevel: TLogLevel;
    FFilePrefix: String;
    FFileFormat: string;
    FThreadPool: TThreadPool;
    FUnHandledLogCount: Integer;
    FThreadCount: Integer;
    procedure HandleLogRequest(Data: Pointer; AThread: TThread);
    procedure LogToFile(const FileName, LogString: String);
    procedure Log(const LogText: string; AAlogLevel: TLogLevel = llFatal);
  public
    //通知到对应的窗口
    NoticeHandle: THandle;

    property LogLevel: TLogLevel write FLogLevel;

    constructor Create(AThreadCount: Integer = 1; const AFilePrefix: string = '';
          const ADtFormat: string = 'yyyymmddhh'; const ALogLevel: TLogLevel = llAll);
    destructor Destroy; override;
    procedure Debug(const LogText: string);
    procedure Info(const LogText: string);
    procedure Warn(const LogText: string);
    procedure Error(const LogText: string);
    procedure Fatal(const LogText: string);
    procedure Force(const LogText: string);
  end;



implementation

uses System.SysUtils;

  (* Simple reuse of a logtofile function for example *)
procedure TThreadFileLog.LogToFile(const FileName, LogString: String);
var
  F: TextFile;
  LDir, LMsg: string;
begin
  Critical.Enter;
  try
    //判断文件夹存不存在
    LDir := ExtractFileDir(FileName);
    if not DirectoryExists(LDir) then
    begin
      if not ForceDirectories(LDir) then
      begin
        Critical.Leave;
        Exit;
      end;
    end;

    //根据指定日期来重新生成
    AssignFile(F, FileName);

    if not FileExists(FileName) then
      Rewrite(F)
    else
      Append(F);

    LMsg := FormatDateTime('[yyyy.mm.dd hh:nn:ss]', Now) + ': ' + LogString;
    Writeln(F, LMsg);

    CloseFile(F);
    if NoticeHandle > 0 then
      SendMessage(NoticeHandle, VV_MSG_LOGGER, Integer(PChar(LMsg)), 0);
  finally
    Critical.Leave;
  end;
end;

constructor TThreadFileLog.Create(AThreadCount: Integer = 1; const AFilePrefix: string = '';
                const ADtFormat: string = 'yyyymmddhh'; const ALogLevel: TLogLevel = llAll);
begin
  NoticeHandle := 0;
  FLogLevel := ALogLevel;
  FFilePrefix := AFilePrefix;
  FFileFormat := ADtFormat;
  Critical := TCriticalSection.Create;
  FThreadCount := AThreadCount;
  FThreadPool := TThreadPool.Create(HandleLogRequest, FThreadCount);
  FUnHandledLogCount := 0;
end;

destructor TThreadFileLog.Destroy;
begin
  FThreadPool.Free;
  Critical.Free;
  inherited;
end;

procedure TThreadFileLog.HandleLogRequest(Data: Pointer; AThread: TThread);
var
  Request: PLogRequest;
  FileName: string;
  LogTitle: string;
begin
  Request := Data;

  try
    // 调用log4delphi中的方法
    case Request.LogLevel of
      llDebug:
        begin
          LogTitle := 'DEBUG';
        end;
      llInfo:
        begin
          LogTitle := 'INFO';
        end;
      llWarn:
        begin
          LogTitle := 'WARN';
        end;
      llError:
        begin
          LogTitle := 'ERROR';
        end;
      llFatal:
        begin
          LogTitle := 'FATAL';
        end;
      llForce:
        begin
          LogTitle := 'FORCE';
        end;
    end;
    FileName := FFilePrefix +  FormatDateTime(FFileFormat,
        Now) + '.log';

    LogToFile(FileName, '[' + LogTitle + ']: ' + Request^.LogText);
  finally
    Dispose(Request);
    InterlockedDecrement(FUnHandledLogCount);
  end;
end;

// llAll是级别最低的消息，只有在llAll时才会被记录
procedure TThreadFileLog.Log(const LogText: string;
  AAlogLevel: TLogLevel = llFatal);
var
  Request: PLogRequest;
begin
  if AAlogLevel < FLogLevel then Exit;
  
  //这里会造成消息丢失，但是能够尽可能保持后续消息的持续记录
  //if FUnHandledLogCount < FThreadCount  then
  Begin
    //如果发现有未处理的消息，进行记录
    New(Request);
    Request^.LogLevel := AAlogLevel;

    if Length(LogText) > 512 then
      Request^.LogText := LogText.Substring(0, 512)
    else
      Request^.LogText := LogText;

    InterlockedIncrement(FUnHandledLogCount);

    //支持单线程模式，也就是在这里直接写入文件
    if FThreadCount = 0 then
      HandleLogRequest(Request, nil)
    else
      FThreadPool.Add(Request);
  End;
end;

procedure TThreadFileLog.Debug(const LogText: string);
begin
  Log(LogText, llDebug);
end;

procedure TThreadFileLog.Info(const LogText: string);
begin
  Log(LogText, llInfo);
end;

procedure TThreadFileLog.Warn(const LogText: string);
begin
  Log(LogText, llWarn);
end;

procedure TThreadFileLog.Error(const LogText: string);
begin
  Log(LogText, llError);
end;

procedure TThreadFileLog.Fatal(const LogText: string);
begin
  Log(LogText, llFatal);
end;

procedure TThreadFileLog.Force(const LogText: string);
begin
  Log(LogText, llForce);
end;

end.
