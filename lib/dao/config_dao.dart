import 'package:app_satisfacao/helpers/app_helper.dart';
import 'package:app_satisfacao/model/config_model.dart';
import 'package:app_satisfacao/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class ConfigDao {
  AppHelper helper = AppHelper();

  Future<ConfigModel> saveConfig(ConfigModel config) async {
    Database dbApp = await helper.db;
    config.id = await dbApp.insert(configTableName, config.toMap());

    return config;
  }

  Future<ConfigModel> getConfig() async {
    Database dbApp = await helper.db;
    List<Map> maps = await dbApp.query(configTableName,
        columns: [idColumn, ipColumn, itemAvaliadoColumn]);

    if (maps.length > 0) {
      return ConfigModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  deleteAll() async {
    final db = await helper.db;
    db.rawDelete("delete from $configTableName");
  }
}
