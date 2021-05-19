import 'package:tch_appliable_core/src/model/DataModel.dart';

abstract class DataTaskOptions {}

class MockUpTaskOptions extends DataTaskOptions {}

enum HTTPType {
  Get,
  Post,
}

class HTTPTaskOptions extends DataTaskOptions {
  final HTTPType type;
  final String? url;
  final Map<String, String>? headers;
  final Map<String, dynamic> Function(String body)? processBody;

  /// HTTPTaskOptions initialization
  HTTPTaskOptions({
    required this.type,
    this.url,
    this.headers,
    this.processBody,
  });
}

enum SQLiteType {
  Raw,
  Query,
  Save,
  Delete,
}

class SQLiteTaskOptions extends DataTaskOptions {
  final SQLiteType type;
  final String idKey;
  final String? rawQuery;
  final List<dynamic>? rawArguments;

  /// SQLiteTaskOptions initialization
  SQLiteTaskOptions({
    required this.type,
    this.idKey = 'id',
    this.rawQuery,
    this.rawArguments,
  });
}

enum SembastType {
  Query,
  Save,
  Delete,
}

class SembastTaskOptions extends DataTaskOptions {
  final SembastType type;

  /// SembastTaskOptions initialization
  SembastTaskOptions({
    required this.type,
  });
}

class DataTask<T extends DataModel, R extends DataModel> {
  final String method;
  final DataTaskOptions options;
  final DataModel data;
  final R? Function(Map<String, dynamic> json) processResult;
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
