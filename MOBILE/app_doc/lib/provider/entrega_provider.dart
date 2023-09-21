// ignore_for_file: unused_import

import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/provider/api_url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class EntregaProvider {
  final _apiUrl = ApiUrlProvider.getApiUrl();

  Future getCargaAPI(int idUsuario) {
    return http.get(
      Uri.parse('$_apiUrl/distribuicao/carregarentregamobile/$idUsuario'),
    );
  }

  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('entrega', data);
  }

  Future<List<Map<String, dynamic>>> getEstatistica() async {
    final db = await DatabaseApp.dataBase();
    return db.rawQuery(
        'SELECT SUM(CASE WHEN A.ID is not null THEN 1 ELSE 0 END) AS LIDO, SUM(CASE WHEN A.PENDENTE=0 THEN 1 ELSE 0 END) AS ENVIADO, (SUM(CASE WHEN A.ID is not null THEN 1 ELSE 0 END) - SUM(CASE WHEN A.PENDENTE=0 THEN 1 ELSE 0 END)) AS PENDENTE_ENVIO, (SELECT COUNT(*) FROM entrega) AS TOTAL, (SELECT COUNT(*) FROM RETORNO_FOTO C WHERE C.PENDENTE=0) AS FOTOS_ENVIADA, (SELECT COUNT(*) FROM RETORNO_FOTO D WHERE D.PENDENTE=1) AS FOTOS_PENDENTES, (SELECT COUNT(*) FROM RETORNO_FOTO E) AS FOTOS_TOTAL, SUM(CASE WHEN A.IDOCORRENCIA > 1 THEN 1 ELSE 0 END) AS OCORRENCIA FROM RETORNO_ENTREGA A');
  }

  Future<List<Map<String, dynamic>>> getEnderecoColetivoPendente(String codBarras) async {
    final db = await DatabaseApp.dataBase();
    return db.rawQuery('SELECT * FROM entrega WHERE pendente = 1 AND codBarras = "$codBarras" LIMIT 1');
  }

  Future<List<Map<String, dynamic>>> getEntregasColetivoPendente(String endereco, String numero) async {
    final db = await DatabaseApp.dataBase();
    return db.rawQuery('SELECT * FROM entrega WHERE pendente = 1 AND endereco LIKE "$endereco %"');
  }

  Future<List<Map<String, dynamic>>> getQtdEntregasPendente() async {
    final db = await DatabaseApp.dataBase();
    return db.rawQuery('SELECT COUNT(*) AS QTD FROM entrega WHERE pendente = 1');
  }

  Future<int> setFaturaEntregue(String codBarras) async {
    final db = await DatabaseApp.dataBase();
    return db.rawUpdate('UPDATE entrega SET pendente = 0 WHERE codBarras = ?', [codBarras]);
  }

  Future<void> insertRetornoEntrega(Map<String, dynamic> data) async {
    DatabaseApp.insert('retorno_entrega', data);
  }

  Future<List<Map<String, dynamic>>> getListaRetornoEntrega(String codBarras) async {
    final db = await DatabaseApp.dataBase();
    return db.query('retorno_entrega', where: 'codBarras = ?', whereArgs: [codBarras]);
  }
}
