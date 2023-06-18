import 'package:edo_sistema/data/http_api.dart';
import 'package:flutter/material.dart';

class Sincronizar extends StatefulWidget {
  const Sincronizar({super.key});

  @override
  State<Sincronizar> createState() => _SincronizarState();
}

class _SincronizarState extends State<Sincronizar> {
  HttpApi api = HttpApi();
  bool inLoading = false;

  @override
  Widget build(BuildContext context) {
    return !inLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Sincronizar'),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    ListTile(
                      title: const Text('Produtos'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      onTap: () async {
                        inLoading = true;
                        setState(() {});
                        await api.retornarProdutos(context);
                        inLoading = false;
                        setState(() {});
                      },
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
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 25),
                  Text('Baixando produtos...'),
                ],
              ),
            ),
          );
  }
}
