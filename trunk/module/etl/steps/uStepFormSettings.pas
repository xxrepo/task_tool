unit uStepFormSettings;

interface

type
  TGridCellPickList = record
    PickList: string;
    KeyList: string;
  end;

  TStepFormSettings = class
  public
    class function GetDataSetFieldTypes: TGridCellPickList;
  end;

implementation

uses Data.DB, System.SysUtils;

{ TStepFormSettings }

class function TStepFormSettings.GetDataSetFieldTypes: TGridCellPickList;
begin
  Result.PickList := 'string' + #13#10
                       + 'int';
  Result.KeyList := IntToStr(Ord(ftString)) + #13#10
                       + IntToStr(Ord(ftInteger));
end;

end.
