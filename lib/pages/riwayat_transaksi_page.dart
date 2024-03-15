import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_umkm/providers/transaksi_provider.dart';
import '../common/theme.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();

  String formatCurrency(var currency) {
    final initialData = NumberFormat("#,##0", "id");
    String currentData = initialData.format(currency);
    return currentData;
  }

  void refreshData() {
    Provider.of<TransaksiProvider>(
      context,
      listen: false,
    ).getAllTransaction();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        refreshData();
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: isSearch
            ? TextFormField(
                style: primaryTextStyle,
                cursorColor: primaryPurple,
                cursorHeight: 20,
                cursorWidth: 3,
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (value) {},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  filled: true,
                  fillColor: white,
                  border: InputBorder.none,
                  hintText: "Cari",
                  hintStyle: primaryTextStyle.copyWith(
                    color: unClickColor,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            : Text(
                "Riwayat Transaksi",
                style: primaryTextStyle.copyWith(
                  color: white,
                  fontWeight: bold,
                ),
              ),
        elevation: 0,
      ),
      body: Consumer<TransaksiProvider>(
        builder: (context, value, child) {
          final transaksis = value.transaksis;

          return value.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryPurple,
                  ),
                )
              : Scrollbar(
                  controller: scrollController,
                  thickness: 10,
                  radius: const Radius.circular(10),
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: DataTable(
                        dividerThickness: 1,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Tanggal Transaksi",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Nama Barang",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Harga Barang",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Jumlah",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Total Harga",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Total Bayar",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                        ],
                        rows: transaksis.map<DataRow>((e) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  "${e.tanggal!.day}-${e.tanggal!.month}-${e.tanggal!.year} ${e.tanggal!.hour}:${e.tanggal!.minute}",
                                  style: primaryTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  e.namaBarang.toString(),
                                  style: primaryTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Rp${formatCurrency(e.hargaBarang)}",
                                  style: primaryTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  e.jumlah.toString(),
                                  style: primaryTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Rp${formatCurrency(e.totalHarga)}",
                                  style: primaryTextStyle,
                                ),
                              ),
                              DataCell(
                                Text(
                                  "Rp${formatCurrency(e.totalBayar)}",
                                  style: primaryTextStyle,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
