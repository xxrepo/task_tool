unit uCtrlMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, RzTray, Vcl.Menus,
  Vcl.StdCtrls;

type
  TCtrlMainForm = class(TBasicForm)
    trycnTool: TRzTrayIcon;
    pmTray: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    lbl1: TLabel;
    procedure N9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N7Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CtrlMainForm: TCtrlMainForm;

implementation

uses uHttpServerControlForm;

{$R *.dfm}

procedure TCtrlMainForm.FormClick(Sender: TObject);
begin
  inherited;

  trycnTool.ShowBalloonHint('采购通提示', '打印报表已经准备好');
end;

procedure TCtrlMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caNone;
  Application.Minimize;
end;

procedure TCtrlMainForm.N7Click(Sender: TObject);
begin
  inherited;
  with THttpServerControlForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TCtrlMainForm.N9Click(Sender: TObject);
begin
  inherited;
  Application.Terminate;
end;

end.
