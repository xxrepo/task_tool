unit donix.job.uDesignTimeDefines;

interface

uses  uDbConMgr, uStepDefines, uProject, uFileUtil, uTask, Winapi.Windows, Winapi.Messages;


type

  TDesignUtil = class
  public
    class function GetRelativePathToProject(ARealPath: string): string;
    class function GetRealAbsolutePath(ARelativePath: string): string;
  end;


  function ShowMsg(AMsg: string; AButtons: Cardinal = MB_OK; ATitle: string = '温馨提示：'): Cardinal;



var
  CurrentProject: TProject;


implementation

uses Vcl.Forms;

function ShowMsg(AMsg: string; AButtons: Cardinal = MB_OK; ATitle: string = '温馨提示：'): Cardinal;
begin
  //如果是在非窗体程序中，本程序进行log记录
  Result := MessageBox(Application.Handle, PChar(AMsg), PChar(ATitle), MB_ICONINFORMATION + AButtons + MB_DEFBUTTON2);
end;

{ TDesignUtil }

class function TDesignUtil.GetRealAbsolutePath(ARelativePath: string): string;
begin
  Result := TFileUtil.GetAbsolutePathEx(CurrentProject.RootPath, ARelativePath);
end;

class function TDesignUtil.GetRelativePathToProject(ARealPath: string): string;
begin
  Result := TFileUtil.GetRelativePath(CurrentProject.RootPath, ARealPath);
end;

end.
