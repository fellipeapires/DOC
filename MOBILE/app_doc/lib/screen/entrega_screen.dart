// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations

import 'package:app_doc/component/info_app.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';

class EntregaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENTREGA'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoApp(user),
          ],
        ),
      ),
    );
  }
}
