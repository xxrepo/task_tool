unit uDefines;

interface


uses
  uFileLogger, System.SyncObjs;

var
  ExePath: string;
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;


const
  APP_VER: string = '1.1.1';


implementation


end.
