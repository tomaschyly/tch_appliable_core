import 'package:example/model/sqlite_record.dart';
import 'package:example/model/sqlite_record_query.dart';
import 'package:example/model/sqlite_result.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class DeleteSQLiteRecordsDataTask extends DataTask<SQLiteRecordQuery, SQLiteResult> {
  /// DeleteSQLiteRecordsDataTask initialization
  DeleteSQLiteRecordsDataTask({
    required SQLiteRecordQuery data,
  }) : super(
          method: SQLiteRecord.table,
          options: SQLiteTaskOptions(
            type: SQLiteType.deleteWhere,
          ),
          data: data,
          processResult: (json) => SQLiteResult.fromJson(json),
          reFetchMethods: [SQLiteRecord.table],
        );
}
