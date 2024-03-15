// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_umkm/models/income_model.dart';
import 'package:toko_umkm/providers/transaksi_provider.dart';
import '../common/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../providers/date_picker_provider.dart';

class LaporanPenjualan extends StatefulWidget {
  const LaporanPenjualan({super.key});

  @override
  State<LaporanPenjualan> createState() => _LaporanPenjualanState();
}

class _LaporanPenjualanState extends State<LaporanPenjualan> {
  TextEditingController searchController = TextEditingController();
  late TooltipBehavior tooltipProfit;

  @override
  void initState() {
    tooltipProfit = TooltipBehavior(
      enable: true,
      textStyle: primaryTextStyle.copyWith(
        color: white,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getRangeDate(BuildContext context) async {
      final DateTimeRange? rangeDate = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(3000),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: primaryPurple,
              colorScheme: ColorScheme.light(
                primary: primaryPurple,
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (rangeDate != null) {
        Provider.of<DatePickerProvider>(
          context,
          listen: false,
        )
            .setSelectedDate(
          rangeDate.start,
          rangeDate.end,
        )
            .then((value) async {
          String starDate = DateFormat("yyyy-MM-dd").format(rangeDate.start);
          String endDate = DateFormat("yyyy-MM-dd").format(rangeDate.end);

          await Provider.of<TransaksiProvider>(
            context,
            listen: false,
          ).fetchData(starDate, endDate);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: Text(
          "Laporan Penjualan",
          style: primaryTextStyle.copyWith(
            color: white,
            fontWeight: bold,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                  ),
                ),
                onPressed: () async {
                  getRangeDate(context);
                },
                child: Text(
                  "Cari Tanggal",
                  style: primaryTextStyle.copyWith(
                    color: primaryPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TransaksiProvider>(
        builder: (context, value, child) {
          return value.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryPurple,
                  ),
                )
              : Column(
                  mainAxisAlignment: value.income.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    value.income.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: grey.withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(),
                                onTooltipRender: (TooltipArgs args) {
                                  args.header = "Penjualan";
                                },
                                tooltipBehavior: tooltipProfit,
                                series: <ChartSeries<IncomeModel, String>>[
                                  ColumnSeries<IncomeModel, String>(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        primaryPurple,
                                        white,
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                    dataSource: Provider.of<TransaksiProvider>(
                                      context,
                                      listen: false,
                                    ).income,
                                    xValueMapper:
                                        (IncomeModel transaction, _) =>
                                            transaction.date,
                                    yValueMapper:
                                        (IncomeModel transaction, _) =>
                                            transaction.amount,
                                    dataLabelMapper:
                                        (IncomeModel transaction, _) =>
                                            transaction.label,
                                    dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      textStyle: primaryTextStyle,
                                    ),
                                    name: 'Penjualan',
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.not_interested_rounded,
                                color: unClickColor,
                                size: 100,
                              ),
                            ],
                          ),
                    value.income.isEmpty
                        ? Text(
                            "Data Kosong",
                            style: primaryTextStyle.copyWith(
                              color: unClickColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                );
        },
      ),
    );
  }
}
