unit uStepFolderCtrl;

interface

uses
  uStepBasic, System.JSON;

type
  TStepFolderCtrl = class (TStepBasic)
  private
    FCtrlType: Integer;
    FFolder: string;
    FToFolder: string;
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property CtrlType: Integer read FCtrlType write FCtrlType;
    property Folder: string read FFolder write FFolder;
    property ToFolder: string read FToFolder write FToFolder;
  end;

implementation

uses
  uDefines, uFunctions, system.Classes, System.SysUtils, uExceptions, uStepDefines,
  uFileUtil;

type
  TCtrlType = (ctCreate, ctDelete, ctEmpty, ctMove, ctCopy);

{ TStepQuery }

procedure TStepFolderCtrl.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('ctrl_type', IntToStr(FCtrlType)));
  AToConfig.AddPair(TJSONPair.Create('folder', FFolder));
  AToConfig.AddPair(TJSONPair.Create('to_folder', FToFolder));
end;


procedure TStepFolderCtrl.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FCtrlType := GetJsonObjectValue(StepConfig.ConfigJson, 'ctrl_type', '-1', 'int');
  FFolder := GetJsonObjectValue(StepConfig.ConfigJson, 'folder');
  FToFolder := GetJsonObjectValue(StepConfig.ConfigJson, 'to_folder');
end;


procedure TStepFolderCtrl.StartSelf;
var
  LAbsFolder, LAbsToFolder: string;
  LCtrlType: TCtrlType;
begin
  try
    CheckTaskStatus;

    LCtrlType := TCtrlType(FCtrlType);
    LAbsFolder := GetRealAbsolutePath(FFolder);

    case LCtrlType of
      ctCreate:
      begin
        TFileUtil.CreateDir(LAbsFolder);
      end;
      ctDelete:
      begin
        TFileUtil.DeleteDir(LAbsFolder);
      end;
      ctEmpty:
      begin
        TFileUtil.DeleteDir(LAbsFolder);
        TFileUtil.CreateDir(LAbsFolder);
      end;
      ctMove:
      begin
        LAbsToFolder := GetRealAbsolutePath(FToFolder);
        if TFileUtil.CopyDir(LAbsFolder, LAbsToFolder) then
          TFileUtil.DeleteDir(LAbsFolder);
      end;
      ctCopy:
      begin
        LAbsToFolder := GetRealAbsolutePath(FToFolder);
        TFileUtil.CopyDir(LAbsFolder, LAbsToFolder);
      end;
    end;
  finally

  end;
end;


initialization
System.Classes.RegisterClass(TStepFolderCtrl);

finalization
System.Classes.UnRegisterClass(TStepFolderCtrl);

end.
