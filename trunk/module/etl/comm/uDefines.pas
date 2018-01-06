unit uDefines;

interface


uses
  uFileLogger, System.SyncObjs;

var
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;



const
  APP_VER: string = '1.1.1';


implementation


end.
