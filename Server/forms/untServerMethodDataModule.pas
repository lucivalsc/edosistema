unit untServerMethodDataModule;

interface

uses
  System.IniFiles,
  Vcl.Forms,
  uDWJSONObject,
  uDWConsts,
  uDWDatamodule,
  uRESTDWPoolerDB,
  uRestDWDriverFD,
  uDWAbout,
  uRESTDWServerEvents,
  uDWConstsData,
  Vcl.Dialogs,
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Moni.Base,
  FireDAC.Moni.FlatFile,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Data.DB,
  uSystemEvents,
  untArquivoINI,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef;

type
  TServerModule = class(TServerMethodDataModule)
    FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink;
    DWServerEvents1: TDWServerEvents;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    FDConnection1: TFDConnection;
    FDQPadrao: TFDQuery;
    pDataSet2: TFDMemTable;
    FDStoredProc1: TFDStoredProc;
    pDataSet: TRESTDWClientSQL;
    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure DWServerEvents1EventsReceberDadosReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsLoginReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsConferenciaReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsSepararReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsProdutosReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWServerEvents1EventsInventarioReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWServerEvents1EventsConferenciaPedidoReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWServerEvents1EventsProdutosContagemReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
  private
    { Private declarations }
    function InternalEncrypt(const S: ansistring; Key: Word): ansistring;
    function PostProcess(const S: ansistring): ansistring;
    function Encode(const S: ansistring): ansistring;
    function GerarSQLInsert(ATabela: string; RestSQL: TFDMemTable): string;
    function GerarSQLInsert2(ATabela: string; RestSQL: TRESTDWClientSQL): string;
  public
    { Public declarations }
  end;

var
  ServerModule: TServerModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  untPrincipal;

{$R *.dfm}

function TServerModule.Encode(const S: ansistring): ansistring;
const
  Map: array[0..63] of Char = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  I: longint;
begin
  I := 0;
  Move(S[1], I, length(S));
  case length(S) of
    1:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64];
    2:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] + Map[(I shr 12) mod 64];
    3:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] + Map[(I shr 12) mod 64] + Map[(I shr 18) mod 64];
  end;
end;

function TServerModule.InternalEncrypt(const S: ansistring; Key: Word): ansistring;
var
  I: Word;
  Seed: int64;
begin
  Result := S;
  Seed := Key;
  for I := 1 to length(Result) do
  begin
    {$IFNDEF VER180}
    Result[I] := Ansichar(byte(Result[I]) xor (Seed shr 8));
    {$ELSE}
    Result[I] := Char(byte(Result[I]) xor (Seed shr 8));
    {$ENDIF}                                                                                                                                                                                            ;
    Seed := (byte(Result[I]) + Seed) * Word(52845) + Word(22719);
  end;
end;

function TServerModule.PostProcess(const S: ansistring): ansistring;
var
  SS: ansistring;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Encode(copy(SS, 1, 3));
    Delete(SS, 1, 3);
  end;
  sleep(10);
end;

procedure TServerModule.DWServerEvents1EventsConferenciaPedidoReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
var
  JSONValue: TJSONValue;
  I: Integer;
  aFDQuery: TFDQuery;
  Filtro: string;
