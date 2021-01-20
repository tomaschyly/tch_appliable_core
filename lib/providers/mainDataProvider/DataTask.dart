import 'package:http/http.dart';
import 'package:tch_appliable_core/model/DataModel.dart';

abstract class DataTaskOptions {}

class MockUpTaskOptions extends DataTaskOptions {}

enum HTTPType {
  Get,
  Post,
}

class HTTPTaskOptions extends DataTaskOptions {
  final HTTPType type;
  final Map<String, String>? headers;
  final Map<String, dynamic> Function(String body)? processBody;

  /// HTTPTaskOptions initialization
  HTTPTaskOptions({
    required this.type,
    this.headers,
    this.processBody,
  });
}

enum SQLiteType {
  Save,
  Delete,
}

class SQLiteTaskOptions extends DataTaskOptions {
  final SQLiteType type;
  final String idKey;

  /// SQLiteTaskOptions initialization
  SQLiteTaskOptions({
    required this.type,
    this.idKey = 'id',
  });
}

class DataTask<T extends DataModel, R extends DataModel> {
  final String method;
  final DataTaskOptions options;
  final DataModel data;
  final R Function(Map<String, dynamic> json) processResult;
  R? result;
  final List<String>? reFetchMethods;

  /// DataTask initialization
  DataTask({
    required this.method,
    required this.options,
    required this.data,
    required this.processResult,
    this.reFetchMethods,
  });
}
