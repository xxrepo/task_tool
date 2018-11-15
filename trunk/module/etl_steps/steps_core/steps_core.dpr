library steps_core;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.ShareMem,
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Forms,
  System.JSON,
  System.SyncObjs,
  uBasicForm in '..\..\..\core\basic\uBasicForm.pas' {BasicForm},
  uBasicDlgForm in '..\..\..\core\basic\uBasicDlgForm.pas' {BasicDlgForm},
  uFunctions in '..\..\..\common\uFunctions.pas',
  uStepBasic in '..\..\..\etl\basic\uStepBasic.pas',
  uStepBasicForm in '..\..\..\etl\basic\uStepBasicForm.pas' {StepBasicForm},
  uTask in '..\..\..\etl\comm\uTask.pas',
  uTaskDefine in '..\..\..\etl\comm\uTaskDefine.pas',
  uTaskResult in '..\..\..\etl\comm\uTaskResult.pas',
  uTaskVar in '..\..\..\etl\comm\uTaskVar.pas',
  uStepDefines in '..\..\..\etl\steps\uStepDefines.pas',
  uStepFormSettings in '..\..\..\etl\steps\uStepFormSettings.pas',
  uDbConMgr in '..\..\..\etl\comm\uDbConMgr.pas',
  uThreadQueueUtil in '..\..\..\core\lib\uThreadQueueUtil.pas',
  uDefines in '..\..\..\etl\comm\uDefines.pas',
  uThreadSafeFile in '..\..\..\etl\comm\uThreadSafeFile.pas',
  uFileUtil in '..\..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\..\core\lib\uNetUtil.pas',
  uGlobalVar in '..\..\..\etl\comm\uGlobalVar.pas',
  uExceptions in '..\..\..\etl\comm\uExceptions.pas',
  uStepCondition in 'steps\common\uStepCondition.pas',
  uStepConditionForm in 'steps\common\uStepConditionForm.pas' {StepConditionForm},
  uStepNullForm in 'steps\common\uStepNullForm.pas' {StepNullForm},
  uStepSubTask in 'steps\common\uStepSubTask.pas',
  uStepSubTaskForm in 'steps\common\uStepSubTaskForm.pas' {StepSubTaskForm},
  uStepTaskResult in 'steps\common\uStepTaskResult.pas',
  uStepTaskResultForm in 'steps\common\uStepTaskResultForm.pas' {StepTaskResultForm},
  uStepVarDefine in 'steps\common\uStepVarDefine.pas',
  uStepVarDefineForm in 'steps\common\uStepVarDefineForm.pas' {StepVarDefineForm},
  uStepExceptionCatch in 'steps\control\uStepExceptionCatch.pas',
  uStepExceptionCatchForm in 'steps\control\uStepExceptionCatchForm.pas' {StepExceptionCatchForm},
  uStepDatasetSpliter in 'steps\data\uStepDatasetSpliter.pas',
  uStepDatasetSpliterForm in 'steps\data\uStepDatasetSpliterForm.pas' {StepDatasetSpliterForm},
  uStepFieldsMap in 'steps\data\uStepFieldsMap.pas',
  uStepFieldsMapForm in 'steps\data\uStepFieldsMapForm.pas' {StepFieldsMapForm},
  uStepFieldsOper in 'steps\data\uStepFieldsOper.pas',
  uStepFieldsOperForm in 'steps\data\uStepFieldsOperForm.pas' {StepFieldsOperForm},
  uStepJson2DataSet in 'steps\data\uStepJson2DataSet.pas',
  uStepJson2DataSetForm in 'steps\data\uStepJson2DataSetForm.pas' {StepJsonDataSetForm},
  uDBQueryResultForm in 'steps\database\uDBQueryResultForm.pas' {DBQueryResultForm},
  uStepJson2Table in 'steps\database\uStepJson2Table.pas',
  uStepJson2TableForm in 'steps\database\uStepJson2TableForm.pas' {StepJson2TableForm},
  uStepQuery in 'steps\database\uStepQuery.pas',
  uStepQueryForm in 'steps\database\uStepQueryForm.pas' {StepQueryForm},
  uStepSQL in 'steps\database\uStepSQL.pas',
  uStepSQLForm in 'steps\database\uStepSQLForm.pas' {StepSQLForm},
  uStepFileDelete in 'steps\file\uStepFileDelete.pas',
  uStepFileDeleteForm in 'steps\file\uStepFileDeleteForm.pas' {StepFileDeleteForm},
  uStepFolderCtrl in 'steps\file\uStepFolderCtrl.pas',
  uStepFolderCtrlForm in 'steps\file\uStepFolderCtrlForm.pas' {StepFolderCtrlForm},
  uStepIniRead in 'steps\file\uStepIniRead.pas',
  uStepIniReadForm in 'steps\file\uStepIniReadForm.pas' {StepIniReadForm},
  uStepIniWrite in 'steps\file\uStepIniWrite.pas',
  uStepIniWriteForm in 'steps\file\uStepIniWriteForm.pas' {StepIniWriteForm},
  uStepTxtFileReader in 'steps\file\uStepTxtFileReader.pas',
  uStepTxtFileReaderForm in 'steps\file\uStepTxtFileReaderForm.pas' {StepTxtFileReaderForm},
  uStepTxtFileWriter in 'steps\file\uStepTxtFileWriter.pas',
  uStepTxtFileWriterForm in 'steps\file\uStepTxtFileWriterForm.pas' {StepTxtFileWriterForm},
  uStepUnzip in 'steps\file\uStepUnzip.pas',
  uStepUnzipForm in 'steps\file\uStepUnzipForm.pas' {StepUnzipForm},
  uStepDownloadFile in 'steps\network\uStepDownloadFile.pas',
  uStepDownloadFileForm in 'steps\network\uStepDownloadFileForm.pas' {StepDownloadFileForm},
  uStepHttpRequest in 'steps\network\uStepHttpRequest.pas',
  uStepHttpRequestForm in 'steps\network\uStepHttpRequestForm.pas' {StepHttpRequestForm},
  uStepFastReport in 'steps\report\uStepFastReport.pas',
  uStepFastReportForm in 'steps\report\uStepFastReportForm.pas' {StepFastReportForm},
  uStepReportMachine in 'steps\report\uStepReportMachine.pas',
  uStepReportMachineForm in 'steps\report\uStepReportMachineForm.pas' {StepReportMachineForm},
  CVRDLL in 'steps\tools\CVRDLL.pas',
  uStepIdCardHS100UC in 'steps\tools\uStepIdCardHS100UC.pas',
  uStepIdCardHS100UCForm in 'steps\tools\uStepIdCardHS100UCForm.pas' {StepIdCardHS100UCForm},
  uStepExeCtrl in 'steps\util\uStepExeCtrl.pas',
  uStepExeCtrlForm in 'steps\util\uStepExeCtrlForm.pas' {StepExeCtrlForm},
  uStepServiceCtrl in 'steps\util\uStepServiceCtrl.pas',
  uStepServiceCtrlForm in 'steps\util\uStepServiceCtrlForm.pas' {StepServiceCtrlForm},
  uStepWaitTime in 'steps\util\uStepWaitTime.pas',
  uStepWaitTimeForm in 'steps\util\uStepWaitTimeForm.pas' {StepWaitTimeForm},
  uFileFinder in '..\..\..\core\lib\uFileFinder.pas',
  uServiceUtil in '..\..\..\core\lib\uServiceUtil.pas',
  uDesignTimeDefines in '..\..\..\etl\comm\uDesignTimeDefines.pas',
  uProject in '..\..\..\etl\comm\uProject.pas',
  uDatabaseConnectTestForm in '..\..\..\etl\forms\uDatabaseConnectTestForm.pas' {DatabaseConnectTestForm},
  uDatabasesForm in '..\..\..\etl\forms\uDatabasesForm.pas' {DatabasesForm},
  uTaskEditForm in '..\..\..\etl\forms\uTaskEditForm.pas' {TaskEditForm},
  uBasicLogForm in '..\..\..\core\basic\uBasicLogForm.pas' {BasicLogForm},
  uStepTypeSelectForm in '..\..\..\etl\forms\uStepTypeSelectForm.pas' {StepTypeSelectForm},
  uTaskStepSourceForm in '..\..\..\etl\forms\uTaskStepSourceForm.pas' {TaskStepSourceForm},
  uSelectFolderForm in '..\..\..\common\uSelectFolderForm.pas' {SelectFolderForm},
  uRunInfo in '..\..\..\common\uRunInfo.pas',
  uStepMgrClass in '..\..\..\common\uStepMgrClass.pas',
  uAppConfig in '..\..\..\etl\comm\uAppConfig.pas',
  uFileLogger in '..\..\..\core\lib\uFileLogger.pas';

