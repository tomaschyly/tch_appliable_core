import 'package:example/model/SembastRecord.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SembastRecordQuery extends DataModel {
  String? name;

  /// SembastRecordQuery initialization from JSON map
  SembastRecordQuery.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json[SembastRecord.COL_NAME];
  }

  /// Covert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();

    if (name != null) {
      json['${SembastRecord.COL_NAME} LIKE'] = name;
    }

    return json;
  }
}
