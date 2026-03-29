import 'package:tch_appliable_core/tch_appliable_core.dart';

class SembastRecord extends DataModel {
  static const String store = 'record';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colDescription = 'description';
  static const String colCreated = 'created';

  int? id;
  late String name;
  late String description;
  late int created;

  /// SembastRecord initialization from JSON map
  SembastRecord.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json[colId];
    name = json[colName] ?? '';
    description = json[colDescription] ?? '';
    created = json[colCreated];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      colName: name,
      colDescription: description,
      colCreated: created,
    };

    if (id != null) {
      json[colId] = id;
    }

    return json;
  }
}
