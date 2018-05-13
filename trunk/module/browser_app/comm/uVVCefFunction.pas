unit uVVCefFunction;

interface

uses uCEFTypes, uCEFConstants, uCEFMiscFunctions, uCEFInterfaces;

function CefValueToCefV8Value(ACefValue: ICefValue): ICefV8Value;
function CefV8ValueToCefValue(ACefV8Value: ICefV8Value): ICefValue;
function CefValueToJsonString(ACefValue: ICefValue; AOptions: TCefJsonWriterOptions = JSON_WRITER_DEFAULT): string;



implementation

uses uCEFv8Value, System.Classes, uXpFunctions, uCEFValue,
uCEFDictionaryValue, uCEFListValue;


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


function CefV8ValueToCefValue(ACefV8Value: ICefV8Value): ICefValue;
var
  LKeys: TStringList;
  LDictionary: ICefDictionaryValue;
  LList: ICefListValue;
  i: Integer;
begin
  Result := TCefValueRef.New;
  Result.SetNull;
  if ACefV8Value.IsBool then
    if ACefV8Value.GetBoolValue then
      Result.SetBool(1)
    else
      Result.SetBool(0)
  else if ACefV8Value.IsInt then
    Result.SetInt(ACefV8Value.GetIntValue)
  else if ACefV8Value.IsUInt then
    Result.SetInt(ACefV8Value.GetUIntValue)
  else if ACefV8Value.IsDouble then
    Result.SetDouble(ACefV8Value.GetDoubleValue)
  else if ACefV8Value.IsString then
    Result.SetString(ACefV8Value.GetStringValue)
  else if ACefV8Value.IsObject then
  begin
    //×ª³ÉjsonObject
    LKeys := TStringList.Create;
    try
      LDictionary := TCefDictionaryValueRef.New;
      ACefV8Value.GetKeys(LKeys);
      for i := 0 to LKeys.Count - 1 do
      begin
        LDictionary.SetValue(LKeys.Strings[i], CefV8ValueToCefValue(ACefV8Value.GetValueByKey(LKeys.Strings[i])));
      end;
      Result.SetDictionary(LDictionary);
    finally
      LKeys.Free;
    end;
  end
  else if ACefV8Value.IsArray then
  begin
    LList := TCefListValueRef.New;
    for i := 0 to ACefV8Value.GetArrayLength - 1 do
    begin
      LList.SetValue(i, CefV8ValueToCefValue(ACefV8Value.GetValueByIndex(i)));
    end;
    Result.SetList(LList);
  end;
end;



function CefValueToJsonString(ACefValue: ICefValue; AOptions: TCefJsonWriterOptions = JSON_WRITER_DEFAULT): string;
begin
  Result := CefWriteJson(ACefValue, AOptions);
end;


end.
