inherited StepJsonDataSetForm: TStepJsonDataSetForm
  Caption = 'Json'#36716'DataSet'
  ClientHeight = 583
  ClientWidth = 719
  OnCreate = FormCreate
  ExplicitWidth = 735
  ExplicitHeight = 622
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 526
    Width = 719
    ExplicitTop = 526
    ExplicitWidth = 719
    inherited btnOK: TBitBtn
      Left = 502
    end
    inherited btnCancel: TBitBtn
      Left = 612
    end
    object btnTest: TButton
      Left = 12
      Top = 12
      Width = 95
      Height = 37
      Caption = #27979#35797
      TabOrder = 2
      Visible = False
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 719
    Height = 526
    ExplicitHeight = 526
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 715
      ExplicitHeight = 499
      object lbl2: TLabel [1]
        Left = 52
        Top = 232
        Width = 56
        Height = 17
        Caption = #21407#22987#25968#25454
      end
      object lblParams: TLabel [2]
        Left = 52
        Top = 292
        Width = 56
        Height = 17
        Caption = #23383#27573#21442#25968
      end
      object lbl3: TLabel [4]
        Left = 24
        Top = 110
        Width = 84
        Height = 17
        Caption = #20027#25968#25454#38598#21517#31216
      end
      object lbl4: TLabel [5]
        Left = 36
        Top = 150
        Width = 70
        Height = 17
        Caption = #20027#32034#24341#23383#27573
      end
      object lbl5: TLabel [6]
        Left = 24
        Top = 190
        Width = 84
        Height = 17
        Caption = #32034#24341#23545#24212#23383#27573
      end
      inherited edtDescription: TEdit
        TabOrder = 4
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 5
        Visible = False
      end
      object edtDataRef: TEdit
        Left = 142
        Top = 229
        Width = 305
        Height = 25
        TabOrder = 1
      end
      object dbnvgrParams: TDBNavigator
        Left = 142
        Top = 267
        Width = 240
        Height = 25
        DataSource = dsParams
        TabOrder = 2
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 142
        Top = 292
        Width = 469
        Height = 169
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
            FieldName = 'field_name'
            Footers = <>
            Title.Caption = #23383#27573#21517
            Width = 105
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DropDownWidth = 260
            DynProps = <>
            EditButtons = <>
            FieldName = 'data_type'
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
            Title.Caption = #25968#25454#31867#22411
            Width = 177
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'size'
            Footers = <>
            Title.Caption = #38271#24230
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
            Visible = False
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object edtMasterSourceName: TEdit
        Left = 142
        Top = 107
        Width = 305
        Height = 25
        TabOrder = 6
      end
      object edtMasterFields: TEdit
        Left = 142
        Top = 147
        Width = 305
        Height = 25
        TabOrder = 7
      end
      object edtIndexFieldNames: TEdit
        Left = 142
        Top = 187
        Width = 305
        Height = 25
        TabOrder = 8
      end
      object chkCreateDataSource: TCheckBox
        Left = 142
        Top = 467
        Width = 379
        Height = 17
        Caption = #21019#24314#25968#25454#28304'(DataSource)'
        TabOrder = 9
      end
    end
  end
  object cdsParams: TClientDataSet
    PersistDataPacket.Data = {
      7A0000009619E0BD0100000018000000040000000000030000007A000A666965
      6C645F6E616D6501004900000001000557494454480200020040000964617461
      5F7479706504000100000000000473697A6504000100000000000D6465666175
      6C745F76616C756501004900000001000557494454480200020040000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'field_name'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'data_type'
        DataType = ftInteger
      end
      item
        Name = 'size'
        DataType = ftInteger
      end
      item
        Name = 'default_value'
        DataType = ftString
        Size = 64
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 634
    Top = 242
  end
  object dsParams: TDataSource
    DataSet = cdsParams
    Left = 632
    Top = 184
  end
end
