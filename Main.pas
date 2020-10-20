unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DrawGrid, Global, DrawObj, Contnrs, CommonConst,
  ExtCtrls, Menus, ComCtrls, ToolWin, ImgList, AppEvnts, ActnList;

type
  TFrmMain = class(TForm)
    mnuMain: TMainMenu;
    popMenuItem: TPopupMenu;
    mnuFile: TMenuItem;
    mnuFileNew: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileClose: TMenuItem;
    N5: TMenuItem;
    mnuFileSave: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    N8: TMenuItem;
    mnuFileQuit: TMenuItem;
    mnuEdit: TMenuItem;
    mnuEditCut: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditPaste: TMenuItem;
    mnuEditDel: TMenuItem;
    mnuView: TMenuItem;
    mnuViewProperties: TMenuItem;
    mnuViewFigure: TMenuItem;
    mnuViewBase: TMenuItem;
    mnuComponent: TMenuItem;
    mnuComponentNew: TMenuItem;
    mnuComponentRename: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpTopic: TMenuItem;
    mnuHelpFind: TMenuItem;
    N29: TMenuItem;
    mnuHelpAbout: TMenuItem;
    popMenuPanel: TPopupMenu;
    popMenuPanelBase: TMenuItem;
    popMenuPanelProperties: TMenuItem;
    popMenuPanelFigure: TMenuItem;
    popMenuItemCut: TMenuItem;
    popMenuItemCopy: TMenuItem;
    popMenuItemPaste: TMenuItem;
    popMenuItemDel: TMenuItem;
    popMenuItemFront: TMenuItem;
    popMenuItemBack: TMenuItem;
    N1: TMenuItem;
    mnuEditFront: TMenuItem;
    mnuEditBack: TMenuItem;
    clbPanel: TCoolBar;
    tlbBase: TToolBar;
    tlbFigure: TToolBar;
    imgToolbar: TImageList;
    btnFileNew: TToolButton;
    btnFileOpen: TToolButton;
    btnFileSave: TToolButton;
    ToolButton5: TToolButton;
    btnEditCut: TToolButton;
    btnEditCopy: TToolButton;
    btnEditPaste: TToolButton;
    btnHelpTopic: TToolButton;
    btnEllipse: TToolButton;
    btnLine: TToolButton;
    btnRectangel: TToolButton;
    btnRoundRect: TToolButton;
    btnSelect: TToolButton;
    stbApp: TStatusBar;
    lstItem: TListBox;
    popMenuList: TPopupMenu;
    popMenuListRename: TMenuItem;
    popMenuListDel: TMenuItem;
    popMenuListCreate: TMenuItem;
    btnBezier: TToolButton;
    btnPolyLine: TToolButton;
    btnPolygon: TToolButton;
    btnCircle: TToolButton;
    ToolButton2: TToolButton;
    N3: TMenuItem;
    popMenuItemBevel: TMenuItem;
    btnText: TToolButton;
    N4: TMenuItem;
    mnuBackGrid: TMenuItem;
    dlgColor: TColorDialog;
    N2: TMenuItem;
    mnuComponentRemove: TMenuItem;
    dlgSave: TSaveDialog;
    dlgOpen: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnSelectClick(Sender: TObject);
    procedure btnLineClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure popMenuItemFrontClick(Sender: TObject);
    procedure popMenuItemBackClick(Sender: TObject);
    procedure mnuViewPropertiesClick(Sender: TObject);
    procedure mnuBackGridClick(Sender: TObject);
    procedure lstItemClick(Sender: TObject);
    procedure lstItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure mnuViewFigureClick(Sender: TObject);
    procedure mnuViewBaseClick(Sender: TObject);
    procedure mnuEditDelClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditPasteClick(Sender: TObject);
    procedure mnuEditCutClick(Sender: TObject);
    procedure mnuComponentRenameClick(Sender: TObject);
    procedure popMenuListPopup(Sender: TObject);
    procedure mnuComponentRemoveClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuFileSaveClick(Sender: TObject);
    procedure mnuFileSaveAsClick(Sender: TObject);
    procedure mnuFileQuitClick(Sender: TObject);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuFileNewClick(Sender: TObject);
    procedure popMenuItemPopup(Sender: TObject);
    procedure mnuHelpTopicClick(Sender: TObject);
    procedure mnuHelpFindClick(Sender: TObject);
  private
    FItemClipboard: TDrawRect;
    FSelectItem: Boolean;
    FPtDown: TPoint;
    FMarkerDown: Integer;
    FNewPos: Boolean;
    FMoveItem: Boolean;
    FSizeItem: Boolean;
    FNewItem: Boolean;
    FNewDrawPoly: Boolean;
    FDocPtDown: TPoint;
    FRectDown: TRect;
    FNewShape: TDrawShape;
    FColorGrid: TColor;
    PR: PRect;
    FCurrentPoint: TPoint;
    FItemIndex: Integer;
  public
    FFileName: String;
    FNewFigure: TDrawRect;
    FItem: TObjectList;
    FNameComponent: String;
    FDirty: Boolean;
    procedure RepaintItems;
    procedure InvalidateForm;
    procedure ControlSave(Flag: Boolean);
    procedure ControlCut(Flag: Boolean);
    procedure ControlCopy(Flag: Boolean);
    procedure ControlPaste(Flag: Boolean);
    procedure ControlFigure(Flag: Boolean);
    function DocToClient(P: TPoint): TPoint;
    function ClientToDoc(P: TPoint): TPoint;
  end;

