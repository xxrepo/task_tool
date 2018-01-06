unit uFileCleaner;

interface

uses uFileFinder, System.Classes, System.IOUtils;

type
  TFileCleaner = class
  private
    FFileFinder: TVVFileFinder;
    FFilterList: TStringList;
    procedure SetFilter(const Value: string);
    function GetFilter: string;
  public
    Dir: string;
    CleanBeforeTime: Integer;

    property Filter: string  read GetFilter write SetFilter;
    procedure OnFileFound(AFileName: string);

    procedure Clean;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, System.DateUtils;

{ TFileCleaner }

constructor TFileCleaner.Create;
begin
  inherited;
  CleanBeforeTime := 604800; //7天

  FFilterList := TStringList.Create;
  FFilterList.Delimiter := ';';

  FFileFinder := TVVFileFinder.Create;
  FFileFinder.OnFileFound := OnFileFound;
end;

destructor TFileCleaner.Destroy;
begin
  FFileFinder.Free;
  FFilterList.Free;
  inherited;
end;


function TFileCleaner.GetFilter: string;
begin
  Result := FFilterList.DelimitedText;
end;

procedure TFileCleaner.Clean;
begin
  FFileFinder.Recursive := True;
  FFileFinder.Dir := Dir;
  FFileFinder.Find;
end;

procedure TFileCleaner.OnFileFound(AFileName: string);
var
  LExt: string;
begin
  //获取文件后缀是否是log
  LExt := ExtractFileExt(AFileName);
  if FFilterList.IndexOf(LExt) = -1  then Exit;

  if CleanBeforeTime > 0 then
  begin
    if SecondsBetween(Now, TFile.GetLastWriteTime(AFileName)) <= CleanBeforeTime then
    begin
      Exit;
    end;
  end;

  try
    TFile.Delete(AFileName);
  finally

  end;
end;

procedure TFileCleaner.SetFilter(const Value: string);
begin
  FFilterList.DelimitedText := Value;
end;

end.
