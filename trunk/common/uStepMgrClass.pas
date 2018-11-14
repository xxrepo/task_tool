{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN unit_LIBRARY ON}
{$WARN unit_PLATFORM ON}
{$WARN unit_DEPRECATED ON}
{$WARN unit_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_unitSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN unit_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN unit_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR OFF}
{$WARN CVT_WIDENING_STRING_LOST OFF}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{Modules, ModuleSteps按照序列直接管理；
 Module[ModuleID], ModuleStep[FullID]按照模块ID进行管理}

unit uStepMgrClass;

interface

uses
  uRunInfo, Contnrs, Classes, System.JSON, uStepBasic, uStepBasicForm;

type
  TRunDllInfo = class
  private
    FStepEntryPointer: Pointer;
    FStepDesignFormEntryPointer: Pointer;
    function GetStepDesignFormEntryPointer: Pointer;
    function GetStepEntryPointer: Pointer;
  public
    FilePath: string;
    DllName: string;
    DllNameSpace: string;

    DllHandle: THandle;
    constructor Create;
    destructor Destroy; override;

    function GetStep(AStepRec: TModuleStepRec): TStepBasic;
    function GetStepDesignForm(AStepRec: TModuleStepRec): TStepBasicForm;
  end;

  //每个step有自己所在的namespace，从而对不同的namespace的库进行有效的区分
  TStepMgr = class
  private
    FModuleSteps: TJSONObject;

    FRunDllList: TStringList;

    function AddRunDll(ANameSpace: string): Integer;
    function RemoveRunDll(ANameSpace): Boolean;
    function GetRunDll(ANameSpace: string): TRunDllInfo;
    function ClearRunDll: Boolean;
  public 
    constructor Create;
    destructor Destroy; override;

    //获取设计阶段的所有step，如果moduleSteps为空，则需要扫描所有的注册的dll
    function GetDesigningSteps: string;

    function GetStep(AStepRec: TModuleStepRec): string;

    function GetStepDesignForm(AStepRec: TModuleStepRec): string;

    //注册所有的steps，其实仅仅是提供了对外部设计阶段进行step的提供，表明设计阶段提供了哪些dll
    //那么，一个project依赖哪些namespace/dll也就需要在project对应的文件中进行描述说明；同样，
    //一个task在加入一个新的step后，step所对应的namespace也需要在task描述文件中进行处理，从task删除后
    //也需要进一步进行扫描。也就是说，一个task要对内部所有引入的step进行清晰的描述，这个描述机制是采用
    //数组的形式实现的；同样，一个project里面的需要引入的namespace，是来自对 project中各个task中引入的
    //namespace的一个集合。project并不明确保存namespace，但是在设计工具中可以通过对task的分析，来实现
    //对所以来的namespace的处理。而且可以很方便的看到，每个namespace被哪些task所使用

    //dll通过加载把所有的Step注入到运行环境中；在设计就通过这里向外提供所有可以使用的step，在运行阶段，
    //其实并没有实际意义，因为在系统运行时，通过task脚本中的fullId，或者直接每个Step对应的namespace，
    //namespace alias等，通过namespace直接关联到对应的dll文件，然后直接调用对应的step或者stepform即可，
    {*
    由dll自身内部对step结构的stepId进行应答输出即可，也就是运行指定的代码，因此，唯一的dll进行注册，
    实际上只需要注册namespace，运行阶段根本就不需要step的注册信息的参与
    因此，还可以进一步进行优化，就是dll在设计阶段都附带了一个同名的abc.dll.config，这个文件用于对其
    内部的step进行说明，由主程序进行构造处理；更进一步，甚至designForm都可以从运行时的dll中进行剥离，
    从而使得每个运行时的包更小，代码也并不进行泄露到客户。那么，每个Dll独立成为一个包，这个包包含运行时、
    设计时、配置这几个部分。主程序负责对每个dll进行加载。设计时的加载还需要设计时、配置这两个部分。
    打包发布时，只需要加载发布时的dll即可。当然，也可以通过编译指令，编译不同版本的dll，简化对文件的管理。
    因此，目前至少可以通过两个文件，一个文件是来自abc.dll.config（包含：namespace, steps等配置），
    另一个文件这是来自abc.dll。主程序通过注册过来的abc.dll.config加载对应的模块。运行程序则是直接只对
    abc.dll对应的命名空间进行注册即可。程序运行时，发现了对应命名空间的Step，则直接把相应的step的配置信息
    发送给对应的dll处理即可。运行程序并不会对step做过多的干涉处理。
    主程序可以扫描所有注册过来的abc.dll.config；设计时，获取对应的step参数，然后交由dll处理；
    运行程序可以根据项目依赖情况，根据运行程序的配置情况加载对应的dll，然后在解析task时，遇到对应的step，
    则把step参数传给对应的dll处理；
    程序
    *}
  end;


implementation

uses
  Windows, SysUtils, uRunInfo;


{ TRunDllInfo }

constructor TRunDllInfo.Create;
begin
  FStepEntryPointer := nil;
  FStepDesignFormEntryPointer := nil;
end;

destructor TRunDllInfo.Destroy;
begin
  if DllHandle <> 0 then
  begin
    FreeLibrary(DllHandle);
  end;
  inherited;
