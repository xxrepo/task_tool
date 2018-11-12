unit uSettingForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, RzTabs, Vcl.ExtCtrls,
  RzPanel;

type
  TSettingsForm = class(TBasicForm)
    rzpgcntrlSettings: TRzPageControl;
    rzpnl1: TRzPanel;
    rztbshtCommon: TRzTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

end.
