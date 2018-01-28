unit uStepUiBasic;

interface

uses uStepBasic;

type
  TStepUiBasic = class(TStepBasic)
  protected
    procedure CheckUserInteractive;
  public
    procedure Start; override;
  end;

implementation

{ TStepUiBasic }

procedure TStepUiBasic.CheckUserInteractive;
begin
  if TaskVar.Interactive <> 1 then
  begin
    StopExceptionRaise('必须运行在Interactive交互模式，请检查Job的Interactive属性');
  end;
end;

procedure TStepUiBasic.Start;
begin
  CheckUserInteractive;
  inherited Start;
end;

end.
