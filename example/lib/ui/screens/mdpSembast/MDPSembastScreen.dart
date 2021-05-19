import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:example/ui/screens/mdpSembast/MDPSembastRecordScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSembastScreen extends AbstractAppScreen {
  static const String ROUTE = "/mdpsembast";

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSembastScreenState();
}

class _MDPSembastScreenState extends AbstractAppScreenState<MDPSembastScreen> {
  @override
  AbstractScreenStateOptions options = AppScreenStateOptions.drawer(
    screenName: MDPSembastScreen.ROUTE,
    title: tt('mdpsembast.screen.title'),
  )..appBarOptions = <AppBarOption>[
      AppBarOption(
        onTap: (BuildContext context) {
          pushNamed(context, MDPSembastRecordScreen.ROUTE);
        },
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    ];

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
    return Container();
  }
}
