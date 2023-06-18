import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String versao = 'Versão: 1.23.6.18'; //v.ano.mes.dia

bool inMostraLogo = true;
bool inMostraImagem = true;

String basicUrlAuth = '';

Future<String> basicAuth() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String username = prefs.getString('usuario') ?? '';
  String password = prefs.getString('senha') ?? '';
  basicUrlAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  return basicUrlAuth;
}

Map<String, String> headers = {
  'content-type': 'application/json',
  'accept': 'application/json',
  'authorization': basicUrlAuth
};

Future<String> baseUrl() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String ip = prefs.getString('ip') ?? '';
  String porta = prefs.getString('porta') ?? '';

  return 'http://$ip:$porta/';
}

Future<bool?> testarConexao(BuildContext? context) async {
  var url = Uri.parse(await baseUrl());
  try {
    await http.get(url, headers: {'authorization': await basicAuth()}).timeout(
        const Duration(milliseconds: 2500));
    return true;
  } catch (e) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: const Text('Erro ao conectar no servidor.'),
        action: SnackBarAction(
          label: 'Aviso',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
    return false;
  }
}
