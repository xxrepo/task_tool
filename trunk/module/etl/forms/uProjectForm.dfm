inherited ProjectForm: TProjectForm
  Caption = #39033#30446#31649#29702
  ClientHeight = 520
  ClientWidth = 759
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 775
  ExplicitHeight = 559
  PixelsPerInch = 96
  TextHeight = 17
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 759
    Height = 44
    Align = alTop
    BorderOuter = fsFlat
    BorderSides = [sdLeft, sdTop, sdRight]
    TabOrder = 0
    DesignSize = (
      759
      44)
    object lblProjectName: TLabel
      Left = 12
      Top = 14
      Width = 140
      Height = 17
      Caption = #39033#30446#21517#31216#65306#26080#25171#24320#39033#30446
    end
    object btnClearOld: TBitBtn
      Left = 657
      Top = 4
      Width = 87
      Height = 37
      Anchors = [akTop, akRight]
      Caption = #28165#29702#26087#29256
      TabOrder = 0
      OnClick = btnClearOldClick
    end
    object btnServiceControl: TBitBtn
      Left = 550
      Top = 4
      Width = 95
      Height = 37
      Anchors = [akTop, akRight]
      Caption = #26381#21153#31649#29702
      TabOrder = 1
      OnClick = btnServiceControlClick
    end
  end
  object rzspltrFiles: TRzSplitter
    Left = 0
    Top = 44
    Width = 759
    Height = 457
    Position = 245
    Percent = 32
    Align = alClient
    TabOrder = 1
    BarSize = (
      245
      0
      249
      457)
    UpperLeftControls = (
      rzshltrProject)
    LowerRightControls = (
      lstFiles)
    object rzshltrProject: TRzShellTree
      Left = 0
      Top = 0
      Width = 245
      Height = 457
      Align = alClient
      Indent = 19
      Options = [stoAutoFill, stoVirtualFolders, stoDefaultKeyHandling, stoDynamicRefresh, stoOleDrag, stoOleDrop, stoShowHidden]
      PopupMenu = pmProjects
      ShellList = lstFiles
      TabOrder = 0
    end
    object lstFiles: TRzShellList
      Left = 0
      Top = 0
      Width = 510
      Height = 457
      Align = alClient
      IconOptions.AutoArrange = True
      PopupMenu = pmProjectFile
      TabOrder = 0
      ViewStyle = vsList
      OnDblClickOpen = lstFilesDblClickOpen
      OnFolderChanged = lstFilesFolderChanged
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 501
    Width = 759
    Height = 19
    Panels = <>
  end
  object dlgOpenProject: TOpenDialog
    DefaultExt = 'project'
    Filter = #39033#30446#25991#20214#65288'*.project'#65289'|*.project'
    Left = 696
    Top = 158
  end
  object pmProjectFile: TPopupMenu
    Left = 703
    Top = 385
    object GlobalVarSetting: TMenuItem
      Caption = #20840#23616#21442#25968#35774#32622
      OnClick = GlobalVarSettingClick
    end
    object DBMgrEdit: TMenuItem
      Caption = #25968#25454#24211#36830#25509#35774#32622
      OnClick = DBMgrEditClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object AddTask: TMenuItem
      Caption = #21019#24314#20219#21153' Task'
      OnClick = AddTaskClick
    end
    object JobMgrEdit: TMenuItem
      Caption = #24037#20316#25191#34892#31649#29702
      OnClick = JobMgrEditClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object N2: TMenuItem
      Caption = #35774#20026#39033#30446#26681#30446#24405
      Visible = False
      OnClick = N2Click
    end
    object N5: TMenuItem
      Caption = #21019#24314#25991#20214#22841
      OnClick = N5Click
    end
  end
  object dlgOpenTask: TOpenDialog
    DefaultExt = 'task'
    Filter = #20219#21153#25991#20214#65288'*.task'#65289'|*.task'
    Left = 696
    Top = 222
  end
  object pmProjects: TPopupMenu
    Left = 152
    Top = 366
    object N3: TMenuItem
      Caption = #21019#24314#39033#30446
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #21024#38500#25991#20214#22841
      OnClick = N4Click
    end
  end
end
