// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations, avoid_returning_null_for_void, prefer_const_constructors, avoid_print

import 'package:app_doc/component/circular_progress.dart';
import 'package:app_doc/provider/entrega_provider.dart';
import 'package:flutter/material.dart';

import '../component/info_app.dart';
import '../model/user.dart';

class EstatisticaScreen extends StatefulWidget {
  @override
  State<EstatisticaScreen> createState() => _EstatisticaScreenState();
}

class _EstatisticaScreenState extends State<EstatisticaScreen> {
  final loading = ValueNotifier<bool>(false);
  final entregaProvider = EntregaProvider();
  late int totalEntrega = 0;
  late int totalLido = 0;
  late int pendenteEnvioEntrega = 0;
  late int enviadoEntrega = 0;
  late int totalFoto = 0;
  late int pendenteEnvioFoto = 0;
  late int enviadoFoto = 0;
  late int ocorrencia = 0;
  final ButtonStyle styleOcorrencia = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900), backgroundColor: Colors.red);
  final ButtonStyle styleFoto = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900), backgroundColor: Colors.blueGrey[400]);

  @override
  initState() {
    super.initState();
    getEstatistica();
  }

  Future<void> getEstatistica() async {
    loading.value = true;
    await entregaProvider.getEstatistica().then(
          (result) => {
            setState(
              () {
                totalEntrega = result[0]['TOTAL'] != null ? int.tryParse(result[0]['TOTAL'].toString())! : 0;
                totalLido = result[0]['LIDO'] != null ? int.tryParse(result[0]['LIDO'].toString())! : 0;
                pendenteEnvioEntrega = result[0]['PENDENTE_ENVIO'] != null ? int.tryParse(result[0]['PENDENTE_ENVIO'].toString())! : 0;
                enviadoEntrega = result[0]['ENVIADO'] != null ? int.tryParse(result[0]['ENVIADO'].toString())! : 0;
                totalFoto = int.tryParse(result[0]['FOTOS_TOTAL'].toString())!;
                pendenteEnvioFoto = int.tryParse(result[0]['FOTOS_PENDENTES'].toString())!;
                enviadoFoto = int.tryParse(result[0]['FOTOS_ENVIADA'].toString())!;
                ocorrencia = result[0]['OCORRENCIA'] != null ? int.tryParse(result[0]['OCORRENCIA'].toString())! : 0;
              },
            ),
            loading.value = false,
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESTATISTICA'),
      ),
      body: ValueListenableBuilder(
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
                        child: ElevatedButton(
                          child: Text(
                            'Total\n\n$totalEntrega',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'Lido\n\n$totalLido',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'Pendente Envio\n\n$pendenteEnvioEntrega',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'Enviado\n\n$enviadoEntrega',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: styleFoto,
                          child: Text(
                            'Total Foto\n\n$totalFoto',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: styleFoto,
                          child: Text(
                            'Foto Pendente\n\n$pendenteEnvioFoto',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: styleFoto,
                          child: Text(
                            'Foto Enviada\n\n$enviadoFoto',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: styleOcorrencia,
                          child: Text(
                            'Ocorrencia\n\n$ocorrencia',
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ),
                  ],
                ),
                InfoApp(user),
              ],
            );
          }
        },
      ),
    );
  }
}
