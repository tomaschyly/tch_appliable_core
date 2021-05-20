import 'package:example/model/SembastRecord.dart';
import 'package:example/model/SembastResult.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class DeleteSembastRecordDataTask extends DataTask<SembastRecord, SembastResult> {
  /// DeleteSembastRecordDataTask initialization
  DeleteSembastRecordDataTask({
    required SembastRecord data,
  }) : super(
          method: SembastRecord.STORE,
          options: SembastTaskOptions(
            type: SembastType.Delete,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => SembastResult.fromJson(json),
          reFetchMethods: [SembastRecord.STORE],
        );
}
