import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../Models/model.dart';
import '../Models/sale_model.dart';
import '../Data/dummy.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider.init();

  static Database? _database;

  DatabaseProvider.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase('tables.db');

    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();

      // Change the default factory.
      databaseFactory = databaseFactoryFfi;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final dbPath = join(documentsDirectory.path, filePath);

    print('database init');

    return await openDatabase(
      dbPath,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE $saleTable (
            ${Field.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${SaleFields.productName} TEXT NOT NULL,
            ${SaleFields.price} FLOAT NOT NULL,
            ${SaleFields.amount} INTEGER NOT NULL
          )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<Model> insert(Model model, String table) async {
    final db = await instance.database;

    // creates new id if needed
    final id = await db.insert(table, model.toMap());
    return model.copy(id: id);
  }

  Future<int> update(Model note, String table) async {
    final db = await instance.database;

    return db.update(
      table,
      note.toMap(),
      where: '${Field.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id, String table) async {
    final db = await instance.database;

    return await db.delete(
      table,
      where: '${Field.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final dbPath = join(documentsDirectory.path, 'tables.db');

    deleteDatabase(dbPath);

    db.close();
  }
}
