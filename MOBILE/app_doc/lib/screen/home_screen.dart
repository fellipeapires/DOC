// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unnecessary_this, sort_child_properties_last, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, avoid_print, avoid_returning_null_for_void, avoid_function_literals_in_foreach_calls, unused_element, await_only_futures

import 'dart:convert';
//import 'dart:ui';

import 'package:app_doc/component/circular_progress.dart';
import 'package:app_doc/component/info_app.dart';
import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/model/backup.dart';
import 'package:app_doc/model/entrega.dart';
import 'package:app_doc/model/ocorrencia.dart';
import 'package:app_doc/model/retorno_entrega.dart';
import 'package:app_doc/model/retorno_foto.dart';
import 'package:app_doc/provider/backup_provider.dart';
import 'package:app_doc/provider/entrega_provider.dart';
import 'package:app_doc/provider/foto_provider.dart';
import 'package:app_doc/provider/ocorrencia_provider.dart';
import 'package:app_doc/util/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final ocorrenciaProvider = OcorrenciaProvider();
  final backupProvider = BackupProvider();
  final fotoProvider = FotoProvider();
  Color colorWifi = Colors.white;
  int contador = 0;

  @override
  initState() {
    super.initState();
    _initDevice();
  }

  Future<void> _initDevice() async {
    setState(() {
      loading.value = true;
    });
    await getOcorrenciaApi(context);
    await _apagarDadosAuto();
    setState(() {
      loading.value = false;
    });
    await _permissionDeviceInfo();
    await _permissionLocation();
    await _permissionStorage();
    await _permissionCamera();
  }

  void _apagarDadosAuto() async {
    try {
      String sufixBackup = '${DateFormat("yMdHHmmss").format(DateTime.now())}';
      String dataBackup = DateFormat("yyyy-MM-dd").format(DateTime.now());

      var isBackupEntrega = await backupProvider.getBackupLast('retorno_entrega');
      if (isBackupEntrega.isEmpty) {
        List<Map<String, dynamic>> listaRetornoEntrega = await entregaProvider.getRetornoEntregaAll();

        var lista = [];
        if (listaRetornoEntrega.isNotEmpty) {
          var retornoRest = RetornoEntrega();
          listaRetornoEntrega.forEach((element) {
            retornoRest = retornoRest.toObject(retornoRest, element);
            lista.add(retornoRest);
          });
          String retornoEntregaJson = jsonEncode(lista);
          await FileManager().writeJsonFile(retornoEntregaJson, 'backup_entrega_${sufixBackup}');

          var backupEntrega = Backup();
          backupEntrega.nome = 'backup_entrega_${sufixBackup}';
          backupEntrega.tabela = 'retorno_entrega';
          backupEntrega.dataCriacao = dataBackup;
          await backupProvider.insert(backupEntrega.toMap());
          await entregaProvider.apagarDadosEntregaAuto();
          await entregaProvider.apagarDadosRetornoEntregaAuto();
        }
      }

      var isBackupFoto = await backupProvider.getBackupLast('retorno_foto');
      if (isBackupFoto.isEmpty) {
        List<Map<String, dynamic>> listaFoto = await fotoProvider.getFotoAll();

        var listaFotoRest = [];
        if (listaFoto.isNotEmpty) {
          listaFoto.forEach((element) {
            var fotoResrt = RetornoFoto();
            fotoResrt.idUsuario = int.tryParse(element['idUsuario'].toString());
            fotoResrt.nome = element['nome'];
            fotoResrt.dataExecucao = element['dataExecucao'];
            fotoResrt.codBarras = element['codBarras'];
            fotoResrt.instalacao = element['instalacao'];
            fotoResrt.imagem = element['imagem'];
            fotoResrt.imei = element['imei'];
            fotoResrt.pendente = int.tryParse(element['pendente'].toString());
            fotoResrt.assinatura = int.tryParse(element['assinatura'].toString());
            listaFotoRest.add(fotoResrt);
          });
          String fotoJson = jsonEncode(listaFotoRest);
          await FileManager().writeJsonFile(fotoJson, 'backup_foto_${sufixBackup}');

          var backupFoto = Backup();
          backupFoto.nome = 'backup_foto_${sufixBackup}';
          backupFoto.tabela = 'retorno_foto';
          backupFoto.dataCriacao = dataBackup;
          await backupProvider.insert(backupFoto.toMap());
          await fotoProvider.apagarDadosFotoAuto();
        }
      }
    } catch (Exc) {
      setState(() {
        loading.value = false;
      });
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO APAGAR OS DADOS: $Exc');
    }
  }

  void _checkInternet(BuildContext context) async {
    await Utility.getStatusNet(context);
    setState(() {
      if (Utility.isNet) {
        colorWifi = Colors.white;
      } else {
        colorWifi = Colors.red[800];
      }
    });
  }

  void _permissionDeviceInfo() async {
    var statusDeviceInfo = await Permission.phone.status;
    if (!statusDeviceInfo.isGranted) {
      await Permission.phone.request();
    }
  }

  void _permissionLocation() async {
    var statusDeviceLocation = await Permission.location.status;
    if (!statusDeviceLocation.isGranted) {
      await Permission.location.request();
    }
  }

  void _permissionStorage() async {
    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
  }

  void _permissionCamera() async {
    var statusDeviceCamera = await Permission.camera.status;
    if (!statusDeviceCamera.isGranted) {
      await Permission.camera.request();
    }
  }

