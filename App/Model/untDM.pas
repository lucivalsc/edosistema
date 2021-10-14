unit untDM;

interface

uses
  JSON,
  Fmx.Ani,
  System.Messaging,
  untAcao,
  Fmx.Dialogs,
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
  System.IOUtils,
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef,
  FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI,
  FireDAC.Phys.SQLite,
  Web.HTTPApp;

type
  TDM = class(TDataModule)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    DWClientEvents1: TDWClientEvents;
    RESTClientPooler1: TRESTClientPooler;
    RESTDWClientSQL1: TRESTDWClientSQL;
    fdcConexao: TFDConnection;
    fdqInventario: TFDQuery;
    fdqCons: TFDQuery;
    fdqProdSolicitacao: TFDQuery;
    fdqFilial: TFDQuery;
    fdqFilialCODIGOFILIAL: TStringField;
    fdqFilialNOME: TStringField;
    fdqFilialFANTASIA: TStringField;
    fdqFilialCNPJ: TStringField;
    fdqFilialINSCRICAO: TStringField;
    fdqFilialENDERECO: TStringField;
    fdqFilialCEP: TStringField;
    fdqFilialCIDADE: TStringField;
    fdqFilialBAIRRO: TStringField;
    fdqFilialESTADO: TStringField;
    fdqFilialTELEFONE: TStringField;
    fdqFilialCODIGOMUNICIPIO: TStringField;
    fdqFilialNUMERO: TStringField;
    fdqFilialREFERENCIA: TStringField;
    fdqFilialFAX: TStringField;
    fdqFilialEMAIL: TStringField;
    fdqFilialSITE: TStringField;
    fdqFilialLOGO: TBlobField;
    fdqFilialCNAE: TStringField;
    fdqEmpresa: TFDQuery;
    fdqEmpresaCOD_EMPRESA: TIntegerField;
    fdqEmpresaRAZAO_SOCIAL: TStringField;
    fdqEmpresaCNPJ_CPF: TStringField;
    fdqEmpresaFANTASIA: TStringField;
    fdqEmpresaCONTADOR: TStringField;
    fdqEmpresaDATA_ADAPTADOR: TDateField;
    fdqEmpresaCOD_CNAE: TIntegerField;
    fdqEmpresaVERSAO: TStringField;
    fdqEmpresaATUALIZADO_ECF: TStringField;
    fdqEmpresaESTRUTURA_01: TStringField;
    fdqEmpresaSITUACAO: TStringField;
    fdqEmpresaCHAVE: TStringField;
    fdqEmpresaDATA_FECHAMENTO_DIARIO: TDateField;
    fdqEmpresaCLASS_FISCAL: TStringField;
    fdqEmpresaADAPTADOR: TStringField;
    fdqEmpresaDATA_BACKUP: TDateField;
    fdqEmpresaAJUSTA_VERSAO: TStringField;
    fdqEmpresaDATA_MOVIMENTO: TDateField;
    fdqEmpresaMENSAGEM_1: TStringField;
    fdqEmpresaMENSAGEM_2: TStringField;
    fdqEmpresaMENSAGEM_3: TStringField;
    fdqEmpresaMENSAGEM_4: TStringField;
    fdqEmpresaENVIA_XML: TStringField;
    fdqEmpresaMES_ANO_SPED: TStringField;
    fdqEmpresaESTRUTURA_02: TStringField;
    fdqEmpresaESTRUTURA_03: TStringField;
    fdqEmpresaESTRUTURA_04: TStringField;
    fdqEmpresaESTRUTURA_05: TStringField;
    fdqEmpresaESTRUTURA_06: TStringField;
    fdqEmpresaESTRUTURA_07: TStringField;
    fdqEmpresaESTRUTURA_08: TStringField;
    fdqEmpresaESTRUTURA_09: TStringField;
    fdqEmpresaDATA_CONSULTA: TDateField;
    fdqEmpresaDATA_NOTICIA: TDateField;
    fdqEmpresaLIBERA_ACESSO: TStringField;
    fdqEmpresaSTATUS_EXPORTA: TSmallintField;
    fdqEmpresaULTNSUC: TStringField;
    fdqProdSolicitacaoCOD_PROD: TStringField;
    fdqProdSolicitacaoCOD_ORG: TStringField;
    fdqProdSolicitacaoPRE_CUS: TFloatField;
    fdqProdSolicitacaoPRE_VEN: TFloatField;
    fdqProdSolicitacaoCOD_GRP: TStringField;
    fdqProdSolicitacaoDES_GRP: TStringField;
    fdqProdSolicitacaoDES_PROD: TStringField;
    fdqProdSolicitacaoPER_DESC: TFloatField;
    fdqProdSolicitacaoFLG_TIPO: TStringField;
    fdqProdSolicitacaoCOD_BARR: TStringField;
    fdqProdSolicitacaoNCM: TStringField;
    fdqProdSolicitacaoCOD_GENERO: TIntegerField;
    fdqProdSolicitacaoUNI_MED: TStringField;
    fdqProdSolicitacaoAPLICA: TStringField;
    fdqProdSolicitacaoDES_MARC: TStringField;
    fdqProdSolicitacaoQTD_ATUAL: TIntegerField;
    fdqProdSolicitacaoQTD_MAX: TIntegerField;
    fdqProdSolicitacaoLOC_ESTO: TStringField;
    fdqProdSolicitacaoNOM_LOJA: TStringField;
    fdqProdSolicitacaoDATA_ENT: TDateTimeField;
    fdqProdSolicitacaoPRE_DESC: TFloatField;
    fdqProdSolicitacaoDATA_ALT: TDateTimeField;
    fdqProdSolicitacaoMASTER: TStringField;
    fdqInventarioNUM_LANC: TFDAutoIncField;
    fdqInventarioDATA: TDateTimeField;
    fdqInventarioCOD_PROD: TStringField;
    fdqInventarioQTDE_ANT: TIntegerField;
    fdqInventarioQTDE_NOVA: TIntegerField;
    fdqInventarioTIPO: TStringField;
    fdqInventarioUCLOGIN: TStringField;
    fdqInventarioVLR_CUSTO: TFloatField;
    fdqInventarioVLR_VENDA: TFloatField;
    fdqInventarioCOD_LOJA: TIntegerField;
    fdqInventarioDESCRICAO: TStringField;
    fdqInventarioLOC_ESTO: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    function ExisteCampo(Tabela, Coluna: string): Boolean;
    procedure ExecutarAlteracao(aSQL: string);
    procedure AtualizarBanco;
    procedure AtualizaComponenteAtualizacao;
    // Validar servidor
    function TestarConexaoServidor: Boolean;
    procedure ConectarBanco(Conexao: TFDConnection);
    procedure AtualizarBaseLocal(ATabela: string);
    function GerarSQLInsert(ATabela: string; RestSQL: TRESTDWClientSQL): string;
    function RetornarDados(aSQL: string; ADataIni, ADataFim: TDateTime): string;

    // Login
    function UsuarioLiberado(AUsuario, ASenha: string): Boolean;
    function EnviarDados(ATabela, ACampo, AParametro: string): Boolean;

    // Novas funções e procedimentos
    function ListarSQL(ATabela: string): string;
    function Listar(TextoPesquisar, ATabela, ACampo: string): string;
    procedure ExcluirItem(ATabela, AColuna: string; ACodigo: Integer);
    function ListarItensMemoria(ADados: TFDMemTable): string;
    procedure GetProdutos(out Erro: string);
  end;

