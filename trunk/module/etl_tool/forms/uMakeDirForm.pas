unit uMakeDirForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TMakeDirForm = class(TBasicDlgForm)
    lbl1: TLabel;
    edtFolderName: TEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MakeDirForm: TMakeDirForm;

implementation

{$R *.dfm}

procedure TMakeDirForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = Char(VK_RETURN) then
    btnOK.Click;
end;

procedure TMakeDirForm.FormShow(Sender: TObject);
begin
  inherited;
  edtFolderName.SetFocus;
end;

end.
