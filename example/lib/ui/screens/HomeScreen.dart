import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/ui/widgets/AbstractStatefulWidget.dart';

class HomeScreen extends AbstractAppScreen {
  static const String ROUTE = "/home";

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends AbstractAppScreenState<HomeScreen> {
  @override
  AppScreenStateOptions get options => AppScreenStateOptions.basic(
        screenName: HomeScreen.ROUTE,
        title: tt('home.screen.title'),
      );

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
  /// BodyWidget initialization
  _BodyWidget({Key? key}) : super(key: key);

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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Wip: This app will contain various examples to show usage of the CoreApp'),
            ],
          ),
        ),
      ),
    );
  }
}
