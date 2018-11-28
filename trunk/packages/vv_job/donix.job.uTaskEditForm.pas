unit donix.job.uTaskEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBasicForm, Vcl.ExtCtrls, RzPanel,
  RzSplit, RzButton, Vcl.StdCtrls, RzLstBox, RzShellDialogs, Vcl.ComCtrls,
  RzListVw, Vcl.Menus, RzCommon, Data.DB, Datasnap.DBClient, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, EhLibVCL, GridsEh, DBAxisGridsEh,
  DBGridEh, RzTreeVw, System.JSON, uStepDefines, Vcl.Mask, RzEdit, RzBtnEdt, uTask,
  Vcl.Buttons, uBasicLogForm, uTaskVar, uTaskDefine, System.Generics.Collections;

type
  TTaskEditForm = class(TBasicLogForm)
    rzpnlTop: TRzPanel;
    rzstsbrMain: TRzStatusBar;
    rzbtbtnSave: TRzBitBtn;
    rzbtbtnRunSchedual: TRzBitBtn;
    pmTaskSteps: TPopupMenu;
    StepAdd: TMenuItem;
    StepDel: TMenuItem;
    StepEdit: TMenuItem;
    chktrTaskSteps: TRzCheckTree;
    SaveNodeAsSubTask: TMenuItem;
    CopyNode: TMenuItem;
    N2: TMenuItem;
    PasteNode: TMenuItem;
    N4: TMenuItem;
    dlgOpenTask: TOpenDialog;
    N1: TMenuItem;
    RunToStep: TMenuItem;
    ViewStepConfigSource: TMenuItem;
    btnStart: TBitBtn;
    AddParentNode: TMenuItem;
    N5: TMenuItem;
    chkInteractive: TCheckBox;
    procedure StepAddClick(Sender: TObject);
    procedure chktrTaskStepsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chktrTaskStepsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure chktrTaskStepsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure rzbtbtnSaveClick(Sender: TObject);
    procedure chktrTaskStepsDeletion(Sender: TObject; Node: TTreeNode);
    procedure chktrTaskStepsDblClick(Sender: TObject);
    procedure StepDelClick(Sender: TObject);
    procedure SaveNodeAsSubTaskClick(Sender: TObject);
    procedure chktrTaskStepsCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure CopyNodeClick(Sender: TObject);
    procedure PasteNodeClick(Sender: TObject);
    procedure RunToStepClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ViewStepConfigSourceClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure AddParentNodeClick(Sender: TObject);
    procedure chkInteractiveClick(Sender: TObject);
  private
    CurrentTask: TTask; //所在的主任务
    TaskBlock: TTaskBlock; //标记当前的任务块
    EditingTaskConfigRec: TTaskConfigRec;    //表明当前正在编辑的资料
    EntryTaskConfigRec: TTaskConfigRec;

    procedure MakeTaskTree(ATaskStepsJsonStr: string);
    function GetNodeData(ANode: TTreeNode): TJSONObject;
    function GetNodeJsonStr(ANode: TTreeNode): string;
    procedure AddTreeChildNode(AParentNode: TTreeNode;
      AChildrenJson: TJsonArray); overload;
    procedure AddTreeChildNode(AParentNode: TTreeNode;
      ANodeJson: TJSONObject); overload;
    function AddStepTo(LParentNode: TTreeNode): TTreeNode;
    { Private declarations }
  public
    { Public declarations }

    procedure ConfigTask(ATaskFile: string; ATaskBlock: PTaskBlock = nil);
  end;

var
  TaskEditForm: TTaskEditForm;

implementation

uses
  uDefines, uFunctions, uStepTypeSelectForm, uDatabasesForm, uStepBasicForm, uStepFormFactory,
  uFileUtil, uDesignTimeDefines, Vcl.Clipbrd, uStepBasic, uTaskStepSourceForm;

{$R *.dfm}


procedure TTaskEditForm.SaveNodeAsSubTaskClick(Sender: TObject);
var
  LSubTaskConfigRec: TTaskConfigRec;
