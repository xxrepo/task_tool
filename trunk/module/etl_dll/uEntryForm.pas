unit uEntryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TTEntryForm = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TEntryForm: TTEntryForm;

implementation

{$R *.dfm}

procedure TTEntryForm.btn1Click(Sender: TObject);
begin
  ShowMessage('OK, Test');
end;

end.
