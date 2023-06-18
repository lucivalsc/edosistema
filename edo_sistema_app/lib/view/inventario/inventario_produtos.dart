import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/texto_entrada.dart';
import 'package:edo_sistema/view/inventario/inventario_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventarioProdutos extends StatefulWidget {
  const InventarioProdutos({super.key});

  @override
  State<InventarioProdutos> createState() => _InventarioProdutosState();
}

class _InventarioProdutosState extends State<InventarioProdutos> {
  NumberFormat formatacao = NumberFormat.simpleCurrency(locale: 'pt_BR');
  InventarioStore store = InventarioStore();
  bool inLoading = false;
  pesquisarProduto() async {
    if (store.pesquisar.text.length > 2) {
      inLoading = true;
      setState(() {});
      await store.pesquisarProduto(context, store.pesquisar.text.toUpperCase());
      inLoading = false;
      setState(() {});
    } else {
      Comum().mensagem(context, 'Digite pelo menos 3 caracteres.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return !inLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Inventário Produtos'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextoEntrada(
                          labeltext: 'Pesquisar',
                          controller: store.pesquisar,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await pesquisarProduto();
                        },
                        icon: const Icon(
                          Icons.search,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          store.pesquisar.text = '';
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Comum().escanearCodigoBarras(store.pesquisar);
                          if (store.pesquisar.text.isNotEmpty) {
                            await pesquisarProduto();
                          }
                        },
                        icon: const Icon(
                          Icons.qr_code_scanner,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextoEntrada(
                          labeltext: 'Quantidade',
                          controller: store.quantidade,
                          tipoTeclado: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: TextoEntrada(
                          labeltext: 'Local estoque',
                          controller: store.localStoque,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextoEntrada(
                          labeltext: 'Código de barras',
                          controller: store.codigoBarras,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: store.lista.isEmpty ? 0 : store.lista.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                      itemBuilder: (BuildContext context, int index) {
                        var item = store.lista[index];
                        return ListTile(
                          selected: index == store.indiceItemSelecionado,
                          onTap: () async {
                            setState(() {
                              store.indiceItemSelecionado = index;
                            });

                            store.quantidade.text = '1';
                            store.localStoque.text =
                                item['LOC_ESTO'].toString();
                            store.codigoBarras.text =
                                item['COD_BARR'].toString();
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Cod.: ${item['COD_PROD']}',
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  'Cod. Org: ${item['COD_ORG']}',
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Cod. Barra: ${item['COD_BARR']}',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Marca: ${item['DES_MARC']}',
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Un. Medida: ${item['UNI_MED']}',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${item['DES_PROD']}',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Custo: ${formatacao.format(double.parse(item['PRE_CUS'].toString()))}',
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Vl. Venda: ${formatacao.format(double.parse(item['PRE_VEN'].toString()))}',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Loc. Esto.: ${item['LOC_ESTO']}',
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Qtd. Atual: ${formatacao.format(double.parse(item['QTD_ATUAL'].toString())).replaceAll('R\$', '')}',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black45,
              onPressed: () async {
                await store.salvarInventario(
                    context, store.lista[store.indiceItemSelecionado]);
              },
              child: const Icon(Icons.check),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 25),
                  Text('Pesquisando produtos...'),
                ],
              ),
            ),
          );
  }
}
