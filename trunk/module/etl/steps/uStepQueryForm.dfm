inherited StepQueryForm: TStepQueryForm
  Caption = 'SQL Query'
  ClientHeight = 449
  ClientWidth = 687
  OnShow = FormShow
  ExplicitWidth = 693
  ExplicitHeight = 478
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 392
    Width = 687
    ExplicitTop = 392
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
    Height = 392
    ExplicitWidth = 687
    ExplicitHeight = 392
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitWidth = 683
      ExplicitHeight = 365
      object lbl2: TRzLabel [1]
        Left = 39
        Top = 159
        Width = 67
        Height = 17
        Alignment = taRightJustify
        Caption = 'Query SQL'
      end
      object lblDb: TRzLabel [2]
        Left = 64
        Top = 117
        Width = 42
        Height = 17
        Alignment = taRightJustify
        Caption = #25968#25454#24211
      end
      inherited edtDescription: TEdit
        TabOrder = 4
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 5
      end
      object mmoQuerySQL: TRzMemo
        Left = 142
        Top = 159
        Width = 407
        Height = 176
        TabOrder = 1
      end
      object btnDbConfig: TBitBtn
        Left = 474
        Top = 114
        Width = 75
        Height = 27
        Caption = #37197#32622
        TabOrder = 2
        OnClick = btnDbConfigClick
      end
      object cbbDbCon: TComboBox
        Left = 142
        Top = 114
        Width = 305
        Height = 25
        Style = csDropDownList
        TabOrder = 3
      end
    end
    object rztbshtParams: TRzTabSheet
      Caption = 'SQL'#20837#21442#32465#23450
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblParams: TLabel
        Left = 40
        Top = 24
        Width = 56
        Height = 17
        Caption = #21442#25968#35774#32622
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 124
        Top = 24
        Width = 435
        Height = 251
        DataSource = dsInputParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 0
        VertScrollBar.Width = 10
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'param_name'
            Footers = <>
            Title.Caption = #21442#25968#21517
            Width = 120
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DropDownWidth = 180
            DynProps = <>
            EditButtons = <>
            FieldName = 'param_value_ref'
            Footers = <>
            PickList.Strings = (
              'parent.'
              'self.'
              'task.'
              'system.time'
              'system.timestamp')
            Title.Caption = #21442#25968#20540
            Width = 120
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'param_type'
            Footers = <>
            PickList.Strings = (
              'int'
              'string'
              'float')
            Title.Caption = #21442#25968#31867#22411
            Width = 90
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DynProps = <>
            EditButtons = <>
            FieldName = 'default_value'
            Footers = <>
            PickList.Strings = (
              ''
              '-1'
              '2017-01-01 00:00:00')
            Title.Caption = #40664#35748#20540
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object btnParseSqlParams: TBitBtn
        Left = 122
        Top = 294
        Width = 113
        Height = 25
        Caption = #35299#26512'SQL'#21442#25968
        TabOrder = 1
        OnClick = btnParseSqlParamsClick
      end
    end
  end
  object unqrySql: TUniQuery
    Left = 47
    Top = 240
  end
  object cdsInputParams: TClientDataSet
    PersistDataPacket.Data = {
      9E0000009619E0BD0100000018000000040000000000030000009E000A706172
      616D5F6E616D6501004900000001000557494454480200020040000F70617261
      6D5F76616C75655F72656601004900000001000557494454480200020040000A
      706172616D5F7479706501004900000001000557494454480200020014000D64
      656661756C745F76616C75650100490000000100055749445448020002004000
      0000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'param_name'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'param_value_ref'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'param_type'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'default_value'
        DataType = ftString
        Size = 64
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 600
    Top = 200
  end
  object dsInputParams: TDataSource
    DataSet = cdsInputParams
    Left = 602
    Top = 142
  end
end
