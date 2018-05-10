unit uSerialPortBinding;

{$I cef.inc}

interface

uses
  uCEFV8Value, uCEFv8Accessor, uCEFInterfaces, uCEFTypes, uCEFConstants,
  uCEFv8Handler, System.Generics.Collections, SPComm, Vcl.ExtCtrls;

type
  TSerialPortConnectRec = record
    CommName: string;
    CallbackIdxName: string;
    Browser: ICefBrowser;
  end;

  //创建，对应的comm对象，comm名称，以及对应的回调函数
  TSerialPort = class
  private
    //对sp的基本配置参数的保存
    FTimer: TTimer;

    //实际的连接实例
    FComm: TComm;
    procedure OnTestTimer(Sender: TObject);
  public
    CommName: string;
    ConnectRec: TSerialPortConnectRec;


    constructor Create;
    destructor Destroy; override;

    procedure Connect(AConnectRec: TSerialPortConnectRec);

    //维护一个方法来接收数据，并且根据名称的生成规则，在回调函数中找到对应的方法，并且发起回调，
    //如果获取到的回调列表为空，则本函数讲自动释放本实例，不再进行监听
    procedure OnCommReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);

    //维护一个方法来响应disconnect，此时在回调函数中查找是否有还有其他回调函数，如果没有，则直接销毁本实例
    procedure Disconnect;
  end;


  TSerialPortMgr = class
  private
    FCommList: TObjectList<TSerialPort>;
    function GetCommSerialPort(AComm: string): TSerialPort;
  public
    constructor Create;
    destructor Destroy; override;
    function ConnectTo(ARec: TSerialPortConnectRec): Boolean;
    procedure DisconnectFrom(AComm: string);
  end;

  TSerialPortFunctionBinding = class(TCefv8HandlerOwn)
  private
  protected
    //Js Executed in Render Progress
    function Execute(const name: ustring; const obj: ICefv8Value; const arguments: TCefv8ValueArray; var retval: ICefv8Value; var exception: ustring): Boolean; override;
  public

    //Register Js to Context
    class procedure BindJsTo(const ACefv8Value: ICefv8Value); virtual;
    class procedure ExecuteInBrowser(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean; const AFormHandle: THandle); static;
  end;

  TSerialPortBinding = class
  private
  protected
  public
    class procedure BindJsTo(const ACefv8Value: ICefv8Value); static;
  end;

var
  BROWSER_SerialPortMgr: TSerialPortMgr;


implementation

uses uBaseJsBinding, uCEFValue, uBROWSER_EventJsListnerList, uCEFProcessMessage,
uRENDER_JsCallbackList, uCEFv8Context, uVVConstants, System.SysUtils;

const
  BINDING_NAMESPACE = 'SERIAL_PORT/';

//在context初始化时绑定js
class procedure TSerialPortBinding.BindJsTo(const ACefv8Value: ICefv8Value);
var
  TempAccessor : ICefV8Accessor;
  TempObject   : ICefv8Value;
begin
  TempAccessor := TCefV8AccessorOwn.Create;
  TempObject   := TCefv8ValueRef.NewObject(TempAccessor, nil);

  //还可以继续绑定其他的函数或者方法
  TSerialPortFunctionBinding.BindJsTo(TempObject);

  ACefv8Value.SetValueByKey('JSN_SerialPort', TempObject, V8_PROPERTY_ATTRIBUTE_NONE);
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
  LResult: ICefv8Value;
  LCefV8Accessor: ICefV8Accessor;
  LSerialPortConnectRec: TSerialPortConnectRec;
begin
  LMsgName := BINDING_NAMESPACE + name;
  if (name = 'connect') then
  begin
    //还可以判断是否是合法的串口名称
    if (Length(arguments) = 2) and (arguments[0].IsString) and (arguments[1].IsFunction) then
    begin
      LContextCallback.Context := TCefv8ContextRef.Current;
      LContextCallback.BrowserId := LContextCallback.Context.Browser.Identifier;
      LContextCallback.IdxName := BINDING_NAMESPACE + 'connect/' + arguments[0].GetStringValue;
      LContextCallback.CallbackFuncType := cftEvent;
      LContextCallback.CallbackFunc := arguments[1];
      LCallbackIdxName := RENDER_JsCallbackList.AddCallback(LContextCallback);

      LMsg := TCefProcessMessageRef.New(LMsgName);
      LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);
      LMsg.ArgumentList.SetString(1, LContextCallback.IdxName);

      //发送消息到BROWSER进程
      TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);

      //注册或者更新回调函数
      LCefV8Accessor := TCefV8AccessorOwn.Create;
      LResult := TCefv8ValueRef.NewObject(LCefV8Accessor, nil);
      LResult.SetValueByKey('disconnect', TCefv8ValueRef.NewFunction('disconnect', Self), V8_PROPERTY_ATTRIBUTE_NONE);
      LResult.SetValueByKey('port_name', arguments[0], V8_PROPERTY_ATTRIBUTE_NONE);
      retval := LResult;
    end
    else
      exception := 'connect params error';
    Result := True;
  end
  else if (name = 'disconnect') then
  begin
    if obj.IsObject then
    begin
      //发送消息给browser，断开对某个端口的监听
      LMsg := TCefProcessMessageRef.New(LMsgName);
      LMsg.ArgumentList.SetString(0, obj.GetValueByKey('port_name').GetStringValue);

      TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);

      retval := TCefv8ValueRef.NewBool(True);
    end
    else
      exception := 'no serial port to disconnected!';

    Result := True;
  end
  else if (name = 'write') then
  begin
    if obj.IsObject then
    begin
      //通知mgr哪个context的sp的哪个端口需要断开连接
      retval := obj.GetValueByKey('port_name');
    end
    else
      retval := TCefv8ValueRef.NewString('no object');

    Result := True;
  end
  else
    Result := False;
