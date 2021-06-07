import 'package:tch_appliable_core/tch_appliable_core.dart';

class MockupLoginRequest extends DataModel {
  static const String STORE = 'user';

  String username;
  String password;

  /// MockupLoginRequest initialization
  MockupLoginRequest(this.username, this.password) : super.fromJson(Map());

  /// Covert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }
}
