inherited BasicLogForm: TBasicLogForm
  Caption = #28040#24687#26085#24535
  ClientHeight = 550
  ClientWidth = 796
  ExplicitWidth = 812
  ExplicitHeight = 589
  PixelsPerInch = 96
  TextHeight = 17
  object rzspltrLogForm: TRzSplitter
    Left = 0
    Top = 0
    Width = 796
    Height = 550
    Orientation = orVertical
    Position = 399
    Percent = 73
    UsePercent = True
    HotSpotVisible = True
    HotSpotDirection = hsdBoth
    SplitterWidth = 7
    Align = alClient
    TabOrder = 0
    BarSize = (
      0
      399
      796
      406)
    UpperLeftControls = ()
    LowerRightControls = (
      redtLog
      rzpnl3)
    object redtLog: TRichEdit
      Left = 0
      Top = 45
      Width = 796
      Height = 99
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
