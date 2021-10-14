unit untAcao;

interface

uses
  IniFiles,
  System.Messaging,

{$IFDEF ANDROID}
  Fmx.DialogService,
  System.Permissions,
  Androidapi.Jni.Net,
  idUri,
  Androidapi.Jni.Telephony,
  Androidapi.Jni.Provider,
  Fmx.Platform.Android,
  Fmx.Helpers.Android,
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
  Fmx.VirtualKeyboard,
  Fmx.Platform,
{$ENDIF }
  System.Classes,
  Fmx.Objects,
  System.SysUtils,
  System.Variants,
  System.Generics.Collections,
  System.IOUtils,
  System.UITypes;

type
  TAcao = (caShow, caOpen, caClose, caHide, caNull, caAtualizar, caCodigoBarra);

  TPrincipal = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TLogin = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TConfiguracao = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TSincronizar = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TSolicitarProdutos = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TMenuEstoque = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TInventario = class(TMessage)
  private
    FTexto: string;
    FAction: TAcao;
  public
    constructor Create(ATexto: string; AAction: TAcao);
    property Text: string read FTexto;
    property Action: TAcao read FAction;
  end;

  TArquivo = class
    class procedure GravarINI(Secao, Propriedade, Valor: string);
    class function LerINI(Secao, Propriedade: string): string;
    class procedure AjustarCor(aCor: TAlphaColor = $FF56EFB9);
  private
  public
    ABotaoVoltarPrincipal: TNotifyEvent;
    ListaNotificacao: TList<TNotifyEvent>;
    property BotaoVoltarPrincipal: TNotifyEvent read ABotaoVoltarPrincipal write ABotaoVoltarPrincipal;
    class procedure AbrirForm(AObj: TObject; const AMensagem: string; ASleep: Integer; AMessageShowCart, AMessageShowOpen: TMessage);
  end;

var
  Notificacao: TArquivo;
  InLoading: Boolean;

const
  corPadrao: TAlphaColor = $FF56EFB9;

implementation
{ TArquivo }

class procedure TArquivo.AjustarCor(aCor: TAlphaColor);
begin
{$IFDEF ANDROID}
  CallInUIThreadAndWaitFinishing(
    procedure
    begin
      TAndroidHelper.Activity.getWindow.SetStatusBarColor(aCor);
    end);

  CallInUIThreadAndWaitFinishing(
    procedure
    begin
      TAndroidHelper.Activity.getWindow.SetNavigationBarColor(aCor);
    end);
{$ENDIF}
end;

class procedure TArquivo.AbrirForm(AObj: TObject; const AMensagem: string; ASleep: Integer; AMessageShowCart, AMessageShowOpen: TMessage);
var
  T: TThread;
begin
  T := TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          TMessageManager.DefaultManager.SendMessage(AObj, AMessageShowCart);
        end);

      Sleep(ASleep);
      TThread.Synchronize(nil,
        procedure
        begin
          TMessageManager.DefaultManager.SendMessage(AObj, AMessageShowOpen);
        end);
    end);
  T.OnTerminate := Nil;
  T.Start;
end;

class procedure TArquivo.GravarINI(Secao, Propriedade, Valor: string);
var
  ArquivoINI: TIniFile;
begin
{$IFDEF ANDROID OR IOS}
  ArquivoINI := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'Arquivo.ini'));
{$ENDIF}
{$IFDEF MSWINDOWS}
  ArquivoINI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Arquivo.ini');
{$ENDIF}
  ArquivoINI.WriteString(Secao, Propriedade, Valor);
  ArquivoINI.Free;
end;

class function TArquivo.LerINI(Secao, Propriedade: string): string;
var
  ArquivoINI: TIniFile;
begin
{$IFDEF ANDROID OR IOS}
  ArquivoINI := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'Arquivo.ini'));
{$ENDIF}
{$IFDEF MSWINDOWS}
  ArquivoINI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Arquivo.ini');
{$ENDIF}
  Result := ArquivoINI.ReadString(Secao, Propriedade, '');
  ArquivoINI.Free;
end;

constructor TPrincipal.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

{ TConfiguracao }

constructor TConfiguracao.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

{ TLogin }

constructor TLogin.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

{ TSincronizar }

constructor TSincronizar.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

{ TSolicitarProdutos }

constructor TSolicitarProdutos.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

{ TMenuEstoque }

constructor TMenuEstoque.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

{ TInventario }

constructor TInventario.Create(ATexto: string; AAction: TAcao);
begin
  FTexto := ATexto;
  FAction := AAction;
end;

initialization
  Notificacao := TArquivo.Create;
  Notificacao.ListaNotificacao := TList<TNotifyEvent>.Create;


finalization
  Notificacao.DisposeOf;
  Notificacao.ListaNotificacao.DisposeOf;

end.

