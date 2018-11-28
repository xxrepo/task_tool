inherited TaskStepSourceForm: TTaskStepSourceForm
  Caption = 'Step'#28304#26597#30475
  ClientHeight = 376
  ClientWidth = 548
  ExplicitWidth = 554
  ExplicitHeight = 405
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 319
    Width = 548
    ExplicitTop = 319
    ExplicitWidth = 548
    inherited btnOK: TBitBtn
      Left = 331
      ExplicitLeft = 331
    end
    inherited btnCancel: TBitBtn
      Left = 441
      ExplicitLeft = 441
    end
  end
  object redtSource: TRzRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 542
    Height = 313
    Align = alClient
    BorderStyle = bsNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Zoom = 100
  end
end
