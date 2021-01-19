import 'package:example/model/SQLiteRecords.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetSQLiteRecordsDataRequest extends DataRequest<SQLiteRecords> {
  /// GetSQLiteRecordsDataRequest initialization
  GetSQLiteRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.SQLite,
          method: SQLiteRecords.TABLE,
          parameters: parameters,
          processResult: (json) => SQLiteRecords.fromJson(json),
        );
}
