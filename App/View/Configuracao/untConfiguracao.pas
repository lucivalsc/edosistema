unit untConfiguracao;

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
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Objects,
  FMX.Layouts,
  untBotaoAcao,
  untPadraoBotao,
  untDM,
  Helper.Loading, FMX.ActnList, System.Actions, FMX.TabControl;

type
  TFrameConfiguracao = class(TFramePadrao)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    TextIP: TText;
    Text2: TText;
    Layout4: TLayout;
    Rectangle1: TRectangle;
    edtIP: TEdit;
    Layout5: TLayout;
    Layout6: TLayout;
    TextPorta: TText;
    Text4: TText;
    Layout7: TLayout;
    Rectangle2: TRectangle;
    edtPorta: TEdit;
    Layout8: TLayout;
    Layout9: TLayout;
    TextUsuario: TText;
    Text6: TText;
    Layout10: TLayout;
    Rectangle3: TRectangle;
    edtUsuario: TEdit;
    Layout11: TLayout;
    Layout12: TLayout;
    TextSenha: TText;
    Text8: TText;
    Layout13: TLayout;
    Rectangle4: TRectangle;
    edtSenha: TEdit;
    StyleBook1: TStyleBook;
    FrameBotaoAcao1: TFrameBotaoAcao;
    procedure FrameBotaoAcao1Click(Sender: TObject);
    procedure recVoltarClick(Sender: TObject);
  private
    { Private declarations }
    procedure Listener(const Sender: TObject; const M: TMessage);
    procedure PreencherCampos;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrameConfiguracao: TFrameConfiguracao;

implementation

{$R *.fmx}

constructor TFrameConfiguracao.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TConfiguracao, Listener);
end;

procedure TFrameConfiguracao.Listener(const Sender: TObject; const M: TMessage);
begin
  case (M as TConfiguracao).Action of
    caShow:
      ShowCart;
    caOpen:
      begin
        PreencherCampos;
        ShowOpen;
      end;
    caClose:
      ShowClose;
    caHide:
      ShowHide;
  end;
end;

procedure TFrameConfiguracao.PreencherCampos;
begin
  edtIP.Text := TArquivo.LerINI('Configuracao', 'IP');
  edtPorta.Text := TArquivo.LerINI('Configuracao', 'Porta');
  edtUsuario.Text := TArquivo.LerINI('Configuracao', 'Usuario');
  edtSenha.Text := TArquivo.LerINI('Configuracao', 'Senha');
end;

procedure TFrameConfiguracao.recVoltarClick(Sender: TObject);
begin
  inherited;
  ShowClose;
end;

procedure TFrameConfiguracao.FrameBotaoAcao1Click(Sender: TObject);
begin
  inherited;
  TArquivo.GravarINI('Configuracao', 'IP', edtIP.Text);
  TArquivo.GravarINI('Configuracao', 'Porta', edtPorta.Text);
  TArquivo.GravarINI('Configuracao', 'Usuario', edtUsuario.Text);
  TArquivo.GravarINI('Configuracao', 'Senha', edtSenha.Text);
  DM.AtualizaComponenteAtualizacao;
  ShowClose;
end;

initialization
  FrameConfiguracao := TFrameConfiguracao.Create(nil);


finalization
  FrameConfiguracao.DisposeOf;

end.

