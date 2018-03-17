unit uBROWSER_EventJsListnerList;

interface

uses System.Generics.Collections, uCEFInterfaces;

type
  TEventJsListnerRec = record
    EventName: string;

    BrowserId: Integer;
    Browser: ICefBrowser;
    ListnerMsgName: string;
  end;

  TEventJsListner = class
    EventName: string;

    BrowserId: Integer;
    Browser: ICefBrowser;
    ListnerMsgName: string;
  end;

  TBROWSER_EventJsListnerList = class
  private
    FListnerList: TObjectList<TEventJsListner>;
  public
    constructor Create;
    destructor Destroy; override;

    function AddEventListner(AEventJsListnerRec: TEventJsListnerRec): Integer;
    procedure EventNotify(ABrowser: ICefBrowser; AEventName: string; AArgs: ICefValue = nil);
    procedure RemoveListners(AEventName: string); overload;
    procedure RemoveListners(ABrowser: ICefBrowser); overload;
    procedure RemoveListners(ABrowser: ICefBrowser; AEventName: string); overload;
  end;

var
  BROWSER_EventJsListnerList: TBROWSER_EventJsListnerList;

implementation

uses uCEFTypes, uCEFProcessMessage;

{ TBROWSER_EventListnerList }

constructor TBROWSER_EventJsListnerList.Create;
begin
  inherited;
  FListnerList := TObjectList<TEventJsListner>.Create(False);
end;


destructor TBROWSER_EventJsListnerList.Destroy;
var
  i: Integer;
begin
  for i := FListnerList.Count - 1 downto 0 do
  begin
    if FListnerList.Items[i] <> nil then
      FListnerList.Items[i].Free;
  end;
  FListnerList.Free;
  inherited;
end;


procedure TBROWSER_EventJsListnerList.EventNotify(ABrowser: ICefBrowser; AEventName: string; AArgs: ICefValue);
var
  LProcessMsg: ICefProcessMessage;
begin
  //便利列表，找出对应的listner对应的func，生成新的event_name
  LProcessMsg := TCefProcessMessageRef.New(AEventName);
  LProcessMsg.ArgumentList.SetValue(0, AArgs);
  ABrowser.SendProcessMessage(PID_RENDERER, LProcessMsg);
end;



function TBROWSER_EventJsListnerList.AddEventListner(AEventJsListnerRec: TEventJsListnerRec): Integer;
begin
  //添加事件监听器到列表中，事件发生时，从本事件监听器列表中获取回调
  //注意，那么也可以提供一个参数，对某个时间执行，事件中的listner仅仅在browser释放的时候进行释放


end;


procedure TBROWSER_EventJsListnerList.RemoveListners(AEventName: string);
begin

end;


procedure TBROWSER_EventJsListnerList.RemoveListners(ABrowser: ICefBrowser);
begin

end;


procedure TBROWSER_EventJsListnerList.RemoveListners(ABrowser: ICefBrowser; AEventName: string);
begin

end;


end.


