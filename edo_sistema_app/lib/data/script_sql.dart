class ScriptSql {
  static const sqlPRODUTOS = '''
                                  CREATE TABLE PRODUTOS (
                                      COD_PROD   TEXT,
                                      COD_ORG    TEXT,
                                      PRE_CUS    TEXT,
                                      PRE_VEN    TEXT,
                                      COD_GRP    TEXT,
                                      DES_GRP    TEXT,
                                      DES_PROD   TEXT,
                                      PER_DESC   TEXT,
                                      FLG_TIPO   TEXT,
                                      COD_BARR   TEXT,
                                      NCM        TEXT,
                                      COD_GENERO TEXT,
                                      UNI_MED    TEXT,
                                      APLICA     TEXT,
                                      DES_MARC   TEXT,
                                      QTD_ATUAL  TEXT,
                                      QTD_MAX    TEXT,
                                      LOC_ESTO   TEXT,
                                      NOM_LOJA   TEXT,
                                      DATA_ENT   TEXT,
                                      PRE_DESC   TEXT,
                                      DATA_ALT   TEXT,
                                      MASTER     TEXT,
                                      DATEUSER   TEXT
                                  );
''';
  static const sqlSIGTBPRDHIST = '''
                                    CREATE TABLE SIGTBPRDHIST (
                                        NUM_LANC  INTEGER       PRIMARY KEY AUTOINCREMENT,
                                        DATA      TEXT,
                                        COD_PROD  TEXT,
                                        QTDE_ANT  TEXT,
                                        QTDE_NOVA TEXT,
                                        TIPO      TEXT,
                                        UCLOGIN   TEXT,
                                        VLR_CUSTO TEXT,
                                        VLR_VENDA TEXT,
                                        COD_LOJA  TEXT,
                                        DESCRICAO TEXT,
                                        LOC_ESTO  TEXT,
                                        COD_BARR  TEXT
                                    );
''';
  static const sqlCONTAGEMESTOQUE = '''
                                    CREATE TABLE CONTAGEM_ESTOQUE (
                                        NUM_LANC  INTEGER       PRIMARY KEY AUTOINCREMENT,
                                        DATA      TEXT,
                                        COD_PROD  TEXT,
                                        QTDE_ANT  TEXT,
                                        QTDE_NOVA TEXT,
                                        TIPO      TEXT,
                                        UCLOGIN   TEXT,
                                        VLR_CUSTO TEXT,
                                        VLR_VENDA TEXT,
                                        COD_LOJA  TEXT,
                                        DESCRICAO TEXT,
                                        LOC_ESTO  TEXT,
                                        COD_BARR  TEXT
                                    );
''';
  static const sqlCONFERENCIA = '''
                                    CREATE TABLE CONFERENCIA (
                                        DAT_PEDI        TEXT,
                                        COD_VEN         TEXT,
                                        COD_CLI         TEXT,
                                        VLR_TOTA        TEXT,
                                        NUM_PEDI        TEXT,
                                        LOCALVENDA      TEXT,
                                        NOM_CLI         TEXT,
                                        COD_PROD        TEXT,
                                        QTD_PROD        TEXT,
                                        DES_PROD        TEXT,
                                        QTD_CONFERENCIA TEXT,
                                        UCLOGIN         TEXT 
                                    );
''';
}
