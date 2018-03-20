unit uVVConstants;

interface

uses Winapi.Messages;

const
  APP_VER: string = '1.1.1';

  VVMSG_RESTORE_APPLICATION_FORM = WM_USER + 3000;
  VVMSG_INTERACTIVE_JOB_REQUEST = WM_USER + 4000;
  VVMSG_OPEN_NATIVE_WINDOW = WM_USER + 2000;


  IPC_MSG_EXEC_CALLBACK = 'IPC_EXEC_CALLBACK';


implementation

end.
