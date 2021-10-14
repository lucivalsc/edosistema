unit untInventario;

interface

uses
  FMX.Ani,
  System.Messaging,
  untAcao,
  JSON,

{$IFDEF ANDROID}
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.NativeActivity,
  Androidapi.JNIBridge,
  IdURI,
  Androidapi.JNI.Net,
{$ENDIF}
{$IF defined(IOS)}
  DPF.iOS.BaseControl,
  DPF.iOS.BarCodeReader,
{$ENDIF}
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
  System.Actions,
  FMX.ActnList,
  FMX.TabControl,
  FMX.Objects,
  FMX.Layouts,
  System.Rtti,
  FMX.Grid.Style,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  MultiDetailAppearanceU,
  FMX.ListView,
  FMX.EditBox,
  FMX.SpinBox,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Grid,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  FMX.Bind.Grid,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.Bind.Grid,
  untDM,
  FireDAC.Comp.Client,
  uRestDWDriverFD,
  uDWConstsData,
  uRESTDWPoolerDB,
  uRESTDWServerEvents,
  uDWAbout,
  uRESTDWBase,
  uDWJSONObject,
  uDWConsts,
  uDWDatamodule,
  ServerUtils,
  IdTCPClient,
  untLeitorCodigo,
  Helper.Loading,
  FMX.ListBox;

type
  TFrameInventario = class(TFramePadrao)
    BindingsList1: TBindingsList;
    tbctrlPrincipal: TTabControl;
    tbitemListagem: TTabItem;
    Layout1: TLayout;
    Grid1: TGrid;
    lblTotais: TLabel;
    Layout2: TLayout;
    ToolBar3: TToolBar;
    tbitemEdicao: TTabItem;
    lytPesquisar: TLayout;
    Rectangle1: TRectangle;
    edtPesq: TEdit;
    Layout4: TLayout;
    ToolBar2: TToolBar;
    edtQtdeItem: TEdit;
    Button1: TButton;
    Button2: TButton;
    ListView1: TListView;
    Brush1: TBrushObject;
    Layout3: TLayout;
    recConfiguracao: TRectangle;
    Path1: TPath;
    Rectangle3: TRectangle;
    Path3: TPath;
    Path4: TPath;
    Rectangle2: TRectangle;
    Path2: TPath;
    Path5: TPath;
    imgAddItem: TRectangle;
    Path6: TPath;
    Path7: TPath;
    imgPesquisar: TRectangle;
    Path8: TPath;
    Rectangle6: TRectangle;
    Path9: TPath;
    Rectangle7: TRectangle;
    Path10: TPath;
    BindSourceDB1: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    BindSourceDB2: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB2: TLinkGridToDataSource;
    FloatAnimation1: TFloatAnimation;
    edtLocEstoque: TEdit;
    procedure recVoltarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edtQtdeItemKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edtPesqKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure Rectangle2Click(Sender: TObject);
    procedure recConfiguracaoClick(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
    procedure imgAddItemClick(Sender: TObject);
    procedure imgPesquisarClick(Sender: TObject);
    procedure Rectangle6Click(Sender: TObject);
    procedure Rectangle7Click(Sender: TObject);
    procedure ListView1UpdateObjects(const Sender: TObject; const AItem: TListViewItem);
  private
    procedure Listener(const Sender: TObject; const M: TMessage);
    procedure SearchProduto(Campo, Conteudo: string);
    procedure TotalSolicitado;
    procedure LimparSolicitacao;
    procedure GravarSolicitacao(sFilial, sQtd: string);
    function ProdutoExisteSolicitacao(sFilial, sCodigoProduto: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure EnviarColetas(out Erro: string);
    procedure AtivarSolicitacao;
  end;

var
  FrameInventario: TFrameInventario;

implementation

{$R *.fmx}

procedure TFrameInventario.AtivarSolicitacao;
begin
  DM.fdqInventario.Close;
  DM.fdqInventario.Open();
  TotalSolicitado;
end;

procedure TFrameInventario.Button1Click(Sender: TObject);
begin
  inherited;
  if StrToIntDef(edtQtdeItem.Text, 1) > 1 then
    edtQtdeItem.Text := IntToStr(StrToIntDef(edtQtdeItem.Text, 0) - 1);
end;

procedure TFrameInventario.Button2Click(Sender: TObject);
begin
  inherited;
  edtQtdeItem.Text := IntToStr(StrToIntDef(edtQtdeItem.Text, 1) + 1);
end;

constructor TFrameInventario.Create(AOwner: TComponent);
begin
  inherited;
  OcultarTab(tbctrlPrincipal, tbitemListagem);

  TMessageManager.DefaultManager.SubscribeToMessage(TInventario, Listener);
end;

procedure TFrameInventario.edtPesqKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    imgPesquisarClick(Sender);
end;

procedure TFrameInventario.edtQtdeItemKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    imgAddItemClick(Sender);
end;

procedure TFrameInventario.Listener(const Sender: TObject; const M: TMessage);
begin
  case (M as TInventario).Action of
    caShow:
      begin
        ShowCart;
      end;
    caOpen:
      begin
        ShowOpen;
        AtivarSolicitacao;
        if Notificacao.ListaNotificacao.Count > 0 then
          Notificacao.ListaNotificacao.Delete(Pred(Notificacao.ListaNotificacao.Count));
        Notificacao.ListaNotificacao.Add(recVoltarClick);
      end;
    caClose:
      ShowClose;
    caHide:
      ShowHide;
    caAtualizar:
      begin
        DM.fdqInventario.Close;
        DM.fdqInventario.Open;
        TotalSolicitado;
      end;
    caCodigoBarra:
      begin
        edtPesq.Text := (M as TInventario).Text;
        imgPesquisarClick(Sender);
      end;
  end;
end;

procedure TFrameInventario.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  inherited;
  edtQtdeItem.SetFocus;
end;

procedure TFrameInventario.ListView1UpdateObjects(const Sender: TObject; const AItem: TListViewItem);
var
  Item1: TListItemText;
begin
  Item1 := AItem.View.FindDrawable('TextCodProd') as TListItemText;
  Item1.Text := 'Cod.: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextDescMarc') as TListItemText;
  Item1.Text := 'Marca: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextCodBarr') as TListItemText;
  Item1.Text := 'Cod. Barra: ' + Item1.Text;
  Item1.TextColor := corPadrao;

  Item1 := AItem.View.FindDrawable('TextPreCus') as TListItemText;
  Item1.Text := 'Custo: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextPreVen') as TListItemText;
  Item1.Text := 'Vl. Venda: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextLocEsto') as TListItemText;
  Item1.Text := 'Loc. Esto.: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextUniMed') as TListItemText;
  Item1.Text := 'Un. Medida: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextQtdAtual') as TListItemText;
  Item1.Text := 'Qtd. Atual: ' + Item1.Text;

  Item1 := AItem.View.FindDrawable('TextQtdMax') as TListItemText;
  Item1.Text := 'Qtd. Max.: ' + Item1.Text;
