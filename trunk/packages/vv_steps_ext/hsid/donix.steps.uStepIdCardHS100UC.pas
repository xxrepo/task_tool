unit donix.steps.uStepIdCardHS100UC;

interface

uses
  uStepBasic, System.JSON, Winapi.Windows;

type
  TStepIdCardHS100UC = class (TStepBasic)
  private
    FWaitTime: Integer;
    FScanPorts: string;

    procedure Delay(DT: DWORD);
  protected
    procedure StartSelf; override;
  public
    procedure ParseStepConfig(AConfigJsonStr: string); override;
    procedure MakeStepConfigJson(var AToConfig: TJSONObject); override;

    property WaitTime: Integer read FWaitTime write FWaitTime;
    property ScanPorts: string read FScanPorts write FScanPorts;
  end;

implementation

uses
  uDefines, uFunctions, System.Classes, System.SysUtils, uExceptions, uStepDefines, uThreadSafeFile,
  Vcl.Forms, CVRDLL;

type
  ChA256 = array[0..255] of AnsiChar;

{ TStepQuery }

procedure TStepIdCardHS100UC.MakeStepConfigJson(var AToConfig: TJSONObject);
begin
  inherited MakeStepConfigJson(AToConfig);
  AToConfig.AddPair(TJSONPair.Create('wait_time', IntToStr(FWaitTime)));
  AToConfig.AddPair(TJSONPair.Create('scan_ports', FScanPorts));
end;


procedure TStepIdCardHS100UC.ParseStepConfig(AConfigJsonStr: string);
begin
  inherited ParseStepConfig(AConfigJsonStr);
  FWaitTime := StrToIntDef(GetJsonObjectValue(StepConfig.ConfigJson, 'wait_time'), 10);
  FScanPorts := GetJsonObjectValue(StepConfig.ConfigJson, 'scan_ports');
end;


procedure TStepIdCardHS100UC.StartSelf;
var
  sWZ: WideString;
  ChPeople: ChA256;

  ID: Cardinal	;

  szGet :array[0..70] of AnsiChar;
  iLenGet:integer;

  LDevicePort: Integer;
  LDevicePortConnected, LDeviceResult: Integer;
  LTimeConnected: Cardinal;
  LWaitTime: Cardinal;


  LCVRDll: TCVRDll;

  LPorts: TStringList;
  i: Integer;
  LOut: TJSONObject;
begin
  LCVRDll := TCVRDll.Create;
  FileCritical.Enter;
  try

    CheckTaskStatus;

    //先关闭上次读卡
    LCVRDll.CVR_CloseComm();

    LDevicePortConnected := -100;
    LPorts := TStringList.Create;
    try
      LPorts.Delimiter := ',';
      LPorts.DelimitedText := FScanPorts;

      //尝试遍历所有串口和usb
      DebugMsg('连接设备');
      for i := 0 to LPorts.Count - 1 do
      begin
        LDevicePort := StrToIntDef(LPorts[i], 0);
        if LDevicePort = 0 then Continue;

        DebugMsg('检测端口：' + LPorts[i]);

        LDevicePortConnected := LCVRDll.CVR_InitComm(LDevicePort);
        if LDevicePortConnected = 1 then
        begin
          DebugMsg('连接读卡器成功，端口：' + IntToStr(LDevicePort));
          Break;
        end;
      end;
    finally
      LPorts.Free;
    end;

    if LDevicePortConnected <> 1  then
    begin
      DebugMsg('未找到读卡器，请重新插入读卡器');
      Exit;
    end
    else
    begin
      //GetManuID(@ID); ，ID:'+inttostr(ID)
      DebugMsg('请放卡');
    end;

    LTimeConnected := GetTickCount();
    LWaitTime := FWaitTime * 1000;
    while True do
    begin
      Delay(300);
      LDeviceResult := LCVRDll.CVR_Authenticate();
      if LDeviceResult = 1 then Break;     //授权成功

      if ( GetTickCount() - LTimeConnected > LWaitTime ) then
      begin
        DebugMsg('放卡超时');
        Exit;
      end;
    end;

    LDeviceResult := LCVRDll.CVR_Read_Content(1);
    LCVRDll.CVR_CloseComm();
    if LDeviceResult <> 1 then
    begin
      DebugMsg('读基本信息出错');
      Exit;
    end;

    DebugMsg('读卡资料成功');

    //------------------------------------------------------------------显示资料
    LOut := TJSONObject.Create;
    try
      //-----测试 GetXXX() 系列函数
      LCVRDll.GetPeopleName(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('name', trim(string(szGet))));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleSex(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('sex', trim(string(szGet))));
      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleNation(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('nation', trim(string(szGet))));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleBirthday(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('birthday', trim(string(szGet))));
      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleAddress(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('address', trim(string(szGet))));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleIDCode(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('id_code', trim(string(szGet))));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetDepartment(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('department', trim(string(szGet))));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetStartDate(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('start_date', trim(string(szGet))));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetEndDate(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('end_date', trim(string(szGet))));

    finally
      FOutData.Data := LOut.ToJSON;
      DebugMsg('读取ID卡片数据：' + LOut.ToString);
      LOut.Free;
    end;
  finally
    if LCVRDll <> nil then
    begin
      LCVRDll.CVR_CloseComm;
      LCVRDll.Free;
    end;
    FileCritical.Leave;
  end;
end;



procedure TStepIdCardHS100UC.Delay(DT: DWORD);
// 延迟函数
var
   TT:DWORD;
begin
   TT:=Gettickcount();
   while Gettickcount() - TT < DT DO
     Application.ProcessMessages;
end;


end.
