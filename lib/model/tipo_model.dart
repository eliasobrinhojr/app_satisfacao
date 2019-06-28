import 'package:app_satisfacao/utils/constants.dart';

class TipoModel {
  int id;
  String idTipo;
  String tipo;
  String descricao;

  TipoModel();

  TipoModel.fromMap(Map map) {
    id = map[idTipoColumn];
    idTipo = map[idTipoAvaliacaoColumn];
    tipo = map[tipoColumn];
    descricao = map[descricaoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idTipoAvaliacaoColumn: idTipo,
      tipoColumn: tipo,
      descricaoColumn: descricao
    };

    if (id != null) {
      map[idTipoColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Tipo(id: $id, id_tipoavaliacao: $idTipo ,tipo: $tipo, descricao: $descricao)";
  }
}
