inherited UserNotifyMsgForm: TUserNotifyMsgForm
  BorderStyle = bsDialog
  Caption = #28201#39336#25552#31034
  ClientHeight = 156
  ClientWidth = 367
  Font.Height = -16
  OnCreate = FormCreate
  ExplicitWidth = 373
  ExplicitHeight = 184
  PixelsPerInch = 96
  TextHeight = 19
  object lblMsg: TRzLabel
    Left = 0
    Top = 0
    Width = 367
    Height = 104
    Align = alClient
    Alignment = taCenter
    AutoSize = False
    EllipsisPosition = epEndEllipsis
    Layout = tlCenter
    ExplicitWidth = 36
    ExplicitHeight = 17
  end
  object rzpnl1: TRzPanel
    Left = 0
    Top = 104
    Width = 367
    Height = 52
    Align = alBottom
    BorderOuter = fsFlat
    BorderSides = [sdTop]
    Caption = #25105#30693#36947#20102
    TabOrder = 0
    OnClick = rzpnl1Click
  end
  object tmrClose: TTimer
    Interval = 200
    OnTimer = tmrCloseTimer
    Left = 280
    Top = 56
  end
end
