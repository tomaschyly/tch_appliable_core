import 'package:example/model/sembast_record.dart';
import 'package:example/model/sembast_result.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SaveSembastRecordDataTask extends DataTask<SembastRecord, SembastResult> {
  /// SaveSembastRecordDataTask initialization
  SaveSembastRecordDataTask({
    required SembastRecord data,
  }) : super(
          method: SembastRecord.store,
          options: SembastTaskOptions(
            type: SembastType.save,
          ),
          data: data,
          processResult: (json) => SembastResult.fromJson(json),
          reFetchMethods: [SembastRecord.store],
        );
}
