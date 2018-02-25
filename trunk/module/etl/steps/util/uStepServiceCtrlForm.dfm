inherited StepServiceCtrlForm: TStepServiceCtrlForm
  Caption = 'Service'#26381#21153#25511#21046
  ClientHeight = 386
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 329
    ExplicitTop = 284
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 329
    ExplicitHeight = 284
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 2
      ExplicitTop = 25
      ExplicitWidth = 673
      ExplicitHeight = 257
      object lbl2: TLabel [1]
        Left = 24
        Top = 201
        Width = 84
        Height = 17
        Caption = #26381#21153#31243#24207#25991#20214
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl3: TLabel [3]
        Left = 66
        Top = 114
        Width = 42
        Height = 17
        Caption = #26381#21153#21517
      end
      object lbl4: TLabel [4]
        Left = 52
        Top = 158
        Width = 56
        Height = 17
        Caption = #25511#21046#25351#20196
      end
      object lbl5: TLabel [5]
        Left = 24
        Top = 240
        Width = 84
        Height = 17
        Caption = #26381#21153#26174#31034#21517#31216
      end
      inherited edtDescription: TEdit
        TabOrder = 2
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 3
        Visible = False
      end
      object btnToFileName: TRzButtonEdit
        Left = 142
        Top = 198
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 1
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnToFileNameButtonClick
      end
      object edt1: TEdit
        Left = 142
        Top = 111
        Width = 305
        Height = 25
        TabOrder = 4
      end
      object edtDisplayName: TEdit
        Left = 142
        Top = 237
        Width = 307
        Height = 25
        TabOrder = 5
      end
      object rbInstall: TRadioButton
        Left = 142
        Top = 159
        Width = 113
        Height = 17
        Caption = #23433#35013
        TabOrder = 6
      end
      object rbUnInstall: TRadioButton
        Left = 381
        Top = 159
        Width = 89
        Height = 17
        Caption = #21368#36733
        TabOrder = 7
      end
      object rbStart: TRadioButton
        Left = 222
        Top = 159
        Width = 89
        Height = 17
        Caption = #21551#21160
        TabOrder = 8
      end
      object rbStop: TRadioButton
        Left = 298
        Top = 159
        Width = 69
        Height = 17
        Caption = #20572#27490
        TabOrder = 9
      end
    end
  end
  object dlgOpenToFileName: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'EXE'#25991#20214#65288'*.exe'#65289'|*.exe'
    Left = 557
    Top = 122
  end
end
