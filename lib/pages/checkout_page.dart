import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_umkm/widgets/custom_textformfield_widget.dart';
import '../common/theme.dart';
import '../providers/barang_provider.dart';
import '../widgets/button_alert_action.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    super.key,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  ScrollController scrollController = ScrollController();
  List<Widget> generatedTextWidgets = [];
  List<TextEditingController> jumlahControllers = [];
  TextEditingController payController = TextEditingController();
  int jumlah = 1;
  double totalHarga = 0;

  void showWillPopDialog(Function() onPressedKonfirmasi) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builder) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            "Batalkan Pembelian?",
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Hal ini dapat menghapus barang pada keranjang!",
            style: primaryTextStyle.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          actions: [
            ButtonAlertActionWidget(
              backgroundColor: white,
              colorBorderSide: Colors.red,
              isBorderSide: true,
              colorText: Colors.red,
              onPressed: onPressedKonfirmasi,
              text: "Ya, Batalkan",
            ),
            ButtonAlertActionWidget(
              backgroundColor: primaryPurple,
              colorBorderSide: Colors.white,
              isBorderSide: false,
              colorText: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "Lanjutkan",
            ),
          ],
        );
      },
    );
  }

  void showAlert(String title, Function() onPressed) {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            title,
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          content: const Icon(
            Icons.warning,
            color: Colors.grey,
            size: 100,
          ),
          actions: [
            ButtonAlertActionWidget(
              backgroundColor: primaryPurple,
              colorBorderSide: Colors.white,
              isBorderSide: false,
              colorText: Colors.white,
              onPressed: onPressed,
              text: "Oke",
            ),
          ],
        );
      },
    );
  }

  void showPaySuccess() {
    showDialog(
      context: context,
      builder: (builder) {
        double kembalian = Provider.of<BarangProvider>(
          context,
          listen: false,
        ).kembalian;
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            "Pembayaran Berhasil",
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: 150,
            width: 150,
            child: Column(
              children: [
                const Icon(
                  Icons.check_rounded,
                  color: Colors.grey,
                  size: 100,
                ),
                Text(
                  "Kembalian: Rp${formatCurrency(kembalian)}",
                  style: primaryTextStyle,
                ),
              ],
            ),
          ),
          actions: [
            ButtonAlertActionWidget(
              backgroundColor: primaryPurple,
              colorBorderSide: Colors.white,
              isBorderSide: false,
              colorText: Colors.white,
              onPressed: () {
                Provider.of<BarangProvider>(
                  context,
                  listen: false,
                ).clearKembalian();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              text: "Kembali ke kasir",
            ),
          ],
        );
      },
    );
  }

  void showPay() {
    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            "Konfirmasi Transaksi?",
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          content: const Icon(
            Icons.shopping_cart_checkout_rounded,
            color: Colors.grey,
            size: 100,
          ),
          actions: [
            ButtonAlertActionWidget(
              backgroundColor: white,
              colorBorderSide: Colors.red,
              isBorderSide: true,
              colorText: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "Batal",
            ),
            ButtonAlertActionWidget(
              backgroundColor: primaryPurple,
              colorBorderSide: Colors.white,
              isBorderSide: false,
              colorText: Colors.white,
              onPressed: () {
                Provider.of<BarangProvider>(
                  context,
                  listen: false,
                ).transaksi(double.parse(payController.text)).then((value) {
                  if (double.parse(payController.text) >=
                      Provider.of<BarangProvider>(
                        context,
                        listen: false,
                      ).totalHarga) {
                    Provider.of<BarangProvider>(
                      context,
                      listen: false,
                    )
                        .setkembalian(double.parse(payController.text))
                        .then((value) {
                      showPaySuccess();
                    });
                  } else {
                    showAlert(
                      "Nominal uang tidak cukup",
                      () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    );
                  }
                });
              },
              text: "Konfirmasi",
            ),
          ],
        );
      },
    );
  }

  String formatCurrency(var currency) {
    final initialData = NumberFormat("#,##0", "id");
    String currentData = initialData.format(currency);
    return currentData;
  }

  @override
  void dispose() {
    for (var controller in jumlahControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (jumlahControllers.isEmpty) {
      jumlahControllers = List.generate(
        Provider.of<BarangProvider>(context, listen: false).carts.length,
        (index) => TextEditingController(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (builder, customSetState) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                showWillPopDialog(() {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  Provider.of<BarangProvider>(
                    context,
                    listen: false,
                  ).setCart([]);

                  Provider.of<BarangProvider>(
                    context,
                    listen: false,
                  ).clearTotalHarga(0);

                  Provider.of<BarangProvider>(
                    context,
                    listen: false,
                  ).clearKembalian();
                });
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: appbarColor,
            title: Text(
              "Checkout",
              style: primaryTextStyle.copyWith(
                color: white,
                fontWeight: bold,
              ),
            ),
            elevation: 0,
          ),
          body: Consumer<BarangProvider>(
            builder: (context, value, child) {
              final carts = value.carts;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 7,
                    child: Scrollbar(
                      controller: scrollController,
                      thickness: 10,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: value.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryPurple,
                                ),
                              )
                            : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: DataTable(
                                  dividerThickness: 1,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "Kode Barang",
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
                                        "Kategori Barang",
                                        style: primaryTextStyle.copyWith(
                                          fontWeight: bold,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "Stok Barang",
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
                                  ],
                                  rows: carts.map<DataRow>(
                                    (e) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              e.kodeBarang.toString(),
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
                                              e.kategoriBarang.toString(),
                                              style: primaryTextStyle,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              e.stokBarang.toString(),
                                              style: primaryTextStyle,
                                            ),
                                          ),
                                          DataCell(
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                        RegExp(r'[0-9]'),
                                                      ),
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style:
                                                        primaryTextStyle.copyWith(
                                                      fontSize: 14,
                                                    ),
                                                    cursorWidth: 2,
                                                    cursorColor: primaryPurple,
                                                    controller: jumlahControllers[
                                                        carts.indexOf(e)],
                                                    onFieldSubmitted:
                                                        (valueString) {
                                                      int orderStok =
                                                          int.parse(valueString);
                                                      if (orderStok != 0) {
                                                        if (e.stokBarang! >=
                                                            orderStok) {
                                                          value.updateJumlah(
                                                              e, orderStok);
                            
                                                          generatedTextWidgets
                                                              .add(
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${e.namaBarang}",
                                                                  style:
                                                                      primaryTextStyle,
                                                                ),
                                                                Text(
                                                                  "x $orderStok",
                                                                  style:
                                                                      primaryTextStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        } else {
                                                          showAlert(
                                                            "Stok barang tidak mecukupi!",
                                                            () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          );
                                                          jumlahControllers[carts
                                                                  .indexOf(e)]
                                                              .clear();
                                                        }
                                                      } else {
                                                        showAlert(
                                                          "Isi minimal 1 barang",
                                                          () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                        10,
                                                      ),
                                                      focusColor: white,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: primaryPurple,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: primaryPurple,
                                                        ),
                                                      ),
                                                      errorBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                            ),
                      ),
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
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Text(
                              "Struk Pembelian",
                              style: primaryTextStyle.copyWith(
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ...generatedTextWidgets,
                          Divider(
                            thickness: 3,
                            color: unClickColor,
                          ),
                          Text(
                            "Total Harga: Rp${formatCurrency(value.totalHarga)}",
                            style: primaryTextStyle,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Kembalian: Rp${formatCurrency(value.kembalian)}",
                            style: primaryTextStyle,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: payController,
                            hintText: "Masukkan nominal pembayaran",
                            textInputType: TextInputType.number,
                            isNumber: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomSheet: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 7,
                  child: SizedBox.shrink(),
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
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                        ),
                        onPressed: () {
                          if (generatedTextWidgets.isNotEmpty &&
                              payController.text != "") {
                            showPay();
                          } else {
                            showAlert(
                              "Masukkan Jumlah Barang dan Pembayaran!",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                        child: Text(
                          "Bayar",
                          style: primaryTextStyle.copyWith(
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
