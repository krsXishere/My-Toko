import 'package:toko_umkm/databases/detail_transaksi_table.dart';

class DetailTransaksiService {
  Future<void> create(
    int jumlah,
    int barangId,
  ) async {
    await DetailTransaksiTable.create(
      jumlah,
      barangId,
    );
  }
}
