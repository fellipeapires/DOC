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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['idImportacao'] = idImportacao;
    data['idEntrega'] = this.idEntrega;
    data['idUsuario'] = this.idUsuario;
    data['idOcorrencia'] = idOcorrencia;
    data['dataExecucao'] = this.dataExecucao;
    data['codBarras'] = this.codBarras;
    data['codigo'] = this.codigo;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['observacao'] = this.observacao;
    data['instalacao'] = this.instalacao;
    data['medidor'] = this.medidor;
    data['matricula'] = this.matricula;
    data['assinatura'] = this.assinatura;
    data['pendente'] = this.pendente;
    data['imei'] = this.imei;
    data['grupoFaturamento'] = this.grupoFaturamento;
    data['roteiro'] = this.roteiro;
    data['predio'] = this.predio;
    data['versaoApp'] = this.versaoApp;
    data['listaIdEntrega'] = this.listaIdEntrega;
    return data;
  }

  RetornoEntrega toObject(RetornoEntrega retornoEntrega, Map<String, dynamic> data) {
    retornoEntrega.id = data['id'];
    retornoEntrega.idImportacao = data['idImportacao'];
    retornoEntrega.idEntrega = data['idEntrega'];
    retornoEntrega.idUsuario = data['idUsuario'];
    retornoEntrega.idOcorrencia = data['idOcorrencia'];
    retornoEntrega.dataExecucao = data['dataExecucao'];
    retornoEntrega.codBarras = data['codBarras'];
    retornoEntrega.codigo = data['codigo'];
    retornoEntrega.longitude = data['longitude'];
    retornoEntrega.latitude = data['latitude'];
    retornoEntrega.observacao = data['observacao'];
    retornoEntrega.observacao = data['instalacao'];
    retornoEntrega.medidor = data['medidor'];
    retornoEntrega.matricula = data['matricula'];
    retornoEntrega.assinatura = data['assinatura'];
    retornoEntrega.pendente = data['pendente'];
    retornoEntrega.imei = data['imei'];
    retornoEntrega.grupoFaturamento = data['grupoFaturamento'];
    retornoEntrega.roteiro = data['roteiro'];
    retornoEntrega.predio = data['predio'];
    retornoEntrega.versaoApp = data['versaoApp'];
    retornoEntrega.listaIdEntrega = data['listaIdEntrega'];
    return retornoEntrega;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idImportacao'] = idImportacao;
    data['idEntrega'] = this.idEntrega;
    data['idUsuario'] = this.idUsuario;
    data['idOcorrencia'] = idOcorrencia;
    data['dataExecucao'] = this.dataExecucao;
    data['codigoBarrasQr'] = this.codBarras;
    data['codigo'] = this.codigo;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['observacao'] = this.observacao;
    data['instalacao'] = this.instalacao;
    data['matricula'] = this.matricula;
    data['assinatura'] = this.assinatura;
    data['pendente'] = this.pendente;
    data['imei'] = this.imei;
    data['grupoFaturamento'] = this.grupoFaturamento;
    data['roteiro'] = this.roteiro;
    data['predio'] = this.predio;
    data['versaoApp'] = this.versaoApp;
    data['listaIdEntrega'] = this.listaIdEntrega;
    return data;
  }
}
