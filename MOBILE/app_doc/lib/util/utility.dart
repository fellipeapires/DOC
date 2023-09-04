// ignore_for_file: missing_return, import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Utility {
  static bool isNet = false;
  static String statusNet = '';

  static void snackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void setAppRouter(BuildContext context, String appRoutes, Object arguments) {
    Navigator.pushNamed(context, appRoutes, arguments: arguments);
  }

  static void setPopAppRouter(BuildContext context) {
    Navigator.pop(context);
  }

  static Map<String, String> getDadosApp() {
    return const {
      'nome': 'DOC',
      'ano': '2023',
      'contrato': 'COMGAS',
      'copyRight': 'Copyright ©',
      'versao': '1.0.0',
      'textoVersao': 'Versão 1.0.0',
      'textoCopyRight': 'Copyright © 2023',
    };
  }

  static Future<void> getStatusNet(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      isNet = true;
      statusNet = 'MOBILE';
    } else {
      isNet = false;
      statusNet = 'SEM CONEXAO';
    }
  }
}
