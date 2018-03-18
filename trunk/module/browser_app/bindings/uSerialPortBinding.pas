unit uSerialPortBinding;

{$I cef.inc}

interface

uses
  uCEFV8Value, uCEFv8Accessor, uCEFInterfaces, uCEFTypes, uCEFConstants,
  uCEFv8Handler;

type
  TSerialPortFunctionBinding = class(TCefv8HandlerOwn)
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

  TSerialPortBinding = class(TCefV8AccessorOwn)
  private
  protected

    function Get(const name: ustring; const obj: ICefv8Value;
      out retval: ICefv8Value; var exception: ustring): Boolean; override;
    function Put(const name: ustring; const obj, value: ICefv8Value;
      var exception: ustring): Boolean; override;

  public
    class procedure BindJsTo(const ACefv8Value: ICefv8Value); static;
    class procedure ExecuteInBrowser(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean); static;
  end;


implementation

uses uBaseJsBinding, uCEFValue, uBROWSER_EventJsListnerList, uCEFProcessMessage,
uRENDER_JsCallbackList, uCEFv8Context, uVVConstants;

const
  BINDING_NAMESPACE = 'SERIAL_PORT/';

//在context初始化时绑定js
class procedure TSerialPortBinding.BindJsTo(const ACefv8Value: ICefv8Value);
var
  TempAccessor : ICefV8Accessor;
  TempObject   : ICefv8Value;
begin
  TempAccessor := TSerialPortBinding.Create;
  TempObject   := TCefv8ValueRef.NewObject(TempAccessor, nil);

  //还可以继续绑定其他的函数或者方法
  TSerialPortFunctionBinding.BindJsTo(TempObject);

  ACefv8Value.SetValueByKey('JSN_SerialPort', TempObject, V8_PROPERTY_ATTRIBUTE_NONE);
end;


//下面的代码在browser进程中执行
class procedure TSerialPortBinding.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  //要处理对BasicJsBinding，依次对上面的方法进行代理处理
  TBasicJsBinding.ExecuteInBrowser(Sender, browser, sourceProcess, message, Result);
end;





//下面两个方法在Render中执行
function TSerialPortBinding.Get(const name: ustring; const obj: ICefv8Value;
  out retval: ICefv8Value; var exception: ustring): Boolean;
begin
  Result := False;
end;


function TSerialPortBinding.Put(const name: ustring; const obj: ICefv8Value;
  const value: ICefv8Value; var exception: ustring): Boolean;
begin
  Result := False;
end;



{ TSerialPortFunctionBinding }

class procedure TSerialPortFunctionBinding.BindJsTo(const ACefv8Value: ICefv8Value);
var
  TempHandler  : ICefv8Handler;
  TempFunction : ICefv8Value;
