unit untSolicitarEditar;

interface

uses
  FMX.Ani,
  System.Messaging,
  untAcao,
  JSON,
  untDM,

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
  System.Actions,
  FMX.ActnList,
  FMX.TabControl,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Edit,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.DBScope,
  untFramePadrao;

type
  TFrameSolicitarEditar = class(TFramePadrao)
    TextCliente: TText;
    TextImpressao: TText;
    edtQtdeItem: TEdit;
    Button1: TButton;
    Button2: TButton;
    Layout2: TLayout;
    imgAddItem: TImage;
    BindingsList1: TBindingsList;
    BindSourceDB1: TBindSourceDB;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure recPadraoClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtQtdeItemKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure imgAddItemClick(Sender: TObject);
  private
    procedure Listener(const Sender: TObject; const M: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrameSolicitarEditar: TFrameSolicitarEditar;

implementation

{$R *.fmx}

procedure TFrameSolicitarEditar.Button1Click(Sender: TObject);
begin
  inherited;
  if StrToIntDef(edtQtdeItem.Text, 1) > 1 then
    edtQtdeItem.Text := IntToStr(StrToIntDef(edtQtdeItem.Text, 0) - 1);
end;

procedure TFrameSolicitarEditar.Button2Click(Sender: TObject);
begin
  inherited;
  edtQtdeItem.Text := IntToStr(StrToIntDef(edtQtdeItem.Text, 1) + 1);
end;

constructor TFrameSolicitarEditar.Create(AOwner: TComponent);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TSolicitarEditar, Listener);
end;

procedure TFrameSolicitarEditar.edtQtdeItemKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkReturn then
    imgAddItemClick(Sender);
end;

procedure TFrameSolicitarEditar.imgAddItemClick(Sender: TObject);
var
  xSql: String;
begin
  inherited;
  try
    xSql := ' UPDATE SOLICITACAO SET QTDSOLICITADA = ' + QuotedStr(edtQtdeItem.Text) + ' WHERE CODIGOPRODUTO = ' + QuotedStr(DM.fdqSolicitacaoCODIGOPRODUTO.AsString);
    DM.fdcConexao.ExecSQL(xSql);
    ShowClose;
    TMessageManager.DefaultManager.SendMessage(Self, TSolicitarProdutos.Create('', TAcao.caAtualizar))
  except
    on E: Exception do
    begin
      ShowMessage('Não foi possível gravar o produto' + #13 + #10 + E.Message);
    end;
  end;
end;

procedure TFrameSolicitarEditar.Listener(const Sender: TObject; const M: TMessage);
begin
  case (M as TSolicitarEditar).Action of
    caShow:
      begin
        LayoutPadrao.Height := Trunc(Self.Height / 2);
        ShowCart;
      end;
    caOpen:
      begin
        edtQtdeItem.Text := (M as TSolicitarEditar).Text;
        ShowOpen;
      end;
    caClose:
      ShowClose;
    caHide:
      ShowHide;
  end;
end;

procedure TFrameSolicitarEditar.recPadraoClick(Sender: TObject);
begin
  inherited;
  ShowClose;
end;

initialization

FrameSolicitarEditar := TFrameSolicitarEditar.Create(nil);

finalization

FrameSolicitarEditar.DisposeOf;

end.
