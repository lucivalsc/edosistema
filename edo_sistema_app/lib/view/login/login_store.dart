import 'dart:convert';

import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/data/padrao.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginStore {
  Future<bool> efetuarLogin(
      BuildContext context, String usuario, String senha) async {
    if (usuario.isNotEmpty && senha.isNotEmpty) {
      if (await testarConexao(context) == true) {
        var url = Uri.parse('${await baseUrl()}Login');
        final http.Response response = await http.get(
          url,
          headers: {
            'authorization': await basicAuth(),
            'usuario': usuario,
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> lista = jsonDecode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('UCIDUSER', lista[0]['UCIDUSER'].toString());
          await prefs.setString('UCUSERNAME', lista[0]['UCUSERNAME']);
          await prefs.setString('UCEMAIL', lista[0]['UCEMAIL']);
          await prefs.setString('UCLOGIN', lista[0]['UCLOGIN']);
          await prefs.setString('UCPASSWORD', lista[0]['UCPASSWORD']);
          await prefs.setString('COD_LOJA', lista[0]['COD_LOJA'].toString());
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      Comum().mensagem(context, 'Usuário ou senha inválidos.');
      return false;
    }
  }

  Future<bool> efetuarLoginOld(
      BuildContext context, String usuario, String senha) async {
    if (usuario.isNotEmpty && senha.isNotEmpty) {
      if (await testarConexao(context) == true) {
        var url =
            Uri.parse('${await baseUrl()}Login?Usuario=$usuario&Senha=$senha');
        final http.Response response =
            await http.get(url, headers: {'authorization': await basicAuth()});

        if (response.statusCode == 200) {
          List<dynamic> lista = jsonDecode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('UCIDUSER', lista[0]['UCIDUSER'].toString());
          await prefs.setString('UCUSERNAME', lista[0]['UCUSERNAME']);
          await prefs.setString('UCEMAIL', lista[0]['UCEMAIL']);
          await prefs.setString('UCLOGIN', lista[0]['UCLOGIN']);
          await prefs.setString('UCPASSWORD', lista[0]['UCPASSWORD']);
          await prefs.setString('COD_LOJA', lista[0]['COD_LOJA'].toString());
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      Comum().mensagem(context, 'Usuário ou senha inválidos.');
      return false;
    }
  }
}
