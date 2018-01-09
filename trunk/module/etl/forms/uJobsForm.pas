unit uJobsForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, RzPanel, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Data.DB,
  Datasnap.DBClient, Vcl.Menus, uJob, Vcl.DBCtrls, Vcl.ComCtrls, RzListVw,
  RzShellCtrls, uDesignTimeDefines, RzSplit, uFileLogger;

type
  TJobsForm = class(TBasicForm)
    rzpnl1: TRzPanel;
    cdsJobs: TClientDataSet;
    dsJobs: TDataSource;
    pmJobs: TPopupMenu;
    AddJob: TMenuItem;
    DeleteTJob: TMenuItem;
    btnSave: TBitBtn;
    btnStartJob: TBitBtn;
    btnStartAll: TBitBtn;
    btnStopJob: TBitBtn;
    dbnvgrJobs: TDBNavigator;
    dlgOpenTaskFile: TOpenDialog;
    btnLoadJobs: TBitBtn;
    tmrJobsSchedule: TTimer;
    rzspltr2: TRzSplitter;
    rzspltr1: TRzSplitter;
    dbgrdhJobs: TDBGridEh;
    rzpnl2: TRzPanel;
    pnl1: TPanel;
    lstLogs: TRzShellList;
    redtLog: TRichEdit;
    rzpnl3: TRzPanel;
    btnClearLog: TBitBtn;
    btnEnableAll: TBitBtn;
    procedure DeleteTJobClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnStartJobClick(Sender: TObject);
    procedure btnStopJobClick(Sender: TObject);
    procedure cdsJobsPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure btnLoadJobsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrJobsScheduleTimer(Sender: TObject);
    procedure btnStartAllClick(Sender: TObject);

    procedure MSGLoggerHandler(var AMsg: TMessage); message VV_MSG_LOGGER;
    procedure btnClearLogClick(Sender: TObject);
    procedure dbgrdhJobsColumns3CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure dbgrdhJobsColumns2CellButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure dbgrdhJobsDblClick(Sender: TObject);
    procedure btnEnableAllClick(Sender: TObject);

  private
    { Private declarations }
    JobsFile: string;
    JobMgr: TJobMgr;

    procedure RefreshData;
    procedure SaveData;
    procedure SetRichEditLineColor(AEditor: TRichEdit; ALine: Integer;
      AColor: TColor);
  public
    procedure ConfigJobs(AJobsConfigFile: string);
  end;

var
  JobsForm: TJobsForm;

implementation

uses uDefines, uFunctions, uJobScheduleForm, uTaskEditForm, uFileUtil;

{$R *.dfm}


procedure TJobsForm.SetRichEditLineColor(AEditor: TRichEdit; ALine: Integer; AColor: TColor);
begin
  redtLog.SelStart := SendMessage(redtLog.Handle, EM_LINEINDEX, ALine, 0); // 选中这一行文字
  redtLog.SelLength := Length(redtLog.Lines.Strings[ALine]);
  redtLog.SelAttributes.Color := AColor; // 设为需要的字体大小
end;


procedure TJobsForm.MSGLoggerHandler(var AMsg: TMessage);
var
  LMsg: PChar;
  LLine: Integer;
begin
  LMsg := PChar(AMsg.WParam);
  //更新状态
  LLine := redtLog.Lines.Add(LMsg);

  if Pos('[WARN]', LMsg) > 0 then
  begin
    SetRichEditLineColor(redtLog, LLine, clWebOrangeRed);
  end
  else if (Pos('[ERROR]', LMsg) > 0) or (Pos('[FATAL]', LMsg) > 0)
          or (Pos('错误', LMsg) > 0) or (Pos('失败', LMsg) > 0)
          or (Pos('异常', LMsg) > 0)  then
  begin
    SetRichEditLineColor(redtLog, LLine, clWebRed);
  end
  else if Pos('[FORCE]', LMsg) > 0 then
  begin
    SetRichEditLineColor(redtLog, LLine, clWebGreen);
  end;
end;


procedure TJobsForm.btnClearLogClick(Sender: TObject);
begin
  inherited;
  redtLog.Lines.Clear;
end;

procedure TJobsForm.btnEnableAllClick(Sender: TObject);
var
  LStatus: Integer;
  i: Integer;
begin
  inherited;
  if btnEnableAll.Caption = '全部启用' then
  begin
    btnEnableAll.Caption := '全部禁用';
    LStatus := 1;
  end
  else
  begin
    btnEnableAll.Caption := '全部启用';
    LStatus := 0;
  end;

  for i := 1 to cdsJobs.RecordCount do
  begin
    cdsJobs.RecNo := i;
    cdsJobs.Edit;
    cdsJobs.FieldByName('status').AsInteger := LStatus;
    cdsJobs.Post;
  end;
end;

