import 'model.dart';
import '../Database/database_provider.dart';

const String productTable = 'sales';

class ProductFields extends Field {
  @override
  List<String> get values {
    var l = super.values;

    l.addAll([
      productName,
      price,
      amount,
    ]);

    return l;
  }

  static const String productName = 'productName';
  static const String price = 'price';
  static const String amount = 'amount';
}

class ProductModel implements Model {
  @override
  final int? id;
  final String productName;
  final double price;
  final int amount;

  const ProductModel({
    this.id,
    required this.productName,
    required this.price,
    required this.amount,
  });

  @override
  set id(int? _id) {
    id = _id;
  }

  static Future<Model> readSale(int id, String table, Field field) async {
    final db = await DatabaseProvider.instance.database;

    final maps = await db.query(
      table,
      columns: field.values,
      where: '${Field.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  static ProductModel fromMap(Map<String, Object?> map) {
    return ProductModel(
      id: map[Field.id] as int?,
      productName: map[ProductFields.productName] as String,
      price: map[ProductFields.price] as double,
      amount: map[ProductFields.amount] as int,
    );
  }

  static Future<List<Model>> readAllSales() async {
    final db = await DatabaseProvider.instance.database;

    // Order by the time in a ascending order
    final result = await db.query(
      productTable,
    );

    return result.map((map) => fromMap(map)).toList();
  }

  static Future<List<ProductModel>> searchModel(
      String keyword, String table, String where) async {
    final db = await DatabaseProvider.instance.database;

    var allRows = await db.query(
      table,
      where: where,
      whereArgs: ['%$keyword%'],
    );

    List<ProductModel> model = allRows.map((model) => fromMap(model)).toList();

    return model;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      Field.id: id,
      ProductFields.productName: productName,
      ProductFields.price: price,
      ProductFields.amount: amount,
    };
  }

  @override
  Model copy({int? id, String? productName, double? price, int? amount}) {
    return ProductModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      amount: amount ?? this.amount,
    );
  }
}
