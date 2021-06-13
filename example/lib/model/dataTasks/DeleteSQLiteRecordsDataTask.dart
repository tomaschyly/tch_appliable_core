import 'package:example/model/SQLiteRecord.dart';
import 'package:example/model/SQLiteRecordQuery.dart';
import 'package:example/model/SQLiteResult.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class DeleteSQLiteRecordsDataTask extends DataTask<SQLiteRecordQuery, SQLiteResult> {
  /// DeleteSQLiteRecordsDataTask initialization
  DeleteSQLiteRecordsDataTask({
    required SQLiteRecordQuery data,
  }) : super(
          method: SQLiteRecord.TABLE,
          options: SQLiteTaskOptions(
            type: SQLiteType.DeleteWhere,
          ),
          data: data,
          processResult: (json) => SQLiteResult.fromJson(json),
          reFetchMethods: [SQLiteRecord.TABLE],
        );
}
