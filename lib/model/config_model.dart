import 'package:app_satisfacao/utils/constants.dart';

class ConfigModel {
  int id;
  String ip;
  String itemAvaliado;

  ConfigModel();

  ConfigModel.fromMap(Map map) {
    id = map[idColumn];
    ip = map[ipColumn];
    itemAvaliado = map[itemAvaliadoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {ipColumn: ip, itemAvaliadoColumn: itemAvaliado};

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Config(id: $id, ip: $ip, item: $itemAvaliado)";
  }
}
