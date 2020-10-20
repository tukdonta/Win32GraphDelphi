unit Prop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ImgList, Grids, Buttons, DrawObj;

type
  TFrmProp = class(TForm)
    pgcProp: TPageControl;
    tabBase: TTabSheet;
    tabFys: TTabSheet;
    tabAdd: TTabSheet;
    pnlFigure: TPanel;
    cmbFigure: TComboBox;
    grbPen: TGroupBox;
    lblPenType: TLabel;
    lblPenWidth: TLabel;
    lblPenColor: TLabel;
    grbBrush: TGroupBox;
    lblBrushType: TLabel;
    lblBrushColor: TLabel;
    cmbPenWidth: TComboBox;
    cmbPenType: TComboBox;
    cmbBrushType: TComboBox;
    dlgColor: TColorDialog;
    lblPColor: TLabel;
    lblBColor: TLabel;
    lvAdd: TListView;
    pnlAdd: TPanel;
    lblName: TLabel;
    edtName: TEdit;
    btnAAdd: TButton;
    btnADel: TButton;
    pnlFys: TPanel;
    btnFAdd: TButton;
    btnFEdit: TButton;
    btnFDel: TButton;
    lvFys: TListView;
    btnAEdit: TButton;
    lblFont: TLabel;
    lblFFont: TLabel;
    btnFont: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure lblPColorClick(Sender: TObject);
    procedure cmbPenTypeDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cmbPenWidthDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure cmbBrushTypeDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cmbPenTypeChange(Sender: TObject);
    procedure cmbFigureChange(Sender: TObject);
    procedure cmbFigureDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnFontClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnFAddClick(Sender: TObject);
    procedure btnAAddClick(Sender: TObject);
    procedure btnFEditClick(Sender: TObject);
    procedure lvFysClick(Sender: TObject);
    procedure lvAddClick(Sender: TObject);
    procedure btnAEditClick(Sender: TObject);
    procedure btnADelClick(Sender: TObject);
    procedure pgcPropChange(Sender: TObject);
  private

  public
    FSelectList: Boolean;
    procedure LoadProperties(Figure: TDrawRect);
    procedure SetStateControl;
    procedure SetDefaultProperties;
  end;

var
  FrmProp: TFrmProp;

implementation

{$R *.DFM}
uses Main, ScaleData, Global, PropText, CommonConst, PropVal;

procedure TFrmProp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FrmMain.mnuViewPropertiesClick(nil);
end;

procedure TFrmProp.FormResize(Sender: TObject);
begin
 with cmbFigure do
  begin
   Left:= 0;
   Top:= 0;
   Width:= pnlFigure.Width;
  end;
 cmbPenType.Width:= grbPen.Width - cmbPenType.Left - PT_FYS;
 cmbPenWidth.Width:= grbPen.Width - cmbPenWidth.Left - PT_FYS;
 cmbBrushType.Width:= grbPen.Width - cmbBrushType.Left - PT_FYS;
 lblPColor.Width:= grbPen.Width - lblPColor.Left - PT_FYS;
 lblBColor.Width:= grbPen.Width - lblBColor.Left - PT_FYS;
 edtName.Width:= grbPen.Width - edtName.Left;
 btnFont.Left:= grbPen.Width - btnFont.Width;
 lblFFont.Width:= btnFont.Left - PT_FYS;
end;

procedure TFrmProp.lblPColorClick(Sender: TObject);
var
 pen: tagLOGPEN;
 brsh: tagLOGBRUSH;
begin
 if not Assigned(FrmMain.FNewFigure) then Exit;
 if dlgColor.Execute then
  begin
   (Sender as TLabel).Color:= dlgColor.Color;
   if dlgColor.Color = (Sender as TLabel).Font.Color then
     (Sender as TLabel).Font.Color:= dlgColor.Color + $FF
   else
     (Sender as TLabel).Font.Color:= clWhite;

   pen:= FrmMain.FNewFigure.Pen;
   brsh:= FrmMain.FNewFigure.Brush;

   case (Sender as TLabel).Tag of
    1: begin
        pen.lopnColor:= lblPColor.Color;
        FrmMain.FNewFigure.Pen:= pen;
       end;
    2: begin
        brsh.lbColor:= lblBColor.Color;
        FrmMain.FNewFigure.Brush:= brsh;
       end;
   end;

   FrmMain.RepaintItems;
   FrmMain.InvalidateForm;

  end;
  FrmMain.FDirty:= True;
   FrmMain.ControlSave(True);
