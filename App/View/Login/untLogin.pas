unit untLogin;

interface

uses
  FMX.Ani,
  System.Messaging,
  untAcao,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  untFramePadrao,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Edit,
  untBotaoAcao,
  untDM,
  FMX.ActnList,
  System.Actions,
  FMX.TabControl;

type
  TFrameLogin = class(TFramePadrao)
    Layout1: TLayout;
    Text2: TText;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    Text3: TText;
    FrameBotaoAcao1: TFrameBotaoAcao;
    StyleBook1: TStyleBook;
    Line1: TLine;
    Line2: TLine;
    FrameBotaoAcao2: TFrameBotaoAcao;
    Image1: TImage;
    recConfiguracao: TRectangle;
    Path1: TPath;
    procedure FrameBotaoAcao1Click(Sender: TObject);
    procedure recConfiguracaoClick(Sender: TObject);
    procedure FrameBotaoAcao2Click(Sender: TObject);
  private
    procedure Listener(const Sender: TObject; const M: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrameLogin: TFrameLogin;

implementation

{$R *.fmx}

constructor TFrameLogin.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TLogin, Listener);
end;

procedure TFrameLogin.FrameBotaoAcao1Click(Sender: TObject);
begin
  if DM.UsuarioLiberado(edtUsuario.Text, edtSenha.Text) then
  begin
    TArquivo.AbrirForm(Self, '', 250, TPrincipal.Create('', TAcao.caShow), TPrincipal.Create('', TAcao.caOpen));
    ShowClose;
  end;
end;

procedure TFrameLogin.FrameBotaoAcao2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrameLogin.Listener(const Sender: TObject; const M: TMessage);
begin
  case (M as TLogin).Action of
    caShow:
      begin
        edtUsuario.Text := TArquivo.LerINI('Usuario', 'UCLOGIN');
        edtSenha.Text := TArquivo.LerINI('Usuario', 'UCPASSWORD');
        ShowCart;
      end;
    caOpen:
      begin
        ShowOpen;
        if Notificacao.ListaNotificacao.Count > 0 then
          Notificacao.ListaNotificacao.Delete(Pred(Notificacao.ListaNotificacao.Count));
      end;
    caClose:
      ShowClose;
    caHide:
      ShowHide;
  end;
end;

procedure TFrameLogin.recConfiguracaoClick(Sender: TObject);
begin
  TArquivo.AbrirForm(Self, '', 200, TConfiguracao.Create('', TAcao.caShow), TConfiguracao.Create('', TAcao.caOpen));
end;

initialization
  FrameLogin := TFrameLogin.Create(nil);


finalization
  FrameLogin.DisposeOf;

end.

