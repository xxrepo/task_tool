unit uGlobalVarSettingForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh,
  DBGridEh, Vcl.ExtCtrls, RzPanel, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls,
  Data.DB, Datasnap.DBClient;

type
  TGlobalVarSettingForm = class(TBasicForm)
    rzpnl1: TRzPanel;
    rzpnl2: TRzPanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lbl1: TLabel;
    dbgrdhInputParams: TDBGridEh;
    dbnvgrParams: TDBNavigator;
    dsParams: TDataSource;
    cdsParams: TClientDataSet;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FileName: string;
  public
    { Public declarations }
    procedure ConfigGlobalVar(AVarFileName: string);
  end;

var
  GlobalVarSettingForm: TGlobalVarSettingForm;

implementation

uses uFunctions, uThreadSafeFile;

{$R *.dfm}

{ TGlobalVarSettingForm }

procedure TGlobalVarSettingForm.btnOKClick(Sender: TObject);
begin
  inherited;
  //±£¥Ê
  TThreadSafeFile.WriteContentTo(FileName, DataSetToJsonStr(cdsParams));
end;

procedure TGlobalVarSettingForm.ConfigGlobalVar(AVarFileName: string);
begin
  //º”‘ÿ
  FileName := AVarFileName;
  JsonToDataSet(TThreadSafeFile.ReadContentFrom(FileName, '[]'), cdsParams);
end;

end.
