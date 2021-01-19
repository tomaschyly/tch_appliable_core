import 'package:example/model/SQLiteRecord.dart';
import 'package:example/model/SQLiteResult.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SaveSQLiteRecordDataTask extends DataTask<SQLiteRecord, SQLiteResult> {
  /// SaveSQLiteRecordDataTask initialization
  SaveSQLiteRecordDataTask({
    required SQLiteRecord data,
  }) : super(
          method: SQLiteRecord.TABLE,
          options: SQLiteTaskOptions(
            type: SQLiteType.Save,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => SQLiteResult.fromJson(json),
          reFetchMethods: [SQLiteRecord.TABLE],
        );
}
