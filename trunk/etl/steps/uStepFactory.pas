unit uStepFactory;

interface

uses
  uStepDefines, uStepBasic, System.Classes, System.JSON, uTaskVar, System.SysUtils;

type
  TStepFactory = class
  protected
    class function GetSysStepDefines: TJSONArray;
  public
    class function GetSysStepDefinesStr: string;
    class function GetStepDefine(AStepType: TStepType): TStepDefine; static;
    class function GetStep(AStepType: TStepType; ATaskVar: TTaskVar): TStepBasic; overload;
  end;

implementation

uses
  uFunctions, uDefines;

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
    1:
      begin

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
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'CONTROL_TASKRESULT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'TaskResult任务结果'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepTaskResult'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepTaskResultForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'CONTROL_EXCEPTION_CATCH'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60040'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '异常捕捉'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepExceptionCatch'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepExceptionCatchForm'));
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
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据库'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DB_SQLSQL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '20011'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'SQL_SQL'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepSQL'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepSQLForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据库'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DB_JSON2TABLE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '20020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'JSON导入数据表'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepJson2Table'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepJson2TableForm'));
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
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DATASET_FILEDS_MAP'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30011'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '字段映射转化'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFieldsMap'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFieldsMapForm'));
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
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '写文本文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepTxtFileWriter'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepTxtFileWriterForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_READ_TEXT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40021'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '读文本文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepTxtFileReader'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepTxtFileReaderForm'));
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
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_UNZIP'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40040'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'ZIP文件解压'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepUnzip'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepUnzipForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'FILE_FOLDER_CTRL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40050'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '文件夹控制'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFolderCtrl'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFolderCtrlForm'));
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
  LRowJson.AddPair(TJSONPair.Create('step_group', '网络'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'NET_HTTP_DOWNLOAD_FILE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '50020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Http文件下载'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepDownloadFile'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepDownloadFileForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '报表打印'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'PRINT_FASTREPORT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '70010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'FastReport打印'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFastReport'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFastReportForm'));
  SysSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '报表打印'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'PRINT_REPORTMACHINE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '70020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'ReportMachine打印'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepReportMachine'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepReportMachineForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '实用工具'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'UTIL_SERVICE_CTRL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '80010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Service服务程序'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepServiceCtrl'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepServiceCtrlForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '实用工具'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'UTIL_EXE_CTRL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '80020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Exe应用程序'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepExeCtrl'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepExeCtrlForm'));
  SysSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '实用工具'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'UTIL_WAIT_TIME'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '80030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '等待时间'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepWaitTime'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepWaitTimeForm'));
  SysSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '设备'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'DEVICE_IDCARD_HS100UC'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '90010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '身份证读卡器-华视100UC'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepIdCardHS100UC'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepIdCardHS100UCForm'));
  SysSteps.AddElement(LRowJson);

  Result := SysSteps.ToJSON;
end;


initialization

finalization
if SysSteps <> nil then
  SysSteps.Free;

end.
