inherited StepSubTaskForm: TStepSubTaskForm
  Caption = #25991#20214#23376#20219#21153
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
        Left = 38
        Top = 122
        Width = 70
        Height = 17
        Caption = #23376#20219#21153#25991#20214
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
      object btnFileName: TRzButtonEdit
        Left = 140
        Top = 119
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 1
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnFileNameButtonClick
      end
      object btnEdit: TBitBtn
        Left = 474
        Top = 119
        Width = 75
        Height = 25
        Caption = #32534#36753#20219#21153
        TabOrder = 4
        OnClick = btnEditClick
      end
    end
  end
  object dlgOpenToFileName: TOpenDialog
    DefaultExt = 'task'
    Filter = #20219#21153#25991#20214#65288'*.task'#65289'|*.task'
    Options = [ofReadOnly, ofHideReadOnly, ofEnableSizing]
    Left = 141
    Top = 198
  end
end
