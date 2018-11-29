inherited StepFieldsMapForm: TStepFieldsMapForm
  Caption = 'Fields'#23383#27573#26144#23556
  ClientHeight = 512
  ExplicitHeight = 551
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 455
    ExplicitTop = 447
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 455
    ExplicitHeight = 447
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitHeight = 420
      object lbl2: TLabel [1]
        Left = 19
        Top = 115
        Width = 89
        Height = 17
        Caption = 'JsonArray'#25968#25454
      end
      object lblParams: TLabel [2]
        Left = 52
        Top = 156
        Width = 56
        Height = 17
        Caption = #36755#20986#21442#25968
      end
      inherited edtDescription: TEdit
        TabOrder = 4
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 5
      end
      object edtDataRef: TEdit
        Left = 142
        Top = 112
        Width = 305
        Height = 25
        TabOrder = 1
      end
      object dbnvgrParams: TDBNavigator
        Left = 142
        Top = 152
        Width = 240
        Height = 25
        DataSource = dsParams
        TabOrder = 2
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 142
        Top = 178
        Width = 469
        Height = 241
        DataSource = dsParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 3
        VertScrollBar.Width = 10
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'param_name'
            Footers = <>
            Title.Caption = #21442#25968#21517
            Width = 105
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DropDownWidth = 260
            DynProps = <>
            EditButtons = <>
            FieldName = 'param_value_ref'
            Footers = <>
            PickList.Strings = (
              'parent.'
              'self.MAX'
              'self.MIN'
              'self.SUM'
              'self.COUNT'
              'self.CONCAT'
              'self.MD5'
              'task.'
              'system.time'
              'system.timestamp')
            Title.Caption = #21442#25968#20540
            Width = 142
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
              'float'
              'currency'
              'datetime')
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
              '0'
              '-1'
              '2017-01-01 00:00:00')
            Title.Caption = #40664#35748#20540
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object cdsParams: TClientDataSet
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
    Left = 532
    Top = 88
  end
  object dsParams: TDataSource
    DataSet = cdsParams
    Left = 474
    Top = 88
  end
end
