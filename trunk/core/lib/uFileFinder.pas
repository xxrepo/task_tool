unit uFileFinder;

interface

uses
  SysUtils;

type
  TVVFileFoundEvent = procedure (aFileName: string; AFinder: TObject) of object;
  TVVFolderFoundEvent = procedure (aFolderName: string; var ARecursive: Boolean; AFinder: TObject) of object;

  TVVFileFinder = class
  private
    FDir: string;
    FRecursive: Boolean;
    FCurrentName: string;
    FOnFileFound: TVVFileFoundEvent;
    FOnFolderFound: TVVFolderFoundEvent;
  protected
    procedure doFind(aDir: string);
  public
    constructor Create;

    procedure Find;
    property Dir: string read FDir write FDir;
    property Recursive: Boolean read FRecursive write FRecursive default True;
    property CurrentName: string read FCurrentName;
    property OnFileFound: TVVFileFoundEvent read FOnFileFound write FOnFileFound;
    property OnFolderFound: TVVFolderFoundEvent read FOnFolderFound write FOnFolderFound;
  end;

implementation

{ TVVFileFinder }

constructor TVVFileFinder.Create;
begin
  FRecursive := True;
end;

procedure TVVFileFinder.doFind(aDir: string);
var
  fr: Integer;
  aRes: TSearchRec;
  aFileName: string;
  ARecursive: Boolean;
begin
  if aDir[Length(aDir)]<>'\' then
    aDir:=aDir+'\';
  fr:= FindFirst(aDir+'*.*',faAnyFile, aRes);
  while fr=0 do
  begin
    // 当前正在处理的文件或者文件夹的名称
    FCurrentName := aRes.Name;
    if (aRes.Attr and faDirectory)<>0 then
    begin
      if (aRes.Name<>'.') and (aRes.Name<>'..') then
      begin
        ARecursive := True;
        if Assigned(FOnFolderFound) then
        begin
          FOnFolderFound(aDir + aRes.Name, ARecursive, Self);
        end;

        if ARecursive and FRecursive then
        begin
          doFind(aDir+aRes.Name);
        end;
      end;
    end
    else
    begin
      aFileName := aDir+aRes.Name;
      if Assigned(FOnFileFound) then
        FOnFileFound(aFileName, Self);
    end;
    fr:=FindNext(aRes);
  end;
  FindClose(aRes);
end;

procedure TVVFileFinder.Find;
begin
  if DirectoryExists(FDir) then
  begin
    doFind(FDir);
  end;
end;

end.
