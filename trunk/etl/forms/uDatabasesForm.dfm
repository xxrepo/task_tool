inherited DatabasesForm: TDatabasesForm
  Caption = #25968#25454#24211#38142#25509#31649#29702
  ClientHeight = 358
  ClientWidth = 386
  OnClose = FormClose
  ExplicitWidth = 402
  ExplicitHeight = 397
  PixelsPerInch = 96
  TextHeight = 17
  object rzpnlTop: TRzPanel
    Left = 0
    Top = 0
    Width = 386
    Height = 57
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 0
    object rzbtbtnAddDb: TRzBitBtn
      Left = 16
      Top = 11
      Height = 35
      Caption = #28155#21152
      TabOrder = 0
      OnClick = rzbtbtnAddDbClick
    end
  end
  object dbgrdhDatabases: TDBGridEh
    Left = 0
    Top = 57
    Width = 386
    Height = 301
    Align = alClient
    BorderStyle = bsNone
    DataSource = dsDatabases
    DynProps = <>
    PopupMenu = pmDatabases
    ReadOnly = True
    TabOrder = 1
    OnDblClick = dbgrdhDatabasesDblClick
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'db_title'
        Footers = <>
        Title.Caption = #21517#31216
        Width = 130
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'connection_str'
        Footers = <>
        Title.Caption = #21442#25968
        Width = 220
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'password'
        Footers = <>
        Visible = False
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object cdsDatabases: TClientDataSet
    PersistDataPacket.Data = {
      980000009619E0BD01000000180000000400000000000300000098000864625F
      7469746C6501004900000001000557494454480200020040000E636F6E6E6563
      74696F6E5F737472020049000000010005574944544802000200000408706173
      73776F726401004900000001000557494454480200020040000C737065636966
      69635F73747202004900000001000557494454480200020000040000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'db_title'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'connection_str'
        DataType = ftString
        Size = 1024
      end
      item
        Name = 'password'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'specific_str'
        DataType = ftString
        Size = 1024
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 264
    Top = 160
  end
  object dsDatabases: TDataSource
    DataSet = cdsDatabases
    Left = 264
    Top = 232
  end
  object uncnctdlgDbs: TUniConnectDialog
    DatabaseLabel = #25968#25454#24211#21517#31216
    PortLabel = #31471#21475
    ProviderLabel = #39537#21160#31867#22411
    Caption = #25968#25454#24211#36830#25509
    UsernameLabel = #29992#25143#21517
    PasswordLabel = #23494#30721
    ServerLabel = #26381#21153#22120
    ConnectButton = #36830#25509#27979#35797
    CancelButton = #21462#28040
    LabelSet = lsCustom
    Left = 332
    Top = 168
  end
  object conDbs: TUniConnection
    ConnectDialog = uncnctdlgDbs
    LoginPrompt = False
    Left = 330
    Top = 110
  end
  object sqlsrvrnprvdr1: TSQLServerUniProvider
    Left = 42
    Top = 296
  end
  object mysqlnprvdr1: TMySQLUniProvider
    Left = 120
    Top = 296
  end
  object orclnprvdr1: TOracleUniProvider
    Left = 32
    Top = 240
  end
  object sqltnprvdr1: TSQLiteUniProvider
    Left = 32
    Top = 176
  end
  object odbcnprvdr1: TODBCUniProvider
    Left = 40
    Top = 120
  end
  object pmDatabases: TPopupMenu
    Left = 164
    Top = 156
    object AddDatabase: TMenuItem
      Caption = #28155#21152
      OnClick = rzbtbtnAddDbClick
    end
    object EditDatabase: TMenuItem
      Caption = #20462#25913
      OnClick = dbgrdhDatabasesDblClick
    end
    object DeleteDatabase: TMenuItem
      Caption = #21024#38500
      OnClick = DeleteDatabaseClick
    end
  end
end
