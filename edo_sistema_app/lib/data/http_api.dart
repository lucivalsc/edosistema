// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:edo_sistema/data/banco_controller.dart';
import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/data/padrao.dart';
import 'package:edo_sistema/model/conferencia_pedido_model.dart';
import 'package:edo_sistema/model/produtos_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String versao = 'V. [1.22.11.18]';

class HttpApi {
  Databasepadrao banco = Databasepadrao.instance;
  Future<int?> retornarProdutos(BuildContext? context) async {
    if (await testarConexao(context) == true) {
      var url = Uri.parse('${await baseUrl()}Produtos');
      final http.Response response =
          await http.get(url, headers: {'authorization': await basicAuth()});

      if (response.statusCode == 200) {
        banco.deletarTudo('PRODUTOS');
        List<dynamic> lista = jsonDecode(response.body);
        for (var item in lista) {
          await banco.inserir('PRODUTOS', ProdutosModel.fromJson(item));
        }
        return lista.length;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  enviarInventario(BuildContext? context, List dados) async {
    if (await testarConexao(context) == true) {
      var dado = jsonEncode(dados);
      var url = Uri.parse('${await baseUrl()}Inventario?Dados=$dado');
      final http.Response response = await http.post(
        url,
        headers: {
          'authorization': await basicAuth(),
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: dado,
      );

      if (response.statusCode == 200) {
        banco.deletarTudo('SIGTBPRDHIST');
      }
    }
  }

  enviarContagem(BuildContext? context, List dados) async {
    if (await testarConexao(context) == true) {
      var dado = jsonEncode(dados);
      var url = Uri.parse('${await baseUrl()}Inventario?Dados=$dado');
      final http.Response response = await http.post(
        url,
        headers: {
          'authorization': await basicAuth(),
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: dado,
      );

      if (response.statusCode == 200) {
        banco.deletarTudo('CONTAGEM_ESTOQUE');
      }
    }
  }

  Future<List> pesquisarProduto(BuildContext? context, String pesquisar,
      {bool? rota}) async {
    if (await testarConexao(context) == true) {
      Uri url;
      if (rota != null) {
        url = Uri.parse(
          '${await baseUrl()}produtosContagem?pesquisar=$pesquisar',
        );
      } else {
        url = Uri.parse(
          '${await baseUrl()}produtos?pesquisar=$pesquisar',
        );
      }
      final http.Response response = await http.get(
        url,
        headers: {
          'authorization': await basicAuth(),
          'pesquisar': pesquisar,
        },
      );

      if (response.statusCode == 200 && response.body != 'Erro') {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  separarParaConferencia(BuildContext? context, String numPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await testarConexao(context) == true) {
      var url = Uri.parse(
        '${await baseUrl()}separar?num_pedi=$numPedido&uclogin=${prefs.getString('UCLOGIN')}',
      );
      var uclogin = prefs.getString('UCLOGIN') ?? '';
      final http.Response response = await http.get(
        url,
        headers: {
          'authorization': await basicAuth(),
          'num_pedi': numPedido,
          'uclogin': uclogin,
        },
      );

      if (response.statusCode == 200) {}
    }
  }

  enviarConferencia(BuildContext? context, List dados) async {
    if (await testarConexao(context) == true) {
      var dado = jsonEncode(dados);
      var url = Uri.parse('${await baseUrl()}Conferencia?Dados=$dado');

      final http.Response response = await http.post(
        url,
        headers: {
          'authorization': await basicAuth(),
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: dado,
      );

      if (response.statusCode == 200) {
        banco.deletarTudo('CONFERENCIA');
      }
    }
  }

  conferenciaPedido(BuildContext context, String numPedido, String loja) async {
    if (await testarConexao(context) == true) {
      var url = Uri.parse(
          '${await baseUrl()}ConferenciaPedido?num_pedi=$numPedido&cod_loja=$loja');
      final http.Response response = await http.get(
        url,
        headers: {
          'authorization': await basicAuth(),
          'num_pedi': numPedido,
          'cod_loja': loja,
        },
      );

      if (response.statusCode == 200) {
        banco.deletarTudo('CONFERENCIA');
        List lista = jsonDecode(response.body);
        for (var item in lista) {
          await banco.inserir(
              'CONFERENCIA', ConferenciaPedidoModel.fromJson(item));
        }
      } else {
        Comum().mensagem(context, 'Nenhum pedido para conferência!');
      }
    }
  }

  limparBanco() async {
    banco.deletarTudo('PRODUTOS');
    banco.deletarTudo('SIGTBPRDHIST');
    banco.deletarTudo('CONFERENCIA');
  }
}
