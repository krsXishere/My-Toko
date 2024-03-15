import 'package:flutter/material.dart';
import '../common/theme.dart';
import 'custom_textformfield_widget.dart';

class ModalBarangWidget extends StatelessWidget {
  final TextEditingController hargaBarangController;
  final TextEditingController kategoriBarangController;
  final TextEditingController stokBarangController;
  final TextEditingController searchController;
  final TextEditingController namaBarangController;
  final String buttonText;
  final Function() onPressed;

  const ModalBarangWidget({
    super.key,
    required this.namaBarangController,
    required this.hargaBarangController,
    required this.kategoriBarangController,
    required this.stokBarangController,
    required this.searchController,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextFormField(
              controller: namaBarangController,
              hintText: "Masukkan nama barang",
              textInputType: TextInputType.text,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            CustomTextFormField(
              controller: hargaBarangController,
              hintText: "Masukkan harga barang",
              textInputType: TextInputType.number,
              isNumber: true,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            CustomTextFormField(
              controller: kategoriBarangController,
              hintText: "Masukkan kategori barang",
              textInputType: TextInputType.text,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            CustomTextFormField(
              controller: stokBarangController,
              hintText: "Masukkan stok barang",
              textInputType: TextInputType.number,
              isNumber: true,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: primaryTextStyle.copyWith(
                    color: white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
