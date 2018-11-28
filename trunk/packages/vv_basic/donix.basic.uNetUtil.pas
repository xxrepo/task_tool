unit donix.basic.uNetUtil;

interface

uses
  REST.Types, REST.Client, IdURI, IdGlobal, IPPeerClient, System.Classes;

type
  TNetUtil = class
  private
  public
    class function DownloadFile(AUrl: string; AParams: TRESTRequestParameterList; AToPath: string): string; static;
    class function InternetConnected: Boolean; static;
    class function RequestTo(AUrl: string; AParams: TRESTRequestParameterList; ARequestMethod: string = 'POST'): string;
    class function ParamEncodeUtf8(const AValue: string): string; static;
  end;

implementation

uses Winapi.WinInet, System.NetEncoding, Web.HTTPApp, uFileUtil;


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

    //调用接口
    LRestRequest.Execute;

    Result := LRestRequest.Response.Content;
  finally
    LRestRequest.Free;
    LRestClient.Free;
  end;
end;


class function TNetUtil.DownloadFile(AUrl: string;AParams: TRESTRequestParameterList; AToPath: string): string;
var
  LRestClient: TRESTClient;
  LRestRequest: TRESTRequest;
  LContent: TMemoryStream;
  LFileName: string;

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
    LRestRequest.Method := rmGET;
    LRestRequest.Params.Assign(AParams);

    //调用接口
    LRestRequest.Execute;

    LContent := TMemoryStream.Create;
    try
      LFileName := LRestRequest.Response.Headers.Values['Content-Disposition'];
      LFileName := Copy(LFileName, Pos('=', LFileName) + 1, Length(LFileName));
      LFileName := AToPath + LFileName;

      LContent.WriteData(LRestRequest.Response.RawBytes, LRestRequest.Response.ContentLength);
      TFileUtil.CreateDir(AToPath);
      LContent.SaveToFile(LFileName);
      Result := LFileName;
    finally
      LContent.Free;
    end;
  finally
    LRestRequest.Free;
    LRestClient.Free;
  end;
end;

end.
