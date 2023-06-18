import 'package:edo_sistema/data/banco_controller.dart';
import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/texto_entrada.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuracao extends StatefulWidget {
  const Configuracao({
    Key? key,
  }) : super(key: key);

  @override
  State<Configuracao> createState() => _ConfiguracaoState();
}

class _ConfiguracaoState extends State<Configuracao> {
  Databasepadrao banco = Databasepadrao.instance;
  final TextEditingController _host = TextEditingController();
  final TextEditingController _porta = TextEditingController();
  final TextEditingController _usuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  lerDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _host.text = prefs.getString('ip') ?? '';
    _porta.text = prefs.getString('porta') ?? '';
    _usuario.text = prefs.getString('usuario') ?? '';
    _senha.text = prefs.getString('senha') ?? '';
  }

  salvarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ip', _host.text.trim());
    await prefs.setString('porta', _porta.text.trim());
    await prefs.setString('usuario', _usuario.text.trim());
    await prefs.setString('senha', _senha.text.trim());
  }

  @override
  void initState() {
    super.initState();
    lerDados();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configuração'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextoEntrada(
              labeltext: 'Host',
              controller: _host,
              onchanged: (value) {
                if (value.length >= 12) {
                  salvarDados();
                }
              },
            ),
            TextoEntrada(
              labeltext: 'Porta',
              controller: _porta,
              tipoTeclado: TextInputType.number,
              onchanged: (value) {
                if (value.length >= 2) {
                  salvarDados();
                }
              },
            ),
            // TextoEntrada(
            //   labeltext: 'Usuário',
            //   controller: _usuario,
            //   onchanged: (value) {
            //     if (value.length >= 2) {
            //       salvarDados();
            //     }
            //   },
            // ),
            // TextoEntrada.senha(
            //   labeltext: 'Senha',
            //   controller: _senha,
            //   onchanged: (value) {
            //     if (value.length >= 2) {
            //       salvarDados();
            //     }
            //   },
            // ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await salvarDados();
              },
              child: const Text('SALVAR'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                Comum().mensagem(context, 'Dados deletados com sucesso.');
                await banco.deletarTudo('PRODUTOS');
                await banco.deletarTudo('SIGTBPRDHIST');
                await banco.deletarTudo('CONFERENCIA');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('LIMPAR BASE'),
            ),
          ],
        ),
      ),
    );
  }
}
