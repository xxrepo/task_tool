unit donix.job.uTaskDefine;

interface

type
  TTaskRunStatus = (trsUnknown, trsCreate, trsRunning, trsStop, trsSuspend, trsFinish);

  TTaskConfigRec = record
    FileName: string;
    TaskName: string;
    Interactive: integer;
    Description: string;
    Version: string;
    Auth: string;

    StepsStr: string;

    //这两项来自于jobmgr运行时传入
    RunBasePath: string;
    DBsConfigFile: string;
  end;

  PEventDataRec = ^TEventDataRec;

  TEventDataRec = record
    JobName: string;
    EventName: string;

    ContentLength: Integer;
    ContentBody: string;
  end;


implementation

end.
