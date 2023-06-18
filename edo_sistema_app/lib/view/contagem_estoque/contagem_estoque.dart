import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/data/http_api.dart';
import 'package:edo_sistema/view/contagem_estoque/contagem_estoque_produtos.dart';
import 'package:edo_sistema/view/contagem_estoque/contagem_estoque_store.dart';
import 'package:flutter/material.dart';

class ContagemEstoque extends StatefulWidget {
  const ContagemEstoque({super.key});

  @override
  State<ContagemEstoque> createState() => _ContagemEstoqueState();
}

class _ContagemEstoqueState extends State<ContagemEstoque> {
  ContagemEstoqueStore store = ContagemEstoqueStore();
  HttpApi api = HttpApi();
  pesquisarContagemEstoque() async {
    await store.pesquisarContagem();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pesquisarContagemEstoque();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contagem de Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 5,
                dataRowHeight: 35,
                columns: const <DataColumn>[
                  DataColumn(label: Text('Código')),
                  DataColumn(label: Text('Descrição')),
                  DataColumn(label: Text('Qtde')),
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
                        Text(
                          '${store.listaInventario[index]['COD_PROD']}',
                        ),
                      ),
                      DataCell(
                        Text(
                          '${store.listaInventario[index]['DESCRICAO']}',
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${store.listaInventario[index]['QTDE_NOVA']}',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
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
                          builder: (_) => const ContagemEstoqueProdutos(),
                        ),
                      );
                      await pesquisarContagemEstoque();
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
          title: const Text(
              'Deseja exculir todos os itens da contagem de estoque?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await store.banco.deletarTudo('CONTAGEM_ESTOQUE');
                await pesquisarContagemEstoque();
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
          title: const Text(
              'Deseja sincronizar todos os itens da contagem de estoque?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await api.enviarContagem(
                  context,
                  store.listaInventario,
                ); //Mudar aqui para enviar dados corretos
                await pesquisarContagemEstoque();
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
