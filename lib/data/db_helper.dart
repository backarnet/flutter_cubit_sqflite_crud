import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableUsers = 'users';

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  factory DbHelper() => _instance;
  static Database? _db;

  DbHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'flutter_cubit_sqflite_crud.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY,
        userName TEXT,
        age INTEGER
      )
      ''',
    );
  }
}
