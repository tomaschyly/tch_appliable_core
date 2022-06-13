import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/providers/MainDataProvider.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/DataRequest.dart';
import 'package:tch_appliable_core/utils/List.dart';

class MainDataSource {
  bool get disposed => _disposed;
  ValueNotifier<MainDataProviderSourceState> state = ValueNotifier(MainDataProviderSourceState.UnAvailable);
  ValueNotifier<List<DataRequest>> results;

  bool _disposed = false;
  final List<DataRequest> _dataRequests;

  /// MainDataSource initialization
  MainDataSource(this._dataRequests)
      : assert(_dataRequests.isNotEmpty),
        results = ValueNotifier(_dataRequests);

  /// Manually dispose of resources
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;

    /// Unless someone else adds an listener, they do not need to be disposed
    /// We use them on for ValueListenableBuilder & they remove their listeners
    // state.dispose();
    // results.dispose();
  }

  /// Get list of identifiers by DataRequests
  List<String> get identifiers => _dataRequests.map((dataRequest) => dataRequest.identifier).toList();

  /// Get list of sources by DataRequests
  List<MainDataProviderSource> get sources => _dataRequests.map((dataRequest) => dataRequest.source).toList();

  /// Get list of sources to which DataSource is actually registered
  List<MainDataProviderSource> get sourcesRegisteredTo => _dataRequests.map((dataRequest) => dataRequest.sourceRegisteredTo ?? dataRequest.source).toList();

  /// Get minDelayMilliseconds for Mockup
  int get mockupMinDelayMilliseconds {
    int minDelayMilliseconds = 0;

    _dataRequests.forEach((dataRequest) {
      final theMockUpRequestOptions = dataRequest.mockUpRequestOptions;

      if (theMockUpRequestOptions != null) {
        minDelayMilliseconds += theMockUpRequestOptions.minDelayMilliseconds;
      }
    });

    return minDelayMilliseconds;
  }

  /// Get minDelayMilliseconds for Mockup
  int get mockupMaxDelayMilliseconds {
    int maxDelayMilliseconds = 0;

    _dataRequests.forEach((dataRequest) {
      final theMockUpRequestOptions = dataRequest.mockUpRequestOptions;

      if (theMockUpRequestOptions != null) {
        maxDelayMilliseconds += theMockUpRequestOptions.maxDelayMilliseconds;
      }
    });

    return maxDelayMilliseconds;
  }

  /// Find DataRequest of this DataSource for method
  DataRequest? requestForMethod(String method) {
    return _dataRequests.firstWhereOrNull((dataRequest) => dataRequest.method == method);
  }

  /// Find DataRequest of this DataSource for identifier
  DataRequest? requestForIdentifier(String identifier) {
    return _dataRequests.firstWhereOrNull((dataRequest) => dataRequest.identifier == identifier);
  }

  /// Find result for identifier if possible
  dynamic resultForIdentifier(String identifier) {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      if (dataRequest.identifier == identifier) {
        return dataRequest.result;
      }
    }

    return null;
  }

  /// Set rawResult from response on request
  void setRawResult(
    String identifier,
    List<Map<String, dynamic>>? results, {
    bool lastHasNext = false,
  }) {
    _dataRequests.forEach((dataRequest) {
      if (dataRequest.identifier == identifier) {
        if (lastHasNext) {
          dataRequest.lastHasNextPageRawResults = results;
        } else {
          dataRequest.rawResults = results;
        }
      }
    });
  }

  /// Set response or already processed result from source as result
  void setResult(String identifier, Map<String, dynamic>? result, SourceException? exception) {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    dataRequests.forEach((dataRequest) {
      if (dataRequest.identifier == identifier) {
        dataRequest.result = result != null ? dataRequest.processResult(result) : null;
        dataRequest.error = exception;
      }
    });

    results.value = dataRequests;
  }

  /// Refetch data for DataRequests of this source
  Future<void> refetchData() async {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      dataRequest.result = null;
      dataRequest.error = null;
    }

    results.value = dataRequests;

    for (DataRequest dataRequest in dataRequests) {
      await MainDataProvider.instance!.reFetchData(dataRequest.source, identifiers: [dataRequest.identifier]);
    }
  }

  /// Check if DataRequest has next page
  /// ListDataWidget & pagination work with single DataRequest per MainDataSource
  Future<bool> hasNextPageOfRequest<R>() async {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      if (dataRequest is R) {
        return MainDataProvider.instance!.dataRequestHasNextPage(dataRequest);
      }
    }

    return false;
  }

  /// Request DataProvider to load next page of DataRequest
  /// ListDataWidget & pagination work with single DataRequest per MainDataSource
  requestNextPageOfRequest<R>() {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      if (dataRequest is R) {
        MainDataProvider.instance!.dataRequestLoadNextPage(dataRequest);
        break;
      }
    }
  }
}
