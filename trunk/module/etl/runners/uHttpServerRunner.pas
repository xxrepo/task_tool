unit uHttpServerRunner;

interface

uses IdContext, IdCustomHTTPServer, IdHTTPServer, System.JSON, uHttpServerConfig, uJobDispatcher;

type

  THttpServerRunner = class
  private
    FServer: TIdHttpServer;
    FServerConfigRec: THttpServerConfigRec;

    procedure OnServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure OnServerCommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleCommandRequest(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleCommandEnter(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function GetRequestParams(ARequestInfo: TIdHTTPRequestInfo): string;
    procedure OutputResult(ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo; AOutResult: TOutResult);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start(AServerConfigRec: THttpServerConfigRec);

    property Server: TIdHttpServer read FServer;
  end;

implementation

uses uFunctions, uDefines, System.SysUtils, uFileUtil, System.Classes;

type
  DisParamException = class(Exception);

{ THttpServerRunner }

constructor THttpServerRunner.Create;
begin
  inherited;
  FServer := TIdHTTPServer.Create(nil);
  FServer.OnCommandGet := OnServerCommandGet;
  FServer.OnCommandOther := OnServerCommandOther;
end;



destructor THttpServerRunner.Destroy;
begin
  try
    FServer.Active := False;
    FreeAndNil(FServer);
  except

  end;
  inherited;
end;


procedure THttpServerRunner.Start(AServerConfigRec: THttpServerConfigRec);
begin
  try
    if FServer.Active then
    begin
      FServer.StopListening;
      FServer.Active := False;
    end;

    FServerConfigRec := AServerConfigRec;
    FServerConfigRec.AbsDocRoot := TFileUtil.GetAbsolutePathEx(ExePath, AServerConfigRec.DocRoot);

    FServer.Bindings.Clear;
    with FServer.Bindings.Add do
    begin
      IP := AServerConfigRec.IP;
      Port := AServerConfigRec.Port;
    end;
    FServer.DefaultPort := AServerConfigRec.Port;
    FServer.Active := True;
  except
    on E: Exception do
      AppLogger.Fatal('LocalServer启动失败：' + E.Message);
  end;
end;



procedure THttpServerRunner.OnServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  //log以及其他通用的一些记录
  HandleCommandEnter(AContext, ARequestInfo, AResponseInfo);

  //处理相关业务
  HandleCommandRequest(AContext, ARequestInfo, AResponseInfo);

  //设置输出
  AResponseInfo.Server := 'CGT SERVER 1.0';
  AResponseInfo.CharSet := 'utf-8';
end;



procedure THttpServerRunner.OnServerCommandOther(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  //log以及其他通用的一些记录
  HandleCommandEnter(AContext, ARequestInfo, AResponseInfo);

  //处理相关业务
  AResponseInfo.ContentText := '';
  AResponseInfo.ContentType := 'text/plain;charset=utf-8';

  //设置输出
  AResponseInfo.Server := 'CGT SERVER 1.0';
  AResponseInfo.ContentEncoding := 'utf-8';
end;


procedure THttpServerRunner.HandleCommandEnter(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LRequest: string;
begin
  //主要对跨域进行处理
  LRequest := 'Command: ' + ARequestInfo.Command;
  LRequest := LRequest + '; GET File: ' + ARequestInfo.Document;
  LRequest := LRequest + '; Params: ' + ARequestInfo.QueryParams;
  LRequest := LRequest + '; Data: ' + ARequestInfo.FormParams;
  AppLogger.Debug('收到请求: ' + LRequest);

  if (Trim(FServerConfigRec.AllowedAccessOrigins) <> '') then
  begin
    AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Origin'] := FServerConfigRec.AllowedAccessOrigins;
    AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Methods'] := 'GET,POST';
    AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Headers'] := 'x-requested-with,content-type';
  end;
end;



//处理对应的请求，对于file，对于有些请求，需要直接调用JobDispatcher，交JobDispatcher去处理
//对于异步消息，发送到AsyncJobHandlerForm去处理，在AsyncJobHandlerForm中，再启动一次JobDispatcher，
//然后JobDispatcher再次创建，运行对应的job，在JobDispatcher中，不再判断是否异步还是同步，也就是说，
//JobDispatcher是只会处理同步消息的，由于多线程的Session机制，这就要求，form也是在对多个线程中发送过来的消息进行响应
//消息默认会排队，因此会逐个处理，但是在form中启动JobDispatcher时，不再检查是否是异步消息机制，当然，
//我们也可以都当成同步机制，仅仅只是在发起调用方，告诉http是要异步处理还是同步处理，http接收这个参数来进行
//是否要进行异步消息处理机制，从而使得jobdispatcher默认都是同步处理机制，简化job的认知，当然，我们可以通过
//设置job是后台服务还是ui交互服务特性来进行相应的标识，这样对于job在service运行中也是能有相应的交互的
procedure THttpServerRunner.HandleCommandRequest(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LLocalDoc: string;
  LDocPath: string;
  LDisStrings: TStringList;
  LJobDispatcherRec: PJobDispatcherRec;
  LJobDispatcher: TJobDispatcher;
  LOutResult: TOutResult;
begin
  LLocalDoc := ExpandFilename(FServerConfigRec.AbsDocRoot + ARequestInfo.Document);

  //判断是否带有参数dis
  if (ARequestInfo.Params.Values['dis'].Length > 0) then
  begin
    LDocPath := ExtractFilePath(LLocalDoc);
    New(LJobDispatcherRec);

    //对请求进行解析
    LDisStrings := TStringList.Create;
    try
      LDisStrings.Delimiter := '/';
      LDisStrings.DelimitedText := ARequestInfo.Params.Values['dis'];
      if LDisStrings.Count = 2 then
      begin
        LJobDispatcherRec^.ProjectFile := LDocPath + LDisStrings.Strings[0] + '\project.jobs';
        LJobDispatcherRec^.JobName := LDisStrings.Strings[1];
        LJobDispatcherRec^.InParams := GetRequestParams(ARequestInfo);
      end
      else
        Dispose(LJobDispatcherRec);
    finally
      LDisStrings.Free;
    end;

    LOutResult.Code := -1;
    LOutResult.Msg := '处理失败';
    LOutResult.Data := '';

    if LJobDispatcherRec = nil then
    begin
      //输出错误结果
      LOutResult.Msg := 'dis参数异常';
      LOutResult.Data := ARequestInfo.Params.Values['dis'];
    end
    else
    begin
      //执行jobdispatcher，如果传入的是异步消息，则发送job的消息到AsyncJobHandlerForm
      if ARequestInfo.Params.Values['vv_async'].Length > 0 then
      begin
        //设置输出结果
        //PostMessage

        LOutResult.Code := 1;
        LOutResult.Msg := '请求处理中';
      end
      else
      begin
        //否则生成jobdispatcher，直接调用
        LJobDispatcher := TJobDispatcher.Create(FServerConfigRec.LogLevel);
        try
          LJobDispatcher.LogNoticeHandle := FServerConfigRec.LogNoticeHandle;
          LJobDispatcher.StartProjectJob(LJobDispatcherRec);

          //获得输出参数
          LOutResult := LJobDispatcher.OutResult;
        finally
          LJobDispatcher.Free;
        end;
      end;
    end;

    //根据rsp进行应答处理
    OutPutResult(ARequestInfo, AResponseInfo, LOutResult);
  end
  else
  begin
    //对文件处理
    if not FileExists(LLocalDoc) and DirectoryExists(LLocalDoc) and FileExists(ExpandFilename(LLocalDoc + '/index.html '))
    then
    begin
      LLocalDoc := ExpandFilename(LLocalDoc + '/index.html ');
    end;

    AppLogger.Debug('获取文件：' + LLocalDoc);

    if FileExists(LLocalDoc) then // File   exists
    begin
      //对于web支持的文件格式，进行直接的文件流输出，否则，进行下载传输
      if AnsiSameText(Copy(LLocalDoc, 1, length(FServerConfigRec.AbsDocRoot)), FServerConfigRec.AbsDocRoot) then // File   down   in   dir   structure
      begin
        AResponseInfo.ContentStream := TFileStream.Create(LLocalDoc, fmOpenRead + fmShareDenyWrite);
        AResponseInfo.ContentType := FServer.MIMETable.GetFileMIMEType(LLocalDoc);
      end
      else
        AResponseInfo.ResponseNo := 403;
    end
    else
    begin
      AResponseInfo.ResponseNo := 404;
    end;
  end;
end;



function THttpServerRunner.GetRequestParams(ARequestInfo: TIdHTTPRequestInfo): string;
var
  LStringStream: TStringStream;
  LParams: TJSONObject;
  i: Integer;
  LGetJson: TJSONObject;
begin
  LParams := TJSONObject.Create;

  try
    //_GET
    LGetJson := TJSONObject.Create;
    for i := 0 to ARequestInfo.Params.Count - 1 do
    begin
      LGetJson.AddPair(TJSONPair.Create(ARequestInfo.Params.Names[i], ARequestInfo.Params.ValueFromIndex[i]));
    end;
    LParams.AddPair(TJSONPair.Create('_GET', LGetJson));

    //_POST
    if UpperCase(ARequestInfo.Command) = 'POST' then
    begin
      if ARequestInfo.PostStream <> nil then
      begin
        LStringStream := TStringStream.Create;
        try
          ARequestInfo.PostStream.Seek(0, 0);
          LStringStream.LoadFromStream(ARequestInfo.PostStream);
          LParams.AddPair(TJSONPair.Create('_POST', UTF8ToString(LStringStream.DataString)));
        finally
          LStringStream.Free;
        end;
      end;
    end;

    Result := LParams.ToString;
  finally
    LParams.Free;
  end;
end;


procedure THttpServerRunner.OutputResult(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo;
  AOutResult: TOutResult);
var
  LRsp: string;
  LResultJson: TJSONObject;
  LDataJson: TJSONValue;
begin
  LRsp := ARequestInfo.Params.Values['rsp'];

  AResponseInfo.ContentText := AOutResult.Data;
  if AOutResult.Code < 0 then
      AResponseInfo.ContentText := AOutResult.Msg;

  if (LRsp = 'html') then
  begin
    AResponseInfo.ContentType := 'text/html';
  end
  else if (LRsp = 'htmlplain') or (LRsp = 'textplain') or (LRsp = 'plain') then
  begin
    AResponseInfo.ContentType := 'text/plain';
  end
  else
  begin
    //默认 json
    AResponseInfo.ContentType := 'application/json';

    LResultJson := TJSONObject.Create;
    try
      LResultJson.AddPair(TJSONPair.Create('code', TJSONNumber.Create(AOutResult.Code)));
      LResultJson.AddPair(TJSONPair.Create('msg', AOutResult.Msg));
      LResultJson.AddPair(TJSONPair.Create('data', StrToJsonValue(AOutResult.Data)));

      AResponseInfo.ContentText := LResultJson.ToJSON;
    finally
      LResultJson.Free;
    end;

  end;
end;


end.
