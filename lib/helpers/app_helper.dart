import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_satisfacao/utils/constants.dart';

class AppHelper {
  static final AppHelper _instance = AppHelper.internal();

  factory AppHelper() => _instance;

  AppHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }
}

Future<Database> initDb() async {
  final dataBasesPath = await getDatabasesPath();
  final path = join(dataBasesPath, "db");

  return await openDatabase(path, version: 1,
      onCreate: (Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $configTableName($idColumn INTEGER PRIMARY KEY, $ipColumn TEXT, $itemAvaliadoColumn TEXT);");
    await db.execute(
        "CREATE TABLE $tipoTableName($idTipoColumn INTEGER PRIMARY KEY, $idTipoAvaliacaoColumn TEXT, $tipoColumn TEXT, $descricaoColumn TEXT);");
    await db.execute(
        "CREATE TABLE $infoTableName($idInfoColumn INTEGER PRIMARY KEY, $filialColumn TEXT, $enderecoColumn TEXT, $numeroColumn TEXT, $bairroColumn TEXT);");
  });
}
