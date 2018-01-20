inherited HttpServerControlForm: THttpServerControlForm
  Caption = #26412#22320'Server'#35774#32622
  ClientHeight = 633
  ClientWidth = 646
  Font.Height = -16
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 662
  ExplicitHeight = 672
  PixelsPerInch = 96
  TextHeight = 19
  inherited rzspltrLogForm: TRzSplitter
    Width = 646
    Height = 633
    Position = 514
    Percent = 82
    UsePercent = False
    HotSpotSizePercent = 50
    ExplicitWidth = 646
    ExplicitHeight = 581
    UpperLeftControls = (
      lbl1
      lblPort
      lblDocRoot
      lblMaxSession
      lbl3
      lbl4
      lbl5
      lbl2
      cbbLogLevel
      mmoAllowedTime
      mmoDisallowedTime
      btnDocRoot
      edtIP
      edtPort
      edtMaxConnection
      mmoAllowedAccessOrigins
      btnStart
      btnStop
      btnSave)
    LowerRightControls = (
      redtLog
      rzpnl3)
    object lbl1: TLabel [0]
      Left = 103
      Top = 25
      Width = 47
      Height = 19
      Caption = #26412#22320'IP'
    end
    object lblPort: TLabel [1]
      Left = 391
      Top = 25
      Width = 93
      Height = 19
      Caption = #30417#21548#31471#21475'Port'
    end
    object lblDocRoot: TLabel [2]
      Left = 46
      Top = 63
      Width = 108
      Height = 19
      Caption = #26681#30446#24405'DocRoot'
    end
    object lblMaxSession: TLabel [3]
      Left = 73
      Top = 101
      Width = 80
      Height = 19
      Caption = #26368#22823#36830#25509#25968
    end
    object lbl3: TLabel [4]
      Left = 87
      Top = 139
      Width = 64
      Height = 19
      Caption = #26085#24535#31561#32423
    end
    object lbl4: TLabel [5]
      Left = 73
      Top = 174
      Width = 80
      Height = 19
      Caption = #20801#35768#26102#38388#27573
    end
    object lbl5: TLabel [6]
      Left = 73
      Top = 235
      Width = 80
      Height = 19
      Caption = #31105#27490#26102#38388#27573
    end
    object lbl2: TLabel [7]
      Left = 74
      Top = 289
      Width = 80
      Height = 19
      Caption = #36328#22495#30333#21517#21333
    end
    object cbbLogLevel: TComboBox [8]
      Left = 173
      Top = 136
      Width = 129
      Height = 27
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'All'
      Items.Strings = (
        'All'
        'Debug'
        'Info'
        'Warn'
        'Error'
        'Fatal')
    end
    object mmoAllowedTime: TMemo [9]
      Left = 173
      Top = 174
      Width = 189
      Height = 55
      TabOrder = 1
    end
    object mmoDisallowedTime: TMemo [10]
      Left = 172
      Top = 235
      Width = 190
      Height = 51
      TabOrder = 2
    end
    object btnDocRoot: TRzButtonEdit [11]
      Left = 172
      Top = 60
      Width = 433
      Height = 27
      Text = ''
      TabOrder = 3
      AltBtnWidth = 15
      ButtonWidth = 15
      OnButtonClick = btnDocRootButtonClick
    end
    object edtIP: TEdit [12]
      Left = 173
      Top = 22
      Width = 190
      Height = 27
      TabOrder = 4
      Text = '127.0.0.1'
    end
    object edtPort: TEdit [13]
      Left = 494
      Top = 22
      Width = 111
      Height = 27
      TabOrder = 5
      Text = '61288'
    end
    object edtMaxConnection: TEdit [14]
      Left = 172
      Top = 98
      Width = 130
      Height = 27
      TabOrder = 6
      Text = '1'
    end
    object mmoAllowedAccessOrigins: TMemo [15]
      Left = 173
      Top = 292
      Width = 432
      Height = 57
      TabOrder = 7
    end
    object btnStart: TBitBtn [16]
      Left = 383
      Top = 360
      Width = 105
      Height = 35
      Caption = #21551#21160
      TabOrder = 8
      OnClick = btnStartClick
    end
    object btnStop: TBitBtn [17]
      Left = 501
      Top = 360
      Width = 105
      Height = 35
      Caption = #20572#27490
      TabOrder = 9
      OnClick = btnStopClick
    end
    object btnSave: TBitBtn [18]
      Left = 172
      Top = 360
      Width = 105
      Height = 35
      Caption = #20445#23384
      TabOrder = 10
      OnClick = btnSaveClick
    end
    inherited redtLog: TRichEdit
      Width = 646
      Height = 67
      ExplicitWidth = 646
      ExplicitHeight = 44
    end
    inherited rzpnl3: TRzPanel
      Width = 646
      ExplicitWidth = 646
    end
  end
end
