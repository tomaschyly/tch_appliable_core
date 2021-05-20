import 'package:example/model/SembastRecords.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetSembastRecordsDataRequest extends DataRequest<SembastRecords> {
  /// GetSembastRecordsDataRequest initialization
  GetSembastRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.Sembast,
          method: SembastRecords.STORE,
          parameters: parameters,
          processResult: (json) => SembastRecords.fromJson(json),
        );
}
