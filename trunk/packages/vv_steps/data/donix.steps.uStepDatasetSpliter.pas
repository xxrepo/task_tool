unit donix.steps.uStepDatasetSpliter;

interface

uses
  uStepBasic, System.JSON;

type
  TStepDatasetSpliter = class (TStepBasic)
  private
    FDatasetRef: string;
    FSplitType: string;
    FCountLimit: Integer;
  protected
    procedure StartSelf; override;

  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    procedure Start; override;

    property DatasetRef: string read FDatasetRef write FDatasetRef;
    property SplitType: string read FSplitType write FSplitType;
    property CountLimit: Integer read FCountLimit write FCountLimit;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines, Math;

{ TStepQuery }

procedure TStepDatasetSpliter.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('dataset_ref', FDatasetRef));
  AToConfig.AddPair(TJSONPair.Create('split_type', FSplitType));
  AToConfig.AddPair(TJSONPair.Create('count_limit', IntToStr(FCountLimit)));
end;


procedure TStepDatasetSpliter.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDatasetRef := GetJsonObjectValue(StepConfig.ConfigJson, 'dataset_ref');
  FSplitType := GetJsonObjectValue(StepConfig.ConfigJson, 'split_type');
  FCountLimit := Max(1, StrToIntDef(GetJsonObjectValue(StepConfig.ConfigJson, 'count_limit'), 1));
end;


procedure TStepDatasetSpliter.Start;
begin
  //StartChildren在start_self中发生调用
  StartSelf;
end;


procedure TStepDatasetSpliter.StartSelf;
var
  LStepData: TStepData;
  LDataJson, LSubArrayJson: TJSONArray;
  LRowJson: TJSONObject;
  i, LRec, LCurrentPack: Integer;
begin
  try
    CheckTaskStatus;

    LDataJson := nil;
    LSubArrayJson := nil;

    //获取数据集
    LStepData := GetStepDataFrom(FDatasetRef);

    LDataJson := TJSONObject.ParseJSONValue(LStepData.Data) as TJSONArray;
    if LDataJson = nil  then Exit;

    LCurrentPack := 0;

    if FSplitType = 'single_obj' then
    begin
      for i := 0 to LDataJson.Count - 1 do
      begin
        TaskVar.Logger.Debug(FormatLogMsg('执行Spliter第' + IntToStr(i + 1) + '批/总共' + IntToStr(LDataJson.Count) + '批/每批1条'));

        CheckTaskStatus;

        LRowJson := LDataJson.Items[i] as TJSONObject;
        if LRowJson = nil then Continue;

        //Edited by ToString
        FOutData.DataType := sdtText;
        FOutData.Data := LRowJson.ToJSON;

        StartChildren;
      end;
    end
    else
    begin
      LSubArrayJson := TJSONArray.Create;
      LRec := LDataJson.Count;
      for i := 1 to LRec do
      begin
        LSubArrayJson.AddElement(LDataJson.Items[i - 1].Clone as TJSONValue);
        if ((i mod CountLimit) = 0) or (i = LDataJson.Count) then
        begin
          LCurrentPack := LCurrentPack + 1;
          TaskVar.Logger.Debug(FormatLogMsg('执行Spliter第' + IntToStr(LCurrentPack) + '批/总共'
                                          + IntToStr(Ceil(LDataJson.Count / CountLimit)) + '批/本批记录数：'
                                          + IntToStr(LSubArrayJson.Count) + '条/每批'
                                          + IntToStr(CountLimit) + '条'));

          //Edited by ToString
          FOutData.DataType := sdtText;
          FOutData.Data := LSubArrayJson.ToJSON;

          StartChildren;

          //释放同时创建
          LSubArrayJson.Free;

          CheckTaskStatus;

          LSubArrayJson := TJSONArray.Create;
        end;
      end;
    end;
  finally
    if LDataJson <> nil then
      LDataJson.Free;
    if LSubArrayJson <> nil then
      LSubArrayJson.Free;
  end;
end;



initialization
RegisterClass(TStepDatasetSpliter);

finalization
UnRegisterClass(TStepDatasetSpliter);

end.
