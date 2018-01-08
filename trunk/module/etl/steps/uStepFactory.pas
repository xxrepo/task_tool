unit uStepFactory;

interface

uses
  uStepDefines, uStepBasic, System.Classes, System.JSON, uTaskVar, System.SysUtils;

type
  TStepFactory = class
  protected
    class function GetSysStepDefines: TJSONArray;
    class function GetStepDefine(AStepType: TStepType): TStepDefine; static;
  public
    class function GetSysStepDefinesStr: string;
    class function GetStep(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasic; overload;
  end;

implementation

uses
  uFunctions, uDefines,
  uStepFieldsOper,
  uStepHttpRequest,
  uStepIniRead,
  uStepIniWrite,
  uStepQuery,
  uStepWriteTxtFile,
  uStepDatasetSpliter,
  uStepSubTask,
  uStepCondition,
  uStepVarDefine,
  uStepFileDelete,
  uStepJsonDataSet;

var
  SysSteps: TJSONArray;


{ TStepFactory }


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
    //走case形式
    case LStepDefine.StepTypeId of
      10010:
      begin
        Result := TStepNull.Create(ATaskVar);
      end;
      10020:
      begin
        Result := TStepSubTask.Create(ATaskVar);
      end;
      20010:
      begin
        Result := TStepQuery.Create(ATaskVar);
      end;
      30010:
      begin
        Result := TStepFieldsOper.Create(ATaskVar);
      end;
      30020:
      begin
        Result := TStepDatasetSpliter.Create(ATaskVar);
      end;
      30030:
      begin
        Result := TStepJsonDataSet.Create(ATaskVar);
      end;
      40010:
      begin
        Result := TStepIniRead.Create(ATaskVar);
      end;
      40011:
      begin
        Result := TStepIniWrite.Create(ATaskVar);
      end;
      40020:
      begin
        Result := TStepWriteTxtFile.Create(ATaskVar);
      end;
      40030:
      begin
        Result := TStepFileDelete.Create(ATaskVar);
      end;
      50010:
      begin
        Result := TStepHttpRequest.Create(ATaskVar);
      end;
      60010:
      begin
        Result := TStepCondition.Create(ATaskVar);
      end;
      60020:
      begin
        Result := TStepVarDefine.Create(ATaskVar);
      end;
    end;
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
  

  GetSysStepDefinesStr;

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
  if SysSteps <> nil then
  begin
    Result := SysSteps.ToJSON;
    Exit;
  end;
  
  SysSteps := TJSONArray.Create;

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'COMMON_NULL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '10010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '空组件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepNull'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepNullForm'));
  SysSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'COMMON_SUB_TASK'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '10020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '子任务'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepSubTask'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepSubTaskForm'));
  SysSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'VAR_DEFININITION'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '变量定义'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepVarDefine'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepVarDefineForm'));
  SysSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'CONTROL_CONDITION'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '条件判断'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepCondition'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepConditionForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据库'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DB_SQLQUERY'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '20010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'SQL_Query'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepQuery'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepQueryForm'));
  SysSteps.AddElement(LRowJson);



  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DATASET_FILEDS_OPER'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '字段处理'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFieldsOper'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFieldsOperForm'));
  SysSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DATASET_SPLITER'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '数据集拆分'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepDatasetSpliter'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepDatasetSpliterForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DATASET_JSON2DATASET'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'JSON转数据集'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepJsonDataSet'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepJsonDataSetForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_READ_INI'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '读INI文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepIniRead'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepIniReadForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_WRITE_INI'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40011'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '写INI文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepIniWrite'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepIniWriteForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_WRITE_TEXT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '写Txt文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepWriteTxtFile'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepWriteTxtFileForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_DELETE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '删除文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFileDelete'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFileDeleteForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '网络'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'NET_HTTP_REQUEST'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '50010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Http_Request_请求'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepHttpRequest'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepHttpRequestForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '报表打印'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'PRINT_FASTREPORT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '70010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'FastReport打印'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepHttpRequest'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepHttpRequestForm'));
  SysSteps.AddElement(LRowJson);


  Result := SysSteps.ToJSON;
end;


initialization

finalization
if SysSteps <> nil then
  SysSteps.Free;

end.
