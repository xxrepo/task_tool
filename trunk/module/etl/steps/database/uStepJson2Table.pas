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
    procedure LoadIntoTable;
    procedure ReplaceIntoTable;

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
  uDefines, uFunctions, uStepDefines, Winapi.ActiveX, System.SysUtils, UniLoader,
  Datasnap.DBClient;

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
begin
  CheckTaskStatus;
  CoInitialize(nil);
  try
    //根据是否填写了unique_key_fields来调用不同的方法
    if FUniqueKeyFields <> '' then
    begin
      ReplaceIntoTable;
    end
    else
    begin
      LoadIntoTable;
    end;
  finally
    CoUninitialize;
  end;
end;


procedure TStepJson2Table.ReplaceIntoTable;
var
  i, j: Integer;
  LQuery: TUniQuery;
  LUniqueKeyFields: TStringList;
  LCondition, LParamName: string;
  LData: TJSONArray;
  LRow: TJSONObject;
  LFieldPair: TJSONPair;
begin
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

    TaskVar.Logger.Debug(FormatLogMsg('导入数据到数据表：' + FTableName));
    LQuery.KeyFields := FUniqueKeyFields;

    //对unique_key_fields进行处理
    LUniqueKeyFields := TStringList.Create;
    try
      LUniqueKeyFields.Delimiter := ';';
      LUniqueKeyFields.DelimitedText := FUniqueKeyFields;
      LCondition := '';
      for i := 0 to LUniqueKeyFields.Count - 1 do
      begin
        LCondition := ' and ' + LUniqueKeyFields.Strings[i] + '=:' + LUniqueKeyFields.Strings[i];
      end;
    finally
      LUniqueKeyFields.Free;
    end;

    //对数据进行循环处理
    if not (FInData.JsonValue is TJSONArray) then
    begin
      LData := InDataJson as TJSONArray;
    end
    else
    begin
      LData := FInData.JsonValue as TJSONArray;
    end;

    if LData = nil then
    begin
      DebugMsg('没有要导入的数据');
      Exit;
    end;

    for i := 0 to LData.Count - 1 do
    begin
      LRow := LData.Items[i] as TJSONObject;
      if LRow = nil then
      begin
        StopExceptionRaise('LRow为空');
      end;

      if LQuery.Active then
        LQuery.Close;

      //获取Sql语句 解析绑定参数 查找定位记录
      LQuery.SQL.Text := 'select * from ' + FTableName + ' where 1' + LCondition;
      for j := 0 to LQuery.ParamCount - 1 do
      begin
        LParamName := LQuery.Params[j].Name;
        LQuery.ParamByName(LParamName).Value := JsonValueToVariant(LRow.GetValue(LParamName));
        TaskVar.Logger.Debug(FormatLogMsg('Sql绑定参数：' + LParamName + '=' + LQuery.ParamByName(LParamName).Value));
      end;
      LQuery.Prepare;
      LQuery.Open;

      if LQuery.RecordCount > 1 then
      begin
        //报错，unique_key_fields设置错误
        StopExceptionRaise('Unique Key Fields设置错误：' + FUniqueKeyFields + ' in Table ' + FTableName);
      end
      else if LQuery.RecordCount = 1 then
      begin
        if FSkipExists then Continue;

        //更新
        LQuery.Edit;
        for j := 0 to LRow.Count - 1 do
        begin
          LFieldPair := LRow.Pairs[j];
          LQuery.FieldByName(LFieldPair.JsonString.Value).Value := JsonValueToVariant(LFieldPair.JsonValue);
        end;
        LQuery.Post;
      end
      else
      begin
        //插入
        LQuery.Append;
        for j := 0 to LRow.Count - 1 do
        begin
          LFieldPair := LRow.Pairs[j];
          LQuery.FieldByName(LFieldPair.JsonString.Value).Value := JsonValueToVariant(LFieldPair.JsonValue);
        end;
        LQuery.Post;
      end;
    end;
  finally
    LQuery.Free;
  end;
end;


procedure TStepJson2Table.LoadIntoTable;
var
  LLoader: TUniLoader;
  LClientDataSet: TClientDataSet;
  LData: TJSONArray;
begin
  //一次性导入目标表
  LClientDataSet := TClientDataSet.Create(nil);
  LLoader := TUniLoader.Create(nil);
  try
    LLoader.TableName := FTableName;
    TaskVar.Logger.Debug(FormatLogMsg('获取数据库连接：' + FDBConTitle));

    LLoader.Connection := TaskVar.DbConMgr.GetDBConnection(FDBConTitle);
    if (LLoader.Connection.ProviderName = 'SQL Server')
        or (LLoader.Connection.ProviderName = 'MySQL')
        or (LLoader.Connection.ProviderName = 'PostgreSQL') then
    begin
      //LLoader.SpecificOptions.Add('CommandTimeout=100');
    end;

    //对数据进行循环处理
    if not (FInData.JsonValue is TJSONArray) then
    begin
      LData := InDataJson as TJSONArray;
    end
    else
    begin
      LData := FInData.JsonValue as TJSONArray;
    end;

    if LData = nil then
    begin
      DebugMsg('没有要导入的数据');
      Exit;
    end;

    JsonToDataSet(LData, LClientDataSet);
    LLoader.LoadFromDataSet(LClientDataSet);
    LLoader.Load;
  finally
    LLoader.Free;
    LClientDataSet.Free;
  end;
end;


initialization
RegisterClass(TStepJson2Table);


finalization
UnRegisterClass(TStepJson2Table);




end.
