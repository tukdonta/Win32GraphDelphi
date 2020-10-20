unit PropVal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TFrmParam = class(TForm)
    lblParam: TLabel;
    lblNum: TLabel;
    lblValue: TLabel;
    lblTag: TLabel;
    edtParam: TEdit;
    edtValue: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    edtNum: TEdit;
    edtTag: TRichEdit;
    btnSyntax: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    FAddList: Boolean;
  public
    { Public declarations }
  end;

var
  FrmParam: TFrmParam;

implementation

{$R *.DFM}
uses Archive, Global, Prop, Main;

procedure TFrmParam.FormActivate(Sender: TObject);
begin
 FAddList:= FrmProp.FSelectList;
end;

procedure TFrmParam.btnOKClick(Sender: TObject);
begin
 FrmMain.FDirty:= True;
 FrmMain.ControlSave(True);
end;

procedure TFrmParam.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 107);
end;

end.
