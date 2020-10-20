unit DrawObj;

interface

uses Windows, Classes, Forms, Archive, SysUtils, Controls,
     Figure, Global, StorageStruct;

 type
  TDrawObj = class(TObject)
   private
    FFormatText: UINT;
    FFont: LOGFONT;
    FPen: LOGPEN;
    FBrush: LOGBRUSH;
    FRect: TRect;
    FMarkerCursor: TCursor;
    FMarkerRect: TRect;
    FMarkerCount: Integer;
    FMarker: TPoint;
    FText: String;
    procedure DoGetMarkerCursor(MarkerID: Integer);
    procedure DoGetMarkerRect(MarkerID: Integer);
    procedure DoGetMarkerCount;
    procedure DoGetMarker(MarkerID: Integer);
   public
    constructor Create(ARect: TRect); virtual;
    destructor Destroy; override;
    function HitTest(P: TPoint; Selected: Boolean): Integer;
    function GetMarkerCursor(MarkerID: Integer): TCursor; virtual;
    function GetMarkerRect(MarkerID: Integer): TRect; virtual;
    function GetMarkerCount: Integer; virtual;
    function GetMarker(MarkerID: Integer): TPoint; virtual;
    procedure MoveTo(NewPosition: TRect); virtual;
    procedure MoveMarkerTo(MarkerID: Integer; P: TPoint); virtual;
    procedure Serialize(ar: TArchive); virtual;
    procedure DrawTracker(DC: HDC; State: TTrackerState);
    procedure Draw(DC: HDC); virtual;
    procedure SetPosition(ARect: TRect);
    property Position: TRect read FRect;
    property Pen: LOGPEN read FPen write FPen;
    property Brush: LOGBRUSH read FBrush write FBrush;
    property Font: LOGFONT read FFont write FFont;
    property FontFormat: UINT read FFormatText write FFormatText;
    property Text: String read FText write FText;
  end;

 TDrawRect = class(TDrawObj)
  private
   FPoints: TDrawPoint;
   FCountPoints: Integer;
   FRn: TPoint;
   FShape: TDrawShape;
   FName: String;
   FFysProp: TMultiStorageString;
   FAddProp: TMultiStorageString;
   procedure SetDrawShape(const Value: TDrawShape);
   procedure SetAddProp(const Value: TMultiStorageString);
   procedure SetFysProp(const Value: TMultiStorageString);
  public
   constructor Create(ARect: TRect); override;
   destructor Destroy; override;
   procedure Assign(Source: TDrawRect);
   procedure AddPoint(P: TPoint);
   procedure RemovePoint(Index: Integer);
   procedure RecalcBounds;
   procedure MoveTo(NewPosition: TRect); override;
   procedure MoveMarkerTo(MarkerID: Integer; P: TPoint); override;
   function GetMarkerCursor(MarkerID: Integer): TCursor; override;
   function GetMarkerRect(MarkerID: Integer): TRect; override;
   function GetMarkerCount: Integer; override;
   function GetMarker(MarkerID: Integer): TPoint; override;
   procedure Serialize(ar: TArchive); override;
   procedure Draw(DC: HDC); override;
   property Shape: TDrawShape read FShape write SetDrawShape;
   property NameFigure: String read FName write FName;
   property CountPoints: Integer read FCountPoints write FCountPoints;
   property Points: TDrawPoint read FPoints;
   property RoundNess: TPoint read FRn;
   property PropPhysical: TMultiStorageString read FFysProp write SetFysProp;
   property PropAdditional: TMultiStorageString read FAddProp write SetAddProp;
   function PtInFigure(P: TPoint): Boolean;
 end;

function SelectBaseName(IDShape: TDrawShape): String;
function GetDefaultFont: LOGFONT;

var
 NUMBER_OBJ: LongInt;

implementation

uses CADFunction, ScaleData, Math;

