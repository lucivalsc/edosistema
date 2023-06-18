import 'package:edo_sistema/data/banco_controller.dart';
import 'package:edo_sistema/data/http_api.dart';
import 'package:flutter/material.dart';

import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/view/conferencia/conferencia_produtos.dart';
import 'package:edo_sistema/view/conferencia/conferencia_store.dart';

class Conferencia extends StatefulWidget {
  final String numPedido;
  const Conferencia({
    Key? key,
    required this.numPedido,
  }) : super(key: key);

  @override
  State<Conferencia> createState() => _ConferenciaState();
}

class _ConferenciaState extends State<Conferencia> {
  HttpApi api = HttpApi();
  ConferenciaStore store = ConferenciaStore();
  Databasepadrao banco = Databasepadrao.instance;
  var lista = [];
  listagemPedido() async {
    lista = await banco.listagemPedido(widget.numPedido);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    listagemPedido();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conferência')),
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
                  lista.isEmpty ? 0 : lista.length,
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
                      DataCell(Text('${lista[index]['QTD_PROD']}')),
                      DataCell(Text('${lista[index]['DES_PROD']}')),
                      DataCell(Text('${lista[index]['QTD_CONFERENCIA']}')),
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
                          builder: (_) => ConferenciaProdutos(
                            numPedido: widget.numPedido,
                          ),
                        ),
                      );
                      await listagemPedido();
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Qtde de itens -> ${lista.length}'),
                        Text('Total de produtos -> ${store.totalProdutos}'),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.black45,
                    heroTag: 3,
                    onPressed: () async {
                      if (lista.isNotEmpty) {
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
          title: const Text('Deseja exculir todos os itens da conferência?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await store.banco.deletarTudo('SIGTBPRDHIST');
                await listagemPedido();
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
          title:
              const Text('Deseja sincronizar todos os itens da conferência?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await api.enviarConferencia(context, lista);
                await listagemPedido();
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
