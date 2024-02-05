import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableUsers = 'users';
const String tableBooks = 'books';

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

    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: (db, oldVersion, newVersion) {},
      onDowngrade: (db, oldVersion, newVersion) {},
    );
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.transaction((trans) async {
      var batch = trans.batch();
      await trans.execute(
        '''
        CREATE TABLE $tableUsers (
          id INTEGER PRIMARY KEY,
          userName TEXT,
          age INTEGER
        )
        ''',
      );
      await trans.execute(
        '''
        CREATE TABLE $tableBooks (
          id INTEGER PRIMARY KEY,
          title TEXT,
          pages INTEGER,
          userId INTEGER,
          FOREIGN KEY (userId) REFERENCES $tableUsers(id) ON DELETE CASCADE
        )
        ''',
      );
      await batch.commit();
    });
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
}
