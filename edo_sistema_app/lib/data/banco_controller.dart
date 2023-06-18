// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:edo_sistema/data/script_sql.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String databaseName = 'bd';
const int databaseVersion = 4;

class Databasepadrao {
  Databasepadrao._privateConstructor();
  static final Databasepadrao instance = Databasepadrao._privateConstructor();
  static Database? _database;

  Future<Database?> get db async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(ScriptSql.sqlCONFERENCIA);
    await db.execute(ScriptSql.sqlPRODUTOS);
    await db.execute(ScriptSql.sqlSIGTBPRDHIST);
    await db.execute(ScriptSql.sqlCONTAGEMESTOQUE);
  }

  Future<void> inserir(String tabela, emprestar) async {
    Database? dbPadrao = await db;
    await dbPadrao!.insert(tabela, emprestar.toJson());
  }

  Future<int> atualizar(String tabela, coluna, emprestar, id) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.update(
      tabela,
      emprestar.toJson(),
      where: "$coluna = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, Object?>>> pesquisarProduto(String pesquisa) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.query(
      'PRODUTOS',
      where: ' MASTER LIKE ? ',
      whereArgs: ['%$pesquisa%'],
      orderBy: 'MASTER',
    );
  }

  Future<List<Map<String, Object?>>> pesquisarPedidoItem(
      String numPedido, String codProd) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.query(
      'CONFERENCIA',
      where: ' NUM_PEDI LIKE ? AND COD_PROD = ? ',
      whereArgs: [numPedido, codProd],
    );
  }

  Future<int> atualizarPedido(quantidade, uclogin, numPedido, codProd) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.rawUpdate('''
                                        UPDATE CONFERENCIA SET 
                                        QTD_CONFERENCIA = "$quantidade", 
                                        UCLOGIN = "$uclogin" 
                                        WHERE NUM_PEDI = "$numPedido" 
                                        AND COD_PROD = "$codProd" 
                                    ''');
  }

  Future<List<Map<String, Object?>>> pesquisarPedido(String numPedi) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.rawQuery('''
                                    select distinct 
                                        c.NUM_PEDI,
                                        DAT_PEDI,
                                        c.NOM_CLI 
                                    from conferencia c
                                    where num_pedi = "$numPedi"
                                  ''');
  }

  Future<List<Map<String, Object?>>> listagemPedido(String numPedi) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.rawQuery('''select distinct c.*
                                        from conferencia c
                                        where c.QTD_CONFERENCIA is not null
                                            and num_pedi = "$numPedi"
                                  ''');
  }

  Future<List<Map<String, Object?>>> itemNaoCadastrado(
      String tabela, String codigo) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.query(
      tabela,
      where: ' COD_PROD = ? ',
      whereArgs: [codigo],
      orderBy: 'COD_PROD',
    );
  }

  Future<List<Map<String, Object?>>> pesquisarInventario() async {
    Database? dbPadrao = await db;
    return await dbPadrao!.query('SIGTBPRDHIST');
  }

  Future<List<Map<String, Object?>>> pesquisarContagem() async {
    Database? dbPadrao = await db;
    return await dbPadrao!.query('CONTAGEM_ESTOQUE');
  }

  Future deletarTudo(String tabela) async {
    Database? dbPadrao = await db;
    await dbPadrao!.delete(tabela);
  }

  Future<int> deletar(String tabela, coluna, id) async {
    Database? dbPadrao = await db;
    return await dbPadrao!.delete(
      tabela,
      where: "$coluna = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    Database? dbPadrao = await db;
    dbPadrao!.close();
  }
}
