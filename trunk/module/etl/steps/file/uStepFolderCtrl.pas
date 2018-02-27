unit uStepFolderCtrl;

interface

uses
  uStepBasic, System.JSON;

type
  TCtrlType = (ctCreate, ctDelete, ctEmpty, ctMove, ctCopy);

  TStepFolderCtrl = class (TStepBasic)
  private
    FCtrlType: Integer;
    FFolder: string;
    FToFolder: string;
    FChildrenOnly: Boolean;

    FAbsFolder: string;
    FAbsToFolder: string;

    procedure ProcessChildrenOnly(AAbsPath, AAbsToPath: string; ACtrlType: TCtrlType);
    procedure OnFileCopy(AFileName: string);
    procedure OnFolderCopy(AFolderName: string; var ARecursive: Boolean);
    procedure OnFileMove(AFileName: string);
    procedure OnFolderMove(AFolderName: string; var ARecursive: Boolean);
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property CtrlType: Integer read FCtrlType write FCtrlType;
    property Folder: string read FFolder write FFolder;
    property ToFolder: string read FToFolder write FToFolder;
    property ChildrenOnly: Boolean read FChildrenOnly write FChildrenOnly;
  end;

implementation

uses
  uDefines, uFunctions, system.Classes, System.SysUtils, uExceptions, uStepDefines, uFileFinder,
  uFileUtil, Winapi.Windows;

{ TStepQuery }

procedure TStepFolderCtrl.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('ctrl_type', IntToStr(FCtrlType)));
  AToConfig.AddPair(TJSONPair.Create('folder', FFolder));
  AToConfig.AddPair(TJSONPair.Create('to_folder', FToFolder));
  AToConfig.AddPair(TJSONPair.Create('children_only', BoolToStr(FChildrenOnly)));
end;


procedure TStepFolderCtrl.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FCtrlType := GetJsonObjectValue(StepConfig.ConfigJson, 'ctrl_type', '-1', 'int');
  FFolder := GetJsonObjectValue(StepConfig.ConfigJson, 'folder');
  FToFolder := GetJsonObjectValue(StepConfig.ConfigJson, 'to_folder');
  FChildrenOnly := StrToBoolDef(GetJsonObjectValue(StepConfig.ConfigJson, 'children_only'), False);
end;


procedure TStepFolderCtrl.StartSelf;
var
  LCtrlType: TCtrlType;
begin
  try
    CheckTaskStatus;

    LCtrlType := TCtrlType(FCtrlType);
    FAbsFolder := GetRealAbsolutePath(FFolder);

    case LCtrlType of
      ctCreate:
      begin
        TFileUtil.CreateDir(FAbsFolder);
      end;
      ctDelete:
      begin
        TFileUtil.DeleteDir(FAbsFolder);
      end;
      ctEmpty:
      begin
        TFileUtil.DeleteDir(FAbsFolder);
        TFileUtil.CreateDir(FAbsFolder);
      end;
      ctMove:
      begin
        FAbsToFolder := GetRealAbsolutePath(FToFolder);
        if ChildrenOnly then
        begin
          ProcessChildrenOnly(FAbsFolder, FAbsToFolder, LCtrlType);
        end
        else
        begin
          DebugMsg('移动文件夹：' + FAbsFolder + ' => ' + FAbsToFolder);
          if TFileUtil.CopyDir(FAbsFolder, FAbsToFolder) then
            TFileUtil.DeleteDir(FAbsFolder);
        end;
      end;
      ctCopy:
      begin
        FAbsToFolder := GetRealAbsolutePath(FToFolder);
        if ChildrenOnly then
        begin
          ProcessChildrenOnly(FAbsFolder, FAbsToFolder, LCtrlType);
        end
        else
        begin
          DebugMsg('复制文件夹：' + FAbsFolder + ' => ' + FAbsToFolder);
          TFileUtil.CopyDir(FAbsFolder, FAbsToFolder);
        end;
      end;
    end;
  finally

  end;
end;



procedure TStepFolderCtrl.ProcessChildrenOnly(AAbsPath: string; AAbsToPath: string; ACtrlType: TCtrlType);
var
  LFileFinder: TVVFileFinder;
  LFolderName, LFileName: string;
begin
  LFileFinder := TVVFileFinder.Create;
  try
    LFileFinder.Dir := AAbsPath;
    LFileFinder.Recursive := False;
    if ACtrlType = ctCopy then
    begin
      LFileFinder.OnFileFound := OnFileCopy;
      LFileFinder.OnFolderFound := OnFolderCopy;
    end
    else if ACtrlType = ctMove then
    begin
      LFileFinder.OnFileFound := OnFileMove;
      LFileFinder.OnFolderFound := OnFolderMove;
    end;

    LFileFinder.Find;
  finally
    LFileFinder.Free;
  end;
end;

procedure TStepFolderCtrl.OnFileCopy(AFileName: string);
var
  LFileName: string;
begin
  LFileName := ExtractFileName(AFileName);
  DebugMsg('复制文件：' + AFileName + ' => ' + FAbsToFolder + LFileName);
  TFileUtil.CopyFile(AFileName, FAbsToFolder + LFileName);
end;

procedure TStepFolderCtrl.OnFolderCopy(AFolderName: string; var ARecursive: Boolean);
begin
  ARecursive := False;
  DebugMsg('复制文件夹：' + AFolderName + ' => ' + FAbsToFolder);
  TFileUtil.CopyDir(AFolderName, FAbsToFolder);
end;


procedure TStepFolderCtrl.OnFileMove(AFileName: string);
var
  LFileName: string;
begin
  LFileName := ExtractFileName(AFileName);
  DebugMsg('移动文件：' + AFileName + ' => ' + FAbsToFolder + LFileName);
  TFileUtil.CopyFile(AFileName, FAbsToFolder + LFileName);
  TFileUtil.DeleteFile(AFileName);
end;

procedure TStepFolderCtrl.OnFolderMove(AFolderName: string; var ARecursive: Boolean);
begin
  ARecursive := False;
  DebugMsg('移动文件夹：' + AFolderName + ' => ' + FAbsToFolder);
  TFileUtil.CopyDir(AFolderName, FAbsToFolder);
  TFileUtil.DeleteDir(AFolderName);
end;




initialization
System.Classes.RegisterClass(TStepFolderCtrl);

finalization
System.Classes.UnRegisterClass(TStepFolderCtrl);

end.