procedure CreateVirtualWindow;
procedure DestroyVirtualWindow;

var
  FrmMain: TFrmMain;

implementation

{$R *.DFM}
uses ScaleData, CADFunction, Prop, SaveOpen,
     ComponentEdit, About, CommonFunct;


procedure CreateVirtualWindow;
var
 CDC: HDC;
begin
 CDC:= GetDC(FrmMain.Handle);
  mDC:= CreateCompatibleDC(CDC);
  mBM:= CreateCompatibleBitmap(CDC, GRID_WIDTH, GRID_HEIGHT);
 ReleaseDC(FrmMain.Handle, CDC);
 SelectObject(mDC, mBM);
 PatBlt(mDC, 0, 0, GRID_WIDTH, GRID_HEIGHT, WHITENESS);
end;

procedure DestroyVirtualWindow;
begin
 DeleteObject(mBM);
 DeleteDC(mDC);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
 s: String;
begin
 // Получить настройки фона и путь к справке
 PATH_BEGIN:= GetCurrentDir;
 s:= IniLoad('Path','Help');
  if s = '' then s:= PATH_BEGIN;
   s:= s + '\EditItem.hlp';
    Application.HelpFile:= s;
 s:= '';
 s:= IniLoad('Color','BackGrid');
 if s = '' then s:= IntToStr(clNone);
  try FColorGrid:= StrToInt(s); except FColorGrid:= clNone; end;
 // Создание объектов и инициализация
 New(PR);
 FNewItem:= False;
 FSelectItem:= False;
 FSizeItem:= False;
 FMoveItem:= False;
 FNewPos:= False;
 FNewDrawPoly:= False;
 FCurrentPoint:= Point(0,0);
 NUMBER_OBJ:= 0;
 // Настройка координат в зависимости от разрешения экрана
 DrawScaleData;
 // Установка размеров окна рисования
 lstItem.Width:= CONTROL_LIST_WIDTH;
 lstItem.ItemHeight:= MX + DEFAULT_SPACE;
 Self.BorderWidth:= WIDTH_BORDER;
 // Расчет координат вывода виртуального окна
 GRID_X:= Screen.Width div 2 - GRID_WIDTH div 2 - CONTROL_LIST_WIDTH div 2 - WIDTH_BORDER;
 GRID_Y:= Screen.Height div 2 - GRID_HEIGHT div 2 - clbPanel.Height div 2- stbApp.Height div 2 - WIDTH_BORDER;
 RULER_RECT:= Rect(GRID_X, GRID_Y, GRID_X + SIZE_RULER - 1, GRID_Y + SIZE_RULER - 1);
 GRID_RECT:= Rect(GRID_X + SIZE_RULER, GRID_Y + SIZE_RULER, GRID_X + GRID_WIDTH, GRID_Y + GRID_HEIGHT);
 GRID_RECT_CLIENT:= Rect(SIZE_RULER, SIZE_RULER, GRID_WIDTH, GRID_HEIGHT);
 PR.Left:= GRID_X;
 PR.Top:= GRID_Y;
 PR.Right:= GRID_X + GRID_WIDTH;
 PR.Bottom:= GRID_Y + GRID_HEIGHT;

 FFileName:= NEW_FILE_NAME;
 Self.Caption:= Application.Title + ' - ' + FFileName;
 dlgSave.InitialDir:= GetCurrentDir;
 dlgOpen.InitialDir:= GetCurrentDir;
 FDirty:= False;

 // Создать виртуальное окно для вывода
 CreateVirtualWindow;
 // Нарисовать сетку
 GridControl(FColorGrid);
 // Обвновление формы
 InvalidateForm;
end;

procedure TFrmMain.FormPaint(Sender: TObject);
begin
 BitBlt(Canvas.Handle, GRID_X, GRID_Y,
                       GRID_X + GRID_WIDTH, GRID_Y + GRID_HEIGHT,
        mDC, 0, 0, SRCCOPY);
end;

procedure TFrmMain.InvalidateForm;
begin
 //Обновление без очистки фона, чтобы не происходило мерцание
 InvalidateRect(Handle, PR, False);
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
 i: Integer;
 s: String;
