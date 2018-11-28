unit donix.job.uExceptions;

interface

uses System.SysUtils;

type
  CgtException = class(Exception);

  TaskConfigException = class(CgtException);

  StepException = class(CgtException);

  StopTaskException = class(CgtException);
  StopTaskGracefulException = class(CgtException);

  StopStepException = class(CgtException);


implementation

end.