{$R *.res}

var
  OldApplication: TApplication;
  OldMainForm: TForm;
  OldScreen: TScreen;

procedure AssignRunInfo(DllRunInfo: TRunInfo);
begin
  if RunInfo = nil then
  begin
    RunInfo := DllRunInfo;
    OldMainForm := Application.MainForm;
    Application := TApplication(RunInfo.Application);
    OldScreen := Screen;
    Screen := TScreen(RunInfo.MainScreen);

    //对本地的define和design_time_define中的全局变量进行赋值
    ExePath := RunInfo.ExePath;
    AppLogger := TThreadFileLog(RunInfo.AppLogger);
    FileCritical := TCriticalSection(RunInfo.FileCritical);
    StepMgr := TStepMgr(RunInfo.StepMgr);
  end;

  if CurrentProject = nil then
    CurrentProject := TProject(RunInfo.CurrentProject);
end;

//需要能够打开form
function ModuleStepDesignForm(DllRunInfo: TRunInfo; DllModuleStepRec: TPCharModuleStepRec; ATaskVar: TTaskVar): TStepBasicForm; stdcall;
var
  LClass: TPersistentClass;
begin
  Result := nil;
  if ATaskVar = nil then Exit;

  AssignRunInfo(DllRunInfo);

  LClass := GetClass(DllModuleStepRec.StepDesignFormClassName);
  if LClass <> nil then
  begin
    Result := LClass.NewInstance as TStepBasicForm;
    Result := Result.Create(nil);
    Result.TaskVar := ATaskVar;
    Result.edtStepTitle.Text := DllModuleStepRec.StepName;
  end;