//verficar caminho do diretório do DB
  void _getDbPath() async {
    await DatabaseApp().getDbPath();
  }

  Future<void> _createBackup(BuildContext context) async {
    try {
      setState(() {
        loading.value = true;
      });

      String sufixBackup = '${DateFormat("yMdHHmmss").format(DateTime.now())}';
      List<Map<String, dynamic>> listaRetornoEntrega = await entregaProvider.getRetornoEntregaAll();
      var lista = [];
      if (listaRetornoEntrega.isNotEmpty) {
        var retornoRest = RetornoEntrega();
        listaRetornoEntrega.forEach((element) {
          retornoRest = retornoRest.toObject(retornoRest, element);
          lista.add(retornoRest);
        });
        String retornoEntregaJson = jsonEncode(lista);
        await FileManager().writeJsonFile(retornoEntregaJson, 'backup_entrega_${sufixBackup}');
      }

      List<Map<String, dynamic>> listaFoto = await fotoProvider.getFotoAll();
      var listaFotoRest = [];
      if (listaFoto.isNotEmpty) {
        listaFoto.forEach((element) {
          var fotoResrt = RetornoFoto();
          fotoResrt.idUsuario = int.tryParse(element['idUsuario'].toString());
          fotoResrt.nome = element['nome'];
          fotoResrt.dataExecucao = element['dataExecucao'];
          fotoResrt.codBarras = element['codBarras'];
          fotoResrt.instalacao = element['instalacao'];
          fotoResrt.imagem = element['imagem'];
          fotoResrt.imei = element['imei'];
          fotoResrt.pendente = int.tryParse(element['pendente'].toString());
          fotoResrt.assinatura = int.tryParse(element['assinatura'].toString());
          listaFotoRest.add(fotoResrt);
        });
        String fotoJson = jsonEncode(listaFotoRest);
        await FileManager().writeJsonFile(fotoJson, 'backup_foto_${sufixBackup}');
      }

      setState(() {
        loading.value = false;
      });
    } catch (Exc) {
      setState(() {
        loading.value = false;
      });
      print('$Exc');
      Utility.snackbar(context, 'ERRO NA GERACAO DO BACKUP: $Exc');
    }
  }

  void _apagarDados(BuildContext context, int idUser) async {
    try {
      await _createBackup(context);

      setState(() {
        loading.value = true;
      });

      await fotoProvider.apagarDados();
      await entregaProvider.apagarDadosEntrega();
      await entregaProvider.apagarDadosRetornoEntrega();
      await entregaProvider.apagarDadosRetornoEntrega9999();

      setState(() {
        loading.value = false;
      });
    } catch (Exc) {
      setState(() {
        loading.value = false;
      });
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO APAGAR OS DADOS: $Exc');
    }
  }

  void _setPage(BuildContext context, String appRoute, Object argumets) {
    Utility.setAppRouter(context, appRoute, argumets);
  }

  Future<void> getOcorrenciaApi(BuildContext context) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        await ocorrenciaProvider.deleteAll('ocorrencia');
        // loading.value = true;
        Ocorrencia ocorrencia;
        final future = ocorrenciaProvider.getOcorrenciaApi();
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (element) => {
                ocorrencia = Ocorrencia(),
                ocorrencia = ocorrencia.toObject(ocorrencia, element),
                ocorrenciaProvider.insert(ocorrencia.toMap()),
              },
            ),
            // loading.value = false,
          },
        );
      } catch (Exc) {
        loading.value = false;
        print('$Exc');
        Utility.snackbar(context, 'ERRO DE DOWNLOAD DE OCORRENCIA: $Exc');
      }
    }
  }

  Future<void> getCargaEntrega(BuildContext context, int idUsuario) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      loading.value = true;
      Entrega entrega;
      List<int> listaIdEntrega = [];
      var listaCarga = [];
      try {
        final future = entregaProvider.getCargaAPI(idUsuario);
        future.then((response) => {
              //  print('${jsonDecode(response.body)}'),
              listaCarga = jsonDecode(response.body),
              if (listaCarga.isNotEmpty)
                {
                  listaCarga.forEach(
                    (element) => {
                      listaIdEntrega.add(int.tryParse(element['idEntrega'].toString())),
                      entrega = Entrega(),
                      entrega.pendente = 1,
                      entrega = entrega.toObject(entrega, element),
                      entregaProvider.insert(entrega.toMap()),
                    },
                  ),
                  getEntregasAssociadas(context, idUsuario, listaIdEntrega),
                }
              else
                {
                  loading.value = false,
                }
            });
      } catch (Exc) {
        print('$Exc');
        Utility.snackbar(context, 'ERRO NO DOWNLOAD DA OCORRENCIA: $Exc');
      }
    } else {
      Utility.snackbar(context, 'SEM CONEXAO COM A INTERNET!');
    }
  }

  Future<void> getEntregasAssociadas(BuildContext context, int idUsuario, List<int> listaIdEntrega) async {
    try {
      String queryIdEntrega = '';
      int index = 0;
      listaIdEntrega.forEach((idEntrega) {
        if (index > 0 && index < listaIdEntrega.length) {
          queryIdEntrega += ',${idEntrega}';
        } else {
          queryIdEntrega += idEntrega.toString();
        }
        index++;
      });
      var distribuicaoDto = {};
      var lista = [];
      final future = entregaProvider.getListaIdEntrega(queryIdEntrega);
      future.then(
        (result) async => {
          result.forEach((element) {
            lista.add(element['id']);
          }),
          distribuicaoDto = {
            'idUsuario': idUsuario,
            'listaIdEntrega': lista,
          },
          await entregaProvider.alterarAssociadoMobileAPI(distribuicaoDto),
          loading.value = false,
        },
      );
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO SINCRONIZAR ENTREGA: $Exc');
    }
  }

  Future<void> iniciarSincronismoRetornoEntrega(BuildContext context) async {
    loading.value = true;
    try {
      RetornoEntrega retornoRest;
      List<RetornoEntrega> listaRetorno = [];
      final future = entregaProvider.getListaRetornoEntregaPendenteSinc();
      future.then(
        (result) => {
          if (result.isNotEmpty)
            {
              result.forEach(
                (element) => {
                  retornoRest = RetornoEntrega(),
                  retornoRest = retornoRest.toObject(retornoRest, element),
                  listaRetorno.add(retornoRest),
                },
              ),
              sincronizarRetornoEntrega(context, listaRetorno),
            }
          else
            {
              loading.value = false,
            }
        },
      );
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO OBTER LISTA DE ENNTREGA: $Exc');
    }
  }

  Future<void> sincronizarRetornoEntrega(BuildContext context, List<RetornoEntrega> listaRetorno) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        //print('${jsonEncode(listaRetorno)}');
        final future = entregaProvider.sincronizarRetorno(listaRetorno);
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (idEntrega) => {
                entregaProvider.marcarRetornoEnviadoPorIdEntrega(idEntrega),
              },
            ),
            loading.value = false,
          },
        );
      } catch (Exc) {
        loading.value = false;
        print('$Exc');
        Utility.snackbar(context, 'ERRO SINCRONIZAR ENTREGA: $Exc');
      }
    } else {
      loading.value = false;
      Utility.snackbar(context, 'SEM CONEXAO DE INTERNET PARA SINCRONIZAR');
    }
  }

  Future<void> iniciarSincronismoFoto(BuildContext context) async {
    loading.value = true;
    try {
      RetornoFoto retornoFoto;
      List<RetornoFoto> listaFoto = [];
      final future = fotoProvider.getListaFotoPendenteSinc();
      future.then(
        (result) => {
          if (result.isNotEmpty)
            {
              result.forEach(
                (element) => {
                  retornoFoto = RetornoFoto(),
                  retornoFoto.idUsuario = int.tryParse(element['idUsuario'].toString()),
                  retornoFoto.nome = element['nome'],
                  retornoFoto.dataExecucao = element['dataExecucao'],
                  retornoFoto.codBarras = element['codBarras'],
                  retornoFoto.instalacao = element['instalacao'],
                  retornoFoto.imagem = element['imagem'],
                  retornoFoto.imei = element['imei'],
                  retornoFoto.pendente = int.tryParse(element['pendente'].toString()),
                  retornoFoto.assinatura = int.tryParse(element['assinatura'].toString()),
                  listaFoto.add(retornoFoto),
                },
              ),
              sincronizarFoto(context, listaFoto),
            }
          else
            {
              loading.value = false,
            }
        },
      );
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO OBTER LISTA DE FOTOS: $Exc');
    }
  }

  Future<void> sincronizarFoto(BuildContext context, List<RetornoFoto> listaFoto) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        //print('${jsonEncode(listaRetorno)}');
        final future = fotoProvider.sincronizarFoto(listaFoto);
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (codBarras) => {
                fotoProvider.marcarFotoEnviadoPorCodBarras(codBarras),
              },
            ),
            loading.value = false,
          },
        );
      } catch (Exc) {
        loading.value = false;
        print('$Exc');
        Utility.snackbar(context, 'ERRO SINCRONIZAR FOTO: $Exc');
      }
    } else {
      loading.value = false;
      Utility.snackbar(context, 'SEM CONEXAO DE INTERNET PARA SINCRONIZAR');
    }
  }

  Future<void> _desassociar(BuildContext context, int idUsuario) async {
    if (this.contador == 0) {
      setState(() {
        this.contador++;
      });
      await Utility.getStatusNet(context);
      if (Utility.isNet) {
        try {
          loading.value = true;
          String arrayIdEntrega = '';
          int index = 0;
          var distribuicaoDto = {};
          var lista = [];
          final future = entregaProvider.getDesassociadosAPI(idUsuario);
          future.then(
            (response) async => {
              jsonDecode(response.body),
              lista = jsonDecode(response.body),
              if (lista.isNotEmpty)
                {
                  lista.forEach((idEntrega) async {
                    if (index > 0 && index < lista.length) {
                      arrayIdEntrega += ',${idEntrega}';
                    } else {
                      arrayIdEntrega += idEntrega.toString();
                    }
                    index++;
                  }),
                  await entregaProvider.desassociar(arrayIdEntrega),
                  distribuicaoDto = {
                    'idUsuario': idUsuario,
                    'listaIdEntrega': lista,
                  },
                  await entregaProvider.limparDesassociadoAPI(distribuicaoDto),
                },
              loading.value = false,
            },
          );
        } catch (Exc) {
          loading.value = false;
          print('$Exc');
          Utility.snackbar(context, 'ERRO AO DESASSOCIAR: $Exc');
        }
      } else {
        loading.value = false;
        Utility.snackbar(context, 'SEM CONEXAO DE INTERNET PARA DESASSOCIAR');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    _checkInternet(context);
    _desassociar(context, user.id);
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
            onPressed: () => getCargaEntrega(context, user.id),
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
                            onPressed: () => iniciarSincronismoRetornoEntrega(context),
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
                            onPressed: () => iniciarSincronismoFoto(context),
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
                            // onPressed: () => _setPage(context, AppRoutes.PRODUTIVIDADE, user),
                            onPressed: null,
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
                            onPressed: () => _createBackup(context),
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
                            onPressed: () => _apagarDados(context, user.id),
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
