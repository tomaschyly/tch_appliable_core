import 'package:example/model/MockupLoginRequest.dart';
import 'package:example/model/MockupUser.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class LoginMockupDataTask extends DataTask<MockupLoginRequest, MockupUser> {
  /// LoginMockupDataTask initialization
  LoginMockupDataTask({
    required MockupLoginRequest data,
  }) : super(
          method: MockupLoginRequest.STORE,
          options: SembastTaskOptions(
            type: SembastType.Query,
          ),
          mockUpTaskOptions: MockUpTaskOptions(
            type: MockUpType.Query,
          ),
          data: data,
          processResult: (Map<String, dynamic> json) => MockupUser.fromJson(json),
          reFetchMethods: [MockupLoginRequest.STORE],
        );
}