begin
  if Params.ItemsString['num_pedi'].AsInteger > 0 then
    Filtro := ' and hpd.num_pedi = :num_pedi and hpd.cod_loja = :cod_loja '
  else
    Filtro := ' and hpd.cod_loja = :cod_loja ';

  try
    JSONValue := TJSONValue.Create;
    aFDQuery := TFDQuery.Create(Nil);
    aFDQuery.Connection := FDConnection1;
    aFDQuery.Close;
    aFDQuery.SQL.Clear;
    aFDQuery.SQL.Add(' select ');
    aFDQuery.SQL.Add('     hpd.dat_pedi, ');
    aFDQuery.SQL.Add('     hpd.cod_ven, ');
    aFDQuery.SQL.Add('     hpd.cod_cli, ');
    aFDQuery.SQL.Add('     hpd.vlr_tota, ');
    aFDQuery.SQL.Add('     hpd.num_pedi, ');
    aFDQuery.SQL.Add('     hpd.localvenda, ');
    aFDQuery.SQL.Add('     cli.nom_cli, ');
    aFDQuery.SQL.Add('     ca.cod_prod, ');
    aFDQuery.SQL.Add('     ca.qtd_prod, ');
    aFDQuery.SQL.Add('     su.des_prod ');
    aFDQuery.SQL.Add(' from captbhpd hpd ');
    aFDQuery.SQL.Add(' left join captbcli cli on cli.cod_cli = hpd.cod_cli ');
    aFDQuery.SQL.Add(' left join captbipd ca on ca.num_pedi = hpd.num_pedi ');
    aFDQuery.SQL.Add(' left join supercons su on su.cod_prod = ca.cod_prod ');
    aFDQuery.SQL.Add(' where hpd.cod_cli = cli.cod_cli ');
    aFDQuery.SQL.Add('     and flg_caixa in (''S'', ''B'') and flg_conf = ''A'' ');
    aFDQuery.SQL.Add(Filtro);
    aFDQuery.SQL.Add(' order by num_pedi desc ');
    aFDQuery.ParamByName('cod_loja').AsInteger := Params.ItemsString['cod_loja'].AsInteger;
    if Params.ItemsString['num_pedi'].AsInteger > 0 then
      aFDQuery.ParamByName('num_pedi').AsInteger := Params.ItemsString['num_pedi'].AsInteger;
    aFDQuery.Open;

    try
      if aFDQuery.RecordCount > 0 then
      begin
        JSONValue.Encoding := Encoding;
        JSONValue.Encoded := False;
        JSONValue.JsonMode := jmPureJSON;
        JSONValue.LoadFromDataset('', aFDQuery, False, JSONValue.JsonMode, 'dd/mm/yyyy', '.');
        Result := JSONValue.ToJSON;
      end
      else
      begin
        StatusCode := 500;
      end;

    finally
      begin
        JSONValue.Free;
        aFDQuery.DisposeOf;
      end;
    end;

  except
    on E: Exception do
    begin
      StatusCode := 500;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TServerModule.DWServerEvents1EventsConferenciaReplyEvent(var Params: TDWParams; var Result: string);
var
  I: Integer;
  RESTDWSQL1: TRESTDWClientSQL;
  aFDQuery: TFDQuery;
begin
  RESTDWSQL1 := Nil;
  RESTDWSQL1 := TRESTDWClientSQL.Create(Nil);
  aFDQuery := TFDQuery.Create(Nil);
  aFDQuery.Connection := FDConnection1;

  try
    RESTDWSQL1.Close;
    RESTDWSQL1.OpenJson(Params.ItemsString['Dados'].AsString);

    if not RESTDWSQL1.IsEmpty then
    begin

      try
        RESTDWSQL1.First;
        RESTDWSQL1.DisableControls;
        aFDQuery.Close;
        aFDQuery.SQL.Clear;
        aFDQuery.SQL.Add(' update captbhpd set ');
        aFDQuery.SQL.Add(' flg_conf = ''C'', ');
        aFDQuery.SQL.Add(' user_conf = :uclogin, ');
        aFDQuery.SQL.Add(' data_conf = :data_conf ');
        aFDQuery.SQL.Add(' WHERE num_pedi = :num_pedi ');
        aFDQuery.ParamByName('num_pedi').AsString := RESTDWSQL1.FieldByName('num_pedi').AsString;
        aFDQuery.ParamByName('uclogin').AsString := RESTDWSQL1.FieldByName('uclogin').AsString;
        aFDQuery.ParamByName('data_conf').AsDateTime := Now;
        aFDQuery.ExecSQL;

      finally
        begin
          aFDQuery.DisposeOf;
          RESTDWSQL1.DisposeOf;
        end;
      end;
    end;

  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TServerModule.DWServerEvents1EventsSepararReplyEvent(var Params: TDWParams; var Result: string);
var
  I: Integer;
  aFDQuery: TFDQuery;
