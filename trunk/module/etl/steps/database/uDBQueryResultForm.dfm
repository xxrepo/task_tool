inherited DBQueryResultForm: TDBQueryResultForm
  Caption = #25968#25454#24211#26597#35810
  ClientHeight = 532
  ClientWidth = 777
  ExplicitWidth = 793
  ExplicitHeight = 571
  PixelsPerInch = 96
  TextHeight = 17
  object rzpnlTop: TRzPanel
    Left = 0
    Top = 0
    Width = 777
    Height = 51
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 0
    ExplicitWidth = 635
    object btnExecute: TBitBtn
      Left = 12
      Top = 8
      Width = 71
      Height = 31
      Caption = #25191#34892
      TabOrder = 0
      OnClick = btnExecuteClick
    end
  end
  object rzspltrMain: TRzSplitter
    Left = 0
    Top = 51
    Width = 777
    Height = 481
    Orientation = orVertical
    Position = 157
    Percent = 33
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 174
    ExplicitTop = 142
    ExplicitWidth = 200
    ExplicitHeight = 100
    BarSize = (
      0
      157
      777
      161)
    UpperLeftControls = (
      redtSQL)
    LowerRightControls = (
      rzpnlResult
      dbgrdhResult)
    object redtSQL: TRichEdit
      Left = 0
      Top = 0
      Width = 777
      Height = 157
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Zoom = 100
    end
    object rzpnlResult: TRzPanel
      Left = 0
      Top = 0
      Width = 777
      Height = 53
      Align = alTop
      BorderOuter = fsFlat
      TabOrder = 0
      object lblMsg: TLabel
        Left = 12
        Top = 20
        Width = 70
        Height = 17
        Caption = #25191#34892#32467#26524#65306
      end
    end
    object dbgrdhResult: TDBGridEh
      Left = 0
      Top = 53
      Width = 777
      Height = 267
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsSql
      DynProps = <>
      HorzScrollBar.Height = 10
      TabOrder = 1
      VertScrollBar.Width = 10
      object RowDetailData: TRowDetailPanelControlEh
      end
    end
  end
  object unqrySql: TUniQuery
    Left = 384
    Top = 346
  end
  object dsSql: TDataSource
    DataSet = unqrySql
    Left = 382
    Top = 410
  end
end
