import 'package:flutter/foundation.dart';
import 'package:toko_umkm/models/income_model.dart';
import 'package:toko_umkm/models/riwayat_transaksi_model.dart';
import '../services/transaksi_service.dart';

class TransaksiProvider with ChangeNotifier {
  final transaksiService = TransaksiService();
  List<RiwayatTransaksiModel> _transaksis = [];
  List<RiwayatTransaksiModel> get transaksis => _transaksis;
  bool isLoading = false;
  List<IncomeModel> _incomes = [];
  List<IncomeModel> get income => _incomes;

  void checkLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> createTransaksi(
    double totalHarga,
    double totalBayar,
  ) async {
    checkLoading(true);
    await transaksiService.create(totalHarga, totalBayar);
    checkLoading(false);
  }

  Future<void> getAllTransaction() async {
    checkLoading(true);
    _transaksis = await transaksiService.getAllTransaction();
    checkLoading(false);
  }

  Future<void> fetchData(String startDate, String endDate) async {
    _incomes = await transaksiService.getIncome(
      startDate,
      endDate,
    );
    notifyListeners();
  }
}
