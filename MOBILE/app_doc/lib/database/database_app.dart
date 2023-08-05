// ignore_for_file: unused_import, missing_return, unused_local_variable, unnecessary_this

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseApp {
  static Future<sql.Database> dataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'svi.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE IF NOT EXISTS usuario (id integer PRIMARY KEY NOT NULL, nome TEXT, login TEXT, senha TEXT, matricula integer, situacao integer, idRegional integer)');
        db.execute('CREATE TABLE IF NOT EXISTS ocorrencia (id integer PRIMARY KEY NOT NULL, codigo integer, nome TEXT, flagOcorrencia integer, situacao integer)');
        db.execute('CREATE TABLE IF NOT EXISTS retornofoto (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, idOs integer, instalacao integer, idUsuario integer, nome TEXT, dataFoto datetime, imei TEXT, ass_biometria integer, tipo integer, enviado integer, image TEXT, marca TEXT, modelo TEXT)');
        db.execute('CREATE TABLE IF NOT EXISTS os (id integer PRIMARY KEY NOT NULL, idContrato integer, idGrupoFaturamento integer, codigoGrupoFaturamento integer, idLocalidade integer, codigoLocalidade integer, contrato integer, roteiro TEXT, municipio string, unidadeRegional TEXT, tipoServico TEXT, instalacao integer, pn TEXT, classe TEXT, livro integer, nome TEXT, rg TEXT, cpfCnpj TEXT, telefone TEXT, endereco TEXT, bairro TEXT, cep TEXT, medidor TEXT, codigo TEXT, descricao TEXT, lido integer)');
        db.execute('CREATE TABLE IF NOT EXISTS retorno (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, idOcorrencia integer, idUsuario integer, idOs integer, idGrupoFaturamento integer, idLocalidade integer, localInversao TEXT, medidorUm TEXT, medidorDois TEXT, medidorTres TEXT, medidorQuatro TEXT, medidorCinco TEXT, medidorSeis TEXT, leituraMedidorUm integer, leituraMedidorDois integer, leituraMedidorTres integer, leituraMedidorQuatro integer, leituraMedidorCinco integer, leituraMedidorSeis integer, resultadoADR TEXT, bairro TEXT, celular TEXT, cep TEXT, latitude TEXT, longitude TEXT, corImovel TEXT, cpf_cnpj TEXT, dataEnvio datetime, dataVisita datetime, dataNascimento datetime, empresaResp TEXT, endereco TEXT, estadoCivil TEXT, dataDeslocamento datetime, dataFinalizacao datetime, dataInicio datetime, imovelEncontrado TEXT, imovelHabitado TEXT, instalacao integer, medidorEncontrado TEXT, mesmoTitular TEXT, municipio TEXT, medidorDireita TEXT, medidorEsquerda TEXT, naturalidade TEXT, nome TEXT, instalacaoFatura integer, medidor TEXT, observacao TEXT, possuiFatura TEXT, responsavel TEXT, rg TEXT, situacaoLocal TEXT, telefone TEXT, vizinhoDireita TEXT, vizinhoEsquerda TEXT, classe TEXT, codigo TEXT, descricao TEXT, livro integer, pn TEXT, tipoServico TEXT, unidadeRegional TEXT, executado integer, inspecionado integer, enviado integer, versaoApp TEXT, leitura03 integer, leitura04 integer, leitura06 integer, leitura08 integer)');
        return  db.execute('CREATE TABLE IF NOT EXISTS configuracao (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, localidade_lote_filter TEXT, status_os_filter TEXT, contrato_filter TEXT)');
      },
      version: 4,
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
