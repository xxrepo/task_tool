inherited SelectFolderForm: TSelectFolderForm
  Caption = #36335#24452#36873#25321
  ClientHeight = 470
  ClientWidth = 400
  Font.Height = -16
  ExplicitWidth = 406
  ExplicitHeight = 499
  PixelsPerInch = 96
  TextHeight = 19
  inherited pnlOper: TPanel
    Top = 413
    Width = 400
    ExplicitTop = 413
    ExplicitWidth = 400
    inherited btnOK: TBitBtn
      Left = 183
      OnClick = btnOKClick
      ExplicitLeft = 183
    end
    inherited btnCancel: TBitBtn
      Left = 293
      ExplicitLeft = 293
    end
  end
  object rzshltrFolder: TRzShellTree
    Left = 0
    Top = 0
    Width = 400
    Height = 413
    Align = alClient
    Indent = 19
    Options = [stoAutoFill, stoDefaultKeyHandling, stoContextMenus, stoDynamicRefresh, stoOleDrag, stoOleDrop, stoShowHidden]
    SelectionPen.Color = clBtnShadow
    TabOrder = 1
    OnDblClick = rzshltrFolderDblClick
    ExplicitTop = -2
    ExplicitWidth = 150
    ExplicitHeight = 150
  end
end
