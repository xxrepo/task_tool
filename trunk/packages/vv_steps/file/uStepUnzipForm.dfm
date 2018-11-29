inherited StepUnzipForm: TStepUnzipForm
  Caption = 'Zip'#25991#20214#35299#21387
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
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 673
      ExplicitHeight = 257
      object lbl2: TLabel [1]
        Left = 48
        Top = 114
        Width = 60
        Height = 17
        Caption = 'Zip'#28304#25991#20214
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lblSaveTo: TLabel [3]
        Left = 24
        Top = 156
        Width = 84
        Height = 17
        Caption = #35299#21387#21040#25991#20214#22841
      end
      inherited edtDescription: TEdit
        TabOrder = 2
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 3
        Visible = False
      end
      object btnSaveToPath: TRzButtonEdit
        Left = 142
        Top = 153
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 1
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnSaveToPathButtonClick
      end
      object edtSrcFileUrl: TEdit
        Left = 142
        Top = 111
        Width = 305
        Height = 25
        TabOrder = 4
      end
    end
  end
end
