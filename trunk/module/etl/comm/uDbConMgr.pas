unit uDbConMgr;

interface

uses
  System.JSON, Uni, System.Classes;

type
  TDbConMgr = class
  private
    FDBConfigStr: string;
    FDBConfigsJson: TJSONArray;
    FDBConList: TStringList;
    function GetDBConfig(ADBTitle: string): TJSONObject;
    function GetDBConfigs: TJSONArray;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadDbConfigs(ADBsConfigFile: string);

    function GetDBTitles: string;
    function GetDBConnection(ADbTitle: string): TUniConnection;
    function CreateDBConnection(ADbTitle: string): TUniConnection;

    property DBConfigs: TJSONArray read GetDBConfigs;
  end;

implementation

uses uDefines, uFunctions, System.SysUtils, Winapi.ActiveX, AccessUniProvider, SQLServerUniProvider,
OracleUniProvider, MySQLUniProvider, SQLiteUniProvider, ODBCUniProvider, uThreadSafeFile;

{ TDbConMgr }

constructor TDbConMgr.Create;
begin
  inherited;
  FDBConList := TStringList.Create;
end;


destructor TDbConMgr.Destroy;
var
  i: Integer;
begin
  if FDBConfigsJson <> nil then
    FDBConfigsJson.Free;
  //释放所有的uniconnection
  for i := 0 to FDBConList.Count - 1 do
  begin
    TUniConnection(FDBConList.Objects[i]).Disconnect;
    TUniConnection(FDBConList.Objects[i]).Free;
  end;

  FDBConList.Free;
  inherited;
end;


procedure TDbConMgr.LoadDbConfigs(ADBsConfigFile: string);
begin
  if FDBConfigsJson <> nil then
    FreeAndNil(FDBConfigsJson);

  FDBConfigStr := TThreadSafeFile.ReadContentFrom(ADBsConfigFile, '[]');
end;

function TDbConMgr.GetDBConfig(ADBTitle: string): TJSONObject;
var
  i: Integer;
  LDBConfigs: TJSONArray;
begin
  Result := nil;
  LDBConfigs := DBConfigs;
  AppLogger.Debug('获取数据库配置：' + ADBTitle);
  for i := 0 to LDBConfigs.Count - 1 do
  begin
    if (LDBConfigs.Items[i] as TJSONObject).GetValue('db_title').Value = ADBTitle then
    begin
      Result := (LDBConfigs.Items[i] as TJSONObject);
      if Result <> nil then
        AppLogger.Debug('获取到数据库配置：' + Result.ToString)
      else
        AppLogger.Debug('数据库配置为空：' + ADBTitle);
      Exit;
    end;
  end;
end;


function TDbConMgr.GetDBConfigs: TJSONArray;
begin
  if FDBConfigsJson = nil then
  begin
    FDBConfigsJson := TJSONObject.ParseJSONValue(FDBConfigStr) as TJSONArray;
    if FDBConfigsJson = nil then
      FDBConfigsJson := TJSONObject.ParseJSONValue('[]') as TJSONArray;
  end;
  Result := FDBConfigsJson;
end;


function TDbConMgr.GetDBConnection(ADbTitle: string): TUniConnection;
var
  LCon: TUniConnection;
  LDBConfig: TJSONObject;
begin
  Result := nil;
  LCon := nil;
  try
    //优先从conlist中匹配
    if FDBConList.IndexOf(ADbTitle) = -1 then
    begin
      //获取对应的json对象
      LDBConfig := GetDBConfig(ADbTitle);
      if LDBConfig = nil then
      begin
        raise Exception.Create('DBList中未找到DBConfig：' + FDBConfigsJson.ToString);
        Exit;
      end;

      AppLogger.Debug('创建DbConnection：' + ADbTitle);
      LCon := TUniConnection.Create(nil);
      LCon.ConnectString := GetJsonObjectValue(LDBConfig, 'connection_str');
      LCon.Password := GetJsonObjectValue(LDBConfig, 'password');
      LCon.SpecificOptions.Text := GetJsonObjectValue(LDBConfig, 'specific_str');

      AppLogger.Debug('设置链接池：' + ADbTitle);
      LCon.Pooling := True;
      LCon.PoolingOptions.MaxPoolSize := 10;
      LCon.PoolingOptions.MinPoolSize := 1;
      LCon.PoolingOptions.ConnectionLifetime := 60000;
      AppLogger.Debug('设置链接池成功：' + ADbTitle);

      FDBConList.AddObject(ADbTitle, LCon);
      AppLogger.Debug('添加DbConnection到队列成功：' + ADbTitle);
    end
    else
    begin
      AppLogger.Debug('从列表中获取数据库连接：' + IntToStr(FDBConList.IndexOf(ADbTitle)));
      LCon := TUniConnection(FDBConList.Objects[FDBConList.IndexOf(ADbTitle)]);
    end;

  finally
    if LCon = nil then
      raise Exception.Create('数据库连接获取失败：'+ADBTitle);

    Result := LCon;
  end;
end;


function TDbConMgr.CreateDBConnection(ADbTitle: string): TUniConnection;
var
  LCon: TUniConnection;
  LDBConfig: TJSONObject;
begin
  Result := nil;
  LCon := nil;
  try
    //获取对应的json对象
    LDBConfig := GetDBConfig(ADbTitle);
    if LDBConfig = nil then
    begin
      raise Exception.Create('DBList中未找到DBConfig：' + FDBConfigsJson.ToString);
      Exit;
    end;

    LCon := TUniConnection.Create(nil);
    LCon.ConnectString := GetJsonObjectValue(LDBConfig, 'connection_str');
    LCon.Password := GetJsonObjectValue(LDBConfig, 'password');
    LCon.SpecificOptions.Text := GetJsonObjectValue(LDBConfig, 'specific_str');
    LCon.Pooling := True;
    LCon.PoolingOptions.MaxPoolSize := 10;
    LCon.PoolingOptions.MinPoolSize := 1;
    LCon.PoolingOptions.ConnectionLifetime := 60000;

  finally
    if LCon = nil then
      raise Exception.Create('数据库连接Connection获取失败：'+ADBTitle);

    Result := LCon;
  end;
end;


//返回用逗号隔开的comma-text
function TDbConMgr.GetDBTitles: string;
var
  i: Integer;
  LDBConfigs: TJSONArray;
begin
  Result := '';
  LDBConfigs := DBConfigs;
  if LDBConfigs = nil then Exit;
  for i := 0 to LDBConfigs.Count - 1 do
  begin
    if Result = '' then
      Result := (LDBConfigs.Items[i] as TJSONObject).GetValue('db_title').Value
    else
      Result := Result + ',' + (LDBConfigs.Items[i] as TJSONObject).GetValue('db_title').Value;
  end;
end;

initialization
CoInitialize(nil);

finalization
CoUninitialize;

end.
