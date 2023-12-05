// ignore_for_file: prefer_collection_literals, unnecessary_this

class Entrega {
  int id;
  String codBarras;
  String codCliente;
  String sequencia;
  String roteiro;
  String endereco;
  String cep;
  String municipio;
  int grupoFaturamento;
  int idGrupoFaturamento;
  int idImportacao;
  String observacao;
  int pendente;

  Entrega({
    this.id,
    this.codBarras,
    this.codCliente,
    this.sequencia,
    this.roteiro,
    this.endereco,
    this.cep,
    this.municipio,
    this.grupoFaturamento,
    this.idGrupoFaturamento,
    this.idImportacao,
    this.observacao,
    this.pendente,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['codBarras'] = this.codBarras;
    data['codCliente'] = this.codCliente;
    data['sequencia'] = sequencia;
    data['roteiro'] = this.roteiro;
    data['endereco'] = this.endereco;
    data['cep'] = cep;
    data['municipio'] = this.municipio;
    data['grupoFaturamento'] = this.grupoFaturamento;
    data['idGrupoFaturamento'] = this.idGrupoFaturamento;
    data['idImportacao'] = this.idImportacao;
    data['observacao'] = this.observacao;
    data['pendente'] = this.pendente;
    return data;
  }

  Entrega toObject(Entrega entrega, Map<String, dynamic> data) {
    entrega.id = data['idEntrega'];
    entrega.codBarras = data['codBarras'];
    entrega.codCliente = data['codCliente'];
    entrega.sequencia = data['sequencia'];
    entrega.roteiro = data['roteiro'];
    entrega.endereco = data['endereco'];
    entrega.cep = data['cep'];
    entrega.municipio = data['municipio'];
    entrega.grupoFaturamento = data['grupoFaturamento'];
    entrega.idGrupoFaturamento = data['idGrupoFaturamento'];
    entrega.idImportacao = data['idImportacao'];
    entrega.observacao = data['observacao'];
    return entrega;
  }
}
