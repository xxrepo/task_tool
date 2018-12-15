unit donix.steps.uStepHttpRequestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepHttpRequestForm = class(TStepBasicForm)
    lbl2: TLabel;
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    lblParams: TLabel;
    dbnvgrParams: TDBNavigator;
    lbl3: TLabel;
    rbGet: TRadioButton;
    rbPost: TRadioButton;
    rztbshtResponse: TRzTabSheet;
    dbgrdhInputParams: TDBGridEh;
    cdsRspParams: TClientDataSet;
    dsRspParams: TDataSource;
    dbgrdh1: TDBGridEh;
    dbnvgr1: TDBNavigator;
    lbl4: TLabel;
    mmoUrl: TMemo;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  protected

  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepHttpRequestForm: TStepHttpRequestForm;

implementation

uses uStepHttpRequest, uFunctions, uDesignTimeDefines;

{$R *.dfm}

procedure TStepHttpRequestForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepHttpRequest do
  begin
    Url := mmoUrl.Text;
    if rbGet.Checked then
      RequestMethod := 'GET'
    else
      RequestMethod := 'POST';
    RequestParams := DataSetToJsonStr(cdsParams);
    ResponseParams := DataSetToJsonStr(cdsRspParams);
  end;
end;

procedure TStepHttpRequestForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepHttpRequest;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepHttpRequest(Step);
  mmoUrl.Text := LStep.Url;
  if LStep.RequestMethod = 'GET' then
    rbGet.Checked := True
  else
    rbPost.Checked := True;
  JsonToDataSet(LStep.RequestParams, cdsParams);
  JsonToDataSet(LStep.ResponseParams, cdsRspParams);
end;

end.