{ Commont entry }
function GetDefaultFont: LOGFONT;
begin
 with Result do
  begin
   lfHeight:= Round(-8 * Screen.PixelsPerInch / 72);
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
   StrCopy(lfFaceName, 'MS Sans Serif');
  end;
end;

function SelectBaseName(IDShape: TDrawShape): String;
begin
 Result:= 'Неизвестная' + IntToStr(NUMBER_OBJ);
 case IDShape of
  gfLine: Result:= 'Линия ' + IntToStr(NUMBER_OBJ);
  gfRectangle: Result:= 'Прямоугольник ' + IntToStr(NUMBER_OBJ);
  gfRoundRectangle: Result:= 'Округлый прямоугольник ' + IntToStr(NUMBER_OBJ);
  gfCircle: Result:= 'Круг ' + IntToStr(NUMBER_OBJ);
  gfEllipse: Result:= 'Эллипс ' + IntToStr(NUMBER_OBJ);
  gfPolyLine: Result:= 'Ломанная ' + IntToStr(NUMBER_OBJ);
  gfPolygon: Result:= 'Полигон ' + IntToStr(NUMBER_OBJ);
  gfBezier: Result:= 'Безье ' + IntToStr(NUMBER_OBJ);
  gfText: Result:= 'Текст ' + IntToStr(NUMBER_OBJ);
 end;
end;

{ TDrawObj }

constructor TDrawObj.Create(ARect: TRect);
begin
 FRect:= ARect;
 FMarker:= Point(-1, -1);
 FMarkerRect:= Rect(-1, -1, -1, -1);
 FMarkerCount:= 8;
 FMarkerCursor:= crDefault;

 FPen.lopnStyle:= PS_SOLID;
 FPen.lopnWidth.x:= 1;
 FPen.lopnWidth.y:= 1;
 FPen.lopnColor:= RGB(0, 0, 0);

 FBrush.lbStyle:= BS_SOLID;
 FBrush.lbColor:= RGB(192, 192, 192);
 FBrush.lbHatch:= HS_VERTICAL;	   
end;

destructor TDrawObj.Destroy;
begin
 inherited;
end;

procedure TDrawObj.Draw(DC: HDC);
begin

end;

function TDrawObj.GetMarker(MarkerID: Integer): TPoint;
begin
 DoGetMarker(MarkerID);
 Result:= FMarker;
end;

function TDrawObj.GetMarkerCount: Integer;
begin
 DoGetMarkerCount;
 Result:= FMarkerCount;;
end;

function TDrawObj.GetMarkerCursor(MarkerID: Integer): TCursor;
begin
 DoGetMarkerCursor(MarkerID);
 Result:= FMarkerCursor;
end;

function TDrawObj.GetMarkerRect(MarkerID: Integer): TRect;
begin
 DoGetMarkerRect(MarkerID);
 Result:= FMarkerRect;
end;

procedure TDrawObj.MoveMarkerTo(MarkerID: Integer; P: TPoint);
var
 R: TRect;
begin
 R:= FRect;
  case MarkerID of
   1: begin R.Left:= P.x; R.Top:= P.y; end;
   2: R.Top:= P.y;
   3: begin R.Right:= P.x; R.Top:= P.y; end;
   4: R.Right:= P.x;
   5: begin R.Right:= P.x; R.Bottom:= P.y; end;
   6: R.Bottom:= P.y;
   7: begin R.Left:= P.x; R.Bottom:= P.y; end;
   8: R.Left:= P.x;
  end;
 MoveTo(R);
end;

procedure TDrawObj.MoveTo(NewPosition: TRect);
begin
 if EqualRect(FRect, NewPosition) then Exit;
 FRect:= NewPosition;
end;

procedure TDrawObj.Serialize(ar: TArchive);
var
 ft: Integer;
