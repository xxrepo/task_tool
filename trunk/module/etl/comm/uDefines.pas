unit uDefines;

interface


uses
  uFileLogger, System.SyncObjs, Winapi.Messages;

var
  ExePath: string;
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;


const
  APP_VER: string = '1.1.1';

  VVMSG_RESTORE_APPLICATION_FORM = WM_USER + 3000;


implementation


end.
