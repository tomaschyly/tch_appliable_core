import 'package:example/ui/screens/abstract_app_screen.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class HomeScreen extends AbstractAppScreen {
  static const String route = '/home';

  const HomeScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends AbstractAppScreenState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    options = AppScreenStateOptions.drawer(
      screenName: HomeScreen.route,
      title: tt('home.screen.title'),
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
  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Wip: This app will contain various examples to show usage of the CoreApp'),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
