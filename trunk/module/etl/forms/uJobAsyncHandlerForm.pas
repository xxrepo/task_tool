unit uJobAsyncHandlerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, uFileLogger;


const
  VV_MSG_HANDLE_ASYNC_JOB = WM_USER + 2000;

type
  TJobAsyncHandlerForm = class(TBasicForm)
  private
    { Private declarations }
    procedure MSGHandleAsyncJob(var AMsg: TMessage); message VV_MSG_HANDLE_ASYNC_JOB;
  public
    { Public declarations }
  end;

var
  JobAsyncHandlerForm: TJobAsyncHandlerForm;

implementation

uses uJobDispatcher, uDefines;

{$R *.dfm}

{ TJobAsyncHandlerForm }

procedure TJobAsyncHandlerForm.MSGHandleAsyncJob(var AMsg: TMessage);
var
  LJobDispatcher: TJobDispatcher;
  LJobDispatcherRec: PJobDispatcherRec;
begin
  if AMsg.Msg <> VV_MSG_HANDLE_ASYNC_JOB then Exit;

  LJobDispatcherRec := PJobDispatcherRec(AMsg.WParam);
  if LJobDispatcher = nil then
  begin
    AppLogger.Error('收到空地址分发指令');
    Exit;
  end;

  //否则生成jobdispatcher，直接调用
  LJobDispatcher := TJobDispatcher.Create;
  try
    LJobDispatcher.StartProjectJob(LJobDispatcherRec);

    //本方法处理无任何结果输出，属于执行指令式的任务，后续可以通过其他异步方式通知调用方
  finally
    LJobDispatcher.Free;
  end;
end;

end.
