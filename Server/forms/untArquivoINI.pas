unit untArquivoINI;

interface

uses
  Winapi.Messages,
  Vcl.Dialogs,
  IniFiles,
  Vcl.Forms,

  // Oracle AdoConnection
  Data.Win.ADODB,

{$REGION 'Arquivos de conex�o Firedac'}
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Comp.UI,

  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Phys.IBBase,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
{$ENDREGION}
  SysUtils;

type
  TArquivoINI = class
  Public
    class function LerIni(Chave1, Chave2: String; ValorPadrao: String = ''): String;
    class procedure ConectarBanco(Conexao: TFDConnection);
    class procedure ConectarBancoOracle(Conexao: TADOConnection);
    class function GetVersionApp(const AFileName: String): String; static;
  end;

implementation

uses
  DWDCPtypes,
  Winapi.Windows;

{ TArquivoINI }

// Fun��o que gera a vers�o do sistema
class function TArquivoINI.GetVersionApp(const AFileName: String): String;
var
  FileName: string;
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := EmptyStr;
  FileName := AFileName;
  UniqueString(FileName);
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          Result := Concat(IntToStr(FI.dwFileVersionMS shr 16), '.', IntToStr(FI.dwFileVersionMS and $FFFF), '.', IntToStr(FI.dwFileVersionLS shr 16), '.',
            IntToStr(FI.dwFileVersionLS and $FFFF));
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

class procedure TArquivoINI.ConectarBanco(Conexao: TFDConnection);
begin
  try
    with Conexao do
    begin
      Params.Values['DriverID'] := 'SQLite';

{$IFDEF IOS}
      try
        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'bd.db');
        Connected := True;
      except
        on E: Exception do
          raise Exception.Create('Erro de conex�o com o banco de dados: ' + E.Message);
      end;
{$ENDIF}
{$IFDEF ANDROID}
      try
        Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'bd.db');
        Connected := True;
      except
        on E: Exception do
          raise Exception.Create('Erro de conex�o com o banco de dados: ' + E.Message);
      end;
{$ENDIF}
{$IFDEF MSWINDOWS}
      Connected := false;
      LoginPrompt := false;
      Params.Clear;
      Params.Values['DriverID'] := 'FB';
      Params.Values['Protocol'] := TArquivoINI.LerIni('FIREBIRD', 'Protocol');
      Params.Values['Server'] := TArquivoINI.LerIni('FIREBIRD', 'Server');
      Params.Values['Database'] := TArquivoINI.LerIni('FIREBIRD', 'Database');
      Params.Values['User_name'] := TArquivoINI.LerIni('FIREBIRD', 'User_name');
      Params.Values['Password'] := TArquivoINI.LerIni('FIREBIRD', 'Password');
      Connected := True;
{$ENDIF}
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Ocorreu uma Falha na configura��o no Banco Firebird! ' + E.Message);
      Conexao.Connected := false;
    end;
  end;
end;

class procedure TArquivoINI.ConectarBancoOracle(Conexao: TADOConnection);
begin
  try
    with Conexao do
    begin
      Connected := false;
      LoginPrompt := false;
      ConnectionString := 'Provider=OraOLEDB.Oracle.1;' + 'Password=' + 'west912' + ';' + 'Persist Security Info=True;' + 'User ID=' + 'lucivalsc' + ';' +
        'Data Source=' + TArquivoINI.LerIni('ORACLE', 'SID');
      Connected := True;
    end;
  except
    on E: Exception do
    begin
      Conexao.Connected := false;
    end;
  end;
end;

class function TArquivoINI.LerIni(Chave1, Chave2, ValorPadrao: String): String;
var
  Arquivo: String;
  FileINI: TIniFile;
begin
{$IFDEF MSWINDOWS}
  Arquivo := ExtractFilePath(ParamStr(0)) + Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1) + '.ini';
  Result := ValorPadrao;
  try
    FileINI := TIniFile.Create(Arquivo);
    if FileExists(Arquivo) then
      Result := FileINI.ReadString(Chave1, Chave2, ValorPadrao);
  finally
    FreeAndNil(FileINI)
  end;
{$ENDIF }
end;

end.
