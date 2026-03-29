import 'package:tch_appliable_core/src/model/data_model.dart';
import 'package:tch_appliable_core/src/providers/main_data_provider.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/data_request.dart';

abstract class DataTaskOptions {
  /// DataTaskOptions initialization
  const DataTaskOptions();
}

enum HTTPType {
  get,
  post,
  delete,
}

enum HTTPPostDataFormat {
  formData,
  toJson,
}

class HTTPTaskOptions extends DataTaskOptions {
  final bool useDio;
  final HTTPType type;
  final HTTPPostDataFormat postDataFormat;
  final String? url;
  final Map<String, String>? headers;
  final Map<String, dynamic> Function(String body)? processBody;

  /// HTTPTaskOptions initialization
  const HTTPTaskOptions({
    this.useDio = true,
    required this.type,
    this.postDataFormat = HTTPPostDataFormat.formData,
    this.url,
    this.headers,
    this.processBody,
  });
}

enum SQLiteType {
  raw,
  query,
  save,
  delete,
  deleteWhere,
}

class SQLiteTaskOptions extends DataTaskOptions {
  final SQLiteType type;
  final String idKey;
  final String? rawQuery;
  final List<dynamic>? rawArguments;
  final String? groupBy;
  final String? having;
  final String? orderBy;

  /// SQLiteTaskOptions initialization
  const SQLiteTaskOptions({
    required this.type,
    this.idKey = 'id',
    this.rawQuery,
    this.rawArguments,
    this.groupBy,
    this.having,
    this.orderBy,
  });
}

enum SembastType {
  query,
  save,
  delete,
  deleteWhere,
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
  SourceException? error;
  final RequestPagination pagination;
  final List<String>? reFetchMethods;

  /// DataTask initialization
  DataTask({
    required this.method,
    required this.options,
    this.mockUpTaskOptions,
    required this.data,
    required this.processResult,
    this.reFetchMethods,
    RequestPagination? pagination,
  }) : pagination = pagination ?? RequestPagination();
}

enum MockUpType {
  query,
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
