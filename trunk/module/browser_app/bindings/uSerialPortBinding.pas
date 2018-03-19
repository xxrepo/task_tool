unit uSerialPortBinding;

{$I cef.inc}

interface

uses
  uCEFV8Value, uCEFv8Accessor, uCEFInterfaces, uCEFTypes, uCEFConstants,
  uCEFv8Handler, System.Generics.Collections, SPComm;

type
  //创建，对应的comm对象，comm名称，以及对应的回调函数
  TSerialPort = class
  private
        //对sp的基本配置参数的保存
    FCommName: string;

    //实际的连接实例
    FComm: TComm;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;

    //维护一个方法来接收数据，并且根据名称的生成规则，在回调函数中找到对应的方法，并且发起回调，
    //如果获取到的回调列表为空，则本函数讲自动释放本实例，不再进行监听
    procedure OnCommDataReceived;

    //维护一个方法来响应disconnect，此时在回调函数中查找是否有还有其他回调函数，如果没有，则直接销毁本实例
    procedure Disconnect;
  end;


  TSerialPortMgr = class
  private
    FCommList: TObjectList<TSerialPort>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ConnectTo(AParams: string);
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


implementation

uses uBaseJsBinding, uCEFValue, uBROWSER_EventJsListnerList, uCEFProcessMessage,
uRENDER_JsCallbackList, uCEFv8Context, uVVConstants;

const
  BINDING_NAMESPACE = 'SERIAL_PORT/';

var
  RENDER_SerialPortMgr: TSerialPortMgr;

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
begin
  LMsgName := BINDING_NAMESPACE + name;
  if (name = 'connect') then
  begin
    LCefV8Accessor := TCefV8AccessorOwn.Create;
    LResult := TCefv8ValueRef.NewObject(LCefV8Accessor, nil);
    LResult.SetValueByKey('disconnect', TCefv8ValueRef.NewFunction('disconnect', Self), V8_PROPERTY_ATTRIBUTE_NONE);
    LResult.SetValueByKey('port_name', TCefv8ValueRef.NewString('COMMMMMM1'), V8_PROPERTY_ATTRIBUTE_NONE);

    //通知mgr需要给哪个comm口添加对当前context的环境变量的监听，回调函数还是添加到callbacks中，并不会独立处理，
    //但是必须标明是监听的哪个comm口的回调函数来标记idxname

    //mgr负责创建comm口，并且对这个comm口负责管理，以及事件的触发，当接收到数据时，会从callbacks列表中
    //找出对应的回调函数进行执行


    retval := LResult;
    Result := True;
  end
  else if (name = 'disconnect') then
  begin
    if obj.IsObject then
    begin
      //通知mgr哪个context的sp的哪个端口需要断开连接
      retval := obj.GetValueByKey('port_name');
    end
    else
      retval := TCefv8ValueRef.NewString('no object');

    //而且能知道当前的context，从而可以在comport的监听列表中移除对应的回调函数
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

procedure TSerialPortMgr.ConnectTo(AParams: string);
begin
  //从list中查找是否有对应comm口的监听对象，如果有，则直接

end;


constructor TSerialPortMgr.Create;
begin
  inherited;

end;


destructor TSerialPortMgr.Destroy;
begin

  inherited;
end;


procedure TSerialPortMgr.DisconnectFrom(AComm: string);
begin

end;

{ TSerialPort }

procedure TSerialPort.Connect;
begin

end;

constructor TSerialPort.Create;
begin
  inherited;

end;

destructor TSerialPort.Destroy;
begin

  inherited;
end;

procedure TSerialPort.Disconnect;
begin

end;

procedure TSerialPort.OnCommDataReceived;
begin

end;

end.
