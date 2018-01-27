unit uFunctions;

interface

uses
  System.JSON, Uni, Data.DB, Datasnap.DBClient, REST.Response.Adapter, Winapi.Windows;


function GetJsonObjectValue(AJsonObject: TJSONObject; AKey: string; ADefault: string = ''; AParamType: string = 'string'): Variant;
function StrToJsonValue(const AStr: string): TJSONValue;
function JsonValueToStr(const AJsonValue: TJSONValue): string;

function FindProcess(AFileName: string): boolean;
function OpenExecutive(AFileName: string): Boolean;
function KillProcess(ExeFileName: string): integer;
function DblClickProcessTray(const ProcessID: THandle): Boolean;
function EnablePrivilege(hToken: Cardinal; PrivName: string; bEnable: Boolean): Boolean;
function Md5String(AText: string): string;


function VariantValueByDataType(AVar: Variant; ADataType: string = 'string'): Variant;


function SortJsonArray(AJsonArray: TJSONArray; ASortByField: string;
               AFieldType: string = 'string'; ASortType: string = 'ASC'): TJSONArray;
procedure UniQueryToJson(AQuery: TUniQuery; var AOutJsonArray: TJSONArray);
function UniQueryToJsonStr(AQuery: TUniQuery): string;
function DataSetToJson(ADataSet: TClientDataSet): TJSONArray;
function DataSetToJsonStr(ADataSet: TClientDataSet): string;
procedure JsonToDataSet(AJson: TJSONValue; ADataSet: TClientDataSet); overload;
procedure JsonToDataSet(AJson: string; ADataset: TClientDataSet); overload;

function GetRowInJsonArray(const AJsonArray: TJSONArray; AFieldName: string; AFieldValue: string): TJSONObject;



implementation

uses
  Winapi.TlHelp32, System.SysUtils, Winapi.ShellAPI, Vcl.Controls, Winapi.Messages,
    System.Classes, IdHash, IdHashMessageDigest, System.Variants, Winapi.CommCtrl;


function VariantValueByDataType(AVar: Variant; ADataType: string = 'string'): Variant;
begin
  Result := VarToStrDef(AVar, '');
  if ADataType = 'float' then
  begin
    Result := StrToFloatDef(AVar, 0);
  end
  else if ADataType = 'int' then
  begin
    Result := StrToIntDef(AVar, 0);
  end
  else if ADataType = 'currency' then
  begin
    Result := StrToCurrDef(AVar, 0);
  end
  else if ADataType = 'datetime' then
  begin
    Result := VarToDateTime(AVar);
  end;
end;


function SortJsonArray(AJsonArray: TJSONArray; ASortByField: string;
               AFieldType: string = 'string'; ASortType: string = 'ASC'): TJSONArray;
begin
  Result := TJSONArray.Create;
  if AJsonArray = nil then Exit;


end;


function GetRowInJsonArray(const AJsonArray: TJSONArray; AFieldName: string; AFieldValue: string): TJSONObject;
var
  i: Integer;
begin
  Result := nil;
  if AJsonArray = nil then Exit;

  for i := 0 to AJsonArray.Count - 1 do
  begin
    Result := AJsonArray.Items[i] as TJSONObject;
    if GetJsonObjectValue(Result, AFieldName, '') = AFieldValue then
    begin
      Exit;
    end;
  end;
end;

procedure UniQueryToJson(AQuery: TUniQuery; var AOutJsonArray: TJSONArray);
var
  LJsonRow: TJSONObject;
  i: Integer;
  LFieldName: string;
begin
  if (AQuery = nil) or (not AQuery.Active) then Exit;

  AQuery.First;
  while not AQuery.Eof do
  begin
    LJsonRow := TJSONObject.Create;
    for i := 0 to AQuery.Fields.Count - 1 do
    begin
      LFieldName := AQuery.Fields[i].FieldName;
      LJsonRow.AddPair(TJSONPair.Create(LFieldName, AQuery.FieldByName(LFieldName).AsString));
    end;
    AOutJsonArray.Add(LJsonRow);
    AQuery.Next;
  end;
end;


function UniQueryToJsonStr(AQuery: TUniQuery): string;
var
  LOutJsonArray: TJSONArray;
begin
  Result := '';
  if (AQuery = nil) or (not AQuery.Active) then Exit;

  LOutJsonArray := TJSONArray.Create;
  try
    UniQueryToJson(AQuery, LOutJsonArray);
    //Edited by ToString
    if LOutJsonArray <> nil then
      Result := LOutJsonArray.ToJSON;
  finally
    LOutJsonArray.Free;
  end;
end;



function DataSetToJson(ADataSet: TClientDataSet): TJSONArray;
var
  LJsonRow: TJSONObject;
  i: Integer;
  LFieldName: string;
