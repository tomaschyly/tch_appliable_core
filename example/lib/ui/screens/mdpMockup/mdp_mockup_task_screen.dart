import 'package:example/model/mockup_login_request.dart';
import 'package:example/model/dataTasks/login_mockup_data_task.dart';
import 'package:example/ui/screens/abstract_app_screen.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPMockupTaskScreen extends AbstractAppScreen {
  static const String route = '/mdpmockup/task';

  const MDPMockupTaskScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPMockupTaskScreenState();
}

class _MDPMockupTaskScreenState extends AbstractAppScreenState<MDPMockupTaskScreen> {
  @override
  void initState() {
    super.initState();
    options = AppScreenStateOptions.basic(
      screenName: MDPMockupTaskScreen.route,
      title: tt('mdpmockuptask.screen.title'),
    );
  }

  @override
  Widget extraLargeDesktopScreen(BuildContext context) => _BodyWidget();

  @override
  Widget largeDesktopScreen(BuildContext context) => _BodyWidget();

  @override
  Widget largePhoneScreen(BuildContext context) => _BodyWidget();

  @override
  Widget smallDesktopScreen(BuildContext context) => _BodyWidget();

  @override
  Widget smallPhoneScreen(BuildContext context) => _BodyWidget();

  @override
  Widget tabletScreen(BuildContext context) => _BodyWidget();
}

class _BodyWidget extends AbstractStatefulWidget {
  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends AbstractStatefulWidgetState<_BodyWidget> {
  String? _mockupData;

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final theMockupdata = _mockupData;

    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: Text(tt('mdpmockuptask.screen.task')),
                    ),
                  ),
                  onTap: () {
                    _mockupLoginTask();
                  },
                ),
              ),
                if (theMockupdata != null) ...[
                  const SizedBox(height: 16),
                  Text(theMockupdata),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Use MockupSource to simulate login Task
  Future<void> _mockupLoginTask() async {
    FocusScope.of(context).unfocus();

    final LoginMockupDataTask result = await MainDataProvider.instance!.executeDataTask(
      LoginMockupDataTask(
        data: MockupLoginRequest('john.doe', 'pass12345'),
      ),
    );

    if (result.result != null) {
      setStateNotDisposed(() {
        _mockupData = 'Mockup user login for user ${result.result!.name}'; //TODO tt
      });
    }
  }
}
