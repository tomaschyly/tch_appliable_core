import 'package:tch_appliable_core/tch_appliable_core.dart';

class MockupUser extends DataModel {
  static const String STORE = 'user';

  int? id;
  late String name;

  /// MockupUser initialization from JSON map
  MockupUser.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    name = json['name'];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
