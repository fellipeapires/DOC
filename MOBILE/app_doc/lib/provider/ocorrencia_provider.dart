// ignore_for_file: unused_import

import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/provider/api_url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class OcorrenciaProvider {
  final _apiUrl = ApiUrlProvider.getApiUrl();

  Future getOcorrenciaApi() {
    return http.get(
      Uri.parse('$_apiUrl/ocorrencia/pesquisar?ativo=2'),
    );
  }

  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('ocorrencia', data);
  }

  Future<void> deleteAll(String table) async {
    DatabaseApp.deleteAll(table);
  }

  Future<List<Map<String, dynamic>>> getOcorrenciaAll() async {
    return DatabaseApp.getData('ocorrencia');
  }

  Future<List<Map<String, dynamic>>> getOcorrenciaPorNome(String nome) async {
    final db = await DatabaseApp.dataBase();
    return db.query('ocorrencia', where: 'nome = ?', whereArgs: [nome]);
  }
}