begin
 if ar.IsStoring then // Save data
  begin
   ar.DataWrite(Integer(FFormatText));
   ar.DataWrite(FFont);
   ar.DataWrite(FPen);
   ar.DataWrite(FBrush);
   ar.DataWrite(FRect);
   ar.DataWrite(FText);
  end
 else // Load data
  begin
   ar.DataRead(ft); FFormatText:= UINT(ft);
   ar.DataRead(FFont);
   ar.DataRead(FPen);
   ar.DataRead(FBrush);
   ar.DataRead(FRect);
   ar.DataRead(FText);
  end;
end;

procedure TDrawObj.SetPosition(ARect: TRect);
begin
 FRect:= ARect;
end;

procedure TDrawObj.DoGetMarker(MarkerID: Integer);
var
 xc, yc: Integer;
begin
 FMarker:= Point(-1, -1);
 with FRect do
  begin
   xc:= Left + (Right - Left) div 2;
   yc:= Top + (Bottom - Top) div 2;
    case MarkerID of
     1: FMarker:= Point(Left, Top);
     2: FMarker:= Point(xc, Top);
     3: FMarker:= Point(Right, Top);
     4: FMarker:= Point(Right, yc);
     5: FMarker:= Point(Right, Bottom);
     6: FMarker:= Point(xc, Bottom);
     7: FMarker:= Point(Left, Bottom);
     8: FMarker:= Point(Left, yc);
    end;
  end;
end;

procedure TDrawObj.DoGetMarkerCount;
begin
 FMarkerCount:= 8;
end;

procedure TDrawObj.DoGetMarkerCursor(MarkerID: Integer);
begin
 FMarkerCursor:= crDefault;
  case MarkerID of
   1, 5: FMarkerCursor:= crSizeNWSE;
   2, 6: FMarkerCursor:= crSizeNS;
   3, 7: FMarkerCursor:= crSizeNESW;
   4, 8: FMarkerCursor:= crSizeWE;
  end;
end;

procedure TDrawObj.DoGetMarkerRect(MarkerID: Integer);
var
 p: TPoint;
begin
 p:= GetMarker(MarkerID);
 FMarkerRect:= Rect(p.x - DEFAULT_SPACE, p.y - DEFAULT_SPACE, p.x + SIZE_MARKER, p.y + SIZE_MARKER);
end;

procedure TDrawObj.DrawTracker(DC: HDC; State: TTrackerState);
var
 i: Integer;
 p: TPoint;
 sm: Integer;
begin
 sm:= DEFAULT_SPACE + SIZE_MARKER;
 case State of
  tsNormal: ;
  tsSelected,
  tsActive:
   for i:= 1 to GetMarkerCount do
    begin
     p:= GetMarker(i);
     PatBlt(DC, p.x - DEFAULT_SPACE, p.y - DEFAULT_SPACE, sm, sm, DSTINVERT);
    end;
 end;
end;

function TDrawObj.HitTest(P: TPoint; Selected: Boolean): Integer;
var
 i: Integer;
 rc: TRect;
begin
 if Selected then
  begin
   for i:= 1 to GetMarkerCount do
    begin
     rc:= GetMarkerRect(i);
      if PtInRect(rc, p) then begin Result:= i; Exit; end;
    end;
  end
 else
  if PtInRect(Position, p) then
   begin
    Result:= -1;
    Exit;
   end;
 Result:= 0;
end;

//*************************************************************************
{ TDrawRect }
constructor TDrawRect.Create(ARect: TRect);
begin
 inherited;
 // Тип фигуры
 FShape:= gfLine;
 // Загрузить шрифт по умолчанию
 FFont:= GetDefaultFont;
 // Выравнивание текста по умолчанию
 FFormatText:= DT_SINGLELINE or DT_LEFT or DT_TOP;
 // Текстовый параметр
 FText:= '';
 // Имя фигуры
 FName:= SelectBaseName(FShape);
 // Округляющие значения для прямоугольника
 FRn:= Point(3 * PT_FYS, 3 * PT_FYS);
 // Количество точек полифигур
 FCountPoints:= 0;
 SetLength(FPoints, 0);
 // Списки свойств
 FFysProp:= TMultiStorageString.Create(DEFAULT_COUNT_PROP, COUNT_FYS_PROP);
 FAddProp:= TMultiStorageString.Create(DEFAULT_COUNT_PROP, COUNT_ADD_PROP);
