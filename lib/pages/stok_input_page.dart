import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_umkm/providers/barang_provider.dart';
import 'package:toko_umkm/widgets/modal_barang_widget.dart';
import '../common/theme.dart';
import '../widgets/button_alert_action.dart';
import '../widgets/custom_icon_button_widget.dart';
import 'package:intl/intl.dart';

class StokInputPage extends StatefulWidget {
  const StokInputPage({super.key});

  @override
  State<StokInputPage> createState() => _StokInputPageState();
}

class _StokInputPageState extends State<StokInputPage> {
  TextEditingController namaBarangController = TextEditingController();
  TextEditingController hargaBarangController = TextEditingController();
  TextEditingController kategoriBarangController = TextEditingController();
  TextEditingController stokBarangController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List selectedBarang = [];
  bool isSearch = false;

  String formatCurrency(var currency) {
    final initialData = NumberFormat("#,##0", "id");
    String currentData = initialData.format(currency);
    return currentData;
  }

  void clearTextFormField() {
    namaBarangController.clear();
    hargaBarangController.clear();
    kategoriBarangController.clear();
    stokBarangController.clear();
    // namaBarangController.clear();
  }

  void refreshData() {
    Provider.of<BarangProvider>(
      context,
      listen: false,
    ).getAllBarang();
  }

