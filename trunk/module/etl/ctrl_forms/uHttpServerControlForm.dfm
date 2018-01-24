inherited HttpServerControlForm: THttpServerControlForm
  Caption = #26412#22320'Server'#35774#32622
  ClientHeight = 609
  ClientWidth = 689
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 705
  ExplicitHeight = 648
  PixelsPerInch = 96
  TextHeight = 17
  inherited rzspltrLogForm: TRzSplitter
    Width = 689
    Height = 609
    Position = 413
    UsePercent = False
    HotSpotSizePercent = 50
    ExplicitWidth = 689
    ExplicitHeight = 603
    UpperLeftControls = (
      rzpnl1)
    LowerRightControls = (
      redtLog
      rzpnl3)
    object rzpnl1: TRzPanel [0]
      Left = 0
      Top = 0
      Width = 689
      Height = 413
      Align = alClient
      AutoSize = True
      BorderOuter = fsFlat
      TabOrder = 0
      ExplicitHeight = 450
      object lbl1: TLabel
        Left = 103
        Top = 25
        Width = 40
        Height = 17
        Caption = #26412#22320'IP'
      end
      object lbl2: TLabel
        Left = 73
        Top = 295
        Width = 70
        Height = 17
        Caption = #36328#22495#30333#21517#21333
      end
      object lbl3: TLabel
        Left = 87
        Top = 139
        Width = 56
        Height = 17
        Caption = #26085#24535#31561#32423
      end
      object lbl4: TLabel
        Left = 73
        Top = 174
        Width = 70
        Height = 17
        Caption = #20801#35768#26102#38388#27573
      end
      object lbl5: TLabel
        Left = 73
        Top = 235
        Width = 70
        Height = 17
        Caption = #31105#27490#26102#38388#27573
      end
      object lblDocRoot: TLabel
        Left = 46
        Top = 63
        Width = 97
        Height = 17
        Caption = #26681#30446#24405'DocRoot'
      end
      object lblMaxSession: TLabel
        Left = 73
        Top = 101
        Width = 70
        Height = 17
        Caption = #26368#22823#36830#25509#25968
      end
      object lblPort: TLabel
        Left = 391
        Top = 25
        Width = 82
        Height = 17
        Caption = #30417#21548#31471#21475'Port'
      end
      object btnDocRoot: TRzButtonEdit
        Left = 172
        Top = 60
        Width = 433
        Height = 25
        Text = ''
        TabOrder = 0
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnDocRootButtonClick
      end
      object btnSave: TBitBtn
        Left = 172
        Top = 360
        Width = 105
        Height = 35
        Caption = #20445#23384
        TabOrder = 1
        OnClick = btnSaveClick
      end
      object btnStart: TBitBtn
        Left = 383
        Top = 360
        Width = 105
        Height = 35
        Caption = #21551#21160
        TabOrder = 2
        OnClick = btnStartClick
      end
      object btnStop: TBitBtn
        Left = 501
        Top = 360
        Width = 105
        Height = 35
        Caption = #20572#27490
        TabOrder = 3
        OnClick = btnStopClick
      end
      object cbbLogLevel: TComboBox
        Left = 173
        Top = 136
        Width = 129
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 4
        Text = 'All'
        Items.Strings = (
          'All'
          'Debug'
          'Info'
          'Warn'
          'Error'
          'Fatal')
      end
      object edtIP: TEdit
        Left = 173
        Top = 22
        Width = 190
        Height = 25
        TabOrder = 5
        Text = '127.0.0.1'
      end
      object edtMaxConnection: TEdit
        Left = 172
        Top = 98
        Width = 130
        Height = 25
        TabOrder = 6
        Text = '1'
      end
      object edtPort: TEdit
        Left = 494
        Top = 22
        Width = 111
        Height = 25
        TabOrder = 7
        Text = '61288'
      end
      object mmoAllowedAccessOrigins: TMemo
        Left = 173
        Top = 292
        Width = 432
        Height = 57
        TabOrder = 8
      end
      object mmoAllowedTime: TMemo
        Left = 173
        Top = 174
        Width = 189
        Height = 55
        TabOrder = 9
      end
      object mmoDisallowedTime: TMemo
        Left = 172
        Top = 235
        Width = 190
        Height = 51
        TabOrder = 10
      end
    end
    inherited redtLog: TRichEdit
      Width = 689
      Height = 144
      ExplicitWidth = 689
      ExplicitHeight = 32
    end
    inherited rzpnl3: TRzPanel
      Width = 689
      ExplicitWidth = 689
    end
  end
end
