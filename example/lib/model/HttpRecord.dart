import 'package:tch_appliable_core/tch_appliable_core.dart';

class HttpRecord extends DataModel {
  static const String METHOD = '/Person';

  late String id;
  late String name;
  late String avatar;
  late String createdAt;

  /// HttpRecord initialization from JSON map
  HttpRecord.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    createdAt = json['createdAt'];
  }

  /// Covert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'createdAt': createdAt,
    };
  }
}
