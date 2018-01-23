unit uStepFormFactory;

interface

uses
  uStepDefines, uStepBasic, System.Classes, System.JSON, uTaskVar, System.SysUtils, uStepFactory, uStepBasicForm;

type
  TStepFormFactory = class(TStepFactory)
  protected

  public
    class function GetStepSettingForm(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasicForm; overload;
  end;

implementation

uses
  uFunctions, uDefines,
  uStepFieldsOperForm
   , uStepHttpRequestForm
   , uStepIniReadForm
   , uStepIniWriteForm
   , uStepQueryForm
   , uStepWriteTxtFileForm
   , uStepDatasetSpliterForm
   , uStepSubTaskForm
   , uStepConditionForm
   , uStepJson2DataSetForm
   , uStepFastReportForm
   , uStepTaskResultForm
   , uStepVarDefineForm;

class function TStepFormFactory.GetStepSettingForm(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasicForm;
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

end.
