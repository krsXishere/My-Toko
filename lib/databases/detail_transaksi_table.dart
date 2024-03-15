import 'package:toko_umkm/databases/db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;

class DetailTransaksiTable {
  static Future<int> create(
    int jumlah,
    int barangId,
  ) async {
    var dbHelper = DBHelper();
    final db = await dbHelper.database;
    List<Map<String, dynamic>> testTID =
        await db.rawQuery("select max(id) as count from transaksis limit 1");
    // print("Transaksi id: ${testTID[0]['count']}");
    int transaksiId = int.parse(testTID[0]['count'].toString());
    if (testTID[0]['count'] != null) {
      final data = {
        'jumlah': jumlah,
        'transaksi_id': transaksiId,
        'barang_id': barangId,
      };
      final id = await db.insert(
        "detail_transaksi",
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );

      return id;
    } else {
      final data = {
        'jumlah': jumlah,
        'transaksi_id': 1,
        'barang_id': barangId,
      };
      final id = await db.insert(
        "detail_transaksi",
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );

      return id;
    }
  }
}
