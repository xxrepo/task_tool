unit uXpFunctions;

interface

uses
  uCEFInterfaces, uCEFv8Value;

type
  TXpFunction = class
  public
    class function TCefv8ValueRef_NewObject(const Accessor: ICefV8Accessor; const AObj: TObject): ICefv8Value;
  end;

implementation


{ TXpFunction }

class function TXpFunction.TCefv8ValueRef_NewObject(
  const Accessor: ICefV8Accessor; const AObj: TObject): ICefv8Value;
begin
  {$IFDEF XP_2623}
  Result := TCefv8ValueRef.NewObject(Accessor);
  {$ELSE}
  Result := TCefv8ValueRef.NewObject(Accessor, nil);
  {$ENDIF}
end;

end.
