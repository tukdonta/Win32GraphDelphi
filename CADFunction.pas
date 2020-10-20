unit CADFunction;

interface

uses Windows, Classes, DrawObj;

const
 FIND_X = True;
 FIND_Y = False;

function PtInLine(R: TRect; P: TPoint): Boolean; 
function MaxPoint(P: array of TPoint; fdValue: Boolean): Integer;
function MinPoint(P: array of TPoint; fdValue: Boolean): Integer;
function EqualPoint(AFirst, ASecond: TPoint): Boolean;
function RectInRect(RSource, RDest: TRect): Boolean;
procedure OutText(DC: HDC; X, Y: Integer; TextStr: String; ColorStr, ColorBack: COLORREF; Align: Boolean);
procedure Line(DC: HDC; X1, Y1, X2, Y2: Integer);
function NormalizeRect(R: TRect): TRect;

implementation

uses ScaleData, SysUtils, Global;


function PtInLine(R: TRect; P: TPoint): Boolean;
// Алгоритм Брензенхама по отрисовке линий
var
 sx, sy, sz, dx, dy, xe,ye, ix, iy, ds, t: SmallInt;
begin
 Result:= False;
  xe:= 0; ye:= 0;
   sx:= r.Left; sy:= r.Top;
    sz:= SIZE_MARKER shr 2;
 // Расстояние в обоих направлениях
 dx:= r.Right - r.Left; dy:= r.Bottom - r.Top;
 // Вычисление шага
 if dx > 0 then ix:= 1 else if dx = 0 then ix:= 0 else ix:= -1;
 if dy > 0 then iy:= 1 else if dy = 0 then iy:= 0 else iy:= -1;
 // big distance
 dx:= Abs(dx); dy:= Abs(dy); if dx > dy then ds:= dx else ds:= dy;
 // draw line
 for t:= 0 to ds + 1 do
  begin
   xe:= xe + dx; ye:= ye + dy;
    if (xe > ds) then begin xe:= xe - ds; sx:= sx + ix; end;
    if (ye > ds) then begin ye:= ye - ds; sy:= sy + iy; end;
     if ((P.X - sz <= sx) and (P.X + sz >= sx)) and
        ((P.Y - sz <= sy) and (P.Y + sz >= sy)) then
         begin
          Result:= True;
          Break;
         end;
  end;
end;

function MaxPoint(P: array of TPoint; fdValue: Boolean): Integer;
var
 i, t: Integer;
begin
 t:= P[0].X;
  for i:= 0 to High(P) do
   if fdValue = FIND_X then
    begin
     if P[i].X > t then t:= P[i].X;
    end
   else
    begin
     if P[i].Y > t then t:= P[i].Y;
    end;
 Result:= t;    
end;

function MinPoint(P: array of TPoint; fdValue: Boolean): Integer;
var
 i, t: Integer;
begin
 t:= P[0].X;
  for i:= 0 to High(P) do
   if fdValue = FIND_X then
    begin
     if P[i].X < t then t:= P[i].X;
    end
   else
    begin
     if P[i].Y < t then t:= P[i].Y;
    end;
 Result:= t;
end;

function EqualPoint(AFirst, ASecond: TPoint): Boolean;
 begin
  Result:= (AFirst.x = ASecond.x) and (AFirst.y = ASecond.y);
 end;

function RectInRect(RSource, RDest: TRect): Boolean;
 begin
  InflateRect(RDest, 1, 1);
  with RSource do
   Result:= (Left <= RDest.Left) and
            (Top <= RDest.Top) and
            (Right >= RDest.Right) and
            (Bottom >= RDest.Bottom);
 end;

procedure OutText(DC: HDC; X, Y: Integer; TextStr: String; ColorStr, ColorBack: COLORREF; Align: Boolean);
 var
  OldFont, HF: HFONT;
  recFont: LOGFONT;
  OldColor: COLORREF;
  OldBkMode: Integer;
  ts: tagSIZE;
  tx, ty: Integer;
begin
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
  OldFont:= SelectObject(DC, HF);
  OldBkMode:= SetBkMode(DC, TRANSPARENT);
   OldColor:= SetTextColor(DC, ColorStr);
    if Align and GetTextExtentPoint32(DC, PChar(TextStr), Length(TextStr), ts) then
     begin
      tx:= ts.cx; ty:= ts.cy;
      if ((X+tx) >= GRID_WIDTH) or ((Y+ty)>= GRID_HEIGHT) then
       begin
        X:= X - tx - 4;
        Y:= Y - ty - 4;
       end;
     end;
    TextOut(DC, X, Y, PChar(TextStr), Length(TextStr));
   SetTextColor(DC, OldColor);
  SetBkMode(DC, OldBkMode);
  SelectObject(DC, OldFont);
  DeleteObject(HF);
 end;

function NormalizeRect(R: TRect): TRect;
 var
  e: Integer;
  rt: TRect;
 begin
 rt:= R;
  if R.Left >= R.Right then
   begin
    e:= Rt.Left;
    Rt.Left:= Rt.Right;
    Rt.Right:= e;
   end;
  if R.Top >= R.Bottom then
   begin
    e:= Rt.Top;
    Rt.Top:= Rt.Bottom;
    Rt.Bottom:= e;
   end;
  Result:= Rt; 
 end;

procedure Line(DC: HDC; X1, Y1, X2, Y2: Integer);
 begin
  MoveToEx(DC, X1, Y1, nil);
  LineTo(DC, X2, Y2);
 end;

end.
