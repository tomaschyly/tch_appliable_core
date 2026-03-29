import 'package:example/model/sembast_record.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SembastRecordQuery extends DataModel {
  String? name;

  /// SembastRecordQuery initialization from JSON map
  SembastRecordQuery.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json[SembastRecord.colName];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (name != null) {
      json['${SembastRecord.colName} LIKE'] = name;
    }

    return json;
  }
}
