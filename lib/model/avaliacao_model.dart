class AvaliacaoModel {
  String perfil, comentario, dtavaliacao, tipoAvaliacao;

  //AvaliacaoModel({this.filial, this.tipoAvaliacao, this.perfil, this.comentario});
  AvaliacaoModel();

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["dtavaliacao"] = dtavaliacao;
    map["tipoAvaliacao"] = tipoAvaliacao;
    map["perfil"] = perfil;
    map["comentario"] = comentario;
    return map;
  }

  factory AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    AvaliacaoModel obj = AvaliacaoModel();
    obj.perfil = json['perfil'];
    obj.tipoAvaliacao = json['tipoAvaliacao'];
    obj.comentario = json['comentario'];
    obj.dtavaliacao = json['dtavaliacao'];
    return obj;
  }

  @override
  String toString() {
    return "Avaliacao(perfil = $perfil, tipo=$tipoAvaliacao, dtavaliacao=$dtavaliacao)";
  }
}
