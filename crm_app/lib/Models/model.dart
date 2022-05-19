abstract class Model {
  late final int? id;

  Map<String, Object?> toMap();
  Model copy({int? id});

  Model fromMap(Map<String, Object?> map);
}

abstract class Field {
  final List<String> values = [Field.id];

  static const String id = '_id';
}
