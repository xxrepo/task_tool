inherited StepWriteTxtFileForm: TStepWriteTxtFileForm
  Caption = #20889'txt'#25991#20214
  ClientHeight = 341
  ExplicitHeight = 370
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 284
    ExplicitTop = 284
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 284
    ExplicitHeight = 284
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitHeight = 257
      object lbl2: TLabel [1]
        Left = 52
        Top = 122
        Width = 56
        Height = 17
        Caption = #30446#26631#25991#20214
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      inherited edtDescription: TEdit
        TabOrder = 2
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 3
        Visible = False
      end
      object btnToFileName: TRzButtonEdit
        Left = 140
        Top = 119
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 1
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnToFileNameButtonClick
      end
    end
  end
  object dlgOpenToFileName: TOpenDialog
    DefaultExt = 'txt'
    Filter = #25991#26412#25991#20214#65288'*.txt'#65289'|*.txt'
    Left = 537
    Top = 188
  end
end
