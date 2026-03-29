import 'package:example/model/sqlite_record.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SQLiteRecordQuery extends DataModel {
  String? name;

  /// SQLiteRecordQuery initialization from JSON map
  SQLiteRecordQuery.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json[SQLiteRecord.colName];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) {
      json['${SQLiteRecord.colName} LIKE ?'] = '%$name%';
    }

    return json;
  }
}