procedure TJobsForm.btnLoadJobsClick(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

procedure TJobsForm.btnSaveClick(Sender: TObject);
begin
  inherited;
  SaveData;
end;

procedure TJobsForm.btnStartAllClick(Sender: TObject);
begin
  inherited;
  if tmrJobsSchedule.Enabled then
  begin
    tmrJobsSchedule.Enabled := False;
    JobMgr.Stop;
    btnStartAll.Caption := '启动全部任务';
  end
  else
  begin
    tmrJobsSchedule.Enabled := True;
    btnStartAll.Caption := '停止全部任务';
  end;
end;

procedure TJobsForm.btnStartJobClick(Sender: TObject);
begin
  inherited;
  try
    if cdsJobs.RecordCount > 0 then
    begin
      JobMgr.StartJob(cdsJobs.FieldByName('job_name').AsString);
    end;
  finally

  end;
end;

procedure TJobsForm.btnStopJobClick(Sender: TObject);
begin
  inherited;
  JobMgr.StopJob(cdsJobs.FieldByName('job_name').AsString);
end;


procedure TJobsForm.cdsJobsPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  inherited;
  if (E as EDBClient).ErrorCode = 9729 then
  begin
    ShowMsg('已存在同名的工作任务');
  end;
  Action := daAbort;
end;


procedure TJobsForm.dbgrdhJobsColumns2CellButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
  inherited;
  dlgOpenTaskFile.InitialDir := CurrentProjectRec.RootPath;
  if dlgOpenTaskFile.Execute then
  begin
    if FileExists(dlgOpenTaskFile.FileName) then
    begin
      if cdsJobs.FieldByName('job_name').AsString = '' then
      begin
        cdsJobs.Append;
        cdsJobs.FieldByName('job_name').AsString := ChangeFileExt(ExtractFileName(dlgOpenTaskFile.FileName), '');
        cdsJobs.FieldByName('schedule').AsString := '';
        cdsJobs.FieldByName('status').AsInteger := 0;
        cdsJobs.FieldByName('sort_no').AsInteger := 0;
      end
      else
      begin
        cdsJobs.Edit;
      end;

      //修改为相对路径
      cdsJobs.FieldByName('task_file').AsString := TDesignUtil.GetRelativePathToProject(dlgOpenTaskFile.FileName);
    end;
  end;
  Handled := True;
end;

procedure TJobsForm.dbgrdhJobsColumns3CellButtons0Click(Sender: TObject;
  var Handled: Boolean);
begin
  inherited;
  with TJobScheduleForm.Create(nil) do
  try
    ParseConfig(cdsJobs.FieldByName('schedule').AsString);
    if ShowModal = mrOk then
    begin
      cdsJobs.Edit;
      cdsJobs.FieldByName('schedule').AsString := MakeConfigJsonStr;
      cdsJobs.Post;
    end;
  finally
    Free;
  end;
end;

procedure TJobsForm.dbgrdhJobsDblClick(Sender: TObject);
var
  LTaskFile: string;
begin
  inherited;
  //双击编辑
  if cdsJobs.RecordCount > 0 then
  begin
    //获取当前的文件
    LTaskFile := TFileUtil.GetAbsolutePathEx(CurrentProjectRec.RootPath, cdsJobs.FieldByName('task_file').AsString);
    if not FileExists(LTaskFile) then
    begin
      ShowMsg('任务文件不存在，请检查文件路径或者重新添加');
      Exit;
    end;

    with TTaskEditForm.Create(nil) do
    try
      ConfigTask(LTaskFile);
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TJobsForm.DeleteTJobClick(Sender: TObject);
begin
  inherited;
  if (not cdsJobs.Active) or (cdsJobs.RecordCount = 0) then Exit;
  
  if ShowMsg('您确定要删除当前任务吗？', MB_OKCANCEL) = mrOk then
  begin
    cdsJobs.Delete;
  end;
end;

procedure TJobsForm.ConfigJobs(AJobsConfigFile: string);
begin
  JobsFile := AJobsConfigFile;
  RefreshData;
end;

procedure TJobsForm.FormCreate(Sender: TObject);
begin
  inherited;
  AppLogger.NoticeHandle := Handle;
  JobMgr := TJobMgr.Create(CurrentProjectRec.JobsFile, 2);
  JobMgr.CallerHandle := Handle;
  lstLogs.Folder.PathName := CurrentProjectRec.RootPath + 'task_log\';
end;

procedure TJobsForm.FormDestroy(Sender: TObject);
begin
  AppLogger.NoticeHandle := 0;
  SaveData;
  JobMgr.Free;
end;

procedure TJobsForm.SaveData;
var
  LStringList: TStringList;
begin
  inherited;
  LStringList := TStringList.Create;
  try
    LStringList.Text := DataSetToJsonStr(cdsJobs);
    LStringList.SaveToFile(JobsFile);
  finally
    LStringList.Free;
  end;
end;

procedure TJobsForm.tmrJobsScheduleTimer(Sender: TObject);
begin
  inherited;
  try
    if cdsJobs.RecordCount > 0 then
    begin
      JobMgr.Start;
    end;
  finally

  end;
end;

procedure TJobsForm.RefreshData;
var
  LStringList: TStringList;
begin
  //从默认的jobs文件加载
  LStringList := TStringList.Create;
  try
    if FileExists(JobsFile) then
    begin
      if JobMgr.LoadConfigFrom(JobsFile) then
      begin
        cdsJobs.EmptyDataSet;
        LStringList.LoadFromFile(JobsFile);
        JsonToDataSet(LStringList.Text, cdsJobs);
      end
      else
        ShowMsg('项目工作列表配置文件加载失败');
    end;
  finally
    LStringList.Free;
  end;
end;

end.
