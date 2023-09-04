// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_print

import 'dart:io';

import 'package:app_doc/screen/backup_screen.dart';
import 'package:app_doc/screen/entrega_coletivo_screen.dart';
import 'package:app_doc/screen/entrega_screen.dart';
import 'package:app_doc/screen/estatistica_screen.dart';
import 'package:app_doc/screen/home_screen.dart';
import 'package:app_doc/screen/login_screen.dart';
import 'package:app_doc/screen/not_found_screen.dart';
import 'package:app_doc/screen/produtividade_screen.dart';
import 'package:app_doc/screen/sincronismo_screen.dart';
import 'package:app_doc/util/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // HttpOverrides.global = EdocHttpOverrides();
  runApp(Doc());
}

class EdocHttpOverrides extends HttpOverrides {
  /*@override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }*/
}

class Doc extends StatelessWidget {
  final ThemeData tema = ThemeData();

  @override
  Widget build(BuildContext context) {
    // PARA DEFINIR A TELA COM ORIENTACAO VERTICAL (portrait) OU VERTICAL (landscape)
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      debugShowCheckedModeBanner: true,
      // SUBSTITUINDO VALOR DAS ROTAS DE STRING POR CONSTANTES
      routes: {
        AppRoutes.LOGIN: (ctx) => LoginScreen(),
        AppRoutes.HOME: (ctx) => HomeScreen(),
        AppRoutes.ENTREGA: (ctx) => EntregaScreen(),
        AppRoutes.ENTREGA_COLETIVO: (ctx) => EntregaColetivoScreen(),
        AppRoutes.PRODUTIVIDADE: (ctx) => ProdutividadeScreen(),
        AppRoutes.ESTATISTICA: (ctx) => EstatisticaScreen(),
        AppRoutes.SINNCRONISMO: (ctx) => SincronismoScreen(),
        AppRoutes.BACKUP: (ctx) => BackupScreen(),
        AppRoutes.NOT_FOUND: (ctx) => NotFoundScreen(),
      },
      onUnknownRoute: ((settings) {
        //METODO PARA RESOLVER QUANDO NÃO ENCONTRA A ROTA, ELE REDIRECIONA PARA A PAGINA DEFINIDA
        return MaterialPageRoute(
          builder: (_) {
            return NotFoundScreen();
          },
        );
      }),
      title: 'EDOC',
      theme: tema.copyWith(
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.purple,
        ),
        textTheme: tema.textTheme.copyWith(
          headline1: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          headline2: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline3: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline4: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headline5: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          headline6: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 110, 109, 109),
          ),
          button: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
