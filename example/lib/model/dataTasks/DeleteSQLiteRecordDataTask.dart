import 'package:example/model/SQLiteRecord.dart';
import 'package:example/model/SQLiteResult.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class DeleteSQLiteRecordDataTask extends DataTask<SQLiteRecord, SQLiteResult> {
  /// DeleteSQLiteRecordDataTask initialization
  DeleteSQLiteRecordDataTask({
    required SQLiteRecord data,
  }) : super(
          method: SQLiteRecord.TABLE,
          options: SQLiteTaskOptions(
            type: SQLiteType.Delete,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => SQLiteResult.fromJson(json),
          reFetchMethods: [SQLiteRecord.TABLE],
        );
}
