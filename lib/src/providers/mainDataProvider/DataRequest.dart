import 'dart:convert';

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

  final MainDataProviderSource source;
  MainDataProviderSource? sourceRegisteredTo;
  final HTTPRequestOptions httpRequestOptions;
  final MockUpRequestOptions? mockUpRequestOptions;
  final SQLiteRequestOptions sqLiteRequestOptions;
  final String method;
  final Map<String, dynamic> parameters;
  dynamic rawResults;
  dynamic lastHasNextPageRawResults;
  final T? Function(Map<String, dynamic> json) processResult;
  T? result;
  SourceException? error;
  final RequestPagination pagination;

  /// DataRequest initialization
  DataRequest({
    required this.source,
    this.httpRequestOptions = const HTTPRequestOptions(),
    this.mockUpRequestOptions,
    this.sqLiteRequestOptions = const SQLiteRequestOptions(),
    required this.method,
    Map<String, dynamic>? parameters,
    required this.processResult,
    RequestPagination? pagination,
  })  : this.parameters = parameters ?? Map(),
        this.pagination = pagination ?? RequestPagination();
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

typedef ResultsNotEmpty = bool Function(dynamic results);
typedef ResultsCombination = dynamic Function(dynamic results, dynamic nextPageResults);

class RequestPagination {
  final int pageSize;
  int page;
  final bool enabled;
  final ResultsNotEmpty? checkResultNotEmpty;
  final ResultsCombination? combinePaginationResult;

  /// RequestPagination initialization
  RequestPagination({
    this.pageSize = 20,
    this.page = 1,
    this.enabled = true,
    this.checkResultNotEmpty,
    this.combinePaginationResult,
  });

  /// Create copy of this pagination with changes
  RequestPagination copyWith({
    int? pageSize,
    int? page,
    bool? enabled,
    ResultsNotEmpty? checkResultNotEmpty,
    ResultsCombination? combinePaginationResult,
  }) {
    return RequestPagination(
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
      enabled: enabled ?? this.enabled,
      checkResultNotEmpty: checkResultNotEmpty ?? this.checkResultNotEmpty,
      combinePaginationResult: combinePaginationResult ?? this.combinePaginationResult,
    );
  }
}

/// Generic function to check list is not empty
bool requestPaginationCheckList(dynamic results) {
  List<Map<String, dynamic>> resultsList = List<Map<String, dynamic>>.from(jsonDecode(results));

  return resultsList.isNotEmpty;
}

/// Generic function to combine two lists into one
dynamic requestPaginationCombineLists(dynamic results, dynamic nextPageResults) {
  List<Map<String, dynamic>> resultsList = List<Map<String, dynamic>>.from(jsonDecode(results)).toList();
  List<Map<String, dynamic>> nextList = List<Map<String, dynamic>>.from(jsonDecode(nextPageResults));

  resultsList.addAll(nextList);

  return jsonEncode(resultsList);
}
