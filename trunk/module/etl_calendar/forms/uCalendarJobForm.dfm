inherited CalendarJobForm: TCalendarJobForm
  Caption = #21516#27493#20219#21153#25191#34892
  ClientHeight = 466
  ClientWidth = 760
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 776
  ExplicitHeight = 505
  PixelsPerInch = 96
  TextHeight = 17
  inherited rzspltrLogForm: TRzSplitter
    Top = 57
    Width = 760
    Height = 409
    Position = 158
    Percent = 39
    UpperLeft.Visible = False
    ExplicitTop = 57
    ExplicitWidth = 760
    ExplicitHeight = 409
    UpperLeftControls = (
      dbgrdhJobs)
    LowerRightControls = (
      redtLog
      rzpnl3)
    object dbgrdhJobs: TDBGridEh [0]
      Left = 0
      Top = 0
      Width = 760
      Height = 0
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsJobs
      DynProps = <>
      ReadOnly = True
      TabOrder = 0
      VertScrollBar.Width = 10
      Columns = <
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'sort_no'
          Footers = <>
          Title.Caption = #25191#34892#24207#21495
          Width = 130
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'job_name'
          Footers = <>
          Title.Caption = #20219#21153#21517#31216
          Width = 286
        end
        item
          CellButtons = <>
          DynProps = <>
          EditButtons = <>
          FieldName = 'status'
          Footers = <>
          KeyList.Strings = (
            '0'
            '1')
          PickList.Strings = (
            #31105#29992
            #21551#29992)
          Title.Caption = #29366#24577
          Width = 156
        end>
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
    inherited redtLog: TRichEdit
      Width = 760
      Height = 364
      ExplicitWidth = 760
      ExplicitHeight = 364
    end
    inherited rzpnl3: TRzPanel
      Width = 760
      ExplicitWidth = 760
    end
  end
  object rzpnlTop: TRzPanel
    Left = 0
    Top = 0
    Width = 760
    Height = 57
    Align = alTop
    BorderOuter = fsFlat
    BorderSides = [sdLeft, sdTop, sdRight]
    TabOrder = 1
    DesignSize = (
      760
      57)
    object btnSetting: TBitBtn
      Left = 668
      Top = 14
      Width = 75
      Height = 32
      Anchors = [akTop, akRight]
      Caption = #35774#32622
      TabOrder = 0
      OnClick = btnSettingClick
    end
    object dtpDate: TDateTimePicker
      Left = 12
      Top = 14
      Width = 145
      Height = 25
      Date = 43199.675914317130000000
      Format = 'yyyy-MM-dd'
      Time = 43199.675914317130000000
      TabOrder = 1
      OnCloseUp = dtpDateCloseUp
    end
    object btnSyncFromApi: TBitBtn
      Left = 178
      Top = 10
      Width = 127
      Height = 32
      Caption = #20174#32447#19978#21516#27493
      TabOrder = 2
      OnClick = btnSyncFromApiClick
    end
    object btnSyncFromFile: TBitBtn
      Left = 322
      Top = 10
      Width = 127
      Height = 32
      Caption = #20174#25991#20214#21516#27493
      TabOrder = 3
      OnClick = btnSyncFromFileClick
    end
  end
  object dsJobs: TDataSource
    DataSet = cdsJobs
    Left = 638
    Top = 289
  end
  object cdsJobs: TClientDataSet
    PersistDataPacket.Data = {
      C20000009619E0BD010000001800000007000000000003000000C20007736F72
      745F6E6F0400010000000000086A6F625F6E616D650100490000000100055749
      445448020002008000097461736B5F66696C6502004900000001000557494454
      48020002000001087363686564756C6502004900000001000557494454480200
      020000040874696D655F6F757404000100000000000B696E7465726163746976
      6504000100000000000673746174757301004900000001000557494454480200
      020014000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'sort_no'
        DataType = ftInteger
      end
      item
        Name = 'job_name'
        DataType = ftString
        Size = 128
      end
      item
        Name = 'task_file'
        DataType = ftString
        Size = 256
      end
      item
        Name = 'schedule'
        DataType = ftString
        Size = 1024
      end
      item
        Name = 'time_out'
        DataType = ftInteger
      end
      item
        Name = 'interactive'
        DataType = ftInteger
      end
      item
        Name = 'status'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <
      item
        Name = 'PK_job_name'
        Fields = 'job_name'
        Options = [ixPrimary, ixUnique]
      end>
    IndexFieldNames = 'sort_no;job_name'
    Params = <>
    StoreDefs = True
    Left = 640
    Top = 225
  end
end
