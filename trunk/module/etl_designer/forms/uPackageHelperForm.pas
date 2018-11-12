unit uPackageHelperForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.StdCtrls, Vcl.Buttons;

type
  TPackageHelperForm = class(TBasicForm)
    btnCleanLog: TBitBtn;
    btnRenameInit: TBitBtn;
    procedure btnCleanLogClick(Sender: TObject);
    procedure btnRenameInitClick(Sender: TObject);
  private
    procedure OnLogFolderFound(AFolderName: string; var ARecursive: Boolean; AFinder: TObject);
    procedure OnInitFileFound(AFileName: string; AFinder: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PackageHelperForm: TPackageHelperForm;

implementation

uses uFileFinder, uDefines, uFileUtil;

{$R *.dfm}

procedure TPackageHelperForm.OnInitFileFound(AFileName: string; AFinder: TObject);
var
  LToFileName, LFileName: string;
begin
  //判断文件夹是否为global或者dbs，如果是，则分别处理相应的文件，并且清空参数，
  //同时重命名，仅仅保留key fields
  LFileName := ExtractFileName(AFileName);
  LToFileName := AFileName + '.init';
  if LFileName = 'project.global' then
  begin
    //全局参数根据json字段的属性进行处理，无默认值的全清空，否则需要设置默认值
    TFileUtil.DeleteFile(LToFileName);
    TFileUtil.RenameFile(AFileName, LToFileName);
  end
  else if LFileName = 'project.dbs' then
  begin
    //数据库全清空
    TFileUtil.DeleteFile(LToFileName);
    TFileUtil.RenameFile(AFileName, LToFileName);
  end;
end;

procedure TPackageHelperForm.btnRenameInitClick(Sender: TObject);
var
  LFileFinder: TVVFileFinder;
begin
  inherited;
  LFileFinder := TVVFileFinder.Create;
  try
    LFileFinder.Dir := ExePath;
    LFileFinder.Recursive := True;
    LFileFinder.OnFileFound := OnInitFileFound;
    LFileFinder.Find;
  finally
    LFileFinder.Free;
  end;
end;




procedure TPackageHelperForm.OnLogFolderFound(AFolderName: string; var ARecursive: Boolean; AFinder: TObject);
var
  LDirName: string;
begin
  LDirName := TVVFileFinder(AFinder).CurrentName;
  //判断文件夹是否为log或者task_log，如果是，则直接进行清空文件夹即可
  if (LDirName = 'log') or (LDirName = 'task_log') then
  begin
    ARecursive := False;
    TFileUtil.DeleteDir(AFolderName);
    TFileUtil.CreateDir(AFolderName);
  end;
end;

procedure TPackageHelperForm.btnCleanLogClick(Sender: TObject);
var
  LFileFinder: TVVFileFinder;
begin
  inherited;
  LFileFinder := TVVFileFinder.Create;
  try
    LFileFinder.Dir := ExePath;
    LFileFinder.Recursive := True;
    LFileFinder.OnFolderFound := OnLogFolderFound;
    LFileFinder.Find;
  finally
    LFileFinder.Free;
  end;

end;

end.
