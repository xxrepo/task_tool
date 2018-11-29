inherited StepServiceCtrlForm: TStepServiceCtrlForm
  Caption = 'Service'#26381#21153#25511#21046
  ClientHeight = 386
  ExplicitHeight = 415
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 329
    ExplicitTop = 329
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 329
    ExplicitHeight = 329
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 2
      ExplicitTop = 25
      ExplicitWidth = 673
      ExplicitHeight = 302
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl3: TLabel [2]
        Left = 66
        Top = 114
        Width = 42
        Height = 17
        Caption = #26381#21153#21517
      end
      object lbl4: TLabel [3]
        Left = 52
        Top = 158
        Width = 56
        Height = 17
        Caption = #25511#21046#25351#20196
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object edtServiceName: TEdit
        Left = 142
        Top = 111
        Width = 305
        Height = 25
        TabOrder = 3
      end
      object rzrdgrpCtrlType: TRzRadioGroup
        Left = 142
        Top = 152
        Width = 327
        Height = 30
        BorderSides = []
        Caption = ''
        Columns = 4
        GroupStyle = gsCustom
        ItemIndex = 0
        Items.Strings = (
          #23433#35013
          #21551#21160
          #20572#27490
          #21368#36733)
        SpaceEvenly = True
        TabOrder = 4
        OnClick = rzrdgrpCtrlTypeClick
      end
      object pnlServiceExe: TRzPanel
        Left = 0
        Top = 188
        Width = 658
        Height = 105
        BorderOuter = fsNone
        TabOrder = 5
        Visible = False
        object lbl2: TLabel
          Left = 24
          Top = 17
          Width = 84
          Height = 17
          Caption = #26381#21153#31243#24207#25991#20214
        end
        object lbl5: TLabel
          Left = 24
          Top = 59
          Width = 84
          Height = 17
          Caption = #26381#21153#26174#31034#21517#31216
        end
        object btnServiceExeFile: TRzButtonEdit
          Left = 142
          Top = 13
          Width = 307
          Height = 25
          Text = ''
          TabOrder = 0
          AltBtnWidth = 15
          ButtonWidth = 15
          OnButtonClick = btnServiceExeFileButtonClick
        end
        object edtDisplayName: TEdit
          Left = 142
          Top = 55
          Width = 307
          Height = 25
          TabOrder = 1
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
