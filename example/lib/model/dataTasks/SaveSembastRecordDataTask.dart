import 'package:example/model/SembastRecord.dart';
import 'package:example/model/SembastResult.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SaveSembastRecordDataTask extends DataTask<SembastRecord, SembastResult> {
  /// SaveSembastRecordDataTask initialization
  SaveSembastRecordDataTask({
    required SembastRecord data,
  }) : super(
          method: SembastRecord.STORE,
          options: SembastTaskOptions(
            type: SembastType.Save,
          ),
          data: data,
          processResult: (json) => SembastResult.fromJson(json),
          reFetchMethods: [SembastRecord.STORE],
        );
}
