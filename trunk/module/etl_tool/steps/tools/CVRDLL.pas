{**************************************************
	深圳华视电子读写设备有限公司 
	    版权所有 (c) 2007.04
 
	By: 吴为龙 Kim.Wu 
	Tel: 0755-26955558
	Http://www.chinaidcard.com
***************************************************}


unit CVRDLL;

interface

type





  TCVRDll = class
  private
    FDllHandle: THandle;

  public
    constructor Create;
    destructor Destroy; override;

    //-------------------------------------------------------------------------
    function CVR_InitComm(iPort :integer):integer;stdcall;       						 //	初始化串口
    function CVR_CloseComm():integer;stdcall;                                // 关闭串口
    function CVR_Authenticate():integer;stdcall;										 	       // 卡认证
    function CVR_Read_Content(Active :integer):integer;stdcall;					     //	读卡操作
    //-------------------------------------------------------------------------
    function InitComm(iPort :integer):integer;stdcall;       						 //	初始化串口
    function CloseComm():integer;stdcall;                                // 关闭串口
    function Authenticate():integer;stdcall;										 	       // 卡认证
    function Read_Content(Active :integer):integer;stdcall;					     //	读卡操作

    function GetManuID(ID:PCardinal): integer;stdcall;

    function  GetPeopleName(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetPeopleSex(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetPeopleNation(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetPeopleBirthday(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetPeopleAddress(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetPeopleIDCode(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetDepartment(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetStartDate(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
    function  GetEndDate(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
  end;

  //-------------------------------------------------------------------------
//  function CVR_InitComm(iPort :integer):integer;stdcall;       						 //	初始化串口
//  function CVR_CloseComm():integer;stdcall;                                // 关闭串口
//  function CVR_Authenticate():integer;stdcall;										 	       // 卡认证
//  function CVR_Read_Content(Active :integer):integer;stdcall;					     //	读卡操作
//  //-------------------------------------------------------------------------
//  function InitComm(iPort :integer):integer;stdcall;       						 //	初始化串口
//  function CloseComm():integer;stdcall;                                // 关闭串口
//  function Authenticate():integer;stdcall;										 	       // 卡认证
//  function Read_Content(Active :integer):integer;stdcall;					     //	读卡操作
//
//  function GetManuID(ID:PCardinal): integer;stdcall;
//
//  function  GetPeopleName(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetPeopleSex(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetPeopleNation(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetPeopleBirthday(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetPeopleAddress(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetPeopleIDCode(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetDepartment(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetStartDate(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;
//  function  GetEndDate(strTmp:PAnsiChar; strLen:Pinteger): integer;stdcall;


implementation

uses Winapi.Windows;


type
  TCVR_InitComm_Func = function (iPort: Integer): Integer; stdcall;
  TCVR_CloseComm_Func = function (): Integer; stdcall;
  TCVR_Authenticate_Func = function (): Integer; stdcall;
  TCVR_Read_Content_Func = function (Active: Integer): Integer; stdcall;
  TGetManuId_Func = function (ID: PCardinal): Integer; stdcall;

  TInitComm_Func = function (iPort: Integer): Integer; stdcall;
  TCloseComm_Func = function (): Integer; stdcall;
  TAuthenticate_Func = function (): Integer; stdcall;
  TRead_Content_Func = function (Active: Integer): Integer; stdcall;

  TGetPeopleName_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetPeopleSex_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetPeopleNation_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetPeopleBirthday_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetPeopleAddress_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetPeopleIDCode_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetDepartment_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetStartDate_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;
  TGetEndDate_Func = function (strTmp: PAnsiChar; strLen: PInteger): Integer; stdcall;

  //---------------------------------------------------
//  function CVR_InitComm; external 'termb.dll';       					 //	初始化串口
//  function CVR_CloseComm; external 'termb.dll';                // 关闭串口
//  function CVR_Authenticate; external 'termb.dll'; 						 // 卡认证
//  function CVR_Read_Content; external 'termb.dll'; 				     //	读卡操作
//  //---------------------------------------------------
//  function InitComm; external 'termb.dll';       					 //	初始化串口
//  function CloseComm; external 'termb.dll';                // 关闭串口
//  function Authenticate; external 'termb.dll'; 						 // 卡认证
//  function Read_Content; external 'termb.dll'; 				     //	读卡操作
//  //---------------------------------------------------
//  function GetManuID;  external 'termb.dll';
//
//  function  GetPeopleName ;external 'termb.dll';
//  function  GetPeopleSex;external 'termb.dll';
//  function  GetPeopleNation ;external 'termb.dll';
//  function  GetPeopleBirthday;external 'termb.dll';
//  function  GetPeopleAddress;external 'termb.dll';
//  function  GetPeopleIDCode;external 'termb.dll';
//  function  GetDepartment;external 'termb.dll';
//  function  GetStartDate;external 'termb.dll';
//  function  GetEndDate;external 'termb.dll';

{ TCVRDll }

function TCVRDll.Authenticate: integer;
var
  LPointer:Pointer;
  LFunc: TAuthenticate_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'Authenticate');
    if LPointer <> nil then
    begin
      LFunc := TAuthenticate_Func(LPointer);
      Result := LFunc();
    end;
  end;
end;

function TCVRDll.CloseComm: integer;
var
  LPointer:Pointer;
  LFunc: TCloseComm_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'CloseComm');
    if LPointer <> nil then
    begin
      LFunc := TCloseComm_Func(LPointer);
      Result := LFunc();
    end;
  end;
end;

constructor TCVRDll.Create;
begin
  FDllHandle := LoadLibrary('termb.dll');
end;

function TCVRDll.CVR_Authenticate: integer;
var
  LPointer:Pointer;
  LFunc: TCVR_Authenticate_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'CVR_Authenticate');
    if LPointer <> nil then
    begin
      LFunc := TCVR_Authenticate_Func(LPointer);
      Result := LFunc();
    end;
  end;
end;

function TCVRDll.CVR_CloseComm: integer;
var
  LPointer:Pointer;
  LFunc: TCVR_CloseComm_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'CVR_CloseComm');
    if LPointer <> nil then
    begin
      LFunc := TCVR_CloseComm_Func(LPointer);
      Result := LFunc();
    end;
  end;
end;

function TCVRDll.CVR_InitComm(iPort: integer): integer;
var
  LPointer:Pointer;
  LFunc: TCVR_InitComm_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'CVR_InitComm');
    if LPointer <> nil then
    begin
      LFunc := TCVR_InitComm_Func(LPointer);
      Result := LFunc(iPort);
    end;
  end;
end;

function TCVRDll.CVR_Read_Content(Active: integer): integer;
var
  LPointer:Pointer;
  LFunc: TCVR_Read_Content_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'CVR_Read_Content');
    if LPointer <> nil then
    try
      LFunc := TCVR_Read_Content_Func(LPointer);
      Result := LFunc(Active);
    except

    end;
  end;
end;


destructor TCVRDll.Destroy;
begin
  if FDllHandle > 0 then
  begin
    FreeLibrary(FDllHandle);
  end;
  inherited;
end;

function TCVRDll.GetDepartment(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetDepartment_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetDepartment');
    if LPointer <> nil then
    begin
      LFunc := TGetDepartment_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;


function TCVRDll.GetEndDate(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetEndDate_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetEndDate');
    if LPointer <> nil then
    begin
      LFunc := TGetEndDate_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetManuID(ID: PCardinal): integer;
var
  LPointer:Pointer;
  LFunc: TGetManuID_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetManuID');
    if LPointer <> nil then
    begin
      LFunc := TGetManuID_Func(LPointer);
      Result := LFunc(ID);
    end;
  end;
end;

function TCVRDll.GetPeopleAddress(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetPeopleAddress_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetPeopleAddress');
    if LPointer <> nil then
    begin
      LFunc := TGetPeopleAddress_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetPeopleBirthday(strTmp: PAnsiChar;
  strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetPeopleBirthday_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetPeopleBirthday');
    if LPointer <> nil then
    begin
      LFunc := TGetPeopleBirthday_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetPeopleIDCode(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetPeopleIDCode_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetPeopleIDCode');
    if LPointer <> nil then
    begin
      LFunc := TGetPeopleIDCode_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetPeopleName(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetPeopleName_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetPeopleName');
    if LPointer <> nil then
    begin
      LFunc := TGetPeopleName_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetPeopleNation(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetPeopleNation_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetPeopleNation');
    if LPointer <> nil then
    begin
      LFunc := TGetPeopleNation_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetPeopleSex(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetPeopleSex_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetPeopleSex');
    if LPointer <> nil then
    begin
      LFunc := TGetPeopleSex_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.GetStartDate(strTmp: PAnsiChar; strLen: Pinteger): integer;
var
  LPointer:Pointer;
  LFunc: TGetStartDate_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'GetStartDate');
    if LPointer <> nil then
    begin
      LFunc := TGetStartDate_Func(LPointer);
      Result := LFunc(strTmp, strLen);
    end;
  end;
end;

function TCVRDll.InitComm(iPort: integer): integer;
var
  LPointer:Pointer;
  LFunc: TInitComm_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'InitComm');
    if LPointer <> nil then
    begin
      LFunc := TInitComm_Func(LPointer);
      Result := LFunc(iPort);
    end;
  end;
end;

function TCVRDll.Read_Content(Active: integer): integer;
var
  LPointer:Pointer;
  LFunc: TRead_Content_Func;
begin
  Result := -100;
  if FDllHandle > 0 then
  begin
    LPointer := GetProcAddress(FDllHandle, 'Read_Content');
    if LPointer <> nil then
    begin
      LFunc := TRead_Content_Func(LPointer);
      Result := LFunc(Active);
    end;
  end;
end;

end.
