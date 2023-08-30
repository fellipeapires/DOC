// ignore_for_file: unused_import, missing_return, unused_local_variable, unnecessary_this

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseApp {
  static Future<sql.Database> dataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'doc.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE IF NOT EXISTS usuario(id integer primary key NOT NULL, idRegional integer, regional TEXT, login TEXT, senha TEXT, matricula TEXT, nome TEXT, situacao integer)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS entrega(id integer primary key NOT NULL, dataEmissao DATE, dataVencimento DATE, dataVerificacaoDeslig DATE, instalacao integer, latitude TEXT, longitude TEXT, medidor TEXT, plano TEXT, codigo TEXT, idRegistro TEXT, roteiro TEXT, sequencia TEXT, ul TEXT, endereco TEXT, numero integer, complemento TEXT, cep TEXT, notaFiscal TEXT, codigoCliente TEXT, cliente TEXT, municipio TEXT, grupoFaturamento integer, idGrupoFaturamento integer, referencia TEXT, dataApresentacao DATE, idImportacao integer, idRegional integer, observacao TEXT, pendente integer)');
        db.execute(
            'CREATE TABLE IF NOT EXISTS retorno_entrega(id integer primary key AUTOINCREMENT NOT NULL, idEntrega integer, idImportacao integer, grupoFaturamento integer, roteiro TEXT, id_usuario integer, id_ocorrencia integer, dataExecucao DATE, observacao TEXT, medidor TEXT, instalacao TEXT, cod_barrasQr TEXT, codigo TEXT, latitude TEXT, longitude TEXT, altitude TEXT, assinatura integer, pendente integer, predio integer, versaoApp TEXT)');
        db.execute('CREATE TABLE IF NOT EXISTS ocorrencia(id integer primary key NOT NULL, codigo integer, nome TEXT, situacao integer, tipo integer, situacaofoto integer, qtminimafoto integer, dataAtualizacao)');
        db.execute('CREATE TABLE IF NOT EXISTS retorno_foto(id integer primary key AUTOINCREMENT NOT NULL, id_usuario integer, nome TEXT, dataExecucao DATE, cod_barrasQr TEXT, instalacao TEXT, imagem TEXT, pendente integer, assinatura integer)');
        db.execute('CREATE INDEX IF NOT EXISTS index_entrega ON entrega (codigo, roteiro, cep, idGrupoFaturamento, grupoFaturamento, pendente)');
        return db.execute('CREATE INDEX IF NOT EXISTS index_retorno_entrega ON retorno_entrega (roteiro, cod_barrasQr, grupoFaturamento, pendente)');
      },
      version: 1,
    );
  }

  void onCreate(String dbPath, String db) {}

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DatabaseApp.dataBase();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DatabaseApp.dataBase();
    return db.query(table);
  }
}
