class RiwayatTransaksiModel {
  int? transaksiId, detailTransaksiId, barangId, jumlah;
  double? totalHarga, totalBayar, hargaBarang;
  DateTime? tanggal;
  String? namaBarang;

  RiwayatTransaksiModel({
    required this.transaksiId,
    required this.detailTransaksiId,
    required this.barangId,
    required this.jumlah,
    required this.hargaBarang,
    required this.totalHarga,
    required this.totalBayar,
    required this.tanggal,
    required this.namaBarang,
  });
}