inherited MakeDirForm: TMakeDirForm
  Caption = #25991#20214#22841
  ClientHeight = 157
  ClientWidth = 429
  OnShow = FormShow
  ExplicitWidth = 435
  ExplicitHeight = 186
  PixelsPerInch = 96
  TextHeight = 17
  object lbl1: TLabel [0]
    Left = 38
    Top = 40
    Width = 42
    Height = 17
    Caption = #21517#31216#65306
  end
  inherited pnlOper: TPanel
    Top = 100
    Width = 429
    ExplicitTop = 122
    ExplicitWidth = 429
    inherited btnOK: TBitBtn
      Left = 212
      ExplicitLeft = 212
    end
    inherited btnCancel: TBitBtn
      Left = 322
      ExplicitLeft = 322
    end
  end
  object edtFolderName: TEdit
    Left = 110
    Top = 38
    Width = 249
    Height = 25
    TabOrder = 1
  end
end