end;

procedure TFrameInventario.EnviarColetas(out Erro: string);
var
  JSONValue: TJSONValue;
  dwParams: TDWParams;
  Resultado: string;
  AFDConexao: TFDConnection;
  AFDQuery, BFDQuery: TFDQuery;
begin
  dwParams := Nil;
  Resultado := '';
  JSONValue := Nil;

  AFDConexao := Nil;
  AFDQuery := Nil;
  BFDQuery := Nil;
  AFDConexao := TFDConnection.Create(Self);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Self);
  AFDQuery.Connection := AFDConexao;

  BFDQuery := TFDQuery.Create(Self);
  BFDQuery.Connection := AFDConexao;
  try

    try
      AFDQuery.Close;
      AFDQuery.SQL.Clear;
      AFDQuery.SQL.Add(' SELECT ');
      AFDQuery.SQL.Add(' NUM_LANC, ');
      AFDQuery.SQL.Add(' DATA, ');
      AFDQuery.SQL.Add(' COD_PROD, ');
      AFDQuery.SQL.Add(' QTDE_ANT, ');
      AFDQuery.SQL.Add(' QTDE_NOVA, ');
      AFDQuery.SQL.Add(' TIPO, ');
      AFDQuery.SQL.Add(' UCLOGIN, ');
      AFDQuery.SQL.Add(' VLR_CUSTO, ');
      AFDQuery.SQL.Add(' VLR_VENDA, ');
      AFDQuery.SQL.Add(' COD_LOJA, ');
      AFDQuery.SQL.Add(' LOC_ESTO ');
      AFDQuery.SQL.Add(' FROM SIGTBPRDHIST ');
      AFDQuery.Open;

      JSONValue := TJSONValue.Create;
      JSONValue.Encoded := False;
      JSONValue.JsonMode := jmPureJSON;
      JSONValue.LoadFromDataset('', AFDQuery, False, JSONValue.JsonMode, 'dd/mm/yyyy hh:mm:ss', ',');

      DM.DWClientEvents1.CreateDWParams('Inventario', dwParams);
      dwParams.ItemsString['Dados'].AsString := JSONValue.ToJSON;
      DM.DWClientEvents1.SendEvent('Inventario', dwParams, Resultado);

      if Resultado = '200' then
      begin
        BFDQuery.Close;
        BFDQuery.SQL.Clear;
        BFDQuery.SQL.Add(' SELECT * FROM SIGTBPRDHIST ');
        BFDQuery.Open;

        if not BFDQuery.IsEmpty then
        begin
          BFDQuery.First;
          BFDQuery.DisableControls;
          while not BFDQuery.Eof do
          begin
            AFDQuery.Close;
            AFDQuery.SQL.Clear;
            AFDQuery.SQL.Add(' UPDATE PRODUTOS SET QTD_ATUAL = :QTD_ATUAL, ');
            AFDQuery.SQL.Add(' LOC_ESTO = :LOC_ESTO ');
            AFDQuery.SQL.Add(' WHERE COD_PROD = :COD_PROD ');
            AFDQuery.ParamByName('QTD_ATUAL').AsFloat := BFDQuery.FieldByName('QTDE_NOVA').AsFloat;
            AFDQuery.ParamByName('LOC_ESTO').AsString := BFDQuery.FieldByName('LOC_ESTO').AsString;
            AFDQuery.ParamByName('COD_PROD').AsString := BFDQuery.FieldByName('COD_PROD').AsString;
            AFDQuery.ExecSQL;

            BFDQuery.Next;
          end;
          BFDQuery.EnableControls;
        end;

        AFDQuery.Close;
        AFDQuery.SQL.Clear;
        AFDQuery.SQL.Add(' DELETE FROM SIGTBPRDHIST ');
        AFDQuery.ExecSQL;
      end
      else
        Erro := Resultado;

    finally
      begin
        dwParams.DisposeOf;
        JSONValue.DisposeOf;
        AFDConexao.DisposeOf;
        AFDQuery.DisposeOf;
      end;
    end;
  except
    on E: Exception do
      Erro := E.Message;
  end;
