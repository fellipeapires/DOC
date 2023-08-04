// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unnecessary_this, sort_child_properties_last

import 'package:flutter/material.dart';
import '../component/info_app.dart';
import '../model/user.dart';
import '../util/app_routes.dart';
import '../util/utility.dart';

class HomeScreen extends StatelessWidget {
  void _setPage(BuildContext context, String appRoute, Object argumets) {
    Utility.setAppRouter(context, appRoute, argumets);
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 18, 5, 0),
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'INDIVIDUAL',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    icon: Icon(
                      Icons.autorenew_sharp,
                      size: 40,
                    ),
                    onPressed: () => _setPage(context, AppRoutes.ENTREGA, user),
                    style: TextButton.styleFrom(
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'COLETIVO',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    icon: Icon(
                      Icons.assignment,
                      size: 40,
                    ),
                    onPressed: () => _setPage(context, AppRoutes.ENTREGA_COLETIVO, user),
                    style: TextButton.styleFrom(
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'SINCRONISMO',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    icon: Icon(
                      Icons.autorenew_sharp,
                      size: 40,
                    ),
                    onPressed: () => _setPage(context, AppRoutes.SINNCRONISMO, user),
                    style: TextButton.styleFrom(
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'PRODUTIVIDADE',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    icon: Icon(
                      Icons.data_exploration_sharp,
                      size: 40,
                    ),
                    onPressed: () => _setPage(context, AppRoutes.PRODUTIVIDADE, user),
                    style: TextButton.styleFrom(
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'ESTATISTICA',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    icon: Icon(
                      Icons.align_vertical_bottom_sharp,
                      size: 40,
                    ),
                    onPressed: () => _setPage(context, AppRoutes.ESTATISTICA, user),
                    style: TextButton.styleFrom(
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    label: Text(
                      'BACKUP',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    icon: Icon(
                      Icons.backup_sharp,
                      size: 40,
                    ),
                    onPressed: () => _setPage(context, AppRoutes.BACKUP, user),
                    style: TextButton.styleFrom(
                      elevation: 10,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              InfoApp(user),
            ],
          ),
        ],
      ),
    );
  }
}