begin
 if FDirty then
  if MessageDlg(MSG_FILE_EDIT, mtConfirmation, [mbYes, mbNo], HELP_FILE_EDIT) = mrYes then
    ZFileSave;
 // Удалить компоненты
 if lstItem.Items.Count <> 0 then
  for i:= 0 to lstItem.Items.Count - 1 do
   TObjectList(lstItem.Items.Objects[i]).Free;
 FItem:= nil;
 FNewFigure:= nil;
 // Удалить координаты обновления
 Dispose(PR);
 // Уничтожить виртуальное окно
 DestroyVirtualWindow;
 // Save params in INI
 IniSave('Color','BackGrid', IntToStr(FColorGrid));
 s:= ExtractFilePath(Application.HelpFile);
 s:= Copy(s, 1, Length(s)-1);
 IniSave('Path','Help', s);
 s:= ExtractFilePath(Application.ExeName);
 s:= Copy(s, 1, Length(s)-1);
 IniSave('Path','App', s);
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
 try
  DestroyVirtualWindow;
  CreateVirtualWindow;
  RepaintItems;
  InvalidateForm;
 except
  on E: Exception do ShowMessage(E.Message);   
 end;
end;

procedure TFrmMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
 p: TPoint;
 r: TRect;
 s: String;
 clrColor, clrBack: COLORREF;
begin
 // Настройка координат и других параметров
 p:= DocToClient(Point(X, Y));
  clrColor:= clBlack; clrBack:= clYellow;
   s:= Format('X %d, Y %d',[p.x div PT_FYS - DEFAULT_SIZE_RULER,  p.y div PT_FYS - DEFAULT_SIZE_RULER]);

 // Проверить, что курсор в масштабе сетки
 if PtInRect(GRID_RECT, Point(X,Y)) then
  begin
   //***************************************************************************
   // Проверка изменения размеров объекта
   if FSizeItem then begin FNewFigure.MoveMarkerTo(FMarkerDown, p); ControlSave(True); end
    else
     if FMoveItem then // Перемещение элемента
      begin
       r:= FRectDown;
       r.Left:= r.Left + (p.x - FPtDown.x);    r.Top:= r.Top + (p.y - FPtDown.y);
       r.Right:= r.Right + (p.x - FPtDown.x);  r.Bottom:= r.Bottom + (p.y - FPtDown.y);

        if RectInRect(GRID_RECT_CLIENT, NormalizeRect(r)) then FNewFigure.MoveTo(r);

       clrColor:= clGreen;
       s:= Format('X %d, Y %d',[r.Left div PT_FYS - DEFAULT_SIZE_RULER, r.Top div PT_FYS - DEFAULT_SIZE_RULER]);
       FDirty:= True;
       ControlSave(True);
      end
     else // Иначе, если новый элемет, то установить прямоугольник отрисовки
      if FNewPos and FNewItem and Assigned(FNewFigure) then
       begin
        if FNewDrawPoly and (FNewFigure.Shape in [gfPolygon, gfPolyLine, gfBezier]) then
          FNewFigure.AddPoint(p)
        else
         FNewFigure.SetPosition(Rect(FPtDown.x, FPtDown.y, p.x, p.y));
        FDirty:= True;
        ControlSave(True);
       end;
   //***************************************************************************

   // Перерисовать все элементы из списка и сетку
   RepaintItems;
   // Удалить временную точку после перерисовки для полилиний
   if Assigned(FNewFigure) then
    if FNewPos and FNewItem and FNewDrawPoly then
      FNewFigure.RemovePoint(FNewFigure.CountPoints);
   // Отобразить маркеры положения
   RulerVertical(X, Y);
   RulerHorizontal(X, Y);
   // Вывести координаты курсора на сетке
   OutText(mDC, p.x + 2, p.y + 2, s, clrColor, clrBack, True);
   // Перерисовать временный контекст в форму
   InvalidateForm;
   // Установить курсор на определенном маркере
   if Assigned(FNewFigure) then Cursor:= FNewFigure.GetMarkerCursor(FNewFigure.HitTest(P, True))
  end;
end;

procedure TFrmMain.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 bArea: Boolean;
 i: Integer;
begin
 if not Assigned(FItem) then Exit;
 // Настройки различных параметров
 FDocPtDown:= Point(X, Y);
 FPtDown:= DocToClient(FDocPtDown);
 FCurrentPoint:= FPtDown;
 bArea:= PtInRect(GRID_RECT, Point(X,Y)) and (Button = mbLeft);

 // Вызов контекстного меню
 popMenuItem.AutoPopup:= FSelectItem and (Button = mbRight) and PtInRect(GRID_RECT, Point(X,Y));

 // Поиск фигуры по щелчку мышкой
 if FSelectItem and bArea and (FItem.Count <> 0) and not FNewDrawPoly then
  for i:= FItem.Count - 1 downto 0 do
   begin
   if (FItem[i] as TDrawRect).PtInFigure(FPtDown) then
    begin
     FNewFigure:= (FItem[i] as TDrawRect);
      with FrmProp do
       begin
        cmbFigure.ItemIndex:= cmbFigure.Items.IndexOf(FNewFigure.NameFigure);
        LoadProperties(FNewFigure);
        SetStateControl;

        ControlCut(True); ControlCopy(True);
        mnuEditDel.Enabled:= True;   popMenuItemDel.Enabled:= True;
        mnuEditFront.Enabled:= True; popMenuItemFront.Enabled:= True;
        mnuEditBack.Enabled:= True;  popMenuItemBack.Enabled:= True;
       end;
     Break;
    end;
   end;

 // Перемещение или изменение размера фигуры
 if FSelectItem and Assigned(FNewFigure) and bArea and not FNewDrawPoly then
   begin
    FMarkerDown:= FNewFigure.HitTest(FPtDown, True);
    if FMarkerDown <> 0 then FSizeItem:= True
     else
      if FNewFigure.PtInFigure(FPtDown) then //if PtInRect(NormalizeRect(FNewFigure.Position), FPtDown) then
       begin
        FMoveItem:= True;
         if FNewFigure.Shape in [gfPolygon, gfPolyline, gfBezier] then FNewfigure.RecalcBounds;
        FRectDown:= FNewFigure.Position;
       end;
    Exit;
   end;

 if FNewDrawPoly and bArea then FNewFigure.AddPoint(FPtDown);

 // Создание новой фигуры
 if FNewItem and bArea and not FNewDrawPoly then
  begin
   FNewFigure:= TDrawRect.Create(Rect(FPtDown.x, FPtDown.y, FPtDown.x+3, FPtDown.y+3));
   FNewFigure.Shape:= FNewShape;
    if (FNewShape in [gfPolygon, gfPolyLine, gfBezier]) then
     begin
      FNewFigure.AddPoint(FPtDown);
      FNewDrawPoly:= True;
     end;
   FNewPos:= True;
  end;

