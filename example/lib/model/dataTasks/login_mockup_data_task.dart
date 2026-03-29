import 'package:example/model/mockup_login_request.dart';
import 'package:example/model/mockup_user.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class LoginMockupDataTask extends DataTask<MockupLoginRequest, MockupUser> {
  /// LoginMockupDataTask initialization
  LoginMockupDataTask({
    required MockupLoginRequest data,
  }) : super(
          method: MockupLoginRequest.store,
          options: SembastTaskOptions(
            type: SembastType.query,
          ),
          mockUpTaskOptions: MockUpTaskOptions(
            type: MockUpType.query,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => MockupUser.fromJson(json),
          reFetchMethods: [MockupLoginRequest.store],
        );
}
