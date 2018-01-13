unit uHttpServerCtrlForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdContext, IdCustomHTTPServer,
  Vcl.StdCtrls, IdBaseComponent, IdComponent, IdCustomTCPServer, IdHTTPServer,
  uVvIdHttpServer;

type
  TForm1 = class(TForm)
    btn1: TButton;
    mmo1: TMemo;
    idhttpsrvrJobDispatch: TIdHttpServerExt;
    procedure btn1Click(Sender: TObject);
    procedure idhttpsrvrJobDispatchCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure idhttpsrvrJobDispatchCommandOther(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  idhttpsrvrJobDispatch.Bindings.Clear;
  idhttpsrvrJobDispatch.DefaultPort := 61288;
  with idhttpsrvrJobDispatch.Bindings.Add do
  begin
    IP := '127.0.0.1';
  end;
  idhttpsrvrJobDispatch.Active := True;
end;

procedure TForm1.idhttpsrvrJobDispatchCommandGet(AContext: TIdContext;
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
        LRequest := LRequest + '; Data: ' + UTF8ToString(LStringStream.DataString);
      finally
        LStringStream.Free;
      end;

    end;
  end;

  LResponseInfoExt := AResponseInfo as TIdHttpResponseInfoExt;

  LResponseInfoExt.HeaderExt.Add('Access-Control-Allow-Origin: *');
  //LResponseInfoExt.HeaderExt.Add('Access-Control-Allow-Methods: GET,POST');
  //LResponseInfoExt.HeaderExt.Add('Access-Control-Allow-Headers: x-requested-with,content-type');

  AResponseInfo.ContentType := 'text/plain;charset=utf-8';
  AResponseInfo.ContentEncoding := 'utf-8';

  mmo1.Lines.Add('收到请求: ' + LRequest);

  AResponseInfo.ContentText := LRequest;


end;

procedure TForm1.idhttpsrvrJobDispatchCommandOther(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LRequest: string;
begin
  LRequest := 'Command: ' + ARequestInfo.Command;
  LRequest := LRequest + '; GET File: ' + ARequestInfo.Document;
  LRequest := LRequest + '; Params: ' + ARequestInfo.QueryParams;
  LRequest := LRequest + '; Data: ' + ARequestInfo.FormParams;
  //ARequestInfo.PostStream.Seek(0, 0);


  (AResponseInfo as TIdHttpResponseInfoExt).HeaderExt.Add('Access-Control-Allow-Origin: *');
  //(AResponseInfo as TIdHttpResponseInfoExt).HeaderExt.Add('Access-Control-Allow-Methods: GET,POST');
  (AResponseInfo as TIdHttpResponseInfoExt).HeaderExt.Add('Access-Control-Allow-Headers: x-requested-with,content-type');

  AResponseInfo.ContentType := 'text/plain;charset=utf-8';
  AResponseInfo.ContentEncoding := 'utf-8';

  mmo1.Lines.Add('收到请求: ' + LRequest);

  AResponseInfo.ContentText := LRequest;


end;

end.
