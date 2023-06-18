import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/data/http_api.dart';
import 'package:edo_sistema/view/inventario/inventario_produtos.dart';
import 'package:edo_sistema/view/inventario/inventario_store.dart';
import 'package:flutter/material.dart';

class Inventario extends StatefulWidget {
  const Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  InventarioStore store = InventarioStore();
  HttpApi api = HttpApi();
  pesquisarInventario() async {
    await store.pesquisarInventario();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pesquisarInventario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 10,
                dataRowHeight: 35,
                columns: const <DataColumn>[
                  DataColumn(label: Text('Código')),
                  DataColumn(label: Text('Descrição')),
                  DataColumn(label: Text('Ant.')),
                  DataColumn(label: Text('Nova')),
                ],
                rows: List<DataRow>.generate(
                  store.listaInventario.isEmpty
                      ? 0
                      : store.listaInventario.length,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      // All rows will have the same selected color.
                      if (states.contains(MaterialState.selected)) {
                        return Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08);
                      }
                      // Even rows will have a grey color.
                      if (index.isEven) {
                        return Colors.grey.withOpacity(0.3);
                      }
                      return null; // Use default value for other states and odd rows.
                    }),
                    cells: <DataCell>[
                      DataCell(
                          Text('${store.listaInventario[index]['COD_PROD']}')),
                      DataCell(
                          Text('${store.listaInventario[index]['DESCRICAO']}')),
                      DataCell(
                          Text('${store.listaInventario[index]['QTDE_ANT']}')),
                      DataCell(
                          Text('${store.listaInventario[index]['QTDE_NOVA']}')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 114,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  FloatingActionButton(
                    heroTag: 1,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InventarioProdutos(),
                        ),
                      );
                      await pesquisarInventario();
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  const SizedBox(width: 25),
                  FloatingActionButton(
                    backgroundColor: Colors.black45,
                    heroTag: 2,
                    onPressed: () async {
                      if (store.listaInventario.isNotEmpty) {
                        showDeletar();
                      } else {
                        Comum().mensagem(
                            context, 'Nenhum item para ser excluído!');
                      }
                    },
                    child: const Icon(
                      Icons.delete,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                            'Qtde de itens -> ${store.listaInventario.length}'),
                        Text('Total de produtos -> ${store.totalProdutos}'),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.black45,
                    heroTag: 3,
                    onPressed: () async {
                      if (store.listaInventario.isNotEmpty) {
                        showSincronizar();
                      } else {
                        Comum().mensagem(
                            context, 'Nenhum item para ser sincronizado!');
                      }
                    },
                    child: const Icon(
                      Icons.autorenew,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDeletar() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Deseja exculir todos os itens do inventário?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await store.banco.deletarTudo('SIGTBPRDHIST');
                await pesquisarInventario();
                setState(() {});
              },
              child: const Text('Sim'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }

  showSincronizar() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Deseja sincronizar todos os itens do inventário?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await api.enviarInventario(context, store.listaInventario);
                await pesquisarInventario();
              },
              child: const Text('Sim'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }
}
