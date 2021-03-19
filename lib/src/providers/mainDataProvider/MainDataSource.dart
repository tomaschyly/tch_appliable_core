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
  List<MainDataProviderSource> get sources => _dataRequests.map((dataReqeust) => dataReqeust.source).toList();

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

  /// Set response or already processed result from source as result
  void setResult(String identifier, Map<String, dynamic> result) {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    dataRequests.forEach((dataRequest) {
      if (dataRequest.identifier == identifier) {
        dataRequest.result = dataRequest.processResult(result);
      }
    });

    results.value = dataRequests;
  }

  /// Check if DataRequest has next page
  bool hasNextPageOfRequest<R>() {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      if (dataRequest is R) {
        // return CoreModule.instance.mainDataProvider.dataRequestHasNextPage(dataRequest); //TODO
      }
    }

    return false;
  }

  /// Request DataProvider to load next page of DataRequest
  requestNextPageOfRequest<R>() {
    final List<DataRequest> dataRequests = List.from(_dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      if (dataRequest is R) {
        // CoreModule.instance.mainDataProvider.dataRequestLoadNextPage(dataRequest); //TODO
        break;
      }
    }
  }
}
