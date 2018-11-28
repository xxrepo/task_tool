unit donix.job.uStepTypeSelectForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, RzLstBox, RzCommon, uStepDefines, Vcl.Grids,
  Vcl.ValEdit, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Data.DB, Datasnap.DBClient;

type
  TStepTypeSelectForm = class(TBasicDlgForm)
    dbgrdhStepTypes: TDBGridEh;
    dsStepTypes: TDataSource;
    cdsStepTypes: TClientDataSet;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbgrdhStepTypesDblClick(Sender: TObject);
  private
    procedure LoadData;
    { Private declarations }
  public
    { Public declarations }
    StepType: TStepType;
  end;

var
  StepTypeSelectForm: TStepTypeSelectForm;

implementation

uses uDefines, uFunctions, uStepFactory;

{$R *.dfm}

procedure TStepTypeSelectForm.btnOKClick(Sender: TObject);
begin
  inherited;
  if cdsStepTypes.Active and (cdsStepTypes.RecordCount > 0) then
  begin
    StepType := cdsStepTypes.FieldByName('step_type').AsString;
  end;
end;

procedure TStepTypeSelectForm.dbgrdhStepTypesDblClick(Sender: TObject);
begin
  inherited;
  if cdsStepTypes.Active and (cdsStepTypes.RecordCount > 0) then
  begin
    StepType := cdsStepTypes.FieldByName('step_type').AsString;
    ModalResult := mrOk;
  end;
end;

procedure TStepTypeSelectForm.FormCreate(Sender: TObject);
begin
  inherited;
  LoadData;
end;


procedure TStepTypeSelectForm.LoadData;
begin
  JsonToDataSet(TStepFactory.GetSysStepDefinesStr, cdsStepTypes);
end;


end.
