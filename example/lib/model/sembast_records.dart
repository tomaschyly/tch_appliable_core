import 'package:example/model/sembast_record.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SembastRecords extends DataModel {
  static const String store = 'record';

  late List<SembastRecord> records;

  /// SembastRecords initialization from JSON map
  SembastRecords.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    final List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(json['list']);

    records = list.map((Map<String, dynamic> item) => SembastRecord.fromJson(item)).toList();
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'list': records.map((SembastRecord record) => record.toJson()).toList(),
    };

    return json;
  }
}
