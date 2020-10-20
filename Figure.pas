unit Figure;

interface

uses Windows, Classes, Global;

procedure TextOutA(DC: HDC; TextStr: String; R: TRect; HandleFont: LOGFONT; FormatText: UINT);
procedure PolygonA(DC: HDC; const P: array of TPoint);
procedure PolyLineA(DC: HDC; const P: array of TPoint);
procedure BezierA(DC: HDC; const P: array of TPoint);
procedure PieA(DC: HDC; X1, Y1, X2, Y2: Integer; PS, PE: TPoint); overload;
procedure PieA(DC: HDC; R: TRect; PS, PE: TPoint); overload;
procedure ArcA(DC: HDC; X1, Y1, X2, Y2: Integer; PS, PE: TPoint); overload;
procedure ArcA(DC: HDC; R: TRect; PS, PE: TPoint); overload;
procedure RoundRectangleA(DC: HDC; X1, Y1, X2, Y2: Integer; Rn: TPoint); overload;
procedure RoundRectangleA(DC: HDC; R: TRect; Rn: TPoint); overload;
procedure CircleA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
procedure CircleA(DC: HDC; R: TRect); overload;
procedure EllipseA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
procedure EllipseA(DC: HDC; R: TRect); overload;
procedure LineA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
procedure LineA(DC: HDC; R: TRect); overload;
procedure RectangleA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
procedure RectangleA(DC: HDC; R: TRect); overload;

implementation

procedure TextOutA(DC: HDC; TextStr: String; R: TRect; HandleFont: LOGFONT; FormatText: UINT);
var
 NewFont: HFONT;
 OldFont: HFONT;
begin
 // Нарисовать текст
 NewFont:= CreateFontIndirect(HandleFont);
 OldFont:= SelectObject(DC, NewFont);
  DrawText(DC, PChar(TextStr), Length(TextStr), R, FormatText);
 SelectObject(DC, OldFont);
 DeleteObject(NewFont);
end;

procedure PolygonA(DC: HDC; const P: array of TPoint);
begin
 Polygon(DC, PPoints(@P)^, High(P) + 1);
end;

procedure PolyLineA(DC: HDC; const P: array of TPoint);
begin
 PolyLine(DC, PPoints(@P)^, High(P) + 1);
end;

procedure BezierA(DC: HDC; const P: array of TPoint);
begin
 PolyBezier(DC, PPoints(@P)^, High(P) + 1);
end;


procedure PieA(DC: HDC; X1, Y1, X2, Y2: Integer; PS, PE: TPoint);
begin
 Pie(DC, X1, Y1, X2, Y2, PS.x, PS.y, PE.x, PE.y);
end;

procedure PieA(DC: HDC; R: TRect; PS, PE: TPoint);
begin
  Pie(DC, R.Left, R.Top, R.Right, R.Bottom, PS.x, PS.y, PE.x, PE.y);
end;


procedure ArcA(DC: HDC; X1, Y1, X2, Y2: Integer; PS, PE: TPoint);
begin
 Arc(DC, X1, Y1, X2, Y2, PS.x, PS.y, PE.x, PE.y);
end;

procedure ArcA(DC: HDC; R: TRect; PS, PE: TPoint);
begin
  Arc(DC, R.Left, R.Top, R.Right, R.Bottom, PS.x, PS.y, PE.x, PE.y);
end;

procedure RoundRectangleA(DC: HDC; X1, Y1, X2, Y2: Integer; Rn: TPoint); overload;
begin
 RoundRect(DC, X1, Y1, X2, Y2, Rn.X, Rn.Y);
end;

procedure RoundRectangleA(DC: HDC; R: TRect; Rn: TPoint); overload;
begin
 RoundRect(DC, R.Left, R.Top, R.Right, R.Bottom, Rn.X, Rn.Y);
end;

procedure CircleA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
var
 H, W, c: Integer;
begin
 H:= (Y2 - Y1);
 W:= (X2 - X1);
 if W < H then c:= W else c:= H;
  X1:= X1 + (W - c) div 2;
  Y1:= Y1 + (H - c) div 2;
  W:= c;
  H:= c;
 Ellipse(DC, X1, Y1, X1 + W, Y1 + H);
end;

procedure CircleA(DC: HDC; R: TRect); overload;
var
 H, W, c: Integer;
begin
 H:= (R.Bottom - R.Top);
 W:= (R.Right - R.Left);
 if W < H then c:= W else c:= H;
  R.Left:= R.Left + (W - c) div 2;
  R.Top:= R.Top + (H - c) div 2;
  W:= c;
  H:= c;
 Ellipse(DC, R.Left, R.Top, R.Left + W, R.Top + H);
end;

procedure EllipseA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
begin
 Ellipse(DC, X1, Y1, X2, Y2);
end;

procedure EllipseA(DC: HDC; R: TRect); overload;
begin
 Ellipse(DC, R.Left, R.Top, R.Right, R.Bottom);
end;


procedure LineA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
begin
 MoveToEx(DC, X1, Y1, nil);
 LineTo(DC, X2, Y2);
end;

procedure LineA(DC: HDC; R: TRect); overload;
begin
 MoveToEx(DC, R.Left, R.Top, nil);
 LineTo(DC, R.Right, R.Bottom);
end;

procedure RectangleA(DC: HDC; X1, Y1, X2, Y2: Integer); overload;
begin
 Rectangle(DC, X1, Y1, X2, Y2);
end;

procedure RectangleA(DC: HDC; R: TRect); overload;
begin
 Rectangle(DC, R.Left, R.Top, R.Right, R.Bottom);
end;

end.
