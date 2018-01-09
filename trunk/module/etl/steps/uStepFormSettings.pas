unit uStepFormSettings;

interface

uses uTaskVar;

type
  TGridCellPickList = record
    PickList: string;
    KeyList: string;
  end;

  TStepFormSettings = class
  private

  public
    class function GetDataSetFieldTypes: TGridCellPickList; static;
    class function GetRegistedObjectStrings(ATaskVar: TTaskVar): TGridCellPickList; static;
  end;

implementation

uses Data.DB, System.SysUtils, uStepBasic;

{ TStepFormSettings }

class function TStepFormSettings.GetDataSetFieldTypes: TGridCellPickList;
begin
  Result.PickList := 'string' + #13#10
                       + 'int';
  Result.KeyList := IntToStr(Ord(ftString)) + #13#10
                       + IntToStr(Ord(ftInteger));
end;


class function TStepFormSettings.GetRegistedObjectStrings(ATaskVar: TTaskVar): TGridCellPickList;
var
  i: Integer;
begin
  for i := 0 to ATaskVar.RegistedObjectList.Count - 1 do
  begin
    Result.PickList := Result.PickList + 'task.' + ATaskVar.RegistedObjectList.Strings[i];
    if i < ATaskVar.RegistedObjectList.Count - 1 then
    begin
      Result.PickList := Result.PickList + #13#10;
    end;
  end;

end;

end.
