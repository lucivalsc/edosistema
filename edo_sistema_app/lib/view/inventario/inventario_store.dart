// ignore_for_file: use_build_context_synchronously

import 'package:edo_sistema/data/banco_controller.dart';
import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/data/http_api.dart';
import 'package:edo_sistema/model/inventario_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventarioStore {
  Databasepadrao banco = Databasepadrao.instance;
  HttpApi api = HttpApi();
  int indiceItemSelecionado = 0;
  final TextEditingController pesquisar = TextEditingController();
  final TextEditingController quantidade = TextEditingController();
  final TextEditingController localStoque = TextEditingController();
  final TextEditingController codigoBarras = TextEditingController();

  // List<Map<String, Object?>> lista = [];
  List lista = [];

  pesquisarProduto(BuildContext context, String pesquisa) async {
    // lista = await banco.pesquisarProduto(pesquisa);
    lista = await api.pesquisarProduto(context, pesquisa);
  }

  List<Map<String, Object?>> listaInventario = [];
  int totalProdutos = 0;
  pesquisarInventario() async {
    totalProdutos = 0;
    listaInventario = await banco.pesquisarInventario();
    for (int i = 0; i < listaInventario.length; i++) {
      totalProdutos =
          totalProdutos + int.parse(listaInventario[i]['QTDE_NOVA'].toString());
    }
  }

  Future<bool> itemNaoCadastrado(String codigo) async {
    List lista = await banco.itemNaoCadastrado('SIGTBPRDHIST', codigo);
    if (lista.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  salvarInventario(BuildContext context, dynamic item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await itemNaoCadastrado(item['COD_PROD'].toString())) {
      InventarioModel inv = InventarioModel();
      inv.QTDE_NOVA = quantidade.text;
      inv.QTDE_ANT = item['QTD_ATUAL'].toString();
      inv.COD_PROD = item['COD_PROD'].toString();
      inv.COD_LOJA = prefs.getString('COD_LOJA');
      inv.UCLOGIN = prefs.getString('UCLOGIN');
      inv.VLR_CUSTO = item['PRE_CUS'].toString();
      inv.VLR_VENDA = item['PRE_VEN'].toString();
      inv.DATA = DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now());
      inv.DESCRICAO = item['DES_PROD'].toString();
      inv.LOC_ESTO = localStoque.text;
      inv.COD_BARR = codigoBarras.text;
      inv.TIPO = 'I';

      banco.inserir('SIGTBPRDHIST', inv);
      Comum().mensagem(context, 'Item inserido com sucesso.');
    } else {
      Comum().mensagem(context, 'Item já cadastrado');
    }
  }
}