var
  DM: TDM;

implementation

uses
  untAtualizarBD;

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

function TDM.Listar(TextoPesquisar, ATabela, ACampo: string): string;
var
  JSONValue: TJSONValue;
  AFDConexao: TFDConnection;
  AFDQuery: TFDQuery;
begin
  Result := '';
  AFDConexao := Nil;
  AFDQuery := Nil;
  AFDConexao := TFDConnection.Create(Self);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Self);
  AFDQuery.Connection := AFDConexao;

  try
    AFDQuery.Close;
    AFDQuery.SQL.Clear;
    AFDQuery.SQL.Add('SELECT DISTINCT * FROM ');
    AFDQuery.SQL.Add(ATabela);
    AFDQuery.SQL.Add(' WHERE ');
    AFDQuery.SQL.Add(ACampo);
    AFDQuery.SQL.Add(' LIKE ' + QuotedStr(UpperCase('%' + TextoPesquisar + '%')));
    AFDQuery.SQL.Add(' ORDER BY ');
    AFDQuery.SQL.Add(ACampo);
    AFDQuery.Open;

    if not AFDQuery.IsEmpty then
    begin
      try
        JSONValue := TJSONValue.Create;
        JSONValue.Encoded := False;
        JSONValue.JsonMode := jmPureJSON;

        JSONValue.LoadFromDataset('', AFDQuery, False, JSONValue.JsonMode);

        Result := JSONValue.ToJSON;
      finally
        JSONValue.Free;
      end;
    end
    else
      Result := 'Erro';

  finally
    begin
      AFDConexao.DisposeOf;
      AFDQuery.DisposeOf;
    end;
  end;

