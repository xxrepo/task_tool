inherited BasicDlgForm: TBasicDlgForm
  BorderStyle = bsDialog
  Caption = 'BasicDlgForm'
  ClientHeight = 309
  ClientWidth = 645
  PixelsPerInch = 96
  TextHeight = 17
  object pnlOper: TPanel
    Left = 0
    Top = 252
    Width = 645
    Height = 57
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      645
      57)
    object btnOK: TBitBtn
      Left = 428
      Top = 10
      Width = 95
      Height = 39
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TBitBtn
      Left = 538
      Top = 10
      Width = 89
      Height = 39
      Anchors = [akTop, akRight]
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
    end
  end
end
