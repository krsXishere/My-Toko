import 'package:toko_umkm/databases/barang_table.dart';
import 'package:toko_umkm/models/barang_model.dart';

class BarangService {
  Future<List<BarangModel>> getAllBarang() async {
    List<Map<String, dynamic>> barang = await BarangTable.readAll();
    final barangs = barang.map((e) {
      return BarangModel(
        id: e['id'],
        kodeBarang: e['kode_barang'],
        namaBarang: e['nama_barang'],
        hargaBarang: e['harga_barang'],
        kategoriBarang: e['kategori_barang'],
        stokBarang: e['stok_barang'],
      );
    }).toList();

    return barangs;
  }

  Future<void> createBarang(
    String namaBarang,
    double hargaBarang,
    String kategoriBarang,
    int stokBarang,
  ) async {
    await BarangTable.create(
      namaBarang,
      hargaBarang,
      kategoriBarang,
      stokBarang,
    );
  }

  Future<void> editBarang(
    int id,
    String namaBarang,
    double hargaBarang,
    String kategoriBarang,
    int stokBarang,
  ) async {
    await BarangTable.update(
      id,
      namaBarang,
      hargaBarang,
      kategoriBarang,
      stokBarang,
    );
  }

   Future<void> editStokBarang(
    int id,
    int stokBarang,
  ) async {
    await BarangTable.updateStok(
      id,
      stokBarang,
    );
  }

  Future<void> deleteBarang(List id) async {
    await BarangTable.delete(id);
  }

  Future<List<BarangModel>> searchBarang(String search) async {
    List<Map<String, dynamic>> barang = await BarangTable.search(search);
    final barangs = barang.map((e) {
      return BarangModel(
        id: e['id'],
        kodeBarang: e['kode_barang'],
        namaBarang: e['nama_barang'],
        hargaBarang: e['harga_barang'],
        kategoriBarang: e['kategori_barang'],
        stokBarang: e['stok_barang'],
      );
    }).toList();

    return barangs;
  }
}
