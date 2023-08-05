import 'package:app_doc/database/database_app.dart';

class ConfiguracaoProvider {
  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('configuracao', data);
  }

  Future<List<Map<String, dynamic>>> getConfiguracaoAll() async {
    return DatabaseApp.getData('configuracao');
  }
}
