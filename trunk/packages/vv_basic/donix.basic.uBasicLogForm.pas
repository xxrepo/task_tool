unit donix.basic.uBasicLogForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.ExtCtrls, RzPanel,
  RzSplit, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, uFileLogger;

type
  TBasicLogForm = class(TBasicForm)
    rzspltrLogForm: TRzSplitter;
    rzpnl3: TRzPanel;
    btnClearLog: TBitBtn;
    redtLog: TRichEdit;
    procedure MSGLoggerHandler(var AMsg: TMessage); message VV_MSG_LOGGER;
    procedure SetRichEditLineColor(AEditor: TRichEdit; ALine: Integer;AColor: TColor);
    procedure btnClearLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BasicLogForm: TBasicLogForm;

implementation

{$R *.dfm}

procedure TBasicLogForm.SetRichEditLineColor(AEditor: TRichEdit; ALine: Integer; AColor: TColor);
begin
  redtLog.SelStart := SendMessage(redtLog.Handle, EM_LINEINDEX, ALine, 0); // 选中这一行文字
  redtLog.SelLength := Length(redtLog.Lines.Strings[ALine]);
  redtLog.SelAttributes.Color := AColor; // 设为需要的字体大小
end;


procedure TBasicLogForm.btnClearLogClick(Sender: TObject);
begin
  inherited;
  redtLog.Clear;
end;

procedure TBasicLogForm.MSGLoggerHandler(var AMsg: TMessage);
var
  LMsg: PChar;
  LLine: Integer;
begin
  LMsg := PChar(AMsg.WParam);
  //更新状态
  LLine := redtLog.Lines.Add(LMsg);

  if Pos('[WARN]', LMsg) > 0 then
  begin
    SetRichEditLineColor(redtLog, LLine, clWebOrangeRed);
  end
  else if (Pos('[ERROR]', LMsg) > 0) or (Pos('[FATAL]', LMsg) > 0)
          or (Pos('错误', LMsg) > 0) or (Pos('失败', LMsg) > 0)
          or (Pos('异常', LMsg) > 0)  then
  begin
    SetRichEditLineColor(redtLog, LLine, clWebRed);
  end
  else if Pos('[FORCE]', LMsg) > 0 then
  begin
    SetRichEditLineColor(redtLog, LLine, clWebGreen);
  end;
end;

end.
