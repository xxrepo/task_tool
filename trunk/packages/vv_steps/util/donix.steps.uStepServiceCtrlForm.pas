unit donix.steps.uStepServiceCtrlForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt, RzPanel, RzRadGrp;

type
  TStepServiceCtrlForm = class(TStepBasicForm)
    dlgOpenToFileName: TOpenDialog;
    lbl3: TLabel;
    edtServiceName: TEdit;
    lbl4: TLabel;
    rzrdgrpCtrlType: TRzRadioGroup;
    pnlServiceExe: TRzPanel;
    lbl2: TLabel;
    btnServiceExeFile: TRzButtonEdit;
    lbl5: TLabel;
    edtDisplayName: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnServiceExeFileButtonClick(Sender: TObject);
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
  StepServiceCtrlForm: TStepServiceCtrlForm;

implementation

uses uDesignTimeDefines, uStepServiceCtrl;

{$R *.dfm}

procedure TStepServiceCtrlForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepServiceCtrl do
  begin
    ServiceName := edtServiceName.Text;
    CtrlType := rzrdgrpCtrlType.ItemIndex;
    ServiceExeFile := btnServiceExeFile.Text;
    DisplayName := edtDisplayName.Text;
  end;
end;

procedure TStepServiceCtrlForm.btnServiceExeFileButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenToFileName.InitialDir := ExtractFileDir(TDesignUtil.GetRealAbsolutePath(btnServiceExeFile.Text));
  if dlgOpenToFileName.Execute then
  begin
    btnServiceExeFile.Text := TDesignUtil.GetRelativePathToProject(dlgOpenToFileName.FileName);
  end;
end;

procedure TStepServiceCtrlForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepServiceCtrl;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepServiceCtrl(Step);
  btnServiceExeFile.Text := LStep.ServiceExeFile;
  edtServiceName.Text := LStep.ServiceName;
  edtDisplayName.Text := LStep.DisplayName;
  rzrdgrpCtrlType.ItemIndex := LStep.CtrlType;

  CheckCtrlType;
end;


procedure TStepServiceCtrlForm.rzrdgrpCtrlTypeClick(Sender: TObject);
begin
  inherited;
  CheckCtrlType;
end;

procedure TStepServiceCtrlForm.CheckCtrlType;
begin
  //еп╤о
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


