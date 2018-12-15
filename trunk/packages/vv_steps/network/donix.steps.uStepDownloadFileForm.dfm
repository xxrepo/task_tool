inherited StepDownloadFileForm: TStepDownloadFileForm
  Caption = 'Http'#25991#20214#19979#36733
  ClientHeight = 556
  ClientWidth = 723
  ExplicitWidth = 739
  ExplicitHeight = 595
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 499
    Width = 723
    ExplicitTop = 499
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
    Height = 499
    ExplicitWidth = 723
    ExplicitHeight = 499
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 719
      ExplicitHeight = 472
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
      object lblSaveTo: TLabel [4]
        Left = 66
        Top = 426
        Width = 42
        Height = 17
        Caption = #20445#23384#20026
      end
      inherited edtDescription: TEdit
        TabOrder = 2
      end
      object dbnvgrParams: TDBNavigator [7]
        Left = 142
        Top = 216
        Width = 240
        Height = 25
        DataSource = dsParams
        TabOrder = 1
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 3
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 142
        Top = 244
        Width = 469
        Height = 159
        DataSource = dsParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 4
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
        TabOrder = 5
      end
      object btnSaveToPath: TRzButtonEdit
        Left = 142
        Top = 423
        Width = 305
        Height = 25
        Text = ''
        TabOrder = 6
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnSaveToPathButtonClick
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
