inherited CtrlMainForm: TCtrlMainForm
  BorderStyle = bsDialog
  Caption = #37319#36141#36890#26234#33021#21161#25163
  ClientHeight = 153
  ClientWidth = 337
  PopupMenu = pmTray
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 343
  ExplicitHeight = 182
  PixelsPerInch = 96
  TextHeight = 17
  object lbl1: TLabel
    Left = 72
    Top = 56
    Width = 175
    Height = 25
    Caption = #37319#36141#36890#26234#33021#21161#25163'1.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object pmTray: TPopupMenu
    Left = 280
    Top = 16
    object N1: TMenuItem
      Caption = #26412#22320#26381#21153
      object N5: TMenuItem
        Caption = #21551#21160
        OnClick = N5Click
      end
      object N6: TMenuItem
        Caption = #20572#27490
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = #35774#32622
        OnClick = N7Click
      end
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #24320#26426#21551#21160
    end
    object N2: TMenuItem
      Caption = #31995#32479#35774#32622
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Caption = #20851#20110#26234#33021#21161#25163
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object N9: TMenuItem
      Caption = #36864#20986
      OnClick = N9Click
    end
  end
  object rztrycnTool: TRzTrayIcon
    HideOnStartup = True
    PopupMenu = pmTray
    OnLButtonDblClick = rztrycnToolLButtonDblClick
    Left = 280
    Top = 88
  end
end