end;

procedure TFrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

 function FindUniqName: String;
  var
   i, m: Integer;
   s,s1: String;
  begin
   s1:= Trim(FNewFigure.NameFigure);
    if Length(s1) > 2 then Delete(s1, Length(s1) - 1, 1);
   s:= s1;
   m:= NUMBER_OBJ;
   with FrmProp.cmbFigure do
    begin
     repeat
      Inc(m);
      i:= Items.IndexOf(s);
      if i <> NOT_FIND then s:= s1 + IntToStr(m);
     until (i = NOT_FIND);
    end;
   Result:= s;
  end;

begin
 if not (PtInRect(GRID_RECT, Point(X,Y)) and (Button = mbLeft)) then Exit;
 if FNewDrawPoly then Exit;
 if Assigned(FNewFigure) and FNewItem then
  begin
  // Поиск уникального имени
  FNewFigure.NameFigure:= FindUniqName;
  FItem.Add(FNewFigure);
   with FrmProp.cmbFigure do
    begin
     Items.Add(FNewFigure.NameFigure);
     ItemIndex:= Items.Count - 1;
     FrmProp.SetStateControl;
     FrmProp.LoadProperties(FNewFigure);
    end;
  // Добавить фигуру в текущий компонент из списка компонентов
  lstItem.Items.Objects[FItemIndex]:= FItem;
  FDirty:= True;
   ControlSave(True);
    ControlCut(True); ControlCopy(True);
    mnuEditFront.Enabled:= True; popMenuItemFront.Enabled:= True;
    mnuEditBack.Enabled:= True;  popMenuItemBack.Enabled:= True;
  end;
 FSizeItem:= False;
 FNewItem:= False;
 FMoveItem:= False;
 FNewPos:= False;
 FNewDrawPoly:= False;
  btnSelect.Down:= True;
  FSelectItem:= True;
end;

procedure TFrmMain.RepaintItems;
var
 i: Integer;
begin
 GridControl(FColorGrid);
 // Пререрисовать элементы из списка
 if Assigned(FItem) then if (FItem.Count <> 0) then
  for i:= 0 to FItem.Count - 1 do
   begin
    (FItem[i] as TDrawRect).Draw(mDC);
    if ((FItem[i] as TDrawRect) = FNewFigure) and not FNewPos then (FItem[i] as TDrawRect).DrawTracker(mDC, tsSelected);
   end;
 // Перерисовать текущий элемент
 if FNewItem and Assigned(FNewFigure) and FNewPos then
  begin
    FNewFigure.Draw(mDC);
    FNewFigure.DrawTracker(mDC, tsSelected);
  end;
end;

function TFrmMain.ClientToDoc(P: TPoint): TPoint;
begin
 Result:= Point(P.x + GRID_X, P.y + GRID_Y);
end;

function TFrmMain.DocToClient(P: TPoint): TPoint;
begin
 Result:= Point(P.x - GRID_X, P.y - GRID_Y);
end;

procedure TFrmMain.btnSelectClick(Sender: TObject);
begin
 FSelectItem:= True;
 FNewItem:= False;
 FNewDrawPoly:= False;
end;

procedure TFrmMain.btnLineClick(Sender: TObject);
begin
 FNewItem:= True;
 FSelectItem:= False;
 case (Sender as TToolButton).Tag of
  1: FNewShape:= gfLine;
  2: FNewShape:= gfRectangle;
  3: FNewShape:= gfRoundRectangle;
  4: FNewShape:= gfPolyLine;
  5: FNewShape:= gfPolygon;
  6: FNewShape:= gfEllipse;
  7: FNewShape:= gfCircle;
  8: FNewShape:= gfBezier;
  9: FNewShape:= gfText;
 end;
end;