end;


function TRunDllInfo.GetStep(AStepRec: TModuleStepRec): TStepBasic;
type
  TGetStepFunc = function (ARunInfo: TRunInfo; APCharModuleStepRec: TPCharModuleStepRec): TStepBasic; stdcall;
var
  LEntryPointer: Pointer;
begin
  //发起实际的调用
  Result := nil;
  LEntryPointer := GetStepEntryPointer;
  if LEntryPointer = nil then Exit;

  Result := TGetStepFunc(LEntryPointer)(RunInfo, );
end;

function TRunDllInfo.GetStepDesignForm(AStepRec: TModuleStepRec): TStepBasicForm;
type
  TGetStepDesignFormFunc = function (ARunInfo: TRunInfo; APCharModuleStepRec: TPCharModuleStepRec): TStepBasic; stdcall;
var
  LEntryPointer: Pointer;
begin
  //发起实际的调用
  Result := nil;
  LEntryPointer := GetStepDesignFormEntryPointer;
  if LEntryPointer = nil then Exit;

  Result := TGetStepDesignFormFunc(LEntryPointer)(RunInfo, );
end;

function TRunDllInfo.GetStepDesignFormEntryPointer: Pointer;
begin
  if FStepDesignFormEntryPointer = nil then
  begin
    FStepDesignFormEntryPointer := GetProcAddress(DllHandle, 'ModuleStepDesignForm');
  end;
  Result := FStepDesignFormEntryPointer;
end;

function TRunDllInfo.GetStepEntryPointer: Pointer;
begin
  if FStepEntryPointer = nil then
  begin
    FStepEntryPointer := GetProcAddress(DllHandle, 'ModuleStep');
  end;
  Result := FStepEntryPointer;
end;

{ TStepMgr }

function TStepMgr.AddRunDll(ANameSpace: string): Integer;
begin
  Result := FRunDllList.IndexOfName(ANameSpace);
  //查看是否存在了ANameSpace，如果存在，则会直接返回
  if Result = -1 then
  begin
    //查找ANameSpace具体指向的dll文件

    //文件不存在，则默认为当前路径 + steps/ + namespace.dll

    //加载dll

  end;

end;

function TStepMgr.RemoveRunDll(ANameSpace): Boolean;
var
  idx: Integer;
  LRunDllObj: TObject;
begin
  Result := False;
  idx := FRunDllList.IndexOfName(ANameSpace);
  if idx = -1 then Result := True;

  LRunDllObj := FRunDllList.Objects[idx];
  if LRunDllObj <> nil then
  begin
    TRunDllInfo(LRunDllObj).Free;
  end;
  FRunDllList.Delete(idx);
end;


function TStepMgr.ClearRunDll: Boolean;
var
  idx: Integer;
  LRunDllObj: TObject;
begin
  for idx := FRunDllList.Count - 1 downto 0 do
  begin
    LRunDllObj := TRunDllInfo(FRunDllList.Objects[idx]);
    if LRunDllObj <> nil then
    begin
      LRunDllObj.Free;
    end;
    FRunDllList.Delete(idx);
  end;
end;

function TStepMgr.GetRunDll(ANameSpace: string): TRunDllInfo;
var
  idx: Integer;
begin
  Result := nil;
  idx := FRunDllList.IndexOfName(ANameSpace);
  if idx = -1 then
  begin
    idx := AddRunDll(ANameSpace);
  end;
  if idx = -1 then Exit;

  Result := TRunDllInfo(FRunDllList.Objects[idx]);
end;

constructor TStepMgr.Create;
begin
  FRunDllList := TStringList.Create(False);
end;

destructor TStepMgr.Destroy;
begin
  if FModuleSteps <> nil then
    FModuleSteps.Free;
  ClearRunDll;
  FRunDllList.Free;
  inherited;
end;


{*
本方法在设计阶段执行
*}
function TStepMgr.GetDesigningSteps: string;
begin
  if FModuleSteps = nil then
  begin
    FModuleSteps := TJSONObject.Create;
    //依次遍历所有的dll

  end;
  Result := FModuleSteps.ToJSON;
end;

{*
本方法在设计阶段执行
*}
function TStepMgr.GetStepDesignForm(AStepRec: TModuleStepRec): TStepBasicForm;
var
  LRunDllInfo: TRunDllInfo;
begin
  Result := nil;
  //获取step对应的dll入口
  LRunDllInfo := GetRunDll(AStepRec.DllNameSpace);
  if LRunDllInfo = nil then Exit;

  //由dll返回对应的指针地址对象
  Result := LRunDllInfo.GetStepDesignForm(AStepRec);
end;

{*
本方法在设计阶段和运行阶段均会执行
*}
function TStepMgr.GetStep(AStepRec: TModuleStepRec): TStepBasic;
var
  LRunDllInfo: TRunDllInfo;
begin
  Result := nil;
  //获取step对应的dll入口
  LRunDllInfo := GetRunDll(AStepRec.DllNameSpace);
  if LRunDllInfo = nil then Exit;

  //由dll返回对应的指针地址对象
  Result := LRunDllInfo.GetStep(AStepRec);
end;

end.