end;

function TDM.ListarSQL(ATabela: string): string;
var
  JSONValue: TJSONValue;
  AFDConexao: TFDConnection;
  AFDQuery: TFDQuery;
begin
  Result := '';
  AFDConexao := Nil;
  AFDQuery := Nil;
  AFDConexao := TFDConnection.Create(Self);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Self);
  AFDQuery.Connection := AFDConexao;

  try
    AFDQuery.Close;
    AFDQuery.SQL.Clear;
    AFDQuery.SQL.Add('SELECT * FROM ' + ATabela);
    AFDQuery.Open;

    if not AFDQuery.IsEmpty then
    begin
      try
        JSONValue := TJSONValue.Create;
        JSONValue.Encoded := False;
        JSONValue.JsonMode := jmPureJSON;

        JSONValue.LoadFromDataset('', AFDQuery, False, JSONValue.JsonMode, 'dd/mm/yyyy mm:ss', '.');

        Result := JSONValue.ToJSON;
      finally
        JSONValue.Free;
      end;
    end
    else
      Result := 'Erro';

  finally
    begin
      AFDConexao.DisposeOf;
      AFDQuery.DisposeOf;
    end;
  end;
end;

function TDM.ListarItensMemoria(ADados: TFDMemTable): string;
var
  JSONValue: TJSONValue;
begin
  Result := '';

  try
    if not ADados.IsEmpty then
    begin
      try
        JSONValue := TJSONValue.Create;
        JSONValue.Encoded := False;
        JSONValue.JsonMode := jmPureJSON;

        JSONValue.LoadFromDataset('', ADados, False, JSONValue.JsonMode);

        Result := JSONValue.ToJSON;
      finally
        JSONValue.Free;
      end;
    end
    else
      Result := 'Erro';

  finally
  end;
end;

function TDM.RetornarDados(aSQL: string; ADataIni, ADataFim: TDateTime): string;
var
  AFDConexao: TFDConnection;
  AFDQuery: TFDQuery;
begin
  Result := '';
  AFDConexao := Nil;
  AFDQuery := Nil;
  AFDConexao := TFDConnection.Create(Self);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Self);
  AFDQuery.Connection := AFDConexao;

  try
    try
      AFDQuery.Close;
      AFDQuery.SQL.Clear;
      AFDQuery.SQL.Add(aSQL);
      AFDQuery.ParamByName('dataini').AsDateTime := ADataIni;
      AFDQuery.ParamByName('datafim').AsDateTime := ADataFim;
      AFDQuery.Open;

      if not AFDQuery.IsEmpty then
      begin
        Result := AFDQuery.FieldByName('total').AsString;
      end
      else
        Result := 'Erro';

    finally
      begin
        AFDConexao.DisposeOf;
        AFDQuery.DisposeOf;
      end;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TDM.AtualizaComponenteAtualizacao;
var
  AuthOPt: TRDWAuthOption;
  AuthOPtParams: TRDWAuthOptionParam;
  AuthOPtBasic: TRDWAuthOptionBasic;