end;

procedure TFrmProp.cmbPenTypeDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 r: TRect;
 i: Integer;
begin
i:= (Control as TComboBox).ItemHeight div 2;
 with (Control as TComboBox).Canvas do
  begin
   r:= Rect;
   FillRect(r);
   Pen.Color:= clBlack;
   Pen.Style:= TPenStyle(Index);
   MoveTo(r.Left + PT_FYS div 2, r.Top + i);
   LineTo(r.Left + PT_FYS * 6, r.Top + i);
   TextOut(r.Left + PT_FYS * 6 + 3, R.Top, (Control as TComboBox).Items[Index]);
  end;
end;

procedure TFrmProp.cmbPenWidthDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 r: TRect;
 i: Integer;
begin
i:= (Control as TComboBox).ItemHeight div 2;
 with (Control as TComboBox).Canvas do
  begin
   r:= Rect;
   FillRect(r);
   Pen.Color:= clBlack;
   Pen.Style:= psSolid;
   Pen.Width:= StrToInt(((Control as TComboBox).Items[Index]));
   MoveTo(r.Left + PT_FYS div 2, r.Top + i);
   LineTo(r.Left + PT_FYS * 6, r.Top + i);
   TextOut(r.Left + PT_FYS * 6 + 3, R.Top, (Control as TComboBox).Items[Index]);
  end;
end;

procedure TFrmProp.FormCreate(Sender: TObject);
begin
 cmbPenType.ItemIndex:= 0;
 cmbPenWidth.ItemIndex:= 0;
 cmbBrushType.ItemIndex:= 0;
 cmbFigure.Clear;
 lblFFont.Caption:= Format('%s, %d',[lblFFont.Font.Name, lblFFont.Font.Size])
end;

procedure TFrmProp.cmbBrushTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
 r: TRect;
begin
 with (Control as TComboBox).Canvas do
  begin
   r:= Rect;
   FillRect(r);
   Pen.Color:= clBlack;
   Pen.Style:= psSolid;
   Brush.Color:= clBlack;
   Brush.Style:= TBrushStyle(Index);
   Rectangle(r.Left, r.Top, r.Left + PT_FYS * 6, r.Bottom);
   Brush.Style:= bsClear;
   TextOut(r.Left + PT_FYS * 6 + 3, R.Top, (Control as TComboBox).Items[Index]);
  end;
end;

// Изменение свойства линии
procedure TFrmProp.cmbPenTypeChange(Sender: TObject);
var
 value: Integer;
 pen: tagLOGPEN;
 brsh: tagLOGBRUSH;
begin
 value:= (Sender as TComboBox).ItemIndex;
 with FrmMain do begin
  if not Assigned(FNewFigure) then Exit;
  case (Sender as TComboBox).Tag of
   // Pen type
   1: begin
       pen:= FNewFigure.Pen;
       pen.lopnStyle:= value;
       pen.lopnColor:= lblPColor.Color;
       FNewFigure.Pen:= pen;
      end;
   // Pen width
   2: begin
       pen:= FNewFigure.Pen;
       pen.lopnWidth:= Point(value + 1, 1);
       pen.lopnColor:= lblPColor.Color;
       FNewFigure.Pen:= pen;
      end;
   // Brush type
   3: begin
       brsh:= FNewFigure.Brush;
        if (value = 0) or (value = 1) then brsh.lbStyle:= value
         else brsh.lbStyle:= BS_HATCHED;
       brsh.lbHatch:= value - 2;
       brsh.lbColor:= lblBColor.Color;
       FNewFigure.Brush:= brsh;
      end;
  end;
  RepaintItems;
  InvalidateForm;
 end;
 FrmMain.FDirty:= True;
 FrmMain.ControlSave(True);
end;

