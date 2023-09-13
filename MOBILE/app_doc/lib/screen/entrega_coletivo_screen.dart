// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, sort_child_properties_last, avoid_returning_null_for_void, unnecessary_null_comparison, unused_element, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app_doc/component/circular_progress.dart';
import 'package:app_doc/provider/entrega_provider.dart';
import 'package:app_doc/util/utility.dart';
import 'package:flutter/material.dart';

class EntregaColetivoScreen extends StatefulWidget {
  @override
  State<EntregaColetivoScreen> createState() => _EntregaColetivoScreenState();
}

class _EntregaColetivoScreenState extends State<EntregaColetivoScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final loading = ValueNotifier<bool>(false);
  final entregaProvider = EntregaProvider();
  //late int totalEntrega = 0;
  final List<String> listaCodBarras = [];
  late String codBarras = '';

  Future<void> readQRCode(BuildContext context) async {
    try {
      if (_numeroController.text.isEmpty || _numeroController.text.trim() == '') {
        Utility.snackbar(context, 'INFORME O Nº DO ENDERECO ANTES DE SCANNEAR!');
        return null;
      }
      String code = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'CANCELAR',
        true,
        ScanMode.BARCODE,
      );
      setState(() {
        codBarras = code != '-1' ? code : '';
      });
      print('CODE: $code');
      if (code == '-1') return;
      await getEntregasColetivo(context, codBarras);
    } catch (Exc) {
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO LER O CODIGO!: $Exc');
    }
  }

  Future<void> getEntregasColetivo(BuildContext context, String codBarras) async {
    loading.value = true;
    // ignore: unused_local_variable
    String endereco = '';
    String charAt = '';
    try {
      await entregaProvider.getEntregasColetivoPendente(codBarras).then((result) => {
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
                }),
                //listaCodBarras.add(result[0]['codBarras']),
              }
            else
              {
                Utility.snackbar(context, 'CODIGO DE BARRAS NAO ENCONTRADO!'),
              },
            loading.value = false,
          });
    } catch (Exc) {
      loading.value = false;
      print('$Exc');
      Utility.snackbar(context, 'ERRO AO BUSCAR COLETIVO: $Exc');
    }
  }

  Future<void> _entregar(BuildContext context) async {
    if (codBarras.trim() == '') {
      Utility.snackbar(context, 'PRIMEIRO SCANNEAR A CONTA PARA REALIZAR A ENTREGAR!');
      return;
    }
    print('REALIZANDO ENTREGA...! ${listaCodBarras.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COLETIVO - QTD: ${listaCodBarras.length}'),
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
                            //labelText: '',
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                            hintText: 'Nº DO ENDERECO',
                          ),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
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
                              onPressed: () => _entregar(context),
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

/*
if (data.rows.length > 0) {
              entrega.id = data.rows.item(0).id;
              entrega.idImportacao = data.rows.item(0).idImportacao;
              entrega.idGrupoFaturamento = data.rows.item(0).idGrupoFaturamento;
              entrega.grupoFaturamento = data.rows.item(0).grupoFaturamento;
              entrega.roteiro = data.rows.item(0).roteiro;
              entrega.endereco = data.rows.item(0).endereco;
              entrega.cep = data.rows.item(0).cep;
              entrega.municipio = data.rows.item(0).municipio;
              entrega.codigo = data.rows.item(0).codigo;
              entrega.codigoCliente = data.rows.item(0).codigoCliente;
              entrega.sequencia = data.rows.item(0).sequencia;
              entrega.observacao = data.rows.item(0).observacao;
            }
*/
