import 'package:sqflite/sqflite.dart';
import 'package:test_db/data/db_helper.dart';

import '../models/user.dart';

class UserRepository {
  Future<int> insertUser(User user) async {
    Database db = await DbHelper.initDb();
    int id = await db.insert(tableUsers, user.toMap());
    return id;
  }

  Future<List<User>> getAllUsers() async {
    Database db = await DbHelper.initDb();
    List<Map<String, dynamic>> usersMaps = await db.query(tableUsers);
    return List.generate(usersMaps.length, (index) {
      return User(
          id: usersMaps[index]['id'],
          userName: usersMaps[index]['userName'],
          age: usersMaps[index]['age']);
    });
  }

  Future<User?> getUser(int id) async {
    Database db = await DbHelper.initDb();
    List<Map<String, dynamic>> user = await db.rawQuery(
      '''
      SELECT *
      FROM $tableUsers
      WHERE id=$id
      ''',
    );
    if (user.length == 1) {
      return User(
          id: user[0]['id'],
          userName: user[0]['userName'],
          age: user[0]['age']);
    } else {
      return null;
    }
  }

  Future<int> addUser(User user) async {
    Database db = await DbHelper.initDb();
    int id = await db.rawInsert(
      '''
      INSERT INTO $tableUsers
      (userName, age)
      VALUES
      ("${user.userName}", ${user.age})
      ''',
    );
    return id;
  }

  Future<void> updateUser(User user) async {
    Database db = await DbHelper.initDb();
    db.rawUpdate(
      '''
        UPDATE $tableUsers
        SET
          userName="${user.userName}",
          age=${user.age}
        WHERE id=${user.id}
        ''',
    );
  }

  Future<void> deleteUser(int id) async {
    Database db = await DbHelper.initDb();
    await db.rawDelete('DELETE FROM $tableUsers WHERE id=$id');
  }
}
