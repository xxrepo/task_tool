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

unit ModuleMgrClass;

interface

uses
  PublicInfoClass, Contnrs, Classes;

type
  TModuleStepRec = record
    StepFullId: string;
    DllNameSpace: string;
    StepId: Integer;
    Name: string;
    Caption: string;
    Hint: string;
    ShowDlg: Boolean;
    AllowMulti: Boolean;
    InitBeforeCall: Boolean;
    Existed: Boolean;
  end;

  TModuleStepList = array of TModuleStepRec;

  TModuleRec = record
    DllName: string;
    FilePath: string;
    Name: string;
    Caption: string;
    Hint: string;
    ID: Integer;
    ModuleStepCount: Byte;
    ModuleSteps: TModuleStepList;
  end;

  TModuleList = array of TModuleRec;

  TRunDllInfo = class
    FilePath: string;
    DllName: string;
    DllHandle: THandle;
    DllEntryPointer: Pointer;
  public
    destructor Destroy; override;
  end;

  TStepFullIDRec = record
    StepFullId: string;
    DllNameSpace: string;
    StepId: Integer;
  end;


  //模块管理器，包括对系统全部Module信息的管理，以及对所有运行中的Module的管理
  TModuleMgr = class
  private
    FModuleList: TModuleList;
    FModuleCount: Integer;
    FModuleCapacity: Integer;
    FModuleRecSize: Integer;
    FMaxModuleCount: Integer;
    FModuleSteps: TStringList;
    FRunDllList: TObjectList;
    function GetDllEntryPointer(aFullID: string): Pointer;

    {ModuleList}
    procedure setModuleCapacity(const Value: Integer);
    function GetModule(aModuleID: Integer): TModuleRec;
    function GetModuleStep(aStepFullID: string): TModuleStepRec;

    {RunDllList}
    function GetRunDllCount: Integer;
    function GetRunDll(idx: Integer): TRunDllInfo;
  protected
    procedure ModuleListGrow;
  public
    constructor Create;
    destructor Destroy; override;
    property DllEntryPointer[aFullID: string]: Pointer read GetDllEntryPointer;
    function StrToStepFullIdRec(const aStepFullId: string): TStepFullIDRec;
    function StepFullIdRecToStr(aDllName: string; aUniqueId: Integer): string;

    {ModuleList}
    function AddModule(const aPCharModuleInfo: TPCharModuleInfo): Integer; overload;
    function AddModule(const aFilePath, aDllName: string; const aPCharModuleInfo: TPCharModuleInfo): Integer; overload;
    function IndexOfModule(const aModuleID: Integer): Integer;
    function GetDllFullName(const aStepFullID: string): string;
    function ModuleStepByStepId(const aStepFullID: string): TModuleStepRec;
    procedure LoadModules(const aFilePath, aDllName: string);
    procedure LoadModuleDlls(aFilePath: string);
    procedure LoadModuleDllsFrom(aFilePath: string);
    property ModuleCount: Integer read FModuleCount write FModuleCount;
    property ModuleCapacity: Integer read FModuleCapacity write setModuleCapacity;
    property Modules: TModuleList read FModuleList write FModuleList;
    property Module[aModuleID: Integer]: TModuleRec read GetModule;
    //property ModuleStep[aFullID: string]: TModuleStepRec read GetModuleStep;

    {RunDllList}
    function AddRunDll(const aRunDllInfo: TRunDllInfo): Integer; overload;
    function AddRunDll(const aFilePath, aDllName: string; const aDllHandle: THandle; const aDllEntryPointer: Pointer): Integer; overload;
    procedure RemoveRunDll(idx: Integer);
    function IndexofRunDll(const aDllFullName: string): Integer;
    property RunDlls: TObjectList read FRunDllList write FRunDllList;
    property RunDll[idx: Integer]: TRunDllInfo read GetRunDll;
    property RunDllCount: Integer read GetRunDllCount;
  end;

implementation

uses
  Windows, SysUtils;


{ TRunDllInfo }

destructor TRunDllInfo.Destroy;
begin
  if DllHandle <> 0 then
  begin
    FreeLibrary(DllHandle);
  end;
  inherited;
end;

{ TModuleMgr }

constructor TModuleMgr.Create;
begin
  inherited Create;
  FRunDllList := TObjectList.Create(False);
  FModuleSteps := TStringList.Create(True);

//  FModuleRecSize := SizeOf(TModuleRec);
//  FModuleRecSize := ((FModuleRecSize + 3) shr 2) shl 2;
//  FMaxModuleCount := MaxInt div FModuleRecSize;
//  FModuleCount := 0;
end;

destructor TModuleMgr.Destroy;
var
  i: Integer;
begin
  FModuleSteps.Free;

  for i := 0 to FRunDllList.Count - 1 do
    RunDll[i].Free;
  FreeAndNil(FRunDllList);
  inherited;
end;