end;

procedure TFrameInventario.LimparSolicitacao;
begin
  DM.fdcConexao.ExecSQL('DELETE FROM SIGTBPRDHIST');
  DM.fdqInventario.Refresh;
  TotalSolicitado;
end;

function TFrameInventario.ProdutoExisteSolicitacao(sFilial, sCodigoProduto: string): Boolean;
begin
  try
    DM.fdqCons.Close;
    DM.fdqCons.SQL.Clear;
    DM.fdqCons.SQL.Text := 'SELECT COD_LOJA, QTDE_NOVA FROM SIGTBPRDHIST WHERE COD_PROD = ''' + sCodigoProduto + ''' ';
    DM.fdqCons.Open;
    if DM.fdqCons.RecordCount > 0 then
    begin
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Não foi possível consultar o produto' + #13 + #10 + E.Message);
    end;
  end;
end;

procedure TFrameInventario.recConfiguracaoClick(Sender: TObject);
begin
  TotalSolicitado;
  MudarTab(tbitemEdicao, Sender);

end;

procedure TFrameInventario.recVoltarClick(Sender: TObject);
begin
  inherited;
  if tbctrlPrincipal.ActiveTab = tbitemListagem then
    ShowClose;

  if tbctrlPrincipal.ActiveTab = tbitemEdicao then
    MudarTab(tbitemListagem, Sender);

end;

procedure TFrameInventario.TotalSolicitado;
begin
  DM.fdqCons.Close;
  DM.fdqCons.SQL.Text := 'SELECT COUNT(QTDE_NOVA) QTDE, SUM(QTDE_NOVA) AS TOTAL FROM SIGTBPRDHIST ';
  DM.fdqCons.Open;
  if DM.fdqCons.FieldByName('TOTAL').Value > 0 then
    lblTotais.Text := 'Qtde de itens ->  ' + DM.fdqCons.FieldByName('QTDE').AsString + #13 + 'Total de produtos ->  ' + DM.fdqCons.FieldByName('TOTAL').AsString
  else
    lblTotais.Text := '';

end;

procedure TFrameInventario.imgAddItemClick(Sender: TObject);
var
  xSql: string;
  i: Integer;
begin
  if DM.fdqInventario.Active = False then
    DM.fdqInventario.Active := True;
  if ProdutoExisteSolicitacao(TArquivo.LerINI('Usuario', 'COD_LOJA'), DM.fdqProdSolicitacaoCOD_PROD.AsString) = False then
  begin
    GravarSolicitacao(TArquivo.LerINI('Usuario', 'COD_LOJA'), edtQtdeItem.Text);
  end
  else
  begin
    ShowMessage('Produto já cadastrado!');
    exit;
  end;
  edtQtdeItem.Text := '1';
  MudarTab(tbitemListagem, Sender);
  TotalSolicitado;
end;

procedure TFrameInventario.GravarSolicitacao(sFilial, sQtd: string);
begin
  try
    DM.fdqInventario.Insert;
    DM.fdqInventarioQTDE_NOVA.AsString := sQtd;
    DM.fdqInventarioQTDE_ANT.AsString := DM.fdqProdSolicitacaoQTD_ATUAL.AsString;
    DM.fdqInventarioCOD_PROD.Value := DM.fdqProdSolicitacaoCOD_PROD.Value;
    DM.fdqInventarioCOD_LOJA.AsString := sFilial;
    DM.fdqInventarioUCLOGIN.AsString := TArquivo.LerINI('Usuario', 'UCUSERNAME');
    DM.fdqInventarioVLR_CUSTO.Value := DM.fdqProdSolicitacaoPRE_CUS.Value;
    DM.fdqInventarioVLR_VENDA.Value := DM.fdqProdSolicitacaoPRE_VEN.Value;
    DM.fdqInventarioDATA.AsDateTime := Now;
    DM.fdqInventarioDESCRICAO.AsString := DM.fdqProdSolicitacaoDES_PROD.AsString;
    DM.fdqInventarioLOC_ESTO.AsString := edtLocEstoque.Text;
    DM.fdqInventarioTIPO.AsString := 'I';
    DM.fdqInventario.Post;
  except
    on E: Exception do
    begin
      ShowMessage('Não foi possível gravar o produto' + #13 + #10 + E.Message);
    end;
  end;
end;

procedure TFrameInventario.imgPesquisarClick(Sender: TObject);
begin
  SearchProduto('MASTER', edtPesq.Text);
end;

procedure TFrameInventario.SearchProduto(Campo, Conteudo: string);
begin
  try
    DM.fdqProdSolicitacao.Close;
    DM.fdqProdSolicitacao.SQL.Clear;
    DM.fdqProdSolicitacao.SQL.Add(' select * ');
    DM.fdqProdSolicitacao.SQL.Add(' FROM PRODUTOS ');
    DM.fdqProdSolicitacao.SQL.Add(' WHERE ' + Campo + ' like ''%' + Conteudo + '%'' ' + ' order by ' + Campo);
    DM.fdqProdSolicitacao.Open;
    if DM.fdqProdSolicitacao.RecordCount = 0 then
    begin
      TLoading.Hide;
      ShowMessage('Produto não encontrado!');
      edtPesq.SetFocus;

    end;
  except
    on E: Exception do
    begin
      ShowMessage('Não foi possível executar a pesquisa' + #13 + #10 + E.Message);
    end;
  end;
end;

procedure TFrameInventario.Rectangle6Click(Sender: TObject);
begin
  edtPesq.Text := '';
  DM.fdqProdSolicitacao.Close;
end;

procedure TFrameInventario.Rectangle7Click(Sender: TObject);
begin
  if not Assigned(frmLeitorCodigo) then
  begin
    frmLeitorCodigo := TfrmLeitorCodigo.Create(Nil);
    frmLeitorCodigo.Show;
  end;
end;

procedure TFrameInventario.Rectangle2Click(Sender: TObject);
var
  xSql: string;
begin
  inherited;
  MessageDlg('Deseja excluir os itens do inventário?', System.UITypes.TMsgDlgType.mtInformation, [System.UITypes.TMsgDlgBtn.mbYes, System.UITypes.TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: System.UITypes.TModalResult)
    begin
      case AResult of
        mrYes:
          begin
            xSql := 'DELETE FROM SIGTBPRDHIST';
            DM.fdcConexao.ExecSQL(xSql);
            DM.fdqInventario.Refresh;
            TotalSolicitado;
          end;
        mrNo:


      end;
    end);
end;

procedure TFrameInventario.Rectangle3Click(Sender: TObject);
var
  Erro: string;
begin
  Erro := '';

  if DM.fdqInventario.RecordCount = 0 then
  begin
    ShowMessage('Não existe informações para sincronizar!');
    exit;
  end;
  if DM.TestarConexaoServidor then
  begin
    FloatAnimation1.Start;
    InLoading := True;
    TLoading.Show('Sincronizando itens...', 'Verdana', 'Black', 'White', 'Black');
    TThread.CreateAnonymousThread(
      procedure
      begin
        EnviarColetas(Erro);
        if Erro <> '' then
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              InLoading := False;
              TLoading.Hide;
              FloatAnimation1.Stop;
              ShowMessage(Erro);
            end);
        end
        else
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              InLoading := False;
              AtivarSolicitacao;
              TLoading.Hide;
              FloatAnimation1.Stop;
            end);
        end;
      end).Start;
  end
  else
    ShowMessage('Sem acesso ao servidor.');

end;

initialization
  FrameInventario := TFrameInventario.Create(nil);


finalization
  FrameInventario.DisposeOf;

end.

