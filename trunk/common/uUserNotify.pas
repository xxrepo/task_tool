unit uUserNotify;

interface

uses Vcl.Dialogs, System.Contnrs, uUserNotifyMsgForm, System.SyncObjs;

type
  TUserNotify = class
  private
    FCritical: TCriticalSection;
    FNotifyForms: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;

    function BlockNotify(AMsg: string): Integer;

    procedure Clear;

    class function BlockUiNotify(AMsg: string): Integer;
  end;

implementation

uses Vcl.Forms, System.SysUtils, Winapi.Windows, Winapi.Messages, System.Classes;

{ TUserNotify }

function TUserNotify.BlockNotify(AMsg: string): Integer;
var
  LForm: TUserNotifyMsgForm;
begin
  //该方法仅仅在具有交互的系统中进行处理，为编译带来较好的维护性
  try
    LForm := TUserNotifyMsgForm.Create(Application);
    FNotifyForms.Add(LForm);
    with LForm do
    try
      lblMsg.Caption := AMsg;
      Result := ShowModal;
    finally
      if LForm <> nil then
      begin
        FreeAndNil(LForm);
      end;
    end;
  finally

  end;
end;

class function TUserNotify.BlockUiNotify(AMsg: string): Integer;
begin
  Application.NormalizeTopMosts;
  with TUserNotifyMsgForm.Create(Application) do
  try
    lblMsg.Caption := AMsg;
    ShowModal;
  finally

  end;
end;

procedure TUserNotify.Clear;
var
  i: Integer;
  LForm: TObject;
begin
  for i := FNotifyForms.Count - 1 downto 0 do
  begin
    if FNotifyForms.Items[i] = nil then Continue;

    try
      LForm := FNotifyForms.Items[i];
      if (LForm <> nil) and (LForm is TForm) then
        SendMessage((LForm as TForm).Handle, WM_CLOSE, 0, 0);
      FNotifyForms.Delete(i);
    finally

    end;
  end;
end;

constructor TUserNotify.Create;
begin
  inherited;
  FCritical := TCriticalSection.Create;
  FNotifyForms := TObjectList.Create(False);
end;

destructor TUserNotify.Destroy;
begin
  Clear;
  FNotifyForms.Free;
  FCritical.Free;
  inherited;
end;

end.