begin
  with RESTClientPooler1 do
  begin
    AuthOPt := TRDWAuthOption.rdwAOBasic;
    AuthOPtParams := TRDWAuthOptionParam.Create;
    AuthOPtBasic := TRDWAuthOptionBasic.Create;

    RESTClientPooler1.Host := TArquivo.LerINI('Configuracao', 'IP');
    RESTClientPooler1.Port := StrToIntDef(TArquivo.LerINI('Configuracao', 'Porta'), 8082);
    AuthOPtBasic.Username := TArquivo.LerINI('Configuracao', 'Usuario');
    AuthOPtBasic.Password := TArquivo.LerINI('Configuracao', 'Senha');

    AuthOPtParams := AuthOPtBasic;

    AuthenticationOptions.AuthorizationOption := AuthOPt;
    AuthenticationOptions.OptionParams := AuthOPtParams;

  end;
end;

procedure TDM.ConectarBanco(Conexao: TFDConnection);
begin
  with Conexao do
  begin
    Params.Values['DriverID'] := 'SQLite';

{$IFDEF ANDROID OR IOS}
    try
      Params.Values['Database'] := System.IOUtils.TPath.Combine(TPath.GetDocumentsPath, 'bd.db');
      Params.Values['LockingMode'] := 'Normal';
      Connected := True;
    except
      on E: Exception do
        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
    end;
{$ENDIF}
{$IFDEF MSWINDOWS}
    try
      Params.Values['Database'] := ExtractFilePath(ParamStr(0)) + 'bd\bd.db';
      Params.Values['LockingMode'] := 'Normal';
      Connected := True;
    except
      on E: Exception do
        raise Exception.Create('Erro de conexão com o banco de dados: ' + E.Message);
    end;
{$ENDIF}
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ConectarBanco(fdcConexao);
  AtualizaComponenteAtualizacao;
  AtualizarBanco;
end;

function TDM.EnviarDados(ATabela, ACampo, AParametro: string): Boolean;
var
  JSONValue: TJSONValue;
  dwParams: TDWParams;
  Resultado: string;
  AFDConexao: TFDConnection;
  AFDQuery: TFDQuery;
begin
  dwParams := Nil;
  Resultado := '';
  JSONValue := Nil;

  AFDConexao := Nil;
  AFDQuery := Nil;
  AFDConexao := TFDConnection.Create(Self);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Self);
  AFDQuery.Connection := AFDConexao;
  try

    try
      AFDQuery.Close;
      AFDQuery.SQL.Clear;
      AFDQuery.SQL.Add('SELECT * FROM ' + ATabela);
      AFDQuery.Open;

      JSONValue := TJSONValue.Create;
      JSONValue.Encoded := False;
      JSONValue.JsonMode := jmDataware;
      JSONValue.LoadFromDataset('', AFDQuery, False, JSONValue.JsonMode, 'dd/mm/yyyy hh:mm:ss', '.');

      DM.DWClientEvents1.CreateDWParams(AParametro, dwParams);
      dwParams.ItemsString['Dados'].AsString := JSONValue.ToJSON;
      dwParams.ItemsString['Tabela'].AsString := ATabela;
      DM.DWClientEvents1.SendEvent(AParametro, dwParams, Resultado);

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
      ShowMessage(E.Message);
  end;
end;

function TDM.GerarSQLInsert(ATabela: string; RestSQL: TRESTDWClientSQL): string;
var
  aSQL, bSQL: string;
  I: Integer;
begin
  aSQL := '';
  bSQL := '';
  Result := '';
  // Gerar sql
  for I := 0 to RestSQL.FieldCount - 1 do
  begin
    aSQL := aSQL + RestSQL.FieldDefs.Items[I].Name + ', ';
    bSQL := bSQL + ':' + RestSQL.FieldDefs.Items[I].Name + ', ';
  end;
  Result := ('INSERT INTO ' + ATabela + '(' + copy(aSQL, 1, length(aSQL) - 2) + ') VALUES(' + copy(bSQL, 1, length(bSQL) - 2) + ')');
end;

