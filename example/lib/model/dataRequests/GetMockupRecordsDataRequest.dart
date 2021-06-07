import 'package:example/model/SembastRecords.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetMockupRecordsDataRequest extends DataRequest<SembastRecords> {
  /// GetMockupRecordsDataRequest initialization
  GetMockupRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.Sembast,
          mockUpRequestOptions: MockUpRequestOptions(
            delayedResult: true,
          ),
          method: SembastRecords.STORE,
          parameters: parameters,
          processResult: (json) => SembastRecords.fromJson(json),
        );
}
