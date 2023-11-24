// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations, use_build_context_synchronously, unused_element, non_constant_identifier_names, avoid_print, avoid_function_literals_in_foreach_calls, sort_child_properties_last

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_doc/model/retorno_entrega.dart';
import 'package:app_doc/model/retorno_foto.dart';
import 'package:app_doc/model/user.dart';
import 'package:app_doc/provider/foto_provider.dart';
import 'package:app_doc/provider/ocorrencia_provider.dart';
import 'package:app_doc/screen/preview_screen.dart';
import 'package:app_doc/widgets/anexo.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app_doc/component/circular_progress.dart';
import 'package:app_doc/provider/entrega_provider.dart';
import 'package:app_doc/util/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class EntregaScreen extends StatefulWidget {
  @override
  State<EntregaScreen> createState() => _EntregaScreenState();
}

class _EntregaScreenState extends State<EntregaScreen> {
  final TextEditingController _obsController = TextEditingController();
  final loading = ValueNotifier<bool>(false);
  final entregaProvider = EntregaProvider();
  final fotoProvider = FotoProvider();
  final ocorrenciaProvider = OcorrenciaProvider();
  String codBarras = '';
  String statusCodBarras = '';
  Color colorWifi = Colors.white;
  Color colorStatusFatura = Colors.green[800];
  File arquivo;
  String versaoApp = Utility.getDadosApp().values.elementAt(5);
  final dropValue = ValueNotifier('');
  final List<String> dropOption = [];
  var isExiste = [];

