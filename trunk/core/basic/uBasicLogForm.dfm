inherited BasicLogForm: TBasicLogForm
  Caption = #28040#24687#26085#24535
  ClientHeight = 623
  ClientWidth = 796
  ExplicitTop = -41
  ExplicitWidth = 812
  ExplicitHeight = 662
  PixelsPerInch = 96
  TextHeight = 17
  object rzspltrLogForm: TRzSplitter
    Left = 0
    Top = 0
    Width = 796
    Height = 623
    Orientation = orVertical
    Position = 389
    Percent = 63
    Align = alClient
    TabOrder = 0
    BarSize = (
      0
      389
      796
      393)
    UpperLeftControls = ()
    LowerRightControls = (
      redtLog
      rzpnl3)
    object redtLog: TRichEdit
      Left = 0
      Top = 45
      Width = 796
      Height = 185
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      Zoom = 100
    end
    object rzpnl3: TRzPanel
      Left = 0
      Top = 0
      Width = 796
      Height = 45
      Align = alTop
      BorderOuter = fsFlat
      TabOrder = 1
      object btnClearLog: TBitBtn
        Left = 12
        Top = 8
        Width = 99
        Height = 31
        Caption = #28165#38500#26085#24535
        TabOrder = 0
        OnClick = btnClearLogClick
      end
    end
  end
end