procedure TDM.GetProdutos(out Erro: string);
var
  AFDConexao: TFDConnection;
  AFDQuery, DeleteQuery: TFDQuery;
  dwParams: TDWParams;
  Resultado: string;
  X, Y: Integer;
  RESTDWSQL1: TRESTDWClientSQL;
  Data: string;
begin
  RESTDWSQL1 := Nil;
  RESTDWSQL1 := TRESTDWClientSQL.Create(Nil);
  dwParams := Nil;
  Resultado := '';
  AFDConexao := Nil;
  AFDQuery := Nil;
  DeleteQuery := Nil;
  Data := '';
  try
    if TestarConexaoServidor then
    begin
      try
        AFDConexao := TFDConnection.Create(Self);
        DM.ConectarBanco(AFDConexao);
        AFDQuery := TFDQuery.Create(Self);
        AFDQuery.Connection := AFDConexao;

        DeleteQuery := TFDQuery.Create(Self);
        DeleteQuery.Connection := AFDConexao;

        AFDQuery.Close;
        AFDQuery.SQL.Clear;
        AFDQuery.SQL.Add(' SELECT MAX(strftime(''%d/%m/%Y %H:%M:%S'', DATEUSER)) DATA FROM PRODUTOS ');
        AFDQuery.Open;

        Data := AFDQuery.FieldByName('DATA').AsString;

        DWClientEvents1.CreateDWParams('Produtos', dwParams);
        dwParams.ItemsString['Data'].AsString := Data;
        DWClientEvents1.SendEvent('Produtos', dwParams, Resultado);

        if Resultado <> 'erro' then
        begin
          RESTDWSQL1.Close;
          RESTDWSQL1.OpenJson(Resultado);
          if not RESTDWSQL1.IsEmpty then
          begin

            AFDQuery.Close;
            AFDQuery.SQL.Clear;
            AFDQuery.SQL.Add(GerarSQLInsert('PRODUTOS', RESTDWSQL1));
            AFDQuery.Params.ArraySize := RESTDWSQL1.RecordCount;

            RESTDWSQL1.First;
            RESTDWSQL1.DisableControls;
            for X := 0 to Pred(RESTDWSQL1.RecordCount) do
            begin
              AFDQuery.Params[0].Values[X] := RESTDWSQL1.FieldByName('COD_PROD').AsString;
              AFDQuery.Params[1].Values[X] := RESTDWSQL1.FieldByName('COD_ORG').AsString;
              AFDQuery.Params[2].Values[X] := RESTDWSQL1.FieldByName('PRE_CUS').AsString;
              AFDQuery.Params[3].Values[X] := RESTDWSQL1.FieldByName('PRE_VEN').AsString;
              AFDQuery.Params[4].Values[X] := RESTDWSQL1.FieldByName('COD_GRP').AsString;
              AFDQuery.Params[5].Values[X] := RESTDWSQL1.FieldByName('DES_GRP').AsString;
              AFDQuery.Params[6].Values[X] := RESTDWSQL1.FieldByName('DES_PROD').AsString;
              AFDQuery.Params[7].Values[X] := RESTDWSQL1.FieldByName('PER_DESC').AsString;
              AFDQuery.Params[8].Values[X] := RESTDWSQL1.FieldByName('FLG_TIPO').AsString;
              AFDQuery.Params[9].Values[X] := RESTDWSQL1.FieldByName('COD_BARR').AsString;
              AFDQuery.Params[10].Values[X] := RESTDWSQL1.FieldByName('NCM').AsString;
              AFDQuery.Params[11].Values[X] := RESTDWSQL1.FieldByName('COD_GENERO').AsString;
              AFDQuery.Params[12].Values[X] := RESTDWSQL1.FieldByName('UNI_MED').AsString;
              AFDQuery.Params[13].Values[X] := RESTDWSQL1.FieldByName('APLICA').AsString;
              AFDQuery.Params[14].Values[X] := RESTDWSQL1.FieldByName('DES_MARC').AsString;
              AFDQuery.Params[15].Values[X] := RESTDWSQL1.FieldByName('QTD_ATUAL').AsString;
              AFDQuery.Params[16].Values[X] := RESTDWSQL1.FieldByName('QTD_MAX').AsString;
              AFDQuery.Params[17].Values[X] := RESTDWSQL1.FieldByName('LOC_ESTO').AsString;
              AFDQuery.Params[18].Values[X] := RESTDWSQL1.FieldByName('NOM_LOJA').AsString;
              AFDQuery.Params[19].Values[X] := RESTDWSQL1.FieldByName('DATA_ENT').AsString;
              AFDQuery.Params[20].Values[X] := RESTDWSQL1.FieldByName('PRE_DESC').AsString;
              AFDQuery.Params[21].Values[X] := RESTDWSQL1.FieldByName('DATA_ALT').AsString;
              AFDQuery.Params[22].Values[X] := RESTDWSQL1.FieldByName('MASTER').AsString;
              AFDQuery.Params[23].AsDateTimes[X] := StrToDateTimeDef(RESTDWSQL1.FieldByName('DATEUSER').AsString, Now - 30000);

              DeleteQuery.Close;
              DeleteQuery.SQL.Clear;
              DeleteQuery.SQL.Add('DELETE FROM PRODUTOS WHERE COD_PROD = ' + QuotedStr(RESTDWSQL1.FieldByName('COD_PROD').AsString));
              DeleteQuery.ExecSQL;

              RESTDWSQL1.Next;
            end;
            RESTDWSQL1.EnableControls;

            AFDQuery.Execute(RESTDWSQL1.RecordCount);
          end;
        end
        else
          Erro := Resultado;

      finally
        begin
          dwParams.DisposeOf;
          AFDConexao.DisposeOf;
          AFDQuery.DisposeOf;
          DeleteQuery.DisposeOf;
          RESTDWSQL1.DisposeOf;
        end;
      end;
    end;
  except
    on E: Exception do
      Erro := E.Message;
  end;
