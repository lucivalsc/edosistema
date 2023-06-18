import 'package:edo_sistema/view/conferencia/pedidos.dart';
import 'package:edo_sistema/view/contagem_estoque/contagem_estoque.dart';
import 'package:flutter/material.dart';

import 'inventario/inventario.dart';

class MenuEstoque extends StatefulWidget {
  const MenuEstoque({super.key});

  @override
  State<MenuEstoque> createState() => _MenuEstoqueState();
}

class _MenuEstoqueState extends State<MenuEstoque> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Estoque'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ListTile(
                title: const Text('Inventário'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Inventario(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Contagem de Estoque'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContagemEstoque(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Conferência de pedidos'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Pedidos(),
                    ),
                  );
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
    );
  }
}
