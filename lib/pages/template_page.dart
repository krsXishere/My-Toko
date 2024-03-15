import 'package:flutter/material.dart';
import 'package:toko_umkm/common/theme.dart';
import 'package:toko_umkm/pages/beranda_page.dart';
import 'package:toko_umkm/pages/kasir_page.dart';
import 'package:toko_umkm/pages/laporan_penjualan_page.dart';
import 'package:toko_umkm/pages/riwayat_transaksi_page.dart';
// import 'package:toko_umkm/pages/pengguna_page.dart';
import 'package:toko_umkm/pages/stok_input_page.dart';
import 'package:toko_umkm/widgets/drawer_item.dart';
// import 'package:wave/config.dart';
// import 'package:wave/wave.dart';

class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryPurple,
                      ),
                      height: 56,
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text(
                              "Menu",
                              style: primaryTextStyle.copyWith(
                                color: white,
                                fontWeight: bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DrawerItem(
                      text: "Kasir",
                      icon: const Icon(Icons.shopping_basket_rounded),
                      onTap: () {
                        setState(() {
                          page = 0;
                        });
                      },
                    ),
                    DrawerItem(
                      text: "Stok Masuk",
                      icon: const Icon(Icons.input_rounded),
                      onTap: () {
                        setState(() {
                          page = 1;
                        });
                      },
                    ),
                    DrawerItem(
                      text: "Laporan Penjualan",
                      icon: const Icon(Icons.note_alt_rounded),
                      onTap: () {
                        setState(() {
                          page = 2;
                        });
                      },
                    ),
                    DrawerItem(
                      text: "Riwayat Transaksi",
                      icon: const Icon(Icons.notes_rounded),
                      onTap: () {
                        setState(() {
                          page = 3;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: double.maxFinite,
                child: VerticalDivider(
                  width: 1,
                  thickness: 3,
                  color: unClickColor,
                ),
              ),
              Expanded(
                flex: 7,
                child: buildPage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    switch (page) {
      case 0:
        return const KasirPage();
      case 1:
        return const StokInputPage();
      case 2:
        return const LaporanPenjualan();
      case 3:
        return const RiwayatTransaksiPage();
      default:
        return const BerandaPage();
    }
  }
}
