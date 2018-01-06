inherited JobsForm: TJobsForm
  Caption = #25191#34892#24037#20316#31649#29702
  ClientHeight = 693
  ClientWidth = 1168
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 1184
  ExplicitHeight = 732
  PixelsPerInch = 96
  TextHeight = 17
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 1168
    Height = 53
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 0
    object btnSave: TBitBtn
      Left = 266
      Top = 7
      Width = 77
      Height = 36
      Caption = #20445#23384
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnStartJob: TBitBtn
      Left = 582
      Top = 7
      Width = 119
      Height = 36
      Caption = #21551#21160#24403#21069#24037#20316
      TabOrder = 1
      OnClick = btnStartJobClick
    end
    object btnStartAll: TBitBtn
      Left = 456
      Top = 7
      Width = 113
      Height = 36
      Caption = #21551#21160#20840#37096#24037#20316
      TabOrder = 2
      OnClick = btnStartAllClick
    end
    object btnStopJob: TBitBtn
      Left = 713
      Top = 7
      Width = 118
      Height = 36
      Caption = #20572#27490#24403#21069#24037#20316
      TabOrder = 3
      OnClick = btnStopJobClick
    end
    object dbnvgrJobs: TDBNavigator
      Left = 6
      Top = 7
      Width = 250
      Height = 36
      DataSource = dsJobs
      TabOrder = 4
    end
    object btnLoadJobs: TBitBtn
      Left = 349
      Top = 7
      Width = 78
      Height = 36
      Caption = #21047#26032
      TabOrder = 5
      OnClick = btnLoadJobsClick
    end
    object btnEnableAll: TBitBtn
      Left = 844
      Top = 7
      Width = 83
      Height = 36
      Caption = #20840#37096#21551#29992
      TabOrder = 6
      OnClick = btnEnableAllClick
    end
  end
  object rzspltr2: TRzSplitter
    Left = 0
    Top = 53
    Width = 1168
    Height = 640
    Orientation = orVertical
    Position = 436
    Percent = 68
    Align = alClient
    TabOrder = 1
    BarSize = (
      0
      436
      1168
      440)
    UpperLeftControls = (
      rzspltr1)
    LowerRightControls = (
      redtLog
      rzpnl3)
    object rzspltr1: TRzSplitter
      Left = 0
      Top = 0
      Width = 1168
      Height = 436
      Position = 874
      Percent = 75
      UsePercent = True
      Align = alClient
      TabOrder = 0
      BarSize = (
        874
        0
        878
        436)
      UpperLeftControls = (
        dbgrdhJobs)
      LowerRightControls = (
        rzpnl2)
      object dbgrdhJobs: TDBGridEh
        Left = 0
        Top = 0
        Width = 874
        Height = 436
        Align = alClient
        BorderStyle = bsNone
        DataSource = dsJobs
        DynProps = <>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        PopupMenu = pmJobs
        TabOrder = 0
        VertScrollBar.Width = 10
        OnDblClick = dbgrdhJobsDblClick
        Columns = <
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'sort_no'
            Footers = <>
            Title.Caption = #25191#34892#24207#21495
            Width = 77
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'job_name'
            Footers = <>
            Title.Caption = #20219#21153#21517#31216
            Width = 180
          end
          item
            ButtonStyle = cbsNone
            CellButtons = <
              item
                Style = ebsEllipsisEh
                Width = 36
                OnClick = dbgrdhJobsColumns2CellButtons0Click
              end>
            DynProps = <>
            EditButton.Visible = False
            EditButtons = <>
            FieldName = 'task_file'
            Footers = <>
            ReadOnly = True
            Title.Caption = #25991#20214
            Width = 380
          end
          item
            AlwaysShowEditButton = True
            CellButtons = <
              item
                ShortCut = 0
                Style = ebsPlusEh
                Width = 88
                OnClick = dbgrdhJobsColumns3CellButtons0Click
              end>
            DisplayFormat = 'yyyy-mm-dd hh:nn:ss'
            DynProps = <>
            EditButtons = <>
            FieldName = 'schedule'
            Footers = <>
            ReadOnly = True
            Title.Caption = #26102#38388#35745#21010
            Width = 80
          end
          item
            CellButtons = <>
            DynProps = <>
            EditButtons = <>
            FieldName = 'time_out'
            Footers = <>
            Title.Caption = #36229#26102
            Visible = False
            Width = 80
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
            Width = 120
          end>
        object RowDetailData: TRowDetailPanelControlEh
        end
      end
      object rzpnl2: TRzPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 436
        Align = alClient
        BorderOuter = fsFlat
        TabOrder = 0
        object pnl1: TPanel
          Left = 1
          Top = 1
          Width = 288
          Height = 41
          Align = alTop
          Caption = #26085#24535#25991#20214
          TabOrder = 0
        end
        object lstLogs: TRzShellList
          Left = 1
          Top = 42
          Width = 288
          Height = 393
          Align = alClient
          BorderStyle = bsNone
          FileFilter = '*.log'
          IconOptions.AutoArrange = True
          TabOrder = 1
          ViewStyle = vsList
        end
      end
    end
    object redtLog: TRichEdit
      Left = 0
      Top = 45
      Width = 1168
      Height = 155
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      Zoom = 100
    end
    object rzpnl3: TRzPanel
      Left = 0
      Top = 0
      Width = 1168
      Height = 45
      Align = alTop
      BorderOuter = fsFlat
      TabOrder = 1
      object btnClearLog: TBitBtn
        Left = 12
        Top = 8
        Width = 99
        Height = 31
        Caption = #28165#38500#26085#24535
        TabOrder = 0
        OnClick = btnClearLogClick
      end
    end
  end
  object cdsJobs: TClientDataSet
    PersistDataPacket.Data = {
      AE0000009619E0BD010000001800000006000000000003000000AE0007736F72
      745F6E6F0400010000000000086A6F625F6E616D650100490000000100055749
      445448020002008000097461736B5F66696C6502004900000001000557494454
      48020002000001087363686564756C6502004900000001000557494454480200
      020000040874696D655F6F757404000100000000000673746174757301004900
      000001000557494454480200020014000000}
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
    OnPostError = cdsJobsPostError
    Left = 538
    Top = 227
  end
  object dsJobs: TDataSource
    DataSet = cdsJobs
    Left = 538
    Top = 291
  end
  object pmJobs: TPopupMenu
    Left = 676
    Top = 230
    object AddJob: TMenuItem
      Caption = #28155#21152
    end
    object DeleteTJob: TMenuItem
      Caption = #21024#38500
      OnClick = DeleteTJobClick
    end
  end
  object dlgOpenTaskFile: TOpenDialog
    Filter = #20219#21153#25991#20214#65288'*.task'#65289'|*.task'
    Left = 298
    Top = 240
  end
  object tmrJobsSchedule: TTimer
    Enabled = False
    OnTimer = tmrJobsScheduleTimer
    Left = 680
    Top = 144
  end
end
