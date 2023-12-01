// ignore_for_file: prefer_collection_literals, unnecessary_this

class Ocorrencia {
  int id;
  String nome;
  int codigo;
  int tipo;
  int situacao;
  int situacaoFoto;
  int qtdMinimaFoto;
  String dataAtualizacao;

  Ocorrencia({
    this.id,
    this.nome,
    this.codigo,
    this.tipo,
    this.situacao,
    this.situacaoFoto,
    this.qtdMinimaFoto,
    this.dataAtualizacao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['codigo'] = this.codigo;
    data['tipo'] = this.tipo;
    data['situacao'] = this.situacao;
    data['situacaoFoto'] = this.situacaoFoto;
    data['qtdMinimaFoto'] = this.qtdMinimaFoto;
    data['dataAtualizacao'] = this.dataAtualizacao;
    return data;
  }
}
