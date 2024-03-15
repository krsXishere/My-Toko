import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toko_umkm/pages/pengguna_page.dart';
import '../common/theme.dart';
import 'drawer_item.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      height: 300,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.purple[300],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_rounded,
            color: white,
            size: 100,
          ),
          Text(
            "Toko Saya",
            style: primaryTextStyle.copyWith(
              color: white,
              fontSize: 18,
              fontWeight: bold,
            ),
          )
        ],
      ),
    );

Widget buildMenuItems(BuildContext context) => Column(
      children: [
        DrawerItem(
          text: "Beranda",
          icon: const Icon(Icons.dashboard_rounded),
          onTap: () {},
        ),
        DrawerItem(
          text: "Kasir",
          icon: const Icon(Icons.shopping_basket_rounded),
          onTap: () {},
        ),
        DrawerItem(
          text: "Stok Masuk",
          icon: const Icon(Icons.input_rounded),
          onTap: () {},
        ),
        DrawerItem(
          text: "Laporan Penjualan",
          icon: const Icon(Icons.file_copy_rounded),
          onTap: () {},
        ),
        DrawerItem(
          text: "Pengguna",
          icon: const Icon(Icons.person_rounded),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              PageTransition(
                child: const PenggunaPage(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          },
        ),
      ],
    );
