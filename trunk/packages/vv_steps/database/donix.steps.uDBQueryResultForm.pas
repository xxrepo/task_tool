unit donix.steps.uDBQueryResultForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, RzSplit, Vcl.ExtCtrls,
  RzPanel, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  EhLibVCL, GridsEh, DBAxisGridsEh, DBGridEh, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Buttons, Data.DB, MemDS, DBAccess, Uni, uDbConMgr;

type
  TDBQueryResultForm = class(TBasicForm)
    rzpnlTop: TRzPanel;
    rzspltrMain: TRzSplitter;
    redtSQL: TRichEdit;
    rzpnlResult: TRzPanel;
    dbgrdhResult: TDBGridEh;
    btnExecute: TBitBtn;
    lblMsg: TLabel;
    unqrySql: TUniQuery;
    dsSql: TDataSource;
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DBConTitle: string;
    DBConMgr: TDbConMgr;

    procedure ExecuteSql;
  end;

var
  DBQueryResultForm: TDBQueryResultForm;

implementation

{$R *.dfm}

{ TDBQueryResultForm }

procedure TDBQueryResultForm.btnExecuteClick(Sender: TObject);
begin
  inherited;
  ExecuteSql;
end;

procedure TDBQueryResultForm.ExecuteSql;
begin
  if unqrySql.Active then
    unqrySql.Close;
  try
    unqrySql.Connection := DBConMgr.GetDBConnection(DBConTitle);
    unqrySql.SQL.Text := redtSQL.Lines.Text;
    unqrySql.Prepare;
    unqrySql.Open;

    lblMsg.Caption := '执行成功，数据记录：' + IntToStr(unqrySql.RecordCount);
  except
    on E: Exception do
      lblMsg.Caption := '执行失败：' + E.Message;
  end;
end;

end.
