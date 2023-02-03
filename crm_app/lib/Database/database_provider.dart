import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../Models/model.dart';
import '../Models/product_model.dart';
import '../Models/sale_model.dart';
import '../Data/dummy.dart';

class DatabaseProvider with ChangeNotifier {
  static final DatabaseProvider instance = DatabaseProvider.init();

  static Database? _database;

  DatabaseProvider.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase('tables3.db');

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

    return await openDatabase(
      dbPath,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE $unitSaleTable (
            ${Field.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${UnitSaleFields.productName} TEXT NOT NULL,
            ${UnitSaleFields.totalPrice} FLOAT NOT NULL,
            ${UnitSaleFields.profit} FLOAT NOT NULL,
            ${UnitSaleFields.quantitySold} INTEGER NOT NULL,
            ${UnitSaleFields.timeCreated} TEXT NOT NULL
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE $productTable (
            ${Field.id} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${ProductFields.productName} TEXT NOT NULL,
            ${ProductFields.costPrice} FLOAT NOT NULL,
            ${ProductFields.sellingPrice} FLOAT NOT NULL,
            ${ProductFields.amount} INTEGER NOT NULL
          )
          ''',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute(
            """
            DROP TABLE IF EXISTS $productTable
            """,
          );

          await db.execute(
            """
            DROP TABLE IF EXISTS $unitSaleTable
            """,
          );
        }
      },
      version: 3,
    );
  }

  Future<Model> insert(Model model, String table) async {
    final db = await instance.database;

    try {
      // creates new id if needed
      final id = await db.insert(table, model.toMap());

      var newModel = model.copy(id: id);

      notifyListeners();

      return newModel;
    } catch (e) {
      throw ErrorDescription(
          "DATABASE PROVIDER :: Failed to insert object: ${model.id} (id). \n ${e.toString()}");
    }
  }

  Future<int> update(Model model, String table) async {
    final db = await instance.database;

    try {
      int count = await db.update(
        table,
        model.toMap(),
        where: '${Field.id} = ?',
        whereArgs: [model.id],
      );

      notifyListeners();

      return count;
    } catch (e) {
      throw ErrorDescription("Failed to update object: ${model.id} (id)");
    }
  }

  Future<List<Map<String, Object?>>> rawQuery(String query) async {
    final db = await instance.database;

    return await db.rawQuery(query);
  }

  /// Returns the number of rows affected
  Future<int> delete(int id, String table) async {
    final db = await instance.database;

    try {
      int rowsAffected = await db.delete(
        table,
        where: '${Field.id} = ?',
        whereArgs: [id],
      );

      notifyListeners();

      return rowsAffected;
    } catch (e) {
      throw ErrorDescription("Failed to delete object: $id (id)");
    }
  }

  Future close() async {
    final db = await instance.database;

/*
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final dbPath = join(documentsDirectory.path, 'tables2.db');

    deleteDatabase(dbPath);*/

    db.close();
  }
}
