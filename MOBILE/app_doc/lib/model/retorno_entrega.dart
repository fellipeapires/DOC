// ignore_for_file: unnecessary_this, prefer_collection_literals

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
  String matricula;
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
    this.matricula,
    this.assinatura,
    this.pendente,
    this.imei,
    this.grupoFaturamento,
    this.roteiro,
    this.predio,
    this.versaoApp,
    this.listaIdEntrega,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idImportacao'] = idImportacao;
    data['idEntrega'] = this.idEntrega;
    data['idUsuario'] = this.idUsuario;
    data['idOcorrencia'] = idOcorrencia;
    data['dataExecucao'] = this.dataExecucao;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['codigoBarrasQr'] = this.codBarras;
    data['codigo'] = this.codigo;
    data['observacao'] = this.observacao;
    data['assinatura'] = this.assinatura;
    data['pendente'] = this.pendente;
    data['imei'] = this.imei;
    data['instalacao'] = this.instalacao;
    data['matricula'] = this.matricula;
    data['roteiro'] = this.roteiro;
    data['grupoFaturamento'] = this.grupoFaturamento;
    data['predio'] = this.predio;
    data['versaoApp'] = this.versaoApp;
    data['listaIdEntrega'] = this.listaIdEntrega;
    return data;
  }
}