procedure TFrmProp.LoadProperties(Figure: TDrawRect);

  function GetDrawChars: Integer;
   var
    b: Byte;
   begin
    b:= 0;
    with Figure.Font do
     begin
      if lfWeight = FW_BOLD then b:= 2;
      Result:= lfItalic + b;
     end;
   end;

  // True - vertical
  function GetAlignChars(ADirection: Boolean): Integer;
   var
    a, b: Cardinal;
   begin
    Result:= 0;
    b:= Figure.FontFormat XOR DT_SINGLELINE;
    if ADirection then
     begin
      a:= b AND $C;
       case a of
        DT_TOP: Result:= 0;
        DT_VCENTER: Result:= 1;
        DT_BOTTOM: Result:= 2;
       end;
     end
    else
     begin
      a:= b AND $3;
       case a of
        DT_LEFT: Result:= 0;
        DT_CENTER: Result:= 2;
        DT_RIGHT: Result:= 1;
       end;
     end;
   end;

var
 value, type_value, i, j: Integer;
 s: String;
 li: TListItem;
begin
 // ***** ЗАГРУЗКА СВОЙСТВ УКАЗАННОЙ ФИГУРЫ
 // *** Графические свойства
 // Тип пера
 cmbPenType.ItemIndex:= Figure.Pen.lopnStyle;
 // Ширина пера
 cmbPenWidth.ItemIndex:= Figure.Pen.lopnWidth.x - 1;
 // Тип кисти
  value:= Figure.Brush.lbStyle;
   if (value = 0) or (value = 1) then type_value:= value
    else type_value:= Figure.Brush.lbHatch + 2;
 cmbBrushType.ItemIndex:= type_value;
 // Цвет пера
 lblPColor.Color:= Figure.Pen.lopnColor;
 // Цвет кисти
 lblBColor.Color:= Figure.Brush.lbColor;
 // Имя фигуры
 edtName.Text:= Figure.NameFigure;
 // Шрифт
 if Figure.Shape = gfText then
  with FrmPropText do
   begin
    s:= StrPas(Figure.Font.lfFaceName);
    value:= Round(-Figure.Font.lfHeight * 72 / PixelsPerInch);
    edtText.Text:= Figure.Text;
    lstFont.ItemIndex:= lstFont.Items.IndexOf(s);
    lstDraw.ItemIndex:= GetDrawChars;
    lstSize.ItemIndex:= lstSize.Items.IndexOf(IntToStr(value));
    lstVert.ItemIndex:= GetAlignChars(True);
    lstHorz.ItemIndex:= GetAlignChars(False);
    lblFFont.Caption:= s + ', ' + IntToStr(value);
   end;
 // *** Физические свойства
 lvFys.Items.Clear;
 with Figure.PropPhysical do
  begin
   if CountX <> 0 then
    if Item[0,0] <> '' then
     for i:= 0 to CountX - 1 do
      begin
       li:= lvFys.Items.Add;
       li.Caption:= Item[i, 0];
       for j:= 1 to CountY - 1 do li.SubItems.Add(Item[i, j]);
      end;
  end;
 // *** Дополнительные свойства
 lvAdd.Items.Clear;
 with Figure.PropAdditional do
  begin
   if CountX <> 0 then
    if Item[0,0] <> '' then
     for i:= 0 to CountX - 1 do
      begin
       li:= lvAdd.Items.Add;
       li.Caption:= Item[i, 0];
       for j:= 0 to CountY - 1 do li.SubItems.Add(Item[i, j]);
      end;
  end;
end;

procedure TFrmProp.cmbFigureChange(Sender: TObject);
var
 i: Integer;
begin
 SetStateControl;
// ***** ПОИСК ФИГУРЫ ПО СПИСКУ ПРИ ИЗМЕНЕНИИ СПИСКА
 if cmbFigure.Items.Count = 0 then Exit;
  with FrmMain do
   begin
    if FItem.Count = 0 then Exit;
    for i:= 0 to FItem.Count - 1 do
     if (FItem[i] as TDrawRect).NameFigure = cmbFigure.Text then
      begin
       FNewFigure:= TDrawRect(FItem[i]);
       LoadProperties(FNewFigure);
       RepaintItems;
       InvalidateForm;
       Break;
      end;
   end;
 FrmMain.FDirty:= True;  
