unit uBasicJsObjectBinding;

{$I cef.inc}

interface

uses
  uCEFV8Value, uCEFv8Accessor, uCEFInterfaces, uCEFTypes, uCEFConstants;

type
  TBasicJsObjectBinding = class(TCefV8AccessorOwn)
  private

  protected
    FTestVal: ustring;

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

uses uBasicJsBinding, uCEFValue, uBROWSER_EventJsListnerList, uCEFProcessMessage;


//在context初始化时绑定js
class procedure TBasicJsObjectBinding.BindJsTo(const ACefv8Value: ICefv8Value);
var
  TempAccessor : ICefV8Accessor;
  TempObject   : ICefv8Value;
begin
  TempAccessor := TBasicJsObjectBinding.Create;
  TempObject   := TCefv8ValueRef.NewObject(TempAccessor, nil);

  //还可以继续绑定其他的函数或者方法
  TBasicJsBinding.BindJsTo(TempObject);

  ACefv8Value.SetValueByKey('JS_BRIDGE', TempObject, V8_PROPERTY_ATTRIBUTE_NONE);
end;


//下面的代码在browser进程中执行
class procedure TBasicJsObjectBinding.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  //要处理对BasicJsBinding，依次对上面的方法进行代理处理
  TBasicJsBinding.ExecuteInBrowser(Sender, browser, sourceProcess, message, Result);
end;





//下面两个方法在Render中执行
function TBasicJsObjectBinding.Get(const name: ustring; const obj: ICefv8Value;
  out retval: ICefv8Value; var exception: ustring): Boolean;
begin
  if (name = 'test_val') then
  begin
    retval := TCefv8ValueRef.NewString(FTestVal);
    Result := True;
  end
  else
    Result := False;
end;


function TBasicJsObjectBinding.Put(const name: ustring; const obj: ICefv8Value;
  const value: ICefv8Value; var exception: ustring): Boolean;
begin
  if (name = 'test_val') then
  begin
    if value.IsString then
      FTestVal := value.GetStringValue
    else
      exception := 'Invalid value type';
    Result := True;
  end
  else
    Result := False;
end;



end.