end;

destructor TDrawRect.Destroy;
begin
 FAddProp.Free;
 FFysProp.Free;
 Finalize(FPoints);
 FPoints:= nil;
 inherited;
end;

procedure TDrawRect.Draw(DC: HDC);
var
 NewPen, OldPen: HPEN;
 NewBrush, OldBrush: HBRUSH;
 OldColorText, OldColorBack: COLORREF;
 OldBkMode: Integer;
begin
 inherited;
 NewPen:= CreatePenIndirect(Pen);
 NewBrush:= CreateBrushIndirect(Brush);

 OldPen:= SelectObject(DC, NewPen);
 OldBrush:= SelectObject(DC, NewBrush);

 case FShape of
  gfRectangle: RectangleA(DC, Position);
  gfLine: LineA(DC, Position);
  gfEllipse: EllipseA(DC, Position);
  gfCircle: CircleA(DC, NormalizeRect(Position));
  gfRoundRectangle: RoundRectangleA(DC, Position, FRn);
  gfPolygon: PolygonA(DC, FPoints);
  gfPolyLine: PolyLineA(DC, FPoints);
  gfBezier: BezierA(DC, FPoints);
  gfText: begin
           OldColorText:= SetTextColor(DC, Pen.lopnColor);
           OldColorBack:= SetBkColor(DC, Brush.lbColor);
            if (Brush.lbStyle = BS_SOLID) or (Brush.lbStyle = BS_HATCHED)
             then OldBkMode:= SetBkMode(DC, OPAQUE)
             else OldBkMode:= SetBkMode(DC, TRANSPARENT);
           TextOutA(DC, Text, NormalizeRect(Position), FFont, FFormatText);
           SetBkMode(DC, OldBkMode);
           SetBkColor(DC, OldColorBack);
           SetTextColor(DC, OldColorText);
          end;
 end;

 SelectObject(DC, OldBrush);
 SelectObject(DC, OldPen);

 DeleteObject(NewBrush);
 DeleteObject(NewPen);
end;

function TDrawRect.GetMarker(MarkerID: Integer): TPoint;
var
 p: TPoint;
begin
 if FShape in [gfPolygon, gfPolyLine, gfBezier] then
  begin
   Result:= FPoints[MarkerID - 1];
   Exit;
  end;

 if (FShape = gfLine) and (MarkerID=2) then MarkerID:= 5
  else
   if (FShape = gfRoundRectangle) and (MarkerID = 9) then
    begin
     p:= NormalizeRect(Position).BottomRight;
     p.x:= p.x - FRn.x div 2;
     p.y:= p.y - FRn.y div 2;
     Result:= p;
     Exit;
    end;
 DoGetMarker(MarkerID);
 Result:= FMarker;
end;

function TDrawRect.GetMarkerCount: Integer;
begin
 DoGetMarkerCount;
  case FShape of
   gfLine: Result:= 2;
   gfRoundRectangle: Result:= FMarkerCount + 1;
   gfPolygon,
   gfPolyLine,
   gfBezier: Result:= Length(FPoints);
   else
    Result:= FMarkerCount;
  end;
end;

function TDrawRect.GetMarkerCursor(MarkerID: Integer): TCursor;
begin
 if (FShape = gfLine) and (MarkerID = 2) then MarkerID:= 5
  else
   if (FShape = gfRoundRectangle) and (MarkerID = 9) then
    begin
     Result:= crSizeAll;
     Exit;
    end;
 DoGetMarkerCursor(MarkerID);
 Result:= FMarkerCursor;;
end;

function TDrawRect.GetMarkerRect(MarkerID: Integer): TRect;
begin
 DoGetMarkerRect(MarkerID);
 Result:= FMarkerRect;
end;

