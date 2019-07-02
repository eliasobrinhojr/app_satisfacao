import 'package:app_satisfacao/utils/constants.dart';

class InformacaoModel {
  int id;
  String filial, endereco, numero, bairro;

  InformacaoModel();

  Map toMap() {
    Map<String, dynamic> map = {
      idInfoColumn: id,
      filialColumn: filial,
      enderecoColumn: endereco,
      numeroColumn: numero,
      bairroColumn: bairro
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  InformacaoModel.fromMap(Map map) {
    id = map[idInfoColumn];
    filial = map[filialColumn];
    endereco = map[enderecoColumn];
    numero = map[numeroColumn];
    bairro = map[bairroColumn];
  }

  @override
  String toString() {
    return 'InformacaoModel{filial: $filial, endereco: $endereco, numero: $numero, bairro: $bairro}';
  }
}
