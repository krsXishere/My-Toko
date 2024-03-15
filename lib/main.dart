import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toko_umkm/pages/template_page.dart';
import 'package:toko_umkm/providers/barang_provider.dart';
import 'package:toko_umkm/providers/date_picker_provider.dart';
import 'package:toko_umkm/providers/transaksi_provider.dart';
import 'package:toko_umkm/providers/user_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    await WindowManager.instance.ensureInitialized();

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    windowManager.waitUntilReadyToShow().then((value) async {
      await windowManager.setTitle("Toko Saya");
    });
  }

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BarangProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TransaksiProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatePickerProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return const MaterialApp(
            title: 'Toko Saya',
            debugShowCheckedModeBanner: false,
            home: TemplatePage(),
          );
        },
      ),
    );
  }
}
