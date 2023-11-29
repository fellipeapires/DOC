// ignore_for_file: unnecessary_this, prefer_collection_literals

class Backup {
  int id;
  String nome;
  String tabela;
  String dataCriacao;

  Backup({
    this.id,
    this.nome,
    this.tabela,
    this.dataCriacao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['tabela'] = this.tabela;
    data['dataCriacao'] = this.dataCriacao;
    return data;
  }
}