end;

procedure TFrmProp.cmbFigureDrawItem(Control: TWinControl; Index: Integer;  Rect: TRect; State: TOwnerDrawState);
var
 r: TRect;
 s: String;
 H, W, c, i, X1, Y1: Integer;
 ds: TDrawShape;
begin
 // Find type figure
 if FrmMain.FItem.Count = 0 then Exit;
 ds:= gfLine;
 s:= (Control as TComboBox).Items[Index];
 for i:= 0 to FrmMain.FItem.Count - 1 do
  if (FrmMain.FItem[i] as TDrawRect).NameFigure = s then
   begin
    ds:= (FrmMain.FItem[i] as TDrawRect).Shape;
    Break;
   end;
 // Init params
 i:= cmbFigure.ItemHeight div 2;
 r:= Rect;
  with (Control as TComboBox).Canvas do
   begin
    FillRect(r);
    // Draw figure
    Brush.Style:= bsSolid;
    Brush.Color:= clActiveBorder;
    Pen.Style:= psSolid;
    Pen.Color:= clBlack;
    case ds of
     gfLine: begin
              MoveTo(r.Left + 2, r.Top + i);
              LineTo(r.Left + PT_FYS * 4, r.Top + i);
             end;
     gfRectangle: Rectangle(r.Left + 2, r.Top + 2, r.Left + PT_FYS * 4, r.Bottom - 2);
     gfRoundRectangle: RoundRect(r.Left + 2, r.Top + 2, r.Left + PT_FYS * 4, r.Bottom - 2, PT_FYS, PT_FYS);
     gfCircle: begin
                H:= (r.Bottom - r.Top); W:= (r.Left + PT_FYS * 4 - r.Left - 4);
                if W < H then c:= W else c:= H;
                X1:= r.Left + (W - c) div 2; Y1:= r.Top + (H - c) div 2;
                W:= c; H:= c;
                Ellipse(X1, Y1, X1 + W, Y1 + H);
               end;
     gfEllipse: Ellipse(r.Left + 2, r.Top + 2, r.Left + PT_FYS * 4, r.Bottom - 2);
     gfPolyLine: PolyLine([Point(r.Left+2, r.Top +2), Point(r.Left + PT_FYS * 3, r.Top + i), Point(r.Left + PT_FYS, r.Bottom - 2)]);
     gfPolygon: Polygon([Point(r.Left+2, r.Top +2), Point(r.Left + PT_FYS * 3, r.Top + i), Point(r.Left + PT_FYS, r.Bottom - 2)]);
     gfBezier:  PolyBezier([Point(r.Left+2, r.Top +2), Point(r.Left + PT_FYS * 3, r.Top + i), Point(r.Left + PT_FYS, r.Bottom - 2), Point(r.Left +2, r.Bottom - 2)]);
     gfText: begin
              Brush.Style:= bsClear;
              TextOut(r.Left + 2, r.Top, 'ABC');
             end;
    end;
    // Out text
    Brush.Style:= bsClear;
    Pen.Color:= clBlack;
    Pen.Style:= psClear;
    TextOut(r.Left + PT_FYS * 5, r.Top, s);
   end;
end;

procedure TFrmProp.btnFontClick(Sender: TObject);
var
 fFont: LOGFONT;
 fAttr: Cardinal;
 size: Integer;
