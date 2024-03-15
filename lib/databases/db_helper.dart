// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
// import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  // static setUp() async {
  //   if(Platform.isWindows || Platform.isLinux) {
  //     sqfliteFfiInit();
  //     databaseFactory = databaseFactoryFfi;
  //     // db = await databaseFactory.openDatabase("path/to/toko.db");

  //   }
  // }
  // void windowsInit() {
  //   String path;
  //   if (kReleaseMode) {
  //     path = 'sqlite3.dll';
  //   } else {
  //     var location = findPackagePath(Directory.current.path);
  //     path = normalize(join(location, 'src', 'windows', 'sqlite3.dll'));
  //   }

  //   open.overrideFor(windows, () {
  //     print('loading $path');
  //     try {
  //       return DynamicLibrary.open(path);
  //     } catch (e) {
  //       stderr.writeln('Failed to load sqlite3.dll at $path');
  //       rethrow;
  //     }
  //   });

  //   sql.openInMemory().dispose();
  // }

//   String? pathGlobal;

//   initialDatabase() async {
//     sqfliteFfiInit();
//     var databaseFactory = databaseFactoryFfi;
//     var databasesPath = await databaseFactory.getDatabasesPath();
//     late sql.Database _db;

//     var path = join(databasesPath, "toko.db");

//     print(path);
//     var exists = await databaseFactory.databaseExists(path);

//     if (!exists) {
//       // Should happen only the first time you launch your application
//       print("Creating new copy from asset");

//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (_) {}
//       // Copy from asset
//       ByteData data = await rootBundle.load('assets/toko.db');
//       print(join('assets','toko.db'));
//       // ByteData data = await rootBundle.load(join('assets','unit_price.db'));
//       List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

//       // Write and flush the bytes written
//       await File(path).writeAsBytes(bytes, flush: true);
//     } else {
//       print("Opening existing database");
//     }
//     // open the database
//     _db = await databaseFactory.openDatabase(path);

//     pathGlobal = path;

//     print(databasesPath);
// }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initWinDB();
      return _database!;
    }
  }

  // Future<Database> initWinDB() async {
  //   sqfliteFfiInit();
  //   final databaseFactory = databaseFactoryFfi;
  //   return await databaseFactory.openDatabase(
  //     inMemoryDatabasePath,
  //     options: OpenDatabaseOptions(
  //       onCreate: _onCreate,
  //       version: 1,
  //     ),
  //   );
  // }

  Future<Database> initWinDB() async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final databasePath = join(appDirectory.path, 'toko.db');

  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;
  return await databaseFactory.openDatabase(
    databasePath,
    options: OpenDatabaseOptions(
      onCreate: _onCreate,
      version: 1,
    ),
  );
}


  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute("""create table users(
      id integer primary key autoincrement not null,
      email text,
      password text
    )""");

    await db.execute("""create table barangs(
      id integer primary key autoincrement not null,
      kode_barang text, 
      nama_barang text,
      harga_barang double,
      kategori_barang text,
      stok_barang int
    )""");

    await db.execute("""create table transaksis(
      id integer primary key autoincrement not null,
      tanggal datetime,
      total_harga double,
      total_bayar double
    )""");

    await db.execute("""create table detail_transaksi(
      id integer primary key autoincrement not null,
      jumlah integer,
      transaksi_id integer,
      barang_id integer,
      foreign key(transaksi_id) references transaksis(id) on update cascade on delete cascade,
      foreign key(barang_id) references barangs(id) on update cascade on delete cascade
    )""");
  }

  // static Future<void> createTables(sql.Database database) async {
  //   await database.execute("""create table users(
  //     id integer primary key autoincrement not null,
  //     email text,
  //     password text
  //   )""");

  //   await database.execute("""create table barangs(
  //     id integer primary key autoincrement not null,
  //     kode_barang text,
  //     nama_barang text,
  //     harga_barang double,
  //     kategori_barang text,
  //     stok_barang int
  //   )""");

  //   await database.execute("""create table transaksis(
  //     id integer primary key autoincrement not null,
  //     tanggal datetime,
  //     total_harga double,
  //     total_bayar double
  //   )""");

  //   await database.execute("""create table detail_transaksi(
  //     id integer primary key autoincrement not null,
  //     jumlah integer,
  //     transaksi_id integer,
  //     barang_id integer,
  //     foreign key(transaksi_id) references transaksis(id) on update cascade on delete cascade,
  //     foreign key(barang_id) references barangs(id) on update cascade on delete cascade
  //   )""");
  // }

  // static Future<sql.Database> database() async {
  //   return sql.openDatabase(
  //     "toko.db",
  //     version: 1,
  //     onCreate: (db, version) async {
  //       await createTables(db);
  //     },
  //     onOpen: (db) {},
  //   );
  // }
}