begin
  inherited;
  if chktrTaskSteps.Selected = nil then Exit;

  dlgOpenTask.InitialDir := CurrentProject.RootPath + 'task\';
  if dlgOpenTask.Execute then
  begin
    if not FileExists(dlgOpenTask.FileName) then
    begin
      if TFileUtil.CreateFile(dlgOpenTask.FileName) = INVALID_HANDLE_VALUE then
      begin
        ShowMsg('任务文件创建失败');
        Exit;
      end;
    end
    else
    begin
      if ShowMsg('任务文件已经存在，您确定要覆盖该任务文件吗？', MB_OKCANCEL) <> mrOk then
      begin
        Exit;
      end;
    end;

    LSubTaskConfigRec.FileName := dlgOpenTask.FileName;
    LSubTaskConfigRec.TaskName := ChangeFileExt(ExtractFileName(LSubTaskConfigRec.FileName), '');
    LSubTaskConfigRec.Version := EditingTaskConfigRec.Version;
    LSubTaskConfigRec.Auth := EditingTaskConfigRec.Auth;
    LSubTaskConfigRec.StepsStr := GetNodeJsonStr(chktrTaskSteps.Selected);

    TTaskUtil.WriteConfigTo(LSubTaskConfigRec, LSubTaskConfigRec.FileName);
    ShowMsg('节点保存为任务：[' + LSubTaskConfigRec.TaskName + ']成功');
  end;
end;


procedure TTaskEditForm.StepAddClick(Sender: TObject);
var
  LNode: TTreeNode;
begin
  inherited;
  //获取鼠标点击时的节点，作为父节点或者作为编辑的节点
  LNode := chktrTaskSteps.Selected;
  if (LNode = nil) and (chktrTaskSteps.Items.Count > 0) then
    LNode := chktrTaskSteps.Items[0];

  AddStepTo(LNode);
end;


function TTaskEditForm.AddStepTo(LParentNode: TTreeNode): TTreeNode;
var
  LStep: TStepBasic;
  LStepDefine: TStepDefine;
  LStepData: TStepConfig;
  LStepConfigJson: TJSONObject;
begin
  Result := nil;
  //创建节点Step，允许选择类型
  with TStepTypeSelectForm.Create(nil) do
  try
    if ShowModal = mrOk then
    begin
      //添加时，直接生成对应的Step加入到树节点中
      LStep := TStepFormFactory.GetStep(StepType, CurrentTask.TaskVar);
      if LStep <> nil then
      begin
        LStepConfigJson := TJSONObject.Create;
        LStepDefine := TStepFormFactory.GetStepDefine(StepType);
        LStep.StepConfig.StepTitle := LStepDefine.StepTypeName;
        try
          //执行画布添加节点
          LStepData := TStepConfig.Create;
          LStepData.StepType := StepType;
          LStepData.StepTitle := LStep.StepConfig.StepTitle;
          LStepData.Description := LStep.StepConfig.Description;
          LStepData.RegDataToTask := LStep.StepConfig.RegDataToTask;

          LStep.MakeStepConfigJson(LStepConfigJson);
          LStepData.ConfigJsonStr := LStepConfigJson.ToJSON;

          Result := chktrTaskSteps.Items.AddChildObject(LParentNode, LStep.StepConfig.StepTitle, LStepData);
          Result.StateIndex := 2;
          chktrTaskSteps.FullExpand;
        finally
          LStepConfigJson.Free;
          LStep.Free;
        end;
      end;
    end;
  finally
    Free;
  end;
end;


procedure TTaskEditForm.StepDelClick(Sender: TObject);
begin
  inherited;
  //获取当前结点node，删除
  if chktrTaskSteps.Selected = nil then Exit;

  if ShowMsg('您确定要删除本步骤吗?', MB_OKCANCEL) = mrOk then
  begin
    chktrTaskSteps.Selected.Delete;
  end;
end;


procedure TTaskEditForm.ViewStepConfigSourceClick(Sender: TObject);
var
  LStepConfig: TStepConfig;
begin
  inherited;
  if chktrTaskSteps.Selected = nil then Exit;

  with TTaskStepSourceForm.Create(nil) do
  try
    LStepConfig := TStepConfig(chktrTaskSteps.Selected.Data);
    if LStepConfig <> nil then
      redtSource.Lines.Text := LStepConfig.ConfigJson.ToString;
    ShowModal;
  finally
    Free;
  end;
end;

function TTaskEditForm.GetNodeData(ANode: TTreeNode): TJSONObject;
var
  LData: TStepConfig;
  i: Integer;
  LChildren: TJSONArray;
  LChild: TJSONObject;
