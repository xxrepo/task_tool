inherited TaskEditForm: TTaskEditForm
  Caption = #39033#30446#20219#21153#35774#35745
  ClientHeight = 562
  ClientWidth = 532
  WindowState = wsMaximized
  OnClose = FormClose
  OnDestroy = FormDestroy
  ExplicitWidth = 548
  ExplicitHeight = 601
  PixelsPerInch = 96
  TextHeight = 17
  object rzpnlTop: TRzPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 57
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 0
    DesignSize = (
      532
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
      Left = 415
      Top = 12
      Width = 86
      Height = 33
      Anchors = [akTop, akRight]
      Caption = #21478#23384#20026'...'
      TabOrder = 1
      Visible = False
    end
  end
  object rzstsbrMain: TRzStatusBar
    Left = 0
    Top = 543
    Width = 532
    Height = 19
    BorderInner = fsNone
    BorderOuter = fsNone
    BorderSides = [sdLeft, sdTop, sdRight, sdBottom]
    BorderWidth = 0
    TabOrder = 1
  end
  object chktrTaskSteps: TRzCheckTree
    Left = 0
    Top = 57
    Width = 532
    Height = 486
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
    TabOrder = 2
    OnCollapsing = chktrTaskStepsCollapsing
    OnDblClick = chktrTaskStepsDblClick
    OnDeletion = chktrTaskStepsDeletion
    OnDragDrop = chktrTaskStepsDragDrop
    OnDragOver = chktrTaskStepsDragOver
    OnMouseDown = chktrTaskStepsMouseDown
  end
  object pmTaskSteps: TPopupMenu
    OwnerDraw = True
    Left = 386
    Top = 191
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
  end
  object dlgOpenTask: TOpenDialog
    DefaultExt = 'task'
    Filter = #20219#21153#25991#20214#65288'*.task'#65289'|*.task'
    Left = 388
    Top = 304
  end
end
