unit Archive;

interface

uses Classes, SysUtils, Windows;
 type
  TStoragePoint = array of TPoint;

  TArchive = class(TObject)
  private
    FStoring: Boolean;
    FHandle: LongInt;
    FError: Integer;
    FPoint: TStoragePoint;
    FPosition: LongInt;
    function GetError: Boolean;
    procedure SetPosition(const Value: LongInt);
    function GetPosition: LongInt;
    function GetFileSize: LongInt;
  public
    constructor Create(FileName: String; Mode: LongWord);
    destructor Destroy; override;
    property IsStoring: Boolean read FStoring write FStoring default False;
    property IsError: Boolean read GetError default False;
    property Points: TStoragePoint read FPoint;
    property Position: LongInt read GetPosition write SetPosition;
    property Size: LongInt read GetFileSize;
    function DataWrite(Data: LongInt): Boolean; overload;
    function DataWrite(Data: Double): Boolean; overload;
    function DataWrite(Data: TPoint): Boolean; overload;
    function DataWrite(Data: TRect): Boolean; overload;
    function DataWrite(Data: String): Boolean; overload;
    function DataWrite(Data: LOGBRUSH): Boolean; overload;
    function DataWrite(Data: LOGPEN): Boolean; overload;
    function DataWrite(Data: array of TPoint): Boolean; overload;

    function DataRead(var Data: LongInt): Boolean; overload;
    function DataRead(var Data: Double): Boolean; overload;
    function DataRead(var Data: TPoint): Boolean; overload;
    function DataRead(var Data: TRect): Boolean; overload;
    function DataRead(var Data: String): Boolean; overload;
    function DataRead(var Data: LOGBRUSH): Boolean; overload;
    function DataRead(var Data: LOGPEN): Boolean; overload;
    function DataRead(Data: Boolean): Boolean; overload;
  end;

implementation

{ TArchive }
constructor TArchive.Create(FileName: String; Mode: LongWord);
begin
 if not FileExists(FileName) then
  FHandle:= FileCreate(FileName)
 else
  FHandle:= FileOpen(FileName, Mode);
 FError:= FHandle;
 SetLength(FPoint, 0);
end;

function TArchive.DataRead(var Data: TPoint): Boolean;
var
 p: TPoint;
begin
 Result:= FileRead(FHandle, p, SizeOf(p)) <> 0;
 Data:= P;
end;

function TArchive.DataRead(var Data: TRect): Boolean;
var
 RD: TRect;
begin
 Result:= FileRead(FHandle, RD, SizeOf(RD)) <> 0;
 Data:= RD;
end;

function TArchive.DataRead(var Data: Integer): Boolean;
begin
 Result:= FileRead(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataRead(var Data: Double): Boolean;
begin
 Result:= FileRead(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataRead(var Data: LOGPEN): Boolean;
var
 lp: LOGPEN;
begin
 Result:= FileRead(FHandle, lp, SizeOf(lp)) <> 0;
 Data:= lp;
end;

function TArchive.DataRead(Data: Boolean): Boolean;
var
 i, j: Integer;
 p: TPoint;
begin
 Result:= FileRead(FHandle, i, SizeOf(i)) <> 0;
 if Result then
  begin
   SetLength(FPoint, i);
    for j:= 0 to i - 1 do
     begin
      Result:= Result and (FileRead(FHandle, p, SizeOf(p)) <> 0);
      if not Result then
       begin
        Finalize(FPoint); FPoint:= nil;
        Break;
       end;
      FPoint[j]:= p;
     end;
  end;
end;

function TArchive.DataRead(var Data: String): Boolean;
var
 i, j: Word;
 ch: Char;
 s: String;
begin
 s:= '';
 Result:= FileRead(FHandle, i, SizeOf(i)) <> 0;
  if Result then
   for j:= 1 to i do
    begin
     Result:= Result and (FileRead(FHandle, ch, SizeOf(ch)) <> 0);
     if not Result then Break;
     s:= s + ch;
    end;
   Data:= s;
end;

function TArchive.DataRead(var Data: LOGBRUSH): Boolean;
var
 lb: LOGBRUSH;
begin
 Result:= FileRead(FHandle, lb, SizeOf(lb)) <> 0;
 Data:= lb;
end;

function TArchive.DataWrite(Data: TPoint): Boolean;
begin
 Result:= FileWrite(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataWrite(Data: TRect): Boolean;
begin
 Result:= FileWrite(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataWrite(Data: Integer): Boolean;
begin
 Result:= FileWrite(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataWrite(Data: Double): Boolean;
begin
 Result:= FileWrite(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataWrite(Data: LOGPEN): Boolean;
begin
 Result:= FileWrite(FHandle, Data, SizeOf(Data)) <> 0;
end;

function TArchive.DataWrite(Data: array of TPoint): Boolean;
var
 i: Integer;
 p: TPoint;
begin
 i:= Length(Data);
 Result:= FileWrite(FHandle, i, SizeOf(i)) <> 0;
  if Result then
    for i:= 0 to High(Data) do
     if Result then
      begin
       p:= Data[i];
       Result:= Result and (FileWrite(FHandle, p, SizeOf(p))<>0)
      end
     else
      Break;
end;

function TArchive.DataWrite(Data: String): Boolean;
var
 i: Word;
 ch: Char;
begin
 i:= Length(Data);
 Result:= FileWrite(FHandle, i, SizeOf(i)) <> 0;
  if Result then
    for i:= 1 to Length(Data) do
     if Result then
      begin
       ch:= Data[i];
       Result:= Result and (FileWrite(FHandle, ch, SizeOf(ch))<>0)
      end
     else
      Break;
end;

function TArchive.DataWrite(Data: LOGBRUSH): Boolean;
begin
 Result:= FileWrite(FHandle, Data, SizeOf(Data)) <> 0;
end;

destructor TArchive.Destroy;
begin
 Finalize(FPoint);
 FPoint:= nil;
 FileClose(FHandle);
 inherited;
end;

function TArchive.GetError: Boolean;
begin
 Result:= FError = -1;
end;

function TArchive.GetFileSize: LongInt;
var
 currPos: LongInt;
begin
 currPos:= FileSeek(FHandle, 0, 0);
 FileSeek(FHandle, 0, 0);
 Result:= FileSeek(FHandle, 0, 2);
 FileSeek(FHandle, currPos, 0);
end;

function TArchive.GetPosition: LongInt;
begin
 Result:= FileSeek(FHandle, 0, 1);
end;

procedure TArchive.SetPosition(const Value: LongInt);
begin
 FPosition:= FileSeek(FHandle, Value, 0);
end;

end.
