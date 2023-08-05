// ignore_for_file: missing_return, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class Utility {
  static final Connectivity _connectivity = Connectivity();
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
      'copyRight': 'Copyright ©',
      'versao': '1.0.0',
      'textoVersao': 'DOC - Versão 1.0.0',
      'textoCopyRight': 'Copyright © 2023',
    };
  }

  static Future<void> getStatusNet(BuildContext context) async {
    await _connectivity.checkConnectivity().then((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile) {
        isNet = true;
        statusNet = 'MOBILE';
      } else if (connectivityResult == ConnectivityResult.wifi) {
        isNet = true;
        statusNet = 'WIFI';
      } else {
        isNet = false;
        statusNet = 'SEM CONEXAO';
      }
    });
  }
}