end;



//需要能够运行steps，但是具体的steps也有可能是最终呈现一个form，比如报表类，当然，报表类也可以通过文件的方式进行处理
//需要能够打开form
function ModuleStep(DllRunInfo: TRunInfo; DllModuleStepRec: TPCharModuleStepRec; ATaskVar: TTaskVar): TStepBasic; stdcall;
var
  LTaskVar: TTaskVar;
begin
  Result := nil;
  if ATaskVar = nil then Exit;
  
  AssignRunInfo(DllRunInfo);

  //接下来，可以根据传入的module的那个step来进行具体的运行
  case DllModuleStepRec.StepId of
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
      20011:
      begin
        Result := TStepSQL.Create(ATaskVar);
      end;
      20020:
      begin
        Result := TStepJson2Table.Create(ATaskVar);
      end;
      30010:
      begin
        Result := TStepFieldsOper.Create(ATaskVar);
      end;
      30011:
      begin
        Result := TStepFieldsMap.Create(ATaskVar);
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
        Result := TStepTxtFileWriter.Create(ATaskVar);
      end;
      40021:
      begin
        Result := TStepTxtFileReader.Create(ATaskVar);
      end;
      40030:
      begin
        Result := TStepFileDelete.Create(ATaskVar);
      end;
      40040:
      begin
        Result := TStepUnzip.Create(ATaskVar);
      end;
      40050:
      begin
        Result := TStepFolderCtrl.Create(ATaskVar);
      end;
      50010:
      begin
        Result := TStepHttpRequest.Create(ATaskVar);
      end;
      50020:
      begin
        Result := TStepDownloadFile.Create(ATaskVar);
      end;
      60010:
      begin
        Result := TStepCondition.Create(ATaskVar);
      end;
      60020:
      begin
        Result := TStepVarDefine.Create(ATaskVar);
      end;
      60030:
      begin
        Result := TStepTaskResult.Create(ATaskVar);
      end;
      60040:
      begin
        Result := TStepExceptionCatch.Create(ATaskVar);
      end;
      70010:
      begin
        Result := TStepFastReport.Create(ATaskVar);
      end;
      70020:
      begin
        Result := TStepReportMachine.Create(ATaskVar);
      end;
      80010:
      begin
        Result := TStepServiceCtrl.Create(ATaskVar);
      end;
      80020:
      begin
        Result := TStepExeCtrl.Create(ATaskVar);
      end;
      80030:
      begin
        Result := TStepWaitTime.Create(ATaskVar);
      end;
    end;
end;


procedure ModulesRegister(var AModules: PChar); stdcall;
var
  LRowJson: TJSONObject;
  LSteps: TJSONArray;
