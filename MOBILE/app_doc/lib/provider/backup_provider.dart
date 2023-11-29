import 'package:app_doc/database/database_app.dart';

class BackupProvider {
  Future<void> insert(Map<String, dynamic> data) async {
    DatabaseApp.insert('backup', data);
  }

  Future<List<Map<String, dynamic>>> getBackupLast(String tabela) async {
    final db = await DatabaseApp.dataBase();
    return db.query('backup', where: "date(dataCriacao) = date('now') AND tabela = ?", whereArgs: [tabela]);
  }

  Future<void> apagarDadosBackup() async {
    final db = await DatabaseApp.dataBase();
    return db.rawDelete("DELETE FROM backup WHERE dataCriacao < date('now')");
  }
}
