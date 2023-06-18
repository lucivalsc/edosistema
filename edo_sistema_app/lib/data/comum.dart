// ignore_for_file: use_build_context_synchronously

import 'package:edo_sistema/data/banco_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Comum {
  Databasepadrao banco = Databasepadrao.instance;
  pesquisarProduto(
      BuildContext context, store, FocusNode pesquisarFocusNode) async {
    await store.retornar(store.pesquisar.text);
    if (store.listaProdutos[0].isEmpty) {
      store.pesquisar.clear();
      await mensagem(context, 'Produto não localizado');
    } else {
      pesquisarFocusNode.requestFocus();
    }
  }

  mensagem(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text(msg),
        action: SnackBarAction(
          label: 'Aviso',
          onPressed: () {},
        ),
      ),
    );
  }

  Future<bool> escanearCodigoBarras(TextEditingController pesquisar) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancelar',
      true,
      ScanMode.BARCODE,
    );
    if (barcodeScanRes == '-1') {
      return false;
    } else {
      pesquisar.text = barcodeScanRes;
      return true;
    }
  }

  mesExtenso(mes) {
    switch (mes) {
      case '1':
        return 'Janeiro';
      case '2':
        return 'Fevereiro';
      case '3':
        return 'Março';
      case '4':
        return 'Abril';
      case '5':
        return 'Maio';
      case '6':
        return 'Junho';
      case '7':
        return 'Julho';
      case '8':
        return 'Agosto';
      case '9':
        return 'Setembro';
      case '10':
        return 'Outubro';
      case '11':
        return 'Novembro';
      case '12':
        return 'Dezezembro';
      default:
    }
  }
}
