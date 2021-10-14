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
    procedure DWServerEvents1EventsInventarioReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsProdutosReplyEvent(var Params: TDWParams; var Result: string);
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
    {$ENDIF}                                                    ;
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

procedure TServerModule.DWServerEvents1EventsInventarioReplyEvent(var Params: TDWParams; var Result: string);
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
          LocFDQuery.SQL.Add(' UPDATE CAPTBEST ');
          LocFDQuery.SQL.Add(' SET LOC_ESTO = :LOC_ESTO, ');
          LocFDQuery.SQL.Add(' QTD_ATUAL = :QTD_ATUAL ');
          LocFDQuery.SQL.Add(' WHERE COD_PROD = :COD_PROD ');
          LocFDQuery.ParamByName('LOC_ESTO').Value := RESTDWSQL1.FieldByName('LOC_ESTO').AsString;
          LocFDQuery.ParamByName('QTD_ATUAL').Value := RESTDWSQL1.FieldByName('QTDE_NOVA').AsString;
          LocFDQuery.ParamByName('COD_PROD').Value := RESTDWSQL1.FieldByName('COD_PROD').AsString;
          LocFDQuery.ExecSQL;

          RESTDWSQL1.Next;
        end;
        RESTDWSQL1.EnableControls;

        AFDQuery.Execute(RESTDWSQL1.RecordCount);
        Result := '200';
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
      Result := 'Erro: ' + E.Message;
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
    aFDQuery.ParamByName('USUARIO').AsString := Params.ItemsString['Usuario'].AsString;
    aFDQuery.ParamByName('SENHA').AsString := PostProcess(InternalEncrypt(format('%s', [Params.ItemsString['Senha'].AsString]), 0));
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
        Result := 'error';

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

procedure TServerModule.DWServerEvents1EventsProdutosReplyEvent(var Params: TDWParams; var Result: string);
var
  JSONValue: TJSONValue;
begin
  FDQPadrao.Close;
  FDQPadrao.SQL.Clear;

  if Params.ItemsString['Data'].AsString <> '' then
  begin
    FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
    FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
    FDQPadrao.SQL.Add(' WHERE DATEUSER > :DATA ');
    FDQPadrao.ParamByName('DATA').AsDateTime := StrToDateTime(Params.ItemsString['Data'].AsString);
  end
  else
  begin
    FDQPadrao.SQL.Add(' SELECT S.*, C.DATEUSER FROM SUPERCONS S ');
    FDQPadrao.SQL.Add(' LEFT JOIN CAPTBPRD C ON C.COD_PROD = S.COD_PROD ');
  end;

  FDQPadrao.Open;

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
    Result := 'erro';
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
        Result := '200';
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

