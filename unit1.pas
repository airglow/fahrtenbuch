unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Calendar, EditBtn, Grids, ComCtrls, Menus, math;

type

  { TfMain }

  TfMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    dedate: TDateEdit;
    ekmStart: TEdit;
    eliter: TEdit;
    eliterprice: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lMin: TLabel;
    lmedian2: TLabel;
    lMax: TLabel;
    lpricekm: TLabel;
    lSumKm1: TLabel;
    lSumKm2: TLabel;
    lSumKm3: TLabel;
    lSumKm4: TLabel;
    lSumKm5: TLabel;
    lSumKm6: TLabel;
    lSumKm7: TLabel;
    lSumLiter: TLabel;
    lSumKm: TLabel;
    lSumPrice: TLabel;
    lmedian: TLabel;
    MainMenu1: TMainMenu;
    MenuItem10: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    sgOverview: TStringGrid;
    TabSheet1: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure dedateChange(Sender: TObject);
    procedure eliterpriceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure sgOverviewKeyPress(Sender: TObject; var Key: char);
    procedure sgOverviewKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
  private

    changeddata : boolean ;
    mtachostand : double;
    function getTachostand: double;
    procedure setTachostand(const AValue: double);
    procedure updateGUI;
    { private declarations }
  public
    { public declarations }

  property
    tachostand : double read getTachostand write setTachostand;
  end; 

var
  fMain: TfMain;


implementation

{$R *.lfm}

{ TfMain }

function strtofloat2(s : string) : double;
begin
  if trim(s) = '' then
    result := 0.0
  else
    result := strtofloat(s);
end;

procedure TfMain.Button1Click(Sender: TObject);
begin
  sgOverview.InsertColRow(false,1);
  sgOverview.Cells[1,1] := ekmStart.text;
  sgOverview.Cells[0,1] := DateToStr(dedate.Date);
  if sgOverview.RowCount = 2 then begin
    sgOverview.Cells[2,1] := floattostr(strtofloat2(sgOverview.Cells[1,1]) - tachostand);
  end
  else
    sgOverview.Cells[2,1] := floattostr(strtofloat2(sgOverview.Cells[1,1]) - strtofloat2(sgOverview.Cells[1,2]));

  //
  sgOverview.Cells[3,1] := floattostrf(strtofloat(eliter.text), ffNumber ,20, 2); ;
  sgOverview.Cells[4,1] := floattostrf(strtofloat(eliterprice.text), ffNumber ,20, 2); ;

  sgOverview.Cells[5,1] := FloatToStrF(strtofloat2(eliterprice.text) / strtofloat2(sgOverview.Cells[2,1]), ffNumber ,20, 2);
  sgOverview.Cells[6,1] := floattostrf(strtofloat2(eliterprice.text) / strtofloat2(eliter.text), ffNumber ,20, 2);
  sgOverview.Cells[7,1] := floattostrf(strtofloat2(eliter.text) / strtofloat2(sgOverview.Cells[2,1]) * 100.0, ffNumber ,20, 2);
  //sgOverview.Cells[1,sgOverview.RowCount-1] := ekmStart.text;
  changeddata := true;
  //sgOverview.SaveToFile('/home/raphael/Fahrtenbuch.fb');
  updateGUI;
end;

procedure TfMain.Button2Click(Sender: TObject);
var fn : string;
begin
  with TSaveDialog.Create(self) do begin
    Filter := 'Fahrtenbuch|*.fb';
    if not execute then
      exit;

    sgOverview.SaveToFile(FileName);
    fn := Filename;
    changeddata:= false;
  end;
  //showmessage(fn);
end;

procedure TfMain.Button3Click(Sender: TObject);
begin
  with TFileDialog.Create(self) do begin
    Filter := 'Fahrtenbuch|*.fb';
    if not execute then
      exit;

    sgOverview.LoadFromFile(FileName);
  end;
  updateGUI;
end;

procedure TfMain.dedateChange(Sender: TObject);
begin

