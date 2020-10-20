unit DrawGrid;

interface

uses Windows, Controls, Forms, SysUtils, Graphics, CLasses, ScaleData,
     Global;

 procedure GridControl(ColorBack: COLORREF);
 procedure RulerVertical(X, Y: Integer);
 procedure RulerHorizontal(X, Y: Integer);

implementation

uses CADFunction;

procedure RulerHorizontal(X, Y: Integer);
var
 OldPen, HP: HPEN;
 OldBkMode: Integer;
begin
 OldBkMode:= SetBkMode(mDC, TRANSPARENT);
 HP:= CreatePen(PS_DOT, 1, clBlue);
 OldPen:= SelectObject(mDC, HP);
  try
   Line(mDC, SIZE_RULER, Y - GRID_Y, GRID_HEIGHT, Y - GRID_Y);
  finally
   SelectObject(mDC, OldPen);
   DeleteObject(HP);
   SetBkMode(mDC, OldBkMode);
  end;
end;

procedure RulerVertical(X, Y: Integer);
var
 OldPen, HP: HPEN;
 OldBkMode: Integer;
begin
 OldBkMode:= SetBkMode(mDC, TRANSPARENT);
 HP:= CreatePen(PS_DOT, 1, clBlue);
 OldPen:= SelectObject(mDC, HP);
  try
   Line(mDC, X - GRID_X, SIZE_RULER, X - GRID_X, GRID_HEIGHT);
  finally
   SelectObject(mDC, OldPen);
   DeleteObject(HP);
   SetBkMode(mDC, OldBkMode);
  end;
end;

procedure GridControl(ColorBack: COLORREF);
var
 OldBrush,HB : HBRUSH;
 lgBrush: LOGBRUSH;
 OldPen, HP: HPEN;
 OldFont, HF: HFONT;
 i, OldBkMode: Integer;
 recFont: LOGFONT;
 s: String;
begin
   // Создать кисть для заливки
   lgBrush.lbStyle:= BS_SOLID;
   lgBrush.lbColor:= ColorBack;
   lgBrush.lbHatch:= HS_CROSS;
   HB:= CreateBrushIndirect(lgBrush);
   OldBrush:= SelectObject(mDC, HB);
   // Копируем кисть в контекст
   PatBlt(mDC, 0, 0, GRID_WIDTH, GRID_HEIGHT, PATCOPY);

   SelectObject(mDC, OldBrush);
   DeleteObject(HB);

   HP:= CreatePen(PS_SOLID, 1, clLtGray);
   OldPen:= SelectObject(mDC, HP);
   try
   // Сетка
    for i:= 1 to MX do
     Line(mDC, i * STEP_GRID + SIZE_RULER, SIZE_RULER,
               i * STEP_GRID + SIZE_RULER, GRID_HEIGHT);
    for i:= 1 to MY do
     Line(mDC, SIZE_RULER, i * STEP_GRID + SIZE_RULER,
               GRID_WIDTH, i * STEP_GRID + SIZE_RULER);
    // Рамка сетки
    SelectObject(mDC, GetStockObject(NULL_BRUSH));
    SelectObject(mDC, GetStockObject(BLACK_PEN));
    Rectangle(mDC, 0, 0, GRID_WIDTH, GRID_HEIGHT );
    // Ограничивающие линии линеек
    Line(mDC, SIZE_RULER, SIZE_RULER, GRID_WIDTH - 1, SIZE_RULER);
    Line(mDC, SIZE_RULER, SIZE_RULER, SIZE_RULER, GRID_HEIGHT - 1);
    // Подготовка шрифта
     with recFont do
      begin
       lfHeight:= 8;
       lfWidth:= 0;
       lfEscapement:= 0;
       lfOrientation:= 0;
       lfWeight:= FW_NORMAL;
       lfItalic:= 0;
       lfUnderline:= 0;
       lfStrikeOut:= 0;
       lfCharSet:= DEFAULT_CHARSET;
       lfOutPrecision:= OUT_DEFAULT_PRECIS;
       lfClipPrecision:= CLIP_DEFAULT_PRECIS;
       lfQuality:= DEFAULT_QUALITY;
       lfPitchAndFamily:= FF_ROMAN;
       StrCopy(lfFaceName, 'MS Serif');
      end;
    HF:= CreateFontIndirect(recFont);
    OldFont:= SelectObject(mDC, HF);
    SetTextAlign(mDC, TA_CENTER);
    OldBkMode:= SetBkMode(mDC, TRANSPARENT);
    // Вывести обозначения на линейках
    for i:= 0 to MX - 1 do
     if (i mod STEP_RULER) = 0 then
      begin
       s:= IntToStr(i);
       TextOut(mDC, i * PT_FYS + SIZE_RULER, 2, PChar(s), Length(s));
       Line(mDC, i * PT_FYS + SIZE_RULER, 15, i * PT_FYS + SIZE_RULER, SIZE_RULER)
      end;
    SetTextAlign(mDC, TA_LEFT);
    for i:= 0 to MY - 1 do
     if (i mod STEP_RULER) = 0 then
      begin
       s:= IntToStr(i);
       TextOut(mDC, 2, i * PT_FYS + SIZE_RULER - 6, PChar(s), Length(s));
       Line(mDC, 15, i * PT_FYS + SIZE_RULER, SIZE_RULER, i * PT_FYS + SIZE_RULER)
      end;
    SelectObject(mDC, OldFont);
    DeleteObject(HF);
    SetBkMode(mDC, OldBkMode);
    // Нарисовать штрихи
    for i:= 1 to MX do
     begin
      Line(mDC, i * STEP_GRID + SIZE_RULER, SIZE_RULER - PT_FYS div 2,
                i * STEP_GRID + SIZE_RULER, SIZE_RULER);
      Line(mDC, SIZE_RULER - PT_FYS div 2, i * STEP_GRID + SIZE_RULER,
                SIZE_RULER, i * STEP_GRID + SIZE_RULER);
     end;
   finally
    SelectObject(mDC, OldPen);
    DeleteObject(HP);
   end;
end;

end.
