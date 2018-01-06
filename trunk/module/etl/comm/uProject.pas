//注意：本单元仅仅用于设计时态对于各种资料的处理
unit uProject;

interface

type
  TProjectConfigRec = record
    ProjectName: string;
    RootPath: string;
    DbsFile: string;
    JobsFile: string;
  end;

  TProjectUtil = class
  public
    class function GetConfigFrom(APath: string): TProjectConfigRec;
  end;


implementation

uses System.SysUtils, System.Classes, System.JSON, uFunctions;

{ TProjectUtil }

class function TProjectUtil.GetConfigFrom(APath: string): TProjectConfigRec;
begin
  if not DirectoryExists(APath) then Exit;

  if APath[Length(APath)] <> '\' then
    APath := APath + '\';

  Result.ProjectName := ExtractFileName(APath);
  Result.RootPath := APath;
  Result.DbsFile := APath + 'project.dbs';
  Result.JobsFile := APath + 'project.jobs';
end;


end.
