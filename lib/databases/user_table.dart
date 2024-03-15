import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
import 'db_helper.dart';

class UserTable {
  static Future<int> create(String email, String password) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    final data = {
      'email': email,
      'password': password,
    };
    final id = await db.insert(
      'users',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> readAll() async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;

    return db.query('users', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> search(String search) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;

    return db.query(
      'users',
      where: "id = ? or email like '%$search%'",
      whereArgs: [search],
    );
  }

  static Future<int> update(int id, String email, String password) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    final data = {
      'email': email,
      'password': password,
    };
    final result = await db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  static Future<void> delete(List id) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;

    try {
      await db.delete(
        'users',
        where: 'id IN (${List.filled(id.length, '?').join(',')})',
        whereArgs: id,
      );
    } catch (e) {
      Exception(e);
    }
  }
}
