unit untMain;

interface

uses
  FMX.Ani,
  System.Messaging,
  untAcao,

{$IFDEF ANDROID}
  FMX.DialogService,
  System.Permissions,
  Androidapi.Jni.Net,
  idUri,
  Androidapi.Jni.Telephony,
  Androidapi.Jni.Provider,
  FMX.Platform.Android,
  FMX.Helpers.Android,
  Androidapi.Jni,
  Androidapi.Jni.App,
  Androidapi.NativeWindow,
  Androidapi.JNIBridge,
  Androidapi.NativeActivity,
  Androidapi.Jni.JavaTypes,
  Androidapi.Jni.GraphicsContentViewText,
  Androidapi.Jni.Os,
  Androidapi.Helpers,
  Androidapi.Jni.Widget,
  // Teclado
  FMX.VirtualKeyboard,
  FMX.Platform,
{$ENDIF }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs;

type
  TfrmPrincipal = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TMessageManager.DefaultManager.SendMessage(Self, TPrincipal.Create('', TAcao.caHide));
  TMessageManager.DefaultManager.SendMessage(Self, TLogin.Create('', TAcao.caHide));
  TMessageManager.DefaultManager.SendMessage(Self, TConfiguracao.Create('', TAcao.caHide));
  TMessageManager.DefaultManager.SendMessage(Self, TSincronizar.Create('', TAcao.caHide));
  TMessageManager.DefaultManager.SendMessage(Self, TSolicitarProdutos.Create('', TAcao.caHide));
  TMessageManager.DefaultManager.SendMessage(Self, TMenuEstoque.Create('', TAcao.caHide));
  TMessageManager.DefaultManager.SendMessage(Self, TInventario.Create('', TAcao.caHide));
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  InLoading := False;
  TArquivo.AjustarCor();
end;

procedure TfrmPrincipal.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
{$IFDEF ANDROID}
var
  Keyboard: IFMXVirtualKeyboardService;
{$ENDIF}
begin
  inherited;
{$IFDEF ANDROID OR IOS}
  // Botão voltar físico
  if Key = vkHardwareBack then
  begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, Keyboard) then
    begin
      if TVirtualKeyBoardState.Visible in Keyboard.GetVirtualKeyBoardState then
      begin
        Keyboard.HideVirtualKeyboard;
        Key := 0;
      end
      else if InLoading then
      begin
        Key := 0;
      end
      else
      begin
        if (Notificacao.ListaNotificacao.Count > 0) then
        begin
          Notificacao.BotaoVoltarPrincipal := Notificacao.ListaNotificacao[Pred(Notificacao.ListaNotificacao.Count)];
          Notificacao.BotaoVoltarPrincipal(Sender);
          Key := 0;
        end;
      end;
    end;
  end;
{$ENDIF}
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
var
  T: TThread;
begin
  T := TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(250);
      TThread.Synchronize(nil,
        procedure
        begin
          TMessageManager.DefaultManager.SendMessage(Self, TLogin.Create('', TAcao.caShow));
        end);
      Sleep(400);
      TThread.Synchronize(nil,
        procedure
        begin
          TMessageManager.DefaultManager.SendMessage(Self, TLogin.Create('', TAcao.caOpen));
        end);
    end);
  T.OnTerminate := Nil;
  T.Start;
end;

end.

