unit uTaskDefine;

interface

type
  TTaskRunStatus = (trsUnknown, trsRunning, trsStop, trsSuspend);

  TTaskConfigRec = record
    FileName: string;
    TaskName: string;
    Description: string;
    Version: string;
    Auth: string;

    StepsStr: string;

    //这两项来自于jobmgr运行时传入
    RunBasePath: string;
    DBsConfigFile: string;
  end;


implementation

end.
