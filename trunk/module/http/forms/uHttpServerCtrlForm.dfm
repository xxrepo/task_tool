object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 354
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 396
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 0
    OnClick = btn1Click
  end
  object mmo1: TMemo
    Left = 8
    Top = 80
    Width = 704
    Height = 266
    Lines.Strings = (
      'mmo1')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object idhttpsrvrJobDispatch: TIdHttpServerExt
    Bindings = <>
    OnCommandOther = idhttpsrvrJobDispatchCommandOther
    OnCommandGet = idhttpsrvrJobDispatchCommandGet
    Left = 40
    Top = 24
  end
end
