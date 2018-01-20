unit uSelectFolderForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicDlgForm, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, RzTreeVw, RzShellCtrls;

type
  TSelectFolderForm = class(TBasicDlgForm)
    rzshltrFolder: TRzShellTree;
    procedure btnOKClick(Sender: TObject);
    procedure rzshltrFolderDblClick(Sender: TObject);
  private
    procedure SetRootDir(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    SelectedPath: string;

    property RootDir: string write SetRootDir;
  end;

var
  SelectFolderForm: TSelectFolderForm;

implementation

{$R *.dfm}

procedure TSelectFolderForm.btnOKClick(Sender: TObject);
begin
  inherited;
  SelectedPath := rzshltrFolder.SelectedPathName + '\';
end;

procedure TSelectFolderForm.rzshltrFolderDblClick(Sender: TObject);
begin
  inherited;
  btnOK.Click;
end;

procedure TSelectFolderForm.SetRootDir(const Value: string);
begin
  rzshltrFolder.BaseFolder.PathName := Value;
end;

end.
