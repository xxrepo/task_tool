inherited StepJson2TableForm: TStepJson2TableForm
  Caption = 'SQL Query'
  ClientHeight = 424
  ClientWidth = 687
  OnShow = FormShow
  ExplicitWidth = 703
  ExplicitHeight = 463
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 367
    Width = 687
    ExplicitTop = 331
    ExplicitWidth = 687
    inherited btnOK: TBitBtn
      Left = 470
      ExplicitLeft = 470
    end
    inherited btnCancel: TBitBtn
      Left = 580
      ExplicitLeft = 580
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 687
    Height = 367
    ExplicitWidth = 687
    ExplicitHeight = 331
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 683
      ExplicitHeight = 304
      object lbl2: TRzLabel [1]
        Left = 64
        Top = 199
        Width = 42
        Height = 17
        Alignment = taRightJustify
        Caption = #30446#26631#34920
      end
      object lblDb: TRzLabel [2]
        Left = 64
        Top = 157
        Width = 42
        Height = 17
        Alignment = taRightJustify
        Caption = #25968#25454#24211
      end
      object lbl3: TRzLabel [4]
        Left = 15
        Top = 241
        Width = 105
        Height = 17
        Alignment = taRightJustify
        Caption = 'Unique Key Fields'
      end
      object lbl4: TLabel [5]
        Left = 64
        Top = 114
        Width = 42
        Height = 17
        Caption = #28304#25968#25454
      end
      inherited edtDescription: TEdit
        TabOrder = 3
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 4
      end
      object btnDbConfig: TBitBtn
        Left = 474
        Top = 154
        Width = 75
        Height = 27
        Caption = #37197#32622
        TabOrder = 1
        OnClick = btnDbConfigClick
      end
      object cbbDbCon: TComboBox
        Left = 142
        Top = 154
        Width = 305
        Height = 25
        Style = csDropDownList
        TabOrder = 2
      end
      object edtTableName: TEdit
        Left = 142
        Top = 196
        Width = 305
        Height = 25
        TabOrder = 5
      end
      object edtUniqueKeyFields: TEdit
        Left = 142
        Top = 238
        Width = 305
        Height = 25
        TabOrder = 6
      end
      object chkSkipExist: TCheckBox
        Left = 142
        Top = 285
        Width = 189
        Height = 17
        Caption = #36339#36807#24050#32463#23384#22312#30340#25968#25454
        TabOrder = 7
      end
      object edtDataRef: TEdit
        Left = 142
        Top = 111
        Width = 305
        Height = 25
        TabOrder = 8
      end
    end
  end
end