begin
  Result := nil;
  if ANode = nil then Exit;

  LData := TStepConfig(ANode.Data);
  Result := TJSONObject.Create;
  Result.AddPair(TJSONPair.Create('step_abs_id', IntToStr(ANode.AbsoluteIndex)));
  Result.AddPair(TJSONPair.Create('step_title', LData.StepTitle));
  Result.AddPair(TJSONPair.Create('description', LData.Description));
  Result.AddPair(TJSONPair.Create('reg_data_to_task', BoolToStr(LData.RegDataToTask)));
  Result.AddPair(TJSONPair.Create('step_type', LData.StepType));

  Result.AddPair(TJSONPair.Create('step_status', IntToStr(ANode.StateIndex)));
  Result.AddPair(TJSONPair.Create('step_config', LData.ConfigJsonStr));

//  //设置titlecount
//  StepTitles.TryGetValue(LData.StepTitle, LTitleCount);
//  LTitleCount := LTitleCount + 1;
//  StepTitles.AddOrSetValue(LData.StepTitle, LTitleCount);


  LChildren := TJSONArray.Create;
  if ANode.HasChildren then
  begin
    for i := 0 to ANode.Count - 1 do
    begin
      LChild := GetNodeData(ANode[i]);
      if LChild <> nil then
        LChildren.AddElement(LChild);
    end;
  end;
  Result.AddPair(TJSONPair.Create('sub_steps', LChildren));
end;


function TTaskEditForm.GetNodeJsonStr(ANode: TTreeNode): string;
var
  LJson: TJSONObject;
begin
  Result := '';
  LJson := GetNodeData(ANode);
  if LJson = nil then Exit;

  Result := LJson.ToJSON;
  LJson.Free;
end;


procedure TTaskEditForm.rzbtbtnSaveClick(Sender: TObject);
begin
  inherited;
  if chktrTaskSteps.Items.Count > 0 then
  begin
    EditingTaskConfigRec.StepsStr := GetNodeJsonStr(chktrTaskSteps.Items[0]);
  end;

  TTaskUtil.WriteConfigTo(EditingTaskConfigRec, EditingTaskConfigRec.FileName);

  //重新加载
  ConfigTask(EditingTaskConfigRec.FileName, @TaskBlock);
end;


procedure TTaskEditForm.chkInteractiveClick(Sender: TObject);
begin
  inherited;
  if chkInteractive.Checked then
    EditingTaskConfigRec.Interactive := 1
  else
    EditingTaskConfigRec.Interactive := 0;
end;

procedure TTaskEditForm.chktrTaskStepsCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  inherited;
  AllowCollapse := False;
end;

procedure TTaskEditForm.chktrTaskStepsDblClick(Sender: TObject);
var
  LStepData: TStepConfig;
  LForm: TStepBasicForm;
  LStepConfigJson: TJSONObject;
begin
  inherited;
  //获取当前Select
  if chktrTaskSteps.Selected = nil then Exit;

  LStepData := TStepConfig(chktrTaskSteps.Selected.Data);

  //根据StepData创建Step
  LForm := TStepFormFactory.GetStepSettingForm(LStepData.StepType, CurrentTask.TaskVar);
  if LForm <> nil then
  try
    CurrentTask.TaskVar.DesignToStep(chktrTaskSteps.Selected.AbsoluteIndex, TaskBlock);
    CurrentTask.Start;
    LForm.GetStepFromStepStack(LStepData.StepType);

    if LForm.Step = nil then
    begin
      ShowMsg('请保存后重新打开任务');
    end
    else
    begin
      LForm.ParseStepConfig(LStepData.ConfigJsonStr);

      if LForm.ShowModal = mrOk then
      begin
        //更新画布节点的参数信息
        LStepConfigJson := TJSONObject.Create;
        try
          LStepData.StepTitle := LForm.Step.StepConfig.StepTitle;
          LForm.Step.MakeStepConfigJson(LStepConfigJson);
          LStepData.ConfigJsonStr := LStepConfigJson.ToJSON;
        finally
          LStepConfigJson.Free;
        end;


        chktrTaskSteps.Selected.Text := LStepData.StepTitle;
      end;
    end;

  finally
    LForm.Free;
  end;

end;