// Двойной щелчок по форме - завершить рисование полифигур
procedure TFrmMain.FormDblClick(Sender: TObject);
begin
 FNewDrawPoly:= False;
 FormMouseUp(Sender, mbLeft, [], Width div 2, Height div 2);
end;

// Перенести на передний фон
procedure TFrmMain.popMenuItemFrontClick(Sender: TObject);
var
 i: Integer;
 lastObj: TDrawRect;
begin
 if Assigned(FItem) and (FItem.Count <> 0) then
  begin
   i:= FItem.IndexOf(FNewFigure);
   if (i = NOT_FIND) or (i = FItem.Count - 1) then Exit;
   FItem.Extract(FNewFigure);
   lastObj:= FItem.Extract(FItem[FItem.Count-1]);
   FItem.Insert(i, lastObj);
   FItem.Add(FNewFigure);
    with FrmProp do
     begin
      cmbFigure.Clear;
       for i:= 0 to FItem.Count - 1 do cmbFigure.Items.Add(TDrawRect(FItem[i]).NameFigure);
      cmbFigure.ItemIndex:= cmbFigure.Items.Count - 1;
      LoadProperties(FNewFigure);
     end;
  end;
   FDirty:= True;
    ControlSave(True);
end;

// Перенести на задний фон
procedure TFrmMain.popMenuItemBackClick(Sender: TObject);
var
 i: Integer;
 firstObj: TDrawRect;
begin
 if Assigned(FItem) then
  begin
   i:= FItem.IndexOf(FNewFigure);
   if (i = NOT_FIND) or (i = 0) then Exit;
   FItem.Extract(FNewFigure);
   firstObj:= FItem.Extract(FItem[0]);
   if i > FItem.Count then FItem.Add(firstObj)
     else FItem.Insert(i, firstObj);
   FItem.Insert(0, FNewFigure);
   with FrmProp do
    begin
     cmbFigure.Clear;
      for i:= 0 to FItem.Count - 1 do cmbFigure.Items.Add(TDrawRect(FItem[i]).NameFigure);
     cmbFigure.ItemIndex:= 0;
     LoadProperties(FNewFigure);
    end;
   end;
    FDirty:= True;
     ControlSave(True);
end;

// Панель СВОЙСТВА
procedure TFrmMain.mnuViewPropertiesClick(Sender: TObject);
begin
 mnuViewProperties.Checked:= not mnuViewProperties.Checked;
 popMenuPanelProperties.Checked:= mnuViewProperties.Checked;
 FrmProp.Visible:= mnuViewProperties.Checked;
end;

// Фон сетки
procedure TFrmMain.mnuBackGridClick(Sender: TObject);
begin
 if dlgColor.Execute then
  begin
   FColorGrid:= dlgColor.Color;
   RepaintItems;
   InvalidateForm;
  end;
end;

// Выбор в списке компонентов
procedure TFrmMain.lstItemClick(Sender: TObject);
var
 i: Integer;
 flag: Boolean;
begin
 if lstItem.ItemIndex <> NOT_FIND then
  begin
   // Показать в строке статуса название компонента
   stbApp.SimpleText:= lstItem.Items[lstItem.ItemIndex];
   // Вывести фигуры компонента по которому щелкнули
   FItemIndex:= lstItem.ItemIndex;
   FItem:= TObjectList(lstItem.Items.Objects[lstItem.ItemIndex]);
   // Загрузить свойства фигур выбранного компонента
   with FrmProp do
    begin
     SetDefaultProperties;
     if FItem.Count <> 0 then
      begin
       for i:= 0 to FItem.Count - 1 do
        cmbFigure.Items.Add(TDrawRect(FItem[i]).NameFigure);
        FNewFigure:= TDrawRect(FItem[0]);
        LoadProperties(FNewFigure);
        cmbFigure.ItemIndex:= 0;
      end;
     // Enabled controls
     flag:= FItem.Count <> 0;
     ControlCut(flag); ControlCopy(flag);
     mnuEditDel.Enabled:= flag;   popMenuItemDel.Enabled:= flag;
     mnuEditFront.Enabled:= flag; popMenuItemFront.Enabled:= flag;
     mnuEditBack.Enabled:= flag;  popMenuItemBack.Enabled:= flag;
     ControlPaste(Assigned(FItemClipboard));
    end;
   // Перерисовка
   RepaintItems;
   InvalidateForm;
  end;
end;

// Перемещение в списке компонентов (подсказка)
procedure TFrmMain.lstItemMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 s: String;
 i: Integer;
begin
 s:= '';
  if lstItem.Items.Count <> 0 then
   begin
    i:= lstItem.ItemAtPos(Point(X,Y), True);
    if i <> NOT_FIND then s:= lstItem.Items[i];
   end;
 lstItem.Hint:= s;
end;

// Панель ФИГУР
procedure TFrmMain.mnuViewFigureClick(Sender: TObject);
begin
 mnuViewFigure.Checked:= not mnuViewFigure.Checked;
 popMenuPanelFigure.Checked:= mnuViewFigure.Checked;
 tlbFigure.Visible:= mnuViewFigure.Checked;
end;

