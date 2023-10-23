// ignore_for_file: unused_import, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/model/retorno_entrega.dart';
import 'package:app_doc/provider/api_url_provider.dart';
import 'package:app_doc/util/utility.dart';
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

  Future<http.Response> marcarEntregaAssociadaAPI(List<int> listaIdEntrega) async {
    String url = '$_apiUrl/distribuicao/atualizarassociadomobile';
    Map<String, String> headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    String strBody = jsonEncode(listaIdEntrega.toList()).toString();
    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: strBody,
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

  Future<List<Map<String, dynamic>>> getEntregasAssociadas(String queryIdEntrega) async {
    final db = await DatabaseApp.dataBase();
    return db.rawQuery('SELECT id FROM entrega WHERE id in(' + queryIdEntrega + ')');
  }

  Future<int> setFaturaEntregue(String codBarras) async {
    final db = await DatabaseApp.dataBase();
    return db.rawUpdate('UPDATE entrega SET pendente = 0 WHERE codBarras = ?', [codBarras]);
  }

  Future<http.Response> sincronizarRetorno(List<RetornoEntrega> listaRetorno) async {
    String url = '$_apiUrl/retornoentregas/incluirmobile';
    Map<String, String> headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    String strBody = jsonEncode(listaRetorno.map((e) => e.toJson()).toList()).toString();
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: strBody,
    );
  }

  Future<http.Response> sincronizarRetornoColetivo(List<RetornoEntrega> listaRetorno) async {
    String url = '$_apiUrl/retornoentregas/incluirmobilecoletivo';
    Map<String, String> headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    String strBody = jsonEncode(listaRetorno.map((e) => e.toJson()).toList()).toString();
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: strBody,
    );
  }

  Future<http.Response> alterarAssociadoMobileAPI(Object distribuicaoDto) async {
    String url = '$_apiUrl/distribuicao/atualizarassociadomobile';
    Map<String, String> headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    String strBody = jsonEncode(distribuicaoDto).toString();
    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: strBody,
    );
  }

  Future<void> insertRetornoEntrega(Map<String, dynamic> data) async {
    DatabaseApp.insert('retorno_entrega', data);
  }

  Future<List<Map<String, dynamic>>> getListaRetornoEntrega(String codBarras) async {
    final db = await DatabaseApp.dataBase();
    return db.query('retorno_entrega', where: 'codBarras = ?', whereArgs: [codBarras]);
  }

  Future<List<Map<String, dynamic>>> getListaRetornoEntregaPendenteSinc() async {
    final db = await DatabaseApp.dataBase();
    return db.query('retorno_entrega', where: 'pendente = 1 ');
  }

  Future<void> marcarRetornoEnviadoPorIdEntrega(int idEntrega) async {
    final db = await DatabaseApp.dataBase();
    return db.rawUpdate('UPDATE retorno_entrega SET pendente = 0 WHERE idEntrega = ?', [idEntrega]);
  }
}
