import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:edo_sistema/data/banco_controller.dart';
import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/texto_entrada.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  var token = '5857531142:AAF7dcQRgCK5wQWGIPL_gk3UaWz3nFmnfFg';
  var chatId = '793933959';

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
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                // Obter o caminho do banco de dados Sqflite
                Directory documentsDirectory =
                    await getApplicationDocumentsDirectory();
                String path = p.join(documentsDirectory.path, 'bd');

                // Ler o arquivo do banco de dados
                File dbFile = File(path);
                List<int> bytes = await dbFile.readAsBytes();

                // Enviar o arquivo via HTTP para a API do Telegram
                String url = 'https://api.telegram.org/bot$token/sendDocument';
                var request = http.MultipartRequest('POST', Uri.parse(url))
                  ..fields['chat_id'] = chatId
                  ..files.add(
                    http.MultipartFile.fromBytes(
                      'document',
                      bytes,
                      filename: 'bd.db',
                    ),
                  );

                var response = await request.send();
                if (response.statusCode == 200) {
                  // Exibir uma mensagem de sucesso

                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sucesso'),
                          content:
                              const Text('Banco de dados enviado com sucesso!'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Fechar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Exibir uma mensagem de erro
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Erro'),
                          content: const Text(
                              'Ocorreu um erro ao enviar o banco de dados.'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Fechar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('ENVIAR BASE'),
            ),
          ],
        ),
      ),
    );
  }
}
