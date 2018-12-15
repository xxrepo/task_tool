unit donix.steps.uStepExeCtrlForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt, RzPanel, RzRadGrp;

type
  TStepExeCtrlForm = class(TStepBasicForm)
    dlgOpenToFileName: TOpenDialog;
    lbl4: TLabel;
    rzrdgrpCtrlType: TRzRadioGroup;
    lbl2: TLabel;
    btnExeFile: TRzButtonEdit;
    pnlServiceExe: TRzPanel;
    edtStartArgs: TEdit;
    lbl3: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnExeFileButtonClick(Sender: TObject);
    procedure rzrdgrpCtrlTypeClick(Sender: TObject);
  private
    procedure CheckCtrlType;
    { Private declarations }
  protected


  public
    { Public declarations }
     procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepExeCtrlForm: TStepExeCtrlForm;

implementation

uses uDesignTimeDefines, uStepExeCtrl;

{$R *.dfm}

procedure TStepExeCtrlForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepExeCtrl do
  begin
    CtrlType := rzrdgrpCtrlType.ItemIndex;
    ExeFile := btnExeFile.Text;
    StartArgs := edtStartArgs.Text;
  end;
end;

procedure TStepExeCtrlForm.btnExeFileButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenToFileName.InitialDir := ExtractFileDir(TDesignUtil.GetRealAbsolutePath(btnExeFile.Text));
  if dlgOpenToFileName.Execute then
  begin
    btnExeFile.Text := TDesignUtil.GetRelativePathToProject(dlgOpenToFileName.FileName);
  end;
end;

procedure TStepExeCtrlForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepExeCtrl;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepExeCtrl(Step);
  btnExeFile.Text := LStep.ExeFile;
  edtStartArgs.Text := LStep.StartArgs;
  rzrdgrpCtrlType.ItemIndex := LStep.CtrlType;

  CheckCtrlType;
end;


procedure TStepExeCtrlForm.rzrdgrpCtrlTypeClick(Sender: TObject);
begin
  inherited;
  CheckCtrlType;
end;

procedure TStepExeCtrlForm.CheckCtrlType;
begin
  if rzrdgrpCtrlType.ItemIndex = 0 then
  begin
    pnlServiceExe.Visible := True;
  end
  else
  begin
    pnlServiceExe.Visible := False;
  end;
end;


end.


