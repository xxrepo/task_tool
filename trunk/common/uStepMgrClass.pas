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
  uRunInfo, Contnrs, Classes, System.JSON, uStepBasic, uStepBasicForm, uStepDefines;

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

    function GetStep(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasic;
    function GetStepDesignForm(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasicForm;
  end;

  //每个step有自己所在的namespace，从而对不同的namespace的库进行有效的区分
  TStepMgr = class
  private
    FModuleSteps: TJSONArray;

    FRunDllList: TStringList;

    function AddRunDll(ANameSpace: string): Integer;
    function RemoveRunDll(ANameSpace: string): Boolean;
    function GetRunDll(ANameSpace: string): TRunDllInfo;
    function ClearRunDll: Boolean;
    procedure LoadModuleDlls(aFilePath: string);
    procedure LoadModules(const aFilePath, aDllName: string);
    function StepTypeToStepRec(AStepType: string): TModuleStepRec;
  public 
    constructor Create;
    destructor Destroy; override;

    //获取设计阶段的所有step，如果moduleSteps为空，则需要扫描所有的注册的dll
    function GetDesigningSteps: string;
    function GetStepDefine(AStepType: string): TStepDefine;

    function GetStep(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasic; overload;
    function GetStep(AStepType: string; ATaskVar: TObject): TStepBasic; overload;

    function GetStepDesignForm(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasicForm; overload;
    function GetStepDesignForm(AStepType: string; ATaskVar: TObject): TStepBasicForm; overload;

  end;


implementation

uses
  Windows, SysUtils, uDefines, uFunctions;


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


function TRunDllInfo.GetStep(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasic;
type
  TGetStepFunc = function (ARunInfo: TRunInfo; APCharModuleStepRec: TPCharModuleStepRec; ATaskVar: TObject): TStepBasic; stdcall;
var
  LEntryPointer: Pointer;
begin
  //发起实际的调用
  Result := nil;
  LEntryPointer := GetStepEntryPointer;
  if LEntryPointer = nil then Exit;



  Result := TGetStepFunc(LEntryPointer)(RunInfo, StepRecToPCharStepRec(AStepRec), ATaskVar);
end;

function TRunDllInfo.GetStepDesignForm(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasicForm;
type
  TGetStepDesignFormFunc = function (ARunInfo: TRunInfo; APCharModuleStepRec: TPCharModuleStepRec; ATaskVar: TObject): TStepBasicForm; stdcall;
var
  LEntryPointer: Pointer;
begin
  //发起实际的调用
  Result := nil;
  LEntryPointer := GetStepDesignFormEntryPointer;
  if LEntryPointer = nil then Exit;

  Result := TGetStepDesignFormFunc(LEntryPointer)(RunInfo, StepRecToPCharStepRec(AStepRec), ATaskVar);
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
var
  LRunDllInfo: TRunDllInfo;
  LDllFilePath, LDllName, LFullFileName: string;
begin
  Result := FRunDllList.IndexOfName(ANameSpace);

  //查看是否存在了ANameSpace，如果存在，则会直接返回
  if Result = -1 then
  begin
    //查找ANameSpace具体指向的dll文件
    LDllName := 'steps_' + ANameSpace + '.dll';
    LDllFilePath := ExePath + 'steps/';
    LFullFileName := LDllFilePath + LDllName;
    if not FileExists(LFullFileName) then Exit;

    //加载dll
    LRunDllInfo := TRunDllInfo.Create;
    LRunDllInfo.DllHandle := LoadLibrary(PChar(LFullFileName));
    if LRunDllInfo.DllHandle < 0 then
    begin
      LRunDllInfo.Free;
      Exit;
    end;

    LRunDllInfo.FilePath := LDllFilePath;
    LRunDllInfo.DllName := LDllName;
    LRunDllInfo.DllNameSpace := ANameSpace;

    Result := FRunDllList.AddObject(ANameSpace, LRunDllInfo);
  end;
end;

function TStepMgr.RemoveRunDll(ANameSpace: string): Boolean;
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
  FModuleSteps := nil;
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
  Result := '';
  if FModuleSteps = nil then
  begin
    //FModuleSteps := TJSONObject.Create;
    //依次遍历所有的dll
    LoadModuleDlls(ExePath + 'steps\');
  end;
  if FModuleSteps is TJSONArray  then
    Result := FModuleSteps.ToJSON;
end;


{*
本方法在设计阶段执行
*}
function TStepMgr.GetStepDesignForm(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasicForm;
var
  LRunDllInfo: TRunDllInfo;
begin
  Result := nil;
  //获取step对应的dll入口
  LRunDllInfo := GetRunDll(AStepRec.DllNameSpace);
  if LRunDllInfo = nil then Exit;

  //由dll返回对应的指针地址对象
  Result := LRunDllInfo.GetStepDesignForm(AStepRec, ATaskVar);
end;


procedure TStepMgr.LoadModuleDlls(aFilePath: string);
var
  aSearchrec: TSearchRec;
  findresult: integer;
begin
  if DirectoryExists(aFilePath) then
  begin
    if aFilePath[Length(aFilePath)] <> '\' then
      aFilePath := aFilePath + '\';
    // 本处根据配置文件的Modules来进行自动配置
    findresult := findfirst(aFilePath + '*.dll', faAnyFile, aSearchrec);
    while (findresult = 0) do
    begin
      LoadModules(aFilePath, aSearchrec.Name);
      findresult := FindNext(aSearchrec);
    end;
    FindClose(aSearchrec);
  end;
end;

procedure TStepMgr.LoadModules(const aFilePath, aDllName: string);
type
  TModuleRegister = procedure (var AModules: PChar); stdcall;
var
  h: thandle;
  p: Pointer;
  afullName: string;
  LModuleStepJsonStr: PChar;
  LModuleStepsJson: TJSONValue;
  LNameSpace: string;
begin
  afullName := aFilePath + aDllName;
  h := LoadLibrary(PChar(afullName));
  if h > 0 then
  begin
    p := GetProcAddress(h, 'ModulesRegister');
    if p <> nil then
    begin
      TModuleRegister(p)(LModuleStepJsonStr);

      //尝试解析
      LModuleStepsJson := TJSONObject.ParseJSONValue(LModuleStepJsonStr);
      if LModuleStepsJson = nil then Exit;

      //加入
      LNameSpace := ChangeFileExt(ExtractFileName(afullName), '');
      FModuleSteps := LModuleStepsJson as TJSONArray;
    end;
    FreeLibrary(h);
  end;
end;

function TStepMgr.GetStepDefine(AStepType: string): TStepDefine;
var
  i: Integer;
  LRow: TJSONObject;
begin
  Result.DllNameSpace := '';
  Result.StepTypeId := 0;
  Result.StepType := '';
  Result.StepTypeName := '';
  Result.StepClassName := '';
  Result.FormClassName := '';

  if AStepType = '' then
  begin
    raise Exception.Create('配置的StepType为空');
  end;


  GetDesigningSteps;

  if FModuleSteps = nil then Exit;


  //从列表中读取
  for I := 0 to FModuleSteps.Count - 1 do
  begin
    LRow := FModuleSteps.Items[i] as TJSONObject;
    if LRow = nil then Continue;

    if GetJsonObjectValue(LRow, 'step_type', '') = AStepType then
    begin
      Result.DllNameSpace := GetJsonObjectValue(LRow, 'namespace', '');
      Result.StepTypeId := StrToIntDef(GetJsonObjectValue(LRow, 'step_type_id', '0'), 0);
      Result.StepType := AStepType;
      Result.StepTypeName := GetJsonObjectValue(LRow, 'step_type_name', '');
      Result.StepClassName := GetJsonObjectValue(LRow, 'step_class_name', '');
      Result.FormClassName := GetJsonObjectValue(LRow, 'form_class_name', '');
    end;
  end;
end;

{*
本方法在设计阶段和运行阶段均会执行
*}
function TStepMgr.GetStep(AStepRec: TModuleStepRec; ATaskVar: TObject): TStepBasic;
var
  LRunDllInfo: TRunDllInfo;
begin
  Result := nil;
  //获取step对应的dll入口
  LRunDllInfo := GetRunDll(AStepRec.DllNameSpace);
  if LRunDllInfo = nil then Exit;

  //由dll返回对应的指针地址对象
  Result := LRunDllInfo.GetStep(AStepRec, ATaskVar);
end;


function TStepMgr.StepTypeToStepRec(AStepType: string): TModuleStepRec;
var
  LStepDefine: TStepDefine;
begin
  LStepDefine := GetStepDefine(AStepType);
  Result.DllNameSpace := LStepDefine.DllNameSpace;
  Result.StepId := LStepDefine.StepTypeId;
  Result.StepName := LStepDefine.StepTypeName;
  Result.Caption := LStepDefine.StepTypeName;
  Result.StepClassName := LStepDefine.StepClassName;
  Result.StepDesignFormClassName := LStepDefine.FormClassName;
end;

function TStepMgr.GetStep(AStepType: string; ATaskVar: TObject): TStepBasic;
begin
  Result := GetStep(StepTypeToStepRec(AStepType), ATaskVar);
end;

function TStepMgr.GetStepDesignForm(AStepType: string; ATaskVar: TObject): TStepBasicForm;
begin
  Result := GetStepDesignForm(StepTypeToStepRec(AStepType), ATaskVar);
end;

end.

