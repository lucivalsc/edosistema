unit untSplash;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  untAcao,
  untMain;

type
  TfrmSplash = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.fmx}

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  TArquivo.AjustarCor();
end;

procedure TfrmSplash.Image1Resize(Sender: TObject);
begin
  if not (Timer1.Enabled) then
    Timer1.Enabled := True;
end;

procedure TfrmSplash.Timer1Timer(Sender: TObject);
var
  LFrm: TForm;
begin
  Timer1.Enabled := False;
  LFrm := Nil;
  LFrm := TfrmPrincipal.Create(Application);
  LFrm.Show;
  Application.MainForm := LFrm;
  Close;
end;

end.

