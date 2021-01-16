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

  /// HTTPTaskOptions initialization
  HTTPTaskOptions({
    required this.type,
    this.headers,
  });
}

class SQLiteTaskOptions extends DataTaskOptions {}

class DataTask {
  final DataTaskOptions options;
  final Map<String, dynamic> data;
  final List<String>? reFetchMethods;

  /// DataTask initialization
  DataTask({
    required this.options,
    DataModel? data,
    this.reFetchMethods,
  }) : this.data = data?.toJson() ?? Map();
}
