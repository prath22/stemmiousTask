import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initialiseDatabase() async {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  return databaseFactory.openDatabase(
    p.join(await getDatabasesPath(), "expences.db"),
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Expences(
            id INTEGER PRIMARY KEY,
            category TEXT,
            description TEXT,
            imgUrl TEXT,
            date TEXT,
            time TEXT,
            amount REAL
          )
        ''');

        db.execute('''
          CREATE TABLE graph(
            id INTEGER PRIMARY KEY,
            category TEXT,
            imgUrl TEXT,
            amount REAL
          )
        ''');
      },
    ),
  );
}
