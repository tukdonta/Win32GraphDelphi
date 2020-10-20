unit ScaleData;

interface

uses Windows, SysUtils, Forms;

const
  MX = 50; MY = 50;
  DEFAULT_SIZE_RULER = 3;
  SIZE_SCROLLBAR = 10;
  DEFAULT_SPACE = 3;
  SIZE_MARKER = 4;
  
var
   // ��� �����
   STEP_GRID,
   // ������ ���������� ����� � ���������� �����������
   PT_FYS,
   // ���������� ������ ����� �� ������ �����
   GRID_X, GRID_Y, GRID_WIDTH, GRID_HEIGHT,
   // ������ ������ �����������
   CONTROL_LIST_WIDTH,
   // ������ ������� �����
   WIDTH_BORDER,
   // ��� � ������������ �������
   STEP_RULER,
   // ������ �������
   SIZE_RULER: Integer;

   // ������������� ������ � ����� ����
   RULER_RECT,
   // ������������� � ���������� �����������
   GRID_RECT_CLIENT,
   // ������������� �����
   GRID_RECT: TRect;

procedure DrawScaleData;

implementation

uses Classes;

procedure DrawScaleData;
 begin
  case Screen.Width of
   640: PT_FYS:= 6;
   800: PT_FYS:= 8;
   1024: PT_FYS:= 10;
   1200: PT_FYS:= 12;
    else
     PT_FYS:= 14;
   end;
  WIDTH_BORDER:= PT_FYS div 2; 
  SIZE_RULER:= DEFAULT_SIZE_RULER * PT_FYS;
  STEP_RULER:= 5;
  STEP_GRID:= PT_FYS;
  CONTROL_LIST_WIDTH:= MX * 2 + SIZE_SCROLLBAR + DEFAULT_SPACE;
  GRID_WIDTH:= MX * PT_FYS + SIZE_RULER + DEFAULT_SIZE_RULER;
  GRID_HEIGHT:= MY * PT_FYS + SIZE_RULER + DEFAULT_SIZE_RULER;
 end;

end.
