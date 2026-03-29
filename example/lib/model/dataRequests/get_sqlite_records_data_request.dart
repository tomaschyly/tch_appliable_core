import 'package:example/model/sqlite_records.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetSQLiteRecordsDataRequest extends DataRequest<SQLiteRecords> {
  /// GetSQLiteRecordsDataRequest initialization
  GetSQLiteRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.sqLite,
          method: SQLiteRecords.table,
          parameters: parameters,
          processResult: (json) => SQLiteRecords.fromJson(json),
        );
}