  @override
  void dispose() {
    selectedBarang.clear();
    clearTextFormField();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        refreshData();
      },
    );

    return StatefulBuilder(
      builder: (context, customSetState) {
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
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                : Text(
                    "Stok Masuk",
                    style: primaryTextStyle.copyWith(
                      color: white,
                      fontWeight: bold,
                    ),
                  ),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: selectedBarang.isEmpty
                    ? Row(
                        children: [
                          CustomIconButtonWidget(
                            onTap: () {
                              customSetState(() {
                                if (isSearch == false) {
                                  // customSetState(() {
                                  isSearch = !isSearch;
                                  // });
                                } else {
                                  Provider.of<BarangProvider>(
                                    context,
                                    listen: false,
                                  ).getAllBarang();

                                  // Future.delayed(const Duration(seconds: 2))
                                  //     .then((value) {
                                  //   searchController.clear();
                                  // });

                                  // customSetState(() {
                                  isSearch = !isSearch;
                                  // });
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
                          CustomIconButtonWidget(
                            onTap: () {
                              Provider.of<BarangProvider>(
                                context,
                                listen: false,
                              ).getAllBarang();
                            },
                            color: white,
                            icon: Icons.refresh_rounded,
                          )
                        ],
                      )
                    : Row(
                        children: [
                          CustomIconButtonWidget(
                            onTap: () {
                              alertDialogDeleteBarang();

                              Future.delayed(const Duration(seconds: 3))
                                  .then((value) {
                                customSetState(() {
                                  selectedBarang.clear();
                                });

                                refreshData();
                              });
                            },
                            color: white,
                            icon: Icons.delete_rounded,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomIconButtonWidget(
                            onTap: () {
                              refreshData();
                            },
                            color: white,
                            icon: Icons.refresh_rounded,
                          ),
                        ],
                      ),
              ),
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
                                  "Edit",
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
                            rows: barangs
                                .map<DataRow>(
                                  (e) => DataRow(
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
                                        CustomIconButtonWidget(
                                          color: unClickColor,
                                          icon: Icons.edit_rounded,
                                          onTap: () {
                                            namaBarangController.text =
                                                e.namaBarang.toString();
                                            hargaBarangController.text =
                                                e.hargaBarang.toString();
                                            kategoriBarangController.text =
                                                e.kategoriBarang.toString();
                                            stokBarangController.text =
                                                e.stokBarang.toString();
                        
                                            showModalEditBarang(
                                                int.parse(e.id.toString()));
                                          },
                                        ),
                                      ),
                                      DataCell(
                                        Checkbox(
                                          activeColor: primaryPurple,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          value: e.isSelected,
                                          onChanged: (value) {
                                            customSetState(() {
                                              e.isSelected = value!;
                        
                                              if (selectedBarang.contains(e.id)) {
                                                selectedBarang.remove(e.id);
                                              } else {
                                                selectedBarang.add(e.id);
                                              }
                        
                                              // print(selectedBarang.toString());
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: secodaryPurple,
            onPressed: () {
              showModalAddBarang();
            },
            child: Icon(
              Icons.add_rounded,
              color: white,
            ),
          ),
        );
      },
    );
  }

  alertDialogDeleteBarang() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (builder) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20),
          title: Text(
            "Hapus Barang?",
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          actions: [
            ButtonAlertActionWidget(
              backgroundColor: primaryPurple,
              colorBorderSide: Colors.white,
              isBorderSide: false,
              colorText: white,
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "Batal",
            ),
            ButtonAlertActionWidget(
              backgroundColor: white,
              colorBorderSide: Colors.red,
              isBorderSide: true,
              colorText: Colors.red,
              onPressed: () {
                Provider.of<BarangProvider>(
                  context,
                  listen: false,
                ).deleteBarang(selectedBarang);

                Navigator.of(context).pop();
              },
              text: "Hapus",
            ),
          ],
        );
      },
    );
  }

  showModalAddBarang() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (builder) {
        return ModalBarangWidget(
          namaBarangController: namaBarangController,
          hargaBarangController: hargaBarangController,
          kategoriBarangController: kategoriBarangController,
          stokBarangController: stokBarangController,
          searchController: searchController,
          buttonText: "Tambah",
          onPressed: () {
            if (namaBarangController.text != "" &&
                hargaBarangController.text != "" &&
                kategoriBarangController.text != "" &&
                stokBarangController.text != "") {
              Provider.of<BarangProvider>(
                context,
                listen: false,
              ).createBarang(
                namaBarangController.text,
                double.parse(hargaBarangController.text),
                kategoriBarangController.text,
                int.parse(stokBarangController.text),
              );

              refreshData();

              clearTextFormField();

              Navigator.of(context).pop();
            } else {
              showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: const EdgeInsets.only(bottom: 20),
                    title: Text(
                      "Isi Semua Data",
                      style: primaryTextStyle,
                      textAlign: TextAlign.center,
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
        );
      },
    );
  }

  showModalEditBarang(int id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (builder) {
        return ModalBarangWidget(
          namaBarangController: namaBarangController,
          hargaBarangController: hargaBarangController,
          kategoriBarangController: kategoriBarangController,
          stokBarangController: stokBarangController,
          searchController: searchController,
          buttonText: "Edit",
          onPressed: () {
            if (namaBarangController.text != "" &&
                hargaBarangController.text != "" &&
                kategoriBarangController.text != "" &&
                stokBarangController.text != "") {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      actionsPadding: const EdgeInsets.only(bottom: 20),
                      title: Text(
                        "Edit Barang?",
                        style: primaryTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        ButtonAlertActionWidget(
                          backgroundColor: primaryPurple,
                          colorBorderSide: Colors.white,
                          isBorderSide: false,
                          colorText: white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: "Batal",
                        ),
                        ButtonAlertActionWidget(
                          backgroundColor: white,
                          colorBorderSide: Colors.red,
                          isBorderSide: true,
                          colorText: Colors.red,
                          onPressed: () {
                            Provider.of<BarangProvider>(
                              context,
                              listen: false,
                            ).editBarang(
                              id,
                              namaBarangController.text,
                              double.parse(hargaBarangController.text),
                              kategoriBarangController.text,
                              int.parse(stokBarangController.text),
                            );

                            clearTextFormField();
                            refreshData();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          text: "Edit",
                        ),
                      ],
                    );
                  });
            } else {
              showDialog(
                context: context,
                builder: (builder) {
                  return AlertDialog(
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: const EdgeInsets.only(bottom: 20),
                    title: Text(
                      "Isi Semua Data",
                      style: primaryTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      ButtonAlertActionWidget(
                        backgroundColor: primaryPurple,
                        colorBorderSide: Colors.white,
                        isBorderSide: false,
                        colorText: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          clearTextFormField();
                        },
                        text: "Oke",
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
