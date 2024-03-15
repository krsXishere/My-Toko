// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:toko_umkm/pages/checkout_page.dart';
import '../common/theme.dart';
import '../models/barang_model.dart';
import '../providers/barang_provider.dart';
import '../widgets/button_alert_action.dart';
import '../widgets/custom_icon_button_widget.dart';

class KasirPage extends StatefulWidget {
  // List<BarangModel> selectedBarang = [];
  const KasirPage({
    super.key,
    // required this.selectedBarang,
  });

  @override
  State<KasirPage> createState() => _KasirPageState();
}

class _KasirPageState extends State<KasirPage> {
  TextEditingController searchController = TextEditingController();
  List<BarangModel> selectedBarang = [];
  bool isSearch = false;
  ScrollController scrollController = ScrollController();

  String formatCurrency(var currency) {
    final initialData = NumberFormat("#,##0", "id");
    String currentData = initialData.format(currency);
    return currentData;
  }

  void showConfirmCartDialog(Function() onPressedKonfirmasi) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builder) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            "Konfirmasi Keranjang Pembelian?",
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          content: const Icon(
            Icons.shopping_cart_rounded,
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
              onPressed: onPressedKonfirmasi,
              text: "Oke",
            ),
          ],
        );
      },
    );
  }

  @override
  void reassemble() {
    refreshData();
    super.reassemble();
  }

  @override
  void dispose() {
    selectedBarang.clear();
    // print("print $selectedBarang");
    super.dispose();
  }

  void refreshData() {
    Provider.of<BarangProvider>(
      context,
      listen: false,
    ).getAllBarang();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        refreshData();
      },
    );

    return StatefulBuilder(
      builder: (builder, customSetState) {
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
                    onFieldSubmitted: (value) {
                      customSetState(() {
                        Provider.of<BarangProvider>(
                          context,
                          listen: false,
                        ).searchBarang(value);
                      });
                    },
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
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                : Text(
                    "Kasir",
                    style: primaryTextStyle.copyWith(
                      color: white,
                      fontWeight: bold,
                    ),
                  ),
            elevation: 0,
            actions: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CustomIconButtonWidget(
                        onTap: () {
                          customSetState(() {
                            if (isSearch == false) {
                              isSearch = !isSearch;
                            } else {
                              Provider.of<BarangProvider>(
                                context,
                                listen: false,
                              ).getAllBarang();

                              isSearch = !isSearch;
                            }
                          });
                        },
                        color: white,
                        icon: isSearch
                            ? Icons.cancel_rounded
                            : Icons.search_rounded,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Consumer<BarangProvider>(
                        builder: (context, value, child) {
                          final barangs = value.barangs;
                          return CustomIconButtonWidget(
                            onTap: () {
                              if (selectedBarang.isNotEmpty) {
                                showConfirmCartDialog(
                                  () {
                                    Navigator.of(context)
                                        .push(
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: const CheckoutPage(),
                                      ),
                                    )
                                        .then((value) {
                                      selectedBarang.clear();
                                      refreshData();
                                    });

                                    customSetState(() {
                                      for (var item in barangs) {
                                        item.isSelected = false;
                                      }
                                    });
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actionsPadding:
                                          const EdgeInsets.only(bottom: 20),
                                      title: Text(
                                        "Isi keranjang minimal 1 barang!",
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
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          text: "Oke",
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            color: white,
                            icon: Icons.shopping_cart,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomIconButtonWidget(
                        onTap: () {
                          Provider.of<BarangProvider>(
                            context,
                            listen: false,
                          ).getAllBarang();
                        },
                        color: white,
                        icon: Icons.refresh_rounded,
                      ),
                    ],
                  )),
            ],
          ),
          body: Consumer<BarangProvider>(
            builder: (context, value, child) {
              final barangs = value.barangs;

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
                                  "Pilih",
                                  style: primaryTextStyle.copyWith(
                                    fontWeight: bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: barangs.map<DataRow>(
                              (e) {
                                return DataRow(
                                  cells: [
                                    // DataCell(
                                    //   Text(
                                    //     e.id.toString(),
                                    //     style: primaryTextStyle,
                                    //   ),
                                    // ),
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
                                      Checkbox(
                                        activeColor: primaryPurple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        value: e.isSelected,
                                        onChanged: (valueCheckbox) {
                                          customSetState(() {
                                            e.isSelected = valueCheckbox!;
                        
                                            if (valueCheckbox) {
                                              if (!selectedBarang.any((element) =>
                                                  element.id == e.id)) {
                                                selectedBarang.add(e);
                                              }
                                            } else {
                                              selectedBarang.removeWhere(
                                                  (element) =>
                                                      element.id == e.id);
                                            }
                        
                                            value.setCart(selectedBarang);
                        
                                            // print(selectedBarang.toString());
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    );
            },
          ),
        );
      },
    );
  }
}
