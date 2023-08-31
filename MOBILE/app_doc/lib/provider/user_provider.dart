// ignore_for_file: unused_import

import 'package:app_doc/database/database_app.dart';
import 'package:app_doc/provider/api_url_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class UserProvider {
  final _apiUrl = ApiUrlProvider.getApiUrl();

  Future getUser() {
    return http.get(
      Uri.parse('$_apiUrl/usuarios/listausuariosmobile'),
    );
  }

  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('usuario', data);
  }

  Future<void> deleteAll(String table) async {
    DatabaseApp.deleteAll(table);
  }

  Future<List<Map<String, dynamic>>> getUsuarioAll() async {
    return DatabaseApp.getData('usuario');
  }

  Future<List<Map<String, dynamic>>> getUsuario(String login, String senha) async {
    final db = await DatabaseApp.dataBase();
    return db.query('usuario', where: 'login = ? AND senha = ?', whereArgs: [login, senha]);
  }
}
