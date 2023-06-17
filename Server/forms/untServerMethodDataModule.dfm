object ServerModule: TServerModule
  OldCreateOrder = False
  OnCreate = ServerMethodDataModuleCreate
  Encoding = esASCII
  QueuedRequest = False
  Height = 451
  Width = 464
  object DWServerEvents1: TDWServerEvents
    IgnoreInvalidParams = False
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
        EventName = 'MobileDados'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventsReceberDadosReplyEvent
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
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'pesquisar'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'Produtos'
        EventName = 'Produtos'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsProdutosReplyEventByType
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
        OnReplyEvent = DWServerEvents1EventsLoginReplyEvent
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
        OnReplyEventByType = DWServerEvents1EventsInventarioReplyEventByType
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovInteger
            ParamName = 'num_pedi'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'cod_loja'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'ConferenciaPedido'
        EventName = 'ConferenciaPedido'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsConferenciaPedidoReplyEventByType
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
        Name = 'Conferencia'
        EventName = 'Conferencia'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventsConferenciaReplyEvent
      end
      item
        Routes = [crAll]
        NeedAuthorization = True
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'num_pedi'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'uclogin'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'Separar'
        EventName = 'Separar'
        OnlyPreDefinedParams = False
        OnReplyEvent = DWServerEvents1EventsSepararReplyEvent
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
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'pesquisar'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'ProdutosContagem'
        EventName = 'ProdutosContagem'
        OnlyPreDefinedParams = False
        OnReplyEventByType = DWServerEvents1EventsProdutosContagemReplyEventByType
      end>
    Left = 264
    Top = 152
  end
  object RESTDWPoolerDB1: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD1
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 264
    Top = 88
  end
  object RESTDWDriverFD1: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection1
    Left = 264
    Top = 24
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'DriverID=FB')
    LoginPrompt = False
    Left = 104
    Top = 24
  end
  object FDQPadrao: TFDQuery
    Connection = FDConnection1
    Left = 104
    Top = 88
  end
  object pDataSet2: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 104
    Top = 152
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConnection1
    StoredProcName = 'SP_PROCESSA_COLETA'
    Left = 104
    Top = 216
    ParamData = <
      item
        Position = 1
        Name = 'ID_OPERACAO'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'RETORNO'
        DataType = ftString
        ParamType = ptOutput
        Size = 100
      end>
  end
  object FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink
    FileAppend = True
    FileColumns = [tiRefNo, tiTime, tiThreadID, tiClassName, tiObjID, tiMsgText]
    Left = 104
    Top = 280
  end
  object pDataSet: TRESTDWClientSQL
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
    ThreadRequest = False
    RaiseErrors = True
    ActionCursor = crSQLWait
    ReflectChanges = False
    Left = 264
    Top = 216
  end
end
