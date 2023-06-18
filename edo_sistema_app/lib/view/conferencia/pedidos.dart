import 'package:edo_sistema/data/http_api.dart';
import 'package:edo_sistema/texto_entrada.dart';
import 'package:edo_sistema/view/conferencia/conferencia.dart';
import 'package:edo_sistema/view/conferencia/conferencia_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({super.key});

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  ConferenciaStore store = ConferenciaStore();
  HttpApi api = HttpApi();
  final TextEditingController numPedido = TextEditingController();
  List<Map<String, Object?>> lista = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisa de Pedidos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextoEntrada(
                    labeltext: 'Número do pedido',
                    controller: numPedido,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    lista = await store.conferenciaPedido(
                      context,
                      numPedido.text,
                    );
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: lista.isEmpty ? 0 : lista.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  var item = lista[index];
                  return ListTile(
                    onTap: () {
                      showModal();
                    },
                    title: Text('${item['NOM_CLI']}'),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('dd/MM/yyyy hh:mm').format(
                            DateTime.parse(item['DAT_PEDI'].toString()))),
                        Text('${item['NUM_PEDI']}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await api.separarParaConferencia(context, numPedido.text);
                },
                child: const Text('SEPARAR PARA CONFERÊNCIA'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black45,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Conferencia(
                        numPedido: numPedido.text,
                      ),
                    ),
                  );
                },
                child: const Text('CONFERIR'),
              ),
            ],
          ),
        );
      },
    );
  }
}
