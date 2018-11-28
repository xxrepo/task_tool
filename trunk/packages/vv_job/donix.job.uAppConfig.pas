unit donix.job.uAppConfig;

interface

uses
  System.IniFiles, System.Win.Registry, System.Classes;

type
  TAppConfig = class
  private
    FCfgIniFile: TIniFile;
    FParamIniFile: TIniFile;   //用于保存运行过程中产生的参数信息
  public
    Debug: string;

    constructor Create;
    destructor Destroy; override;
    procedure Load;
    procedure Save;

    procedure WriteParamValue(ASection, AParamName, AParamValue: string); overload;
    function ReadParamValue(ASection, AParamName, ADefaultValue: string): string; overload;
    procedure WriteParamValue(AParamName, AParamValue: string); overload;
    function ReadParamValue(AParamName: string): string; overload;
  end;

implementation

uses
  uDesignTimeDefines, Winapi.Windows, System.SysUtils, Vcl.Dialogs, uDefines;

{ TCgtConfig }

constructor TAppConfig.Create;
begin
  FCfgIniFile := TIniFile.Create(ExePath + 'config/app.ini');
  FParamIniFile := TIniFile.Create(ExePath + 'config/params.ini');
  Load;
end;

destructor TAppConfig.Destroy;
begin
  FParamIniFile.Free;
  FCfgIniFile.Free;
  inherited;
end;

procedure TAppConfig.Load;
begin

end;


//把数据库同步时的参数状态实时更新到本地文件中去



procedure TAppConfig.Save;
begin
  //ini
end;


procedure TAppConfig.WriteParamValue(ASection: string; AParamName: string; AParamValue: string);
begin
  FParamIniFile.WriteString(ASection, AParamName, AParamValue);
end;


function TAppConfig.ReadParamValue(ASection: string; AParamName: string; ADefaultValue: string): string;
begin
  Result := FParamIniFile.ReadString(ASection, AParamName, ADefaultValue);
end;


procedure TAppConfig.WriteParamValue(AParamName: string; AParamValue: string);
begin
  FParamIniFile.WriteString('params', AParamName, AParamValue);
end;


function TAppConfig.ReadParamValue(AParamName: string): string;
begin
  Result := FParamIniFile.ReadString('params', AParamName, '');
end;


end.
