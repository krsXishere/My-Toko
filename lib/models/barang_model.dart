class BarangModel{
  int? id, stokBarang;
  String? kodeBarang, namaBarang, kategoriBarang;
  double hargaBarang;
  bool isSelected;
  int jumlah;

  BarangModel({
    required this.id,
    required this.kodeBarang,
    required this.namaBarang,
    required this.hargaBarang,
    required this.kategoriBarang,
    required this.stokBarang,
    this.isSelected = false,
    this.jumlah = 0,
  });
}