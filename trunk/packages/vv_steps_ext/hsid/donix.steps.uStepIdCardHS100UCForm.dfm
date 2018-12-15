inherited StepIdCardHS100UCForm: TStepIdCardHS100UCForm
  Caption = #21326#35270'100UC'#36523#20221#35777#35835#21345
  ClientHeight = 373
  ClientWidth = 679
  ExplicitWidth = 695
  ExplicitHeight = 412
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 316
    Width = 679
    ExplicitTop = 316
    ExplicitWidth = 679
    inherited btnOK: TBitBtn
      Left = 462
      ExplicitLeft = 462
    end
    inherited btnCancel: TBitBtn
      Left = 572
      ExplicitLeft = 572
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 679
    Height = 316
    ExplicitWidth = 679
    ExplicitHeight = 316
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      object lbl2: TLabel [2]
        Left = 22
        Top = 118
        Width = 84
        Height = 17
        Caption = #31561#24453#25918#21345#26102#38388
      end
      object lbl3: TLabel [3]
        Left = 22
        Top = 166
        Width = 84
        Height = 17
        Caption = #33258#21160#25195#25551#31471#21475
      end
      object edtWaitTime: TEdit
        Left = 142
        Top = 115
        Width = 305
        Height = 25
        TabOrder = 3
      end
      object mmoScanPorts: TMemo
        Left = 144
        Top = 168
        Width = 303
        Height = 89
        Lines.Strings = (
          '1001'
          '1002'
          '1003'
          '1004'
          '1005'
          '1006'
          '1007'
          '1008'
          '1009'
          '1010'
          '1011'
          '1012'
          '1013'
          '1014'
          '1015'
          '1016'
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16')
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
  end
end
