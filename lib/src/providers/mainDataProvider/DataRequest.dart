import 'package:tch_appliable_core/src/model/DataModel.dart';
import 'package:tch_appliable_core/src/providers/MainDataProvider.dart';

class DataRequest<T extends DataModel> {
  String get identifier {
    String identifier = method;

    if (parameters.isNotEmpty) {
      for (String key in parameters.keys) {
        identifier += '_${key}_${parameters[key]}';
      }
    }

    return identifier;
  }

  bool get isCollection => true;

  final MainDataProviderSource source;
  MainDataProviderSource? sourceRegisteredTo;
  final HTTPRequestOptions httpRequestOptions;
  final MockUpRequestOptions? mockUpRequestOptions;
  final SQLiteRequestOptions sqLiteRequestOptions;
  final String method;
  final Map<String, dynamic> parameters;
  final T? Function(Map<String, dynamic> json) processResult;
  T? result;
  SourceException? error;

  /// DataRequest initialization
  DataRequest({
    required this.source,
    this.httpRequestOptions = const HTTPRequestOptions(),
    this.mockUpRequestOptions,
    this.sqLiteRequestOptions = const SQLiteRequestOptions(),
    required this.method,
    Map<String, dynamic>? parameters,
    required this.processResult,
  }) : this.parameters = parameters ?? Map();
}

class HTTPRequestOptions {
  final bool useDio;

  /// HTTPRequestOptions initialization
  const HTTPRequestOptions({
    this.useDio = true,
  });
}

class MockUpRequestOptions {
  final bool delayedResult;
  final int minDelayMilliseconds;
  final int maxDelayMilliseconds;
  final String? assetDataPath;

  /// MockUpRequestOptions initialization
  const MockUpRequestOptions({
    this.delayedResult = false,
    this.minDelayMilliseconds = 200,
    this.maxDelayMilliseconds = 2000,
    this.assetDataPath,
  });
}

class SQLiteRequestOptions {
  final String? groupBy;
  final String? having;
  final String? orderBy;

  /// SQLiteRequestOptions initialization
  const SQLiteRequestOptions({
    this.groupBy,
    this.having,
    this.orderBy,
  });
}
