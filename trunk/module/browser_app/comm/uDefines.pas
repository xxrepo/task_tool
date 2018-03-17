unit uDefines;

interface

uses Winapi.Messages, uRENDER_ProcessProxy, System.SyncObjs, uFileLogger;

var
  ExePath: string;
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;


  //本变量只能在Render进程中调用
  PRENDER_RenderHelper: TRENDER_ProcessProxy;



implementation



end.
