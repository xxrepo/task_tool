unit uNetUtil;

interface

uses
  REST.Types, REST.Client, IdURI, IdGlobal, IPPeerClient;

type
  TNetUtil = class
  private
  public
    class function InternetConnected: Boolean; static;
    class function RequestTo(AUrl: string; AParams: TRESTRequestParameterList; ARequestMethod: string = 'POST'): string;
    class function ParamEncodeUtf8(const AValue: string): string; static;
  end;

implementation

uses Winapi.WinInet, System.NetEncoding, Web.HTTPApp, uDefines;


class function TNetUtil.InternetConnected: Boolean;
begin
  Result := False;
  if InternetGetConnectedState(nil, 0) then
  begin
    Result := True;
  end;
end;

class function TNetUtil.ParamEncodeUtf8(const AValue: string): string;
begin
  //HTTPEncode(UTF8Encode(AValue))
  Result := TNetEncoding.URL.Encode(UTF8Encode(AValue));//(TIdURI.ParamsEncode(AValue, IndyTextEncoding_UTF8));
end;


class function TNetUtil.RequestTo(AUrl: string; AParams: TRESTRequestParameterList; ARequestMethod: string = 'POST'): string;
var
  LRestClient: TRESTClient;
  LRestRequest: TRESTRequest;
begin
  Result := '';
  LRestClient := TRESTClient.Create(AUrl);
  LRestRequest := TRESTRequest.Create(nil);
  LRestRequest.Client := LRestClient;
  try
    //分析生成url
    LRestClient.BaseUrl := AUrl;
    LRestClient.ContentType := 'application/x-www-form-urlencoded;charset="UTF-8"';

    //附带上额外的请求参数信息
    if ARequestMethod = 'GET' then
      LRestRequest.Method := rmGET
    else
      LRestRequest.Method := rmPOST;
    LRestRequest.Params.Assign(AParams);
    LRestRequest.Params.AddCookie('http_agent_ver', APP_VER);

    //调用接口
    LRestRequest.Execute;

    Result := LRestRequest.Response.Content;
  finally
    LRestRequest.Free;
    LRestClient.Free;
  end;
end;

end.
