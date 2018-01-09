unit uServiceControlForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.ExtCtrls, RzPanel,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, RzEdit, RzBtnEdt;

type
  TServiceControlForm = class(TBasicForm)
    rzpnl1: TRzPanel;
    btnInstall: TBitBtn;
    btnStop: TBitBtn;
    lblServiceStatus: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lblServiceStatusStr: TLabel;
    btnJobsFile: TRzButtonEdit;
    edtHandlerCount: TEdit;
    btnUnInstall: TBitBtn;
    btnStart: TBitBtn;
    dlgOpenJobs: TOpenDialog;
    tmrCheckServiceStatus: TTimer;
    lbl3: TLabel;
    cbbLogLevel: TComboBox;
    lbl4: TLabel;
    mmoAllowedTime: TMemo;
    lbl7: TLabel;
    lbl5: TLabel;
    mmoDisallowedTime: TMemo;
    lbl8: TLabel;
    btnTestService: TBitBtn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnUnInstallClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnJobsFileButtonClick(Sender: TObject);
    procedure tmrCheckServiceStatusTimer(Sender: TObject);
    procedure btnTestServiceClick(Sender: TObject);
  private
    function SaveServiceConfig: Boolean;
    procedure RefreshServiceStatus;
    procedure LoadServiceConfig;
    procedure TerminateTest;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServiceControlForm: TServiceControlForm;

implementation

uses uServiceUtil, uServiceConfig, uServiceRunner, uDesignTimeDefines, uFileUtil;

var
  ServiceConfig: TServiceConfig;
  ServiceRunner: TServiceRunner;

  SERVICE_NAME: string;

{$R *.dfm}

procedure TServiceControlForm.btnStopClick(Sender: TObject);
begin
  inherited;
  if TServiceUtil.QueryServiceStatusStr(SERVICE_NAME) = '未安装' then
  begin
    ShowMsg('请先安装服务');
  end
  else
  begin
    if not TServiceUtil.StopServices(SERVICE_NAME) then
      ShowMsg('服务停止失败');
  end;
end;

procedure TServiceControlForm.TerminateTest;
begin
  if ServiceRunner <> nil then
  begin
    ServiceRunner.Terminate;
    ServiceRunner.WaitFor;

    FreeAndNil(ServiceRunner);
  end;
end;

procedure TServiceControlForm.btnTestServiceClick(Sender: TObject);
begin
  inherited;
  if ServiceRunner <> nil then
  begin
    try
      TerminateTest;
      btnTestService.Caption := '测试';
    finally

    end;
  end
  else
  begin
    if SaveServiceConfig then
    begin
      try
        ServiceRunner := TServiceRunner.Create(ExePath, ServiceConfig);
        ServiceRunner.Start;
        btnTestService.Caption := '停止测试';
      finally

      end;
    end;
  end;
end;

procedure TServiceControlForm.btnInstallClick(Sender: TObject);
begin
  inherited;
  //save
  if SaveServiceConfig then
  begin
    if TServiceUtil.QueryServiceStatusStr(SERVICE_NAME) <> '未安装' then
    begin
      ShowMsg('服务程序已经安装');
    end
    else if not TServiceUtil.InstallServices(SERVICE_NAME,  'CGT Etl Service', ExePath + 'CgtEtlService.exe') then
      ShowMsg('服务安装失败');
  end;
end;

procedure TServiceControlForm.btnJobsFileButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenJobs.InitialDir := ExePath;
  if dlgOpenJobs.Execute then
  begin
    if not FileExists(dlgOpenJobs.FileName) then Exit;

    btnJobsFile.Text := TFileUtil.GetRelativePath(ExePath, dlgOpenJobs.FileName);
  end;
end;