function TModuleMgr.GetDllEntryPointer(aFullID: string): Pointer;
var
  aDllFullName: string;
  idx: Integer;
  h: THandle;
  p: Pointer;
begin
  Result := nil;
  aDllFullName := GetDllFullName(aFullID);
  idx := IndexofRunDll(aDllFullName);
  if idx > -1 then
  begin
    Result := RunDll[idx].DllEntryPointer;
    Exit;
  end;
  h := LoadLibrary(PChar(aDllFullName));
  if h > 0 then
  begin
    p := GetProcAddress(h, 'DllEntryPointer');
    if p <> nil then
    begin
      Result := p;
      AddRunDll(ExtractFilePath(aDllFullName), ExtractFileName(aDllFullName), h, p);
    end
    else
      FreeLibrary(h);
  end;
end;

{ModuleList}

function TModuleMgr.IndexOfModule(const aModuleID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FModuleCount - 1 do
  begin
    if FModuleList[i].ID = aModuleID then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TModuleMgr.StrToStepFullIdRec(const aStepFullID: string): TStepFullIDRec;
var
  LStringList: TStringList;
begin
  LStringList := TStringList.Create;
  try

  finally
    LStringList.Free;
  end;
end;

function TModuleMgr.StepFullIdRecToStr(aDllName: string; aUniqueId: Integer): string;
begin
  Result := aDllName + IntToStr(aUniqueId);
end;

function TModuleMgr.GetDllFullName(const aStepFullID: string): string;
var
  idx: Integer;
  aID: TStepFullIDRec;
begin
  Result := '';
  aID := StrToStepFullIdRec(aStepFullID);
  idx := IndexofModule(aID.StepId);
  if idx > -1 then
    Result := Modules[idx].FilePath + Modules[idx].DllName;
end;

function TModuleMgr.AddModule(const aPCharModuleInfo: TPCharModuleInfo): Integer;
var
  i: Integer;
begin
  if FModuleCount = FModuleCapacity then
    ModuleListGrow;
  with FModuleList[FModuleCount] do
  begin
    Name := aPCharModuleInfo.Name;
    Caption := aPCharModuleInfo.Caption;
    Hint := aPCharModuleInfo.Hint;
    ModuleStepCount := aPCharModuleInfo.ModuleStepCount;
    SetLength(ModuleSteps, ModuleStepCount);
    for i := 0 to ModuleStepCount - 1 do
    begin
      with ModuleSteps[i] do
      begin
        Name := TPCharModuleStepInfo(aPCharModuleInfo.ModuleSteps[i]).Name;
        Caption := TPCharModuleStepInfo(aPCharModuleInfo.ModuleSteps[i]).Caption;
        Hint := TPCharModuleStepInfo(aPCharModuleInfo.ModuleSteps[i]).Hint;
        ShowDlg := TPCharModuleStepInfo(aPCharModuleInfo.ModuleSteps[i]).ShowDlg;
        AllowMulti := TPCharModuleStepInfo(aPCharModuleInfo.ModuleSteps[i]).AllowMulti;
        InitBeforeCall := TPCharModuleStepInfo(aPCharModuleInfo.ModuleSteps[i]).InitBeforeCall;
        Existed := True;
      end;
    end;
    Result := FModuleCount;
    inc(FModuleCount);
  end;
end;

function TModuleMgr.AddModule(const aFilePath, aDllName: string; const aPCharModuleInfo: TPCharModuleInfo): Integer;
begin
  //TODO 在这里引入对moduleSteps的管理


  if FModuleCount = FModuleCapacity then
    ModuleListGrow;
  with FModuleList[FModuleCount] do
  begin
    FilePath := aFilePath;
    DllName := aDllName;
  end;
  Result := AddModule(aPCharModuleInfo);
end;

procedure TModuleMgr.ModuleListGrow;
var
  NewCapacity: Integer;
begin
  if ModuleCapacity = 0 then
    NewCapacity := 4
  else if ModuleCapacity < 64 then
    NewCapacity := ModuleCapacity + 16
  else
    NewCapacity := ModuleCapacity + (ModuleCapacity div 4);
  if NewCapacity > FMaxModuleCount then
  begin
    NewCapacity := FMaxModuleCount;
    if (NewCapacity = ModuleCapacity) then
      raise Exception.Create('内存分配错误，已达模块最大数。');
  end;
  ModuleCapacity := NewCapacity;
end;

procedure TModuleMgr.setModuleCapacity(const Value: Integer);
begin
  if Value <> FModuleCapacity then
  begin
    if Value > FMaxModuleCount then
      raise Exception.Create('内存分配错误，已达模块最大数。');
    SetLength(FModuleList, Value);
    FModuleCapacity := Value;
  end;
end;

function TModuleMgr.ModuleStepByStepId(const aStepFullID: string): TModuleStepRec;
var
  i, j: Integer;
begin
  Result.Existed := False;
  for j := 0 to ModuleCount - 1 do
  begin
    for i := 0 to Modules[j].ModuleStepCount - 1 do
    begin
      if Modules[j].ModuleSteps[i].Name = aStepFullID then
      begin
        Result := Modules[j].ModuleSteps[i];
        Exit;
      end;
    end;
  end;
end;

function TModuleMgr.GetModule(aModuleID: Integer): TModuleRec;
var
  idx: Integer;
begin
  idx := IndexofModule(aModuleID);
  if (idx > -1) then
    Result := FModuleList[idx]
  else
    Result.ID := -1;
end;

function TModuleMgr.GetModuleStep(aStepFullID: string): TModuleStepRec;
var
  aID: TStepFullIDRec;
  i, idx: Integer;
begin
  Result.Existed := False;
  aID := StrToStepFullIdRec(aStepFullID);
  idx := IndexOfModule(aID.StepId);
  if idx = -1 then
    Exit;
  for i := 0 to Modules[idx].ModuleStepCount - 1 do
  begin
//    if Modules[idx].SubModules[i].ID=aID.SubModuleID then
//    begin
//      Result:=Modules[idx].SubModules[i];
//      Exit;
//    end;
  end;
end;


// 本函数从配置文件加载动态模块
procedure TModuleMgr.LoadModuleDllsFrom(aFilePath: string);
var
  lStringList: TStringList;
  i: Integer;
  lFilePath, lFileName: string;
begin
  if DirectoryExists(aFilePath) then
  begin
    lStringList := TStringList.Create;
    try
      //Config.IniFile.ReadSectionValues('Modules', lStringList);
      for i := 0 to lStringList.Count - 1 do
      begin
        if FileExists(lStringList.ValueFromIndex[i]) then
        begin
          lFilePath := ExtractFilePath(lStringList.ValueFromIndex[i]);
          lFileName := ExtractFileName(lStringList.ValueFromIndex[i]);
          LoadModules(lFilePath, lFileName);
        end
        else
          LoadModules(aFilePath, lStringList.ValueFromIndex[i]);
      end;
    finally
      lStringList.Free;
    end;
  end;
end;

procedure TModuleMgr.LoadModuleDlls(aFilePath: string);
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

procedure TModuleMgr.LoadModules(const aFilePath, aDllName: string);
type
  TModuleRegister = procedure(DllModuleList: TObjectList); stdcall;
var
  h: thandle;
  p: Pointer;
  i: Integer;
  afullName: string;
  tempPCharModuleInfo: TPCharModuleInfo;
  tempList: TObjectList;
begin
  afullName := aFilePath + aDllName;
  h := LoadLibrary(PChar(afullName));
  if h > 0 then
  begin
    p := GetProcAddress(h, 'ModulesRegister');
    if p <> nil then
    begin
      tempList := TObjectList.Create(True);
      TModuleRegister(p)(tempList);
      for i := 0 to tempList.Count - 1 do
      begin
        tempPCharModuleInfo := TPCharModuleInfo(tempList.Items[i]);
        AddModule(aFilePath, aDllName, tempPCharModuleInfo);
      end;
      tempList.Clear;
      tempList.Free;
    end;
    FreeLibrary(h);
  end;
end;



{RunDllList}
function TModuleMgr.GetRunDllCount: Integer;
begin
  Result := FRunDllList.Count;
end;

function TModuleMgr.AddRunDll(const aRunDllInfo: TRunDllInfo): Integer;
begin
  Result := -1;
  if aRunDllInfo <> nil then
  begin
    Result := FRunDllList.Add(aRunDllInfo);
  end;
end;

function TModuleMgr.AddRunDll(const aFilePath, aDllName: string; const aDllHandle: THandle; const aDllEntryPointer: Pointer): Integer;
var
  aRunDllInfo: TRunDllInfo;
begin
  aRunDllInfo := TRunDllInfo.Create;
  aRunDllInfo.FilePath := aFilePath;
  aRunDllInfo.DllName := aDllName;
  aRunDllInfo.DllHandle := aDllHandle;
  aRunDllInfo.DllEntryPointer := aDllEntryPointer;
  Result := AddRunDll(aRunDllInfo);
  if Result = -1 then
    aRunDllInfo.Free;
end;

procedure TModuleMgr.RemoveRunDll(idx: Integer);
begin
  RunDll[idx].Free;
  FRunDllList.Delete(idx);
end;

function TModuleMgr.IndexofRunDll(const aDllFullName: string): Integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to FRunDllList.Count - 1 do
  begin
    if CompareText(aDllFullName, RunDll[i].FilePath + Rundll[i].DllName) = 0 then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

function TModuleMgr.GetRunDll(idx: Integer): TRunDllInfo;
begin
  Result := nil;
  if (idx > -1) and (idx < FRunDllList.Count) then
    Result := TRunDllInfo(FRunDllList[idx]);
end;

end.

