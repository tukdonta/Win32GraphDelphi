unit CommonFunct;

interface

uses Windows;
const
 KEY_APP = 'Software\ZANS';

type
 TMemoryStatusInformation = record
  MemoryLoad: String;
  TotalPhys: String;
  AvailPhys: String;
  TotalPage: String;
  AvailPage: String;
  TotalVirtual: String;
  AvailVirtual: String;
 end;

function MemoryStatus: TMemoryStatusInformation;
function IniLoad(Section, Key: String): String;
function IniSave(Section, Key, Value: String): Boolean;
procedure RegisterProgIDShell;

implementation

uses SysUtils, Global, Registry, CommonConst;

procedure RegisterProgIDShell;
 const
  Buffer: array [0..3] of Byte = (0,0,0,0);
 var
  reg: TRegistry;
  s: String;
 begin
  reg:= TRegistry.Create;
   try
    with reg do
     begin
      s:= IniLoad('Path','App');
       if s = '' then s:= GetCurrentDir;
      RootKey:= HKEY_CLASSES_ROOT;
       if not KeyExists(FILE_EXT) then CreateKey(FILE_EXT);
        OpenKey(FILE_EXT, False);
         WriteString('',REG_APP_NAME);
         WriteString('Content Type','application/x-data');
          if not KeyExists('ShellNew') then CreateKey('ShellNew');
           OpenKey('ShellNew', False);
            WriteString('NullFile','');
            WriteBinaryData('Data', Buffer, 4);
           CloseKey;
        CloseKey;
       if not KeyExists(REG_APP_NAME) then CreateKey(REG_APP_NAME);
        OpenKey(REG_APP_NAME, False);
         WriteString('',NEW_FILE_NAME_NO_EXT);
         WriteBinaryData('EditFlags', Buffer, 4);
          OpenKey('Shell', True);
           OpenKey('open', True);
            OpenKey('command', True);
             WriteString('','"' + s + '\DsgLib.exe" "%1"');
            CloseKey;
           CloseKey;
          CloseKey;
          OpenKey('DefaultIcon', True);
           WriteString('',s + 'DsgLib.exe,0');
          CloseKey;
        CloseKey;
      CloseKey;
     end;
   finally
    reg.Free;
   end;
 end;

function IniLoad(Section, Key: String): String;
var
 r: TRegistry;
begin
 r:= TRegistry.Create;
  try
   r.RootKey:= HKEY_LOCAL_MACHINE;
   r.OpenKey(KEY_APP+'\'+Section, True);
    Result:= r.ReadString(Key);
   r.CloseKey;
  finally
   r.Free;
  end;
end;

function IniSave(Section, Key, Value: String): Boolean;
var
 r: TRegistry;
begin
 r:= TRegistry.Create;
  try
   r.RootKey:= HKEY_LOCAL_MACHINE;
    r.OpenKey(KEY_APP+'\'+Section, True);
     r.WriteString(Key, Value); 
    r.CloseKey;
   Result:= True; 
  finally
   r.Free;
  end;
end;

function MemoryStatus: TMemoryStatusInformation;
var
 ms: _MEMORYSTATUS;
 l: LongWord;
begin
 l:= 1024*1024;
 ms.dwLength:= SizeOf(ms);
  GlobalMemoryStatus(ms);
   with Result do
    begin
     MemoryLoad:= Format('Загрузка памяти %d %%',[ms.dwMemoryLoad]);
     TotalPhys:= Format('Всего физ. памяти %u Кб (%u Мб)',[ms.dwTotalPhys div 1024, ms.dwTotalPhys div l]);
     AvailPhys:= Format('Доступно физ. памяти %u Кб (%u Мб)',[ms.dwAvailPhys div 1024, ms.dwAvailPhys div l]);
     TotalPage:= Format('Размер файла подкачки %u Кб (%u Мб)',[ms.dwTotalPageFile div 1024,ms.dwTotalPageFile div l]);
     AvailPage:= Format('Доступно файла подкачки %u Кб (%u Мб)',[ms.dwAvailPageFile div 1024,ms.dwAvailPageFile div l]);
     TotalVirtual:= Format('Всего вирт. памяти %u Кб (%u Мб)',[ms.dwTotalVirtual div 1024,ms.dwTotalVirtual div l]);
     AvailVirtual:= Format('Доступно вирт. памяти %u Кб (%u Мб)',[ms.dwAvailVirtual div 1024,ms.dwAvailVirtual div l]);
    end;
end;

end.