begin
  TempHandler  := TSerialPortFunctionBinding.Create;

  ACefv8Value.SetValueByKey('__NAMESPACE', TCefv8ValueRef.NewString(BINDING_NAMESPACE), V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('connect', TempHandler);
  ACefv8Value.SetValueByKey('connect', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('disconnect', TempHandler);
  ACefv8Value.SetValueByKey('disconnect', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('write', TempHandler);
  ACefv8Value.SetValueByKey('write', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);
end;


function TSerialPortFunctionBinding.Execute(const name: ustring;
  const obj: ICefv8Value; const arguments: TCefv8ValueArray;
  var retval: ICefv8Value; var exception: ustring): Boolean;
var
  LMsg: ICefProcessMessage;
  LContextCallback: TContextCallbackRec;
  LMsgName, LCallbackIdxName: string;
begin
  LMsgName := BINDING_NAMESPACE + name;
  if (name = 'connect') then
  begin
    //调用串口管理类，获取对应串口的实例，并且进行返回？还是可以进行回调？
    LMsg := TCefProcessMessageRef.New(LMsgName);
    LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);
    TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
    Result := True;
  end
  else if (name = 'disconnect') then
  begin
    if (Length(arguments) = 3) and (arguments[0].IsString) and (arguments[2].IsFunction) then
    begin
      arguments[2].ExecuteFunction(nil, arguments);
      retval := TCefv8ValueRef.NewString('return ok');
      //添加到回调函数列表中去，生成一个随机性的字符串，用来对应本次发起调用的回调函数
//      LContextCallback.Context := TCefv8ContextRef.Current;
//      LContextCallback.BrowserId := LContextCallback.Context.Browser.Identifier;
//      LContextCallback.CallbackFunc := arguments[2];
//      LCallbackIdxName := RENDER_JsCallbackList.AddCallback(LContextCallback);
//
//      if LCallbackIdxName <> '' then
//      begin
//        //发送消息到browser进程
//        LMsg := TCefProcessMessageRef.New(LMsgName);
//        LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);
//        LMsg.ArgumentList.SetString(1, arguments[1].GetStringValue);
//        LMsg.ArgumentList.SetString(2, LCallbackIdxName);
//
//        TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
//      end
//      else
//        exception := 'callback function register error on ' + name;
    end;
    Result := True;
  end
  else if (name = 'write') then
  begin
    if (Length(arguments) = 2) and (arguments[0].IsString) and (arguments[1].IsFunction) then
    begin
      //这里需要进行标记相应的事件
      //第一个参数为监听的事件的名称，第二个参数为事件发生时的回调函数
      //添加到回调函数列表中去，这里因为是新生成的对象，可能已经存在，则在回调中直接释放，回调列表仅保留一份
      LContextCallback.Context := TCefv8ContextRef.Current;
      LContextCallback.BrowserId := LContextCallback.Context.Browser.Identifier;
      LContextCallback.IdxName := LMsgName + '/' + arguments[0].GetStringValue;
      LContextCallback.CallbackFunc := arguments[1];
      LCallbackIdxName := RENDER_JsCallbackList.AddCallback(LContextCallback);

      if LCallbackIdxName <> '' then
      begin
        //发送消息到browser进程
        LMsg := TCefProcessMessageRef.New(LMsgName);
        LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue); //事件名称
        //LMsg.ArgumentList.SetString(1, )  //在回调函数中的索引名称，用来作为消息

        TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
      end
      else
        exception := 'callback function register error on ' + LContextCallback.IdxName;
    end;
    Result := True;
  end
  else
    Result := False;
end;



//下面的代码在browser进程中执行
class procedure TSerialPortFunctionBinding.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
var
  LMsg: ICefProcessMessage;
  LParams: ICefValue;
  LJsListnerRec: TEventJsListnerRec;
begin
  if message.Name = BINDING_NAMESPACE + 'connect' then
  begin
    //发送消息给mainform.handle，在mainform.handle实现openNativeWindow的消息响应
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
  else if message.Name = BINDING_NAMESPACE + 'disconnect' then
  begin
    //执行task，在结果返回时，把对应的执行结果放入lmsg中，作为rsp传入给render的js执行环节
    //回复一条回调函数的消息到render中，同时删掉对应的监听回调
    LMsg := TCefProcessMessageRef.New(IPC_MSG_EXEC_CALLBACK);
    LMsg.ArgumentList.SetValue(0, message.ArgumentList.GetValue(2)); //callback_idxname
    LMsg.ArgumentList.SetValue(1, message.ArgumentList.GetValue(0));
    LMsg.ArgumentList.SetValue(2, message.ArgumentList.GetValue(1));

    //TODO 可以告诉render，执行完毕后，可以移除这个回调函数
    browser.SendProcessMessage(PID_RENDERER, LMsg);

    Result := True;
  end
  else if message.Name = BINDING_NAMESPACE + 'write' then
  begin
    //向BROWSER_EventJsListner添加监听者

    //在系统记录具体的哪个事件被监听，事件要能很容易进行处罚
    //比如, browser_eventlist.eventnotify('event_name')
    //这里的event_name要非常明确，比如basic.timer, basic.weighter_change，然后可以带上具体的browser_id


    //第一个参数为事件的名称，第二个参数为对应的回调方法在render进程中的名称
    LJsListnerRec.EventName := message.ArgumentList.GetString(0);
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
