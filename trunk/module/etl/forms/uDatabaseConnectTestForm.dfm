inherited DatabaseConnectTestForm: TDatabaseConnectTestForm
  Caption = #25968#25454#24211#36830#25509#27979#35797
  ClientHeight = 472
  ClientWidth = 383
  ExplicitWidth = 389
  ExplicitHeight = 501
  PixelsPerInch = 96
  TextHeight = 19
  object lblProvider: TRzLabel [0]
    Left = 47
    Top = 57
    Width = 64
    Height = 19
    Alignment = taRightJustify
    Caption = #39537#21160#31867#22411
  end
  object lbl1: TRzLabel [1]
    Left = 47
    Top = 24
    Width = 64
    Height = 19
    Alignment = taRightJustify
    Caption = #36830#25509#21517#31216
  end
  object lblServer: TRzLabel [2]
    Left = 63
    Top = 87
    Width = 48
    Height = 19
    Alignment = taRightJustify
    Caption = #26381#21153#22120
  end
  object lblPort: TRzLabel [3]
    Left = 79
    Top = 122
    Width = 32
    Height = 19
    Alignment = taRightJustify
    Caption = #31471#21475
  end
  object lbl2: TRzLabel [4]
    Left = 63
    Top = 194
    Width = 48
    Height = 19
    Alignment = taRightJustify
    Caption = #29992#25143#21517
  end
  object lbl3: TRzLabel [5]
    Left = 77
    Top = 228
    Width = 32
    Height = 19
    Alignment = taRightJustify
    Caption = #23494#30721
  end
  object lbl4: TRzLabel [6]
    Left = 63
    Top = 157
    Width = 48
    Height = 19
    Alignment = taRightJustify
    Caption = #25968#25454#24211
  end
  object lblSpecificStr: TRzLabel [7]
    Left = 47
    Top = 262
    Width = 64
    Height = 19
    Alignment = taRightJustify
    Caption = #25193#23637#35774#32622
  end
  inherited pnlOper: TPanel
    Top = 415
    Width = 383
    ExplicitTop = 415
    ExplicitWidth = 383
    inherited btnOK: TBitBtn
      Left = 202
      Width = 72
      Caption = #20445#23384
      ExplicitLeft = 202
      ExplicitWidth = 72
    end
    inherited btnCancel: TBitBtn
      Left = 286
      Width = 79
      ExplicitLeft = 286
      ExplicitWidth = 79
    end
    object btnTest: TBitBtn
      Left = 12
      Top = 10
      Width = 97
      Height = 39
      Caption = #27979#35797#36830#25509
      TabOrder = 2
      OnClick = btnTestClick
    end
  end
  object edtDbTitle: TRzEdit
    Left = 152
    Top = 21
    Width = 201
    Height = 27
    Text = ''
    TabOrder = 1
  end
  object cbbProvider: TComboBox
    Left = 152
    Top = 54
    Width = 201
    Height = 27
    ItemIndex = 0
    TabOrder = 2
    Text = 'SQL Server'
    Items.Strings = (
      'SQL Server'
      'MySQL'
      'ODBC'
      'Oracle'
      'Sqlite')
  end
  object edtServer: TRzEdit
    Left = 152
    Top = 84
    Width = 201
    Height = 27
    Text = ''
    TabOrder = 3
  end
  object edtPort: TRzEdit
    Left = 152
    Top = 117
    Width = 201
    Height = 27
    Text = '0'
    TabOrder = 4
  end
  object edtDatabase: TRzEdit
    Left = 152
    Top = 154
    Width = 201
    Height = 27
    Text = ''
    TabOrder = 5
  end
  object edtUserName: TRzEdit
    Left = 152
    Top = 191
    Width = 201
    Height = 27
    Text = ''
    TabOrder = 6
  end
  object edtPassword: TRzMaskEdit
    Left = 152
    Top = 224
    Width = 201
    Height = 27
    PasswordChar = '*'
    TabOrder = 7
    Text = ''
  end
  object mmoSpecificStr: TMemo
    Left = 40
    Top = 292
    Width = 313
    Height = 113
    TabOrder = 8
  end
end
