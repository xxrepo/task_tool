object BasicChromeForm: TBasicChromeForm
  Left = 0
  Top = 0
  Caption = 'BasicChromeForm'
  ClientHeight = 321
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object cfwndwprntMain: TCEFWindowParent
    Left = 0
    Top = 0
    Width = 678
    Height = 321
    Align = alClient
    TabOrder = 0
  end
  object chrmMain: TChromium
    OnProcessMessageReceived = chrmMainProcessMessageReceived
    OnAfterCreated = chrmMainAfterCreated
    Left = 70
    Top = 116
  end
  object tmrChromium: TTimer
    Enabled = False
    Interval = 25
    OnTimer = tmrChromiumTimer
    Left = 72
    Top = 192
  end
end
