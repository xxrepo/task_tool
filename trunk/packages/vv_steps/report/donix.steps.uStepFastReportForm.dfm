inherited StepFastReportForm: TStepFastReportForm
  Caption = 'FastReport'#25253#34920#25171#21360#35774#32622
  ClientHeight = 463
  ExplicitHeight = 502
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 406
    ExplicitTop = 406
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Height = 406
    ExplicitHeight = 406
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitHeight = 379
      object lbl2: TLabel [1]
        Left = 52
        Top = 112
        Width = 56
        Height = 17
        Caption = #25253#34920#25991#20214
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl5: TLabel [3]
        Left = 38
        Top = 156
        Width = 70
        Height = 17
        Caption = #25171#21360#26426#21517#31216
      end
      inherited chkRegDataToTask: TCheckBox
        Visible = False
      end
      object edtPrinterName: TEdit
        Left = 142
        Top = 153
        Width = 305
        Height = 25
        TabOrder = 3
      end
      object chkPreview: TCheckBox
        Left = 142
        Top = 199
        Width = 463
        Height = 17
        Caption = #25171#21360#21069#39044#35272#65288#22312#26381#21153#31243#24207#20013#35831#25351#23450#36755#20986#33267#29305#23450#25991#20214#22841#65289
        TabOrder = 4
      end
      object btnReportFile: TRzButtonEdit
        Left = 142
        Top = 109
        Width = 305
        Height = 25
        Text = ''
        TabOrder = 5
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnReportFileButtonClick
      end
      object btnDesign: TButton
        Left = 474
        Top = 108
        Width = 93
        Height = 28
        Caption = #25253#34920#35774#35745
        TabOrder = 6
        OnClick = btnDesignClick
      end
    end
    object rztbshtData: TRzTabSheet
      Caption = #25968#25454#35774#32622
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblParams: TLabel
        Left = 38
        Top = 183
        Width = 70
        Height = 17
        Caption = #25253#34920#25968#25454#38598
      end
      object lbl3: TLabel
        Left = 52
        Top = 20
        Width = 56
        Height = 17
        Caption = #21464#37327#21442#25968
      end
      object dbnvgrDatasetParams: TDBNavigator
        Left = 142
        Top = 179
        Width = 240
        Height = 25
        DataSource = dsDatasetParams
        TabOrder = 0
      end
      object dbgrdhDatasetParams: TDBGridEh
        Left = 142
        Top = 204
        Width = 469
        Height = 105
        DataSource = dsDatasetParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 1
        VertScrollBar.Width = 10
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'rpt_dataset_name'
            Footers = <>
            Title.Caption = #25253#34920#25968#25454#38598
            Width = 105
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DropDownWidth = 260
            DynProps = <>
            EditButtons = <>
            FieldName = 'dataset_object_ref'
            Footers = <>
            Title.Caption = #23454#38469#25968#25454#38598
            Width = 177
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'description'
            Footers = <>
            PickList.Strings = (
              'int'
              'string'
              'float'
              'currency'
              'datetime')
            Title.Caption = #35828#26126
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object dbnvgrVarParams: TDBNavigator
        Left = 142
        Top = 16
        Width = 240
        Height = 25
        DataSource = dsVarParams
        TabOrder = 2
      end
      object dbgrdhVarParams: TDBGridEh
        Left = 142
        Top = 42
        Width = 469
        Height = 119
        DataSource = dsVarParams
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
    end
  end
  object cdsDatasetParams: TClientDataSet
    PersistDataPacket.Data = {
      860000009619E0BD010000001800000003000000000003000000860010727074
      5F646174617365745F6E616D6501004900000001000557494454480200020040
      0012646174617365745F6F626A6563745F726566010049000000010005574944
      54480200020040000B6465736372697074696F6E010049000000010005574944
      54480200020020000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'rpt_dataset_name'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'dataset_object_ref'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'description'
        DataType = ftString
        Size = 32
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 634
    Top = 298
  end
  object dsDatasetParams: TDataSource
    DataSet = cdsDatasetParams
    Left = 632
    Top = 232
  end
  object dlgOpenFileName: TOpenDialog
    DefaultExt = 'fr3'
    Filter = 'FR3'#25253#34920#25991#20214#65288'*.fr3'#65289'|*.fr3'
    Options = [ofReadOnly, ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 37
    Top = 352
  end
  object dsVarParams: TDataSource
    DataSet = cdsVarParams
    Left = 632
    Top = 74
  end
  object cdsVarParams: TClientDataSet
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
    Left = 632
    Top = 134
  end
  object frxrprt1: TfrxReport
    Version = '5.6.1'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43124.798967847220000000
    ReportOptions.LastChange = 43124.798967847220000000
    ScriptLanguage = 'PascalScript'
    StoreInDFM = False
    Left = 33
    Top = 272
  end
end
