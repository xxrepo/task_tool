inherited StepConditionForm: TStepConditionForm
  Caption = #26465#20214#25511#21046
  ClientHeight = 536
  ClientWidth = 710
  ExplicitWidth = 726
  ExplicitHeight = 575
  PixelsPerInch = 96
  TextHeight = 17
  inherited pnlOper: TPanel
    Top = 479
    Width = 710
    ExplicitTop = 479
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
    Height = 479
    ExplicitWidth = 710
    ExplicitHeight = 479
    FixedDimension = 23
    inherited rztbshtCommon: TRzTabSheet
      ExplicitLeft = 1
      ExplicitTop = 24
      ExplicitWidth = 706
      ExplicitHeight = 452
      object lblParams: TLabel [1]
        Left = 52
        Top = 116
        Width = 56
        Height = 17
        Caption = #26465#20214#21442#25968
      end
      inherited lblDescription: TLabel
        Left = 52
        ExplicitLeft = 52
      end
      object lbl4: TLabel [3]
        Left = 24
        Top = 292
        Width = 84
        Height = 17
        Caption = #26465#20214#32467#26524#25191#34892
      end
      inherited edtDescription: TEdit
        TabOrder = 2
      end
      object dbnvgrParams: TDBNavigator [6]
        Left = 142
        Top = 112
        Width = 240
        Height = 25
        DataSource = dsConditionParams
        TabOrder = 1
      end
      inherited chkRegDataToTask: TCheckBox
        TabOrder = 3
        Visible = False
      end
      object dbgrdhConditionParams: TDBGridEh
        Left = 142
        Top = 140
        Width = 499
        Height = 131
        DataSource = dsConditionParams
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 4
        VertScrollBar.Width = 10
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'left_param_ref'
            Footers = <>
            PickList.Strings = (
              'parent.'
              'self.'
              'task.'
              'system.time'
              'system.timestamp')
            Title.Caption = #24038#21442
            Width = 150
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DropDownWidth = 260
            DynProps = <>
            EditButtons = <>
            FieldName = 'operator'
            Footers = <>
            KeyList.Strings = (
              '0'
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11')
            PickList.Strings = (
              #26080
              '=='
              '!='
              '<'
              '<='
              '>'
              '>='
              '+'
              '-'
              '*'
              '/'
              'MD5')
            Title.Caption = #36816#31639#31526
            Width = 80
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'right_param_ref'
            Footers = <>
            PickList.Strings = (
              'parent.'
              'self.'
              'task.'
              'system.time'
              'system.timestamp')
            Title.Caption = #21491#21442
            Width = 150
          end
          item
            CellButtons = <>
            DropDownSizing = True
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
            Width = 130
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object dbnvgr1: TDBNavigator
        Left = 142
        Top = 288
        Width = 240
        Height = 25
        DataSource = dsConditionResults
        TabOrder = 5
      end
      object dbgrdhConditionResults: TDBGridEh
        Left = 142
        Top = 316
        Width = 499
        Height = 105
        DataSource = dsConditionResults
        DynProps = <>
        HorzScrollBar.Height = 10
        TabOrder = 6
        VertScrollBar.Width = 10
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'result_value'
            Footers = <>
            PickList.Strings = (
              'TRUE'
              'FALSE'
              'parent.'
              'self.'
              'task.')
            Title.Caption = #32467#26524#20540
            Width = 150
          end
          item
            CellButtons = <>
            DropDownSizing = True
            DropDownWidth = 260
            DynProps = <>
            EditButtons = <>
            FieldName = 'result_action'
            Footers = <>
            PickList.Strings = (
              'step.'
              'END_STEP'
              'END_TASK')
            Title.Caption = #25191#34892#21160#20316
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
              'float')
            Title.Caption = #35828#26126
            Width = 150
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
    end
  end
  object dsConditionParams: TDataSource
    DataSet = cdsConditionParams
    Left = 324
    Top = 218
  end
  object cdsConditionParams: TClientDataSet
    PersistDataPacket.Data = {
      910000009619E0BD01000000180000000400000000000300000091000E6C6566
      745F706172616D5F72656601004900000001000557494454480200020040000F
      72696768745F706172616D5F7265660100490000000100055749445448020002
      004000086F70657261746F7204000100000000000A706172616D5F7479706501
      004900000001000557494454480200020014000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'left_param_ref'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'right_param_ref'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'operator'
        DataType = ftInteger
      end
      item
        Name = 'param_type'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 442
    Top = 220
  end
  object cdsConditionResults: TClientDataSet
    PersistDataPacket.Data = {
      7D0000009619E0BD0100000018000000030000000000030000007D000C726573
      756C745F76616C756502004900000001000557494454480200020000020D7265
      73756C745F616374696F6E01004900000001000557494454480200020080000B
      6465736372697074696F6E010049000000010005574944544802000200400000
      00}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'result_value'
        DataType = ftString
        Size = 512
      end
      item
        Name = 'result_action'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'description'
        DataType = ftString
        Size = 64
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 42
    Top = 358
  end
  object dsConditionResults: TDataSource
    DataSet = cdsConditionResults
    Left = 40
    Top = 414
  end
end
