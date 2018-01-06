program PrintTool;

uses
  Vcl.Forms,
  MidasLib,
  uFunctions in '..\common\uFunctions.pas',
  uBasicDlgForm in '..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uBasicForm in '..\core\basic\uBasicForm.pas' {BasicForm},
  uPrintMainForm in '..\module\print_tools\forms\uPrintMainForm.pas' {PrintMainForm},
  uPrinterPageSettingForm in '..\module\print_tools\forms\uPrinterPageSettingForm.pas' {PrinterPageSettingForm};

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := DebugHook<>0;
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrintMainForm, PrintMainForm);
  PrintMainForm.WindowState := wsMaximized;
  Application.Run;
end.
