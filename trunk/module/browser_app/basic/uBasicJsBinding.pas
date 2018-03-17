//运行在render进程中，属于jsv8的函数方法，本文件要么是单独能够提供服务，要么是向
//browser进程发送消息
//本进程还提供一个用于接收来自browser进程的方法，用于向render中运行的jsv8的context进行回调
//而这里，具体的context接收的消息是来自于chromium实体里面的对象了，也就是jsv8的context对应的cefbrowser
//另外，还有一个需要把回调函数的对象来保存在这个进程中对于不同类型事件的回调方法，有些回调函数是可以在回调
//完成之后就进行释放的，而有些，比如对某个事件的监听，则直到整个context被释放，才不需要进行
//这个函数方法是在render中执行的，同样，我们需要一个对应的实力来处理这些js方法函数，
//这个对应的方法函数是应该在browser的进程中存在的


unit uBasicJsBinding;

{$I cef.inc}

interface

uses
  uCEFTypes, uCEFInterfaces, uCEFv8Value, uCEFv8Handler, uCEFv8Context;

type
  TBasicJsBinding = class(TCefv8HandlerOwn)
  protected
    //Js Executed in Render Progress
    function Execute(const name: ustring; const obj: ICefv8Value; const arguments: TCefv8ValueArray; var retval: ICefv8Value; var exception: ustring): Boolean; override;
  public
    //Register Js to Context
    class procedure BindJsTo(const ACefv8Value: ICefv8Value); virtual;

    //Js Executed in Browser Progress
    class procedure ExecuteInBrowser(Sender: TObject;
                      const browser: ICefBrowser; sourceProcess: TCefProcessId;
                      const message: ICefProcessMessage; out Result: Boolean); virtual;
  end;


implementation

uses Winapi.Windows, Vcl.Dialogs, System.SysUtils, Vcl.Forms, uCEFProcessMessage,
  uRENDER_JsCallbackList, uCEFValue, uCEFConstants, uBROWSER_EventJsListnerList;



//在context初始化时绑定js
class procedure TBasicJsBinding.BindJsTo(const ACefv8Value: ICefv8Value);
var
  TempHandler  : ICefv8Handler;
  TempFunction : ICefv8Value;
begin
  TempHandler  := TBasicJsBinding.Create;

  TempFunction := TCefv8ValueRef.NewFunction('test_form', TempHandler);
  ACefv8Value.SetValueByKey('test_form', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('test_on_func', TempHandler);
  ACefv8Value.SetValueByKey('test_on_func', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('test_on_event', TempHandler);
  ACefv8Value.SetValueByKey('test_on_event', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);
end;



//这个方法在render进程中执行
function TBasicJsBinding.Execute(const name      : ustring;
                              const obj       : ICefv8Value;
                              const arguments : TCefv8ValueArray;
                              var   retval    : ICefv8Value;
                              var   exception : ustring): Boolean;
var
  LMsg: ICefProcessMessage;
  LContextCallback: TContextCallbackRec;
begin
  if (name = '__BROWSER_APP_VERSION') then
  begin
    retval := TCefv8ValueRef.NewString('1.0.0');
    Result := True;
  end
  else if (name = 'test_form') then
  begin
    LMsg := TCefProcessMessageRef.New('test_form');
    LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);
    TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
    Result := True;
  end
  else if (name = 'test_func') then
  begin
    retval := TCefv8ValueRef.NewString('My Func!');
    Result := True;
  end
  else if (name = 'test_on_func') then
  begin
    if (Length(arguments) = 2) and (arguments[0].IsString) and (arguments[1].IsFunction) then
    begin
      //添加到回调函数列表中去，生成一个随机性的字符串，用来对应本次发起调用的回调函数
      LContextCallback.Context := TCefv8ContextRef.Current;
      LContextCallback.BrowserId := LContextCallback.Context.Browser.Identifier;
      LContextCallback.CallerName := name;
      LContextCallback.CallbackFunc := arguments[1];
      RENDER_JsCallbackList.AddCallback(LContextCallback);

      //发送消息到browser进程
      LMsg := TCefProcessMessageRef.New('test_on_func');
      LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);


      TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
    end;
    Result := True;
  end
  else if (name = 'test_on_event') then
  begin
    if (Length(arguments) = 2) and (arguments[0].IsString) and (arguments[1].IsFunction) then
    begin
      //添加到回调函数列表中去，这里因为是新生成的对象，可能已经存在，则在回调中直接释放，回调列表仅保留一份
      LContextCallback.Context := TCefv8ContextRef.Current;
      LContextCallback.BrowserId := LContextCallback.Context.Browser.Identifier;
      LContextCallback.CallerName := name;
      LContextCallback.CallbackFunc := arguments[1];
      RENDER_JsCallbackList.AddCallback(LContextCallback);

      //发送消息到browser进程
      LMsg := TCefProcessMessageRef.New('test_on_event');
      LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);


      TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
    end;
    Result := True;
  end
  else
    Result := False;
end;



//下面的代码在browser进程中执行
class procedure TBasicJsBinding.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
var
  LMsg: ICefProcessMessage;
  LParams: ICefValue;
  LJsListnerRec: TEventJsListnerRec;
begin
  if message.Name = 'test_on_func' then
  begin
    //回复一条回调函数的消息到render中，同时删掉对应的监听回调
    LMsg := TCefProcessMessageRef.New(message.Name);
    LMsg.ArgumentList.SetValue(0, message.ArgumentList.GetValue(0));

    LParams := TCefValueRef.New;
    LParams.SetString('hello, 这是测试字符串');
    LMsg.ArgumentList.SetValue(0, LParams);

    //TODO 可以告诉render，执行完毕后，可以移除这个回调函数
    browser.SendProcessMessage(PID_RENDERER, LMsg);

    Result := True;
  end
  else if message.Name = 'test_on_event' then
  begin
    //像BROWSER_EventJsListner添加监听者
    LJsListnerRec.EventName := message.Name;
    LJsListnerRec.BrowserId := browser.Identifier;
    LJsListnerRec.Browser := browser;
    LJsListnerRec.ListnerMsgName := '';
    BROWSER_EventJsListnerList.AddEventListner(LJsListnerRec);
    Result := True;
  end
  else
    Result := False;
end;

end.
