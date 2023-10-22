import 'package:example/model/SQLiteRecord.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SQLiteRecords extends DataModel {
  static const String TABLE = 'record';

  late List<SQLiteRecord> records;

  /// SQLiteRecords initialization from JSON map
  SQLiteRecords.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(json['list']);

    records = list.map((Map<String, dynamic> item) => SQLiteRecord.fromJson(item)).toList();
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'list': records.map((SQLiteRecord record) => record.toJson()).toList(),
    };

    return json;
  }
}
