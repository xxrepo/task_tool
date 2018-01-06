unit uAlertSound;

interface

uses
  Winapi.Windows;

type
  TAlertSound = class
  public
    class procedure Beep(AFreq: Cardinal; ADuration: Cardinal);
    class procedure Error;
    class procedure Warning;
    class procedure Success;
  end;

implementation

{ TAlertSound }

class procedure TAlertSound.Beep(AFreq, ADuration: Cardinal);
begin
  Winapi.Windows.Beep(AFreq, ADuration);
end;

class procedure TAlertSound.Error;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Beep(2000, 180);
end;

class procedure TAlertSound.Warning;
var
  I: Integer;
begin
  for I := 0 to 1 do
    Beep(1000, 250);
end;

class procedure TAlertSound.Success;
begin
  Beep(3000, 400);
end;

end.
