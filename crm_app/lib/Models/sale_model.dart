import 'model.dart';
import '../Database/database_provider.dart';

const String saleTable = "sales_tb";

class SaleModelFields extends Field {
  @override
  List<String> get values {
    var l = super.values;

    l.addAll([
      productName,
      totalPrice,
      profit,
      quantitySold,
    ]);

    return l;
  }

  static const String productName = 'productName';
  static const String totalPrice = 'totalPrice';
  static const String profit = 'profit';
  static const String quantitySold = 'quantitySold';
  static const String timeCreated = 'timeCreated';
}

class SaleModel implements Model {
  @override
  final int? id;
  final String productName;
  final double totalPrice;
  final double profit;
  final int quantitySold;
  final DateTime timeCreated;

  const SaleModel({
    this.id,
    required this.productName,
    required this.totalPrice,
    required this.profit,
    required this.quantitySold,
    required this.timeCreated,
  });

  @override
  set id(int? _id) {
    id = _id;
  }

  static Future<Model> readUnitSale(int id, String table, Field field) async {
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

  static SaleModel fromMap(Map<String, Object?> map) {
    return SaleModel(
      id: map[Field.id] as int?,
      productName: map[SaleModelFields.productName] as String,
      totalPrice: map[SaleModelFields.totalPrice] as double,
      profit: map[SaleModelFields.profit] as double,
      quantitySold: map[SaleModelFields.quantitySold] as int,
      timeCreated: DateTime.parse(map[SaleModelFields.timeCreated] as String),
    );
  }

  static Future<List<Model>> readAllUnitSales() async {
    final db = await DatabaseProvider.instance.database;

    // Order by the time in a ascending order
    final result = await db.query(saleTable);

    return result.map((map) => fromMap(map)).toList();
  }

  static Future<List<SaleModel>> searchModel(
    String keyword,
    String table,
    String where,
  ) async {
    final db = await DatabaseProvider.instance.database;

    var allRows = await db.query(
      table,
      where: where,
      whereArgs: ['%$keyword%'],
    );

    List<SaleModel> model = allRows.map((model) => fromMap(model)).toList();

    return model;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      Field.id: id,
      SaleModelFields.productName: productName,
      SaleModelFields.totalPrice: totalPrice,
      SaleModelFields.profit: profit,
      SaleModelFields.quantitySold: quantitySold,
      SaleModelFields.timeCreated: timeCreated.toString(),
    };
  }

  @override
  Model copy({
    int? id,
    String? productName,
    double? totalPrice,
    double? profit,
    int? quantitySold,
    DateTime? timeCreated,
  }) {
    return SaleModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      totalPrice: totalPrice ?? this.totalPrice,
      profit: profit ?? this.profit,
      quantitySold: quantitySold ?? this.quantitySold,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }
}
