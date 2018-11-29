inherited StepFileDeleteForm: TStepFileDeleteForm
  Caption = #25991#20214#21024#38500
  ClientHeight = 348
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 291
    ExplicitTop = 291
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 291
    ExplicitHeight = 291
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitHeight = 264
      object lbl2: TLabel [1]
        Left = 38
        Top = 122
        Width = 70
        Height = 17
        Caption = #30446#26631#25991#20214#22841
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl3: TLabel [3]
        Left = 52
        Top = 166
        Width = 56
        Height = 17
        Caption = #25991#20214#31867#22411
      end
      object lbl4: TLabel [4]
        Left = 52
        Top = 210
        Width = 56
        Height = 17
        Caption = #36807#26399#26102#38388
      end
      object lbl5: TLabel [5]
        Left = 279
        Top = 210
        Width = 14
        Height = 17
        Caption = #31186
      end
      object lbl6: TLabel [6]
        Left = 474
        Top = 166
        Width = 91
        Height = 17
        Caption = #27604#22914#65306'.txt;.log'
      end
      inherited edtDescription: TEdit
        TabOrder = 2
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 3
        Visible = False
      end
      object btnPath: TRzButtonEdit
        Left = 140
        Top = 119
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 1
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnPathButtonClick
      end
      object edtFilter: TEdit
        Left = 140
        Top = 163
        Width = 305
        Height = 25
        TabOrder = 4
        Text = '.log'
      end
      object edtDeleteBeforeTime: TEdit
        Left = 140
        Top = 207
        Width = 133
        Height = 25
        TabOrder = 5
        Text = '604800'
      end
    end
  end
  object chkRecursive: TCheckBox
    Left = 475
    Top = 147
    Width = 189
    Height = 17
    Caption = #36941#21382#23376#25991#20214#22841
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object dlgfldSelectorPath: TRzSelectFolderDialog
    Left = 401
    Top = 234
  end
end
