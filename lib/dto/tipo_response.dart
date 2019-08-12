class TipoResponse {
  int idtipoavaliacao;
  String tipo;
  String descricao;

  TipoResponse();

  @override
  String toString() {
    return "Tipo(id: $idtipoavaliacao, tipo: $tipo, descricao: $descricao)";
  }
}