procedure TServiceControlForm.btnStartClick(Sender: TObject);
begin
  inherited;
  //save
  if SaveServiceConfig then
  begin
    if TServiceUtil.QueryServiceStatusStr(SERVICE_NAME) = '启动'  then
    begin
      ShowMsg('服务已经启动');
    end
    else if not TServiceUtil.StartServices(SERVICE_NAME) then
      ShowMsg('服务启动失败');
  end;
end;


procedure TServiceControlForm.btnUnInstallClick(Sender: TObject);
begin
  inherited;
  if TServiceUtil.QueryServiceStatusStr(SERVICE_NAME) = '未安装' then
  begin
    ShowMsg('请先安装服务');
  end
  else
  begin
    if not TServiceUtil.UnInstallServices(SERVICE_NAME) then
    begin
      ShowMsg('服务卸载失败');
    end;
  end;
end;

procedure TServiceControlForm.FormCreate(Sender: TObject);
begin
  inherited;
  SERVICE_NAME := 'CgtEtlSrv';
  ServiceConfig := TServiceConfig.Create(ExePath + 'config\service.ini');
  ServiceRunner := nil;
  LoadServiceConfig;

  tmrCheckServiceStatus.Enabled := True;
end;

procedure TServiceControlForm.FormDestroy(Sender: TObject);
begin
  inherited;
  TerminateTest;
  ServiceConfig.Free;
end;


procedure TServiceControlForm.LoadServiceConfig;
begin
  lblServiceStatusStr.Caption := TServiceUtil.QueryServiceStatusStr(SERVICE_NAME);
  btnJobsFile.Text := ServiceConfig.JobsFile;
  edtHandlerCount.Text := IntToStr(ServiceConfig.ThreadCount);
  cbbLogLevel.ItemIndex := Ord(ServiceConfig.LogLevel);
  mmoAllowedTime.Lines.DelimitedText := ServiceConfig.AllowedTimes;
  mmoDisallowedTime.Lines.DelimitedText := ServiceConfig.DisAllowedTimes;
end;

function TServiceControlForm.SaveServiceConfig: Boolean;
begin
  Result := False;
  if not FileExists(btnJobsFile.Text) then Exit;

  ServiceConfig.IniFile.WriteString('project', 'jobs', btnJobsFile.Text);
  ServiceConfig.IniFile.WriteInteger('project', 'handler_count', StrToIntDef(edtHandlerCount.Text, 1));
  ServiceConfig.IniFile.WriteInteger('log', 'log_level', cbbLogLevel.ItemIndex);
  ServiceConfig.IniFile.WriteString('project', 'allowed_times', mmoAllowedTime.Lines.DelimitedText);
  ServiceConfig.IniFile.WriteString('project', 'disallowed_times', mmoDisAllowedTime.Lines.DelimitedText);
  Result := True;
end;


procedure TServiceControlForm.tmrCheckServiceStatusTimer(Sender: TObject);
begin
  inherited;
  RefreshServiceStatus;
end;

procedure TServiceControlForm.RefreshServiceStatus;
begin
  if ServiceRunner <> nil then
  begin
    btnInstall.Enabled := False;
    Exit;
  end;

  lblServiceStatusStr.Caption := TServiceUtil.QueryServiceStatusStr(SERVICE_NAME);
  if lblServiceStatusStr.Caption = '已启动' then
  begin
    btnTestService.Enabled := False;
    btnInstall.Enabled := False;
    btnUnInstall.Enabled := False;
    btnStart.Enabled := False;
    btnStop.Enabled := True;
  end
  else if lblServiceStatusStr.Caption = '已停止' then
  begin
    btnTestService.Enabled := False;
    btnInstall.Enabled := False;
    btnUnInstall.Enabled := True;
    btnStart.Enabled := True;
    btnStop.Enabled := False;
  end
  else if lblServiceStatusStr.Caption = '未安装' then
  begin
    btnTestService.Enabled := True;
    btnInstall.Enabled := True;
    btnUnInstall.Enabled := False;
    btnStart.Enabled := False;
    btnStop.Enabled := False;
  end;
end;

end.
