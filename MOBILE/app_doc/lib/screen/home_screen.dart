// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unnecessary_this, sort_child_properties_last, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, avoid_print, avoid_returning_null_for_void

import 'dart:convert';
//import 'dart:ui';

import 'package:app_doc/component/circular_progress.dart';
import 'package:app_doc/component/info_app.dart';
import 'package:app_doc/model/entrega.dart';
import 'package:app_doc/provider/entrega_provider.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import '../util/app_routes.dart';
import '../util/utility.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final loading = ValueNotifier<bool>(false);
  final entregaProvider = EntregaProvider();
  Color colorWifi = Colors.white;

  void _checkInternet(BuildContext context) async {
    await Utility.getStatusNet(context);
    setState(() {
      if (Utility.isNet) {
        colorWifi = Colors.white;
      } else {
        colorWifi = Colors.red[800]!;
      }
    });
  }

  void _setPage(BuildContext context, String appRoute, Object argumets) {
    Utility.setAppRouter(context, appRoute, argumets);
  }

  Future<void> getCargaEntrega(BuildContext context, int idUsuario) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      loading.value = true;
      Entrega entrega;
      try {
        final future = entregaProvider.getCargaAPI(idUsuario);
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (element) => {
                entrega = Entrega(),
                entrega.id = int.tryParse(element['idEntrega'].toString())!,
                entrega.idImportacao = int.tryParse(element['idImportacao'].toString())!,
                entrega.idGrupoFaturamento = int.tryParse(element['idGrupoFaturamento'].toString())!,
                entrega.grupoFaturamento = int.tryParse(element['grupoFaturamento'].toString())!,
                entrega.roteiro = element['roteiro'],
                entrega.sequencia = element['sequencia'],
                entrega.municipio = element['municipio'],
                entrega.endereco = element['endereco'],
                entrega.cep = element['cep'],
                entrega.codCliente = element['codCliente'],
                entrega.codBarras = element['codBarras'],
                entrega.observacao = element['observacao'],
                entrega.pendente = 1,
                entregaProvider.insert(
                  {
                    'id': entrega.id,
                    'grupoFaturamento': entrega.grupoFaturamento,
                    'idImportacao': entrega.idImportacao,
                    'roteiro': entrega.roteiro,
                    'idGrupoFaturamento': entrega.idGrupoFaturamento,
                    'sequencia': entrega.sequencia,
                    'municipio': entrega.municipio,
                    'endereco': entrega.endereco,
                    'cep': entrega.cep,
                    'codCliente': entrega.codCliente,
                    'codBarras': entrega.codBarras,
                    'observacao': entrega.observacao,
                    'pendente': entrega.pendente
                  },
                ),
              },
            ),
            loading.value = false,
          },
        );
      } catch (Exc) {
        print('$Exc');
        Utility.snackbar(context, 'ERRO DE CARGA: $Exc');
      }
    } else {
      Utility.snackbar(context, 'SEM CONEXAO COM A INTERNET!');
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkInternet(context);
    final user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOME'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.wifi,
              size: 40,
              color: colorWifi,
            ),
            padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(
              Icons.download_sharp,
              size: 40,
            ),
            padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
            onPressed: () => getCargaEntrega(context, user.id!),
          ),
        ],
      ),
      body:
          // Stack(
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.stretch,
          //       children: [
          //         Container(
          //           alignment: Alignment.center,
          //           margin: const EdgeInsets.fromLTRB(5, 18, 5, 1),
          //           padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
          //           child: SizedBox(
          //             height: 49,
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               label: Text(
          //                 'INDIVIDUAL',
          //                 style: Theme.of(context).textTheme.headline3,
          //               ),
          //               icon: Icon(
          //                 Icons.autorenew_sharp,
          //                 size: 30,
          //               ),
          //               onPressed: () => _setPage(context, AppRoutes.ENTREGA, user),
          //               style: TextButton.styleFrom(
          //                 elevation: 10,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           alignment: Alignment.center,
          //           margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
          //           padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
          //           child: SizedBox(
          //             height: 49,
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               label: Text(
          //                 'COLETIVO',
          //                 style: Theme.of(context).textTheme.headline3,
          //               ),
          //               icon: Icon(
          //                 Icons.assignment,
          //                 size: 30,
          //               ),
          //               onPressed: () => _setPage(context, AppRoutes.ENTREGA_COLETIVO, user),
          //               style: TextButton.styleFrom(
          //                 elevation: 10,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           alignment: Alignment.center,
          //           margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
          //           padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
          //           child: SizedBox(
          //             height: 49,
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               label: Text(
          //                 'SINCRONISMO',
          //                 style: Theme.of(context).textTheme.headline3,
          //               ),
          //               icon: Icon(
          //                 Icons.autorenew_sharp,
          //                 size: 30,
          //               ),
          //               onPressed: () => _setPage(context, AppRoutes.SINNCRONISMO, user),
          //               style: TextButton.styleFrom(
          //                 elevation: 10,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           alignment: Alignment.center,
          //           margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
          //           padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
          //           child: SizedBox(
          //             height: 49,
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               label: Text(
          //                 'PRODUTIVIDADE',
          //                 style: Theme.of(context).textTheme.headline3,
          //               ),
          //               icon: Icon(
          //                 Icons.data_exploration_sharp,
          //                 size: 30,
          //               ),
          //               onPressed: () => _setPage(context, AppRoutes.PRODUTIVIDADE, user),
          //               style: TextButton.styleFrom(
          //                 elevation: 10,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           alignment: Alignment.center,
          //           margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
          //           padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
          //           child: SizedBox(
          //             height: 49,
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               label: Text(
          //                 'ESTATISTICA',
          //                 style: Theme.of(context).textTheme.headline3,
          //               ),
          //               icon: Icon(
          //                 Icons.align_vertical_bottom_sharp,
          //                 size: 30,
          //               ),
          //               onPressed: () => _setPage(context, AppRoutes.ESTATISTICA, user),
          //               style: TextButton.styleFrom(
          //                 elevation: 10,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           alignment: Alignment.center,
          //           margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
          //           padding: const EdgeInsets.fromLTRB(5, 1, 5, 0),
          //           child: SizedBox(
          //             height: 49,
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               label: Text(
          //                 'BACKUP',
          //                 style: Theme.of(context).textTheme.headline3,
          //               ),
          //               icon: Icon(
          //                 Icons.backup_sharp,
          //                 size: 30,
          //               ),
          //               onPressed: () => _setPage(context, AppRoutes.BACKUP, user),
          //               style: TextButton.styleFrom(
          //                 elevation: 10,
          //               ),
          //             ),
          //           ),
          //         ),
          // const Spacer(),
          // InfoApp(user),
          //       ],
          //     ),
          //   ],
          // ),
          ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) {
          if (value) {
            return CircularProgressComponent();
          } else {
            return Stack(
              children: [
                GridView(
                    padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'INDIVIDUAL',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.mail,
                              size: 25,
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
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'COLETIVO',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.mail,
                              size: 25,
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
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'SINC. ENTREGA',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.autorenew_sharp,
                              size: 24,
                            ),
                            onPressed: () => null,
                            style: TextButton.styleFrom(
                              elevation: 10,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'SINC. FOTO',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.autorenew_sharp,
                              size: 25,
                            ),
                            onPressed: () => null,
                            style: TextButton.styleFrom(
                              elevation: 10,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'ESTATISTICA',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.align_vertical_bottom_sharp,
                              size: 24,
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
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'PRODUTIVIDADE',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.data_exploration_sharp,
                              size: 24,
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
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'BACKUP',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.backup_sharp,
                              size: 25,
                            ),
                            onPressed: () => _setPage(context, AppRoutes.BACKUP, user),
                            style: TextButton.styleFrom(
                              elevation: 10,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            label: Text(
                              'APAGAR DADOS',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            icon: Icon(
                              Icons.delete_forever,
                              size: 24,
                            ),
                            onPressed: () => null,
                            style: TextButton.styleFrom(
                              elevation: 10,
                            ),
                          ),
                        ),
                      ),
                    ]),
                InfoApp(user),
              ],
            );
          }
        },
      ),
    );
  }
}
