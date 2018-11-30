inherited StepFolderCtrlForm: TStepFolderCtrlForm
  Caption = #25991#20214#22841#25511#21046
  ClientHeight = 371
  ExplicitHeight = 410
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 314
    ExplicitTop = 287
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 314
    ExplicitHeight = 287
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitHeight = 260
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl4: TLabel [2]
        Left = 52
        Top = 118
        Width = 56
        Height = 17
        Caption = #25511#21046#25351#20196
      end
      object lbl2: TLabel [3]
        Left = 66
        Top = 160
        Width = 42
        Height = 17
        Caption = #25991#20214#22841
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object rzrdgrpCtrlType: TRzRadioGroup
        Left = 142
        Top = 112
        Width = 335
        Height = 30
        BorderSides = []
        Caption = ''
        Columns = 5
        GroupStyle = gsCustom
        ItemIndex = 0
        Items.Strings = (
          #21019#24314
          #21024#38500
          #28165#31354
          #31227#21160
          #22797#21046)
        SpaceEvenly = True
        TabOrder = 3
        OnClick = rzrdgrpCtrlTypeClick
      end
      object btnFolder: TRzButtonEdit
        Left = 142
        Top = 157
        Width = 307
        Height = 25
        Text = ''
        TabOrder = 4
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnFolderButtonClick
      end
      object pnlServiceExe: TRzPanel
        Left = 0
        Top = 188
        Width = 658
        Height = 96
        BorderOuter = fsNone
        TabOrder = 5
        Visible = False
        object lbl3: TLabel
          Left = 38
          Top = 15
          Width = 70
          Height = 17
          Caption = #30446#26631#25991#20214#22841
        end
        object btnToFolder: TRzButtonEdit
          Left = 142
          Top = 13
          Width = 307
          Height = 25
          Text = ''
          TabOrder = 0
          AltBtnWidth = 15
          ButtonWidth = 15
          OnButtonClick = btnFolderButtonClick
        end
        object chkChildrenOnly: TCheckBox
          Left = 142
          Top = 62
          Width = 247
          Height = 17
          Caption = #20165#38480#23376#25991#20214#21644#23376#25991#20214#22841
          TabOrder = 1
        end
      end
    end
  end
end
