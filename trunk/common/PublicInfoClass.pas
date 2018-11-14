{
  TPCharSubModuleInfo, TPCharModuleInfo, TPCharRunInfo中的信息结构不能变动,
  否则, 主程序无法实现对模块DLL的调用

    版权所有-----------Dony Zhang @ VeryView.com.cn
    2009-12-5                                                   }

unit PublicInfoClass;

interface

uses
  Contnrs, Vcl.Controls, Vcl.Graphics, IniFiles, Windows, Messages;

type
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

    //对外进行呈现的一些属性
    Name: PChar;
    Caption: PChar;
    Hint: PChar;
    ShowDlg: WordBool;     // 创建时是否以Dlg的模式显示，TODO: 将统一去掉，由子模块自行实现如何显示
    AllowMulti: WordBool;  // 是否同时允许多个子模块运行，一般在文档型应用子模块中
    InitBeforeCall: WordBool; // 每次调用前初始化标志
  end;

  {*****************************************************************************
  记录subModule信息, 用作Dll向主程序提供本子模块的参数时调用，该类
  是TPCharSubModuleParams记录结构的封装体，用于方便内存的管理，确保
  内存被完全释放
  *****************************************************************************}
  TPCharModuleStepInfo=class
  private
    FModuleStepRec: TPCharModuleStepRec;
  public
    constructor Create(aName,aCaption,aHint: PChar;
                        aShowDlg: WordBool=True; aAllowMulti: WordBool=False;
                        aInitBeforeCall: WordBool=True);
    property Name: PChar read FModuleStepRec.Name write FModuleStepRec.Name;
    property Caption: PChar read FModuleStepRec.Caption write FModuleStepRec.Caption;
    property Hint: PChar read FModuleStepRec.Hint write FModuleStepRec.Hint;
    property ShowDlg: WordBool read FModuleStepRec.ShowDlg write FModuleStepRec.ShowDlg;
    property AllowMulti: WordBool read FModuleStepRec.AllowMulti write FModuleStepRec.AllowMulti;
    property InitBeforeCall: WordBool read FModuleStepRec.InitBeforeCall write FModuleStepRec.InitBeforeCall;
  end;


  {*****************************************************************************
  记录Module信息, 用作Dll向主程序提供整个模块的参数时调用，它包括
  模块中的所有子模块的信息，是PCharSubModuleInfo的管理者
  *****************************************************************************}
  TPCharModuleInfo=class
  private
    FName: PChar;
    FCaption: PChar;
    FHint: PChar;
    FNo: Integer; // 排序号，用于模块之间的排序，可配置
    FModuleStepList: TObjectList;
    function getSubModuleCount: Byte;
    procedure setModuleStep(idx: Byte; const value: TPCharModuleStepInfo);
    function getModuleStep(idx: Byte): TPCharModuleStepInfo;
  public
    constructor Create; overload;
    constructor Create(aName, aCaption, aHint: PChar); overload;
    destructor Destroy; override;
    function Add(aPCharModuleStepInfo: TPCharModuleStepInfo): Integer;overload;
    function Add(aName,aCaption,aHint: PChar;
                        aShowDlg: WordBool=True; aAllowMulti: WordBool=True;
                        aInitBeforeCall: WordBool=True):Integer;overload;
    property Name: PChar read FName write FName;
    property Caption: PChar read FCaption write FCaption;
    property Hint: PChar read FHint write FHint;
    property ModuleStepCount: Byte read getSubModuleCount;
    property ModuleSteps: TObjectList read FModuleStepList write FModuleStepList;
    property ModuleStep[idx: Byte]: TPCharModuleStepInfo read getModuleStep
                               write setModuleStep;
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

    property ThemeStyle: Byte read FThemeStyle write FThemeStyle;
    property ConfigFile: TIniFile read FConfigFile write FConfigFile;
    property Debug: Integer read FDebug write FDebug;
  end;


var
  RunInfo: TRunInfo;

implementation

uses Vcl.Forms, SysUtils;

{ TPCharSubModuleInfo }

constructor TPCharModuleStepInfo.Create(
  aName, aCaption, aHint: PChar; aShowDlg, aAllowMulti,
  aInitBeforeCall: WordBool);
begin
  Name:=aName;
  Caption:=aCaption;
  Hint:=aHint;
  ShowDlg := aShowDlg;
  AllowMulti := aAllowMulti;
  InitBeforeCall := aInitBeforeCall;
end;


{ TPCharModuleInfo }

constructor TPCharModuleInfo.Create;
begin
  inherited Create;
  ModuleSteps:=TObjectList.Create;
end;

constructor TPCharModuleInfo.Create(aName, aCaption, aHint: PChar);
begin
  inherited Create;
  ModuleSteps:=TObjectList.Create;
  FName:=aName;
  FCaption:=aCaption;
  FHint:=aHint;
end;

destructor TPCharModuleInfo.Destroy;
begin
  ModuleSteps.Clear;
  ModuleSteps.Free;
  inherited;
end;

function TPCharModuleInfo.GetModuleStep(idx: Byte): TPCharModuleStepInfo;
begin
  Result:=TPCharModuleStepInfo(FModuleStepList[idx]);
end;

procedure TPCharModuleInfo.setModuleStep(idx: Byte;
  const value: TPCharModuleStepInfo);
begin
  FModuleStepList[idx]:=value;
end;

function TPCharModuleInfo.Add(aPCharModuleStepInfo: TPCharModuleStepInfo): Integer;
begin
  Result:=-1;
  if (aPCharModuleStepInfo<>nil) and (FModuleStepList.Count<255) then
  begin
    FModuleStepList.Add(aPCharModuleStepInfo);
    Result:=FModuleStepList.Count;
  end;
end;

function TPCharModuleInfo.Add(aName,
  aCaption, aHint: PChar; aShowDlg, aAllowMulti, aInitBeforeCall: WordBool): Integer;
var
  aPCharModuleStepInfo: TPCharModuleStepInfo;
begin
  aPCharModuleStepInfo:=TPCharModuleStepInfo.Create(aName,aCaption,aHint,
                         aShowDlg,aAllowMulti,aInitBeforeCall);
  Result:=Add(aPCharModuleStepInfo);
end;

function TPCharModuleInfo.getSubModuleCount: Byte;
begin
  Result:=FModuleStepList.Count;
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
