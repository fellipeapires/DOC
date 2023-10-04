class RetornoEntrega {
  int id;
  int idImportacao;
  int idEntrega;
  int idUsuario;
  int idOcorrencia;
  String dataExecucao;
  String codBarras;
  String codigo;
  String latitude;
  String longitude;
  String observacao;
  String instalacao;
  String medidor;
  int assinatura;
  int pendente;
  String imei;
  int grupoFaturamento;
  String roteiro;
  int predio;
  String versaoApp;
  List<int> listaIdEntrega;

  RetornoEntrega({
    this.id,
    this.idImportacao,
    this.idEntrega,
    this.idUsuario,
    this.idOcorrencia,
    this.dataExecucao,
    this.codBarras,
    this.codigo,
    this.latitude,
    this.longitude,
    this.observacao,
    this.instalacao,
    this.medidor,
    this.assinatura,
    this.pendente,
    this.imei,
    this.grupoFaturamento,
    this.roteiro,
    this.predio,
    this.versaoApp,
    this.listaIdEntrega,
  });
}
