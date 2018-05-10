unit uInitIdCardReadForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.ExtCtrls, RzPanel,
  Vcl.StdCtrls, Vcl.Buttons;

type
  TInitIdCardReadForm = class(TBasicForm)
    mmoInfo: TMemo;
    rzpnlBottom: TRzPanel;
    btnOk: TBitBtn;
    btnClose: TBitBtn;
    cbbPorts: TComboBox;
    btnSign: TBitBtn;
    chkAuto: TCheckBox;
    tmrAutoReadSign: TTimer;
    procedure btnOkClick(Sender: TObject);
    procedure btnSignClick(Sender: TObject);
    procedure tmrAutoReadSignTimer(Sender: TObject);
  private
    procedure DebugMsg(AMsg: string);
    procedure Delay(DT: DWORD);
    { Private declarations }
  public
    { Public declarations }
    CurrentID: string;
  end;

var
  InitIdCardReadForm: TInitIdCardReadForm;

implementation

uses System.JSON, CVRDLL, uCtrlMainForm, uNetUtil, REST.Client, REST.Types, uFunctions;

type
  ChA256 = array[0..255] of AnsiChar;

{$R *.dfm}

procedure TInitIdCardReadForm.btnSignClick(Sender: TObject);
var
  LRequestParamData: TRESTRequestParameterList;
  LResponse: string;
  LResponseJson: TJSONObject;
begin
  inherited;
  if CurrentID = '' then
  begin
    ShowMessage('签到的身份证号不能为空');
  end;

  LRequestParamData := TRESTRequestParameterList.Create(nil);
  try
    LRequestParamData.AddItem('tmp_token', TNetUtil.ParamEncodeUtf8('HelloWorldTest2018'), pkGETorPOST, [poDoNotEncode]);
    LRequestParamData.AddItem('id_card_no', TNetUtil.ParamEncodeUtf8(CurrentID), pkGETorPOST, [poDoNotEncode]);
    //LRequestParamData.AddItem('apply_id', TNetUtil.ParamEncodeUtf8('1'), pkGETorPOST, [poDoNotEncode]);

    //发起请求
    LResponse := TNetUtil.RequestTo('http://kt.zfjyjt.com/kt/org/?dis=lesson-apply/sign&rsp=json', LRequestParamData);
    //DebugMsg('签到结果：' + LResponse);

    LResponseJson := TJSONObject.ParseJSONValue(LResponse) as TJSONObject;

    if LResponseJson = nil then
    begin
      ShowMessage('签到失败');
      Exit;
    end
    else
    begin
      DebugMsg('签到结果：' +  LResponseJson.ToString);
      ShowMessage(GetJsonObjectValue(LResponseJson, 'msg'));
      if (GetJsonObjectValue(LResponseJson, 'code', '0', 'int') > 0) then
      begin
        if chkAuto.Checked then
        begin
          tmrAutoReadSign.Enabled := True;
        end;
      end;
      LResponseJson.Free;
    end;
  finally
    LRequestParamData.Free;
  end;
end;


procedure TInitIdCardReadForm.DebugMsg(AMsg: string);
begin
  mmoInfo.Lines.Add(AMsg);
end;

procedure TInitIdCardReadForm.btnOkClick(Sender: TObject);
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

  LPorts: TStringList;
  i: Integer;
  LOut: TJSONObject;
  LCVRDll: TCVRDll;
begin
  try
    mmoInfo.Clear;
    btnSign.Enabled := False;
    CurrentId := '';

    LCVRDll := TCVRDll.Create;

    //先关闭上次读卡
    LCVRDll.CVR_CloseComm();

    LDevicePortConnected := -100;
    LPorts := TStringList.Create;
    try
      LPorts.Text := cbbPorts.Items.Text;

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
    LWaitTime := 10 * 1000;
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
    btnSign.Enabled := True;

    //------------------------------------------------------------------显示资料
    LOut := TJSONObject.Create;
    try
      //-----测试 GetXXX() 系列函数
      LCVRDll.GetPeopleName(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('name', trim(string(szGet))));
      DebugMsg('姓名：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleSex(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('sex', trim(string(szGet))));
      DebugMsg('性别：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleNation(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('nation', trim(string(szGet))));
      DebugMsg('名族：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleBirthday(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('birthday', trim(string(szGet))));
      DebugMsg('生日：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleAddress(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('address', trim(string(szGet))));
      DebugMsg('地址：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetPeopleIDCode(@szGet[0], @iLenGet);
      CurrentID := trim(string(szGet));
      LOut.AddPair(TJSONPair.Create('id_code', trim(string(szGet))));
      DebugMsg('号码：' + string(szGet));


      zeromemory(@szGet[0], 70);
      LCVRDll.GetDepartment(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('department', trim(string(szGet))));
      DebugMsg('发证机关：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetStartDate(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('start_date', trim(string(szGet))));
      DebugMsg('有效期（开始）：' + string(szGet));

      zeromemory(@szGet[0], 70);
      LCVRDll.GetEndDate(@szGet[0], @iLenGet);
      LOut.AddPair(TJSONPair.Create('end_date', trim(string(szGet))));
      DebugMsg('有效期（截止）：' + string(szGet));

      if chkAuto.Checked then
        btnSign.Click;

    finally
      //DebugMsg('读取ID卡片数据：' + LOut.ToString);
      LOut.Free;
    end;
  finally
    if LCVRDll <> nil then
    begin
      LCVRDll.CVR_CloseComm;
      LCVRDll.Free;
    end;
  end;
end;

procedure TInitIdCardReadForm.Delay(DT: DWORD);
// 延迟函数
var
   TT:DWORD;
begin
   TT:=Gettickcount();
   while Gettickcount() - TT < DT DO
     Application.ProcessMessages;
end;

procedure TInitIdCardReadForm.tmrAutoReadSignTimer(Sender: TObject);
begin
  inherited;
  tmrAutoReadSign.Enabled := False;
  btnOk.Click;
end;

end.
