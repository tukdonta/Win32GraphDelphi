unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmAbout = class(TForm)
    lblTitle: TLabel;
    lblOrg: TLabel;
    lblDevelopment: TLabel;
    btnOK: TButton;
    lblMail: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAbout: TFrmAbout;

implementation

{$R *.DFM}
uses CommonFunct;

procedure TFrmAbout.FormCreate(Sender: TObject);
var
 msi: TMemoryStatusInformation;
begin
 msi:= MemoryStatus;
  Label2.Caption:= msi.MemoryLoad;
  Label3.Caption:= msi.TotalPhys;
  Label4.Caption:= msi.AvailPhys;
  Label5.Caption:= msi.TotalPage;
  Label6.Caption:= msi.AvailPage;
  Label7.Caption:= msi.TotalVirtual;
  Label8.Caption:= msi.AvailVirtual;
end;

end.
