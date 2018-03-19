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
  end;

var
  AppForm: TAppForm;

implementation

uses uCEFApplication, uDefines;

{$R *.dfm}

procedure TAppForm.FormCreate(Sender: TObject);
begin
  inherited;
  FTargetUrl := 'file:///' + ExePath + 'app/html/index.html';
end;

end.
