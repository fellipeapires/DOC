// ignore_for_file: unused_import

import 'dart:convert';

import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/model/retorno_foto.dart';
import 'package:app_doc/provider/api_url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class FotoProvider {
  final _apiUrl = ApiUrlProvider.getApiUrl();

  Future getCargaAPI(int idUsuario) {
    return http.get(
      Uri.parse('$_apiUrl/retornofoto/upload-img'),
    );
  }

  Future<http.Response> sincronizarFoto(List<RetornoFoto> listaRetorno) async {
    String url = '$_apiUrl/retornofoto/upload-img';
    Map<String, String> headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    String strBody = jsonEncode(listaRetorno.map((e) => e.toJson()).toList()).toString();
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: strBody,
    );
  }

  Future<List<Map<String, dynamic>>> getFotoAll() async {
    return DatabaseApp.getData('retorno_foto');
  }

  Future<List<Map<String, dynamic>>> getListaFotoPendenteSinc() async {
    final db = await DatabaseApp.dataBase();
    return db.query('retorno_foto', where: 'pendente = 1 ');
  }

  Future<void> marcarFotoEnviadoPorCodBarras(String codBarras) async {
    final db = await DatabaseApp.dataBase();
    return db.rawUpdate('UPDATE retorno_foto SET pendente = 0 WHERE codBarras = ?', [codBarras]);
  }

  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('retorno_foto', data);
  }

  Future<void> apagarDados() async {
    final db = await DatabaseApp.dataBase();
    return db.rawDelete('DELETE FROM retorno_foto WHERE pendente = 0');
  }
}
