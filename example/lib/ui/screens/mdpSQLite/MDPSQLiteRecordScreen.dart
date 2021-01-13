import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSQLiteRecordScreen extends AbstractAppScreen {
  static const String ROUTE = "/mdpsqlite/record";

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSQLiteRecordScreenState();
}

class _MDPSQLiteRecordScreenState extends AbstractAppScreenState<MDPSQLiteRecordScreen> {
  @override
  AppScreenStateOptions get options => AppScreenStateOptions.basic(
        screenName: MDPSQLiteRecordScreen.ROUTE,
        title: tt('mdpsqliterecord.screen.title'),
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
              Text('Wip: MainDataProvider SQLlite example create record'),
            ],
          ),
        ),
      ),
    );
  }
}
