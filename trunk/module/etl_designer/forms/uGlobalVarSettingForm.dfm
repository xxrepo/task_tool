inherited GlobalVarSettingForm: TGlobalVarSettingForm
  Caption = #20840#23616#21442#25968#35774#32622
  ClientHeight = 543
  ClientWidth = 759
  ExplicitWidth = 775
  ExplicitHeight = 582
  PixelsPerInch = 96
  TextHeight = 17
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 759
    Height = 71
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 0
    ExplicitWidth = 602
    object lbl1: TLabel
      Left = 14
      Top = 13
      Width = 84
      Height = 17
      Caption = #20840#23616#21442#25968#35774#32622
    end
    object dbnvgrParams: TDBNavigator
      Left = 8
      Top = 46
      Width = 240
      Height = 25
      DataSource = dsParams
      TabOrder = 0
    end
  end
  object rzpnl2: TRzPanel
    Left = 0
    Top = 485
    Width = 759
    Height = 58
    Align = alBottom
    BorderOuter = fsFlat
    TabOrder = 1
    ExplicitTop = 370
    ExplicitWidth = 602
    object btnOK: TBitBtn
      Left = 20
      Top = 10
      Width = 87
      Height = 39
      Caption = #20445#23384
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      Left = 124
      Top = 10
      Width = 87
      Height = 39
      Caption = #20851#38381
      ModalResult = 2
      TabOrder = 0
    end
  end
  object dbgrdhInputParams: TDBGridEh
    Left = 0
    Top = 71
    Width = 759
    Height = 414
    Align = alClient
    BorderStyle = bsNone
    DataSource = dsParams
    DynProps = <>
    HorzScrollBar.Height = 10
    TabOrder = 2
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
        FieldName = 'param_value'
        Footers = <>
        Title.Caption = #21442#25968#20540
        Width = 410
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'description'
        Footers = <>
        Title.Caption = #35828#26126
        Width = 189
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dsParams: TDataSource
    DataSet = cdsParams
    Left = 534
    Top = 196
  end
  object cdsParams: TClientDataSet
    PersistDataPacket.Data = {
      790000009619E0BD01000000180000000300000000000300000079000A706172
      616D5F6E616D6501004900000001000557494454480200020040000B70617261
      6D5F76616C756502004900000001000557494454480200020000080B64657363
      72697074696F6E01004900000001000557494454480200020040000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'param_name'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'param_value'
        DataType = ftString
        Size = 2048
      end
      item
        Name = 'description'
        DataType = ftString
        Size = 64
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 534
    Top = 256
  end
end
