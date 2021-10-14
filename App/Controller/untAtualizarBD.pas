unit untAtualizarBD;

interface

uses
  untDM;

type
  TAtualizaBD = class
  public
    class procedure Versao0001;
    class procedure Versao0002;
  end;

implementation

{ TArquivo }

class procedure TAtualizaBD.Versao0001;
begin
  if not (DM.ExisteCampo('SIGTBPRDHIST', 'NUM_LANC')) then
  begin
    DM.ExecutarAlteracao(' CREATE TABLE SIGTBPRDHIST ( '+
                        '     NUM_LANC  INTEGER       PRIMARY KEY AUTOINCREMENT, '+
                        '     DATA      DATETIME, '+
                        '     COD_PROD  VARCHAR (20), '+
                        '     QTDE_ANT  INTEGER, '+
                        '     QTDE_NOVA INTEGER, '+
                        '     TIPO      CHAR (1), '+
                        '     UCLOGIN   VARCHAR (30), '+
                        '     VLR_CUSTO DOUBLE, '+
                        '     VLR_VENDA DOUBLE, '+
                        '     COD_LOJA  INTEGER, '+
                        '     DESCRICAO VARCHAR (255)); ');
  end;
end;

class procedure TAtualizaBD.Versao0002;
begin
  if not (DM.ExisteCampo('PRODUTOS', 'COD_PROD')) then
  begin
    DM.ExecutarAlteracao(' CREATE TABLE COD_PROD ( '+
                        ' COD_PROD   VARCHAR (20), '+
                        ' COD_ORG    VARCHAR (20), '+
                        ' PRE_CUS    DOUBLE, '+
                        ' PRE_VEN    DOUBLE, '+
                        ' COD_GRP    VARCHAR (3), '+
                        ' DES_GRP    VARCHAR (30), '+
                        ' DES_PROD   VARCHAR (60), '+
                        ' PER_DESC   DOUBLE, '+
                        ' FLG_TIPO   CHAR (1), '+
                        ' COD_BARR   VARCHAR (30), '+
                        ' NCM        VARCHAR (8), '+
                        ' COD_GENERO INTEGER, '+
                        ' UNI_MED    CHAR (2), '+
                        ' APLICA     VARCHAR (800), '+
                        ' DES_MARC   VARCHAR (30), '+
                        ' QTD_ATUAL  INTEGER, '+
                        ' QTD_MAX    INTEGER, '+
                        ' LOC_ESTO   VARCHAR (11), '+
                        ' NOM_LOJA   VARCHAR (20), '+
                        ' DATA_ENT   DATETIME, '+
                        ' PRE_DESC   DOUBLE, '+
                        ' DATA_ALT   DATETIME, '+
                        ' MASTER     VARCHAR (1365)); ');

  end;
end;

end.

