abstract class IObjectModel {
  late final int id;

  Map<String, dynamic> toMap();
  List<IObjectModel> queryToList(List<Map<String, dynamic>> query);

  @override
  String toString();
}
