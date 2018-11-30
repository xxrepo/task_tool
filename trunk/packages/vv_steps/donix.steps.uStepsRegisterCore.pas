unit donix.steps.uStepsRegisterCore;

interface

uses uStepFactory;

type
  TStepsRegisterCore = class
  public
    class procedure RegSteps;
  end;

implementation

uses uFunctions, uDefines,
  uStepBasic,
  uStepBasicForm,
  uStepFieldsOper,
  uStepFieldsOperForm,
  uStepFieldsMap,
  uStepFieldsMapForm,
  uStepHttpRequest,
  uStepHttpRequestForm,
  uStepIniRead,
  uStepIniReadForm,
  uStepIniWrite,
  uStepIniWriteForm,
  uStepQuery,
  uStepQueryForm,
  uStepSQL,
  uStepSQLForm,
  uStepTxtFileWriter,
  uStepTxtFileWriterForm,
  uStepTxtFileReader,
  uStepTxtFileReaderForm,
  uStepDatasetSpliter,
  uStepDatasetSpliterForm,
  uStepSubTask,
  uStepSubTaskForm,
  uStepCondition,
  uStepConditionForm,
  uStepVarDefine,
  uStepVarDefineForm,
  uStepFileDelete,
  uStepFileDeleteForm,
  uStepJson2DataSet,
  uStepJson2DataSetForm,
  uStepJson2Table,
  uStepJson2TableForm,
  uStepTaskResult,
  uStepTaskResultForm,
  uStepFastReport,
  uStepFastReportForm,
  uStepReportMachine,
  uStepReportMachineForm,
  uStepDownloadFile,
  uStepDownloadFileForm,
  uStepUnzip,
  uStepUnzipForm,
  uStepServiceCtrl,
  uStepServiceCtrlForm,
  uStepExeCtrl,
  uStepExeCtrlForm,
  uStepFolderCtrl,
  uStepFolderCtrlForm,
  uStepWaitTime,
  uStepWaitTimeForm,
  uStepExceptionCatch,
  uStepExceptionCatchForm;

{ TStepsRegisterCore }

class procedure TStepsRegisterCore.RegSteps;
var
  LStepRegisterRec: TStepRegisterRec;
