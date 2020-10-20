unit Global;

interface

uses Windows, Classes;

const
 //Имя файла настроек
 INI_NAME = 'EDITITEM.INI';
 //Количество свойств по умолчанию
 DEFAULT_COUNT_PROP = 0;
 // Количество физических параметров в свойстве
 COUNT_FYS_PROP = 4;
 // Количество дополнительных параметров в свойстве
 COUNT_ADD_PROP = 2;
 // Количество точек полифигур
 MAX_POINTS = 100;
 // Элемент не найден
 NOT_FIND = -1;
 // Смещение символа
 CHAR_OFFSET = 3;
 // Выравнивания
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
 // Контекст виртуального окна
 mDC: HDC;
 // Битовая карта виртуального окна
 mBM: HBITMAP;
 // Начальный путь
 PATH_BEGIN: String;


implementation

end.
