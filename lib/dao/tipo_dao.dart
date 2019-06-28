import 'package:app_satisfacao/model/tipo_model.dart';
import 'package:app_satisfacao/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_satisfacao/helpers/app_helper.dart';

class TipoDao {
  AppHelper helper = AppHelper();

  TipoDao() {
    helper.db;
  }

  Future<TipoModel> saveTipo(TipoModel tipoBean) async {
    Database dbApp = await helper.db;
    tipoBean.id = await dbApp.insert(tipoTableName, tipoBean.toMap());
    return tipoBean;
  }

  Future<List> buscaTipo() async {
    Database dbApp = await helper.db;
    List listMap = await dbApp.rawQuery("SELECT * FROM $tipoTableName");
    List<TipoModel> list = List();
    for (Map m in listMap) {
      list.add(TipoModel.fromMap(m));
    }
    return list;
  }

  deleteAll() async {
    final db = await helper.db;
    db.rawDelete("delete from $tipoTableName");
  }
}
