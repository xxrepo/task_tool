inherited TaskEditForm: TTaskEditForm
  Caption = #39033#30446#20219#21153#35774#35745
  ClientHeight = 612
  ClientWidth = 858
  WindowState = wsMaximized
  OnDestroy = FormDestroy
  ExplicitWidth = 874
  ExplicitHeight = 651
  PixelsPerInch = 96
  TextHeight = 17
  inherited rzspltrLogForm: TRzSplitter
    Width = 858
    Height = 593
    Position = 336
    Percent = 57
    TabOrder = 1
    ExplicitWidth = 858
    ExplicitHeight = 593
    UpperLeftControls = (
      rzpnlTop
      chktrTaskSteps)
    LowerRightControls = (
      redtLog
      rzpnl3)
    object rzpnlTop: TRzPanel [0]
      Left = 0
      Top = 0
      Width = 858
      Height = 57
      Align = alTop
      BorderOuter = fsFlat
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        858
        57)
      object rzbtbtnSave: TRzBitBtn
        Left = 13
        Top = 12
        Width = 81
        Height = 33
        Caption = #20445#23384
        TabOrder = 0
        OnClick = rzbtbtnSaveClick
      end
      object rzbtbtnRunSchedual: TRzBitBtn
        Left = 741
        Top = 12
        Width = 86
        Height = 33
        Anchors = [akTop, akRight]
        Caption = #21478#23384#20026'...'
        TabOrder = 1
        Visible = False
      end
      object btnStart: TBitBtn
        Left = 114
        Top = 12
        Width = 89
        Height = 33
        Caption = #36816#34892
        TabOrder = 2
        OnClick = btnStartClick
      end
    end
    object chktrTaskSteps: TRzCheckTree [1]
      Left = 0
      Top = 57
      Width = 858
      Height = 279
      CascadeChecks = False
      Align = alClient
      AutoExpand = True
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      Indent = 19
      ParentFont = False
      PopupMenu = pmTaskSteps
      RightClickSelect = True
      SelectionPen.Color = clSkyBlue
      StateImages = chktrTaskSteps.CheckImages
      TabOrder = 1
      OnCollapsing = chktrTaskStepsCollapsing
      OnDblClick = chktrTaskStepsDblClick
      OnDeletion = chktrTaskStepsDeletion
      OnDragDrop = chktrTaskStepsDragDrop
      OnDragOver = chktrTaskStepsDragOver
      OnMouseDown = chktrTaskStepsMouseDown
    end
    inherited redtLog: TRichEdit
      Width = 858
      Height = 205
      ExplicitWidth = 858
      ExplicitHeight = 205
    end
    inherited rzpnl3: TRzPanel
      Width = 858
      Font.Height = -16
      ParentFont = False
      ExplicitWidth = 858
      inherited btnClearLog: TBitBtn
        Font.Height = -16
        ParentFont = False
      end
    end
  end
  object rzstsbrMain: TRzStatusBar
    Left = 0
    Top = 593
    Width = 858
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 0
  end
  object pmTaskSteps: TPopupMenu
    OwnerDraw = True
    Left = 682
    Top = 161
    object StepAdd: TMenuItem
      Caption = #28155#21152'Step'
      OnClick = StepAddClick
    end
    object StepEdit: TMenuItem
      Caption = #32534#36753'Step'
      OnClick = chktrTaskStepsDblClick
    end
    object StepDel: TMenuItem
      Caption = #21024#38500'Step'
      OnClick = StepDelClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object RunToStep: TMenuItem
      Caption = #36816#34892#33267#24403#21069'Step'
      OnClick = RunToStepClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object CopyNode: TMenuItem
      Caption = #22797#21046
      OnClick = CopyNodeClick
    end
    object PasteNode: TMenuItem
      Caption = #31896#36148
      OnClick = PasteNodeClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object SaveNodeAsSubTask: TMenuItem
      Caption = #33410#28857#20219#21153#21478#23384#20026'...'
      OnClick = SaveNodeAsSubTaskClick
    end
    object ViewStepConfigSource: TMenuItem
      Caption = #26597#30475#28304
      OnClick = ViewStepConfigSourceClick
    end
  end
  object dlgOpenTask: TOpenDialog
    DefaultExt = 'task'
    Filter = #20219#21153#25991#20214#65288'*.task'#65289'|*.task'
    Left = 684
    Top = 84
  end
end
