import 'package:toko_umkm/databases/db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;

class TransaksiTable {
  static Future<int> create(double totalHarga, double totalBayar) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    final dateTime = DateTime.now();
    String formattedDateTime = dateTime.toIso8601String();
    final data = {
      'tanggal': formattedDateTime,
      'total_harga': totalHarga,
      'total_bayar': totalBayar,
    };
    final id = await db.insert(
      "transaksis",
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> readAllTransaction() async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> data = await db.rawQuery(
        "select * from transaksis, detail_transaksi, barangs where (transaksis.id = detail_transaksi.transaksi_id and detail_transaksi.barang_id = barangs.id)");
    // print(data);
    return data;
  }

  static Future<List<Map<String, dynamic>>> getTransactionsInRange(
    String startDate,
    String endDate,
  ) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      select * from transaksis
      where tanggal between ? and ? order by tanggal''',
      [startDate, endDate],
    );

    return result;
  }
}
