import 'package:tch_appliable_core/tch_appliable_core.dart';

class HttpRecord extends DataModel {
  static const String METHOD = '/todos';

  late int userId;
  late int id;
  late String title;
  late bool completed;

  /// HttpRecord initialization from JSON map
  HttpRecord.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  /// Covert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