end;

procedure TDM.AtualizarBaseLocal(ATabela: string);
var
  AFDConexao: TFDConnection;
  AFDQuery, DeleteQuery: TFDQuery;
  dwParams: TDWParams;
  Resultado, AFiltroDelete: string;
  X, Y: Integer;
  RESTDWSQL1: TRESTDWClientSQL;
begin
  dwParams := Nil;
  Resultado := '';
  AFiltroDelete := '';

  AFDConexao := Nil;
  AFDQuery := Nil;
  DeleteQuery := Nil;
  AFDConexao := TFDConnection.Create(Self);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Self);
  AFDQuery.Connection := AFDConexao;

  DeleteQuery := TFDQuery.Create(Self);
  DeleteQuery.Connection := AFDConexao;
  try

    try
      AFDQuery.Close;
      AFDQuery.SQL.Clear;
      AFDQuery.SQL.Add('SELECT strftime(''%d/%m/%Y %H:%M:%S'', MAX(LAST_CHANGE)) DATA FROM ' + ATabela);
      AFDQuery.Open;

      if TestarConexaoServidor then
      begin
        try
          DWClientEvents1.CreateDWParams(ATabela, dwParams);
          dwParams.ItemsString['Data'].AsString := AFDQuery.FieldByName('DATA').AsString;
          DWClientEvents1.SendEvent(ATabela, dwParams, Resultado);
          if Resultado <> 'Erro' then
          begin
            RESTDWSQL1.Close;
            RESTDWSQL1.OpenJson(Resultado);

            if not RESTDWSQL1.IsEmpty then
            begin
              AFDQuery.Close;
              AFDQuery.SQL.Clear;
              AFDQuery.SQL.Add(GerarSQLInsert(ATabela, RESTDWSQL1));
              AFDQuery.Params.ArraySize := RESTDWSQL1.RecordCount;

              RESTDWSQL1.First;
              RESTDWSQL1.DisableControls;

              for X := 0 to Pred(RESTDWSQL1.RecordCount) do
              begin
                AFiltroDelete := AFiltroDelete + QuotedStr(RESTDWSQL1.FieldByName('CODIGO').AsString) + ', ';

                for Y := 0 to Pred(RESTDWSQL1.FieldCount) do
                begin
                  // Validar tipo de dados aqui
                  case RESTDWSQL1.Fields.Fields[Y].DataType of
                    ftString, ftWideMemo, ftMemo, ftWideString:
                      begin
                        AFDQuery.Params[Y].AsDateTimes[X] := StrToDateTimeDef(RESTDWSQL1.Fields.Fields[Y].AsString, StrToDateTime('01/01/1900 00:00:01'));
                      end;
                    ftInteger, ftSmallint, ftWord, ftShortint, ftBCD:
                      begin
                        AFDQuery.Params[Y].AsIntegers[X] := RESTDWSQL1.Fields.Fields[Y].AsInteger;
                      end;
                    ftFloat, ftFMTBcd, ftExtended:
                      begin
                        AFDQuery.Params[Y].AsFloats[X] := StrToFloat(RESTDWSQL1.Fields.Fields[Y].AsString)
                      end;
                    ftDate, ftDateTime, ftTimeStamp, ftTime:
                      begin
                        AFDQuery.Params[Y].AsStrings[X] := FormatDateTime('yyyy-mm-dd hh:ss', StrToDateTime(RESTDWSQL1.Fields.Fields[Y].AsString));
                      end;
                  else // casos gerais são tratados como string
                    AFDQuery.Params[Y].AsStrings[X] := RESTDWSQL1.Fields.Fields[Y].AsString;
                  end;
                end;
                RESTDWSQL1.Next;
              end;
              RESTDWSQL1.EnableControls;

              DeleteQuery.Close;
              DeleteQuery.SQL.Clear;
              DeleteQuery.SQL.Add('DELETE FROM ' + ATabela);
              DeleteQuery.ExecSQL;

              AFDQuery.Execute(RESTDWSQL1.RecordCount);
            end;
          end;

        finally
          begin
            dwParams.DisposeOf;
          end;
        end;
      end;
    finally
      begin
        AFDConexao.DisposeOf;
        AFDQuery.DisposeOf;
        DeleteQuery.DisposeOf;
        RESTDWSQL1.DisposeOf;
      end;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

