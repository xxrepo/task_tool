unit uProjectForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.ExtCtrls, RzPanel,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL,
  GridsEh, DBAxisGridsEh, DBGridEh, Vcl.StdCtrls, Vcl.Buttons,
  RzFilSys, Vcl.ComCtrls, RzTreeVw, RzShellCtrls, RzListVw, RzSplit, Vcl.Menus;

type
  TProjectForm = class(TBasicForm)
    rzpnl1: TRzPanel;
    dlgOpenProject: TOpenDialog;
    rzspltrFiles: TRzSplitter;
    rzshltrProject: TRzShellTree;
    lstFiles: TRzShellList;
    stat1: TStatusBar;
    pmProjectFile: TPopupMenu;
    AddTask: TMenuItem;
    DBMgrEdit: TMenuItem;
    JobMgrEdit: TMenuItem;
    lblProjectName: TLabel;
    dlgOpenTask: TOpenDialog;
    N1: TMenuItem;
    N2: TMenuItem;
    pmProjects: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    btnClearOld: TBitBtn;
    btnServiceControl: TBitBtn;
    GlobalVarSetting: TMenuItem;
    N6: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure lstFilesDblClickOpen(Sender: TObject; var Handled: Boolean);
    procedure DBMgrEditClick(Sender: TObject);
    procedure JobMgrEditClick(Sender: TObject);
    procedure AddTaskClick(Sender: TObject);
    procedure lstFilesFolderChanged(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure btnClearOldClick(Sender: TObject);
    procedure btnServiceControlClick(Sender: TObject);
    procedure GlobalVarSettingClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure RefreshProjectFiles;
    function CheckCurrentProject: Boolean;
    function MakeNewDirIn(AParantPath: string): string;
    procedure MakeDirAsProjectRoot(ADir: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProjectForm: TProjectForm;

implementation

uses uProject, uFileUtil, uDesignTimeDefines, uDefines, uDatabasesForm, uJobsForm,
uTaskEditForm, uFunctions, uMakeDirForm, System.IOUtils, System.JSON, System.Win.Registry,
uServiceControlForm, uGlobalVarSettingForm, uTaskVar, uGlobalVar;

{$R *.dfm}

procedure TProjectForm.btnClearOldClick(Sender: TObject);
var
  Reg: TRegistry;
  LSyncAutoStartExePath: string;
begin
  Reg:=TRegistry.Create(KEY_WRITE or KEY_READ);// or KEY_WOW64_64KEY);     //创建一个新键
  Reg.RootKey := HKEY_CURRENT_USER;     //将根键设置为HKEY_LOCAL_MACHINE
  Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true);//打开一个键
  //判断是否是开机自动启动，如果不是
  LSyncAutoStartExePath := Reg.ReadString('CGTSMSyncService');
  if Length(Trim(LSyncAutoStartExePath)) > 0 then
  begin
    if FileExists(LSyncAutoStartExePath) then
    begin
      //判断是否在运行，运行的话提示进行退出关闭
      if FindProcess(LSyncAutoStartExePath) then
      begin
        KillProcess(LSyncAutoStartExePath);
        ShowMsg(ExtractFileName(LSyncAutoStartExePath) + '正在运行，尝试关闭...');

        if FindProcess(LSyncAutoStartExePath) then
        begin
          ShowMsg('关闭程序失败，请从任务管理器执行关闭');
          //清楚对应的注册表项
          Reg.CloseKey;
          Reg.Free;
          Exit;
        end;
      end;

      //清除对应的文件夹
      TDirectory.Delete(ExtractFileDir(LSyncAutoStartExePath), True);
      if DirectoryExists(ExtractFileDir(LSyncAutoStartExePath)) then
      begin
        ShowMsg('程序文件删除失败：' + LSyncAutoStartExePath);
        Reg.CloseKey;
        Reg.Free;
        Exit;
      end;
    end;
    //清除对应的注册表项目
    Reg.DeleteValue('CGTSMSyncService');

    //清除对应的注册表项
    if Reg.ReadString('CGTSMSyncService') <> '' then
      ShowMsg('自动启动清除失败，请重新尝试或者手动清除')
    else
      ShowMsg('清除成功.');

  end
  else
  begin
    ShowMsg('旧版程序尚未安装，清除成功');
  end;

  Reg.CloseKey;
  Reg.Free;
end;

procedure TProjectForm.btnServiceControlClick(Sender: TObject);
begin
  inherited;
  with TServiceControlForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

function TProjectForm.CheckCurrentProject: Boolean;
begin
  Result := FileExists(CurrentProject.RootPath + 'project.json');
  if not Result then
  begin
    ShowMsg('请先创建或者打开项目文件');
  end;
end;

procedure TProjectForm.AddTaskClick(Sender: TObject);
var
  LTaskFileName: string;
begin
  inherited;
  if not CheckCurrentProject then Exit;

  dlgOpenTask.InitialDir := lstFiles.Folder.PathName;
  if dlgOpenTask.Execute then
  begin
    LTaskFileName := dlgOpenTask.FileName;
    if not FileExists(LTaskFileName) then
    begin
      if TFileUtil.CreateFile(LTaskFileName) = INVALID_HANDLE_VALUE then
      begin
        ShowMsg('任务文件创建失败');
        Exit;
      end;
    end;

    with TTaskEditForm.Create(nil) do
    try
      ConfigTask(LTaskFileName);
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TProjectForm.DBMgrEditClick(Sender: TObject);
begin
  inherited;
  if not CheckCurrentProject then Exit;

  with TDatabasesForm.Create(nil) do
  try
    ConfigDatabases(CurrentProject.DbsFile);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TProjectForm.FormCreate(Sender: TObject);
begin
  inherited;
  CurrentProject := TProject.Create;
  rzshltrProject.BaseFolder.PathName := ExePath + 'projects';
  RefreshProjectFiles;
end;

procedure TProjectForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(CurrentProject);
end;

procedure TProjectForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_ESCAPE) then
  begin
    if ShowMsg('确定要退出任务管理程序吗？', MB_OKCANCEL) = mrOk  then
      Self.Close;
  end;
