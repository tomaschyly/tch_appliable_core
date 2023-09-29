import 'package:tch_appliable_core/tch_appliable_core.dart';

class ResponsiveWidget extends StatelessWidget {
  // Default child widget
  final Widget child;
  // View layout from widgets for phone screens (< 576px)
  final Widget? smallPhoneScreen;
  // View layout from widgets for phone screens (> 576px)
  final Widget? largePhoneScreen;
  // View layout from widgets for tablet screens (> 768px)
  final Widget? tabletScreen;
  // View layout from widgets for desktop screens (> 992px)
  final Widget? smallDesktopScreen;
  // View layout from widgets for desktop screens (> 1200px)
  final Widget? largeDesktopScreen;
  // View layout from widgets for desktop screens (> 1500px)
  final Widget? extraLargeDesktopScreen;

  /// ResponsiveWidget initialization
  ResponsiveWidget({
    Key? key,
    required this.child,
    this.smallPhoneScreen,
    this.largePhoneScreen,
    this.tabletScreen,
    this.smallDesktopScreen,
    this.largeDesktopScreen,
    this.extraLargeDesktopScreen,
  }) : super(key: key);

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final AbstractAppDataStateSnapshot? snapshot = AppDataState.of(context);

    ResponsiveScreen? responsiveScreen = snapshot?.responsiveScreen;

    if (responsiveScreen == null) {
      responsiveScreen = determineResponsiveScreen(context);
    }

    switch (responsiveScreen) {
      case ResponsiveScreen.ExtraLargeDesktop:
        return extraLargeDesktopScreen ?? largeDesktopScreen ?? smallDesktopScreen ?? tabletScreen ?? largePhoneScreen ?? smallPhoneScreen ?? child;
      case ResponsiveScreen.LargeDesktop:
        return largeDesktopScreen ?? smallDesktopScreen ?? tabletScreen ?? largePhoneScreen ?? smallPhoneScreen ?? child;
      case ResponsiveScreen.SmallDesktop:
        return smallDesktopScreen ?? tabletScreen ?? largePhoneScreen ?? smallPhoneScreen ?? child;
      case ResponsiveScreen.Tablet:
        return tabletScreen ?? largePhoneScreen ?? smallPhoneScreen ?? child;
      case ResponsiveScreen.LargePhone:
        return largePhoneScreen ?? smallPhoneScreen ?? child;
      case ResponsiveScreen.SmallPhone:
        return smallPhoneScreen ?? child;
      case ResponsiveScreen.UnDetermined:
      default:
        return child;
    }
  }
}
