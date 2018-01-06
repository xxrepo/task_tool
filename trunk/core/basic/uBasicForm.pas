unit uBasicForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TBasicForm = class(TForm)
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BasicForm: TBasicForm;

implementation

{$R *.dfm}

procedure TBasicForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_ESCAPE) then
  begin
    Self.Close;
  end;
end;

end.