function TDM.TestarConexaoServidor: Boolean;
var
  FGetLastError: string;
  TCP: TIdTCPClient;
  Exists: Boolean;
  I: Integer;
begin

  Result := False;
  TCP := TIdTCPClient.Create(nil);
  try
    TCP.Host := TArquivo.LerINI('Configuracao', 'IP');
    TCP.Port := StrToIntDef(TArquivo.LerINI('Configuracao', 'Porta'), 8082);
    TCP.ReadTimeout := 500;
    TCP.ConnectTimeout := 500;
    I := 0;
    while (I < 1) do
    begin
      Inc(I);
      try
        TCP.Connect;
        TCP.Disconnect;
        exit(True); // Success
      except
        on E: Exception do
        begin
          //ShowMessage(e.Message);
          FGetLastError := 'Connect tcp error :' + E.Message;
        end;
      end;
    end;
  finally
    TCP.Free;
  end;
end;

function TDM.UsuarioLiberado(AUsuario, ASenha: string): Boolean;
var
  JSONValue: TJSONValue;
  dwParams: TDWParams;
  Resultado: string;
begin
  JSONValue := Nil;
  dwParams := Nil;
  Resultado := '';
  Result := False;
  JSONValue := TJSONValue.Create;
  if TestarConexaoServidor then
  begin

    try
      DM.DWClientEvents1.CreateDWParams('Login', dwParams);
      dwParams.ItemsString['Usuario'].AsString := AUsuario;
      dwParams.ItemsString['Senha'].AsString := ASenha;
      DM.DWClientEvents1.SendEvent('Login', dwParams, Resultado);
      if Resultado <> 'error' then
      begin
        DM.RESTDWClientSQL1.OpenJson(Resultado);
        if not DM.RESTDWClientSQL1.IsEmpty then
        begin
          TArquivo.GravarINI('Usuario', 'UCIDUSER', RESTDWClientSQL1.FieldByName('UCIDUSER').AsString);
          TArquivo.GravarINI('Usuario', 'UCUSERNAME', RESTDWClientSQL1.FieldByName('UCUSERNAME').AsString);
          TArquivo.GravarINI('Usuario', 'UCEMAIL', RESTDWClientSQL1.FieldByName('UCEMAIL').AsString);
          TArquivo.GravarINI('Usuario', 'UCLOGIN', RESTDWClientSQL1.FieldByName('UCLOGIN').AsString);
          TArquivo.GravarINI('Usuario', 'UCPASSWORD', ASenha);
          TArquivo.GravarINI('Usuario', 'COD_LOJA', RESTDWClientSQL1.FieldByName('COD_LOJA').AsString);

          Result := True;
        end;
      end
      else
      begin
      // Fazer algo aqui
        ShowMessage('Usuário ou senha inválido.');
      end;

    finally
      begin
        dwParams.DisposeOf;
        JSONValue.DisposeOf;
      end;
    end;
  end
  else
    ShowMessage('Vefirique seu acesso com o servidor.');