procedure TDrawRect.MoveMarkerTo(MarkerID: Integer; P: TPoint);
var
 rc: TRect;
begin

 if FShape in [gfPolygon, gfPolyLine, gfBezier] then
  begin
   if EqualPoint(FPoints[MarkerID-1], P) then Exit;
   FPoints[MarkerID - 1]:= P;
   RecalcBounds;
   Exit;
  end;

 if (FShape = gfLine) and (MarkerID = 2) then MarkerID:= 5
  else
   if (FShape = gfRoundRectangle) and (MarkerID = 9) then
    begin
     rc:= NormalizeRect(Position);
     if (P.x > rc.Right - 1) then P.x:= rc.Right - 1
      else if (P.x < rc.Left + (rc.Right - rc.Left) div 2) then P.x:= rc.Left + (rc.Right - rc.Left) div 2;
     if (P.y > rc.Bottom - 1) then P.y:= rc.Bottom - 1
      else if (P.y < rc.Top + (rc.Bottom - rc.Top) div 2) then P.y:= rc.Top + (rc.Bottom - rc.Top) div 2;
     FRn.x:= 2 * (rc.Right - P.x);
     FRn.y:= 2 * (rc.Bottom - P.y);
     Exit;
    end;

 inherited;
end;

procedure TDrawRect.MoveTo(NewPosition: TRect);
var
 i: Integer;
 r: TRect;
begin
 if FShape in [gfPolygon, gfPolyLine, gfBezier] then
  begin
   if FCountPoints = 0 then Exit;
   r:= NormalizeRect(Position);
   if EqualRect(r, NewPosition) then Exit;
   for i:= 0 to High(FPoints) do
    begin
     FPoints[i].x:= FPoints[i].x + (NewPosition.Left - r.Left);
     FPoints[i].y:= FPoints[i].y + (NewPosition.Top - r.Top);
    end;
   SetPosition(NewPosition);
  end;
 inherited;
end;

procedure TDrawRect.Serialize(ar: TArchive);
var
 i: Integer;
begin
 inherited;
 if ar.IsStoring then //Save data
  begin
   ar.DataWrite(FPoints);
   ar.DataWrite(FRn);
   ar.DataWrite(Integer(FShape));
   ar.DataWrite(FName);
   ar.DataWrite(FAddProp);
   ar.DataWrite(FFysProp);
  end
 else //Load data
  begin
   ar.DataRead(True);
     if Length(ar.Points) <> 0 then
      begin
       Finalize(FPoints); FPoints:= nil;
       SetLength(FPoints, Length(ar.Points));
       for i:= 0 to High(ar.Points) do FPoints[i]:= ar.Points[i];
       FCountPoints:= Length(FPoints);
      end;
   ar.DataRead(FRn);
   i:= 0;
   ar.DataRead(i); FShape:= TDrawShape(i);
   ar.DataRead(FName);
   ar.DataRead(FAddProp);
   ar.DataRead(FFysProp);
  end;
end;

procedure TDrawRect.RecalcBounds;
var
 r: TRect;
 i: Integer;
begin
 if Length(FPoints) = 0 then Exit;
  r:= Rect(FPoints[0].x, FPoints[0].y, FPoints[0].x, FPoints[0].y);
  for i:= 0 to High(FPoints) do
   begin
    if FPoints[i].x < r.Left then r.Left:= FPoints[i].x;
    if FPoints[i].x > r.Right then r.Right:= FPoints[i].x;
    if FPoints[i].y < r.Top then r.Top:= FPoints[i].y;
    if FPoints[i].y > r.Bottom then r.Bottom:= FPoints[i].y;
   end;
  if EqualRect(r, Position) then Exit;
 SetPosition(r);
end;

procedure TDrawRect.AddPoint(P: TPoint);
begin
 if not (FShape in [gfPolygon, gfPolyLine, gfBezier]) then Exit;
 if Length(FPoints) > MAX_POINTS then Exit;
 SetLength(FPoints, Length(FPoints) + 1);
 FPoints[High(FPoints)]:= P;
 FCountPoints:= Length(FPoints);
 RecalcBounds;
