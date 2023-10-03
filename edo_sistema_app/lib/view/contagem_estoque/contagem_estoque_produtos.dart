// ignore_for_file: use_build_context_synchronously

import 'package:edo_sistema/data/comum.dart';
import 'package:edo_sistema/texto_campo.dart';
import 'package:edo_sistema/view/contagem_estoque/contagem_estoque_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContagemEstoqueProdutos extends StatefulWidget {
  const ContagemEstoqueProdutos({super.key});

  @override
  State<ContagemEstoqueProdutos> createState() =>
      _ContagemEstoqueProdutosState();
}

class _ContagemEstoqueProdutosState extends State<ContagemEstoqueProdutos> {
  NumberFormat formatacao = NumberFormat.simpleCurrency(locale: 'pt_BR');
  ContagemEstoqueStore store = ContagemEstoqueStore();
  bool inLoading = false;
  pesquisarProduto() async {
    // inLoading = true;
    setState(() {});
    await store.pesquisarProduto(
      context,
      store.pesquisar.text.toUpperCase(),
      rota: true,
    );
    // inLoading = false;
    setState(() {});
  }

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !inLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Produtos'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextoCampo(
                          focusNode: focusNode,
                          labeltext: 'Pesquisar',
                          onSubmitted: (valor) async {
                            //Adicionar dados
                            await pesquisarProduto();
                            if (store.lista.isNotEmpty) {
                              await store.salvarContagem(
                                context,
                                store.lista[store.indiceItemSelecionado],
                              );
                              // store.lista = [];
                            }
                            store.pesquisar.clear();
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          textInputAction: TextInputAction.done,
                          controller: store.pesquisar,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await pesquisarProduto();
                          if (store.lista.isNotEmpty) {
                            await store.salvarContagem(
                              context,
                              store.lista[store.indiceItemSelecionado],
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.search,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          store.pesquisar.text = '';
                          store.lista = [];
                          setState(() {});
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
                            if (store.lista.isNotEmpty) {
                              await store.salvarContagem(
                                context,
                                store.lista[store.indiceItemSelecionado],
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.qr_code_scanner,
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
            //   floatingActionButton: FloatingActionButton(
            //     backgroundColor: Colors.black45,
            //     onPressed: () async {
            //       await store.salvarContagem(
            //           context, store.lista[store.indiceItemSelecionado]);
            //     },
            //     child: const Icon(Icons.check),
            //   ),
          )
        : const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 25),
                  Text('Pesquisando produtos...'),
                ],
              ),
            ),
          );
  }
}
