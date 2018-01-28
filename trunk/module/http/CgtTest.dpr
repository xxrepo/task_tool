program CgtTest;

uses
  Vcl.Forms,
  uHttpServerCtrlForm in 'forms\uHttpServerCtrlForm.pas' {Form1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
