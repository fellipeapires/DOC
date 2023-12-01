// ignore_for_file: unnecessary_this, prefer_collection_literals

class User {
  int id;
  int idRegional;
  String regional;
  String nome;
  String login;
  String senha;
  String matricula;
  int situacao;

  User({
    this.id,
    this.idRegional,
    this.regional,
    this.nome,
    this.login,
    this.senha,
    this.matricula,
    this.situacao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['idRegional'] = this.idRegional;
    data['regional'] = this.regional;
    data['nome'] = this.nome;
    data['login'] = this.login;
    data['senha'] = this.senha;
    data['matricula'] = this.matricula;
    data['situacao'] = this.situacao;
    return data;
  }
}
