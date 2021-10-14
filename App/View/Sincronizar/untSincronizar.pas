unit untSincronizar;

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
  FMX.ActnList,
  System.Actions,
  FMX.TabControl,
  untDM,
  Helper.Loading;

type
  TFrameSincronizar = class(TFramePadrao)
    Line1: TLine;
    Text1: TText;
    Rectangle1: TRectangle;
    Path1: TPath;
    procedure recVoltarClick(Sender: TObject);
    procedure Line1Click(Sender: TObject);
  private
    procedure Listener(const Sender: TObject; const M: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrameSincronizar: TFrameSincronizar;

implementation

{$R *.fmx}

constructor TFrameSincronizar.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TSincronizar, Listener);
end;

procedure TFrameSincronizar.Listener(const Sender: TObject; const M: TMessage);
begin
  case (M as TSincronizar).Action of
    caShow:
      ShowCart;
    caOpen:
      ShowOpen;
    caClose:
      ShowClose;
    caHide:
      ShowHide;
  end;
end;

procedure TFrameSincronizar.recVoltarClick(Sender: TObject);
begin
  ShowClose;
end;

procedure TFrameSincronizar.Line1Click(Sender: TObject);
var
  Inicio: string;
  Erro: string;
begin
  Erro := '';
  if (TArquivo.LerINI('Configuracao', 'IP') = '') or ((TArquivo.LerINI('Configuracao', 'Porta') = '')) then
  begin
    ShowMessage('Preencha todos os campos na tela de configuração.');
    Abort;
  end;
  if DM.TestarConexaoServidor then
  begin
    Inicio := DateTimeToStr(Now);
    InLoading := True;
    TLoading.Show('Sincronizando os dados de produtos', 'Verdana', 'Black', 'White', 'Black');
    TThread.CreateAnonymousThread(
      procedure
      begin
        DM.GetProdutos(Erro);
        if Erro <> '' then
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              InLoading := False;
              TLoading.Hide;
              ShowMessage(Erro);
            end);
        end
        else
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              InLoading := False;
              TLoading.Hide;
              ShowMessage('Produtos -> Início: ' + Inicio + ' - Fim: ' + DateTimeToStr(Now));
            end);
        end;

      end).Start;

  end
  else
    ShowMessage('Não foi possivel acessar o servidor. Verifique sua internet ou os dados de configuração.');

end;

initialization
  FrameSincronizar := TFrameSincronizar.Create(nil);


finalization
  FrameSincronizar.DisposeOf;

end.