begin
 if FrmPropText.ShowModal = mrCancel then Exit;
  with fFont, FrmPropText, FrmMain do
   begin
    // Get prev font
    fFont:= FNewFigure.Font; 
    // Name font
    StrCopy(lfFaceName, PChar(lstFont.Items[lstFont.ItemIndex]));
    // Draw chars
     lfItalic:= 0; lfWeight:= FW_NORMAL;
     case lstDraw.ItemIndex of
      1: lfItalic:= 1;
      2: lfWeight:= FW_BOLD;
      3: begin lfItalic:= 1; lfWeight:= FW_BOLD; end;
     end;
    // Size chars
     size:= StrToInt(lstSize.Items[lstSize.ItemIndex]);
     lfHeight:= Round(-size * PixelsPerInch / 72);
    // Attr vertical
     fAttr:= DT_SINGLELINE or TextAlignVertical[lstVert.ItemIndex];
    // Attr horizontal
     fAttr:= fAttr or TextAlignHorizontal[lstHorz.ItemIndex];
    // Information font
    lblFFont.Caption:= Format('%s, %d',[lstFont.Items[lstFont.ItemIndex], size]);
    // Set font
    FNewFigure.Font:= fFont;
    FNewFigure.FontFormat:= fAttr;
    // Set text
    FNewFigure.Text:= edtText.Text; 
    RepaintItems;
    InvalidateForm;
   end;
end;

procedure TFrmProp.FormActivate(Sender: TObject);
begin
 SetStateControl;
 lvFysClick(nil);
 lvAddClick(nil);
end;

procedure TFrmProp.SetStateControl;
var
 ds: TDrawShape;
 s: String;
 i: Integer;
begin
 with FrmMain do
  begin
   ds:= gfLine;
   btnFont.Enabled:= FItem.Count <> 0;
   if FItem.Count = 0 then Exit;
   s:= cmbFigure.Items[cmbFigure.ItemIndex];
   for i:= 0 to FItem.Count - 1 do
    if (FItem[i] as TDrawRect).NameFigure = s then
     begin
      ds:= (FItem[i] as TDrawRect).Shape;
      Break;
     end;
   btnFont.Enabled:= ds = gfText;
   tabFys.Enabled:= ds <> gfText;
   tabAdd.Enabled:= ds <> gfText;
   lblFFont.Visible:= ds = gfText;
   Self.Refresh;
  end;
end;

procedure TFrmProp.edtNameKeyPress(Sender: TObject; var Key: Char);
var
 OldName: String;
 i, OldIndex: Integer;
