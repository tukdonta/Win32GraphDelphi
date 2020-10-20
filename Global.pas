unit Global;

interface

uses Windows, Classes;

const
 //��� ����� ��������
 INI_NAME = 'EDITITEM.INI';
 //���������� ������� �� ���������
 DEFAULT_COUNT_PROP = 0;
 // ���������� ���������� ���������� � ��������
 COUNT_FYS_PROP = 4;
 // ���������� �������������� ���������� � ��������
 COUNT_ADD_PROP = 2;
 // ���������� ����� ���������
 MAX_POINTS = 100;
 // ������� �� ������
 NOT_FIND = -1;
 // �������� �������
 CHAR_OFFSET = 3;
 // ������������
 TextAlignHorizontal: array [0..2] of Cardinal = (DT_LEFT, DT_RIGHT, DT_CENTER);
 TextAlignVertical: array [0..2] of Cardinal = (DT_TOP, DT_VCENTER, DT_BOTTOM);

type
 TDrawShape = (gfLine, gfRectangle, gfRoundRectangle,
               gfCircle, gfEllipse, gfPolyLine, gfPolygon, gfBezier, gfText);

 TTrackerState = (tsNormal, tsSelected, tsActive);
 PPoints = ^TPoints;
 TPoints = array[0..0] of TPoint;
 TDrawPoint = array of TPoint;
 
var
 // �������� ������������ ����
 mDC: HDC;
 // ������� ����� ������������ ����
 mBM: HBITMAP;
 // ��������� ����
 PATH_BEGIN: String;


implementation

end.
