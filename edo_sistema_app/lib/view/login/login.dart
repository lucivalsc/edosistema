import 'package:edo_sistema/texto_entrada.dart';
import 'package:edo_sistema/view/configuracao/configuracao.dart';
import 'package:edo_sistema/view/login/login_store.dart';
import 'package:edo_sistema/view/principal/principal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginStore login = LoginStore();

  final TextEditingController _usuario = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  lerDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuario.text = prefs.getString('login') ?? '';
    _senha.text = prefs.getString('password') ?? '';
  }

  salvarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', _usuario.text.trim());
    await prefs.setString('password', _senha.text.trim());
  }

  @override
  void initState() {
    super.initState();
    lerDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Image.asset(
            'imagens/logo.png',
          ),
          TextoEntrada(
            labeltext: 'Usuário',
            controller: _usuario,
          ),
          TextoEntrada.senha(
            labeltext: 'Senha',
            controller: _senha,
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              if (await login.efetuarLogin(
                context,
                _usuario.text.trim().toUpperCase(),
                _senha.text.trim().toUpperCase(),
              )) {
                salvarDados();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Principal(),
                  ),
                );
              }
            },
            child: const Text('ENTRAR'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black45,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Configuracao(),
            ),
          );
        },
        child: const Icon(
          Icons.settings,
        ),
      ),
    );
  }
}
