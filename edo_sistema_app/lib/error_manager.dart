import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ErrorManager {
  var token = '5857531142:AAF7dcQRgCK5wQWGIPL_gk3UaWz3nFmnfFg';
  var chatId = '793933959';
  static final ErrorManager _singleton = ErrorManager._internal();

  factory ErrorManager() {
    return _singleton;
  }

  ErrorManager._internal();

  void init() {
    // Ouvir por erros não tratados e relatar para o serviço de rastreamento de erros
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      reportError(details);
    };
    PlatformDispatcher.instance.onError = (e, stack) {
      reportExececao(e, stack);
      return true;
    };
  }

  Future<void> reportError(FlutterErrorDetails e) async {
    await enviarErroTelegram(e.exception);
  }

  Future<void> reportExececao(Object e, StackTrace stack) async {
    await enviarErroTelegram(e, stack);
  }

  Future<void> enviarErroTelegram(Object e, [StackTrace? stack]) async {
    try {
      final url = Uri.parse('https://api.telegram.org/bot$token/sendMessage');

      final texto = jsonEncode(
        {
          "Erro: ": "$e",
          "Stack": "$stack",
          "Aplicacao": 'EdoSistema',
        },
      );

      await http.post(
        url,
        body: {
          "chat_id": chatId,
          "text": texto,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> enviarLog(String msg) async {
    try {
      final url = Uri.parse('https://api.telegram.org/bot$token/sendMessage');

      final texto = jsonEncode(
        {
          "Mensagem": msg,
          "Aplicacao": 'EdoSistema',
        },
      );

      await http.post(
        url,
        body: {
          "chat_id": chatId,
          "text": texto,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