begin
  LStepRegisterRec.StepGroup := '通用';
  LStepRegisterRec.StepType := 'core|COMMON_NULL';
  LStepRegisterRec.StepTypeName := '空组件';
  LStepRegisterRec.StepClassName := 'TStepNull';
  LStepRegisterRec.StepClass := TStepNull;
  LStepRegisterRec.FormClassName := 'TStepNullForm';
  LStepRegisterRec.FormClass := TStepBasicForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);

  LStepRegisterRec.StepGroup := '通用';
  LStepRegisterRec.StepType := 'core|VAR_DEFININITION';
  LStepRegisterRec.StepTypeName := '变量定义';
  LStepRegisterRec.StepClassName := 'TStepVarDefine';
  LStepRegisterRec.StepClass := TStepVarDefine;
  LStepRegisterRec.FormClassName := 'TStepVarDefineForm';
  LStepRegisterRec.FormClass := TStepVarDefineForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);

  LStepRegisterRec.StepGroup := '通用';
  LStepRegisterRec.StepType := 'core|CONTROL_CONDITION';
  LStepRegisterRec.StepTypeName := '条件判断';
  LStepRegisterRec.StepClassName := 'TStepCondition';
  LStepRegisterRec.StepClass := TStepCondition;
  LStepRegisterRec.FormClassName := 'TStepConditionForm';
  LStepRegisterRec.FormClass := TStepConditionForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);

  LStepRegisterRec.StepGroup := '通用';
  LStepRegisterRec.StepType := 'core|CONTROL_TASKRESULT';
  LStepRegisterRec.StepTypeName := 'TaskResult任务结果';
  LStepRegisterRec.StepClassName := 'TStepTaskResult';
  LStepRegisterRec.StepClass := TStepTaskResult;
  LStepRegisterRec.FormClassName := 'TStepTaskResultForm';
  LStepRegisterRec.FormClass := TStepTaskResultForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);

  LStepRegisterRec.StepGroup := '通用';
  LStepRegisterRec.StepType := 'core|CONTROL_EXCEPTION_CATCH';
  LStepRegisterRec.StepTypeName := '异常捕捉';
  LStepRegisterRec.StepClassName := 'TStepExceptionCatch';
  LStepRegisterRec.StepClass := TStepExceptionCatch;
  LStepRegisterRec.FormClassName := 'TStepExceptionCatchForm';
  LStepRegisterRec.FormClass := TStepExceptionCatchForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);

  LStepRegisterRec.StepGroup := '数据库';
  LStepRegisterRec.StepType := 'core|DB_SQLQUERY';
  LStepRegisterRec.StepTypeName := 'SQL_Query';
  LStepRegisterRec.StepClassName := 'TStepQuery';
  LStepRegisterRec.StepClass := TStepQuery;
  LStepRegisterRec.FormClassName := 'TStepQueryForm';
  LStepRegisterRec.FormClass := TStepQueryForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '数据库';
  LStepRegisterRec.StepType := 'core|DB_SQLSQL';
  LStepRegisterRec.StepTypeName := 'SQL_SQL';
  LStepRegisterRec.StepClassName := 'TStepSQL';
  LStepRegisterRec.StepClass := TStepSQL;
  LStepRegisterRec.FormClassName := 'TStepSQLForm';
  LStepRegisterRec.FormClass := TStepSQLForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '数据库';
  LStepRegisterRec.StepType := 'core|DB_JSON2TABLE';
  LStepRegisterRec.StepTypeName := 'JSON导入数据表';
  LStepRegisterRec.StepClassName := 'TStepJson2Table';
  LStepRegisterRec.StepClass := TStepJson2Table;
  LStepRegisterRec.FormClassName := 'TStepJson2TableForm';
  LStepRegisterRec.FormClass := TStepJson2TableForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '数据集/字段';
  LStepRegisterRec.StepType := 'core|DATASET_FILEDS_OPER';
  LStepRegisterRec.StepTypeName := '字段处理';
  LStepRegisterRec.StepClassName := 'TStepFieldsOper';
  LStepRegisterRec.StepClass := TStepFieldsOper;
  LStepRegisterRec.FormClassName := 'TStepFieldsOperForm';
  LStepRegisterRec.FormClass := TStepFieldsOperForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '数据集/字段';
  LStepRegisterRec.StepType := 'core|DATASET_FILEDS_MAP';
  LStepRegisterRec.StepTypeName := '字段映射转化';
  LStepRegisterRec.StepClassName := 'TStepFieldsMap';
  LStepRegisterRec.StepClass := TStepFieldsMap;
  LStepRegisterRec.FormClassName := 'TStepFieldsMapForm';
  LStepRegisterRec.FormClass := TStepFieldsMapForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '数据集/字段';
  LStepRegisterRec.StepType := 'core|DATASET_SPLITER';
  LStepRegisterRec.StepTypeName := '数据集拆分';
  LStepRegisterRec.StepClassName := 'TStepDatasetSpliter';
  LStepRegisterRec.StepClass := TStepDatasetSpliter;
  LStepRegisterRec.FormClassName := 'TStepDatasetSpliterForm';
  LStepRegisterRec.FormClass := TStepDatasetSpliterForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);



  LStepRegisterRec.StepGroup := '数据集/字段';
  LStepRegisterRec.StepType := 'core|DATASET_JSON2DATASET';
  LStepRegisterRec.StepTypeName := 'JSON转数据集';
  LStepRegisterRec.StepClassName := 'TStepJsonDataSet';
  LStepRegisterRec.StepClass := TStepJsonDataSet;
  LStepRegisterRec.FormClassName := 'TStepJsonDataSetForm';
  LStepRegisterRec.FormClass := TStepJsonDataSetForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_READ_INI';
  LStepRegisterRec.StepTypeName := '读INI文件';
  LStepRegisterRec.StepClassName := 'TStepIniRead';
  LStepRegisterRec.StepClass := TStepIniRead;
  LStepRegisterRec.FormClassName := 'TStepIniReadForm';
  LStepRegisterRec.FormClass := TStepIniReadForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_WRITE_INI';
  LStepRegisterRec.StepTypeName := '写INI文件';
  LStepRegisterRec.StepClassName := 'TStepIniWrite';
  LStepRegisterRec.StepClass := TStepIniWrite;
  LStepRegisterRec.FormClassName := 'TStepIniWriteForm';
  LStepRegisterRec.FormClass := TStepIniWriteForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_WRITE_TEXT';
  LStepRegisterRec.StepTypeName := '写文本文件';
  LStepRegisterRec.StepClassName := 'TStepTxtFileWriter';
  LStepRegisterRec.StepClass := TStepTxtFileWriter;
  LStepRegisterRec.FormClassName := 'TStepTxtFileWriterForm';
  LStepRegisterRec.FormClass := TStepTxtFileWriterForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_READ_TEXT';
  LStepRegisterRec.StepTypeName := '读文本文件';
  LStepRegisterRec.StepClassName := 'TStepTxtFileReader';
  LStepRegisterRec.StepClass := TStepTxtFileReader;
  LStepRegisterRec.FormClassName := 'TStepTxtFileReaderForm';
  LStepRegisterRec.FormClass := TStepTxtFileReaderForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_DELETE';
  LStepRegisterRec.StepTypeName := '删除文件';
  LStepRegisterRec.StepClassName := 'TStepFileDelete';
  LStepRegisterRec.StepClass := TStepFileDelete;
  LStepRegisterRec.FormClassName := 'TStepFileDeleteForm';
  LStepRegisterRec.FormClass := TStepFileDeleteForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_UNZIP';
  LStepRegisterRec.StepTypeName := 'ZIP文件解压';
  LStepRegisterRec.StepClassName := 'TStepUnzip';
  LStepRegisterRec.StepClass := TStepUnzip;
  LStepRegisterRec.FormClassName := 'TStepUnzipForm';
  LStepRegisterRec.FormClass := TStepUnzipForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '文件';
  LStepRegisterRec.StepType := 'core|FILE_FOLDER_CTRL';
  LStepRegisterRec.StepTypeName := '文件夹控制';
  LStepRegisterRec.StepClassName := 'TStepFolderCtrl';
  LStepRegisterRec.StepClass := TStepFolderCtrl;
  LStepRegisterRec.FormClassName := 'TStepFolderCtrlForm';
  LStepRegisterRec.FormClass := TStepFolderCtrlForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '网络';
  LStepRegisterRec.StepType := 'core|NET_HTTP_REQUEST';
  LStepRegisterRec.StepTypeName := 'Http_Request_请求';
  LStepRegisterRec.StepClassName := 'TStepHttpRequest';
  LStepRegisterRec.StepClass := TStepHttpRequest;
  LStepRegisterRec.FormClassName := 'TStepHttpRequestForm';
  LStepRegisterRec.FormClass := TStepHttpRequestForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '网络';
  LStepRegisterRec.StepType := 'core|NET_HTTP_DOWNLOAD_FILE';
  LStepRegisterRec.StepTypeName := 'Http文件下载';
  LStepRegisterRec.StepClassName := 'TStepDownloadFile';
  LStepRegisterRec.StepClass := TStepDownloadFile;
  LStepRegisterRec.FormClassName := 'TStepDownloadFileForm';
  LStepRegisterRec.FormClass := TStepDownloadFileForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '报表打印';
  LStepRegisterRec.StepType := 'core|PRINT_FASTREPORT';
  LStepRegisterRec.StepTypeName := 'FastReport打印';
  LStepRegisterRec.StepClassName := 'TStepFastReport';
  LStepRegisterRec.StepClass := TStepFastReport;
  LStepRegisterRec.FormClassName := 'TStepFastReportForm';
  LStepRegisterRec.FormClass := TStepFastReportForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '报表打印';
  LStepRegisterRec.StepType := 'core|PRINT_REPORTMACHINE';
  LStepRegisterRec.StepTypeName := 'ReportMachine打印';
  LStepRegisterRec.StepClassName := 'TStepReportMachine';
  LStepRegisterRec.StepClass := TStepReportMachine;
  LStepRegisterRec.FormClassName := 'TStepReportMachineForm';
  LStepRegisterRec.FormClass := TStepReportMachineForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);



  LStepRegisterRec.StepGroup := '实用工具';
  LStepRegisterRec.StepType := 'core|UTIL_SERVICE_CTRL';
  LStepRegisterRec.StepTypeName := 'Service服务程序';
  LStepRegisterRec.StepClassName := 'TStepServiceCtrl';
  LStepRegisterRec.StepClass := TStepServiceCtrl;
  LStepRegisterRec.FormClassName := 'TStepServiceCtrlForm';
  LStepRegisterRec.FormClass := TStepServiceCtrlForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '实用工具';
  LStepRegisterRec.StepType := 'core|UTIL_EXE_CTRL';
  LStepRegisterRec.StepTypeName := 'Exe应用程序';
  LStepRegisterRec.StepClassName := 'TStepExeCtrl';
  LStepRegisterRec.StepClass := TStepExeCtrl;
  LStepRegisterRec.FormClassName := 'TStepExeCtrlForm';
  LStepRegisterRec.FormClass := TStepExeCtrlForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);


  LStepRegisterRec.StepGroup := '实用工具';
  LStepRegisterRec.StepType := 'core|UTIL_WAIT_TIME';
  LStepRegisterRec.StepTypeName := '等待时间';
  LStepRegisterRec.StepClassName := 'TStepWaitTime';
  LStepRegisterRec.StepClass := TStepWaitTime;
  LStepRegisterRec.FormClassName := 'TStepWaitTimeForm';
  LStepRegisterRec.FormClass := TStepWaitTimeForm;
  TStepFactory.RegsiterStep(LStepRegisterRec);
end;

initialization
  TStepsRegisterCore.RegSteps;

end.
