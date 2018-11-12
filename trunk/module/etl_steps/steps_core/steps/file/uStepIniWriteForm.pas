unit uStepIniWriteForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uStepBasicForm, Vcl.StdCtrls, RzTabs,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, RzEdit, RzBtnEdt,
  Data.DB, Datasnap.DBClient, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.DBCtrls, System.IniFiles;

type
  TStepIniWriteForm = class(TStepBasicForm)
    lbl2: TLabel;
    btnIniFileName: TRzButtonEdit;
    dlgOpenFileName: TOpenDialog;
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    lblParams: TLabel;
    btnGetValues: TBitBtn;
    dbnvgrParams: TDBNavigator;
    dbgrdhInputParams: TDBGridEh;
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
  StepIniWriteForm: TStepIniWriteForm;

implementation

uses uStepIniWrite, uFunctions, uDesignTimeDefines;

{$R *.dfm}

procedure TStepIniWriteForm.btnOKClick(Sender: TObject);
begin
  inherited;
  with Step as TStepIniWrite do
  begin
    FileName := btnIniFileName.Text;
    FieldParams := DataSetToJsonStr(cdsParams);
  end;
end;

procedure TStepIniWriteForm.btnClearParamsClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('您真的要清空所有参数吗？', MB_OKCANCEL) = mrOK then
    cdsParams.EmptyDataSet;
end;

procedure TStepIniWriteForm.btnGetValuesClick(Sender: TObject);
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
          cdsParams.FieldByName('param_name').AsString := LSections.Strings[i]
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

procedure TStepIniWriteForm.btnIniFileNameButtonClick(Sender: TObject);
begin
  inherited;
  dlgOpenFileName.InitialDir := ExtractFileDir(btnIniFileName.Text);
  if dlgOpenFileName.Execute then
  begin
    btnIniFileName.Text := TDesignUtil.GetRelativePathToProject(dlgOpenFileName.FileName);
  end;
end;

procedure TStepIniWriteForm.ParseStepConfig(AConfigJsonStr: string);
var
  LStep: TStepIniWrite;
begin
  inherited ParseStepConfig(AConfigJsonStr);

  LStep := TStepIniWrite(Step);
  btnIniFileName.Text := LStep.FileName;
  JsonToDataSet(LStep.FieldParams, cdsParams);
end;

initialization
RegisterClass(TStepIniWriteForm);

finalization
UnRegisterClass(TStepIniWriteForm);

end.


