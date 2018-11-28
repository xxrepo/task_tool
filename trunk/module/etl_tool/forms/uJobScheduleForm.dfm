inherited JobScheduleForm: TJobScheduleForm
  Caption = #35745#21010#24037#20316#26102#38388
  ClientHeight = 474
  ClientWidth = 606
  ExplicitWidth = 612
  ExplicitHeight = 503
  PixelsPerInch = 96
  TextHeight = 17
  object lblInterval: TLabel [0]
    Left = 72
    Top = 80
    Width = 56
    Height = 17
    Caption = #25191#34892#38388#38548
  end
  object lblStartTime: TLabel [1]
    Left = 24
    Top = 29
    Width = 98
    Height = 17
    Caption = #21551#21160#21518#25191#34892#26102#38388
  end
  object lbl1: TLabel [2]
    Left = 56
    Top = 172
    Width = 70
    Height = 17
    Caption = #20801#35768#26102#38388#27573
  end
  object lbl2: TLabel [3]
    Left = 56
    Top = 280
    Width = 70
    Height = 17
    Caption = #31105#27490#26102#38388#27573
  end
  object lbl3: TLabel [4]
    Left = 72
    Top = 128
    Width = 56
    Height = 17
    Caption = #36229#26102#35774#32622
  end
  object lbl4: TLabel [5]
    Left = 366
    Top = 32
    Width = 14
    Height = 17
    Caption = #31186
  end
  object lbl5: TLabel [6]
    Left = 366
    Top = 80
    Width = 14
    Height = 17
    Caption = #31186
  end
  object lbl6: TLabel [7]
    Left = 366
    Top = 128
    Width = 14
    Height = 17
    Caption = #31186
  end
  object lbl7: TLabel [8]
    Left = 366
    Top = 172
    Width = 163
    Height = 17
    Caption = #27604#22914#65306'08:00:00-09:00:00'
  end
  object lbl8: TLabel [9]
    Left = 366
    Top = 280
    Width = 163
    Height = 17
    Caption = #27604#22914#65306'07:30:30-23:59:30'
  end
  inherited pnlOper: TPanel
    Top = 417
    Width = 606
    ExplicitTop = 417
    ExplicitWidth = 606
    DesignSize = (
      606
      57)
    inherited btnOK: TBitBtn
      Left = 389
      ExplicitLeft = 389
    end
    inherited btnCancel: TBitBtn
      Left = 499
      ExplicitLeft = 499
    end
  end
  object edtStartAfter: TEdit
    Left = 168
    Top = 29
    Width = 189
    Height = 25
    TabOrder = 1
    Text = '0'
  end
  object edtInterval: TEdit
    Left = 168
    Top = 77
    Width = 189
    Height = 25
    TabOrder = 2
    Text = '3600'
  end
  object edtTimeOut: TEdit
    Left = 168
    Top = 125
    Width = 189
    Height = 25
    TabOrder = 3
    Text = '7200'
  end
  object mmoAllowedTime: TMemo
    Left = 168
    Top = 169
    Width = 189
    Height = 94
    TabOrder = 4
  end
  object mmoDisallowedTime: TMemo
    Left = 168
    Top = 277
    Width = 189
    Height = 100
    TabOrder = 5
  end
end