// Панель ОСНОВНАЯ
procedure TFrmMain.mnuViewBaseClick(Sender: TObject);
begin
 mnuViewBase.Checked:= not mnuViewBase.Checked;
 popMenuPanelBase.Checked:= mnuViewBase.Checked;
 tlbBase.Visible:= mnuViewBase.Checked;
end;

// Удаление фигуры
procedure TFrmMain.mnuEditDelClick(Sender: TObject);
var
 i: Integer;
begin
 // Удаление фигуры
 // Check pointers
 if (not Assigned(FItem)) or (not Assigned(FNewFigure)) then Exit;
 // Remove figure
 i:= FItem.IndexOf(FNewFigure);
 if (i = NOT_FIND) then Exit;
 // Извлечь объект из списка
 FItem.Extract(FNewFigure);
 // Удалить объект
 FNewFigure.Free;
 FNewFigure:= nil;
 // Удалить объект из списка свойств
 FrmProp.cmbFigure.Items.Delete(i);
 // Проверить список, Загрузить свойства или очистить свойства
 if FItem.Count <> 0 then
  begin
   if i > 0 then Dec(i);
   FNewFigure:= TDrawRect(FItem[i]);
   FrmProp.LoadProperties(FNewFigure);
   FrmProp.cmbFigure.ItemIndex:= i;
  end
 else
  with FrmProp do
   begin
    cmbFigure.Clear;
    lvFys.Items.Clear;
    lvAdd.Items.Clear;
    cmbPenWidth.ItemIndex:= 0;
    cmbPenType.ItemIndex:= 0;
    cmbBrushType.ItemIndex:= 0;
    lblFFont.Caption:= '';
    btnFont.Enabled:= False;
    tabFys.Enabled:= False;
    tabAdd.Enabled:= False;

     ControlCut(False); ControlCopy(False);
     mnuEditDel.Enabled:= False;   popMenuItemDel.Enabled:= False;
     mnuEditFront.Enabled:= False; popMenuItemFront.Enabled:= False;
     mnuEditBack.Enabled:= False;  popMenuItemBack.Enabled:= False;
   end;
 RepaintItems;
 InvalidateForm;
  FDirty:= True;
   ControlSave(True);
end;

// Копирование выделенной фигуры в буфер обмена
procedure TFrmMain.mnuEditCopyClick(Sender: TObject);
begin
// Копирование элемента в свой буфер
 if not Assigned(FNewFigure) then Exit;
 FItemClipboard:= TDrawRect.Create(FNewFigure.Position);
 FItemClipboard.Assign(FNewFigure);
 FDirty:= True;
 ControlPaste(True);
  ControlSave(True);
end;

// Вставить фигуру из буфера обмена
procedure TFrmMain.mnuEditPasteClick(Sender: TObject);
var
 t: TDrawRect;

 function FindUniqName: String;
  var
   s: String;
   i, j, m: Integer;
  begin
   m:= NUMBER_OBJ;
   Inc(m);
   s:= FItemClipboard.NameFigure + ' ' + IntToStr(m);
   i:= 0;
   while (i <> NOT_FIND) do
    begin
     for j:= 0 to FItem.Count - 1 do
      if AnsiUpperCase(TDrawRect(FItem[j]).NameFigure) = AnsiUpperCase(s) then
       begin
        i:= 1;
        Break;
       end;
      if i = 0 then i:= NOT_FIND
        else s:= FItemClipboard.NameFigure + ' ' + IntToStr(m);
     Inc(m);   
    end;
   Result:= s;
  end;

begin
// Вставить скопированный объект
 if (not Assigned(FItem)) or (not Assigned(FItemClipboard)) then Exit;

 t:= TDrawRect.Create(FItemClipboard.Position);
 t.Assign(FItemClipboard);
 t.NameFigure:= FindUniqName;

 FItem.Add(t);

  FNewFigure:= (FItem[FItem.Count - 1] as TDrawRect);

   with FrmProp.cmbFigure do
    begin
     Items.Add(FNewFigure.NameFigure);
     ItemIndex:= Items.Count - 1;
     FrmProp.SetStateControl;
     FrmProp.LoadProperties(FNewFigure);
    end;

     ControlCut(True); ControlCopy(True);
     mnuEditDel.Enabled:= True;   popMenuItemDel.Enabled:= True;
     mnuEditFront.Enabled:= True; popMenuItemFront.Enabled:= True;
     mnuEditBack.Enabled:= True;  popMenuItemBack.Enabled:= True;

 RepaintItems;
 InvalidateForm;
  FDirty:= True;
   ControlSave(True);
end;

// Вырезать фигуру в буфер обмена
procedure TFrmMain.mnuEditCutClick(Sender: TObject);
begin
 mnuEditCopyClick(Sender);
 mnuEditDelClick(Sender);
 ControlPaste(True);
 FDirty:= True;
  ControlSave(True);
end;


procedure TFrmMain.mnuComponentRenameClick(Sender: TObject);
begin
// Переименование компонента или создание компонента
 if lstItem.Items.Count = 0 then FItemIndex:= NOT_FIND;
