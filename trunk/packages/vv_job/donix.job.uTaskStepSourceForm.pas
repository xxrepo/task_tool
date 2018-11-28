unit donix.job.uTaskStepSourceForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, RzEdit;

type
  TTaskStepSourceForm = class(TBasicDlgForm)
    redtSource: TRzRichEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaskStepSourceForm: TTaskStepSourceForm;

implementation

{$R *.dfm}

end.
