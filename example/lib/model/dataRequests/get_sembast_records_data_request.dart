import 'package:example/model/sembast_records.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetSembastRecordsDataRequest extends DataRequest<SembastRecords> {
  /// GetSembastRecordsDataRequest initialization
  GetSembastRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.sembast,
          method: SembastRecords.store,
          parameters: parameters,
          processResult: (json) => SembastRecords.fromJson(json),
        );
}
