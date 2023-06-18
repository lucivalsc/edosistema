// ignore_for_file: use_build_context_synchronously

import 'package:edo_sistema/data/banco_controller.dart';
import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/data/http_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConferenciaStore {
  Databasepadrao banco = Databasepadrao.instance;
  HttpApi api = HttpApi();
  int indiceItemSelecionado = 0;
  final TextEditingController pesquisar = TextEditingController();
  final TextEditingController quantidade = TextEditingController();
  final TextEditingController localStoque = TextEditingController();

  // List<Map<String, Object?>> lista = [];
  List lista = [];
  pesquisarProduto(BuildContext context, String pesquisa) async {
    lista = await api.pesquisarProduto(context, pesquisa);
    // lista = await banco.pesquisarProduto(pesquisa);
  }

  List<Map<String, Object?>> listaconferencia = [];
  int totalProdutos = 0;
  pesquisarconferencia() async {
    totalProdutos = 0;
    // listaconferencia = await banco.pesquisarconferencia();
    for (int i = 0; i < listaconferencia.length; i++) {
      totalProdutos = totalProdutos +
          int.parse(listaconferencia[i]['QTDE_NOVA'].toString());
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

  Future<bool> verificarItemPedido(
      BuildContext context, String numPedido, String codProd) async {
    var lista = await banco.pesquisarPedidoItem(numPedido, codProd);
    if (lista.isNotEmpty) {
      if (lista[0]['QTD_PROD'] != quantidade.text) {
        Comum().mensagem(
            context, 'Quantidade digitada não confere com a solicitada.');
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  salvarconferencia(BuildContext context, dynamic item, numPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await verificarItemPedido(
      context,
      numPedido,
      item['COD_PROD'].toString(),
    )) {
      banco.atualizarPedido(
        quantidade.text,
        prefs.getString('UCLOGIN'),
        numPedido,
        item['COD_PROD'].toString(),
      );
      Comum().mensagem(context, 'Item inserido com sucesso.');
    } else {
      Comum().mensagem(context, 'Item já cadastrado');
    }
  }

  Future<List<Map<String, Object?>>> conferenciaPedido(
      BuildContext context, String numPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loja = prefs.getString('COD_LOJA');
    await api.conferenciaPedido(context, numPedido, loja!);

    return await banco.pesquisarPedido(numPedido);
  }
}
