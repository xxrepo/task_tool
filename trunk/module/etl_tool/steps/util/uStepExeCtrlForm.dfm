inherited StepExeCtrlForm: TStepExeCtrlForm
  Caption = 'EXE'#24212#29992#31243#24207#25511#21046
  ClientHeight = 350
  ExplicitHeight = 379
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 293
    ExplicitTop = 277
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 293
    ExplicitHeight = 277
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 2
      ExplicitTop = 16
      ExplicitWidth = 673
      ExplicitHeight = 328
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
        Left = 28
        Top = 160
        Width = 80
        Height = 17
        Caption = 'EXE'#31243#24207#25991#20214
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object rzrdgrpCtrlType: TRzRadioGroup
        Left = 142
        Top = 112
        Width = 197
        Height = 30
        BorderSides = []
        Caption = ''
        Columns = 2
        GroupStyle = gsCustom
        ItemIndex = 0
        Items.Strings = (
          #21551#21160
          #20572#27490)
        SpaceEvenly = True
        TabOrder = 3
        OnClick = rzrdgrpCtrlTypeClick
      end
      object btnExeFile: TRzButtonEdit
        Left = 142
        Top = 157
        Width = 305
        Height = 25
        Text = ''
        TabOrder = 4
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnExeFileButtonClick
      end
      object pnlServiceExe: TRzPanel
        Left = 5
        Top = 188
        Width = 658
        Height = 66
        BorderOuter = fsNone
        TabOrder = 5
        Visible = False
        object lbl3: TLabel
          Left = 46
          Top = 23
          Width = 56
          Height = 17
          Caption = #21551#21160#21442#25968
        end
        object edtStartArgs: TEdit
          Left = 136
          Top = 15
          Width = 305
          Height = 25
          TabOrder = 0
        end
      end
    end
  end
  object dlgOpenToFileName: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'EXE'#25991#20214#65288'*.exe'#65289'|*.exe'
    Left = 557
    Top = 122
  end
end
