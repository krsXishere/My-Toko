import 'package:randomstring_dart/randomstring_dart.dart';
import 'db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;

class BarangTable {
  // static Future<void> createTables(sql.Database database) async {
  //   await database.execute("""create table barangs(
  //     id integer primary key autoincrement not null,
  //     kode_barang text,
  //     nama_barang text,
  //     harga_barang double,
  //     kategori_barang text,
  //     stok_barang int
  //   )""");
  // }

  // static Future onConfigure(sql.Database db) async {
  //   await db.execute('PRAGMA foreign_keys = ON');
  // }

  // static Future<sql.Database> database() async {
  //   return sql.openDatabase(
  //     "toko.db",
  //     version: 1,
  //     onCreate: (db, version) async {
  //       await createTables(db);
  //     },
  //     onConfigure: onConfigure,
  //   );
  // }

  static Future<int> create(
    String namaBarang,
    double hargaBarang,
    String kategoriBarang,
    int stokBarang,
  ) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    final rs = RandomString();
    String randomString = rs.getRandomString(
      uppersCount: 3,
      lowersCount: 0,
      numbersCount: 1,
      specialsCount: 0,
      canSpecialRepeat: false,
      specials: "",
    );
    String kodeBarang = "BRG-$randomString";
    final data = {
      'kode_barang': kodeBarang,
      'nama_barang': namaBarang,
      'harga_barang': hargaBarang,
      'kategori_barang': kategoriBarang,
      'stok_barang': stokBarang,
    };
    final id = await db.insert(
      'barangs',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> readAll() async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;

    return db.query('barangs', orderBy: 'nama_barang');
  }

  static Future<List<Map<String, dynamic>>> search(String search) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;

    return db.query(
      'barangs',
      where: "nama_barang like '%$search%' or kategori_barang like '%$search%'",
      // whereArgs: [search],
    );
  }

  static Future<int> update(
    int id,
    String namaBarang,
    double hargaBarang,
    String kategoriBarang,
    int stokBarang,
  ) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    final data = {
      'nama_barang': namaBarang,
      'harga_barang': hargaBarang,
      'kategori_barang': kategoriBarang,
      'stok_barang': stokBarang,
    };
    final result = await db.update(
      'barangs',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  static Future<int> updateStok(
    int id,
    int stokBarang,
  ) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    final data = {
      'stok_barang': stokBarang,
    };
    final result = await db.update(
      'barangs',
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
        'barangs',
        where: 'id IN (${List.filled(id.length, '?').join(',')})',
        whereArgs: id,
      );
    } catch (e) {
      // print(e);
    }
  }
}