end;

procedure TDM.ExcluirItem(ATabela, AColuna: string; ACodigo: Integer);
var
  AFDConexao: TFDConnection;
  AFDQuery: TFDQuery;
begin
  AFDConexao := Nil;
  AFDQuery := Nil;

  AFDConexao := TFDConnection.Create(Nil);
  DM.ConectarBanco(AFDConexao);

  AFDQuery := TFDQuery.Create(Nil);
  AFDQuery.Connection := AFDConexao;

  try
    AFDQuery.Close;
    AFDQuery.SQL.Clear;
    AFDQuery.SQL.Add('DELETE FROM ' + ATabela);
    AFDQuery.SQL.Add(' WHERE ' + AColuna);
    AFDQuery.SQL.Add(' = :CODIGO ');
    AFDQuery.ParamByName('CODIGO').AsInteger := ACodigo;
    AFDQuery.ExecSQL;
  finally
    AFDConexao.DisposeOf;
    AFDQuery.DisposeOf;
  end;
end;

procedure TDM.ExecutarAlteracao(aSQL: string);
var
  AFDConexao: TFDConnection;
  bFDQuery: TFDQuery;
begin
  AFDConexao := Nil;
  bFDQuery := Nil;

  AFDConexao := TFDConnection.Create(Nil);
  DM.ConectarBanco(AFDConexao);

  bFDQuery := TFDQuery.Create(Nil);
  bFDQuery.Connection := AFDConexao;

  try
    bFDQuery.Close;
    bFDQuery.SQL.Clear;
    bFDQuery.SQL.Add(aSQL);
    bFDQuery.ExecSQL;
  finally
    AFDConexao.DisposeOf;
    bFDQuery.DisposeOf;
  end;
end;

function TDM.ExisteCampo(Tabela, Coluna: string): Boolean;
var
  AFDConexao: TFDConnection;
  bFDQuery: TFDQuery;
  I: Integer;
begin
  Result := False;
  AFDConexao := Nil;
  bFDQuery := Nil;

  AFDConexao := TFDConnection.Create(Nil);
  DM.ConectarBanco(AFDConexao);

  bFDQuery := TFDQuery.Create(Nil);
  bFDQuery.Connection := AFDConexao;

  try
    bFDQuery.Close;
    bFDQuery.SQL.Clear;
    bFDQuery.SQL.Add('SELECT sql FROM sqlite_master WHERE type=''table'' AND name=:TABELA');
    bFDQuery.ParamByName('TABELA').AsString := Tabela;
    bFDQuery.Open;

    if bFDQuery.RecordCount > 0 then
    begin
      I := Pos(Coluna, bFDQuery.FieldByName('SQL').AsString);
      if I > 0 then
      begin
        Result := True;
      end;
    end;

  finally
    AFDConexao.DisposeOf;
    bFDQuery.DisposeOf;
  end;
end;

procedure TDM.AtualizarBanco;
begin
  TAtualizaBD.Versao0001;
  TAtualizaBD.Versao0002;
end;

end.

