unit uStepFolderCtrlForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt, RzPanel, RzRadGrp;

type
  TStepFolderCtrlForm = class(TStepBasicForm)
    lbl4: TLabel;
    rzrdgrpCtrlType: TRzRadioGroup;
    lbl2: TLabel;
    btnFolder: TRzButtonEdit;
    pnlServiceExe: TRzPanel;
    lbl3: TLabel;
    btnToFolder: TRzButtonEdit;
    chkChildrenOnly: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnFolderButtonClick(Sender: TObject);
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
  StepFolderCtrlForm: TStepFolderCtrlForm;

implementation

uses uDesignTimeDefines, uDefines, uStepFolderCtrl, uSelectFolderForm;

{$R *.dfm}

procedure TStepFolderCtrlForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepFolderCtrl do
  begin
    CtrlType := rzrdgrpCtrlType.ItemIndex;
    Folder := btnFolder.Text;
    ToFolder := btnToFolder.Text;
    ChildrenOnly := chkChildrenOnly.Checked;
  end;
end;

procedure TStepFolderCtrlForm.btnFolderButtonClick(Sender: TObject);
begin
  inherited;
  with TSelectFolderForm.Create(nil) do
  try
    RootDir := ExePath;
    if ShowModal = mrOk then
    begin
       (Sender as TRzButtonEdit).Text := TDesignUtil.GetRelativePathToProject(SelectedPath);
    end;
  finally
    Free;
  end;
end;




procedure TStepFolderCtrlForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepFolderCtrl;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepFolderCtrl(Step);
  btnFolder.Text := LStep.Folder;
  btnToFolder.Text := LStep.ToFolder;
  chkChildrenOnly.Checked := LStep.ChildrenOnly;
  rzrdgrpCtrlType.ItemIndex := LStep.CtrlType;

  CheckCtrlType;
end;


procedure TStepFolderCtrlForm.rzrdgrpCtrlTypeClick(Sender: TObject);
begin
  inherited;
  CheckCtrlType;
end;

procedure TStepFolderCtrlForm.CheckCtrlType;
begin
  case rzrdgrpCtrlType.ItemIndex of
    3:
    begin
      pnlServiceExe.Visible := True;
    end;
    4:
    begin
      pnlServiceExe.Visible := True;
    end
    else
    begin
      pnlServiceExe.Visible := False;
    end;
  end;
end;

initialization
RegisterClass(TStepFolderCtrlForm);

finalization
UnRegisterClass(TStepFolderCtrlForm);

end.


