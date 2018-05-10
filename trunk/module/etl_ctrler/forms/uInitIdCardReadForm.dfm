inherited InitIdCardReadForm: TInitIdCardReadForm
  Caption = #35835#21345#31614#21040
  ClientHeight = 481
  ClientWidth = 696
  ExplicitWidth = 712
  ExplicitHeight = 520
  PixelsPerInch = 96
  TextHeight = 17
  object mmoInfo: TMemo
    Left = 0
    Top = 0
    Width = 696
    Height = 416
    Align = alClient
    BorderStyle = bsNone
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitWidth = 599
    ExplicitHeight = 322
  end
  object rzpnlBottom: TRzPanel
    Left = 0
    Top = 416
    Width = 696
    Height = 65
    Align = alBottom
    BorderOuter = fsFlat
    TabOrder = 1
    ExplicitTop = 322
    ExplicitWidth = 599
    DesignSize = (
      696
      65)
    object btnOk: TBitBtn
      Left = 16
      Top = 16
      Width = 97
      Height = 41
      Caption = #24320#22987#35835#21345
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnClose: TBitBtn
      Left = 591
      Top = 16
      Width = 89
      Height = 41
      Anchors = [akTop, akRight]
      Caption = #20851#38381
      ModalResult = 8
      TabOrder = 1
    end
    object cbbPorts: TComboBox
      Left = 136
      Top = 24
      Width = 81
      Height = 25
      Style = csDropDownList
      TabOrder = 2
      Visible = False
      Items.Strings = (
        '1001'
        '1002'
        '1003'
        '1004'
        '1005'
        '1006'
        '1007'
        '1008'
        '1009'
        '1010'
        '1011'
        '1012'
        '1013'
        '1014'
        '1015'
        '1016'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15'
        '16')
    end
    object btnSign: TBitBtn
      Left = 336
      Top = 16
      Width = 121
      Height = 41
      Caption = #31614#21040
      Enabled = False
      TabOrder = 3
      OnClick = btnSignClick
    end
    object chkAuto: TCheckBox
      Left = 240
      Top = 32
      Width = 97
      Height = 17
      Caption = #33258#21160#31614#21040
      TabOrder = 4
    end
  end
  object tmrAutoReadSign: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tmrAutoReadSignTimer
    Left = 440
    Top = 24
  end
end
