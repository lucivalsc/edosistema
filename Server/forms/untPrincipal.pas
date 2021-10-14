unit untPrincipal;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  uDWAbout,
  uRESTDWBase,
  untServerMethodDataModule,
  uDWJSONObject,
  uDWConsts,
  ServerUtils,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Vcl.Grids,
  Vcl.DBGrids,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  untArquivoINI,
  System.StrUtils,
  Vcl.Menus,
  Vcl.ExtCtrls,
  Vcl.AppEvnts;

type
  TfrmPrincipal = class(TForm)
    RESTServicePooler1: TRESTServicePooler;
    edtPorta: TEdit;
    Label1: TLabel;
    Button1: TButton;
    edtUsuario: TEdit;
    Label2: TLabel;
    edtSenha: TEdit;
    Label3: TLabel;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Fechar1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Status;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.ApplicationEvents1Minimize(Sender: TObject);
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
var
  AuthOPt: TRDWAuthOption;
  AuthOPtParams: TRDWAuthOptionParam;
  AuthOPtBasic: TRDWAuthOptionBasic;
begin
  with RESTServicePooler1 do
  begin
    AuthOPt := TRDWAuthOption.rdwAOBasic;
    AuthOPtParams := TRDWAuthOptionParam.Create;
    AuthOPtBasic := TRDWAuthOptionBasic.Create;

    AuthOPtBasic.Username := edtUsuario.Text;
    AuthOPtBasic.Password := edtSenha.Text;
    AuthOPtParams := AuthOPtBasic;

    AuthenticationOptions.AuthorizationOption := AuthOPt;
    AuthenticationOptions.OptionParams := AuthOPtParams;
    ServicePort := StrToInt(edtPorta.Text);
  end;
  RESTServicePooler1.Active := not RESTServicePooler1.Active;
  Status;
end;

procedure TfrmPrincipal.Fechar1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.FormActivate(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TServerModule;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  Status;
  Caption := 'Servidor - ' + TArquivoINI.GetVersionApp(Application.ExeName);
end;

procedure TfrmPrincipal.Status;
begin
  Button1.Caption := IfThen(RESTServicePooler1.Active, 'Parar servidor', 'Iniciar servidor');
end;

procedure TfrmPrincipal.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

//initialization
//  ReportMemoryLeaksOnShutdown := True;

end.

