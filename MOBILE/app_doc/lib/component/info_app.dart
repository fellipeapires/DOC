// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations, prefer_const_constructors, unnecessary_this, prefer_const_constructors_in_immutables, unnecessary_brace_in_string_interps, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../model/user.dart';
import '../util/utility.dart';

class InfoApp extends StatelessWidget {
  final User user;

  InfoApp(this.user);

  @override
  Widget build(BuildContext context) {
    return user == null
        ? Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2),
                child: Text(
                  '${Utility.getDadosApp().values.elementAt(4)} - ${Utility.getDadosApp().values.elementAt(5)}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          )
        : Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                padding: const EdgeInsets.all(2),
                child: Text(
                  user.matricula == '0' ? '' : 'Matricula: ${user.matricula}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2),
                child: Text(
                  '${Utility.getDadosApp().values.elementAt(4)} - ${Utility.getDadosApp().values.elementAt(5)}',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          );
  }
}