begin
  aFDQuery := TFDQuery.Create(Nil);
  aFDQuery.Connection := FDConnection1;
  try
    try
      aFDQuery.Close;
      aFDQuery.SQL.Clear;
      aFDQuery.SQL.Add(' update captbhpd set ');
      aFDQuery.SQL.Add(' flg_conf = ''S'', ');
      aFDQuery.SQL.Add(' user_separ = :uclogin, ');
      aFDQuery.SQL.Add(' data_separ = :data_conf ');
      aFDQuery.SQL.Add(' WHERE num_pedi = :num_pedi ');
      aFDQuery.ParamByName('num_pedi').AsString := Params.ItemsString['num_pedi'].AsString;
      aFDQuery.ParamByName('uclogin').AsString := Params.ItemsString['uclogin'].AsString;
      aFDQuery.ParamByName('data_conf').AsDateTime := Now;
      aFDQuery.ExecSQL;

    finally
      begin
        aFDQuery.DisposeOf;
      end;
    end;

  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TServerModule.DWServerEvents1EventsInventarioReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
var
  AFDQuery, LocFDQuery: TFDQuery;
  RESTDWSQL1: TRESTDWClientSQL;
  I: Integer;
begin
  RESTDWSQL1 := Nil;
  RESTDWSQL1 := TRESTDWClientSQL.Create(Nil);
  AFDQuery := Nil;
  LocFDQuery := nil;
  try
    try
      AFDQuery := TFDQuery.Create(Self);
      AFDQuery.Connection := FDConnection1;

      LocFDQuery := TFDQuery.Create(Self);
      LocFDQuery.Connection := FDConnection1;

      RESTDWSQL1.Close;
      RESTDWSQL1.OpenJson(Params.ItemsString['Dados'].AsString);
      if not RESTDWSQL1.IsEmpty then
      begin
        AFDQuery.Close;
        AFDQuery.SQL.Clear;
        AFDQuery.SQL.Add(' INSERT INTO SIGTBPRDHIST(NUM_LANC, DATA, COD_PROD, QTDE_ANT, QTDE_NOVA, TIPO, UCLOGIN, VLR_CUSTO, VLR_VENDA, COD_LOJA) ');
        AFDQuery.SQL.Add(' VALUES(GEN_ID(GEN_NUM_PRDHIST, 1), :DATA, :COD_PROD, :QTDE_ANT, :QTDE_NOVA, :TIPO, :UCLOGIN, :VLR_CUSTO, :VLR_VENDA, :COD_LOJA) ');

        AFDQuery.Params.ArraySize := RESTDWSQL1.RecordCount;

        RESTDWSQL1.First;
        RESTDWSQL1.DisableControls;
        for I := 0 to Pred(RESTDWSQL1.RecordCount) do
        begin
          AFDQuery.Params[0].AsDateTimes[I] := StrToDateTime(RESTDWSQL1.FieldByName('DATA').AsString);
          AFDQuery.Params[1].Values[I] := RESTDWSQL1.FieldByName('COD_PROD').AsString;
          AFDQuery.Params[2].AsIntegers[I] := StrToIntDef(RESTDWSQL1.FieldByName('QTDE_ANT').AsString, 0);
          AFDQuery.Params[3].Values[I] := StrToIntDef(RESTDWSQL1.FieldByName('QTDE_NOVA').AsString, 0);
          AFDQuery.Params[4].Values[I] := RESTDWSQL1.FieldByName('TIPO').AsString;
          AFDQuery.Params[5].Values[I] := RESTDWSQL1.FieldByName('UCLOGIN').AsString;
          AFDQuery.Params[6].Values[I] := StrToFloatDef(RESTDWSQL1.FieldByName('VLR_CUSTO').AsString, 0);
          AFDQuery.Params[7].Values[I] := StrToFloatDef(RESTDWSQL1.FieldByName('VLR_VENDA').AsString, 0);
          AFDQuery.Params[8].Values[I] := StrToIntDef(RESTDWSQL1.FieldByName('COD_LOJA').AsString, 0);

          LocFDQuery.Close;
          LocFDQuery.SQL.Clear;
          LocFDQuery.SQL.Add(' UPDATE CAPTBPRD ');
          LocFDQuery.SQL.Add(' SET COD_BARR = :COD_BARR ');
          LocFDQuery.SQL.Add(' WHERE COD_PROD = :COD_PROD ');
          LocFDQuery.ParamByName('COD_BARR').Value := RESTDWSQL1.FieldByName('COD_BARR').AsString;
          LocFDQuery.ParamByName('COD_PROD').Value := RESTDWSQL1.FieldByName('COD_PROD').AsString;
          LocFDQuery.ExecSQL;

          LocFDQuery.Close;
          LocFDQuery.SQL.Clear;
          LocFDQuery.SQL.Add(' UPDATE CAPTBEST ');
          LocFDQuery.SQL.Add(' SET LOC_ESTO = :LOC_ESTO, ');
          LocFDQuery.SQL.Add(' QTD_ATUAL = :QTD_ATUAL ');
          LocFDQuery.SQL.Add(' WHERE COD_PROD = :COD_PROD ');
          LocFDQuery.ParamByName('LOC_ESTO').Value := RESTDWSQL1.FieldByName('LOC_ESTO').AsString;
          LocFDQuery.ParamByName('QTD_ATUAL').Value := RESTDWSQL1.FieldByName('QTDE_NOVA').AsString;
          LocFDQuery.ParamByName('COD_PROD').Value := RESTDWSQL1.FieldByName('COD_PROD').AsString;
          LocFDQuery.ExecSQL;

          LocFDQuery.Close;
          LocFDQuery.SQL.Clear;
          LocFDQuery.SQL.Add(' UPDATE CAPTBPRD ');
          LocFDQuery.SQL.Add(' SET DATEUSER = :DATEUSER, ');
          LocFDQuery.SQL.Add(' UCLOGIN = :UCLOGIN ');
          LocFDQuery.SQL.Add(' WHERE COD_PROD = :COD_PROD ');
          LocFDQuery.ParamByName('DATEUSER').AsDateTime := Now;
          LocFDQuery.ParamByName('UCLOGIN').Value := RESTDWSQL1.FieldByName('UCLOGIN').AsString;
          LocFDQuery.ParamByName('COD_PROD').Value := RESTDWSQL1.FieldByName('COD_PROD').AsString;
          LocFDQuery.ExecSQL;

          RESTDWSQL1.Next;
        end;
        RESTDWSQL1.EnableControls;

        AFDQuery.Execute(RESTDWSQL1.RecordCount);
        StatusCode := 200;
        Result := 'Erro';
      end;

    finally
      begin
        AFDQuery.DisposeOf;
        LocFDQuery.DisposeOf;
        RESTDWSQL1.DisposeOf;
      end;
    end;
  except
    on E: Exception do
    begin
      StatusCode := 500;
      Result := 'Erro: ' + E.Message;
    end;
  end;
