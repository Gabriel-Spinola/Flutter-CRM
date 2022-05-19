import 'model.dart';
import '../Database/database_provider.dart';

const String saleTable = 'sales';

class SaleFields extends Field {
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

class SaleModel implements Model {
  @override
  final int? id;
  final String productName;
  final double price;
  final int amount;

  const SaleModel({
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

  static Model fromMap(Map<String, Object?> map) {
    return SaleModel(
      id: map[Field.id] as int?,
      productName: map[SaleFields.productName] as String,
      price: map[SaleFields.price] as double,
      amount: map[SaleFields.amount] as int,
    );
  }

  static Future<List<Model>> readAllNotes() async {
    final db = await DatabaseProvider.instance.database;

    // Order by the time in a ascending order
    final result = await db.query(
      saleTable,
    );

    return result.map((map) => fromMap(map)).toList();
  }

  @override
  Map<String, Object?> toMap() {
    return {
      Field.id: id,
      SaleFields.productName: productName,
      SaleFields.price: price,
      SaleFields.amount: amount,
    };
  }

  @override
  Model copy({int? id, String? productName, double? price, int? amount}) {
    return SaleModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      amount: amount ?? this.amount,
    );
  }
}
