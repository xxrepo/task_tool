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
    FStepMgr: Integer;


    FThemeStyle: Byte;
    FConfigFile: TiniFile;
    FDebug: Integer;  // 存储VVDebug
  public
    constructor Create(aApplication, aMainScreen, aMainForm: Integer; aMainFormHandle: THandle);
    destructor Destroy; override;
    property Application:Integer read FApplication;
    property MainScreen:Integer read FMainScreen;
    property MainForm:Integer read FMainForm write FMainForm;
    property MainFormHandle:THandle read FMainFormHandle;

    property StepMgr: Integer read FStepMgr;

    property ThemeStyle: Byte read FThemeStyle write FThemeStyle;
    property ConfigFile: TIniFile read FConfigFile write FConfigFile;
    property Debug: Integer read FDebug write FDebug;
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
end;


function StepRecToPCharStepRec(AStepRec: TModuleStepRec): TPCharModuleStepRec;
begin
  Result.StepId := AStepRec.StepId;
  Result.StepName := PChar(AStepRec.StepName);
  Result.Caption := PChar(AStepRec.Caption);
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

end.