begin
 with cmbFigure do
 if (Key = #13) and (Items.Count <> 0) then
  begin
   OldName:= AnsiUpperCase(edtName.Text);
   OldIndex:= ItemIndex;
   for i:= 0 to Items.Count - 1 do
    if (AnsiUpperCase(Items[i]) = OldName) and (i <> OldIndex) then
     begin
      MessageDlg(MSG_CONSIST_NAME, mtInformation, [mbOK, mbHelp], HELP_CONSIST_NAME);
      edtName.Text:= Items[OldIndex];
      Exit;
     end;
   Items[OldIndex]:= edtName.Text;
   ItemIndex:= OldIndex;
   Hide;
   FrmMain.FNewFigure.NameFigure:= edtName.Text;
   Show;    
  end;
 FrmMain.FDirty:= True;
  FrmMain.ControlSave(True);
end;

procedure TFrmProp.btnFAddClick(Sender: TObject);
var
 li: TListItem;
begin
 with FrmParam do
  begin
   edtParam.Text:= '';
   edtValue.Text:= '';
   edtNum.Enabled:= True;
   edtNum.Text:= '';
   edtTag.Enabled:= True;
   edtTag.Text:= '';
   FSelectList:= True;
   ShowModal;
    if ModalResult = mrOK then
     with lvFys do
      begin
       li:= Items.Add;
       li.Caption:= edtParam.Text;
       li.SubItems.Add(edtNum.Text);
       li.SubItems.Add(edtValue.Text);
       li.SubItems.Add(edtTag.Text);
       // Добавить в свойство фигуры
       with FrmMain.FNewFigure.PropPhysical do
        begin
         Add;
         Item[CountX-1, 0]:= edtParam.Text;
         Item[CountX-1, 1]:= edtNum.Text;
         Item[CountX-1, 2]:= edtValue.Text;
         Item[CountX-1, 3]:= edtTag.Text;
        end;
      end
  end;
end;

procedure TFrmProp.btnAAddClick(Sender: TObject);
var
 li: TListItem;
begin
 with FrmParam do
  begin
   edtParam.Text:= '';
   edtValue.Text:= '';
   edtNum.Enabled:= False;
   edtNum.Text:= '';
   edtTag.Enabled:= False;
   edtTag.Text:= '';
   FSelectList:= False;
   ShowModal;
    if ModalResult = mrOK then
     with lvAdd do
      begin
       li:= Items.Add;
       li.Caption:= edtParam.Text;
       li.SubItems.Add(edtValue.Text);
         with FrmMain.FNewFigure.PropAdditional do
          begin
           Add;
           Item[CountX-1, 0]:= edtParam.Text;
           Item[CountX-1, 1]:= edtValue.Text;
          end;
      end;
  end;
end;

procedure TFrmProp.btnFEditClick(Sender: TObject);
begin
 with FrmParam do
  begin
   edtNum.Enabled:= True;
   edtTag.Enabled:= True;
   FSelectList:= True;
   edtParam.Text:= lvFys.Selected.Caption;
   edtNum.Text:= lvFys.Selected.SubItems.Strings[0];
   edtValue.Text:= lvFys.Selected.SubItems.Strings[1];
   edtTag.Text:= lvFys.Selected.SubItems.Strings[2];
   ShowModal;
    if ModalResult = mrOK then
     with lvFys.Selected do
      begin
       Caption:= edtParam.Text;
       SubItems.Strings[0]:= edtNum.Text;
       SubItems.Strings[1]:= edtValue.Text;
       SubItems.Strings[2]:= edtTag.Text;
        with FrmMain.FNewFigure.PropPhysical do
         begin
          Item[Index, 0]:= edtParam.Text;
          Item[Index, 1]:= edtNum.Text;
          Item[Index, 2]:= edtValue.Text;
          Item[Index, 3]:= edtTag.Text;
         end;
      end;
  end;
end;

procedure TFrmProp.lvFysClick(Sender: TObject);
begin
 btnFEdit.Enabled:= Assigned(lvFys.Selected);
 btnFDel.Enabled:= btnFEdit.Enabled;
end;

procedure TFrmProp.lvAddClick(Sender: TObject);
begin
 btnFEdit.Enabled:= Assigned(lvAdd.Selected);
 btnFDel.Enabled:= btnFEdit.Enabled;
end;

procedure TFrmProp.btnAEditClick(Sender: TObject);
begin
  if Sender = btnAEdit then
   begin
   if not Assigned(lvAdd.Selected) then Exit;
   end
  else
   begin
   if not Assigned(lvFys.Selected) then Exit;
   end;
 with FrmParam do
  begin
   edtNum.Text:= '';
   edtTag.Text:= '';
   edtNum.Enabled:= False;
   edtTag.Enabled:= False;
   Refresh;
   FSelectList:= False;
   edtParam.Text:= lvAdd.Selected.Caption;
   edtValue.Text:= lvAdd.Selected.SubItems.Strings[0];
   ShowModal;
    if ModalResult = mrOK then
     with lvAdd.Selected do
      begin
       Caption:= edtParam.Text;
       SubItems.Strings[0]:= edtValue.Text;
        with FrmMain.FNewFigure.PropAdditional do
         begin
          Item[Index, 0]:= edtParam.Text;
          Item[Index, 1]:= edtValue.Text;
         end;
      end;
  end;
end;

procedure TFrmProp.btnADelClick(Sender: TObject);
begin
  if Sender = btnADel then begin if not Assigned(lvAdd.Selected) then Exit; end
                      else begin if not Assigned(lvFys.Selected) then Exit; end;
  if MessageDlg(MSG_DELETE_PARAM, mtConfirmation, [mbYes, mbNo, mbHelp], HELP_DELETE_PARAM) = mrYes then
   if Sender = btnADel then
    begin
     FrmMain.FNewFigure.PropAdditional.Remove(lvAdd.Selected.Index);
     lvAdd.Selected.Delete
    end
   else
    begin
     FrmMain.FNewFigure.PropPhysical.Remove(lvFys.Selected.Index);
     lvFys.Selected.Delete;
    end;
   FrmMain.FDirty:= True; 
end;

procedure TFrmProp.pgcPropChange(Sender: TObject);
begin
 lvFysClick(nil);
 lvAddClick(nil);
end;

procedure TFrmProp.SetDefaultProperties;
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

  SetStateControl; 
end;

end.
