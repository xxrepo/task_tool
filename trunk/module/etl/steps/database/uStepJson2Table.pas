unit uStepJson2Table;

interface

uses
  uStepBasic, System.JSON, System.Classes, Uni;

type
  TStepJson2Table = class (TStepBasic)
  private
    FDBConTitle: string;
    FTableName: string;
    FUniqueKeyFields: string;
    FSkipExists: Boolean;

  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property DBConTitle: string read FDBConTitle write FDBConTitle;
    property TableName: string read FTableName write FTableName;
    property UniqueKeyFields: string read FUniqueKeyFields write FUniqueKeyFields;
    property SkipExists: Boolean read FSkipExists write FSkipExists;
  end;

implementation

uses
  uDefines, uFunctions, uStepDefines, Winapi.ActiveX, System.SysUtils;

{ TStepQuery }

procedure TStepJson2Table.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('db_title', FDBConTitle));
  AToConfig.AddPair(TJSONPair.Create('table_name', FTableName));
  AToConfig.AddPair(TJSONPair.Create('unique_key_fields', FUniqueKeyFields));
  AToConfig.AddPair(TJSONPair.Create('skip_exists', BoolToStr(FSkipExists)));
end;


procedure TStepJson2Table.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FDBConTitle := GetJsonObjectValue(StepConfig.ConfigJson, 'db_title');
  FTableName := GetJsonObjectValue(StepConfig.ConfigJson, 'table_name');
  FUniqueKeyFields := GetJsonObjectValue(StepConfig.ConfigJson, 'unique_key_fields');
  FSkipExists := GetJsonObjectValue(StepConfig.ConfigJson, 'skip_exists');
end;


procedure TStepJson2Table.StartSelf;
var
  LQuery: TUniQuery;
  i: Integer;
  LParamName: string;
  LParamConfig: TJSONObject;
  LSqlParamsConfigJson: TJSONArray;
begin
  CheckTaskStatus;
  CoInitialize(nil);

  //获取数据库连接
  LQuery := TUniQuery.Create(nil);
  try
    TaskVar.Logger.Debug(FormatLogMsg('获取数据库连接：' + FDBConTitle));

    LQuery.Connection := TaskVar.DbConMgr.GetDBConnection(FDBConTitle);
    if (LQuery.Connection.ProviderName = 'SQL Server')
        or (LQuery.Connection.ProviderName = 'MySQL')
        or (LQuery.Connection.ProviderName = 'PostgreSQL') then
    begin
      LQuery.SpecificOptions.Add('CommandTimeout=30');
    end;

    TaskVar.Logger.Debug(FormatLogMsg('SQL：' + FTableName));

    //获取Sql语句
    LQuery.SQL.Text := 'select * from ' + FTableName + ' where 1';

    //解析绑定参数
    if LQuery.ParamCount > 0 then
    begin
      try
        //依次，逐条处理，根据unique_key_fields来进行定位更新



        for i := 0 to LQuery.ParamCount - 1 do
        begin
          LParamName := LQuery.Params[i].Name;
          LParamConfig := GetRowInJsonArray(LSqlParamsConfigJson, 'param_name', LParamName);

          LQuery.ParamByName(LParamName).Value := GetParamValue(LParamConfig);

          TaskVar.Logger.Debug(FormatLogMsg('Sql绑定参数：' + LParamName + '=' + LQuery.ParamByName(LParamName).Value));
        end;
      finally
        LSqlParamsConfigJson.Free;
      end;
    end;

    //执行
    try
      LQuery.Prepare;
      LQuery.Open;
    except
      on E: Exception do
      begin
        TaskVar.Logger.Error('Query.Open执行异常：' + E.Message);
        StopExceptionRaise(E.Message);
      end;
    end;


    if LQuery.Active then
    begin
      FOutData.DataType := sdtText;
      FOutData.Data := UniQueryToJsonStr(LQuery);

      TaskVar.Logger.Debug(FormatLogMsg('Sql运行成功，记录数：' + IntToStr(LQuery.RecordCount)));
    end
    else
      TaskVar.Logger.Debug(FormatLogMsg('Sql运行失败'));
  finally
    LQuery.Close;
    LQuery.Free;
    CoUninitialize;
  end;
end;



initialization
RegisterClass(TStepJson2Table);


finalization
UnRegisterClass(TStepJson2Table);




end.
