// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'package:flutter/material.dart';

import '../component/info_app.dart';
import '../model/user.dart';
import '../util/utility.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Utility.getDadosApp().values.elementAt(0)}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Text(
                'Pagina nao Encontrada!',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(5, 40, 5, 10),
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/error-404.png',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 40),
              padding: const EdgeInsets.all(5),
              child: Text(
                'Entre em contato com o administrador do sistema!',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            InfoApp(User(id: 0, idRegional: 0, login: '', matricula: 0, nome: '', senha: '', situacao: 0)),
          ],
        ),
      ),
    );
  }
}
