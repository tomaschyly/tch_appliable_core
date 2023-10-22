import 'package:tch_appliable_core/tch_appliable_core.dart';

class SembastRecord extends DataModel {
  static const String STORE = 'record';
  static const String COL_ID = 'id';
  static const String COL_NAME = 'name';
  static const String COL_DESCRIPTION = 'description';
  static const String COL_CREATED = 'created';

  int? id;
  late String name;
  late String description;
  late int created;

  /// SembastRecord initialization from JSON map
  SembastRecord.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json[COL_ID];
    name = json[COL_NAME] ?? '';
    description = json[COL_DESCRIPTION] ?? '';
    created = json[COL_CREATED];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      COL_NAME: name,
      COL_DESCRIPTION: description,
      COL_CREATED: created,
    };

    if (id != null) {
      json[COL_ID] = id;
    }

    return json;
  }
}