end;

procedure TDrawRect.RemovePoint(Index: Integer);
var
 tp: TDrawPoint;
 i: Integer;
begin
 if not (FShape in [gfPolygon, gfPolyLine, gfBezier]) then Exit;
 if FCountPoints = 1 then Exit;
 SetLength(tp, Length(FPoints) - 1);
  try
   //******************************************
    if Index = 1 then for i:= 1 to High(FPoints) do tp[i-1]:= FPoints[i]
     else if Index = Length(FPoints) then for i:= 0 to High(FPoints) - 1 do tp[i]:= FPoints[i]
      else
       begin
        for i:= 0 to Index - 1 do tp[i]:= FPoints[i];
        for i:= Index to High(FPoints) do tp[i-1]:= FPoints[i];
       end;
   //******************************************
   Finalize(FPoints); FPoints:= nil;
    SetLength(FPoints, Length(tp));
   for i:= 0 to High(tp) do FPoints[i]:= tp[i];
   FCountPoints:= Length(FPoints);
   //******************************************
  finally
   Finalize(tp); tp:= nil;
  end;
 RecalcBounds;
end;

function TDrawRect.PtInFigure(P: TPoint): Boolean;
var
 rgn: HRGN;
 r: TRect;

  function PtInPolyFigure(const PtPoly: array of TPoint; Pt: TPoint): Boolean;
   var rgp: HRGN;
    begin
     rgp:= CreatePolygonRgn(PPoints(@PtPoly)^, High(PtPoly)+1, ALTERNATE);
      Result:= PtInRegion(rgp, Pt.X, Pt.Y);
     DeleteObject(rgp);
    end;

begin
 Result:= False;
 r:= NormalizeRect(Position);
 InflateRect(r, SIZE_MARKER, SIZE_MARKER);
 case FShape of
  gfLine: Result:= PtInLine(Position, P) or (HitTest(P, True) <> 0);
  gfEllipse,
  gfCircle,
  gfRectangle,
  gfText: Result:= PtInRect(r, P);
  gfRoundRectangle:
   begin
    rgn:= CreateRoundRectRgn(r.Left, r.Top, r.Right, r.Bottom, FRn.x, FRn.y);
    Result:= PtInRegion(rgn, P.x, P.y);
    DeleteObject(rgn);
   end;
  gfPolyLine,
  gfPolygon,
  gfBezier: Result:= PtInPolyFigure(FPoints, P) or (HitTest(P, True) <> 0);
 end;
end;

procedure TDrawRect.SetDrawShape(const Value: TDrawShape);
begin
 FShape:= Value;
 Inc(NUMBER_OBJ);
 FName:= SelectBaseName(Value);
  if FText = '' then FText:= FName;
end;

procedure TDrawRect.Assign(Source: TDrawRect);
var
 i: Integer;
begin
 with Self do
  begin
   SetPosition(Source.Position);
   FFormatText:= Source.FFormatText;
   FFont:= Source.Font;
   FPen:= Source.Pen;
   FBrush:= Source.Brush;
   FMarkerCursor:= Source.FMarkerCursor;
   FMarkerRect:= Source.FMarkerRect;
   FMarkerCount:= Source.FMarkerCount;
   FMarker:= Source.FMarker;
   FText:= Source.Text;
   FCountPoints:= Source.CountPoints;
   FRn:= Source.RoundNess;
   FShape:= Source.Shape;
   FName:= Source.NameFigure;
   if Length(Source.Fpoints) <> 0 then
    for i:= 0  to High(Source.FPoints) do
     FPoints[i]:= Source.FPoints[i];
  end;
end;

procedure TDrawRect.SetAddProp(const Value: TMultiStorageString);
begin
 FAddProp := Value;
end;

procedure TDrawRect.SetFysProp(const Value: TMultiStorageString);
begin
 FFysProp := Value;
end;

end.