begin
  Result := nil;
  if (ADataSet = nil) or (not ADataSet.Active) then Exit;

  Result := TJSONArray.Create;
  ADataSet.First;
  while not ADataSet.Eof do
  begin
    LJsonRow := TJSONObject.Create;
    for i := 0 to ADataSet.Fields.Count - 1 do
    begin
      LFieldName := ADataSet.Fields[i].FieldName;
      if ADataSet.FieldDefs.Find(LFieldName).DataType
            in [ftDateTime, ftDate, ftTime, ftFloat, ftCurrency] then
      begin
        LJsonRow.AddPair(TJSONPair.Create(LFieldName, FloatToStr(ADataSet.FieldByName(LFieldName).AsDateTime)));
      end
      else if ADataSet.FieldDefs.Find(LFieldName).DataType in [ftInteger] then
        LJsonRow.AddPair(TJSONPair.Create(LFieldName, IntToStr(ADataSet.FieldByName(LFieldName).AsInteger)))
      else
        LJsonRow.AddPair(TJSONPair.Create(LFieldName, ADataSet.FieldByName(LFieldName).AsString));
    end;
    Result.Add(LJsonRow);
    ADataSet.Next;
  end;
end;


function DataSetToJsonStr(ADataSet: TClientDataSet): string;
var
  LJson: TJSONArray;
begin
  Result := '[]';
  LJson := DataSetToJson(ADataSet);
  if LJson = nil then Exit;
  Result := LJson.ToJSON;
  LJson.Free;
end;


procedure JsonToDataSet(AJson: string; ADataset: TClientDataSet);
var
  jDataSet: TJSONArray;
  jRecord: TJSONObject;
  i, j: Integer;
  LFieldName, LFieldValue: string;
begin
  if (AJson = '') or (ADataset = nil) or (not ADataset.Active) then
    Exit;
  jDataSet := TJSONObject.ParseJSONValue(AJson) as TJSONArray;
  ADataset.EmptyDataSet;

  if jDataSet = nil then Exit;

  try
    for i := 0 to jDataSet.Count - 1 do
    begin
      ADataset.Append;
      jRecord := jDataSet.Items[i] as TJSONObject;
      for j := 0 to ADataset.FieldCount - 1 do
      begin
        LFieldName := ADataset.Fields[j].FieldName;
        if ADataset.FieldDefs.Find(LFieldName).DataType
                 in [ftDateTime, ftDate, ftTime, ftFloat, ftCurrency, ftInteger] then
        begin
          LFieldValue := GetJsonObjectValue(jRecord, LFieldName, '0');
          if LFieldValue = '' then
            LFieldValue := '0';
        end
        else
        begin
          LFieldValue := GetJsonObjectValue(jRecord, LFieldName, '');
        end;
        ADataset.Fields[j].Value := LFieldValue;
      end;
      ADataset.Post;
    end;
  finally
    jDataSet.Free;
  end;
end;


procedure JsonToDataSet(AJson: TJSONValue; ADataSet: TClientDataSet);
var
  jsoncds: TCustomJSONDataSetAdapter;
begin
  if AJson = nil then
  begin
    if ADataSet.Active then
      ADataSet.EmptyDataSet;
    Exit;
  end;

  jsoncds := TCustomJSONDataSetAdapter.Create(nil);
  try
    if ADataSet.Active then
      ADataSet.Close;
    // 从Json创建数据
    jsoncds.Dataset := ADataSet;
    jsoncds.UpdateDataSet(AJson);
    ADataSet.Open;
  finally
    jsoncds.Free;
  end;
end;



function GetJsonObjectValue(AJsonObject: TJSONObject; AKey: string; ADefault: string = ''; AParamType: string = 'string'): Variant;
var
  LJsonValue: TJSONValue;
begin
  Result := ADefault;
  if AJsonObject <> nil then
    LJsonValue := AJsonObject.GetValue(AKey);
  if (LJsonValue <> nil) then
  begin
    if (LJsonValue is TJSONObject) or (LJsonValue is TJSONArray) then
    begin
      Result := (LJsonValue.ToJSON);
    end
    else
    begin
      Result := LJsonValue.Value;
    end;
  end;
  Result := VariantValueByDataType(Result);
end;


function StrToJsonValue(const AStr: string): TJSONValue;
begin
  Result := TJSONObject.ParseJSONValue(AStr);
  if Result = nil then
    Result := TJSONString.Create(AStr);
end;


function JsonValueToStr(const AJsonValue: TJSONValue): string;
begin
  Result := '';
  if AJsonValue = nil then Exit;

  if (AJsonValue is TJSONObject) or (AJsonValue is TJSONArray) then
    Result := AJsonValue.ToJSON
  else
    Result := AJsonValue.Value;
end;


function Md5File(AFileName: string): string;
var
  LFileStream: TFileStream;
  LMd5: TIdHashMessageDigest5;
begin
  Result := '';
  if not FileExists(AFileName) then Exit;

  LFileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareExclusive);
  LMd5 := TIdHashMessageDigest5.Create;
  try
    Result := LowerCase(LMd5.HashStreamAsHex(LFileStream));
  finally
    LMd5.Free;
    LFileStream.Free;
  end;
