import 'package:tch_appliable_core/model/DataModel.dart';
import 'package:tch_appliable_core/providers/MainDataProvider.dart';

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
  final String method;
  final Map<String, dynamic> parameters;
  final T Function(Map<String, dynamic> json) processResult;
  T? result;

  /// DataRequest initialization
  DataRequest({
    required this.source,
    required this.method,
    Map<String, dynamic>? parameters,
    required this.processResult,
  }) : this.parameters = parameters ?? Map();
}
