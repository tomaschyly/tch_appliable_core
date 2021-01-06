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
    Map<String, dynamic>? data,
  }) : this.data = data ?? Map();
}
