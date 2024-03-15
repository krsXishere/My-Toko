import 'package:flutter/material.dart';
import 'package:toko_umkm/common/theme.dart';
import 'package:toko_umkm/widgets/custom_card_widget.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        elevation: 0,
        title: Text(
          "Beranda",
          style: primaryTextStyle.copyWith(
            color: white,
            fontWeight: bold,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.count(
          padding: EdgeInsets.all(defaultPadding),
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            CustomCardWidget(
              color: primaryPurple,
            ),
            CustomCardWidget(
              color: secodaryPurple,
            ),
            const CustomCardWidget(
              color: Colors.lightBlue,
            ),
            const CustomCardWidget(
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
