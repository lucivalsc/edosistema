unit untMenuEstoque;

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
  FMX.ActnList,
  System.Actions,
  FMX.TabControl,
  FMX.Layouts;

type
  TFrameMenuEstoque = class(TFramePadrao)
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
  FrameMenuEstoque: TFrameMenuEstoque;

implementation

{$R *.fmx}

constructor TFrameMenuEstoque.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TMenuEstoque, Listener);
end;

procedure TFrameMenuEstoque.Line1Click(Sender: TObject);
begin
  TArquivo.AbrirForm(Self, '', 200, TInventario.Create('', TAcao.caShow), TInventario.Create('', TAcao.caOpen));
end;

procedure TFrameMenuEstoque.Listener(const Sender: TObject; const M: TMessage);
begin
  case (M as TMenuEstoque).Action of
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

procedure TFrameMenuEstoque.recVoltarClick(Sender: TObject);
begin
  inherited;
  ShowClose;
end;

initialization
  FrameMenuEstoque := TFrameMenuEstoque.Create(nil);


finalization
  FrameMenuEstoque.DisposeOf;

end.

