inherited StepDatasetSpliterForm: TStepDatasetSpliterForm
  Caption = #25968#25454#38598#25286#20998
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
      ExplicitHeight = 257
      object lbl2: TLabel [1]
        Left = 52
        Top = 122
        Width = 56
        Height = 17
        Caption = #25968#25454#26469#28304
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl3: TLabel [3]
        Left = 52
        Top = 162
        Width = 56
        Height = 17
        Caption = #25286#20998#26684#24335
      end
      object lbl4: TLabel [4]
        Left = 64
        Top = 202
        Width = 42
        Height = 17
        Caption = #23376#34892#25968
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object edtDataRef: TEdit
        Left = 142
        Top = 119
        Width = 305
        Height = 25
        TabOrder = 3
      end
      object rbSingleObject: TRadioButton
        Left = 142
        Top = 163
        Width = 113
        Height = 17
        Caption = #21333#34892#23545#35937
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = rbSubArrayClick
      end
      object rbSubArray: TRadioButton
        Left = 270
        Top = 163
        Width = 113
        Height = 17
        Caption = #23376#20108#32500#25968#32452
        TabOrder = 5
        OnClick = rbSubArrayClick
      end
      object edtCountLimit: TEdit
        Left = 142
        Top = 199
        Width = 305
        Height = 25
        ReadOnly = True
        TabOrder = 6
        Text = '1'
      end
    end
  end
end
