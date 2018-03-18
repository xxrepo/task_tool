unit uBindingProxy;

interface

uses uCEFInterfaces, uCEFTypes;

type
  TBindingProxy = class
  private
    class procedure ExecuteInBrowser(Sender: TObject;
      const browser: ICefBrowser; sourceProcess: TCefProcessId;
      const message: ICefProcessMessage; out Result: Boolean); static;
  public
    class procedure BindJsTo(const ACefV8Context: ICefv8Context); static;

  end;

implementation

uses uCEFv8Value, uCEFConstants,
uBaseJsObjectBinding,
uSerialPortBinding;


//在context初始化时绑定js
class procedure TBindingProxy.BindJsTo(const ACefV8Context: ICefv8Context);
begin
  //绑定本应用需要的各级对象和函数
  TBasicJsObjectBinding.BindJsTo(ACefV8Context.Global);
  TSerialPortBinding.BindJsTo(ACefV8Context.Global);
end;


//下面的代码在browser进程中执行
class procedure TBindingProxy.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean);
begin
  //要处理对BasicJsBinding，依次对上面的方法进行代理处理
  TBasicJsObjectBinding.ExecuteInBrowser(Sender, browser, sourceProcess, message, Result);
  if not Result then
    TSerialPortBinding.ExecuteInBrowser(Sender, browser, sourceProcess, message, Result);
end;


end.