end;

procedure TfMain.eliterpriceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
    button1.click;
end;

procedure TfMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if changeddata then begin
    if MessageDlg('Schliessen', 'Es wurden Aenderungen am Fahrtenbuch vorgenommen, sollen diese gespeichert werden?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      Button2.click;

  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
var s : string ;
begin
  tachostand:=0.0;
  if FileExists('config.cnf') then begin
    with Tstringlist.Create do begin
        LoadFromFile('config.cnf');
        tachostand := strtofloat(Strings[0]);
    end;
  end;
  sgOverview.Cells[0,0] := 'Datum';
  sgOverview.Cells[1,0] := 'Tachostand';
  sgOverview.Cells[2,0] := 'Gefahrene Km';
  sgOverview.Cells[3,0] := 'Getankte Liter';
  sgOverview.Cells[4,0] := 'Preis';
  sgOverview.Cells[5,0] := 'Preis pro Km';
  sgOverview.Cells[6,0] := 'Preis pro Liter';
  sgOverview.Cells[7,0] := 'Verbrauch';
  sgOverview.SaveOptions:= [soDesign, soPosition, soContent, soAttributes];

  dedate.date := now;
  updateGUI;
  //ListView1.;
end;

procedure TfMain.MenuItem10Click(Sender: TObject);
begin
  close;
end;

procedure TfMain.MenuItem1Click(Sender: TObject);
begin

end;

procedure TfMain.MenuItem2Click(Sender: TObject);
begin
  button2.click;
end;

procedure TfMain.MenuItem4Click(Sender: TObject);
begin
  button3.click;
end;

procedure TfMain.MenuItem6Click(Sender: TObject);
begin
  button2.click;
end;

procedure TfMain.Panel1Click(Sender: TObject);
begin

end;

procedure TfMain.Panel2Click(Sender: TObject);
begin

end;

procedure TfMain.sgOverviewKeyPress(Sender: TObject; var Key: char);
begin
end;

procedure TfMain.sgOverviewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
end;



procedure TfMain.updateGUI;
var sumLiter, sumPrice, km, sumKm, minVerbrauch, maxVerbrauch : double;
    i : integer;
begin
  sumLiter := 0.0;
  sumPrice := 0.0;
  sumKm := 0.0;
  km := 0.0;
  minVerbrauch := 100.0;
  maxVerbrauch := 0.0;
  for i := 1 to sgOverview.RowCount-1 do begin
      km := strtofloat2(sgOverview.Cells[2,i]);
      sumKm := sumKm + km;
      sumLiter := sumLiter + strtofloat2(sgOverview.Cells[3,i]);
      sumPrice := sumPrice + strtofloat2(sgOverview.Cells[4,i]);
      maxVerbrauch := max(maxVerbrauch, strtofloat2(sgOverview.Cells[7,i]));
      minVerbrauch := min(minVerbrauch, strtofloat2(sgOverview.Cells[7,i]));
  end;

  lSumLiter.Caption := FloatToStrF(sumLiter, ffNumber ,20, 2);
  lSumKm.Caption := FloatToStrF(sumKm, ffNumber ,20, 2);
  lSumPrice.Caption := FloatToStrF(sumPrice, ffNumber ,20, 2);
  lmedian.Caption := FloatToStrF((sumLiter / sumKm) * 100.0, ffNumber ,20, 2);
  lpricekm.Caption := FloatToStrF(sumPrice / sumKm, ffNumber ,20, 2);
  lMin.Caption:= FloatToStrF(minVerbrauch, ffNumber ,20, 2);
  lMax.Caption:= FloatToStrF(maxVerbrauch, ffNumber ,20, 2);
end;

function TfMain.getTachostand: double;
begin
  result := mtachostand;
end;

procedure TfMain.setTachostand(const AValue: double);
begin
  mtachostand:=AValue;
  label2.caption := FloatToStrF(mtachostand, ffNumber ,20, 2);
end;

end.

