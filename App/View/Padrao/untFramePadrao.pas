unit untFramePadrao;

interface

uses
  FMX.Ani,
  System.Messaging,
  untAcao,
  System.Math,

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
  FMX.Layouts,
  FMX.Objects, FMX.ActnList, System.Actions, FMX.TabControl;

type
  TFramePadrao = class(TFrame)
    recPadraoConteudo: TRectangle;
    LayoutPadrao: TLayout;
    recPadrao: TRectangle;
    VertScrollBox1: TVertScrollBox;
    MainLayout1: TLayout;
    TextPadrao: TText;
    recVoltar: TRectangle;
    PathPadraoBotao: TPath;
    ActionList1: TActionList;
    actMudarTab: TChangeTabAction;
    Action1: TAction;
  private
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    // procedure Listener(const Sender: TObject; const M: TMessage);
  public
    // constructor Create(AOwner: TComponent); override;
    procedure ShowCart;
    procedure ShowOpen;
    procedure ShowClose;
    procedure ShowHide;
    procedure Voltar(Sender: TObject);

    // Mudar tab
    procedure MudarTab(ATabItem: TTabItem; Sender: TObject);
    // Tratar tabs
    procedure OcultarTab(ATabControl: TTabControl; ATabItem: TTabItem);
  end;

  // var
  // AFramePadrao: TFramePadrao;

implementation

{$R *.fmx}
{ TFramePadrao }

// constructor TFramePadrao.Create(AOwner: TComponent);
// begin
// inherited;
// TMessageManager.DefaultManager.SubscribeToMessage(TFramePadraoAcao, Listener);
// end;
//
// procedure TFramePadrao.Listener(const Sender: TObject; const M: TMessage);
// begin
// case (M as TFramePadraoAcao).Action of
// caShow:
// ShowCart;
// caOpen:
// ShowOpen;
// caClose:
// ShowClose;
// caHide:
// ShowHide;
// end;
// end;
// initialization
//
// AFramePadrao := TFramePadrao.Create(nil);
//
// finalization
//
// AFramePadrao.DisposeOf;

procedure TFramePadrao.MudarTab(ATabItem: TTabItem; Sender: TObject);
begin
  actMudarTab.Tab := ATabItem;
  actMudarTab.ExecuteTarget(Sender);
end;

procedure TFramePadrao.OcultarTab(ATabControl: TTabControl; ATabItem: TTabItem);
begin
  ATabControl.ActiveTab := ATabItem;
  ATabControl.TabPosition := TTabPosition.None;
end;

procedure TFramePadrao.ShowCart;
begin
  Parent := Application.MainForm;
  Align := TAlignLayout.None;
  Height := Application.MainForm.ClientHeight;
  Width := Application.MainForm.ClientWidth;
  Opacity := 0;
  Position.Y := 0;
  Position.X := (Application.MainForm.ClientWidth + 200);
  BringToFront;
end;

procedure TFramePadrao.ShowOpen;
begin
  Notificacao.ListaNotificacao.Add(Voltar);
  TAnimator.AnimateFloat(Self, 'Position.X', 0, 0.3, TAnimationType.Out, TInterpolationType.Linear);
  TAnimator.AnimateFloat(Self, 'Opacity', 1, 0.5, TAnimationType.Out, TInterpolationType.Linear);
end;

procedure TFramePadrao.ShowClose;
begin
  if Notificacao.ListaNotificacao.Count > 0 then
    Notificacao.ListaNotificacao.Delete(Pred(Notificacao.ListaNotificacao.Count));
  TAnimator.AnimateFloat(Self, 'Opacity', 0, 0.5, TAnimationType.&In, TInterpolationType.Linear);
  TAnimator.AnimateFloat(Self, 'Position.X', (Application.MainForm.ClientHeight + 200), 0.3, TAnimationType.Out, TInterpolationType.Linear);
end;

procedure TFramePadrao.ShowHide;
begin
  Parent := Nil;
end;

procedure TFramePadrao.Voltar(Sender: TObject);
begin
  ShowClose;
end;

end.
