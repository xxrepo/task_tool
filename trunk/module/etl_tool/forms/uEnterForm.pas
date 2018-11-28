unit uEnterForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.StdCtrls, Vcl.Buttons;

type
  TEnterForm = class(TBasicForm)
    lbl1: TLabel;
    lblVersion: TLabel;
    btnServiceControl: TBitBtn;
    btnProjectDesign: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btnServiceControlClick(Sender: TObject);
    procedure btnProjectDesignClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OpenForm: string;
  end;

var
  EnterForm: TEnterForm;

implementation

uses uDefines;

{$R *.dfm}

procedure TEnterForm.btnProjectDesignClick(Sender: TObject);
begin
  inherited;
  OpenForm := 'project_design';
end;

procedure TEnterForm.btnServiceControlClick(Sender: TObject);
begin
  inherited;
  OpenForm := 'service_control';
end;

procedure TEnterForm.FormCreate(Sender: TObject);
begin
  inherited;
  lblVersion.Caption := 'Ver£º' + APP_VER;
end;

end.
