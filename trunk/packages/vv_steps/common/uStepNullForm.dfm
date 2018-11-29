inherited StepNullForm: TStepNullForm
  Caption = #31354'Step'#21442#25968#35774#32622
  ClientHeight = 207
  ClientWidth = 694
  ExplicitWidth = 700
  ExplicitHeight = 236
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 150
    Width = 694
    ExplicitTop = 150
    ExplicitWidth = 694
    inherited btnOK: TBitBtn
      Left = 477
      ExplicitLeft = 477
    end
    inherited btnCancel: TBitBtn
      Left = 587
      ExplicitLeft = 587
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 694
    Height = 150
    ExplicitWidth = 694
    ExplicitHeight = 150
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitWidth = 690
      ExplicitHeight = 123
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
    end
  end
end
