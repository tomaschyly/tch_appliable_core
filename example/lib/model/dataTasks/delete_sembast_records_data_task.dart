import 'package:example/model/sembast_record.dart';
import 'package:example/model/sembast_record_query.dart';
import 'package:example/model/sembast_result.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class DeleteSembastRecordsDataTask extends DataTask<SembastRecordQuery, SembastResult> {
  /// DeleteSembastRecordsDataTask initialization
  DeleteSembastRecordsDataTask({
    required SembastRecordQuery data,
  }) : super(
          method: SembastRecord.store,
          options: SembastTaskOptions(
            type: SembastType.deleteWhere,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => SembastResult.fromJson(json),
          reFetchMethods: [SembastRecord.store],
        );
}