end;



function Md5String(AText: string): string;
var
  LMd5: TIdHashMessageDigest5;
begin
  Result := '';

  LMd5 := TIdHashMessageDigest5.Create;
  try
    Result := LowerCase(LMd5.HashStringAsHex(AText));
  finally
    LMd5.Free;
  end;
end;




function FindProcess(AFileName: string): boolean;
var
  hSnapshot: THandle; // 用于获得进程列表
  lppe: TProcessEntry32; // 用于查找进程
  Found: boolean; // 用于判断进程遍历是否完成
begin
  Result := False;
  hSnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0); // 获得系统进程列表
  lppe.dwSize := SizeOf(TProcessEntry32); // 在调用Process32First   API之前，需要初始化lppe记录的大小
  Found := Process32First(hSnapshot, lppe); // 将进程列表的第一个进程信息读入ppe记录中
  while Found do
  begin
    if ((UpperCase(ExtractFileName(lppe.szExeFile)) = UpperCase(AFileName)) or
      (UpperCase(lppe.szExeFile) = UpperCase(AFileName))) then
    begin
      Result := True;
    end;
    Found := Process32Next(hSnapshot, lppe); // 将进程列表的下一个进程信息读入lppe记录中
  end;
end;



function DblClickProcessTray(const ProcessID: THandle): Boolean;
var
  h: THandle;
  p: PTBBUTTON;
  i: Integer;
  b: _TBBUTTON;
  hTray: Cardinal;
  //dw: Cardinal;
  dw: THandle;
  TrayPid: Cardinal;
  TempPid: Cardinal;
  IcoHwnd: Cardinal;
  r: TRect;
  point: TPoint;
begin
  Result := False;

  hTray := FindWindow('Shell_TrayWnd', nil);
  hTray := FindWindowEx(hTray, 0, 'TrayNotifyWnd', nil);
  hTray := FindWindowEx(hTray, 0, 'SysPager', nil);
  hTray := FindWindowEx(hTray, 0, 'ToolbarWindow32', nil);
  GetWindowThreadProcessId(hTray, TrayPid);
  h := OpenProcess(PROCESS_ALL_ACCESS, False, TrayPid);
  p := VirtualAllocEx(h, nil, SizeOf(b) + SizeOf(r), MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);  dw := 0;

  for i := 0 to SendMessage(hTray, TB_BUTTONCOUNT, 0, 0) - 1 do
  begin
    ZeroMemory(@b, SizeOf(b));
    WriteProcessMemory(h, p, @b, SizeOf(b), dw);
    SendMessage(hTray, TB_GETBUTTON, i, LPARAM(p));
    ReadProcessMemory(h, p, @b, SizeOf(b), dw);
    ReadProcessMemory(h, Pointer(b.dwData), @IcoHwnd, 4, dw);//返回到本地的结构中dwData成员表示托盘图标句柄所在的位置
    GetWindowThreadProcessId(IcoHwnd, TempPid);
    if TempPid = ProcessID then
    begin
      SendMessage(hTray, TB_GETITEMRECT, i, LPARAM(LPARAM(p) + SizeOf(b)));
      ReadProcessMemory(h, Pointer(LPARAM(p) + SizeOf(b)), @r, SizeOf(r), dw);
      ClientToScreen(hTray, point);
      point.X := point.X + r.Left;
      point.Y := point.Y + r.Top;
      SetCursorPos(point.X, point.Y);//菜单弹出位置
      {按下右键弹出菜单，不能松开右键，否则可能弹出系统任务栏菜单}
      //Result := (0 = SendMessage(hTray, WM_RBUTTONDOWN, MK_RBUTTON, MAKELPARAM(r.Left, r.Top)));
      Result := (0 = SendMessage(hTray, WM_LBUTTONDBLCLK, MK_LBUTTON, MAKELPARAM(r.Left, r.Top)));
      Break;
    end;
  end;

  VirtualFreeEx(h, p, 0, MEM_RELEASE);
  CloseHandle(h);
end;


function EnablePrivilege(hToken: Cardinal; PrivName: string; bEnable: Boolean): Boolean;
var
TP: TOKEN_PRIVILEGES;
Dummy: Cardinal;
begin
TP.PrivilegeCount := 1;
LookupPrivilegeValue(nil, pchar(PrivName), TP.Privileges[0].Luid);

  if bEnable then
    TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED
  else
    TP.Privileges[0].Attributes := 0;

  AdjustTokenPrivileges(hToken, False, TP, Sizeof(TP), nil, Dummy);
  Result := GetLastError = ERROR_SUCCESS;
end;



function KillProcess(ExeFileName: string): integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOLean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase
          (ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase
          (ExeFileName))) then
      Result := integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;



function OpenExecutive(AFileName: string): Boolean;
begin
  Result := ShellExecute(0, 'open', PChar(AFileName), nil, nil, SW_NORMAL) > 0;
end;

end.
