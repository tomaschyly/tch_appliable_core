import 'package:tch_appliable_core/tch_appliable_core.dart';

class SQLiteResult extends DataModel {
  int? id;
  int? deleted;

  /// SQLiteResult initialization from JSON map
  SQLiteResult.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    deleted = json['deleted'];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'deleted': deleted,
    };

    return json;
  }
}
