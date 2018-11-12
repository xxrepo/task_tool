{
  TPCharSubModuleInfo, TPCharModuleInfo, TPCharRunInfo中的信息结构不能变动,
  否则, 主程序无法实现对模块DLL的调用

    版权所有-----------Dony Zhang @ VeryView.com.cn
    2009-12-5                                                   }

unit PublicInfoClass;

interface

uses
  Contnrs, Vcl.Controls, Vcl.Graphics, IniFiles, Windows, Messages, System.Classes, uFileLogger, System.SyncObjs;

type
  {*****************************************************************************
   1. 每个子模块创建时需要的参数，从该结构读取，这是主程序调用Dll中的
  子模块时向Dll传递的参数，采用记录结构是因为为了管理大规模的子模
  块时，能够在内存上保持一致，从而能够进行模块的快速定位；
   2. 子模块相当于主窗口中的一个Tab页；
   3. 子模块的属性定义相当于给主窗口中的Tab页进行属性的定义；
   ****************************************************************************}
  TPCharSubModuleRec = record
//    OwnerID: Cardinal;     // 附属主模块ID，主模块是左侧导航栏中的顶级栏
//    ID: Byte;              // 子模块在主模块中的ID，OwnerID + ID 在系统中唯一

    UniqueID: PChar;        // 用于真实确定当前Submodule，每个SubModule都有一个全局唯一的命名包

// 还需要给出这个module是step还是step的DesignForm

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
  TPCharSubModuleInfo=class
  private
    FSubModuleParams: TPCharSubModuleRec;
  public
    constructor Create(ASubModuleRec: TPCharSubModuleRec);
    property Name: PChar read FSubModuleParams.Name write FSubModuleParams.Name;
    property Caption: PChar read FSubModuleParams.Caption write FSubModuleParams.Caption;
    property Hint: PChar read FSubModuleParams.Hint write FSubModuleParams.Hint;
    property ShowDlg: WordBool read FSubModuleParams.ShowDlg write FSubModuleParams.ShowDlg;
    property AllowMulti: WordBool read FSubModuleParams.AllowMulti write FSubModuleParams.AllowMulti;
    property InitBeforeCall: WordBool read FSubModuleParams.InitBeforeCall write FSubModuleParams.InitBeforeCall;
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
    FID: Integer;
    //FNo: Integer; // 排序号，用于模块之间的排序，可配置
    FSubModuleList: TObjectList;
    function getSubModuleCount: Byte;
    procedure setSubModule(idx: Byte; const value: TPCharSubModuleInfo);
    function getSubModule(idx: Byte): TPCharSubModuleInfo;
  public
    constructor Create; overload;
    constructor Create(aID:Integer; aName, aCaption, aHint: PChar); overload;
    destructor Destroy; override;
    function Add(aPCharSubModuleInfo: TPCharSubModuleInfo): Integer;overload;
    function Add(ASubModuleRec: TPCharSubModuleRec):Integer;overload;
    property Name: PChar read FName write FName;
    property Caption: PChar read FCaption write FCaption;
    property Hint: PChar read FHint write FHint;
    property ID: Integer read FID write FID;
    property SubModuleCount: Byte read getSubModuleCount;
    property SubModules: TObjectList read FSubModuleList write FSubModuleList;
    property SubModule[idx: Byte]: TPCharSubModuleInfo read getSubModule
                               write setSubModule;
  end;


  {*****************************************************************************
  对跨dll模块的全局传参的类
  *****************************************************************************}
  TRunGlobalVar = class
    ExePath: PChar;
    FileLogger: TThreadFileLog;
    FileCritical: TCriticalSection;
  end;


  {*****************************************************************************
  保留全局变量，这些全局变量在整个程序中不发生改变或者很少发生改变
  *****************************************************************************}
  TRunInfo = class
  private
    //以下参数主要用来提供vcl中的消息循环，提供对dll中创建窗体的宿主
    FApplication: Integer;
    FMainScreen: Integer;
    FMainForm: Integer;
    FMainFormHandle: THandle;

    //其他全局变量，主要用于在exe和dll的任务派发之间进行处理
    //比如，数据库链接在不同dll的step中共享
    //比如，日志操作组件在不同dll之间的共享
    //比如，提供全局的院子级别的锁等等
    FRunGlobalVar: Integer;
  public
    constructor Create(aApplication, aMainScreen, aMainForm, aRunGlobalVar: Integer;
                       aMainFormHandle: THandle);
    //
    property Application:Integer read FApplication;
    property MainScreen:Integer read FMainScreen;
    property MainForm:Integer read FMainForm write FMainForm;
    property MainFormHandle:THandle read FMainFormHandle;

    property __RUN_GLOBAL: Integer read FRunGlobalVar;
  end;


var
  //Dll和主程序都要有的控制变量
  RunInfo: TRunInfo;

implementation

uses Vcl.Forms, SysUtils;

{ TPCharSubModuleInfo }

constructor TPCharSubModuleInfo.Create(ASubModuleRec: TPCharSubModuleRec);
begin
//  OwnerID:=ASubModuleRec.OwnerID;
//  ID:=ASubModuleRec.ID;
  Name:=ASubModuleRec.Name;
  Caption:=ASubModuleRec.Caption;
  Hint:=ASubModuleRec.Hint;
  ShowDlg := ASubModuleRec.ShowDlg;
  AllowMulti := ASubModuleRec.AllowMulti;
  InitBeforeCall := ASubModuleRec.InitBeforeCall;
end;


{ TPCharModuleInfo }

constructor TPCharModuleInfo.Create;
begin
  inherited Create;
  SubModules:=TObjectList.Create;
end;

constructor TPCharModuleInfo.Create(aID: Integer; aName, aCaption,
  aHint: PChar);
begin
  inherited Create;
  SubModules:=TObjectList.Create;
  FID:=aID;
  FName:=aName;
  FCaption:=aCaption;
  FHint:=aHint;
end;

destructor TPCharModuleInfo.Destroy;
begin
  SubModules.Clear;
  SubModules.Free;
  inherited;
end;

function TPCharModuleInfo.GetSubModule(idx: Byte): TPCharSubModuleInfo;
begin
  Result:=TPCharSubModuleInfo(FSubModuleList[idx]);
end;

procedure TPCharModuleInfo.setSubModule(idx: Byte;
  const value: TPCharSubModuleInfo);
begin
  FSubModuleList[idx]:=value;
end;

function TPCharModuleInfo.Add(aPCharSubModuleInfo: TPCharSubModuleInfo): Integer;
begin
  Result:=-1;
  if (aPCharSubModuleInfo<>nil) and (FSubModuleList.Count<255) then
  begin
    FSubModuleList.Add(aPCharSubModuleInfo);
    Result:=FSubModuleList.Count;
  end;
end;

function TPCharModuleInfo.Add(ASubModuleRec: TPCharSubModuleRec): Integer;
var
  aPCharSubModuleInfo: TPCharSubModuleInfo;
begin
  aPCharSubModuleInfo:=TPCharSubModuleInfo.Create(ASubModuleRec);
  Result:=Add(aPCharSubModuleInfo);
end;

function TPCharModuleInfo.getSubModuleCount: Byte;
begin
  Result:=FSubModuleList.Count;
end;



{ TRunInfo }

constructor TRunInfo.Create(aApplication, aMainScreen, aMainForm, aRunGlobalVar: Integer;
                       aMainFormHandle: THandle);
begin
  FApplication     := aApplication;
  FMainScreen      := aMainScreen;
  FMainForm        := aMainForm;
  FRunGlobalVar    := aRunGlobalVar;
end;

end.
