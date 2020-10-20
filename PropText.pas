unit PropText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFrmPropText = class(TForm)
    lblTText: TLabel;
    edtText: TEdit;
    grbFont: TGroupBox;
    lblTFont: TLabel;
    lblTDraw: TLabel;
    lblTSize: TLabel;
    lstFont: TListBox;
    lstDraw: TListBox;
    lstSize: TListBox;
    grbAttr: TGroupBox;
    lblTSample: TLabel;
    pnlSample: TPanel;
    lblSample: TLabel;
    lblTVert: TLabel;
    lblTHorz: TLabel;
    lstVert: TListBox;
    lstHorz: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure edtTextChange(Sender: TObject);
    procedure lstFontClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    procedure ViewSample;
  public
    { Public declarations }
  end;

var
  FrmPropText: TFrmPropText;

implementation

{$R *.DFM}

uses Global, Main;

procedure TFrmPropText.FormCreate(Sender: TObject);
var
 i: Integer;
begin
 // Load list font
 lstFont.Items.Assign(Screen.Fonts);
 // Load size font
 i:= 8;
 repeat
  lstSize.Items.Add(IntToStr(i));
  Inc(i, 2);
 until (i = 48);
 lstSize.ItemIndex:= 0;
 lstFont.ItemIndex:= 0;
 lstDraw.ItemIndex:= 0;
 lstVert.ItemIndex:= 0;
 lstHorz.ItemIndex:= 0;
 ViewSample;
end;

procedure TFrmPropText.ViewSample;
var
 s: String;
 fs: TFontStyles;
begin
 if edtText.Text = '' then s:= lstFont.Items[lstFont.ItemIndex] else s:= edtText.Text;
 lblSample.Font.Size:= StrToInt(lstSize.Items[lstSize.ItemIndex]);
  case lstDraw.ItemIndex of
   0: fs:= []; // Normal
   1: fs:= [fsItalic]; // Italic
   2: fs:= [fsBold];
   3: fs:= [fsBold, fsItalic];
  end;
 lblSample.Font.Name:= lstFont.Items[lstFont.ItemIndex]; 
 lblSample.Font.Style:= fs;
 lblSample.Layout:= TTextLayout(lstVert.ItemIndex);
 lblSample.Alignment:= TAlignment(lstHorz.ItemIndex);
 lblSample.Caption:= s;
end;

procedure TFrmPropText.edtTextChange(Sender: TObject);
begin
  ViewSample;
end;

procedure TFrmPropText.lstFontClick(Sender: TObject);
begin
  ViewSample;
end;

procedure TFrmPropText.FormActivate(Sender: TObject);
begin
 ViewSample;
end;

procedure TFrmPropText.btnOKClick(Sender: TObject);
begin
 FrmMain.FDirty:= True;
 FrmMain.ControlSave(True);
end;

procedure TFrmPropText.btnHelpClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT, 106);
end;

end.