end;

procedure TServerModule.DWServerEvents1EventsLoginReplyEvent(var Params: TDWParams; var Result: string);
var
  JSONValue: TJSONValue;
  I: Integer;
  aFDQuery: TFDQuery;
begin

  try
    JSONValue := TJSONValue.Create;
    aFDQuery := TFDQuery.Create(Nil);
    aFDQuery.Connection := FDConnection1;
    aFDQuery.Close;
    aFDQuery.SQL.Clear;
    aFDQuery.SQL.Add(' SELECT ');
    aFDQuery.SQL.Add('     U.UCIDUSER, ');
    aFDQuery.SQL.Add('     U.UCUSERNAME, ');
    aFDQuery.SQL.Add('     U.UCEMAIL, ');
    aFDQuery.SQL.Add('     U.UCLOGIN, ');
    aFDQuery.SQL.Add('     U.UCPASSWORD, ');
    aFDQuery.SQL.Add('     U.COD_LOJA ');
    aFDQuery.SQL.Add(' FROM UCTABUSERS U ');
    aFDQuery.SQL.Add(' WHERE U.UCTYPEREC = ''U'' ');
    aFDQuery.SQL.Add(' AND UPPER(U.UCLOGIN) = :USUARIO ');
    aFDQuery.SQL.Add(' AND U.UCPASSWORD = :SENHA ');
    aFDQuery.ParamByName('USUARIO').AsString := UpperCase(Params.ItemsString['Usuario'].AsString);
    aFDQuery.ParamByName('SENHA').AsString := (PostProcess(InternalEncrypt(format('%s', [UpperCase(Params.ItemsString['Senha'].AsString)]), 0)));
    aFDQuery.Open;

    try
      if aFDQuery.RecordCount > 0 then
      begin
        JSONValue.Encoding := Encoding;
        JSONValue.Encoded := False;
        JSONValue.JsonMode := jmPureJSON;
        JSONValue.LoadFromDataset('', aFDQuery, False, JSONValue.JsonMode, 'dd/mm/yyyy', '.');
        Result := JSONValue.ToJSON;
      end
      else
        Result := 'Erro';

    finally
      begin
        JSONValue.Free;
        aFDQuery.DisposeOf;
      end;
    end;

  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TServerModule.DWServerEvents1EventsProdutosContagemReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
