object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 458
  Width = 709
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 96
    Top = 269
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 96
    Top = 328
  end
  object DWClientEvents1: TDWClientEvents
    ServerEventName = 'TServerModule.DWServerEvents1'
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    RESTClientPooler = RESTClientPooler1
    Events = <
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'Dados'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odOUT
            ObjectValue = ovString
            ParamName = 'Tabela'
            Encoded = True
          end>
        JsonMode = jmDataware
        Name = 'ReceberDados'
        EventName = 'ReceberDados'
        OnlyPreDefinedParams = False
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'Data'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'Produtos'
        EventName = 'Produtos'
        OnlyPreDefinedParams = False
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'Usuario'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'Senha'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'Login'
        EventName = 'Login'
        OnlyPreDefinedParams = False
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'Dados'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'Inventario'
        EventName = 'Inventario'
        OnlyPreDefinedParams = False
      end>
    Left = 96
    Top = 151
  end
  object RESTClientPooler1: TRESTClientPooler
    DataCompression = True
    Encoding = esUtf8
    hEncodeStrings = True
    Host = '192.168.0.2'
    AuthenticationOptions.AuthorizationOption = rdwAOBasic
    AuthenticationOptions.OptionParams.AuthDialog = True
    AuthenticationOptions.OptionParams.CustomDialogAuthMessage = 'Protected Space...'
    AuthenticationOptions.OptionParams.Custom404TitleMessage = '(404) The address you are looking for does not exist'
    AuthenticationOptions.OptionParams.Custom404BodyMessage = '404'
    AuthenticationOptions.OptionParams.Custom404FooterMessage = 'Take me back to <a href="./">Home REST Dataware'
    ProxyOptions.BasicAuthentication = False
    ProxyOptions.ProxyPort = 0
    RequestTimeOut = 10000
    ThreadRequest = False
    AllowCookies = False
    RedirectMaximum = 0
    HandleRedirects = False
    FailOver = False
    FailOverConnections = <>
    FailOverReplaceDefaults = False
    BinaryRequest = False
    CriptOptions.Use = False
    CriptOptions.Key = 'RDWBASEKEY256'
    UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/41.0.2227.0 Safari/537.36'
    Left = 96
    Top = 92
  end
  object RESTDWClientSQL1: TRESTDWClientSQL
    Active = False
    Filtered = False
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    BinaryCompatibleMode = False
    MasterCascadeDelete = True
    BinaryRequest = False
    Datapacks = -1
    DataCache = False
    MassiveType = mtMassiveCache
    Params = <>
    CacheUpdateRecords = True
    AutoCommitData = False
    AutoRefreshAfterCommit = False
    RaiseErrors = True
    ActionCursor = crSQLWait
    ReflectChanges = False
    Left = 96
    Top = 210
  end
  object fdcConexao: TFDConnection
    Params.Strings = (
      'Database=D:\Github\Freenlancer\RicardoJurado\App\bd\bd.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 240
    Top = 96
  end
  object fdqInventario: TFDQuery
    Connection = fdcConexao
    SQL.Strings = (
      'select * from SIGTBPRDHIST')
    Left = 496
    Top = 120
    object fdqInventarioNUM_LANC: TFDAutoIncField
      FieldName = 'NUM_LANC'
      Origin = 'NUM_LANC'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object fdqInventarioDATA: TDateTimeField
      FieldName = 'DATA'
      Origin = 'DATA'
    end
    object fdqInventarioCOD_PROD: TStringField
      FieldName = 'COD_PROD'
      Origin = 'COD_PROD'
    end
    object fdqInventarioQTDE_ANT: TIntegerField
      FieldName = 'QTDE_ANT'
      Origin = 'QTDE_ANT'
    end
    object fdqInventarioQTDE_NOVA: TIntegerField
      FieldName = 'QTDE_NOVA'
      Origin = 'QTDE_NOVA'
    end
    object fdqInventarioTIPO: TStringField
      FieldName = 'TIPO'
      Origin = 'TIPO'
      FixedChar = True
      Size = 1
    end
    object fdqInventarioUCLOGIN: TStringField
      FieldName = 'UCLOGIN'
      Origin = 'UCLOGIN'
      Size = 30
    end
    object fdqInventarioVLR_CUSTO: TFloatField
      FieldName = 'VLR_CUSTO'
      Origin = 'VLR_CUSTO'
    end
    object fdqInventarioVLR_VENDA: TFloatField
      FieldName = 'VLR_VENDA'
      Origin = 'VLR_VENDA'
    end
    object fdqInventarioCOD_LOJA: TIntegerField
      FieldName = 'COD_LOJA'
      Origin = 'COD_LOJA'
    end
    object fdqInventarioDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      Size = 255
    end
    object fdqInventarioLOC_ESTO: TStringField
      FieldName = 'LOC_ESTO'
      Origin = 'LOC_ESTO'
      Size = 255
    end
  end
  object fdqCons: TFDQuery
    Connection = fdcConexao
    Left = 498
    Top = 64
  end
  object fdqProdSolicitacao: TFDQuery
    Connection = fdcConexao
    SQL.Strings = (
      'select '
      '*'
      'FROM PRODUTOS')
    Left = 496
    Top = 178
    object fdqProdSolicitacaoCOD_PROD: TStringField
      FieldName = 'COD_PROD'
      Origin = 'COD_PROD'
    end
    object fdqProdSolicitacaoCOD_ORG: TStringField
      FieldName = 'COD_ORG'
      Origin = 'COD_ORG'
    end
    object fdqProdSolicitacaoPRE_CUS: TFloatField
      FieldName = 'PRE_CUS'
      Origin = 'PRE_CUS'
      currency = True
    end
    object fdqProdSolicitacaoPRE_VEN: TFloatField
      FieldName = 'PRE_VEN'
      Origin = 'PRE_VEN'
      currency = True
    end
    object fdqProdSolicitacaoCOD_GRP: TStringField
      FieldName = 'COD_GRP'
      Origin = 'COD_GRP'
      Size = 3
    end
    object fdqProdSolicitacaoDES_GRP: TStringField
      FieldName = 'DES_GRP'
      Origin = 'DES_GRP'
      Size = 30
    end
    object fdqProdSolicitacaoDES_PROD: TStringField
      FieldName = 'DES_PROD'
      Origin = 'DES_PROD'
      Size = 60
    end
    object fdqProdSolicitacaoPER_DESC: TFloatField
      FieldName = 'PER_DESC'
      Origin = 'PER_DESC'
    end
    object fdqProdSolicitacaoFLG_TIPO: TStringField
      FieldName = 'FLG_TIPO'
      Origin = 'FLG_TIPO'
      FixedChar = True
      Size = 1
    end
    object fdqProdSolicitacaoCOD_BARR: TStringField
      FieldName = 'COD_BARR'
      Origin = 'COD_BARR'
      Size = 30
    end
    object fdqProdSolicitacaoNCM: TStringField
      FieldName = 'NCM'
      Origin = 'NCM'
      Size = 8
    end
    object fdqProdSolicitacaoCOD_GENERO: TIntegerField
      FieldName = 'COD_GENERO'
      Origin = 'COD_GENERO'
    end
    object fdqProdSolicitacaoUNI_MED: TStringField
      FieldName = 'UNI_MED'
      Origin = 'UNI_MED'
      FixedChar = True
      Size = 2
    end
    object fdqProdSolicitacaoAPLICA: TStringField
      FieldName = 'APLICA'
      Origin = 'APLICA'
      Size = 800
    end
    object fdqProdSolicitacaoDES_MARC: TStringField
      FieldName = 'DES_MARC'
      Origin = 'DES_MARC'
      Size = 30
    end
    object fdqProdSolicitacaoQTD_ATUAL: TIntegerField
      FieldName = 'QTD_ATUAL'
      Origin = 'QTD_ATUAL'
    end
    object fdqProdSolicitacaoQTD_MAX: TIntegerField
      FieldName = 'QTD_MAX'
      Origin = 'QTD_MAX'
    end
    object fdqProdSolicitacaoLOC_ESTO: TStringField
      FieldName = 'LOC_ESTO'
      Origin = 'LOC_ESTO'
      Size = 11
    end
    object fdqProdSolicitacaoNOM_LOJA: TStringField
      FieldName = 'NOM_LOJA'
      Origin = 'NOM_LOJA'
    end
    object fdqProdSolicitacaoDATA_ENT: TDateTimeField
      FieldName = 'DATA_ENT'
      Origin = 'DATA_ENT'
    end
    object fdqProdSolicitacaoPRE_DESC: TFloatField
      FieldName = 'PRE_DESC'
      Origin = 'PRE_DESC'
      currency = True
    end
    object fdqProdSolicitacaoDATA_ALT: TDateTimeField
      FieldName = 'DATA_ALT'
      Origin = 'DATA_ALT'
    end
    object fdqProdSolicitacaoMASTER: TStringField
      FieldName = 'MASTER'
      Origin = 'MASTER'
      Size = 1365
    end
  end
  object fdqFilial: TFDQuery
    Connection = fdcConexao
    SQL.Strings = (
      'SELECT * FROM FILIAL ORDER BY CODIGOFILIAL')
    Left = 496
    Top = 240
    object fdqFilialCODIGOFILIAL: TStringField
      FieldName = 'CODIGOFILIAL'
      Origin = 'CODIGOFILIAL'
      FixedChar = True
      Size = 3
    end
    object fdqFilialNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 40
    end
    object fdqFilialFANTASIA: TStringField
      FieldName = 'FANTASIA'
      Origin = 'FANTASIA'
    end
    object fdqFilialCNPJ: TStringField
      FieldName = 'CNPJ'
      Origin = 'CNPJ'
      FixedChar = True
      Size = 18
    end
    object fdqFilialINSCRICAO: TStringField
      FieldName = 'INSCRICAO'
      Origin = 'INSCRICAO'
      Size = 18
    end
    object fdqFilialENDERECO: TStringField
      FieldName = 'ENDERECO'
      Origin = 'ENDERECO'
      Size = 40
    end
    object fdqFilialCEP: TStringField
      FieldName = 'CEP'
      Origin = 'CEP'
      Size = 10
    end
    object fdqFilialCIDADE: TStringField
      FieldName = 'CIDADE'
      Origin = 'CIDADE'
    end
    object fdqFilialBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Origin = 'BAIRRO'
    end
    object fdqFilialESTADO: TStringField
      FieldName = 'ESTADO'
      Origin = 'ESTADO'
      FixedChar = True
      Size = 2
    end
    object fdqFilialTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Origin = 'TELEFONE'
    end
    object fdqFilialCODIGOMUNICIPIO: TStringField
      FieldName = 'CODIGOMUNICIPIO'
      Origin = 'CODIGOMUNICIPIO'
      FixedChar = True
      Size = 7
    end
    object fdqFilialNUMERO: TStringField
      FieldName = 'NUMERO'
      Origin = 'NUMERO'
      Size = 10
    end
    object fdqFilialREFERENCIA: TStringField
      FieldName = 'REFERENCIA'
      Origin = 'REFERENCIA'
    end
    object fdqFilialFAX: TStringField
      FieldName = 'FAX'
      Origin = 'FAX'
    end
    object fdqFilialEMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 100
    end
    object fdqFilialSITE: TStringField
      FieldName = 'SITE'
      Origin = 'SITE'
      Size = 100
    end
    object fdqFilialLOGO: TBlobField
      FieldName = 'LOGO'
      Origin = 'LOGO'
    end
    object fdqFilialCNAE: TStringField
      FieldName = 'CNAE'
      Origin = 'CNAE'
      FixedChar = True
      Size = 7
    end
  end
  object fdqEmpresa: TFDQuery
    Connection = fdcConexao
    SQL.Strings = (
      'SELECT * FROM EMPRESA ORDER BY COD_EMPRESA')
    Left = 496
    Top = 304
    object fdqEmpresaCOD_EMPRESA: TIntegerField
      FieldName = 'COD_EMPRESA'
      Origin = 'COD_EMPRESA'
      Required = True
    end
    object fdqEmpresaRAZAO_SOCIAL: TStringField
      FieldName = 'RAZAO_SOCIAL'
      Origin = 'RAZAO_SOCIAL'
      Size = 50
    end
    object fdqEmpresaCNPJ_CPF: TStringField
      FieldName = 'CNPJ_CPF'
      Origin = 'CNPJ_CPF'
      Size = 14
    end
    object fdqEmpresaFANTASIA: TStringField
      FieldName = 'FANTASIA'
      Origin = 'FANTASIA'
      Size = 28
    end
    object fdqEmpresaCONTADOR: TStringField
      FieldName = 'CONTADOR'
      Origin = 'CONTADOR'
      Size = 34
    end
    object fdqEmpresaDATA_ADAPTADOR: TDateField
      FieldName = 'DATA_ADAPTADOR'
      Origin = 'DATA_ADAPTADOR'
    end
    object fdqEmpresaCOD_CNAE: TIntegerField
      FieldName = 'COD_CNAE'
      Origin = 'COD_CNAE'
    end
    object fdqEmpresaVERSAO: TStringField
      FieldName = 'VERSAO'
      Origin = 'VERSAO'
      Size = 9
    end
    object fdqEmpresaATUALIZADO_ECF: TStringField
      FieldName = 'ATUALIZADO_ECF'
      Origin = 'ATUALIZADO_ECF'
      Size = 1
    end
    object fdqEmpresaESTRUTURA_01: TStringField
      FieldName = 'ESTRUTURA_01'
      Origin = 'ESTRUTURA_01'
      Size = 35
    end
    object fdqEmpresaSITUACAO: TStringField
      FieldName = 'SITUACAO'
      Origin = 'SITUACAO'
      Size = 1
    end
    object fdqEmpresaCHAVE: TStringField
      FieldName = 'CHAVE'
      Origin = 'CHAVE'
      Size = 50
    end
    object fdqEmpresaDATA_FECHAMENTO_DIARIO: TDateField
      FieldName = 'DATA_FECHAMENTO_DIARIO'
      Origin = 'DATA_FECHAMENTO_DIARIO'
    end
    object fdqEmpresaCLASS_FISCAL: TStringField
      FieldName = 'CLASS_FISCAL'
      Origin = 'CLASS_FISCAL'
      Size = 1
    end
    object fdqEmpresaADAPTADOR: TStringField
      FieldName = 'ADAPTADOR'
      Origin = 'ADAPTADOR'
      Size = 1
    end
    object fdqEmpresaDATA_BACKUP: TDateField
      FieldName = 'DATA_BACKUP'
      Origin = 'DATA_BACKUP'
    end
    object fdqEmpresaAJUSTA_VERSAO: TStringField
      FieldName = 'AJUSTA_VERSAO'
      Origin = 'AJUSTA_VERSAO'
      Size = 30
    end
    object fdqEmpresaDATA_MOVIMENTO: TDateField
      FieldName = 'DATA_MOVIMENTO'
      Origin = 'DATA_MOVIMENTO'
    end
    object fdqEmpresaMENSAGEM_1: TStringField
      FieldName = 'MENSAGEM_1'
      Origin = 'MENSAGEM_1'
      Size = 230
    end
    object fdqEmpresaMENSAGEM_2: TStringField
      FieldName = 'MENSAGEM_2'
      Origin = 'MENSAGEM_2'
      Size = 230
    end
    object fdqEmpresaMENSAGEM_3: TStringField
      FieldName = 'MENSAGEM_3'
      Origin = 'MENSAGEM_3'
      Size = 230
    end
    object fdqEmpresaMENSAGEM_4: TStringField
      FieldName = 'MENSAGEM_4'
      Origin = 'MENSAGEM_4'
      Size = 230
    end
    object fdqEmpresaENVIA_XML: TStringField
      FieldName = 'ENVIA_XML'
      Origin = 'ENVIA_XML'
      Size = 7
    end
    object fdqEmpresaMES_ANO_SPED: TStringField
      FieldName = 'MES_ANO_SPED'
      Origin = 'MES_ANO_SPED'
      Size = 7
    end
    object fdqEmpresaESTRUTURA_02: TStringField
      FieldName = 'ESTRUTURA_02'
      Origin = 'ESTRUTURA_02'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_03: TStringField
      FieldName = 'ESTRUTURA_03'
      Origin = 'ESTRUTURA_03'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_04: TStringField
      FieldName = 'ESTRUTURA_04'
      Origin = 'ESTRUTURA_04'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_05: TStringField
      FieldName = 'ESTRUTURA_05'
      Origin = 'ESTRUTURA_05'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_06: TStringField
      FieldName = 'ESTRUTURA_06'
      Origin = 'ESTRUTURA_06'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_07: TStringField
      FieldName = 'ESTRUTURA_07'
      Origin = 'ESTRUTURA_07'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_08: TStringField
      FieldName = 'ESTRUTURA_08'
      Origin = 'ESTRUTURA_08'
      Size = 35
    end
    object fdqEmpresaESTRUTURA_09: TStringField
      FieldName = 'ESTRUTURA_09'
      Origin = 'ESTRUTURA_09'
      Size = 35
    end
    object fdqEmpresaDATA_CONSULTA: TDateField
      FieldName = 'DATA_CONSULTA'
      Origin = 'DATA_CONSULTA'
    end
    object fdqEmpresaDATA_NOTICIA: TDateField
      FieldName = 'DATA_NOTICIA'
      Origin = 'DATA_NOTICIA'
    end
    object fdqEmpresaLIBERA_ACESSO: TStringField
      FieldName = 'LIBERA_ACESSO'
      Origin = 'LIBERA_ACESSO'
      Size = 250
    end
    object fdqEmpresaSTATUS_EXPORTA: TSmallintField
      FieldName = 'STATUS_EXPORTA'
      Origin = 'STATUS_EXPORTA'
    end
    object fdqEmpresaULTNSUC: TStringField
      FieldName = 'ULTNSUC'
      Origin = 'ULTNSUC'
      Size = 30
    end
  end
end
