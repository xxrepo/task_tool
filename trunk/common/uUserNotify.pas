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
  end;

implementation

uses Vcl.Forms, System.SysUtils, Winapi.Windows, Winapi.Messages;

{ TUserNotify }

function TUserNotify.BlockNotify(AMsg: string): Integer;
var
  LForm: TUserNotifyMsgForm;
  idx: Integer;
begin
  //该方法仅仅在具有交互的系统中进行处理，为编译带来较好的维护性
  try
    LForm := TUserNotifyMsgForm.Create(Application);
    idx := FNotifyForms.Add(LForm);
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
