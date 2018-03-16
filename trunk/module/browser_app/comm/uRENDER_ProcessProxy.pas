{
1.render进程的辅助函数，用来管理消息，
  1.1 context初始化时注册相应js函数对应的handler
  1.2 拥有变量用来保存context中的所有回调函数的一个列表
  1.3 接收来自browser的消息从而在回调函数列表中查找并且运行相应的js回调函数，
  1.4 context释放事件时，对js发起调用时保存的js回调函数进行释放

  另外，回调函数列表的管理需要记录browser_id, 对应browser的消息或者说某个消息/事件的回调，
  这个回调的类别是事件还是函数（事件回调需要保存知道这个Browser对应的context释放，而函数
  回调则在调用执行后，直接释放），对应回调执行的context，而且执行时，需要context.enter为
  render中的当前context，最后是要执行的函数名，也就是context调用handler时注册到回调函数
  列表中的js回调函数名称
}

unit uRENDER_ProcessProxy;

interface

uses
  uRENDER_JsCallbackList, uCEFInterfaces, uCEFConstants, uCEFTypes;

type
  TRENDER_ProcessProxy = class
  private

  public
    procedure OnContextCreated(const browser: ICefBrowser;
      const frame: ICefFrame; const context: ICefv8Context);

    procedure OnProcessMessageReceived(const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; var aHandled : boolean);

    procedure OnContextReleased(const browser: ICefBrowser; const frame: ICefFrame; const context: ICefv8Context);
  end;





implementation

uses uBasicJsBridge, uCEFv8Value, uCEFv8Types, uVVCefFunction;



{ TRenderProcessHelper }
procedure TRENDER_ProcessProxy.OnContextCreated(const browser: ICefBrowser; const frame: ICefFrame; const context: ICefv8Context);
begin
  TBasicJsBridge.BindJsToContext(context);
end;



procedure TRENDER_ProcessProxy.OnContextReleased(const browser: ICefBrowser;
  const frame: ICefFrame; const context: ICefv8Context);
begin
  PRENDER_JsCallbackMgr.RemoveCallbackByContext(context);
end;



procedure TRENDER_ProcessProxy.OnProcessMessageReceived(
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; var aHandled: boolean);
var
  LContextCallback: TContextCallback;
  LArguments: TCefv8ValueArray;
  i: Integer;
  LFuncResult: ICefv8Value;
begin
  //在这里根据消息的不同名称，去全局的回调函数管理列表中查找相关的回调函数，然后在这里进行执行，
  //具体的回调名称是在参数中传递过来的，不是来自具体的消息名称
  //消息名称仅仅用来作为是否对某个消息进行怎么样的处理，至于具体执行哪个回调函数是不一样的

  LContextCallback := PRENDER_JsCallbackMgr.GetCallback(browser.Identifier, message.Name);
  if LContextCallback <> nil then
  begin
    LContextCallback.Context.Enter;
    try
      try
        SetLength(LArguments, message.ArgumentList.GetSize);
        for i := 0 to message.ArgumentList.GetSize - 1 do
        begin
          LArguments[i] := CefValueToCefV8Value(message.ArgumentList.GetValue(i));
        end;

        LFuncResult := LContextCallback.CallbackFunc.ExecuteFunction(nil, LArguments);
        if LFuncResult.IsBool then
          aHandled := LFuncResult.GetBoolValue;
      finally
        SetLength(LArguments, 0);
      end;
    finally
      LContextCallback.Context.Exit;
    end;
  end;
end;

end.
