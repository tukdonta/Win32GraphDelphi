program DsgLib;

uses
  Forms, SysUtils,
  Main in 'Main.pas' {FrmMain},
  ScaleData in 'ScaleData.pas',
  DrawGrid in 'DrawGrid.pas',
  DrawObj in 'DrawObj.pas',
  Global in 'Global.pas',
  CADFunction in 'CADFunction.pas',
  Archive in '..\SysIO\Archive.pas',
  Figure in 'Figure.pas',
  Prop in 'Prop.pas' {FrmProp},
  PropVal in 'PropVal.pas' {FrmParam},
  PropText in 'PropText.pas' {FrmPropText},
  CommonConst in 'CommonConst.pas',
  ComponentEdit in 'ComponentEdit.pas' {FrmComponent},
  About in 'About.pas' {FrmAbout},
  StorageStruct in '..\SysIO\StorageStruct.pas',
  SaveOpen in 'SaveOpen.pas',
  CommonFunct in 'CommonFunct.pas';

{$R *.RES}

begin
  Application.Initialize;
   RegisterProgIDShell;
  Application.Title := 'Ёлементы схем';
  Application.HelpFile := 'Edititem.hlp';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmParam, FrmParam);
  Application.CreateForm(TFrmPropText, FrmPropText);
  Application.CreateForm(TFrmProp, FrmProp);
  Application.CreateForm(TFrmComponent, FrmComponent);
    //ќткрытие с командной строки
    if ParamCount >= 1 then
     begin
      try
       FrmMain.mnuFileCloseClick(nil);
        FrmMain.FFileName:= ExtractFileName(ParamStr(1));
         FrmMain.mnuFileOpenClick(nil);
      except
       FrmMain.mnuFileNewClick(nil);
      end;
     end;
  Application.Run;
end.
