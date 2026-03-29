import 'package:example/model/sqlite_record.dart';
import 'package:example/model/sqlite_result.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class DeleteSQLiteRecordDataTask extends DataTask<SQLiteRecord, SQLiteResult> {
  /// DeleteSQLiteRecordDataTask initialization
  DeleteSQLiteRecordDataTask({
    required SQLiteRecord data,
  }) : super(
          method: SQLiteRecord.table,
          options: SQLiteTaskOptions(
            type: SQLiteType.delete,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => SQLiteResult.fromJson(json),
          reFetchMethods: [SQLiteRecord.table],
        );
}
