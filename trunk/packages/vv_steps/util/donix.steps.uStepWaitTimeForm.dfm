inherited StepWaitTimeForm: TStepWaitTimeForm
  Caption = #31561#24453#26102#38388
  ClientHeight = 310
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 253
    ExplicitTop = 253
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 253
    ExplicitHeight = 253
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitHeight = 226
      object lbl2: TLabel [1]
        Left = 52
        Top = 122
        Width = 56
        Height = 17
        Caption = #31561#24453#26102#38388
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl3: TLabel [3]
        Left = 459
        Top = 122
        Width = 28
        Height = 17
        Caption = #27627#31186
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object edtMiniSeconds: TEdit
        Left = 142
        Top = 119
        Width = 305
        Height = 25
        TabOrder = 3
      end
    end
  end
end