end;

procedure TProjectForm.GlobalVarSettingClick(Sender: TObject);
begin
  inherited;
  if not CheckCurrentProject then Exit;

  with TGlobalVarSettingForm.Create(nil) do
  try
    ConfigGlobalVar(CurrentProject.RootPath + 'project.global');
    ShowModal;
  finally
    Free;
  end;
end;

procedure TProjectForm.JobMgrEditClick(Sender: TObject);
begin
  inherited;
  if not CheckCurrentProject then Exit;

  with TJobsForm.Create(nil) do
  try
    ConfigJobs(CurrentProject.JobsFile);
    WindowState := wsMaximized;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TProjectForm.lstFilesDblClickOpen(Sender: TObject;
  var Handled: Boolean);
var
  LExt: string;
begin
  inherited;
  Handled := True;
  LExt := ExtractFileExt(lstFiles.SelectedItem.PathName);
  if LExt = '.task' then
  begin
    //获取当前的文件
    with TTaskEditForm.Create(nil) do
    try
      ConfigTask(lstFiles.SelectedItem.PathName);
      ShowModal;
    finally
      Free;
    end;
  end
  else if LExt = '.jobs' then
  begin
    JobMgrEditClick(Sender);
  end
  else if LExt = '.dbs' then
  begin
    DBMgrEditClick(Sender);
  end
  else if LExt = '.global' then
    GlobalVarSettingClick(Sender)
  else
    Handled := False;
end;

procedure TProjectForm.lstFilesFolderChanged(Sender: TObject);
begin
  inherited;
  if FileExists(lstFiles.Folder.PathName + '\project.json') then
  begin
    CurrentProject.GetConfigFrom(lstFiles.Folder.PathName);
    RefreshProjectFiles;
  end;
end;


procedure TProjectForm.N2Click(Sender: TObject);
var
  LFolder: string;
begin
  inherited;
  LFolder := lstFiles.Folder.PathName;
  MakeDirAsProjectRoot(LFolder);
end;

procedure TProjectForm.N3Click(Sender: TObject);
var
  LDir: string;
begin
  inherited;
  LDir := MakeNewDirIn(ExePath + 'projects\');
  if LDir <> '' then
  begin
    MakeDirAsProjectRoot(LDir);
    lstFiles.Folder.PathName := LDir;
  end;
end;

procedure TProjectForm.N4Click(Sender: TObject);
begin
  inherited;
  if rzshltrProject.SelectedFolder.PathName <> '' then
  begin
    if ShowMsg('您确认要删除本项目吗？', MB_OKCANCEL) = mrOk then
    begin
      if ShowMsg('删除后无法找回本项目，您确认要继续删除吗？', MB_OKCANCEL) = mrOk then
        TFileUtil.DeleteDir(rzshltrProject.SelectedFolder.PathName);
    end;
  end;
end;

procedure TProjectForm.N5Click(Sender: TObject);
begin
  inherited;
  MakeNewDirIn(lstFiles.Folder.PathName + '\');
end;

procedure TProjectForm.RefreshProjectFiles;
begin
  //编辑相关类别的文件
  if System.SysUtils.DirectoryExists(CurrentProject.RootPath) then
  begin
    lblProjectName.Caption := '当前项目路径：' + CurrentProject.RootPath;
  end
  else
  begin
    lblProjectName.Caption := '当前项目：无打开项目';
  end;
end;


procedure TProjectForm.MakeDirAsProjectRoot(ADir: string);
begin
  if not FileExists(ADir + '\project.json') then
  begin
    if TFileUtil.CreateFile(ADir + '\project.json') <> INVALID_HANDLE_VALUE then
    begin
      CurrentProject.GetConfigFrom(ADir);
      RefreshProjectFiles;
    end;
  end;
end;


function TProjectForm.MakeNewDirIn(AParantPath: string): string;
begin
  Result := '';
  with TMakeDirForm.Create(nil) do
  try
    if ShowModal = mrOk then
    begin
      if Trim(edtFolderName.Text) <> '' then
      begin
        if TFileUtil.CreateDir(AParantPath + edtFolderName.Text) then
        begin
          Result := AParantPath + edtFolderName.Text;
        end;
      end;
    end;
  finally
    Free;
  end;
end;

end.
