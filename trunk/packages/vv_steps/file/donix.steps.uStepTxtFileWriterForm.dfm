inherited StepTxtFileWriterForm: TStepTxtFileWriterForm
  Caption = #20889#25991#26412#25991#20214#65288'txt, json...'#65289
  ClientHeight = 341
  ExplicitHeight = 380
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
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 663
      ExplicitHeight = 257
      object lbl2: TLabel [1]
        Left = 54
        Top = 162
        Width = 56
        Height = 17
        Caption = #30446#26631#25991#20214
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl3: TLabel [3]
        Left = 80
        Top = 118
        Width = 28
        Height = 17
        Caption = #25968#25454
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
        Top = 159
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 1
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnToFileNameButtonClick
      end
      object chkRewrite: TCheckBox
        Left = 142
        Top = 207
        Width = 189
        Height = 17
        Caption = #35206#30422#24050#26377#25991#20214
        TabOrder = 4
      end
      object edtDataRef: TEdit
        Left = 142
        Top = 115
        Width = 305
        Height = 25
        TabOrder = 5
        Text = 'parent.*'
      end
    end
  end
  object dlgOpenToFileName: TOpenDialog
    Filter = #25991#26412#25991#20214
    Left = 537
    Top = 188
  end
end
