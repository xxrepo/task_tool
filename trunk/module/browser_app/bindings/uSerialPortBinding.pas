unit uSerialPortBinding;

{$I cef.inc}

interface

uses
  uCEFV8Value, uCEFv8Accessor, uCEFInterfaces, uCEFTypes, uCEFConstants,
  uCEFv8Handler, System.Generics.Collections, SPComm;

type
  TSerialPortConnectRec = record
    CommName: string;

    OnDataReceivedCallbackFunc: ICefv8Value;
    Context: ICefv8Context;
    BrowserId: Integer;
  end;

  //创建，对应的comm对象，comm名称，以及对应的回调函数
  TSerialPort = class
  private
    //对sp的基本配置参数的保存


    //实际的连接实例
    FComm: TComm;
  public
    CommName: string;


    constructor Create;
    destructor Destroy; override;

    procedure Connect;

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
  protected
    //Js Executed in Render Progress
    function Execute(const name: ustring; const obj: ICefv8Value; const arguments: TCefv8ValueArray; var retval: ICefv8Value; var exception: ustring): Boolean; override;
  public

    //Register Js to Context
    class procedure BindJsTo(const ACefv8Value: ICefv8Value); virtual;
  end;

  TSerialPortBinding = class
  private
  protected
  public
    class procedure BindJsTo(const ACefv8Value: ICefv8Value); static;
  end;

var
  RENDER_SerialPortMgr: TSerialPortMgr;


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
    //通知mgr需要给哪个comm口添加对当前context的环境变量的监听，回调函数还是添加到callbacks中，并不会独立处理，
    //但是必须标明是监听的哪个comm口的回调函数来标记idxname
    LSerialPortConnectRec.CommName := arguments[0].GetStringValue;
    LSerialPortConnectRec.OnDataReceivedCallbackFunc := arguments[0];
    LSerialPortConnectRec.Context := TCefv8ContextRef.Current;
    LSerialPortConnectRec.BrowserId := TCefv8ContextRef.Current.Browser.Identifier;
    if RENDER_SerialPortMgr.ConnectTo(LSerialPortConnectRec) then
    begin
      //注册或者更新回调函数
      LCefV8Accessor := TCefV8AccessorOwn.Create;
      LResult := TCefv8ValueRef.NewObject(LCefV8Accessor, nil);
      LResult.SetValueByKey('disconnect', TCefv8ValueRef.NewFunction('disconnect', Self), V8_PROPERTY_ATTRIBUTE_NONE);
      LResult.SetValueByKey('port_name', TCefv8ValueRef.NewString('COMMMMMM1'), V8_PROPERTY_ATTRIBUTE_NONE);
      retval := LResult;
    end
    else
    begin
      exception := 'connect to serial port failed!';
    end;
    Result := True;
  end
  else if (name = 'disconnect') then
  begin
    if obj.IsObject then
    begin
      //通知mgr哪个context的sp的哪个端口需要断开连接
      RENDER_SerialPortMgr.DisconnectFrom(obj.GetValueByKey('port_name').GetStringValue);
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

    //创建回调函数添加
    LCallback.Context := ARec.Context;
    LCallback.BrowserId := ARec.BrowserId;
    LCallback.CallbackFuncType := cftEvent;
    LCallback.IdxName := BINDING_NAMESPACE + 'connect/' + ARec.CommName;
    LCallback.CallbackFunc := ARec.OnDataReceivedCallbackFunc;
    if RENDER_JsCallbackList.AddCallback(LCallback) <> '' then
    begin
      FCommList.Add(LSerialPort);
      Result := True;
    end
    else
      LSerialPort.Free;
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
    if (FCommList.Items[i] <> nil) and (FCommList.Items[i].CommName = AComm) then
    begin
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

procedure TSerialPort.Connect;
begin
  //设置参数，同时设置数据接收事件

end;

constructor TSerialPort.Create;
begin
  inherited;
  FComm := TComm.Create(nil);
  FComm.OnReceiveData := OnCommReceiveData;
end;

destructor TSerialPort.Destroy;
begin
  FComm.Free;
  inherited;
end;


procedure TSerialPort.Disconnect;
begin
  //检测监听列表，如果没有事件监听了，则进行释放

end;


procedure TSerialPort.OnCommReceiveData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
begin
  //调用回调函数列表中的回调函数

end;


end.
