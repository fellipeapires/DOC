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
}
