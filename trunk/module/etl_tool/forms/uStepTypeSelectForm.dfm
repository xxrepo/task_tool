inherited StepTypeSelectForm: TStepTypeSelectForm
  Caption = #36873#25321'Step'#31867#22411
  ClientHeight = 396
  ClientWidth = 407
  OnCreate = FormCreate
  ExplicitWidth = 413
  ExplicitHeight = 425
  PixelsPerInch = 96
  TextHeight = 19
  inherited pnlOper: TPanel
    Top = 339
    Width = 407
    ExplicitTop = 339
    ExplicitWidth = 289
    inherited btnOK: TBitBtn
      Left = 199
      OnClick = btnOKClick
      ExplicitLeft = 81
    end
    inherited btnCancel: TBitBtn
      Left = 300
      ExplicitLeft = 182
    end
  end
  object dbgrdhStepTypes: TDBGridEh
    Left = 0
    Top = 0
    Width = 407
    Height = 339
    Align = alClient
    ColumnDefValues.Title.Color = clBtnFace
    DataSource = dsStepTypes
    DynProps = <>
    TabOrder = 1
    TitleParams.Color = clBackground
    VertScrollBar.Width = 10
    OnDblClick = dbgrdhStepTypesDblClick
    Columns = <
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'step_group'
        Footers = <>
        Title.Caption = #20998#32452
        Width = 120
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'step_type'
        Footers = <>
        Title.Caption = 'ID'
        Visible = False
        Width = 100
      end
      item
        CellButtons = <>
        DynProps = <>
        EditButtons = <>
        FieldName = 'step_type_name'
        Footers = <>
        Title.Caption = 'Step'#31867#22411
        Width = 250
      end>
    object RowDetailData: TRowDetailPanelControlEh
    end
  end
  object dsStepTypes: TDataSource
    DataSet = cdsStepTypes
    Left = 162
    Top = 234
  end
  object cdsStepTypes: TClientDataSet
    PersistDataPacket.Data = {
      7A0000009619E0BD0100000018000000030000000000030000007A0009737465
      705F7479706501004900000001000557494454480200020040000E737465705F
      747970655F6E616D6501004900000001000557494454480200020020000A7374
      65705F67726F757001004900000001000557494454480200020020000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'step_type'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'step_type_name'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'step_group'
        DataType = ftString
        Size = 32
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 160
    Top = 164
  end
end
