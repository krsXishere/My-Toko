import 'package:flutter/material.dart';
import 'package:toko_umkm/models/barang_model.dart';
// import 'package:toko_umkm/pages/kasir_page.dart';
import 'package:toko_umkm/services/barang_service.dart';
import 'package:toko_umkm/services/detail_transaksi_service.dart';

import '../services/transaksi_service.dart';
// import 'package:toko_umkm/services/transaksi_service.dart';

class BarangProvider with ChangeNotifier {
  final _barangService = BarangService();
  final _transaksiService = TransaksiService();
  final _detailTransaksiService = DetailTransaksiService();
  List<BarangModel> _barangs = [];
  List<BarangModel> get barangs => _barangs;
  List<BarangModel> _carts = [];
  List<BarangModel> get carts => _carts;
  bool isLoading = false;
  double _totalHarga = 0;
  double get totalHarga => _totalHarga;
  double _kembalian = 0;
  double get kembalian => _kembalian;

  void checkLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getAllBarang() async {
    checkLoading(true);
    final data = await _barangService.getAllBarang();
    _barangs = data;
    checkLoading(false);
  }

  Future<void> createBarang(
    String namaBarang,
    double hargaBarang,
    String kategoriBarang,
    int stokBarang,
  ) async {
    checkLoading(true);
    await _barangService.createBarang(
      namaBarang,
      hargaBarang,
      kategoriBarang,
      stokBarang,
    );
    checkLoading(false);
  }

  Future<void> editBarang(
    int id,
    String namaBarang,
    double hargaBarang,
    String kategoriBarang,
    int stokBarang,
  ) async {
    checkLoading(true);
    await _barangService.editBarang(
      id,
      namaBarang,
      hargaBarang,
      kategoriBarang,
      stokBarang,
    );
    checkLoading(false);
  }

  Future<void> deleteBarang(List id) async {
    checkLoading(true);
    await _barangService.deleteBarang(id);
    checkLoading(false);
  }

  Future<void> searchBarang(String search) async {
    checkLoading(true);
    final data = await _barangService.searchBarang(search);
    _barangs = data;
    checkLoading(false);
  }

  void setCart(List<BarangModel> barangs) {
    checkLoading(true);
    final data = barangs;
    _carts = barangs;
    _totalHarga = _hitungTotalHarga(data);
    // print("Carts: $_carts");
    checkLoading(false);
  }

  double _hitungTotalHarga(List<BarangModel> listItems) {
    double calculatedTotalHarga = 0;
    for (var item in listItems) {
      calculatedTotalHarga +=
          item.hargaBarang * double.parse(item.jumlah.toString());
    }

    notifyListeners();
    return calculatedTotalHarga;
  }

  void updateJumlah(BarangModel barang, int newJumlah) {
    var tempCarts = List<BarangModel>.from(_carts);
    // List<BarangModel> tempCarts = _carts;
    int index = tempCarts.indexWhere((element) => element.id == barang.id);
    // print("Index: $index");
    if (index != -1) {
      tempCarts[index].jumlah = newJumlah;
      _carts[index] = tempCarts[index];
      _totalHarga = _hitungTotalHarga(_carts);
      // print("Carts: $_carts");
      // print("Jumlah: ${_carts[index].jumlah}");
      notifyListeners();
    }
  }

  void clearTotalHarga(double voidTotalHarga) {
    _totalHarga = voidTotalHarga;
    notifyListeners();
  }

  Future<void> transaksi(double totalBayar) async {
    await _transaksiService.create(
      _totalHarga,
      totalBayar,
    );
    detailTransaksi();
  }

  Future<void> detailTransaksi() async {
    for (var item in _carts) {
      // print("Item: ${item.jumlah}\nID: ${item.id!}");
      await _detailTransaksiService.create(
        item.jumlah,
        item.id!,
      );
      _barangService.editStokBarang(
        item.id!,
        item.stokBarang! - item.jumlah,
      );
    }
  }

  Future<void> setkembalian(double totalBayar) async {
    checkLoading(true);
    if(totalBayar >= _totalHarga) {
      _kembalian = totalBayar - _totalHarga;
    }
    checkLoading(false);
  }

  void clearKembalian() {
    _kembalian = 0;
    notifyListeners();
  }
}
