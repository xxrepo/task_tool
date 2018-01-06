inherited JobEditForm: TJobEditForm
  Caption = #25191#34892#24037#20316#35774#32622
  ClientHeight = 463
  ClientWidth = 465
  ExplicitWidth = 471
  ExplicitHeight = 492
  PixelsPerInch = 96
  TextHeight = 19
  object lblTaskName: TLabel [0]
    Left = 38
    Top = 74
    Width = 64
    Height = 19
    Caption = #20219#21153#21517#31216
  end
  object lblFileName: TLabel [1]
    Left = 38
    Top = 24
    Width = 64
    Height = 19
    Caption = #20219#21153#25991#20214
  end
  object lbl1: TLabel [2]
    Left = 38
    Top = 126
    Width = 64
    Height = 19
    Caption = #25191#34892#38388#38548
  end
  object lblLastTime: TLabel [3]
    Left = 38
    Top = 176
    Width = 64
    Height = 19
    Caption = #19978#27425#26102#38388
  end
  object lblNextTime: TLabel [4]
    Left = 38
    Top = 226
    Width = 64
    Height = 19
    Caption = #19979#27425#26102#38388
  end
  object lblTimeOut: TLabel [5]
    Left = 38
    Top = 274
    Width = 64
    Height = 19
    Caption = #36229#26102#35774#32622
  end
  inherited pnlOper: TPanel
    Top = 406
    Width = 465
    ExplicitTop = 406
    ExplicitWidth = 465
    inherited btnOK: TBitBtn
      Left = 248
      OnClick = btnOKClick
      ExplicitLeft = 248
    end
    inherited btnCancel: TBitBtn
      Left = 358
      ExplicitLeft = 358
    end
    object btnDelete: TBitBtn
      Left = 12
      Top = 12
      Width = 95
      Height = 39
      Caption = #21024#38500
      ModalResult = 1
      TabOrder = 2
      OnClick = btnDeleteClick
    end
  end
  object edtTaskName: TEdit
    Left = 154
    Top = 71
    Width = 251
    Height = 27
    ReadOnly = True
    TabOrder = 1
  end
  object btnFileName: TRzButtonEdit
    Left = 154
    Top = 21
    Width = 251
    Height = 27
    Text = ''
    TabOrder = 2
    AltBtnWidth = 15
    ButtonWidth = 15
    OnButtonClick = btnFileNameButtonClick
  end
  object edtInterval: TEdit
    Left = 154
    Top = 123
    Width = 251
    Height = 27
    TabOrder = 3
    Text = '7200'
  end
  object edtTimeOut: TEdit
    Left = 154
    Top = 271
    Width = 251
    Height = 27
    TabOrder = 4
    Text = '3600'
  end
  object rgStatus: TRadioGroup
    Left = 154
    Top = 312
    Width = 251
    Height = 73
    Caption = #20219#21153#29366#24577
    ItemIndex = 1
    Items.Strings = (
      #26080#25928
      #26377#25928)
    TabOrder = 5
  end
  object rzdtmpckrLastTime: TRzDateTimePicker
    Left = 154
    Top = 174
    Width = 251
    Height = 27
    Date = 43069.485208310190000000
    Format = 'yyyy-MM-dd HH:mm:ss'
    Time = 43069.485208310190000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 6
  end
  object rzdtmpckrNextTime: TRzDateTimePicker
    Left = 154
    Top = 222
    Width = 251
    Height = 27
    Date = 43069.485208310190000000
    Format = 'yyyy-MM-dd HH:mm:ss'
    Time = 43069.485208310190000000
    DateMode = dmUpDown
    Kind = dtkTime
    TabOrder = 7
  end
  object dlgOpenTaskFile: TOpenDialog
    DefaultExt = 'task'
    Filter = #20219#21153#25991#20214'(*.task)|*.task'
    Left = 48
    Top = 328
  end
end
