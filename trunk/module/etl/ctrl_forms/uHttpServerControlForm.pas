unit uHttpServerControlForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicLogForm, Vcl.StdCtrls,
  Vcl.Buttons, RzPanel, Vcl.ComCtrls, Vcl.ExtCtrls, RzSplit, Vcl.Mask, RzEdit, uHttpServerRunner,
  RzBtnEdt, uHttpServerConfig;

type
  THttpServerControlForm = class(TBasicLogForm)
    lbl1: TLabel;
    lblPort: TLabel;
    lblDocRoot: TLabel;
    lblMaxSession: TLabel;
    lbl3: TLabel;
    cbbLogLevel: TComboBox;
    lbl4: TLabel;
    mmoAllowedTime: TMemo;
    lbl5: TLabel;
    mmoDisallowedTime: TMemo;
    btnDocRoot: TRzButtonEdit;
    edtIP: TEdit;
    edtPort: TEdit;
    edtMaxConnection: TEdit;
    lbl2: TLabel;
    mmoAllowedAccessOrigins: TMemo;
    btnStart: TBitBtn;
    btnStop: TBitBtn;
    btnSave: TBitBtn;
    rzpnl1: TRzPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDocRootButtonClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FHttpServerConfigRec: THttpServerConfigRec;
    procedure CheckServerStatus;
  public
    { Public declarations }
  end;

var
  HttpServerControlForm: THttpServerControlForm;
  //单实例，需要在引用这种单独引入httpserverrunner单元
  HttpServerRunner: THttpServerRunner;

implementation

uses uDesignTimeDefines, uFileLogger, uSelectFolderForm, uFileUtil, uDefines;

{$R *.dfm}

procedure THttpServerControlForm.btnDocRootButtonClick(Sender: TObject);
begin
  inherited;
  with TSelectFolderForm.Create(nil) do
  try
    RootDir := ExePath;
    if ShowModal = mrOk then
    begin
       btnDocRoot.Text := TFileUtil.GetRelativePath(ExePath, SelectedPath);
    end;
  finally
    Free;
  end;
end;


procedure THttpServerControlForm.btnSaveClick(Sender: TObject);
begin
  inherited;
  FHttpServerConfigRec.IP := edtIP.Text;
  FHttpServerConfigRec.Port := StrToIntDef(edtPort.Text, 61288);
  FHttpServerConfigRec.DocRoot := btnDocRoot.Text;
  FHttpServerConfigRec.MaxConnection := StrToIntDef(edtMaxConnection.Text, 0);
  FHttpServerConfigRec.LogLevel := TLogLevel(cbbLogLevel.ItemIndex);
  FHttpServerConfigRec.AllowedAccessOrigins := mmoAllowedAccessOrigins.Lines.DelimitedText;
  FHttpServerConfigRec.AllowedTimes := mmoAllowedTime.Lines.DelimitedText;
  FHttpServerConfigRec.DisallowedTimes := mmoDisallowedTime.Lines.DelimitedText;

  THttpServerConfigUtil.WriteConfigTo(FHttpServerConfigRec, ExePath + 'config\local_server.ini');
end;


procedure THttpServerControlForm.btnStartClick(Sender: TObject);
begin
  inherited;
  btnSave.Click;
  if (HttpServerRunner = nil) then
  begin
    HttpServerRunner := THttpServerRunner.Create;
  end;
  if (not HttpServerRunner.Server.Active) then
  begin
    HttpServerRunner.LogNoticeHandle := Handle;
    HttpServerRunner.Start(FHttpServerConfigRec);
  end;
  CheckServerStatus;
end;


procedure THttpServerControlForm.btnStopClick(Sender: TObject);
begin
  inherited;
  if (HttpServerRunner <> nil) and (HttpServerRunner.Server.Active) then
  begin
    FreeAndNil(HttpServerRunner);
    CheckServerStatus;
  end;
end;


procedure THttpServerControlForm.FormCreate(Sender: TObject);
begin
  inherited;
  FHttpServerConfigRec := THttpServerConfigUtil.ReadConfigFrom(Exepath + 'config\local_server.ini');

  edtIP.Text := FHttpServerConfigRec.IP;
  edtPort.Text := IntToStr(FHttpServerConfigRec.Port);
  btnDocRoot.Text := FHttpServerConfigRec.DocRoot;
  edtMaxConnection.Text := IntToStr(FHttpServerConfigRec.MaxConnection);
  cbbLogLevel.ItemIndex := Ord(FHttpServerConfigRec.LogLevel);
  mmoAllowedTime.Lines.DelimitedText := FHttpServerConfigRec.AllowedTimes;
  mmoDisallowedTime.Lines.DelimitedText := FHttpServerConfigRec.DisallowedTimes;
  mmoAllowedAccessOrigins.Lines.DelimitedText := FHttpServerConfigRec.AllowedAccessOrigins;

  CheckServerStatus;

  AppLogger.NoticeHandle := Handle;
  if HttpServerRunner <> nil then
    HttpServerRunner.LogNoticeHandle := Handle;
end;


procedure THttpServerControlForm.FormDestroy(Sender: TObject);
begin
  inherited;
  if HttpServerRunner <> nil then
    HttpServerRunner.LogNoticeHandle := 0;
  AppLogger.NoticeHandle := 0;
end;

procedure THttpServerControlForm.CheckServerStatus;
begin
  if (HttpServerRunner <> nil) and (HttpServerRunner.Server.Active) then
  begin
    btnStop.Enabled := True;
    btnStart.Enabled := False;
  end
  else
  begin
    btnStart.Enabled := True;
    btnStop.Enabled := False;
  end;
end;

end.