var
  JSONValue: TJSONValue;
begin

  if Params.ItemsString['pesquisar'].AsString <> '' then
  begin
    FDQPadrao.Close;
    FDQPadrao.SQL.Clear;
    FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
    FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
    FDQPadrao.SQL.Add(' WHERE S.COD_BARR = ' + QuotedStr(Params.ItemsString['pesquisar'].AsString));
    FDQPadrao.Open;
  end;

  if FDQPadrao.IsEmpty then
  begin
    if Params.ItemsString['pesquisar'].AsString <> '' then
    begin
      FDQPadrao.Close;
      FDQPadrao.SQL.Clear;
      FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
      FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
      FDQPadrao.SQL.Add(' WHERE S.COD_PROD = ' + QuotedStr(Params.ItemsString['pesquisar'].AsString));
      FDQPadrao.Open;
    end;
  end;

  if not FDQPadrao.IsEmpty then
  begin
    try
      JSONValue := TJSONValue.Create;
      JSONValue.Encoding := Encoding;
      JSONValue.Encoded := False;
      JSONValue.JsonMode := jmPureJSON;
      JSONValue.LoadFromDataset('', FDQPadrao, False, JSONValue.JsonMode, 'dd/mm/yyyy hh:mm:ss', '.');
      Result := JSONValue.ToJSON;
    finally
      JSONValue.Free;
    end;
  end
  else
    StatusCode := 500;
end;

