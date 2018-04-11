inherited SettingForm: TSettingForm
  Caption = #35774#32622
  ClientHeight = 408
  ClientWidth = 584
  OnCreate = FormCreate
  ExplicitWidth = 590
  ExplicitHeight = 437
  PixelsPerInch = 96
  TextHeight = 17
  object lbl1: TLabel [0]
    Left = 79
    Top = 35
    Width = 56
    Height = 17
    Caption = #39033#30446#36335#24452
  end
  object lbl2: TLabel [1]
    Left = 65
    Top = 73
    Width = 70
    Height = 17
    Caption = #24037#20316#32447#31243#25968
  end
  object lbl4: TLabel [2]
    Left = 65
    Top = 151
    Width = 70
    Height = 17
    Caption = #20801#35768#26102#38388#27573
  end
  object lbl5: TLabel [3]
    Left = 65
    Top = 247
    Width = 70
    Height = 17
    Caption = #31105#27490#26102#38388#27573
  end
  object lbl8: TLabel [4]
    Left = 358
    Top = 250
    Width = 163
    Height = 17
    Caption = #27604#22914#65306'07:30:30-23:59:30'
  end
  object lbl7: TLabel [5]
    Left = 358
    Top = 151
    Width = 163
    Height = 17
    Caption = #27604#22914#65306'08:00:00-09:00:00'
  end
  object lbl3: TLabel [6]
    Left = 79
    Top = 113
    Width = 56
    Height = 17
    Caption = #26085#24535#31561#32423
  end
  inherited pnlOper: TPanel
    Top = 351
    Width = 584
    ExplicitTop = 351
    ExplicitWidth = 584
    inherited btnOK: TBitBtn
      Left = 367
      Caption = #20445#23384
      OnClick = btnOKClick
      ExplicitLeft = 367
    end
    inherited btnCancel: TBitBtn
      Left = 477
      Caption = #20851#38381
      ExplicitLeft = 477
    end
    object btnDatabase: TBitBtn
      Left = 18
      Top = 10
      Width = 133
      Height = 39
      Caption = #25968#25454#24211#36830#25509#35774#32622
      TabOrder = 2
      OnClick = btnDatabaseClick
    end
    object btnGlobalVar: TBitBtn
      Left = 166
      Top = 10
      Width = 133
      Height = 39
      Caption = #20840#23616#21442#25968#35774#32622
      TabOrder = 3
      OnClick = btnGlobalVarClick
    end
  end
  object edtHandlerCount: TEdit
    Left = 166
    Top = 70
    Width = 129
    Height = 25
    ReadOnly = True
    TabOrder = 1
    Text = '1'
  end
  object mmoAllowedTime: TMemo
    Left = 163
    Top = 148
    Width = 189
    Height = 78
    TabOrder = 2
  end
  object mmoDisallowedTime: TMemo
    Left = 162
    Top = 244
    Width = 190
    Height = 76
    TabOrder = 3
  end
  object cbbLogLevel: TComboBox
    Left = 166
    Top = 110
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
  object btnDocRoot: TRzButtonEdit
    Left = 166
    Top = 32
    Width = 287
    Height = 25
    Text = ''
    TabOrder = 5
    AltBtnWidth = 15
    ButtonWidth = 15
    OnButtonClick = btnDocRootButtonClick
  end
end
