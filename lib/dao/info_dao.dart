import 'package:app_satisfacao/helpers/app_helper.dart';
import 'package:app_satisfacao/model/informacao_model.dart';
import 'package:app_satisfacao/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class InfoDao {
  AppHelper helper = AppHelper();

  TipoDao() {
    helper.db;
  }

  Future<InformacaoModel> saveInfo(InformacaoModel infoBean) async {
    Database dbApp = await helper.db;
    infoBean.id = await dbApp.insert(infoTableName, infoBean.toMap());
    return infoBean;
  }

  Future<List> getInfo() async {
    Database dbApp = await helper.db;
    List listMap = await dbApp.rawQuery("SELECT * FROM $infoTableName");
    List<InformacaoModel> list = List();
    for (Map m in listMap) {
      list.add(InformacaoModel.fromMap(m));
    }
    return list;
  }

  deleteAll() async {
    final db = await helper.db;
    db.rawDelete("delete from $infoTableName");
  }
}
