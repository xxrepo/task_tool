//运行在render进程中，属于jsv8的函数方法，本文件要么是单独能够提供服务，要么是向
//browser进程发送消息
//本进程还提供一个用于接收来自browser进程的方法，用于向render中运行的jsv8的context进行回调
//而这里，具体的context接收的消息是来自于chromium实体里面的对象了，也就是jsv8的context对应的cefbrowser
//另外，还有一个需要把回调函数的对象来保存在这个进程中对于不同类型事件的回调方法，有些回调函数是可以在回调
//完成之后就进行释放的，而有些，比如对某个事件的监听，则直到整个context被释放，才不需要进行
//这个函数方法是在render中执行的，同样，我们需要一个对应的实力来处理这些js方法函数，
//这个对应的方法函数是应该在browser的进程中存在的


unit uBaseJsBinding;

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
                      const message: ICefProcessMessage; out Result: Boolean; const AFormHandle: THandle); virtual;

    class procedure OpenNativeWindow(AWindowParams: string); static;
  end;


implementation

uses Winapi.Windows, Vcl.Dialogs, System.SysUtils, Vcl.Forms, uCEFProcessMessage,
  uRENDER_JsCallbackList, uCEFValue, uCEFConstants, uBROWSER_EventJsListnerList, uVVConstants,
  System.JSON, uAppDefines, uFunctions,
  uBasicChromeForm, uDefines, uJobDispatcher, uFileLogger;


const
  BINDING_NAMESPACE = 'BASIC/';


//在context初始化时绑定js
class procedure TBasicJsBinding.BindJsTo(const ACefv8Value: ICefv8Value);
var
  TempHandler  : ICefv8Handler;
  TempFunction : ICefv8Value;
begin
  TempHandler  := TBasicJsBinding.Create;

  ACefv8Value.SetValueByKey('__BROWSER_APP_VERSION', TCefv8ValueRef.NewString('1.0.0'), V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('openNativeWindow', TempHandler);
  ACefv8Value.SetValueByKey('openNativeWindow', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('startJob', TempHandler);
  ACefv8Value.SetValueByKey('startJob', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);

  TempFunction := TCefv8ValueRef.NewFunction('registerEventListner', TempHandler);
  ACefv8Value.SetValueByKey('registerEventListner', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);
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
  LMsgName, LCallbackIdxName: string;
begin
  LMsgName := BINDING_NAMESPACE + name;
  if (name = 'openNativeWindow') then
  begin
    LMsg := TCefProcessMessageRef.New(LMsgName);
    LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);
    TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
    Result := True;
  end
  else if (name = 'startJob') then
  begin
    if (Length(arguments) = 3) and (arguments[0].IsString) and (arguments[2].IsFunction) then
    begin
      //添加到回调函数列表中去，生成一个随机性的字符串，用来对应本次发起调用的回调函数
      LContextCallback.Context := TCefv8ContextRef.Current;
      LContextCallback.BrowserId := LContextCallback.Context.Browser.Identifier;
      LContextCallback.CallbackFunc := arguments[2];
      LCallbackIdxName := RENDER_JsCallbackList.AddCallback(LContextCallback);

      if LCallbackIdxName <> '' then
      begin
        //发送消息到browser进程
        LMsg := TCefProcessMessageRef.New(LMsgName);
        LMsg.ArgumentList.SetString(0, arguments[0].GetStringValue);
        LMsg.ArgumentList.SetString(1, arguments[1].GetStringValue);

        //第二个参数为回调函数
        LMsg.ArgumentList.SetString(2, LCallbackIdxName);

        TCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, LMsg);
      end
      else
        exception := 'callback function register error on ' + name;
    end;
    Result := True;
  end
  else if (name = 'registerEventListner') then
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
class procedure TBasicJsBinding.ExecuteInBrowser(Sender: TObject;
  const browser: ICefBrowser; sourceProcess: TCefProcessId;
  const message: ICefProcessMessage; out Result: Boolean; const AFormHandle: THandle);
