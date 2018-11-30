unit donix.steps.uStepDownloadFile;

interface

uses
  uStepBasic, System.JSON;

type
  TStepDownloadFile = class (TStepBasic)
  private
    FUrl: string;
    FRequestParams: string;
    FSaveToPath: string;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property Url: string read FUrl write FUrl;
    property RequestParams: string read FRequestParams write FRequestParams;
    property SaveToPath: string read FSaveToPath write FSaveToPath;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uTask,
  uStepDefines, System.Net.HttpClient, uNetUtil, REST.Client, REST.Types;

{ TStepQuery }

procedure TStepDownloadFile.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('url', FUrl));
  AToConfig.AddPair(TJSONPair.Create('request_params', FRequestParams));
  AToConfig.AddPair(TJSONPair.Create('save_to_path', FSaveToPath));
end;


procedure TStepDownloadFile.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FUrl := GetJsonObjectValue(StepConfig.ConfigJson, 'url');
  FRequestParams := GetJsonObjectValue(StepConfig.ConfigJson, 'request_params');
  FSaveToPath := GetJsonObjectValue(StepConfig.ConfigJson, 'save_to_path');
end;


procedure TStepDownloadFile.StartSelf;
var
  LFileName, LTargetFile, LSrcFileUrl: string;
  LRequestParamData: TRESTRequestParameterList;
  LRequestParamsJson: TJSONArray;
  LRequestParam: TJSONObject;
  i: Integer;
  LParamName, LParamValue: string;
begin
  try
    CheckTaskStatus;

    LSrcFileUrl := GetParamValue(FUrl, 'string', FUrl);
    LTargetFile := GetRealAbsolutePath(FSaveToPath);
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

    //加载任务文件
    DebugMsg('开始下载文件：' + LSrcFileUrl);
    LFileName := TNetUtil.DownloadFile(LSrcFileUrl, LRequestParamData, LTargetFile);
    if not FileExists(LFileName) then
    begin
      StopExceptionRaise('下载文件失败');
    end
    else
    begin
      //输出保存到本地的文件名称
      FOutData.Data := LFileName;
    end;
  finally
    if LRequestParamData <> nil then
      LRequestParamData.Free;
  end;
end;


initialization
RegisterClass(TStepDownloadFile);

finalization
UnRegisterClass(TStepDownloadFile);

end.
