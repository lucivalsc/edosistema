unit untPrincipal;

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
  FMX.Layouts,
  FMX.Objects,
  untPadraoBotao,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.ActnList,
  System.Actions,
  FMX.TabControl;

type
  TFramePrincipal1 = class(TFramePadrao)
    Line1: TLine;
    Text1: TText;
    Rectangle1: TRectangle;
    Path1: TPath;
    Line3: TLine;
    Text3: TText;
    Rectangle3: TRectangle;
    Path3: TPath;
    Line2: TLine;
    Text2: TText;
    Rectangle2: TRectangle;
    Path2: TPath;
    Image1: TImage;
    Text4: TText;
    procedure Line3Click(Sender: TObject);
    procedure Line2Click(Sender: TObject);
    procedure Line1Click(Sender: TObject);
  private
    { Private declarations }
    procedure Listener(const Sender: TObject; const M: TMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  FramePrincipal1: TFramePrincipal1;

implementation

{$R *.fmx}
{ TFramePadrao1 }

constructor TFramePrincipal1.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TPrincipal, Listener);
end;

procedure TFramePrincipal1.Line1Click(Sender: TObject);
begin
  TArquivo.AbrirForm(Self, '', 200, TMenuEstoque.Create('', TAcao.caShow), TMenuEstoque.Create('', TAcao.caOpen));
end;

procedure TFramePrincipal1.Line2Click(Sender: TObject);
begin
  TArquivo.AbrirForm(Self, '', 200, TSincronizar.Create('', TAcao.caShow), TSincronizar.Create('', TAcao.caOpen));
end;

procedure TFramePrincipal1.Line3Click(Sender: TObject);
begin
  inherited;
  ShowClose;
  TArquivo.AbrirForm(Self, '', 200, TLogin.Create('', TAcao.caShow), TLogin.Create('', TAcao.caOpen));
end;

procedure TFramePrincipal1.Listener(const Sender: TObject; const M: TMessage);
begin
  inherited;
  case (M as TPrincipal).Action of
    caShow:
      ShowCart;
    caOpen:
      begin
        TextPadrao.Text := TArquivo.LerINI('Usuario', 'UCEMAIL');
        ShowOpen;
      end;
    caClose:
      ShowClose;
    caHide:
      ShowHide;
  end;
end;

initialization
  FramePrincipal1 := TFramePrincipal1.Create(nil);


finalization
  FramePrincipal1.DisposeOf;

end.

