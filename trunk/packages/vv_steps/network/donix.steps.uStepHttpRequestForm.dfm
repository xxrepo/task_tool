inherited StepHttpRequestForm: TStepHttpRequestForm
  Caption = 'Http Request '#35831#27714
  ClientHeight = 529
  ClientWidth = 723
  ExplicitWidth = 739
  ExplicitHeight = 568
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 472
    Width = 723
    ExplicitTop = 472
    ExplicitWidth = 723
    inherited btnOK: TBitBtn
      Left = 506
      ExplicitLeft = 506
    end
    inherited btnCancel: TBitBtn
      Left = 616
      ExplicitLeft = 616
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 723
    Height = 472
    ExplicitWidth = 723
    ExplicitHeight = 472
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 719
      ExplicitHeight = 445
      object lbl2: TLabel [1]
        Left = 50
        Top = 114
        Width = 56
        Height = 17
        Caption = #30446#26631#22320#22336
      end
      object lblParams: TLabel [2]
        Left = 52
        Top = 220
        Width = 56
        Height = 17
        Caption = #35831#27714#21442#25968
      end
      object lbl3: TLabel [3]
        Left = 50
        Top = 412
        Width = 56
        Height = 17
        Caption = #35831#27714#26041#24335
      end
      inherited edtDescription: TEdit
        TabOrder = 4
      end
      object dbnvgrParams: TDBNavigator [7]
        Left = 142
        Top = 216
        Width = 240
        Height = 25
        DataSource = dsParams
        TabOrder = 1
      end
      object rbGet: TRadioButton [8]
        Left = 140
        Top = 413
        Width = 71
        Height = 17
        Caption = 'GET'
        TabOrder = 2
      end
      object rbPost: TRadioButton [9]
        Left = 238
        Top = 413
        Width = 83
        Height = 17
        Caption = 'Post'
        Checked = True
        TabOrder = 3
        TabStop = True
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 5
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 142
        Top = 244
        Width = 469
        Height = 159
        DataSource = dsParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 6
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
              'self.'
              'task.'
              'system.time'
              'system.timestamp')
            Title.Caption = #21442#25968#20540
            Width = 177
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
              '0'
              '-1'
              '2017-01-01 00:00:00')
            Title.Caption = #40664#35748#20540
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object mmoUrl: TMemo
        Left = 142
        Top = 111
        Width = 469
        Height = 92
        ScrollBars = ssVertical
        TabOrder = 7
      end
    end
    object rztbshtResponse: TRzTabSheet
      TabVisible = False
      Caption = #36755#20986#35774#32622
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbl4: TLabel
        Left = 42
        Top = 32
        Width = 56
        Height = 17
        Caption = #36820#22238#32467#26524
      end
      object dbgrdh1: TDBGridEh
        Left = 132
        Top = 56
        Width = 499
        Height = 237
        DataSource = dsRspParams
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
              'self.'
              'task.'
              'system.time'
              'system.timestamp')
            Title.Caption = #21442#25968#20540
            Width = 177
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
              '0'
              '-1'
              '2017-01-01 00:00:00')
            Title.Caption = #40664#35748#20540
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object dbnvgr1: TDBNavigator
        Left = 132
        Top = 28
        Width = 240
        Height = 25
        DataSource = dsRspParams
        TabOrder = 1
      end
    end
  end
  object dsParams: TDataSource
    DataSet = cdsParams
    Left = 646
    Top = 242
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
    Left = 646
    Top = 298
  end
  object cdsRspParams: TClientDataSet
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
    Left = 650
    Top = 60
  end
  object dsRspParams: TDataSource
    DataSet = cdsRspParams
    Left = 648
    Top = 114
  end
end