// Проверка списка для переименования
 if (TMenuItem(Sender).Tag = 1) and (lstItem.ItemIndex = NOT_FIND) then Exit;
// Вызов формы переименования
  with FrmComponent do
   begin
    ShowModal;
    // Проверить действия пользователя
    if (ModalResult = mrOK) and (edtName.Text <> '') then
     begin
      // Поиск совпадения в списке компонентов
       if lstItem.Items.IndexOf(edtName.Text) = NOT_FIND then
        //***************************************************
        if (TMenuItem(Sender).Tag = 1) then
         lstItem.Items[lstItem.ItemIndex]:= edtName.Text
        else
         begin
          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
          // Очистить текущий компонент
          FItem:= TObjectList.Create(True);
          // Добавить новый элемент в список
          lstItem.Items.AddObject(edtName.Text, FItem);
          FItemIndex:= lstItem.Items.Count - 1;
          lstItem.ItemIndex:= FItemIndex;
          // Вызвать перерисовку
          RepaintItems;
          InvalidateForm;
          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++
         end;
         //Enabled controls
         mnuComponentRename.Enabled:= True; popMenuListRename.Enabled:= True;
         mnuComponentRemove.Enabled:= True; popMenuListDel.Enabled:= True;
         ControlFigure(True);
        //*****************************************************
     end;
   end;
   FDirty:= True;
    ControlSave(True);
end;

procedure TFrmMain.popMenuListPopup(Sender: TObject);
begin
 popMenuListRename.Enabled:= (lstItem.ItemIndex <> NOT_FIND);
 popMenuListDel.Enabled:= (lstItem.ItemIndex <> NOT_FIND);
 popMenuListCreate.Enabled:= True;
end;

// Меню: УДАЛЕНИЕ КОМПОНЕНТА
procedure TFrmMain.mnuComponentRemoveClick(Sender: TObject);
begin
 with lstItem do
  begin
   if Items.Count = 0 then Exit;
    TObjectList(Items.Objects[FItemIndex]).Free;
     Items.Delete(FItemIndex);
      if Items.Count <> 0 then
       begin
        ItemIndex:= 0;
        lstItemClick(nil);
       end
      else
       begin
        FItemIndex:= NOT_FIND;
        ControlFigure(False);
        mnuComponentRename.Enabled:= False;  popMenuListRename.Enabled:= False;
        mnuComponentRemove.Enabled:= False;  popMenuListDel.Enabled:= False;
        ControlCut(False); ControlCopy(False); ControlPaste(False);
        mnuEditFront.Enabled:= False;     popMenuItemFront.Enabled:= False;
        mnuEditBack.Enabled:= False;     popMenuItemBack.Enabled:= False;
       end;
   RepaintItems;
   InvalidateForm;
  end;
   FDirty:= True;
    ControlSave(True);
end;

procedure TFrmMain.mnuHelpAboutClick(Sender: TObject);
begin
 FrmAbout:= TFrmAbout.Create(Self);
  FrmAbout.ShowModal;
 FrmAbout.Free;
end;

procedure TFrmMain.mnuFileSaveClick(Sender: TObject);
begin
 ZFileSave;
 FDirty:= False;
  ControlSave(False);
end;

procedure TFrmMain.mnuFileSaveAsClick(Sender: TObject);
begin
 if dlgSave.Execute then
  begin
   FFileName:= ExtractFileName(dlgSave.FileName);
   ZFileSave;
   Self.Caption:= Application.Title + ' - ' + FFileName;
   FDirty:= False;
   ControlSave(False);
  end;
end;

procedure TFrmMain.mnuFileQuitClick(Sender: TObject);
begin
 Close;
end;

procedure TFrmMain.mnuFileCloseClick(Sender: TObject);
var
 i: Integer;
begin
 // Спросить об сохранении
 if FDirty then
  if MessageDlg(MSG_FILE_EDIT, mtConfirmation, [mbYes, mbNo], HELP_FILE_EDIT) = mrYes then
    ZFileSave;
 // Удалить все объекты
 if lstItem.Items.Count <> 0 then
  for i:= 0 to lstItem.Items.Count - 1 do
   TObjectList(lstItem.Items.Objects[i]).Free;

 lstItem.Clear;
 FDirty:= False;

 FItem:= nil;
 FNewFigure:= nil;

 // Обновить окно
 RepaintItems;
 InvalidateForm;

 // Обновить заголовок
 Self.Caption:= Application.Title;
 FFileName:= NEW_FILE_NAME;

 // Запретить все команды
 ControlFigure(False);

 mnuFileClose.Enabled:= False;
 mnuFileSave.Enabled:= False;  btnFileSave.Enabled:= False;
 mnuFileSaveAs.Enabled:= False;

 ControlCut(False); ControlCopy(False); ControlPaste(False);

 mnuEditFront.Enabled:= False; popMenuItemFront.Enabled:= False;
 mnuEditBack.Enabled:= False;  popMenuItemBack.Enabled:= False;

 mnuComponentNew.Enabled:= False;    popMenuListCreate.Enabled:= False;
 mnuComponentRename.Enabled:= False; popMenuListRename.Enabled:= False;
 mnuComponentRemove.Enabled:= False; popMenuListDel.Enabled:= False;
