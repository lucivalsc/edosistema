import 'package:edo_sistema/data/http_api.dart';
import 'package:edo_sistema/view/menu_estoque.dart';
import 'package:edo_sistema/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String titulo = '';
  lerDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    titulo = prefs.getString('UCEMAIL') ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    lerDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ListTile(
                title: const Text('Estoque'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MenuEstoque(),
                    ),
                  );
                },
              ),
              // ListTile(
              //   title: const Text('Sincronizar'),
              //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => const Sincronizar(),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                title: const Text('Sair'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Login(),
                    ),
                  );
                },
              ),
              const Expanded(child: SizedBox()),
              Text(
                versao,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Image.asset(
                'imagens/logo.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
