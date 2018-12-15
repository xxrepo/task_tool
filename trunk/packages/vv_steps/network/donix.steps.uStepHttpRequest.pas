unit donix.steps.uStepHttpRequest;
interface

uses
  uStepBasic, System.JSON;

type
  TStepHttpRequest = class (TStepBasic)
  private
    FUrl: string;
    FRequestMethod: string;
    FRequestParams: string;
    FResponseParams: string;
  protected

    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property Url: string read FUrl write FUrl;
    property RequestMethod: string read FRequestMethod write FRequestMethod;
    property RequestParams: string read FRequestParams write FRequestParams;
    property ResponseParams: string read FResponseParams write FResponseParams;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions,
  System.IniFiles, System.StrUtils, uStepDefines, REST.Client, REST.Types, uNetUtil;

{ TStepQuery }

procedure TStepHttpRequest.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('url', FUrl));
  AToConfig.AddPair(TJSONPair.Create('request_method', FRequestMethod));
  AToConfig.AddPair(TJSONPair.Create('request_params', FRequestParams));
  AToConfig.AddPair(TJSONPair.Create('rsp_params', FResponseParams));
end;


procedure TStepHttpRequest.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FUrl := GetJsonObjectValue(StepConfig.ConfigJson, 'url');
  FRequestMethod := GetJsonObjectValue(StepConfig.ConfigJson, 'request_method');
  FRequestParams := GetJsonObjectValue(StepConfig.ConfigJson, 'request_params');
  FResponseParams := GetJsonObjectValue(StepConfig.ConfigJson, 'rsp_params');
end;



procedure TStepHttpRequest.StartSelf;
var
  LRequestParamData: TRESTRequestParameterList;
  LRequestParamsJson, LRspParamsJson: TJSONArray;
  LRequestParam, LOutJson, LRspJson, LRspParamConfigJson: TJSONObject;
  i: Integer;
  LTryCount: Integer;
  LUrl: string;
  LParamName, LParamValue: string;
begin
  try
    CheckTaskStatus;

    LRspParamsJson := nil;
    LRspJson := nil;
    LOutJson := nil;
    LRequestParamData := nil;

    //设置好参数信息
    LRequestParamsJson := TJSONObject.ParseJSONValue(FRequestParams) as TJSONArray;
    if LRequestParamsJson <> nil then
    begin
      LRequestParamData := TRESTRequestParameterList.Create(nil);
      try
        for i := 0 to LRequestParamsJson.Count - 1 do
        begin
          LRequestParam := LRequestParamsJson.Items[i] as TJSONObject;
          if LRequestParam = nil then Continue;
          LParamName := GetJsonObjectValue(LRequestParam, 'param_name');
          LParamValue := GetParamValue(LRequestParam);
          LRequestParamData.AddItem(LParamName,
                                    TNetUtil.ParamEncodeUtf8(LParamValue),
                                    pkGETorPOST,
                                    [poDoNotEncode]);
          TaskVar.Logger.Debug(FormatLogMsg('准备HTTP请求参数：' + LParamName + '：' + LParamValue));
        end;
      finally
        LRequestParamsJson.Free;
      end;
    end;

    //联网状态检测
    LTryCount := 0;
    while not TNetUtil.InternetConnected do
    begin
      Sleep(500);
      LTryCount := LTryCount + 1;
      if LTryCount > 2 then Break;
    end;

    //调用接口
    LUrl := GetParamValue(FUrl, 'string', FUrl);
    FOutData.DataType := sdtText;
    FOutData.Data := TNetUtil.RequestTo(LUrl, LRequestParamData, FRequestMethod);

    TaskVar.Logger.Debug(FormatLogMsg('发起网络请求：' + LUrl));


    //输出结果
    LRspParamsJson := TJSONObject.ParseJSONValue(FResponseParams) as  TJSONArray;
    LRspJson := nil;
    LOutJson := nil;
    if (LRspParamsJson <> nil) and (LRspParamsJson.Count > 0) then
    begin
      LRspJson := TJSONObject.ParseJSONValue(FOutData.Data) as TJSONObject;
      if LRspJson <> nil then
      begin
        LOutJson := TJSONObject.Create;
        for i := 0 to LRspParamsJson.Count - 1 do
        begin
          LRspParamConfigJson := LRspParamsJson.Items[i] as TJSONObject;
          LOutJson.AddPair(TJSONPair.Create(GetJsonObjectValue(LRspParamConfigJson, 'param_name'),
                                             GetJsonObjectValue(LRspJson,
                                             GetJsonObjectValue(LRspParamConfigJson, 'param_value_ref'),
                                             GetJsonObjectValue(LRspParamConfigJson, 'default_value'))));
        end;

        //Edited by ToString
        FOutData.DataType := sdtText;
        FOutData.Data := LOutJson.ToJSON;
      end;
    end;
  finally
    if LRequestParamData <> nil then
      LRequestParamData.Free;
    if LRspParamsJson <> nil then
      LRspParamsJson.Free;
    if LRspJson <> nil then
      LRspJson.Free;
    if LOutJson <> nil then
      LOutJson.Free;
  end;
end;

end.
