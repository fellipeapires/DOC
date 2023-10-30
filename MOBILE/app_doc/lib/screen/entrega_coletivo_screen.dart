// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, sort_child_properties_last, avoid_returning_null_for_void, unnecessary_null_comparison, unused_element, import_of_legacy_library_into_null_safe, use_build_context_synchronously,, avoid_function_literals_in_foreach_calls, unused_local_variable, avoid_init_to_null, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, await_only_futures

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_doc/model/retorno_entrega.dart';
import 'package:app_doc/model/retorno_foto.dart';
import 'package:app_doc/model/user.dart';
import 'package:app_doc/provider/foto_provider.dart';
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

class EntregaColetivoScreen extends StatefulWidget {
  @override
  State<EntregaColetivoScreen> createState() => _EntregaColetivoScreenState();
}

class _EntregaColetivoScreenState extends State<EntregaColetivoScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final loading = ValueNotifier<bool>(false);
  final entregaProvider = EntregaProvider();
  final fotoProvider = FotoProvider();
  int qtdEntrega = 0;
  List listaCodBarras = [];
  String codBarras = '';
  String enderecoColetivo = '';
  Color colorWifi = Colors.white;
  File arquivo;
  String versaoApp = Utility.getDadosApp().values.elementAt(5);

  @override
  initState() {
    super.initState();
    getQtdEntregasPendente(context);
    _getStatusNet(context);
    _determinePosition();
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
        colorWifi = Colors.white;
      } else {
        colorWifi = Colors.red[800];
      }
    });
  }

  Future<void> readQRCode(BuildContext context) async {
    try {
      if (_numeroController.text.isEmpty || _numeroController.text.trim() == '') {
        Utility.snackbar(context, 'INFORME O Nº DO ENDERECO ANTES DE SCANNEAR!');
        return null;
      }
      codBarras = '';
      enderecoColetivo = '';
      String code = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'CANCELAR',
        true,
        ScanMode.BARCODE,
      );
      setState(() {
        codBarras = code != '-1' ? code : '';
      });
      if (code == '-1') return;
      await getEntregasColetivo(context, codBarras);
    } catch (Exc) {
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO LER O CODIGO!: $Exc');
    }
  }

  Future<void> getQtdEntregasPendente(BuildContext context) async {
    try {
      loading.value = true;
      codBarras = '';
      enderecoColetivo = '';
      _numeroController.text = '';
      await entregaProvider.getQtdEntregasPendente().then((result) => {
            setState(() {
              qtdEntrega = result[0]['QTD'];
            }),
          });
      loading.value = false;
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO BUSCAR QTD PENDENTE: $Exc');
    }
  }

  Future<void> getEntregasColetivo(BuildContext context, String codBarras) async {
    loading.value = true;
    String endereco = '';
    String charAt = '';
    int index = 0;
    try {
      await entregaProvider.getEnderecoColetivoPendente(codBarras).then(
            (result) => {
              if (result.isNotEmpty)
                {
                  setState(() {
                    charAt = result[0]['endereco'] ?? '';
                    for (int i = 0; i < charAt.toString().length; i++) {
                      if (charAt[i] == '0' || charAt[i] == '1' || charAt[i] == '2' || charAt[i] == '3' || charAt[i] == '4' || charAt[i] == '5' || charAt[i] == '6' || charAt[i] == '7' || charAt[i] == '8' || charAt[i] == '9') {
                        break;
                      }
                      endereco += charAt[i];
                    }
                    enderecoColetivo = endereco;
                  }),
                }
              else
                {
                  enderecoColetivo = 'BUSCA SEM RESULTADO!',
                  Utility.snackbar(context, 'CODIGO DE BARRAS NAO ENCONTRADO!'),
                },
              loading.value = false,
            },
          );
      setState(() {
        listaCodBarras = [];
      });
      if (enderecoColetivo.trim() == '') {
        return;
      }
      var entity;
      List lista = [];
      await entregaProvider.getEntregasColetivoPendente(enderecoColetivo.trim(), _numeroController.text.trim()).then(
            (result) => {
              if (result.isNotEmpty)
                {
                  result.forEach(
                    (element) => {
                      entity = {
                        'codBarras': element['codBarras'],
                        'endereco': element['endereco'],
                      },
                      setState(() {
                        lista.add(element);
                      }),
                    },
                  ),
                  setState(() {
                    lista.retainWhere((endereco) {
                      return endereco.toString().toLowerCase().contains('${_numeroController.text.trim()}'.toLowerCase());
                    });
                    listaCodBarras = lista;
                    enderecoColetivo += ' - QTD: ${listaCodBarras.length}';
                  }),
                }
            },
          );
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO BUSCAR COLETIVO: $Exc');
    }
  }

  Future<void> _entregar(BuildContext context, User user) async {
    if (codBarras.trim() == '' || listaCodBarras.isEmpty) {
      Utility.snackbar(context, 'PRIMEIRO SCANNEAR A CONTA PARA REALIZAR A ENTREGAR!');
      return;
    }
    try {
      loading.value = true;
      if (arquivo != null) {
        File imagem = File(arquivo.path);
        Uint8List imagebytes = await imagem.readAsBytes();
        //DateFormat("y-MM-d HH:mm:ss").format(DateTime.now())
        var foto = RetornoFoto();
        foto.codBarras = codBarras;
        foto.dataExecucao = DateFormat("y-MM-d HH:mm:ss").format(DateTime.now());
        foto.instalacao = '';
        foto.nome = '${user.id}${DateFormat("yMdHHmmsssss").format(DateTime.now())}';
        foto.imagem = 'data:image/jpg;base64,${base64.encode(imagebytes)}';
        foto.pendente = 1;
        foto.assinatura = 0;
        fotoProvider.insert(
          {
            'idUsuario': user.id,
            'codBarras': foto.codBarras,
            'dataExecucao': foto.dataExecucao,
            'instalacao': foto.instalacao,
            'nome': foto.nome,
            'imagem': foto.imagem,
            'pendente': foto.pendente,
            'assinatura': foto.assinatura,
          },
        );
      }
      Position position = await _determinePosition();
      RetornoEntrega retornoRest = RetornoEntrega();
      retornoRest.listaIdEntrega = [];
      List<String> listaFaturasEntregues = [];
      listaCodBarras.forEach((element) => {
            retornoRest.listaIdEntrega.add(int.tryParse(element['id'].toString())),
            retornoRest.idEntrega = int.tryParse(element['id'].toString()),
            retornoRest.idUsuario = user.id,
            retornoRest.idOcorrencia = 1,
            retornoRest.dataExecucao = DateFormat("y-MM-d HH:mm:ss").format(DateTime.now()),
            retornoRest.latitude = position.latitude.toString(),
            retornoRest.longitude = position.longitude.toString(),
            retornoRest.imei = '',
            retornoRest.observacao = '',
            retornoRest.assinatura = 0,
            retornoRest.matricula = '',
            retornoRest.versaoApp = versaoApp,
            listaFaturasEntregues.add(element['codBarras']),
            entregaProvider.insertRetornoEntrega(
              {
                'idImportacao': int.tryParse(element['idImportacao'].toString()),
                'idEntrega': int.tryParse(element['id'].toString()),
                'idUsuario': int.tryParse(user.id.toString()),
                'idOcorrencia': 1,
                'grupoFaturamento': int.tryParse(element['grupoFaturamento'].toString()),
                'dataExecucao': retornoRest.dataExecucao,
                'roteiro': element['roteiro'],
                'instalacao': null,
                'medidor': null,
                'matricula': retornoRest.matricula,
                'codBarras': element['codBarras'],
                'codCliente': element['codCliente'],
                'imei': retornoRest.imei,
                'observacao': retornoRest.observacao,
                'altitude': '0',
                'latitude': position.latitude.toString(),
                'longitude': position.longitude.toString(),
                'assinatura': retornoRest.assinatura,
                'predio': 1,
                'pendente': 1,
                'versaoApp': versaoApp,
              },
            )
          });
      arquivo = null;
      if (listaFaturasEntregues.isNotEmpty) {
        listaFaturasEntregues.forEach((element) async => {
              await entregaProvider.getListaRetornoEntrega(element).then(
                    (result) => {
                      if (result.isNotEmpty)
                        {
                          result.forEach(
                            (element) => {entregaProvider.setFaturaEntregue(element['codBarras'])},
                          ),
                          sincronizarRetornoColetivo(context, retornoRest),
                        }
                    },
                  ),
            });
      }
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO SALVAR FATURAS: $Exc');
    }
  }

  Future<void> sincronizarRetornoColetivo(BuildContext context, RetornoEntrega retornoEntrega) async {
    await Utility.getStatusNet(context);
    if (Utility.isNet) {
      try {
        loading.value = true;
        List<RetornoEntrega> listaRetorno = [];
        listaRetorno.add(retornoEntrega);
        final future = entregaProvider.sincronizarRetorno(listaRetorno);
        future.then(
          (response) => {
            jsonDecode(response.body).forEach(
              (idEntrega) => {
                entregaProvider.marcarRetornoEnviadoPorIdEntrega(idEntrega),
              },
            ),
            getQtdEntregasPendente(context),
          },
        );
      } catch (Exc) {
        loading.value = false;
        print('$Exc');
        Utility.snackbar(context, 'ERRO SINCRONIZAR ENTREGA: $Exc');
      }
    } else {
      getQtdEntregasPendente(context);
      //loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _setColorIconWifi(context);
    final user = ModalRoute.of(context).settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text('COLETIVO - QTD: $qtdEntrega'),
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
            // onPressed: () => openCamera(context),
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
                        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        //padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Text(
                          'PRIMEIRO INFORME O Nº DO ENDERECO!',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                        padding: const EdgeInsets.all(5),
                        child: TextField(
                          controller: _numeroController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            labelText: 'Nº DO ENDERECO',
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                            hintText: 'Nº DO ENDERECO',
                          ),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                        child: Text(
                          '$enderecoColetivo',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        child: arquivo != null ? Anexo(arquivo: arquivo) : const Text(''),
                      ),
                      arquivo != null
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () => removePhoto(),
                                  ),
                                ),
                              ),
                            )
                          : const Text(''),
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
                              child: const Text('SCANNEAR'),
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
