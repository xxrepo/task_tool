unit uHttpServerRunner;

interface

uses uVVIdHttpServer, System.Classes, IdContext, IdCustomHTTPServer,
  IdBaseComponent, IdComponent, IdCustomTCPServer, uHttpServerConfig;

type
  THttpServerRunner = class(TComponent)
  private
    FServer: TIdHttpServerExt;
    FServerConfigRec: THttpServerConfigRec;

    procedure OnServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure OnServerCommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start(AServerConfigRec: THttpServerConfigRec);

    property Server: TIdHttpServerExt read FServer;
  end;

implementation

uses uDefines, System.SysUtils;

{ THttpServerRunner }

constructor THttpServerRunner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServer := TIdHTTPServerExt.Create(AOwner);
  FServer.OnCommandGet := OnServerCommandGet;
  FServer.OnCommandOther := OnServerCommandOther;
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
var
  LRequest: string;
  LResponseInfoExt: TIdHttpResponseInfoExt;
  LStringStream: TStringStream;
begin
  LRequest := 'Command: ' + ARequestInfo.Command;
  LRequest := LRequest + '; GET File: ' + ARequestInfo.Document;
  LRequest := LRequest + '; Params: ' + ARequestInfo.QueryParams;

  if ARequestInfo.Command = 'POST' then
  begin
    if ARequestInfo.PostStream <> nil then
    begin
      LStringStream := TStringStream.Create;
      try
        ARequestInfo.PostStream.Seek(0, 0);
        LStringStream.LoadFromStream(ARequestInfo.PostStream);
        LRequest := LRequest + '; Data: ' + UTF8Decode(LStringStream.DataString);
      finally
        LStringStream.Free;
      end;
    end;
  end;
  AppLogger.Debug('收到请求: ' + LRequest);

  //处理相关业务


  //输出结果

  LResponseInfoExt := AResponseInfo as TIdHttpResponseInfoExt;

  if (Trim(FServerConfigRec.AllowedAccessOrigins) <> '') then
  begin
    LResponseInfoExt.HeaderExt.Add('Access-Control-Allow-Origin: ' + FServerConfigRec.AllowedAccessOrigins);
    LResponseInfoExt.HeaderExt.Add('Access-Control-Allow-Methods: GET,POST');
    LResponseInfoExt.HeaderExt.Add('Access-Control-Allow-Headers: x-requested-with,content-type');
  end;

  AResponseInfo.ContentType := 'text/plain;charset=utf-8';
  AResponseInfo.ContentEncoding := 'utf-8';
  AResponseInfo.ContentText := '';//LRequest;
end;



procedure THttpServerRunner.OnServerCommandOther(AContext: TIdContext;
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
    (AResponseInfo as TIdHttpResponseInfoExt).HeaderExt.Add('Access-Control-Allow-Origin: ' + FServerConfigRec.AllowedAccessOrigins);
    (AResponseInfo as TIdHttpResponseInfoExt).HeaderExt.Add('Access-Control-Allow-Methods: GET,POST');
    (AResponseInfo as TIdHttpResponseInfoExt).HeaderExt.Add('Access-Control-Allow-Headers: x-requested-with,content-type');
  end;

  AResponseInfo.ContentType := 'text/plain;charset=utf-8';
  AResponseInfo.ContentEncoding := 'utf-8';
  AResponseInfo.ContentText := '';
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

end.