procedure TTaskEditForm.chktrTaskStepsDeletion(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
  TStepConfig(Node.Data).Free;
end;

procedure TTaskEditForm.chktrTaskStepsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  inherited;
  if chktrTaskSteps.Selected = nil then Exit;

  chktrTaskSteps.Items.BeginUpdate;
  try
    chktrTaskSteps.Selected.MoveTo(chktrTaskSteps.DropTarget, naAddChild);
  finally
    chktrTaskSteps.Items.EndUpdate;
    chktrTaskSteps.UpdateStateIndexDisplay(chktrTaskSteps.Selected);
  end;
end;

procedure TTaskEditForm.chktrTaskStepsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  LNode: TTreeNode;
begin
  inherited;
  if Source = chktrTaskSteps then
  begin
    LNode := chktrTaskSteps.GetNodeAt(X, Y);
    if LNode <> nil then
    begin
      Accept := True;
    end;
  end;
end;

procedure TTaskEditForm.chktrTaskStepsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (Button = mbLeft)
    and (ssCtrl in Shift)
    and (htOnItem in chktrTaskSteps.GetHitTestInfoAt(X, Y)) then
  begin
    chktrTaskSteps.BeginDrag(False);
  end;
end;


procedure TTaskEditForm.ConfigTask(ATaskFile: string; ATaskBlock: PTaskBlock = nil);

  function ParseTaskConfig(AFile: string): TTaskConfigRec;
  begin
    Result := TTaskUtil.ReadConfigFrom(AFile);
    Result.RunBasePath := CurrentProject.RootPath;
    Result.DBsConfigFile := CurrentProject.DbsFile;
  end;

begin
  if CurrentTask <> nil then
    FreeAndNil(CurrentTask);

  if ATaskBlock <> nil then
  begin
    TaskBlock.BlockName := ATaskBlock.BlockName;
    TaskBlock._ENTRY_FILE := ATaskBlock._ENTRY_FILE;
  end
  else
  begin
    TaskBlock.BlockName := '';
    TaskBlock._ENTRY_FILE := ATaskFile;
  end;

  //对当前的current_task进行处理
  EditingTaskConfigRec := ParseTaskConfig(ATaskFile);
  EntryTaskConfigRec := ParseTaskConfig(TaskBlock._ENTRY_FILE);

  CurrentTask := TTask.Create(EntryTaskConfigRec);
  //同时加载任务执行需要依赖的GlobalVar
  CurrentTask.TaskVar.GlobalVar := CurrentProject.GlobalVar;
  CurrentTask.TaskVar.Logger.NoticeHandle := Handle;

  MakeTaskTree(EditingTaskConfigRec.StepsStr);
  Self.Caption := '任务设计：' + TaskBlock.BlockName + '/' + EditingTaskConfigRec.TaskName;

  if EditingTaskConfigRec.Interactive = 1 then
  begin
    chkInteractive.Checked := True;
  end
end;


procedure TTaskEditForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(CurrentTask);
end;


procedure TTaskEditForm.CopyNodeClick(Sender: TObject);
var
  LNode: TTreeNode;
  LNodeStr: string;
begin
  inherited;
  LNode := chktrTaskSteps.Selected;
  if LNode = nil then Exit;

  LNodeStr := GetNodeJsonStr(LNode);

  //复制到剪贴板
  Clipboard.SetTextBuf(PChar(LNodeStr));
end;



//实现画图
procedure TTaskEditForm.MakeTaskTree(ATaskStepsJsonStr: string);
var
  LTaskJson: TJSONObject;
begin
  chktrTaskSteps.Items.Clear;
  LTaskJson := TJSONObject.ParseJSONValue(ATaskStepsJsonStr) as TJSONObject;
  if LTaskJson = nil then Exit;

  try
    AddTreeChildNode(nil, LTaskJson);
  finally
    LTaskJson.Free;
  end;
end;


procedure TTaskEditForm.PasteNodeClick(Sender: TObject);
var
  LNodeJson: TJSONObject;
begin
  inherited;
  //从剪贴板读取数据
  LNodeJson := TJSONObject.ParseJSONValue(Clipboard.AsText) as TJSONObject;

  try
    AddTreeChildNode(chktrTaskSteps.Selected, LNodeJson);
  finally
    LNodeJson.Free;
  end;
end;

procedure TTaskEditForm.RunToStepClick(Sender: TObject);
begin
  inherited;
  if chktrTaskSteps.Selected = nil then Exit;

  rzspltrLogForm.LowerRight.Visible := True;

  try
    CurrentTask.TaskVar.Logger.Force('运行至当前Step：' + TaskBlock.BlockName + '/' + chktrTaskSteps.Selected.Text);
    CurrentTask.TaskVar.DebugToStep(chktrTaskSteps.Selected.AbsoluteIndex, TaskBlock);
    CurrentTask.Start;
  except
    on E: Exception do
    begin
      AppLogger.Fatal('执行工作异常退出，原因：' + E.Message);
    end;
  end;
end;

procedure TTaskEditForm.AddTreeChildNode(AParentNode: TTreeNode; AChildrenJson: TJsonArray);
var
  i: Integer;
  LChild: TJSONObject;
  LNode: TTreeNode;
  LStepConfig: TStepConfig;
begin
  if (AChildrenJson = nil) or (AChildrenJson.Count = 0) then Exit;

  for i := 0 to AChildrenJson.Count - 1 do
  begin
    LChild := AChildrenJson.Items[i] as TJSONObject;
    if LChild = nil then Continue;

    LStepConfig := TStepConfig.Create;
    LStepConfig.StepType := GetJsonObjectValue(LChild, 'step_type', '');
    LStepConfig.StepTitle := GetJsonObjectValue(LChild, 'step_title');
    LStepConfig.Description := GetJsonObjectValue(LChild, 'description');
    LStepConfig.RegDataToTask := StrToBoolDef(GetJsonObjectValue(LChild, 'reg_data_to_task'), False);
    LStepConfig.ConfigJsonStr := GetJsonObjectValue(LChild, 'step_config');

    LNode := chktrTaskSteps.Items.AddChildObject(AParentNode, LStepConfig.StepTitle, LStepConfig);
    LNode.StateIndex := StrToInt(GetJsonObjectValue(LChild, 'step_status', '0'));
    LStepConfig.StepId := LNode.AbsoluteIndex;

    //如果有子节点，还需要遍历添加子节点
    if (LChild.GetValue('sub_steps') <> nil) then
      AddTreeChildNode(LNode, LChild.GetValue('sub_steps') as TJSONArray);
  end;

  chktrTaskSteps.FullExpand;
  chktrTaskSteps.Refresh;
end;


procedure TTaskEditForm.AddParentNodeClick(Sender: TObject);
var
  LNode: TTreeNode;
begin
  inherited;
  //获取当前选中项的父节点，给当前选中项的父节点插入子节点，把选中项作为子节点插入新创建的节点
  if chktrTaskSteps.Selected = nil then Exit;

  LNode := AddStepTo(chktrTaskSteps.Selected.Parent);
  if LNode <> nil then
    chktrTaskSteps.Selected.MoveTo(LNode, naAddChild);
end;

procedure TTaskEditForm.AddTreeChildNode(AParentNode: TTreeNode; ANodeJson: TJSONObject);
var
  LSubJson: TJSONArray;
begin
  if (ANodeJson = nil) then Exit;

  LSubJson := TJSONArray.Create;
  try
    LSubJson.AddElement(ANodeJson.Clone as TJSONObject);
    AddTreeChildNode(AParentNode, LSubJson);
  finally
    LSubJson.Free;
  end;
end;


procedure TTaskEditForm.btnStartClick(Sender: TObject);
begin
  inherited;
  rzspltrLogForm.LowerRight.Visible := True;

  //TODO 建议在这里采用JobDispatcher来运行，防止单任务执行时卡死的情况

  try
    CurrentTask.TaskVar.Logger.Force('运行任务：' + EditingTaskConfigRec.FileName + '；主任务文件：' + EntryTaskConfigRec.FileName);
    //debug到最后一步
    if chktrTaskSteps.Items.Count > 0 then
    begin
      btnClearLog.Click;
      CurrentTask.TaskVar.DebugToStep(chktrTaskSteps.Items.Count - 1, TaskBlock);
      CurrentTask.Start;
    end;
    CurrentTask.TaskVar.Logger.Force('运行结束');
  except
    on E: Exception do
    begin
      AppLogger.Fatal('执行工作异常退出，原因：' + E.Message);
    end;
  end;
end;

end.