end;


//下面的代码在browser进程中执行
class procedure TSerialPortFunctionBinding.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean; const AFormHandle: THandle);
var
  LMsg: ICefProcessMessage;
  LParams: ICefValue;
  LJsListnerRec: TEventJsListnerRec;
  LSerialPortConnectRec: TSerialPortConnectRec;
begin
  if message.Name = BINDING_NAMESPACE + 'connect' then
  begin
    //添加到BROWSER的串口列表中去
    LSerialPortConnectRec.CommName := message.ArgumentList.GetString(0);
    LSerialPortConnectRec.Browser := browser;
    LSerialPortConnectRec.CallbackIdxName := message.ArgumentList.GetString(1);
    BROWSER_SerialPortMgr.ConnectTo(LSerialPortConnectRec);

    Result := True;
  end
  else if message.Name = BINDING_NAMESPACE + 'disconnect' then
  begin
    //从Browser_mgr里面移除对于那个的端口监听
    BROWSER_SerialPortMgr.DisconnectFrom(message.ArgumentList.GetString(0));

    Result := True;
  end
  else
    Result := False;
end;


{ TSerialPortMgr }

function TSerialPortMgr.ConnectTo(ARec: TSerialPortConnectRec): Boolean;
var
  LSerialPort: TSerialPort;
  LCallback: TContextCallbackRec;
begin
  //从list中查找是否有对应comm口的监听对象，如果有，则直接返回这个对象，然后回调函数增加到列表中
  Result := False;
  LSerialPort := GetCommSerialPort(ARec.CommName);

  if LSerialPort = nil then
  begin
    LSerialPort := TSerialPort.Create;
    LSerialPort.CommName := ARec.CommName;
    LSerialPort.ConnectRec := ARec;
    LSerialPort.Connect(ARec);

    FCommList.Add(LSerialPort);
  end;
end;


constructor TSerialPortMgr.Create;
begin
  inherited;
  FCommList := TObjectList<TSerialPort>.Create(False);
end;


destructor TSerialPortMgr.Destroy;
var
  i: Integer;
begin
  for i := FCommList.Count - 1 downto 0 do
  begin
    //尝试清除回调函数
    if FCommList.Items[i] is TSerialPort then
      FCommList.Items[i].Free;
  end;
  FCommList.Free;
  inherited;
end;


procedure TSerialPortMgr.DisconnectFrom(AComm: string);
var
  i: Integer;
begin
  for i := 0 to FCommList.Count - 1 do
  begin
    if (FCommList.Items[i] <> nil) and (FCommList.Items[i].ConnectRec.CommName = AComm) then
    begin
      FCommList.Items[i].Disconnect;
      FCommList.Items[i].Free;
      FCommList.Delete(i);
      Break;
    end;
  end;
end;


function TSerialPortMgr.GetCommSerialPort(AComm: string): TSerialPort;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FCommList.Count - 1 do
  begin
    if (FCommList.Items[i] <> nil) and (FCommList.Items[i].CommName = AComm) then
    begin
      Result := FCommList.Items[i];
      Break;
    end;
  end;
end;


{ TSerialPort }

procedure TSerialPort.Connect(AConnectRec: TSerialPortConnectRec);
begin
  //设置参数，同时设置数据接收事
  ConnectRec := AConnectRec;
  FTimer.Enabled := True;
end;

constructor TSerialPort.Create;
begin
  inherited;
  FComm := TComm.Create(nil);
  FComm.OnReceiveData := OnCommReceiveData;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 50;
  FTimer.Enabled := False;
  FTimer.OnTimer := OnTestTimer;
end;

destructor TSerialPort.Destroy;
begin
  FTimer.Free;
  FComm.Free;
  inherited;
end;


procedure TSerialPort.Disconnect;
begin
  //检测监听列表，如果没有事件监听了，则进行释放
  FTimer.Enabled := False;
end;


procedure TSerialPort.OnCommReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
begin
  //调用回调函数列表中的回调函数

end;

procedure TSerialPort.OnTestTimer(Sender: TObject);
var
  LCallback: TContextCallback;
  LMsg: ICefProcessMessage;
begin
  //调用回调函数列表中的回调函数
  LMsg := TCefProcessMessageRef.New(IPC_MSG_EXEC_CALLBACK);
  LMsg.ArgumentList.SetString(0, ConnectRec.CallbackIdxName);
  LMsg.ArgumentList.SetString(1, FormatDateTime('yyyymmddhhnnss.zzz', Now));
  ConnectRec.Browser.SendProcessMessage(PID_RENDERER, LMsg);
end;


end.

