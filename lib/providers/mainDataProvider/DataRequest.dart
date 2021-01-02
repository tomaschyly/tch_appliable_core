class DataRequest {
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

  final String method;
  final Map<String, dynamic> parameters;
  Map<String, dynamic>? result;

  /// DataRequest initialization
  DataRequest({
    required this.method,
    Map<String, dynamic>? parameters,
  }) : this.parameters = parameters ?? Map();
}
