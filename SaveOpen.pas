unit SaveOpen;

interface

uses Windows, Classes, SysUtils, Forms, Dialogs, Main;

procedure ZFileSave;
function ZFileOpen: Boolean;

implementation

uses StorageStruct, Archive, CommonConst, Contnrs, DrawObj;

// Открытие файла данных
function ZFileOpen: Boolean;
var
 FFileOpen: TArchive;
      i, j: Integer;
    ci, cf: Integer;
         s: String;
begin
 with FrmMain do
  begin
   if not FileExists(GetCurrentDir + '\' + FFileName) then
    begin
     Result:= False;
     Exit;
    end;
   FFileOpen:= TArchive.Create(GetCurrentDir + '\' + FFileName, fmOpenRead);
   FFileOpen.IsStoring:= False;
    try
     ci:= 0; cf:= 0;
     FFileOpen.DataRead(ci); // Количество компонентов
      if ci <> 0 then
       begin
        Dec(ci); i:= 0;
         repeat // BEGIN ADD COMPONENT
          s:= '';
          FFileOpen.DataRead(s); //Name component
           //BEGIN LIST FIGURE
            FItem:= TObjectList.Create(True);
             FFileOpen.DataRead(cf);
              if cf <> 0 then
               begin
                Dec(cf); j:= 0;
                 //BEGIN READ FIGURE
                 repeat
                  FNewFigure:= TDrawRect.Create(Rect(0,0,0,0));
                   FNewFigure.Serialize(FFileOpen);
                    FItem.Add(FNewFigure);
                  Inc(j);
                 until (cf < j);
                 //END READ FIGURE
               end;
           //END LIST FIGURE
          lstItem.Items.AddObject(s, FItem);
          Inc(i);
         until (ci < i); // END ADD COMPONENT
       end;
      Result:= True; 
    finally
     FFileOpen.Free;
    end;
  end;
end;


// Сохранение данных
procedure ZFileSave;
 var
   FFileSave: TArchive;
        i, j: Integer;
        list: TObjectList;
 begin
  with FrmMain do
   begin
    try
    // Удалить файл
    DeleteFile(GetCurrentDir + '\' + FFileName);
    // Открыть файл
     FFileSave:= TArchive.Create(GetCurrentDir + '\' + FFileName, fmOpenWrite);
     FFileSave.IsStoring:= True;
      try //************** BEGIN ERROR HANDLER *******************
       // Begin file save
       FFileSave.DataWrite(Integer(lstItem.Items.Count));
       if lstItem.Items.Count <> 0 then
        for i:= 0 to lstItem.Items.Count - 1 do
         begin
          // Имя компонента
          FFileSave.DataWrite(lstItem.Items[i]);
          // Данные объекта
          list:= TObjectList(lstItem.Items.Objects[i]);
          FFileSave.DataWrite(Integer(list.Count));
           if list.Count <> 0 then
            for j:= 0 to list.Count - 1 do
             TDrawRect(list.Items[j]).Serialize(FFileSave);
         end;
       // End file save
      finally //************* ERROR HANDLER ***********************
       FFileSave.Free;
      end; //*************** END ERROR HANDLER *******************
    except
     MessageDlg(MSG_NO_SAVE, mtError, [mbOK], HELP_NO_SAVE);
    end;
   end;
 end;

end.
