inherited StepExceptionCatchForm: TStepExceptionCatchForm
  Caption = #24322#24120#25429#25417
  ClientHeight = 260
  ClientWidth = 710
  ExplicitWidth = 726
  ExplicitHeight = 299
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 203
    Width = 710
    ExplicitTop = 203
    ExplicitWidth = 710
    inherited btnOK: TBitBtn
      Left = 493
      ExplicitLeft = 493
    end
    inherited btnCancel: TBitBtn
      Left = 603
      ExplicitLeft = 603
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 710
    Height = 203
    ExplicitWidth = 710
    ExplicitHeight = 203
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 706
      ExplicitHeight = 176
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl4: TLabel [2]
        Left = 52
        Top = 118
        Width = 56
        Height = 17
        Caption = #24322#24120#32467#26524
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object rzrdgrpCtrlType: TRzRadioGroup
        Left = 142
        Top = 112
        Width = 251
        Height = 30
        BorderSides = []
        Caption = ''
        Columns = 2
        GroupStyle = gsCustom
        ItemIndex = 0
        Items.Strings = (
          'END STEP'
          'END TASK')
        SpaceEvenly = True
        TabOrder = 3
      end
    end
  end
end
