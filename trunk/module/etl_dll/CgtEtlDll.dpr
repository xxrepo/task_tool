library CgtEtlDll;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Dialogs,
  uEntryForm in 'uEntryForm.pas' {TEntryForm};

{$R *.res}


function GetMax( X , Y : integer ) : integer ; stdcall ;
begin
  if X > Y then
    Result := X
  else
    Result := Y ;
end;

procedure ShowMsg(AMsg: PChar); stdcall;
begin
  ShowMessage(AMsg);
end;


procedure ShowForm(AParams: PChar); stdcall;
begin
  with TEntryForm.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;


exports
GetMax,
ShowMsg,
ShowForm;

begin
end.