var
  LMsg: ICefProcessMessage;
  LParams: ICefValue;
  LJsListnerRec: TEventJsListnerRec;
  LParamIdx: Integer;


  LSyncJobDispatcher: TJobDispatcher;
  LOutResult: TOutResult;
  LJobDispatcherRec: PJobDispatcherRec;
  LSplitterPos: Integer;
  LDispatch: string;
  LProjectName, LJobName: string;
begin
  if message.Name = BINDING_NAMESPACE + 'openNativeWindow' then
  begin
    LParamIdx := BROWSER_GlobalVar.AddParam(message.ArgumentList.GetString(0));
    PostMessage(Application.MainForm.Handle, VVMSG_OPEN_NATIVE_WINDOW, LParamIdx, 0);
    Result := True;
  end
  else if message.Name = BINDING_NAMESPACE + 'startJob' then
  begin
    //执行task，在结果返回时，把对应的执行结果放入lmsg中，作为rsp传入给render的js执行环节
    //回复一条回调函数的消息到render中，同时删掉对应的监听回调
    //这里可以引入临时变量尝试
    LDispatch := message.ArgumentList.GetString(0);
    LSplitterPos := Pos('/', LDispatch);
    LProjectName := Copy(LDispatch, 1, LSplitterPos - 1);
    LJobName := Copy(LDispatch, LSplitterPos + 1, Length(LDispatch) - LSplitterPos);

    New(LJobDispatcherRec);
    if LJobDispatcherRec <> nil then
    try
      LJobDispatcherRec^.ProjectFile := ExePath + 'projects\' + LProjectName + '\project.jobs';
      LJobDispatcherRec^.JobName := LJobName;
      LJobDispatcherRec^.InParams := message.ArgumentList.GetString(1);
      LJobDispatcherRec^.LogLevel := llDebug;
      LJobDispatcherRec^.LogNoticeHandle := AFormHandle;
    finally

    end;

    LSyncJobDispatcher := BROWSER_JobDispatcherMgr.NewDispatcher;
    try
      LSyncJobDispatcher.StartProjectJob(LJobDispatcherRec, True);

      if LSyncJobDispatcher <> nil then
        LOutResult := LSyncJobDispatcher.OutResult;
    finally
      BROWSER_JobDispatcherMgr.FreeDispatcher(LSyncJobDispatcher);
    end;

    LMsg := TCefProcessMessageRef.New(IPC_MSG_EXEC_CALLBACK);
    LMsg.ArgumentList.SetValue(0, message.ArgumentList.GetValue(2)); //callback_idxname

    //设置参数结果
    LMsg.ArgumentList.SetInt(1, LOutResult.Code);
    LMsg.ArgumentList.SetString(2, LOutResult.Msg);
    LMsg.ArgumentList.SetString(3, LOutResult.Data);

    //TODO 可以告诉render，执行完毕后，可以移除这个回调函数
    browser.SendProcessMessage(PID_RENDERER, LMsg);

    Result := True;
  end
  else if message.Name = BINDING_NAMESPACE + 'registerEventListner' then
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


//
class procedure TBasicJsBinding.OpenNativeWindow(AWindowParams: string);
var
  LWindowParamsJson: TJSONObject;
begin
  LWindowParamsJson := TJSONObject.ParseJSONValue(AWindowParams) as TJSONObject;
  if LWindowParamsJson = nil then Exit;

  //甚至可以在这里提供几个自定义相关的不同窗口类来对外提供不同的原生窗口界面
  try
    with TBasicChromeForm.Create(nil, 'file:///' + ExePath + 'app/html/index.html') do
    try
      Caption := GetJsonObjectValue(LWindowParamsJson, 'caption');
      ShowModal;
    finally
      Free;
    end;
  finally
    LWindowParamsJson.Free;
  end;

end;

end.
