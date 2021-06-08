import 'package:tch_appliable_core/src/model/DataModel.dart';

abstract class DataTaskOptions {
  /// DataTaskOptions initialization
  const DataTaskOptions();
}

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
  const HTTPTaskOptions({
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
  const SQLiteTaskOptions({
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
  final String idKey;

  /// SembastTaskOptions initialization
  const SembastTaskOptions({
    required this.type,
    this.idKey = 'id',
  });
}

class DataTask<T extends DataModel, R extends DataModel> {
  final String method;
  final DataTaskOptions options;
  final MockUpTaskOptions? mockUpTaskOptions;
  final DataModel data;
  final R? Function(Map<String, dynamic> json) processResult;
  R? result;
  final List<String>? reFetchMethods;

  /// DataTask initialization
  DataTask({
    required this.method,
    required this.options,
    this.mockUpTaskOptions,
    required this.data,
    required this.processResult,
    this.reFetchMethods,
  });
}

enum MockUpType {
  Query,
}

class MockUpTaskOptions {
  final MockUpType type;
  final bool delayedResult;
  final int minDelayMilliseconds;
  final int maxDelayMilliseconds;
  final String? assetDataPath;

  /// MockUpTaskOptions initialization
  const MockUpTaskOptions({
    required this.type,
    this.delayedResult = false,
    this.minDelayMilliseconds = 200,
    this.maxDelayMilliseconds = 2000,
    this.assetDataPath,
  });
}
