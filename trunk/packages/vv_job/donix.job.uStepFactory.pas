unit donix.job.uStepFactory;

interface

uses
  uStepDefines, uStepBasicForm, uStepBasic, System.Classes, System.JSON, uTaskVar, System.SysUtils;

type
  TStepRegisterRec = record
    StepGroup: string;
    StepTypeId: Integer;
    StepType: TStepType;
    StepTypeName: string;
    StepClassName: string;
    StepClass: TStepClass;
    FormClassName: string;
    FormClass: TStepFormClass;
  end;

  TRegisteredStepInfo = class
  public
    StepGroup: string;
    StepTypeId: Integer;
    StepType: TStepType;
    StepTypeName: string;
    StepClassName: string;
    StepClass: TStepClass;
    FormClassName: string;
    FormClass: TStepFormClass;

    constructor Create(AStepRegisterRec: TStepRegisterRec);
    destructor Destroy; override;
  end;

  TStepFactory = class
  private
    class procedure UnRegisterSteps; static;
  protected
    class function GetSysStepDefines: TJSONArray;
    class procedure FinalizeParams; static;
    class procedure InitParams; static;
  public
    class function GetSysStepDefinesStr: string;
    class function RegsiterStep(AStepRegisterRec: TStepRegisterRec): Integer; static;
    class function GetStepDefine(AStepType: TStepType): TStepDefine; static;
    class function GetStepSettingForm(AStepType: TStepType;
      ATaskVar: TTaskVar): TStepBasicForm; static;
    class function GetStep(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasic; overload;
  end;

implementation

uses
  uFunctions, uDefines;

var
  SysSteps: TJSONArray;
  RegisteredSteps: TStringList;


{ TStepFactory }
class procedure TStepFactory.InitParams;
begin
  if SysSteps = nil then
  begin
    SysSteps := TJSONArray.Create;
  end;
  if RegisteredSteps = nil then
  begin
    RegisteredSteps := TStringList.Create(False);
  end;
end;

class function TStepFactory.RegsiterStep(AStepRegisterRec: TStepRegisterRec): Integer;
var
  LRowJson: TJSONObject;
  LRegisteredStep: TRegisteredStepInfo;
begin
  LRegisteredStep := TRegisteredStepInfo.Create(AStepRegisterRec);
  RegisteredSteps.AddObject(AStepRegisterRec.StepType, LRegisteredStep);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', AStepRegisterRec.StepGroup));
  LRowJson.AddPair(TJSONPair.Create('step_type', AStepRegisterRec.StepType));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', AStepRegisterRec.StepTypeName));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', AStepRegisterRec.StepClassName));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', AStepRegisterRec.FormClassName));
  SysSteps.AddElement(LRowJson);
end;

class procedure TStepFactory.UnRegisterSteps;
begin

end;

class procedure TStepFactory.FinalizeParams;
var
  i: Integer;
  LRegisteredStep: TRegisteredStepInfo;
begin
  if SysSteps <> nil then
    SysSteps.Free;
  //释放所有对象
  for i := RegisteredSteps.Count - 1 downto 0 do
  begin
    LRegisteredStep := TRegisteredStepInfo(RegisteredSteps.Objects[i]);
    if LRegisteredStep <> nil then
    begin
      LRegisteredStep.Free;
    end;
    RegisteredSteps.Delete(i);
  end;
  RegisteredSteps.Free;
end;

class function TStepFactory.GetStep(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasic;
var
  LClass: TPersistentClass;
  LStepDefine: TStepDefine;
begin
  Result := nil;
  if ATaskVar = nil then Exit;
  
  LStepDefine := GetStepDefine(AStepType);
  LClass := GetClass(LStepDefine.StepClassName);
  if LClass <> nil then
  begin
    Result := LClass.NewInstance as TStepBasic;
    Result := Result.Create(ATaskVar);
  end
  else
  begin
    //进行错误日志记录

  end;
end;


class function TStepFactory.GetStepDefine(AStepType: TStepType): TStepDefine;
var
  i: Integer;
  LRow: TJSONObject;
begin
  Result.StepTypeId := 0;
  Result.StepType := '';
  Result.StepTypeName := '';
  Result.StepClassName := '';
  Result.FormClassName := '';

  if AStepType = '' then
  begin
    raise Exception.Create('配置的StepType为空');
  end;

  if SysSteps = nil then Exit;


  //从列表中读取
  for I := 0 to SysSteps.Count - 1 do
  begin
    LRow := SysSteps.Items[i] as TJSONObject;
    if LRow = nil then Continue;

    if GetJsonObjectValue(LRow, 'step_type', '') = AStepType then
    begin
      Result.StepTypeId := StrToIntDef(GetJsonObjectValue(LRow, 'step_type_id', '0'), 0);
      Result.StepType := AStepType;
      Result.StepTypeName := GetJsonObjectValue(LRow, 'step_type_name', '');
      Result.StepClassName := GetJsonObjectValue(LRow, 'step_class_name', '');
      Result.FormClassName := GetJsonObjectValue(LRow, 'form_class_name', '');
    end;
  end;
end;

class function TStepFactory.GetStepSettingForm(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasicForm;
var
  LClass: TPersistentClass;
  LStepDefine: TStepDefine;
begin
  Result := nil;

  //寻找对应的类参数
  LStepDefine := GetStepDefine(AStepType);

  LClass := GetClass(LStepDefine.FormClassName);
  if LClass <> nil then
  begin
    Result := LClass.NewInstance as TStepBasicForm;
    Result := Result.Create(nil);
    Result.TaskVar := ATaskVar;
    //Result.Step := Self.GetStep(AStepType, ATaskVar);
    Result.edtStepTitle.Text := LStepDefine.StepTypeName;
  end;
end;


class function TStepFactory.GetSysStepDefines: TJSONArray;
begin
  if SysSteps = nil then
    GetSysStepDefinesStr;
  Result := SysSteps;
end;


class function TStepFactory.GetSysStepDefinesStr: string;
var
  LRowJson: TJSONObject;
begin
  Result := '';
  if SysSteps <> nil then
  begin
    Result := SysSteps.ToJSON;
  end;
end;


{ TRegisteredStepInfo }

constructor TRegisteredStepInfo.Create(AStepRegisterRec: TStepRegisterRec);
begin
  StepGroup := AStepRegisterRec.StepGroup;
  StepTypeId := AStepRegisterRec.StepTypeId;
  StepType := AStepRegisterRec.StepType;
  StepTypeName := AStepRegisterRec.StepTypeName;
  StepClassName := AStepRegisterRec.StepClassName;
  StepClass := AStepRegisterRec.StepClass;
  FormClassName := AStepRegisterRec.FormClassName;
  FormClass := AStepRegisterRec.FormClass;

  RegisterClass(StepClass);
  RegisterClass(FormClass);
end;

destructor TRegisteredStepInfo.Destroy;
begin
  UnRegisterClass(StepClass);
  UnRegisterClass(FormClass);
  inherited;
end;

initialization
TStepFactory.InitParams;

finalization
TStepFactory.FinalizeParams;

end.
