import 'package:example/model/sqlite_record.dart';
import 'package:example/model/sqlite_result.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SaveSQLiteRecordDataTask extends DataTask<SQLiteRecord, SQLiteResult> {
  /// SaveSQLiteRecordDataTask initialization
  SaveSQLiteRecordDataTask({
    required SQLiteRecord data,
  }) : super(
          method: SQLiteRecord.table,
          options: SQLiteTaskOptions(
            type: SQLiteType.save,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => SQLiteResult.fromJson(json),
          reFetchMethods: [SQLiteRecord.table],
        );
}
