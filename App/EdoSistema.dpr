program EdoSistema;

uses
  System.StartUpCopy,
  FMX.Forms,
  untMain in 'View\untMain.pas' {frmPrincipal},
  untFramePadrao in 'View\Padrao\untFramePadrao.pas' {FramePadrao: TFrame},
  untAcao in 'Controller\untAcao.pas',
  untPrincipal in 'View\untPrincipal.pas' {FramePrincipal1: TFrame},
  untPadraoBotao in 'View\Padrao\Botao\untPadraoBotao.pas' {FramePadraoBotao: TFrame},
  untBotaoAcao in 'View\Padrao\Botao\untBotaoAcao.pas' {FrameBotaoAcao: TFrame},
  untConfiguracao in 'View\Configuracao\untConfiguracao.pas' {FrameConfiguracao: TFrame},
  untLogin in 'View\Login\untLogin.pas' {FrameLogin: TFrame},
  untDM in 'Model\untDM.pas' {DM: TDataModule},
  Helper.Loading in 'Controller\Helper.Loading.pas',
  untSplash in 'View\untSplash.pas' {frmSplash},
  untSincronizar in 'View\Sincronizar\untSincronizar.pas' {FrameSincronizar: TFrame},
  untLeitorCodigo in 'View\CodigoBarras\untLeitorCodigo.pas' {frmLeitorCodigo},
  untInventario in 'View\Inventario\untInventario.pas' {FrameInventario: TFrame},
  untMenuEstoque in 'View\Estoque\untMenuEstoque.pas' {FrameMenuEstoque: TFrame},
  untAtualizarBD in 'Controller\untAtualizarBD.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.Run;
end.
Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];

Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmSplash, frmSplash);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];

