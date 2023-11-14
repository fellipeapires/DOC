// ignore_for_file: unnecessary_this, prefer_collection_literals

class RetornoFoto {
  int id;
  int idUsuario;
  String nome;
  String dataExecucao;
  String codBarras;
  String instalacao;
  String imagem;
  String imei;
  int pendente;
  int assinatura;

  RetornoFoto({
    this.id,
    this.idUsuario,
    this.nome,
    this.dataExecucao,
    this.codBarras,
    this.instalacao,
    this.imagem,
    this.imei,
    this.pendente,
    this.assinatura,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idUsuario'] = this.idUsuario;
    data['codigoBarrasQr'] = this.codBarras;
    data['imagem'] = this.imagem;
    data['imei'] = this.imei;
    data['nomeArquivo'] = this.nome;
    data['instalacao'] = this.instalacao;
    data['assinatura'] = this.assinatura;
    data['dataExecucao'] = this.dataExecucao;
    return data;
  }
}
