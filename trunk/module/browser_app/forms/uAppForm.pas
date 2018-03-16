unit uAppForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicChromeForm, Vcl.ExtCtrls,
  uCEFChromium, uCEFWindowParent, uCEFConstants;

type
  TAppForm = class(TBasicChromeForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
    procedure WMEnterSizeMove(var Message: TMessage) ; message WM_ENTERSIZEMOVE;
  end;

var
  AppForm: TAppForm;

implementation

uses uCEFApplication, uDefines;

{$R *.dfm}

procedure TAppForm.WMMove(var aMessage : TWMMove);
begin
  inherited;
  if (chrmMain <> nil) then chrmMain.NotifyMoveOrResizeStarted;
end;

procedure TAppForm.WMMoving(var aMessage : TMessage);
begin
  inherited;
  if (chrmMain <> nil) then chrmMain.NotifyMoveOrResizeStarted;
end;


procedure TAppForm.FormCreate(Sender: TObject);
begin
  inherited;
  FTargetUrl := 'file:///' + ExePath + 'app/html/index.html';
end;

procedure TAppForm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure TAppForm.WMEnterSizeMove(
  var Message: TMessage);
begin
  if (chrmMain <> nil) then chrmMain.NotifyMoveOrResizeStarted;
end;

procedure TAppForm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

end.
