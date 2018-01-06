unit uJobScheduleForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TJobScheduleForm = class(TBasicDlgForm)
    lblInterval: TLabel;
    lblStartTime: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtStartAfter: TEdit;
    edtInterval: TEdit;
    edtTimeOut: TEdit;
    mmoAllowedTime: TMemo;
    mmoDisallowedTime: TMemo;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    function MakeConfigJsonStr: string;
    procedure ParseConfig(AConfigJsonStr: string);
  end;

var
  JobScheduleForm: TJobScheduleForm;

implementation

uses System.JSON, uFunctions;

{$R *.dfm}

function TJobScheduleForm.MakeConfigJsonStr: string;
var
  LJson: TJSONObject;
begin
  LJson := TJSONObject.Create;
  try
    LJson.AddPair(TJSONPair.Create('start_after', edtStartAfter.Text));
    LJson.AddPair(TJSONPair.Create('interval', edtInterval.Text));
    LJson.AddPair(TJSONPair.Create('time_out', edtTimeOut.Text));
    LJson.AddPair(TJSONPair.Create('allowed_time', mmoAllowedTime.Text));
    LJson.AddPair(TJSONPair.Create('disallowed_time', mmoDisallowedTime.Text));
  finally
    //Edited by ToString
    Result := LJson.ToJSON;
    LJson.Free;
  end;
end;

procedure TJobScheduleForm.ParseConfig(AConfigJsonStr: string);
var
  LJson: TJSONObject;
begin
  LJson := TJSONObject.ParseJSONValue(AConfigJsonStr) as TJSONObject;
  if LJson = nil then Exit;

  try
    edtStartAfter.Text := GetJsonObjectValue(LJson, 'start_after', '0');
    edtInterval.Text := GetJsonObjectValue(LJson, 'interval', '3600');
    edtTimeOut.Text := GetJsonObjectValue(LJson, 'time_out', '7200');
    mmoAllowedTime.Text := GetJsonObjectValue(LJson, 'allowed_time');
    mmoDisallowedTime.Text := GetJsonObjectValue(LJson, 'disallowed_time');
  finally
    LJson.Free;
  end;
end;

end.
