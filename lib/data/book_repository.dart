import 'package:sqflite/sqflite.dart';
import 'package:test_db/data/db_helper.dart';

import '../models/book.dart';

class BookRepository {
  Future<List<Book>> getAllBooks() async {
    Database db = await DbHelper.initDb();
    List<Map<String, dynamic>> booksMaps = await db.rawQuery(
      '''
      SELECT *
      FROM $tableBooks
      JOIN $tableUsers ON userId = users.id
      ''',
    );
    return List.generate(booksMaps.length, (index) {
      return Book(
        id: booksMaps[index]['id'],
        title: booksMaps[index]['title'],
        pages: booksMaps[index]['pages'],
        userId: booksMaps[index]['userId'],
      )..userName = booksMaps[index]['userName'];
    });
  }

  Future<Book?> getBook(int id) async {
    Database db = await DbHelper.initDb();
    List<Map<String, dynamic>> book = await db.rawQuery(
      '''
      SELECT *
      FROM $tableBooks
      JOIN $tableUsers ON userId = users.id
      WHERE id=$id
      ''',
    );
    if (book.length == 1) {
      return Book(
        id: book[0]['id'],
        title: book[0]['title'],
        pages: book[0]['pages'],
        userId: book[0]['userId'],
      )..userName = book[0]['user'];
    } else {
      return null;
    }
  }

  Future<int> addBook(Book book) async {
    Database db = await DbHelper.initDb();
    int id = await db.insert(tableBooks, book.toMap());
    return id;
  }

  Future<void> updateBook(Book book) async {
    Database db = await DbHelper.initDb();
    db.rawUpdate(
      '''
        UPDATE $tableBooks
        SET
          title="${book.title}",
          pages=${book.pages},
          userId=${book.userId}
        WHERE id=${book.id}
        ''',
    );
  }

  Future<void> deleteBook(int id) async {
    Database db = await DbHelper.initDb();
    await db.rawDelete('DELETE FROM $tableBooks WHERE id=$id');
  }
}
