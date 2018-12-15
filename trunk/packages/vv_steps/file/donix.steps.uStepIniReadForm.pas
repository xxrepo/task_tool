unit donix.steps.uStepIniReadForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepIniReadForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnIniFileName: TRzButtonEdit;
    dlgOpenFileName: TOpenDialog;
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    lblParams: TLabel;
    dbgrdhInputParams: TDBGridEh;
    btnGetValues: TBitBtn;
    dbnvgrParams: TDBNavigator;
    btnClearParams: TBitBtn;
    procedure btnOKClick(Sender: TObject);
    procedure btnIniFileNameButtonClick(Sender: TObject);
    procedure btnGetValuesClick(Sender: TObject);
    procedure btnClearParamsClick(Sender: TObject);
  private

    { Private declarations }
  protected

  public
    { Public declarations }
    procedure ParseStepConfig(AConfigJsonStr: string); override;
  end;

var
  StepIniReadForm: TStepIniReadForm;

implementation

uses uStepIniRead, uFunctions, uDesignTimeDefines, uProject;

{$R *.dfm}

procedure TStepIniReadForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepIniRead do
  begin
    FileName := btnIniFileName.Text;
    FieldParams := DataSetToJsonStr(cdsParams);
  end;
end;

procedure TStepIniReadForm.btnClearParamsClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('您真的要清空所有参数吗？', MB_OKCANCEL) = mrOK then
    cdsParams.EmptyDataSet;
end;

procedure TStepIniReadForm.btnGetValuesClick(Sender: TObject);
var
  LFileName: string;
  LIniFile: TIniFile;
  LSections, LSectionStrings: TStringList;
  i, j: Integer;
begin
  inherited;
  LFileName := TDesignUtil.GetRealAbsolutePath(btnIniFileName.Text);
  if FileExists(LFileName) then
  begin
    //对ini文件进行分析处理，逐个添加到列表字段中
    LIniFile := TIniFile.Create(LFileName);
    LSections := TStringList.Create;
    LSectionStrings := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to LSections.Count - 1 do
      begin
        LIniFile.ReadSection(LSections.Strings[i], LSectionStrings);
        for j := 0 to LSectionStrings.Count - 1 do
        begin
          cdsParams.Append;
          cdsParams.FieldByName('param_value_ref').AsString := 'self.' + LSections.Strings[i]
                              + '.' + LSectionStrings.Strings[j];
          cdsParams.FieldByName('param_type').AsString := 'string';
          cdsParams.FieldByName('default_value').AsString := '';
          cdsParams.Post;
        end;
      end;
    finally
      LSectionStrings.Free;
      LSections.Free;
      LIniFile.Free;
    end;
  end;
end;

procedure TStepIniReadForm.btnIniFileNameButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenFileName.InitialDir := ExtractFileDir(btnIniFileName.Text);
  if dlgOpenFileName.Execute then
  begin
    btnIniFileName.Text := TDesignUtil.GetRelativePathToProject(dlgOpenFileName.FileName);
  end;
end;

procedure TStepIniReadForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepIniRead;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepIniRead(Step);
  btnIniFileName.Text := LStep.FileName;
  JsonToDataSet(LStep.FieldParams, cdsParams);
end;


end.


