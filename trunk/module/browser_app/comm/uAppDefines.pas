unit uAppDefines;

interface

uses Winapi.Messages, uRENDER_ProcessProxy, System.SyncObjs, uFileLogger, uBROWSER_GlobalVar,
uJobDispatcher;

var
  //本变量只能在Render进程中调用
  RENDER_RenderHelper: TRENDER_ProcessProxy;

  //browser进程的全局变量，也可以声明render的全局变量，在单独进程中线程访问安全
  BROWSER_GlobalVar: TBROWSER_GlobalVar;
  BROWSER_JobDispatcherMgr: TJobDispatcherList;



implementation



end.
