inherited ServiceControlForm: TServiceControlForm
  BorderStyle = bsDialog
  Caption = #26381#21153#25511#21046
  ClientHeight = 437
  ClientWidth = 604
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 610
  ExplicitHeight = 466
  PixelsPerInch = 96
  TextHeight = 17
  object lblServiceStatus: TLabel
    Left = 87
    Top = 34
    Width = 56
    Height = 17
    Caption = #26381#21153#29366#24577
  end
  object lbl1: TLabel
    Left = 59
    Top = 78
    Width = 84
    Height = 17
    Caption = 'Jobs'#24037#20316#25991#20214
  end
  object lbl2: TLabel
    Left = 73
    Top = 116
    Width = 70
    Height = 17
    Caption = #24037#20316#32447#31243#25968
  end
  object lblServiceStatusStr: TLabel
    Left = 174
    Top = 29
    Width = 60
    Height = 23
    Caption = #26410#23433#35013
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 87
    Top = 156
    Width = 56
    Height = 17
    Caption = #26085#24535#31561#32423
  end
  object lbl4: TLabel
    Left = 73
    Top = 194
    Width = 70
    Height = 17
    Caption = #20801#35768#26102#38388#27573
  end
  object lbl7: TLabel
    Left = 366
    Top = 191
    Width = 163
    Height = 17
    Caption = #27604#22914#65306'08:00:00-09:00:00'
  end
  object lbl5: TLabel
    Left = 73
    Top = 290
    Width = 70
    Height = 17
    Caption = #31105#27490#26102#38388#27573
  end
  object lbl8: TLabel
    Left = 366
    Top = 290
    Width = 163
    Height = 17
    Caption = #27604#22914#65306'07:30:30-23:59:30'
  end
  object rzpnl1: TRzPanel
    Left = 0
    Top = 380
    Width = 604
    Height = 57
    Align = alBottom
    BorderOuter = fsFlat
    TabOrder = 0
    object btnInstall: TBitBtn
      Left = 180
      Top = 8
      Width = 89
      Height = 39
      Caption = #23433#35013
      Enabled = False
      TabOrder = 0
      OnClick = btnInstallClick
    end
    object btnStop: TBitBtn
      Left = 500
      Top = 8
      Width = 89
      Height = 39
      Caption = #20572#27490
      Enabled = False
      TabOrder = 1
      OnClick = btnStopClick
    end
    object btnUnInstall: TBitBtn
      Left = 287
      Top = 8
      Width = 89
      Height = 39
      Caption = #21368#36733
      Enabled = False
      TabOrder = 2
      OnClick = btnUnInstallClick
    end
    object btnStart: TBitBtn
      Left = 393
      Top = 8
      Width = 89
      Height = 39
      Caption = #21551#21160
      Enabled = False
      TabOrder = 3
      OnClick = btnStartClick
    end
    object btnTestService: TBitBtn
      Left = 12
      Top = 8
      Width = 89
      Height = 39
      Caption = #27979#35797
      Enabled = False
      TabOrder = 4
      OnClick = btnTestServiceClick
    end
  end
  object btnJobsFile: TRzButtonEdit
    Left = 174
    Top = 75
    Width = 243
    Height = 25
    Text = ''
    TabOrder = 1
    AltBtnWidth = 15
    ButtonWidth = 15
    OnButtonClick = btnJobsFileButtonClick
  end
  object edtHandlerCount: TEdit
    Left = 174
    Top = 113
    Width = 129
    Height = 25
    TabOrder = 2
    Text = '1'
  end
  object cbbLogLevel: TComboBox
    Left = 174
    Top = 153
    Width = 129
    Height = 25
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'All'
    Items.Strings = (
      'All'
      'Debug'
      'Info'
      'Warn'
      'Error'
      'Fatal')
  end
  object mmoAllowedTime: TMemo
    Left = 171
    Top = 191
    Width = 189
    Height = 78
    TabOrder = 4
  end
  object mmoDisallowedTime: TMemo
    Left = 170
    Top = 287
    Width = 190
    Height = 76
    TabOrder = 5
  end
  object dlgOpenJobs: TOpenDialog
    Filter = #24037#20316#25991#20214#65288'*.jobs'#65289'|*.jobs'
    Options = [ofReadOnly, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofNoNetworkButton, ofEnableSizing]
    Left = 30
    Top = 14
  end
  object tmrCheckServiceStatus: TTimer
    Enabled = False
    OnTimer = tmrCheckServiceStatusTimer
    Left = 508
    Top = 22
  end
end
