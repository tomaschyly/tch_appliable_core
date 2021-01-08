import 'package:tch_appliable_core/model/DataModel.dart';

abstract class DataTaskOptions {}

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

  /// DataTask initialization
  DataTask({
    required this.options,
    DataModel? data,
  }) : this.data = data?.toJson() ?? Map();
}