procedure TServerModule.DWServerEvents1EventsProdutosReplyEventByType(var Params: TDWParams; var Result: string; const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
var
  JSONValue: TJSONValue;
begin
  FDQPadrao.Close;
  FDQPadrao.SQL.Clear;

  if Params.ItemsString['pesquisar'].AsString <> '' then
  begin
    FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
    FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
    FDQPadrao.SQL.Add(' WHERE MASTER LIKE ' + QuotedStr('%' + Params.ItemsString['pesquisar'].AsString + '%'));

    FDQPadrao.Open;
  end;

//  if Params.ItemsString['Data'].AsString <> '' then
//  begin
//    FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
//    FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
//    FDQPadrao.SQL.Add(' WHERE DATEUSER > :DATA ');
//    FDQPadrao.ParamByName('DATA').AsDateTime := StrToDateTime(Params.ItemsString['Data'].AsString);
//  end
//  else
//  begin
//    FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
//    FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
//  end;

  if not FDQPadrao.IsEmpty then
  begin
    try
      JSONValue := TJSONValue.Create;
      JSONValue.Encoding := Encoding;
      JSONValue.Encoded := False;
      JSONValue.JsonMode := jmPureJSON;

      JSONValue.LoadFromDataset('', FDQPadrao, False, JSONValue.JsonMode, 'dd/mm/yyyy hh:mm:ss', '.');

      Result := JSONValue.ToJSON;
    finally
      JSONValue.Free;
    end;
  end
  else
    Result := 'Erro';
end;

procedure TServerModule.DWServerEvents1EventsReceberDadosReplyEvent(var Params: TDWParams; var Result: string);
var
  aSQL, bSQL, cSQL: string;
  I, X, Y: Integer;
  aFDQuery: TFDQuery;
  JSONValue: TJSONValue;
begin
  JSONValue := Nil;
  aFDQuery := TFDQuery.Create(Self);
  aFDQuery.Connection := FDConnection1;

  aSQL := '';
  bSQL := '';
  cSQL := '';
  Result := '';
  JSONValue := TJSONValue.Create;

  try
    pDataSet2.Close;
    JSONValue.WriteToDataset(dtFull, Params.ItemsString['Dados'].Value, pDataSet2);
    pDataSet2.CommitUpdates;

    try
      if pDataSet2.RecordCount > 0 then
      begin
        // Gravar no banco com ArrayDML
        aFDQuery.Close;
        aFDQuery.SQL.Clear;
        aFDQuery.SQL.Add(GerarSQLInsert(Params.ItemsString['Tabela'].AsString, pDataSet2));
        aFDQuery.Params.ArraySize := pDataSet2.RecordCount;

        pDataSet2.First;
        pDataSet2.DisableControls;
        for X := 0 to pDataSet2.RecordCount - 1 do
        begin
          for Y := 0 to pDataSet2.FieldCount - 1 do
          begin
            // Validar tipo de dados aqui
            case pDataSet2.Fields.Fields[Y].DataType of
              ftString, ftWideMemo, ftMemo, ftWideString:
                begin
                  aFDQuery.Params[Y].AsStrings[X] := pDataSet2.Fields.Fields[Y].AsString;
                end;
              ftInteger, ftSmallint, ftWord, ftShortint, ftBCD:
                begin
                  aFDQuery.Params[Y].AsIntegers[X] := pDataSet2.Fields.Fields[Y].AsInteger;
                end;
              ftDateTime, ftDate, ftTimeStamp:
                begin
                  aFDQuery.Params[Y].AsDateTimes[X] := StrToDateTimeDef(pDataSet2.Fields.Fields[Y].AsString, Now);
                end;
              ftFloat, ftFMTBcd, ftExtended:
                begin
                  aFDQuery.Params[Y].AsFloats[X] := StrToFloat(pDataSet2.Fields.Fields[Y].AsString)
                end;
            else // casos gerais são tratados como string
              aFDQuery.Params[Y].AsStrings[X] := pDataSet2.Fields.Fields[Y].AsString;
            end;
          end;

          pDataSet2.Next;
        end;
        pDataSet2.EnableControls;
        aFDQuery.Execute(pDataSet2.RecordCount);
        Result := 'Erro';
      end;

    finally
      begin
        aFDQuery.DisposeOf;
        JSONValue.DisposeOf;
      end;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
    //  Result := 'Erro no servidor: ' + E.Message;
  end;
end;

function TServerModule.GerarSQLInsert(ATabela: string; RestSQL: TFDMemTable): string;
var
  aSQL, bSQL: string;
  I: Integer;
begin
  aSQL := '';
  bSQL := '';
  Result := '';
  for I := 0 to RestSQL.FieldCount - 1 do
  begin
    aSQL := aSQL + RestSQL.FieldDefs.Items[I].Name + ', ';
    bSQL := bSQL + ':' + RestSQL.FieldDefs.Items[I].Name + ', ';
  end;
  Result := ('INSERT INTO ' + ATabela + '(' + Copy(aSQL, 1, length(aSQL) - 2) + ') VALUES(' + Copy(bSQL, 1, length(bSQL) - 2) + ')');
end;

function TServerModule.GerarSQLInsert2(ATabela: string; RestSQL: TRESTDWClientSQL): string;
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

procedure TServerModule.ServerMethodDataModuleCreate(Sender: TObject);
begin
  TArquivoINI.ConectarBanco(FDConnection1);
end;

end.

