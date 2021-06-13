import 'package:example/model/SQLiteRecord.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SQLiteRecordQuery extends DataModel {
  String? name;

  /// SQLiteRecordQuery initialization from JSON map
  SQLiteRecordQuery.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json['name'];
  }

  /// Covert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();

    if (name != null) {
      json['${SQLiteRecord.COL_NAME} LIKE ?'] = '%$name%';
    }

    return json;
  }
}