begin
  LSteps := TJSONArray.Create;

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|COMMON_NULL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '10010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '空组件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepNull'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepNullForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|COMMON_SUB_TASK'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '10020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '子任务'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepSubTask'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepSubTaskForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|VAR_DEFININITION'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '变量定义'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepVarDefine'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepVarDefineForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|CONTROL_CONDITION'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '条件判断'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepCondition'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepConditionForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|CONTROL_TASKRESULT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'TaskResult任务结果'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepTaskResult'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepTaskResultForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '通用'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|CONTROL_EXCEPTION_CATCH'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '60040'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '异常捕捉'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepExceptionCatch'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepExceptionCatchForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据库'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DB_SQLQUERY'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '20010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'SQL_Query'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepQuery'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepQueryForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据库'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DB_SQLSQL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '20011'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'SQL_SQL'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepSQL'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepSQLForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据库'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DB_JSON2TABLE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '20020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'JSON导入数据表'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepJson2Table'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepJson2TableForm'));
  LSteps.AddElement(LRowJson);



  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DATASET_FILEDS_OPER'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '字段处理'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFieldsOper'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFieldsOperForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DATASET_FILEDS_MAP'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30011'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '字段映射转化'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFieldsMap'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFieldsMapForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DATASET_SPLITER'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '数据集拆分'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepDatasetSpliter'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepDatasetSpliterForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '数据集/字段'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DATASET_JSON2DATASET'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '30030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'JSON转数据集'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepJsonDataSet'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepJsonDataSetForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_READ_INI'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '读INI文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepIniRead'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepIniReadForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_WRITE_INI'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40011'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '写INI文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepIniWrite'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepIniWriteForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_WRITE_TEXT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '写文本文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepTxtFileWriter'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepTxtFileWriterForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_READ_TEXT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40021'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '读文本文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepTxtFileReader'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepTxtFileReaderForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_DELETE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '删除文件'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFileDelete'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFileDeleteForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_UNZIP'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40040'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'ZIP文件解压'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepUnzip'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepUnzipForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '文件'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|FILE_FOLDER_CTRL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '40050'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '文件夹控制'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFolderCtrl'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFolderCtrlForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '网络'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|NET_HTTP_REQUEST'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '50010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Http_Request_请求'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepHttpRequest'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepHttpRequestForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '网络'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|NET_HTTP_DOWNLOAD_FILE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '50020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Http文件下载'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepDownloadFile'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepDownloadFileForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '报表打印'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|PRINT_FASTREPORT'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '70010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'FastReport打印'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepFastReport'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepFastReportForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '报表打印'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|PRINT_REPORTMACHINE'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '70020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'ReportMachine打印'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepReportMachine'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepReportMachineForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '实用工具'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|UTIL_SERVICE_CTRL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '80010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Service服务程序'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepServiceCtrl'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepServiceCtrlForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '实用工具'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|UTIL_EXE_CTRL'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '80020'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', 'Exe应用程序'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepExeCtrl'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepExeCtrlForm'));
  LSteps.AddElement(LRowJson);

  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '实用工具'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|UTIL_WAIT_TIME'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '80030'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '等待时间'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepWaitTime'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepWaitTimeForm'));
  LSteps.AddElement(LRowJson);


  LRowJson := TJSONObject.Create;
  LRowJson.AddPair(TJSONPair.Create('namespace', 'core'));
  LRowJson.AddPair(TJSONPair.Create('step_group', '设备'));
  LRowJson.AddPair(TJSONPair.Create('step_type', 'core|DEVICE_IDCARD_HS100UC'));
  LRowJson.AddPair(TJSONPair.Create('step_type_id', '90010'));
  LRowJson.AddPair(TJSONPair.Create('step_type_name', '身份证读卡器-华视100UC'));
  LRowJson.AddPair(TJSONPair.Create('step_class_name', 'TStepIdCardHS100UC'));
  LRowJson.AddPair(TJSONPair.Create('form_class_name', 'TStepIdCardHS100UCForm'));
  LSteps.AddElement(LRowJson);

  AModules := PChar(LSteps.ToJSON);
  LSteps.Free;
end;


procedure NewDllProc(dwReason: DWORD);
begin
  if dwReason = DLL_PROCESS_ATTACH then
    OldApplication := application
  else if dwReason = DLL_PROCESS_DETACH then
  begin
    Application := OldApplication;
    if OldScreen <> nil then
      Screen := OldScreen;
  end;
end;

exports
  ModuleStepDesignForm,
  ModuleStep,
  ModulesRegister;

begin
  DllProc := @NewDllProc;
  DllProc(DLL_PROCESS_ATTACH);
end.

