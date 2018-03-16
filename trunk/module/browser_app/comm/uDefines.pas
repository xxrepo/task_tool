unit uDefines;

interface

uses Winapi.Messages, uRENDER_ProcessProxy, System.SyncObjs, uFileLogger;

const
  APP_VER: string = '1.1.1';

  VVMSG_RESTORE_APPLICATION_FORM = WM_USER + 3000;
  VVMSG_INTERACTIVE_JOB_REQUEST = WM_USER + 4000;
  VVMSG_OPEN_URL_FORM= WM_USER + 2000;

var
  ExePath: string;
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;


  //本变量只能在Render进程中调用
  PRENDER_RenderHelper: TRENDER_ProcessProxy;



implementation



end.
