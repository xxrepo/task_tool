unit uVVCefFunction;

interface

uses uCEFInterfaces;

function CefValueToCefV8Value(ACefValue: ICefValue): ICefV8Value;


implementation

uses uCEFTypes, uCEFv8Value, System.Classes, uCEFConstants, uXpFunctions;


function CefValueToCefV8Value(ACefValue: ICefValue): ICefV8Value;
var
  LKeys: TStringList;
  LDictionary: ICefDictionaryValue;
  LList: ICefListValue;
  i: Integer;
begin
  case ACefValue.GetType of
    VTYPE_INVALID:
    begin
      Result := TCefv8ValueRef.NewNull;
    end;
    VTYPE_NULL:
    begin
      Result := TCefv8ValueRef.NewNull;
    end;
    VTYPE_BOOL:
    begin
      Result := TCefv8ValueRef.NewBool(ACefValue.GetBool);
    end;
    VTYPE_INT:
    begin
      Result := TCefv8ValueRef.NewInt(ACefValue.GetInt);
    end;
    VTYPE_DOUBLE:
    begin
      Result := TCefv8ValueRef.NewDouble(ACefValue.GetDouble);
    end;
    VTYPE_STRING:
    begin
      Result := TCefv8ValueRef.NewString(ACefValue.GetString)
    end;
    VTYPE_BINARY:
    begin
      Result := TCefv8ValueRef.NewNull
    end;
    VTYPE_DICTIONARY:
    begin
      Result := TXpFunction.TCefv8ValueRef_NewObject(nil, nil);

      LDictionary := ACefValue.GetDictionary;
      LKeys := TStringList.Create;
      try
        LDictionary.GetKeys(LKeys);
        for i := 0 to LKeys.Count - 1 do
        begin
          Result.SetValueByKey(LKeys[i], CefValueToCefV8Value(LDictionary.GetValue(LKeys[i])), V8_PROPERTY_ATTRIBUTE_NONE);
        end;
      finally
        LKeys.Free;
      end;
    end;
    VTYPE_LIST:
    begin
      LList := ACefValue.GetList;
      Result := TCefv8ValueRef.NewArray(LList.GetSize);
      for i := 0 to LList.GetSize - 1 do
      begin
        Result.SetValueByIndex(i, CefValueToCefV8Value(LList.GetValue(i)));
      end;
    end;
  end;
end;


end.
