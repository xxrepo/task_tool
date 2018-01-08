inherited StepFastReportForm: TStepFastReportForm
  Caption = 'FastReport'#25253#34920#25171#21360#35774#32622
  ClientHeight = 463
  ExplicitHeight = 492
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 406
    ExplicitTop = 447
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
    Height = 406
    ExplicitHeight = 447
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitHeight = 420
      object lbl2: TLabel [1]
        Left = 52
        Top = 112
        Width = 56
        Height = 17
        Caption = #25253#34920#25991#20214
      end
      object lblParams: TLabel [2]
        Left = 38
        Top = 172
        Width = 70
        Height = 17
        Caption = #25253#34920#25968#25454#38598
      end
      object lbl5: TLabel [4]
        Left = 38
        Top = 332
        Width = 70
        Height = 17
        Caption = #25171#21360#26426#21517#31216
      end
      inherited edtDescription: TEdit
        TabOrder = 3
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 4
        Visible = False
      end
      object dbnvgrParams: TDBNavigator
        Left = 142
        Top = 147
        Width = 240
        Height = 25
        DataSource = dsParams
        TabOrder = 1
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 142
        Top = 172
        Width = 469
        Height = 105
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
            FieldName = 'frx_dataset_name'
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
      object edtPrinterName: TEdit
        Left = 142
        Top = 329
        Width = 305
        Height = 25
        TabOrder = 5
      end
      object chkPreview: TCheckBox
        Left = 142
        Top = 303
        Width = 431
        Height = 17
        Caption = #25171#21360#21069#39044#35272#65288#22312#26381#21153#31243#24207#20013#35831#25351#23450#36755#20986#33267#29305#23450#25991#20214#22841#65289
        TabOrder = 6
      end
      object btnReportFile: TRzButtonEdit
        Left = 142
        Top = 109
        Width = 305
        Height = 25
        Text = ''
        TabOrder = 7
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = btnReportFileButtonClick
      end
    end
  end
  object cdsParams: TClientDataSet
    PersistDataPacket.Data = {
      7A0000009619E0BD0100000018000000030000000000030000007A0010667278
      5F646174617365745F6E616D6501004900000001000557494454480200020040
      0012646174617365745F6F626A6563745F72656604000100000000000B646573
      6372697074696F6E01004900000001000557494454480200020020000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'frx_dataset_name'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'dataset_object_ref'
        DataType = ftInteger
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
    Top = 242
  end
  object dsParams: TDataSource
    DataSet = cdsParams
    Left = 632
    Top = 184
  end
  object dlgOpenFileName: TOpenDialog
    DefaultExt = 'fr3'
    Filter = 'FR3'#25253#34920#25991#20214#65288'*.fr3'#65289'|*.fr3'
    Options = [ofReadOnly, ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 519
    Top = 98
  end
end
