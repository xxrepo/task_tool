unit donix.basic.uBasicDlgForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TBasicDlgForm = class(TBasicForm)
    pnlOper: TPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BasicDlgForm: TBasicDlgForm;

implementation

{$R *.dfm}

end.
