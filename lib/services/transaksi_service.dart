import 'package:intl/intl.dart';
import 'package:toko_umkm/databases/transaksi_table.dart';
import '../models/income_model.dart';
import '../models/riwayat_transaksi_model.dart';

class TransaksiService {
  Future<void> create(
    double totalHarga,
    double totalBayar,
  ) async {
    await TransaksiTable.create(
      totalHarga,
      totalBayar,
    );
  }

  Future<List<RiwayatTransaksiModel>> getAllTransaction() async {
    List<Map<String, dynamic>> transaksi =
        await TransaksiTable.readAllTransaction();
    final transaksis = transaksi.map((e) {
      return RiwayatTransaksiModel(
        transaksiId: e['transaksi_id'],
        detailTransaksiId: e['detailTransaksi_id'],
        barangId: e['barang_id'],
        jumlah: e['jumlah'],
        hargaBarang: e['harga_barang'],
        totalHarga: e['total_harga'],
        totalBayar: e['total_bayar'],
        tanggal: DateTime.parse(e['tanggal'].toString()),
        namaBarang: e['nama_barang'],
      );
    }).toList();

    return transaksis;
  }

  Future<List<IncomeModel>> getIncome(
    String startDate,
    String endDate,
  ) async {
    final result = await TransaksiTable.getTransactionsInRange(startDate, endDate);
    List<IncomeModel> transactions = result.map((row) {
      DateTime tanggal = DateTime.parse(row['tanggal']);
      String formattedTanggal = "${tanggal.day}-${tanggal.month}-${tanggal.year}";
      return IncomeModel(
        date: formattedTanggal,
        amount: row['total_harga'] ?? 0,
        label: "Rp${formatCurrency(row['total_harga'])}",
      );
    }).toList();
    return transactions;
  }

  String formatCurrency(var currency) {
    final initialData = NumberFormat("#,##0", "id");
    String currentData = initialData.format(currency);
    return currentData;
  }
}
