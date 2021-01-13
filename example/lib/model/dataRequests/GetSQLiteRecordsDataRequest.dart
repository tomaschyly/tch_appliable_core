import 'package:example/model/SQLiteRecord.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetSQLiteRecordsDataRequest extends DataRequest<SQLiteRecord> {
  /// GetSQLiteRecordsDataRequest initialization
  GetSQLiteRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.SQLite,
          method: SQLiteRecord.TABLE,
          parameters: parameters,
          processResult: (json) => SQLiteRecord.fromJson(json),
        );
}
