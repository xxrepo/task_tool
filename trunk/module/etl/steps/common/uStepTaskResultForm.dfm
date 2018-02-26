inherited StepTaskResultForm: TStepTaskResultForm
  Caption = 'Task Result '#20219#21153#32467#26524#35774#32622
  ClientHeight = 507
  ClientWidth = 710
  ExplicitWidth = 716
  ExplicitHeight = 536
  PixelsPerInch = 96
  TextHeight = 17
  object lbl3: TLabel [0]
    Left = 53
    Top = 172
    Width = 56
    Height = 17
    Caption = 'Step'#35828#26126
  end
  inherited pnlOper: TPanel
    Top = 450
    Width = 710
    ExplicitTop = 450
    ExplicitWidth = 710
    inherited btnOK: TBitBtn
      Left = 493
      ExplicitLeft = 493
    end
    inherited btnCancel: TBitBtn
      Left = 603
      ExplicitLeft = 603
    end
  end
  inherited rzpgcntrlStepSettings: TRzPageControl
    Width = 710
    Height = 450
    ExplicitWidth = 710
    ExplicitHeight = 450
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 706
      ExplicitHeight = 423
      object lblParams: TLabel [1]
        Left = 51
        Top = 208
        Width = 57
        Height = 17
        Caption = #36755#20986'Data'
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl2: TLabel [3]
        Left = 76
        Top = 108
        Width = 32
        Height = 17
        Caption = 'Code'
      end
      object lbl4: TLabel [4]
        Left = 84
        Top = 148
        Width = 24
        Height = 17
        Caption = 'Msg'
      end
      inherited edtDescription: TEdit
        TabOrder = 3
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 4
        Visible = False
      end
      object dbgrdhInputParams: TDBGridEh
        Left = 142
        Top = 208
        Width = 469
        Height = 161
        DataSource = dsParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 1
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
      object dbnvgrParams: TDBNavigator
        Left = 142
        Top = 183
        Width = 240
        Height = 25
        DataSource = dsParams
        TabOrder = 2
      end
      object edtCode: TEdit
        Left = 142
        Top = 105
        Width = 305
        Height = 25
        TabOrder = 5
      end
      object chkExitTask: TCheckBox
        Left = 142
        Top = 385
        Width = 97
        Height = 17
        Caption = #32467#26463'Task'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
    end
  end
  object edtMsg: TEdit
    Left = 143
    Top = 169
    Width = 305
    Height = 25
    TabOrder = 2
  end
  object dsParams: TDataSource
    DataSet = cdsParams
    Left = 658
    Top = 84
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
    Left = 658
    Top = 144
  end
end