end;

procedure TFrmMain.mnuFileOpenClick(Sender: TObject);
var
 flag: Boolean;
begin
 if Sender <> nil then
  begin
   if dlgOpen.Execute then
    begin
     mnuFileCloseClick(nil);
     FFileName:= ExtractFileName(dlgOpen.FileName)
    end
   else
    Exit;
  end;

   Self.Caption:= Application.Title + ' - ' + FFileName;
   FDirty:= False;
    if ZFileOpen then
     begin
      if not Assigned(FItem) then FItem:= TObjectList.Create(True);
      if lstItem.Items.Count <> 0 then
       begin
        if not Assigned(FNewFigure) then FNewFigure:= TDrawRect.Create(Rect(0,0,0,0));
        lstItem.ItemIndex:= 0;
        lstItemClick(nil);
       end;
      // Разрешить команды
      mnuFileClose.Enabled:= True;
      mnuFileSave.Enabled:= True;
      mnuFileSaveAs.Enabled:= True;
      mnuComponentNew.Enabled:= True;
      popMenuListCreate.Enabled:= True;
       flag:= lstItem.Items.Count <> 0;
        mnuComponentNew.Enabled:= flag;    popMenuListCreate.Enabled:= flag;
        mnuComponentRename.Enabled:= flag; popMenuListRename.Enabled:= flag;
        mnuComponentRemove.Enabled:= flag; popMenuListDel.Enabled:= flag;
        ControlFigure(flag);
         flag:= TObjectList(lstItem.Items.Objects[0]).Count <> 0;
          mnuEditFront.Enabled:= flag; popMenuItemFront.Enabled:= flag;
          mnuEditBack.Enabled:= flag;  popMenuItemBack.Enabled:= flag;
          ControlCut(flag);
           ControlCopy(flag);
            ControlPaste(Assigned(FItemClipboard));
     end;
end;

procedure TFrmMain.mnuFileNewClick(Sender: TObject);
var
 i: Integer;
 s: String;
begin
 mnuFileCloseClick(nil);
  //BEGIN FIND NAME FILE
   i:= 1;
   FFileName:= NEW_FILE_NAME;
    repeat
     s:= NEW_FILE_NAME_NO_EXT + IntToStr(i) + ExtractFileExt(FFileName);
     Inc(i);
    until not FileExists(GetCurrentDir + '\' + s);
   FFileName:= s;
  //END FIND NAME FILE
 Self.Caption:= Application.Title + ' - ' + FFileName;
 FDirty:= True;
 // Разрешить команды
 mnuFileClose.Enabled:= True;
 ControlSave(True);
 mnuFileSaveAs.Enabled:= True;
 mnuComponentNew.Enabled:= True;
 popMenuListCreate.Enabled:= True;
 ControlPaste(Assigned(FItemClipboard));
end;

procedure TFrmMain.popMenuItemPopup(Sender: TObject);
begin
 popMenuItemCut.Enabled:= FSelectItem and Assigned(FNewFigure);
 popMenuItemCopy.Enabled:= popMenuItemCut.Enabled;
 popMenuItemPaste.Enabled:= Assigned(FItemClipboard); 
 popMenuItemDel.Enabled:= popMenuItemCut.Enabled;
 popMenuItemFront.Enabled:= popMenuItemCut.Enabled;
 popMenuItemBack.Enabled:= popMenuItemCut.Enabled;
end;

procedure TFrmMain.ControlFigure(Flag: Boolean);
begin
 btnEllipse.Enabled:= Flag;            btnLine.Enabled:= Flag;
 btnRectangel.Enabled:= Flag;          btnRoundRect.Enabled:= Flag;
 btnSelect.Enabled:= Flag;             btnBezier.Enabled:= Flag;
 btnPolyLine.Enabled:= Flag;           btnPolygon.Enabled:= Flag;
 btnCircle.Enabled:= Flag;             btnText.Enabled:= Flag;
end;

procedure TFrmMain.ControlCopy(Flag: Boolean);
begin
 mnuEditCopy.Enabled:= Flag;
 btnEditCopy.Enabled:= Flag;
 popMenuItemCopy.Enabled:= Flag;
end;

procedure TFrmMain.ControlCut(Flag: Boolean);
begin
 mnuEditCut.Enabled:= Flag;
 btnEditCut.Enabled:= Flag;
 popMenuItemCut.Enabled:= Flag;
end;

procedure TFrmMain.ControlPaste(Flag: Boolean);
begin
 mnuEditPaste.Enabled:= Flag;
 btnEditPaste.Enabled:= Flag;
 popMenuItemPaste.Enabled:= Flag;
end;

procedure TFrmMain.ControlSave(Flag: Boolean);
begin
 mnuFileSave.Enabled:= Flag;
 btnFileSave.Enabled:= Flag;
end;

procedure TFrmMain.mnuHelpTopicClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_FINDER, 0);
end;

procedure TFrmMain.mnuHelpFindClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_KEY, 0);
end;

end.