  @override
  initState() {
    super.initState();
    _getStatusNet(context);
    _determinePosition();
    _getListaNomeOcorrencia();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados!');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('As permissões de localização são negadas permanentemente, não podemos solicitar permissões!');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('As permissões de localização são negadas (valor real: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  showPreview(File file) async {
    file = await Get.to(() => PreviewScreen(file: file));
    if (file != null) {
      setState(() {
        arquivo = file;
        Get.back();
      });
    }
  }

  removePhoto() {
    setState(() {
      arquivo = null;
    });
  }

  void _getStatusNet(BuildContext context) async {
    await Utility.getStatusNet(context);
    if (!Utility.isNet) {
      Utility.snackbar(context, 'SEM CONEXAO COM A INTERNET!');
    }
  }

  void _setColorIconWifi(BuildContext context) async {
    await Utility.getStatusNet(context);
    setState(() {
      if (Utility.isNet) {
        setState(() {
          colorWifi = Colors.white;
        });
      } else {
        setState(() {
          colorWifi = Colors.red[800];
        });
      }
    });
  }

  Future<void> readQRCode(BuildContext context) async {
    try {
      statusCodBarras = '';
      codBarras = '';
      setState(() {
        colorStatusFatura = Colors.green[800];
      });
      String code = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'CANCELAR',
        true,
        ScanMode.BARCODE,
      );
      setState(() {
        codBarras = code != '-1' ? code : '';
        statusCodBarras = 'FATURA ESCANEADA COM SUCESSO!';
      });
      if (code == '-1') return;
      // await getEntregasColetivo(context, codBarras);
    } catch (Exc) {
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO LER O CODIGO!: $Exc');
    }
  }

  Future<void> _getListaNomeOcorrencia() async {
    if (dropOption.isNotEmpty) {
      setState(() {
        dropOption.clear();
      });
    }
    await ocorrenciaProvider.getOcorrenciaAll().then((result) => {
          result.forEach(
            (element) => {
              dropOption.add(element['nome']),
            },
          ),
          setState(() {
            dropOption;
          }),
        });
  }

  Future<void> _entregar(BuildContext context, User user) async {
    if (codBarras.trim() == '') {
      Utility.snackbar(context, 'PRIMEIRO ESCANEAR A CONTA PARA REALIZAR A ENTREGAR!');
      return;
    }
    try {
      loading.value = true;
      Position position = await _determinePosition();
      RetornoEntrega retornoRest = RetornoEntrega();
      retornoRest.listaIdEntrega = [];
      List<String> listaFaturasEntregues = [];
      var ocorrencia = await ocorrenciaProvider.getOcorrenciaPorNome(dropValue.value.toString());
      if (ocorrencia.isEmpty) {
        loading.value = false;
        Utility.snackbar(context, 'INFORME UMA OCORRENCIA!');
        return;
      }
      isExiste = await entregaProvider.getListaRetornoEntrega(codBarras);
      if (isExiste.isNotEmpty) {
        loading.value = false;
        setState(() {
          colorStatusFatura = Colors.red[800];
        });
        statusCodBarras = 'FATURA JÁ ENTREGUE!';
        Utility.snackbar(context, 'FATURA JÁ ENTREGUE!');
        return;
      }
      await entregaProvider.getEntregaPorCodBarras(codBarras).then(
            (result) async => {
              if (result.isNotEmpty)
                {
                  //  print('ENTREI NO IF'),
                  result.forEach((element) {
                    print('${jsonEncode(element)}');
                    retornoRest.listaIdEntrega.add(int.tryParse(element['id'].toString()));
                    retornoRest.idImportacao = int.tryParse(element['idImportacao'].toString());
                    retornoRest.idEntrega = int.tryParse(element['id'].toString());
                    retornoRest.idUsuario = user.id;
                    retornoRest.idOcorrencia = ocorrencia[0]['id'];
                    retornoRest.grupoFaturamento = int.tryParse(element['grupoFaturamento'].toString());
                    retornoRest.roteiro = element['roteiro'];
                    retornoRest.dataExecucao = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
                    retornoRest.instalacao = null;
                    retornoRest.medidor = null;
                    retornoRest.latitude = position.latitude.toString();
                    retornoRest.longitude = position.longitude.toString();
                    retornoRest.imei = '';
                    retornoRest.codBarras = codBarras;
                    retornoRest.codigo = element['codCliente'];
                    retornoRest.observacao = _obsController.text == null ? '' : _obsController.text.trim();
                    retornoRest.assinatura = 0;
                    retornoRest.predio = 0;
                    retornoRest.pendente = 1;
                    retornoRest.matricula = '';
                    retornoRest.versaoApp = versaoApp;
                    /* entregaProvider.insertRetornoEntrega(
                      {
                        'idImportacao': retornoRest.idImportacao,
                        'idEntrega': retornoRest.idEntrega,
                        'idUsuario': retornoRest.idUsuario,
                        'idOcorrencia': retornoRest.idOcorrencia,
                        'grupoFaturamento': retornoRest.grupoFaturamento,
                        'dataExecucao': retornoRest.dataExecucao,
                        'roteiro': retornoRest.roteiro,
                        'instalacao': retornoRest.instalacao,
                        'medidor': retornoRest.medidor,
                        'matricula': retornoRest.matricula,
                        'codBarras': retornoRest.codBarras,
                        'codCliente': retornoRest.codigo,
                        'imei': retornoRest.imei,
                        'observacao': retornoRest.observacao,
                        'latitude': retornoRest.latitude,
                        'longitude': retornoRest.longitude,
                        'assinatura': retornoRest.assinatura,
                        'predio': retornoRest.predio,
                        'pendente': retornoRest.pendente,
                        'versaoApp': retornoRest.versaoApp,
                      },
                    );*/
                  }),
                }
              else
                {
                  //   print('ENTREI NO ELSE'),
                  retornoRest.listaIdEntrega.add(0),
                  retornoRest.idImportacao = 0,
                  retornoRest.idEntrega = 0,
                  retornoRest.idUsuario = user.id,
                  retornoRest.idOcorrencia = ocorrencia[0]['id'],
                  retornoRest.grupoFaturamento = 9999,
                  retornoRest.roteiro = '9999',
                  retornoRest.dataExecucao = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                  retornoRest.instalacao = null,
                  retornoRest.medidor = null,
                  retornoRest.latitude = position.latitude.toString(),
                  retornoRest.longitude = position.longitude.toString(),
                  retornoRest.imei = '',
                  retornoRest.codBarras = codBarras,
                  retornoRest.codigo = '0',
                  retornoRest.observacao = _obsController.text == null ? '' : _obsController.text.trim(),
                  retornoRest.assinatura = 0,
                  retornoRest.predio = 0,
                  retornoRest.pendente = 1,
                  retornoRest.matricula = '',
                  retornoRest.versaoApp = versaoApp,
                  /*  entregaProvider.insertRetornoEntrega(
                    {
                      'idImportacao': retornoRest.idImportacao,
                      'idEntrega': retornoRest.idEntrega,
                      'idUsuario': retornoRest.idUsuario,
                      'idOcorrencia': retornoRest.idOcorrencia,
                      'grupoFaturamento': retornoRest.grupoFaturamento,
                      'dataExecucao': retornoRest.dataExecucao,
                      'roteiro': retornoRest.roteiro,
                      'instalacao': retornoRest.instalacao,
                      'medidor': retornoRest.medidor,
                      'matricula': retornoRest.matricula,
                      'codBarras': retornoRest.codBarras,
                      'codCliente': retornoRest.codigo,
                      'imei': retornoRest.imei,
                      'observacao': retornoRest.observacao,
                      'latitude': retornoRest.latitude,
                      'longitude': retornoRest.longitude,
                      'assinatura': retornoRest.assinatura,
                      'predio': retornoRest.predio,
                      'pendente': retornoRest.pendente,
                      'versaoApp': retornoRest.versaoApp,
                    },
                  ),*/
                },
              //  print('RETORNO REST: ${jsonEncode(retornoRest)}'),
              await entregaProvider.insertRetornoEntrega(
                {
                  'idImportacao': retornoRest.idImportacao,
                  'idEntrega': retornoRest.idEntrega,
                  'idUsuario': retornoRest.idUsuario,
                  'idOcorrencia': retornoRest.idOcorrencia,
                  'grupoFaturamento': retornoRest.grupoFaturamento,
                  'dataExecucao': retornoRest.dataExecucao,
                  'roteiro': retornoRest.roteiro,
                  'instalacao': retornoRest.instalacao,
                  'medidor': retornoRest.medidor,
                  'matricula': retornoRest.matricula,
                  'codBarras': retornoRest.codBarras,
                  'codCliente': retornoRest.codigo,
                  'imei': retornoRest.imei,
                  'observacao': retornoRest.observacao,
                  'latitude': retornoRest.latitude,
                  'longitude': retornoRest.longitude,
                  'assinatura': retornoRest.assinatura,
                  'predio': retornoRest.predio,
                  'pendente': retornoRest.pendente,
                  'versaoApp': retornoRest.versaoApp,
                },
              ),
            },
          );
      if (arquivo != null) {
        File imagem = File(arquivo.path);
        Uint8List imagebytes = await imagem.readAsBytes();
        //DateFormat("y-MM-d HH:mm:ss").format(DateTime.now())
        var foto = RetornoFoto();
        foto.codBarras = codBarras;
        foto.dataExecucao = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        foto.instalacao = '';
        foto.nome = '${user.id}${DateFormat("yMdHHmmsssss").format(DateTime.now())}';
        foto.imagem = 'data:image/jpg;base64,${base64.encode(imagebytes)}';
        foto.imei = '';
        foto.pendente = 1;
        foto.assinatura = 0;
        fotoProvider.insert(
          {
            'idUsuario': user.id,
            'codBarras': foto.codBarras,
            'dataExecucao': foto.dataExecucao,
            'instalacao': foto.instalacao,
            'nome': '${codBarras}_${foto.nome}.jpg',
            'imagem': foto.imagem,
            'imei': foto.imei,
            'pendente': foto.pendente,
            'assinatura': foto.assinatura,
          },
        );
      }
      listaFaturasEntregues.add(codBarras);
      if (listaFaturasEntregues.isNotEmpty) {
        listaFaturasEntregues.forEach((element) async => {
              await entregaProvider.getListaRetornoEntrega(element).then(
                    (result) => {
                      if (result.isNotEmpty)
                        {
                          result.forEach(
                            (element) => {entregaProvider.setFaturaEntregue(element['codBarras'])},
                          ),
                          sincronizarRetorno(context, retornoRest)
                        }
                      else
                        {
                          loading.value = false,
                        }
                    },
                  ),
            });
        iniciarSincronismoFoto(context);
      } else {
        loading.value = false;
      }
      codBarras = '';
      statusCodBarras = '';
      _obsController.text = '';
      dropValue.value = '';
      arquivo = null;
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO SALVAR A FATURA: $Exc');
    }
  }

  Future<void> sincronizarRetorno(BuildContext context, RetornoEntrega retornoEntrega) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        loading.value = true;
        final List<RetornoEntrega> listaRetorno = [];
        listaRetorno.add(retornoEntrega);
        //print('LISTA RETORNO ENTREGA');
        //print('${jsonEncode(listaRetorno).toString()}');
        //print('${jsonEncode(listaRetorno)}');
        final future = entregaProvider.sincronizarRetorno(listaRetorno);
        future.then(
          (response) => {
            // print('RESPONSE: ${response.body}'),
            if (response.body.isNotEmpty)
              {
                jsonDecode(response.body).forEach(
                  (idEntrega) => {
                    entregaProvider.marcarRetornoEnviadoPorIdEntrega(idEntrega),
                  },
                ),
              },
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

  @override
  Widget build(BuildContext context) {
    _setColorIconWifi(context);
    final user = ModalRoute.of(context).settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('INDIVIDUAL'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.camera_alt_sharp,
              size: 40,
              color: Colors.white,
            ),
            padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
            onPressed: () => Get.to(
              () => CameraCamera(onFile: (file) => showPreview(file)),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.wifi,
              size: 40,
              color: colorWifi,
            ),
            padding: const EdgeInsets.fromLTRB(1, 1, 25, 1),
            onPressed: () => {},
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) {
          if (value) {
            return CircularProgressComponent();
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                        //padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Text(
                          '$statusCodBarras',
                          style: TextStyle(
                            color: colorStatusFatura,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(2),
                        child: arquivo != null ? Anexo(arquivo: arquivo) : const Text(''),
                      ),
                      arquivo != null
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                    onPressed: () => removePhoto(),
                                  ),
                                ),
                              ),
                            )
                          : const Text(''),
                      // codBarras.trim() != '' ?
                      Center(
                        child: ValueListenableBuilder(
                          valueListenable: dropValue,
                          builder: (BuildContext context, String value, _) {
                            return Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down_circle_sharp),
                                  hint: const Text('SELECIONE A OCORRENCIA'),
                                  decoration: InputDecoration(
                                    label: const Text('OCORRENCIA'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  value: (value.isEmpty ? null : value),
                                  onChanged: (selected) => dropValue.value = selected.toString(),
                                  items: dropOption
                                      .map((op) => DropdownMenuItem(
                                            value: op,
                                            child: Text(op),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      //        : const Text(''),
                      ///  codBarras.trim() != '' ?
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        padding: const EdgeInsets.fromLTRB(3, 5, 3, 0),
                        child: TextField(
                          controller: _obsController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            labelText: 'OBSERVACAO',
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                            hintText: 'OBSERVACAO',
                          ),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      )
                      //  : const Text(''),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 60,
                            width: 160,
                            child: ElevatedButton(
                              child: const Text('ENTREGAR'),
                              onPressed: () => _entregar(context, user),
                              style: TextButton.styleFrom(
                                elevation: 10,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 60,
                            width: 160,
                            child: ElevatedButton(
                              child: const Text('ESCANEAR'),
                              onPressed: () => readQRCode(context),
                              style: TextButton.styleFrom(
                                elevation: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
