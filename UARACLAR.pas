unit UARACLAR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxGraphics, dxSkinsCore, dxSkinsDefaultPainters, DBAccess,
  Ora, DB, MemDS, StdCtrls, Buttons, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, Grids, DBGrids, DBCtrls, dxSkinscxPCPainter, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, cxImage, cxDBEdit, ImgList, frxClass,
  frxExportXLS, frxDBSet;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    Panel4: TPanel;
    ColorDialog1: TColorDialog;
    cxLookupComboBox1: TcxLookupComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    Edit4: TEdit;
    OraSession1: TOraSession;
    QPERSONEL_LOOP: TOraQuery;
    QARACLAR: TOraQuery;
    DSARACLAR: TOraDataSource;
    DSPERSONEL_LOOP: TOraDataSource;
    insert_sql: TOraSQL;
    QFOTOLAR: TOraQuery;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BitBtn2: TBitBtn;
    DSFOTOLAR: TOraDataSource;
    cxDBImage1: TcxDBImage;
    cxLookupComboBox2: TcxLookupComboBox;
    DBGrid1: TDBGrid;
    qisimara: TOraQuery;
    dsisimara: TOraDataSource;
    qplakaara: TOraQuery;
    dsplakaara: TOraDataSource;
    cxLookupComboBox3: TcxLookupComboBox;
    BitBtn3: TBitBtn;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    frxXLSExport1: TfrxXLSExport;
    BitBtn4: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure cxLookupComboBox2KeyPress(Sender: TObject; var Key: Char);
    procedure cxLookupComboBox3KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure DSARACLARDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn4Click(Sender: TObject);
  private
    { Private declarations }
  public
  USR,PSW,SRV,KUL,SIF:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
rno:integer;
begin
if (cxLookupComboBox1.Text='')  or (edit3.Text='') then  exit;
insert_sql.Params[0].AsString:=cxLookupComboBox1.EditText;
insert_sql.Params[1].AsString:=Edit1.Text;
insert_sql.Params[2].AsString:=Edit2.Text;
insert_sql.Params[3].AsString:=Edit3.Text;
insert_sql.Params[4].AsString:=Edit4.Text;
insert_sql.Params[5].AsString:=cxLookupComboBox1.EditValue;
insert_sql.Execute;
OraSession1.Commit;
rno:=QARACLAR.RecNo;
QARACLAR.Refresh;
QARACLAR.RecNo:=rno;
cxLookupComboBox1.Text:='';
edit1.Text:='';
edit2.Text:='';
edit3.Text:='';
edit4.Text:='';
qisimara.Refresh;
qplakaara.Refresh;

QARACLAR.Refresh;
QARACLAR.RecNo:=rno;
BitBtn3.Click;

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
QARACLAR.Delete;

end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
QARACLAR.Close;
QARACLAR.Params[0].AsString:=cxLookupComboBox2.EditText;
QARACLAR.Params[1].AsString:=cxLookupComboBox3.Text;
QARACLAR.Open;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
frxReport1.ShowReport();
end;

procedure TForm1.cxLookupComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then  BitBtn3.Click;

end;

procedure TForm1.cxLookupComboBox3KeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then BitBtn3.Click;

end;

procedure TForm1.DSARACLARDataChange(Sender: TObject; Field: TField);
begin

QFOTOLAR.Close;
if QARACLAR.FieldByName('FOTO').AsString='' then  exit;

QFOTOLAR.Params[0].AsString:=QARACLAR.FieldByName('FOTO').AsString;
if copy(QFOTOLAR.Params[0].AsString,1,5)='KADRO' then
begin
  cxDBImage1.Properties.GraphicClassName:='TBitmap';
end else begin
 cxDBImage1.Properties.GraphicClassName:='TJPEGImage';
end;

QFOTOLAR.Open;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TRY
      WinExec(pchar('EVRAKTAKIP.exe'+' '+KUL+' '+SIF),SW_SHOWNORMAL);
      EXCEPT
      EXIT;
      END;
     Application.Terminate;

     Action:=caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

if ParamCount<5 then  Application.Terminate;
USR:=ParamStr(1);
PSW:=ParamStr(2);
SRV:=ParamStr(3);
KUL:=Paramstr(4);
SIF:=Paramstr(5);



OraSession1.Username:= USR;
OraSession1.Password:=  PSW;
OraSession1.Server:=SRV;

 {
OraSession1.Username:= 'DOGAN';
OraSession1.Password:=  '19721904';
OraSession1.Server:='10.42.112.2:1521:ORCL';

  }


OraSession1.Open;




left:=0;
top:=0;

QPERSONEL_LOOP.Open;
QARACLAR.Open;
qisimara.Open;
qplakaara.Open;
QFOTOLAR.Open;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
FORM1:=Nil;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if ((ssCtrl in Shift) and (Key = VK_F10)) then
begin
Key := 0;
if ColorDialog1.Execute then
begin
  showmessage(ColorToString(ColorDialog1.Color));
end;
end

end;

end.
