import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/core/core_app.dart';
import 'package:tch_appliable_core/src/ui/screens/abstract_screen.dart';
import 'package:tch_appliable_core/src/ui/widgets/abstract_responsive_widget.dart';

abstract class AbstractResponsiveScreen extends AbstractScreen {}

abstract class AbstractResponsiveScreenState<T extends AbstractResponsiveScreen> extends AbstractScreenState<T> {
  /// Create view layout from widgets for phone screens (< 576px)
  @protected
  Widget smallPhoneScreen(BuildContext context);

  /// Create view layout from widgets for phone screens (> 576px)
  @protected
  Widget largePhoneScreen(BuildContext context);

  /// Create view layout from widgets for tablet screens (> 768px)
  @protected
  Widget tabletScreen(BuildContext context);

  /// Create view layout from widgets for desktop screens (> 992px)
  @protected
  Widget smallDesktopScreen(BuildContext context);

  /// Create view layout from widgets for desktop screens (> 1200px)
  @protected
  Widget largeDesktopScreen(BuildContext context);

  /// Create view layout from widgets for desktop screens (> 1500px)
  @protected
  Widget extraLargeDesktopScreen(BuildContext context);

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final AbstractAppDataStateSnapshot? snapshot = AppDataState.of(context);

    if (snapshot != null) {
      switch (snapshot.responsiveScreen) {
        case ResponsiveScreen.extraLargeDesktop:
          return extraLargeDesktopScreen(context);
        case ResponsiveScreen.largeDesktop:
          return largeDesktopScreen(context);
        case ResponsiveScreen.smallDesktop:
          return smallDesktopScreen(context);
        case ResponsiveScreen.tablet:
          return tabletScreen(context);
        case ResponsiveScreen.largePhone:
          return largePhoneScreen(context);
        case ResponsiveScreen.smallPhone:
        case ResponsiveScreen.unDetermined:
          return smallPhoneScreen(context);
      }
    }

    return smallPhoneScreen(context);
  }
}
