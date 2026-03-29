import 'package:example/model/sembast_records.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetMockupRecordsDataRequest extends DataRequest<SembastRecords> {
  /// GetMockupRecordsDataRequest initialization
  GetMockupRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.sembast,
          mockUpRequestOptions: MockUpRequestOptions(
            delayedResult: true,
          ),
          method: SembastRecords.store,
          parameters: parameters,
          processResult: (json) => SembastRecords.fromJson(json),
        );
}
