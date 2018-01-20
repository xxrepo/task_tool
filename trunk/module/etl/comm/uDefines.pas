unit uDefines;

interface


uses
  uFileLogger, System.SyncObjs, uHttpServerRunner;

var
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;

  //目前仅保留单实例启动情形
  HttpServerRunner: THttpServerRunner;



const
  APP_VER: string = '1.1.1';


implementation


end.
