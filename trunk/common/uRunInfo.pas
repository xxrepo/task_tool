{
  TPCharSubModuleInfo, TPCharModuleInfo, TPCharRunInfo中的信息结构不能变动,
  否则, 主程序无法实现对模块DLL的调用，本文件主要用于穿透，在exe和dll，以及dll之间
  进行数据的传递

    版权所有-----------Dony Zhang @ VeryView.com.cn
    2009-12-5                                                   }

unit uRunInfo;

interface

uses
  Contnrs, Vcl.Controls, Vcl.Graphics, IniFiles, Windows, Messages;

type
  TModuleStepRec = record
    DllNameSpace: string;

    StepId: Integer;
    StepName: string;

    Caption: string;
    Hint: string;
    StepClassName: string;
    StepDesignFormClassName: string;
  end;

  {*****************************************************************************
   1. 每个子模块创建时需要的参数，从该结构读取，这是主程序调用Dll中的
  子模块时向Dll传递的参数，采用记录结构是因为为了管理大规模的子模
  块时，能够在内存上保持一致，从而能够进行模块的快速定位；
   2. 子模块相当于主窗口中的一个Tab页；
   3. 子模块的属性定义相当于给主窗口中的Tab页进行属性的定义；
   ****************************************************************************}
  TPCharModuleStepRec = record
    //对于Step的结构的描述
    StepId: Integer;
    StepName: PChar;

    //对外进行呈现的一些属性
    Caption: PChar;
    Hint: PChar;
    StepClassName: PChar;
    StepDesignFormClassName: PChar;
  end;



  {*****************************************************************************
  保留全局变量，这些全局变量在整个程序中不发生改变或者很少发生改变
  *****************************************************************************}
  TRunInfo = class
  private
    FApplication: Integer;
    FMainScreen: Integer;
    FMainForm: Integer;
    FMainFormHandle: THandle;


    //执行任务相关
    FExePath: PChar;
    FAppLogger: Integer;
    FFileCritical: Integer;
    FStepMgr: Integer;
    FCurrentProject: Integer;
  public
    constructor Create(aApplication, aMainScreen, aMainForm: Integer; aMainFormHandle: THandle);
    destructor Destroy; override;


    procedure SetApplication(AApplication: Integer);
    procedure SetMainScreen(aMainScreen: Integer);
    procedure SetMainForm(aMainForm: Integer);
    procedure SetMainformHandle(aMainFormHandle: Integer);

    procedure SetExePath(AExePath: PChar);
    procedure SetStepMgr(AStepMgr: Integer);
    procedure SetAppLogger(AAppLogger: Integer);
    procedure SetFileCritical(AFileCritical: Integer);
    procedure SetCurrentProject(ACurrentProject: Integer);


    property Application:Integer read FApplication;
    property MainScreen:Integer read FMainScreen;
    property MainForm:Integer read FMainForm;
    property MainFormHandle:THandle read FMainFormHandle;

    //uDefines
    property ExePath: PChar read FExePath;
    property StepMgr: Integer read FStepMgr;
    property AppLogger: Integer read FAppLogger;
    property FileCritical: Integer read FFileCritical;

    //uDesignTimeDefines
    property CurrentProject: Integer read FCurrentProject;

  end;


  //几个公用的用于在内部的结构和外部的传参结构之间的数据格式的转换
  function PCharStepRecToStepRec(ADllNameSpace: PChar; APCharStepRec: TPCharModuleStepRec): TModuleStepRec;
  function StepRecToPCharStepRec(AStepRec: TModuleStepRec): TPCharModuleStepRec;

var
  RunInfo: TRunInfo;

implementation

uses Vcl.Forms, SysUtils;

function PCharStepRecToStepRec(ADllNameSpace: PChar; APCharStepRec: TPCharModuleStepRec): TModuleStepRec;
begin
  Result.DllNameSpace := ADllNameSpace;
  Result.StepId := APCharStepRec.StepId;
  Result.StepName := APCharStepRec.StepName;
  Result.Caption := APCharStepRec.Caption;
  Result.StepClassName := APCharStepRec.StepClassName;
  Result.StepDesignFormClassName := APCharStepRec.StepDesignFormClassName;
end;


function StepRecToPCharStepRec(AStepRec: TModuleStepRec): TPCharModuleStepRec;
begin
  Result.StepId := AStepRec.StepId;
  Result.StepName := PChar(AStepRec.StepName);
  Result.Caption := PChar(AStepRec.Caption);
  Result.StepClassName := PChar(AStepRec.StepClassName);
  Result.StepDesignFormClassName := PChar(AStepRec.StepDesignFormClassName);
end;



{ TRunInfo }

constructor TRunInfo.Create(aApplication, aMainScreen, aMainForm: Integer; aMainFormHandle: THandle);
begin
  FApplication     := aApplication;
  FMainScreen      := aMainScreen;
  FMainForm        := aMainForm;
  FMainFormHandle  := aMainFormHandle;
end;


destructor TRunInfo.Destroy;
begin
  inherited;
end;

procedure TRunInfo.SetApplication(AApplication: Integer);
begin
  if FApplication = 0 then
    FApplication := AApplication;
end;

procedure TRunInfo.SetAppLogger(AAppLogger: Integer);
begin
  if FAppLogger = 0 then
    FAppLogger := AAppLogger;
end;

procedure TRunInfo.SetCurrentProject(ACurrentProject: Integer);
begin
  if FCurrentProject = 0 then
    FCurrentProject := ACurrentProject;
end;

procedure TRunInfo.SetExePath(AExePath: PChar);
begin
  if not Assigned(AExePath) then
    FExePath := AExePath;
end;

procedure TRunInfo.SetFileCritical(AFileCritical: Integer);
begin
  if FFileCritical = 0 then
    FFileCritical := AFileCritical;
end;

procedure TRunInfo.SetMainForm(aMainForm: Integer);
begin
  if FMainForm = 0 then
    FMainForm := aMainForm;
end;

procedure TRunInfo.SetMainformHandle(aMainFormHandle: Integer);
begin
  if FMainFormHandle = 0 then
    FMainFormHandle := aMainFormHandle;
end;

procedure TRunInfo.SetMainScreen(aMainScreen: Integer);
begin
  if FMainScreen = 0 then
    FMainScreen := aMainScreen;
end;

procedure TRunInfo.SetStepMgr(AStepMgr: Integer);
begin
  if FStepMgr = 0 then
    FStepMgr := AStepMgr;
end;

end.
