// ignore_for_file: unused_import

import 'package:app_doc/database/database_app.dart';
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

  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('retorno_foto', data);
  }
}
