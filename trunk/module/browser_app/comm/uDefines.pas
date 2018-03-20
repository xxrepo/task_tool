unit uDefines;

interface

uses Winapi.Messages, uRENDER_ProcessProxy, System.SyncObjs, uFileLogger, uGlobalVar;

var
  ExePath: string;
  AppLogger: TThreadFileLog;
  FileCritical: TCriticalSection;


  //本变量只能在Render进程中调用
  RENDER_RenderHelper: TRENDER_ProcessProxy;

  //browser进程的全局变量，也可以声明render的全局变量，在单独进程中线程访问安全
  BROWSER_GlobalVar: TGlobalVar;



implementation



end.
