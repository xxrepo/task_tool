program CgtEtlOnce;

uses
  Vcl.Forms,
  System.SysUtils,
  System.Classes,
  System.SyncObjs,
  Vcl.Dialogs,
  uStepBasic in '..\etl\basic\uStepBasic.pas',
  uStepSubTask in '..\etl\steps\common\uStepSubTask.pas',
  uStepTaskResult in '..\etl\steps\common\uStepTaskResult.pas',
  uStepVarDefine in '..\etl\steps\common\uStepVarDefine.pas',
  uStepDatasetSpliter in '..\etl\steps\data\uStepDatasetSpliter.pas',
  uStepJson2DataSet in '..\etl\steps\data\uStepJson2DataSet.pas',
  uStepFileDelete in '..\etl\steps\file\uStepFileDelete.pas',
  uStepFolderCtrl in '..\etl\steps\file\uStepFolderCtrl.pas',
  uStepIniRead in '..\etl\steps\file\uStepIniRead.pas',
  uStepIniWrite in '..\etl\steps\file\uStepIniWrite.pas',
  uStepUnzip in '..\etl\steps\file\uStepUnzip.pas',
  uStepWaitTime in '..\etl\steps\util\uStepWaitTime.pas',
  uStepDownloadFile in '..\etl\steps\network\uStepDownloadFile.pas',
  uStepHttpRequest in '..\etl\steps\network\uStepHttpRequest.pas',
  uStepFastReport in '..\etl\steps\report\uStepFastReport.pas',
  uStepReportMachine in '..\etl\steps\report\uStepReportMachine.pas',
  uStepExeCtrl in '..\etl\steps\util\uStepExeCtrl.pas',
  uStepServiceCtrl in '..\etl\steps\util\uStepServiceCtrl.pas',
  uExeUtil in '..\..\core\lib\uExeUtil.pas',
  uFileLogger in '..\..\core\lib\uFileLogger.pas',
  uFileUtil in '..\..\core\lib\uFileUtil.pas',
  uNetUtil in '..\..\core\lib\uNetUtil.pas',
  uServiceUtil in '..\..\core\lib\uServiceUtil.pas',
  uThreadQueueUtil in '..\..\core\lib\uThreadQueueUtil.pas',
  uFunctions in '..\..\common\uFunctions.pas',
  uStepDefines in '..\etl\steps\uStepDefines.pas',
  uStepFactory in '..\etl\steps\uStepFactory.pas',
  uTaskVar in '..\etl\comm\uTaskVar.pas',
  uDbConMgr in '..\etl\comm\uDbConMgr.pas',
  uThreadSafeFile in '..\etl\comm\uThreadSafeFile.pas',
  uDefines in '..\etl\comm\uDefines.pas',
  uTaskDefine in '..\etl\comm\uTaskDefine.pas',
  uGlobalVar in '..\etl\comm\uGlobalVar.pas',
  uTaskResult in '..\etl\comm\uTaskResult.pas',
  uExceptions in '..\etl\comm\uExceptions.pas',
  uTask in '..\etl\comm\uTask.pas',
  uFileFinder in '..\..\core\lib\uFileFinder.pas',
  uStepUiBasicExt in '..\etl\basic\uStepUiBasicExt.pas',
  uJob in '..\etl\comm\uJob.pas',
  uJobDispatcher in '..\etl\comm\uJobDispatcher.pas',
  uJobStarter in '..\etl\comm\uJobStarter.pas',
  uStepCondition in '..\etl\steps\common\uStepCondition.pas',
  uStepExceptionCatch in '..\etl\steps\control\uStepExceptionCatch.pas',
  uStepTxtFileReader in '..\etl\steps\file\uStepTxtFileReader.pas',
  uStepTxtFileWriter in '..\etl\steps\file\uStepTxtFileWriter.pas',
  uStepFieldsMap in '..\etl\steps\data\uStepFieldsMap.pas',
  uStepFieldsOper in '..\etl\steps\data\uStepFieldsOper.pas',
  uStepJson2Table in '..\etl\steps\database\uStepJson2Table.pas',
  uStepQuery in '..\etl\steps\database\uStepQuery.pas',
  uStepSQL in '..\etl\steps\database\uStepSQL.pas',
  CVRDLL in '..\etl\steps\tools\CVRDLL.pas',
  uStepIdCardHS100UC in '..\etl\steps\tools\uStepIdCardHS100UC.pas';

{$R *.res}

var
  LJobStarter: TJobStarter;
  LDisStrings: TStringList;
begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := False;

  //运行程序启动对应的task
  ExePath := ExtractFilePath(ParamStr(0));
  AppLogger := TThreadFileLog.Create(1,  ExePath + 'log\once\', 'yyyymmdd\hh');
  FileCritical := TCriticalSection.Create;

  LDisStrings := TStringList.Create;
  LJobStarter := TJobStarter.Create(0, llDebug);
  try
    LDisStrings.Delimiter := '/';
    LDisStrings.DelimitedText := ParamStr(1);
    if LDisStrings.Count = 2 then
    begin
      LJobStarter.LoadConfigFrom(ExePath + 'projects\' + LDisStrings.Strings[0] + '\project.jobs', LDisStrings.Strings[1]);
      LJobStarter.StartJob(LDisStrings.Strings[1]);
    end;
  finally
    LJobStarter.Free;
    LDisStrings.Free;
  end;

  Application.Run;

  FileCritical.Free;
  AppLogger.Free;
end.
