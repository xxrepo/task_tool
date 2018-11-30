inherited StepBasicForm: TStepBasicForm
  BorderStyle = bsSizeable
  Caption = 'Step'#21442#25968#35774#32622
  ClientHeight = 410
  ClientWidth = 667
  OnDestroy = FormDestroy
  ExplicitWidth = 683
  ExplicitHeight = 449
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 353
    Width = 667
    ExplicitTop = 353
    ExplicitWidth = 667
    DesignSize = (
      667
      57)
    inherited btnOK: TBitBtn
      Left = 450
      OnClick = btnOKClick
      ExplicitLeft = 450
    end
    inherited btnCancel: TBitBtn
      Left = 560
      ExplicitLeft = 560
    end
  end
  object rzpgcntrlStepSettings: TRzPageControl
    Left = 0
    Top = 0
    Width = 667
    Height = 353
    Hint = ''
    ActivePage = rztbshtCommon
    Align = alClient
    TabIndex = 0
    TabOrder = 1
    FixedDimension = 23
    object rztbshtCommon: TRzTabSheet
      Caption = #22522#26412#35774#32622
      object lbl1: TLabel
        Left = 52
        Top = 26
        Width = 56
        Height = 17
        Caption = 'Step'#26631#39064
      end
      object lblDescription: TLabel
        Left = 50
        Top = 70
        Width = 56
        Height = 17
        Caption = 'Step'#35828#26126
      end
      object edtStepTitle: TEdit
        Left = 142
        Top = 23
        Width = 305
        Height = 25
        TabOrder = 0
      end
      object edtDescription: TEdit
        Left = 142
        Top = 67
        Width = 305
        Height = 25
        TabOrder = 1
      end
      object chkRegDataToTask: TCheckBox
        Left = 474
        Top = 27
        Width = 189
        Height = 17
        Caption = #27880#20876#36755#20986#32467#26524#21040'Task'
        TabOrder = 2
      end
    end
  end
end
