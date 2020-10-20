unit ComponentEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmComponent = class(TForm)
    lblTitle: TLabel;
    edtName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmComponent: TFrmComponent;

implementation

{$R *.DFM}

procedure TFrmComponent.btnHelpClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT, 114);
end;

end.
