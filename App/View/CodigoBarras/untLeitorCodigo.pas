unit untLeitorCodigo;

interface

uses
  Fmx.Ani,
  System.Messaging,
  untAcao,

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

  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  Fmx.Types,
  Fmx.Controls,
  Fmx.Forms,
  Fmx.Graphics,
  Fmx.Dialogs,
  Fmx.CodeReader,
  Fmx.Objects,
  Fmx.Controls.Presentation,
  Fmx.StdCtrls,
  Fmx.Android.Permissions,
  Fmx.Layouts;

type
  TfrmLeitorCodigo = class(TForm)
    CodeReader1: TCodeReader;
    AP: TAndroidPermissions;
    recVoltar: TRectangle;
    Path1: TPath;
    Rectangle1: TRectangle;
    Rectangle6: TRectangle;
    Button1: TText;
    procedure FormShow(Sender: TObject);
    procedure CodeReader1CodeReady(aCode: string);
    procedure CodeReader1Start(Sender: TObject);
    procedure CodeReader1Stop(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure recVoltarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Rectangle6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLeitorCodigo: TfrmLeitorCodigo;

implementation

{$R *.fmx}

procedure TfrmLeitorCodigo.CodeReader1Start(Sender: TObject);
begin
  Button1.Text := 'Parar';
end;

procedure TfrmLeitorCodigo.CodeReader1Stop(Sender: TObject);
begin
  Button1.Text := 'Iniciar';
end;

procedure TfrmLeitorCodigo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  frmLeitorCodigo := Nil;
end;

procedure TfrmLeitorCodigo.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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
      else if (Key = vkHardwareBack) then
      begin
        Close;
        Key := 0;
      end;
    end;
  end;
{$ENDIF}
end;

procedure TfrmLeitorCodigo.FormShow(Sender: TObject);
var
  T: TThread;
begin
  T := TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(500);
      TThread.Synchronize(nil,
        procedure
        begin
          try
            Button1.Text := 'Iniciar';
            Rectangle6Click(Sender);
          except
            on E: Exception do


          end;
        end);
    end);
  T.OnTerminate := Nil;
  T.Start;
end;

procedure TfrmLeitorCodigo.Rectangle6Click(Sender: TObject);
begin
  try
    if Button1.Text = 'Iniciar' then
      CodeReader1.Start
    else
      CodeReader1.Stop;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TfrmLeitorCodigo.recVoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmLeitorCodigo.CodeReader1CodeReady(aCode: string);
begin
  if Trim(aCode) <> '' then
  begin
    TMessageManager.DefaultManager.SendMessage(Self, TInventario.Create(aCode, TAcao.caCodigoBarra));
    Close;
  end;
end;

end.

