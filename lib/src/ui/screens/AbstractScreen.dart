import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/core/RouterV1.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractStatefulWidget.dart';
import 'package:tch_appliable_core/src/ui/widgets/ScreenMessengerWidget.dart';

class AbstractScreenStateOptions {
  String screenName;
  String title;
  bool safeArea;

  /// Callback used to preProcess options at the start of each build
  /// May be used to change options based on some conditions
  void Function(BuildContext context)? optionsBuildPreProcessor;
  List<AppBarOption>? appBarOptions;
  List<BottomBarOption>? bottomBarOptions;
  List<DrawerOption>? drawerOptions;
  bool drawerIsPermanentlyVisible;

  /// AbstractScreenStateOptions initialization for default state
  AbstractScreenStateOptions.basic({
    required this.screenName,
    required this.title,
    this.safeArea = true,
    this.drawerIsPermanentlyVisible = false,
  });
}

abstract class AbstractScreen extends AbstractStatefulWidget {}

abstract class AbstractScreenState<T extends AbstractScreen> extends AbstractStatefulWidgetState<T> with RouteAware {
  @protected
  late AbstractScreenStateOptions options;

  final GlobalKey<ScreenMessengerWidgetState> _messengerKey = GlobalKey();

  /// Manually dispose of resources
  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  /// Run initializations of screen on first build only
  @override
  firstBuildOnly(BuildContext context) {
    super.firstBuildOnly(context);

    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute as PageRoute);
    }
  }

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final theOptionsBuildPreProcessor = options.optionsBuildPreProcessor;
    if (theOptionsBuildPreProcessor != null) {
      theOptionsBuildPreProcessor(context);
    }

    if (widgetState == WidgetState.NotInitialized) {
      firstBuildOnly(context);
    }

    Widget theContent = buildContent(context);
    if (options.safeArea) {
      theContent = SafeArea(
        top: false,
        child: theContent,
      );
    }

    final Widget? theDrawer = createDrawer(context);
    if (options.drawerIsPermanentlyVisible && theDrawer != null) {
      theContent = Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            theDrawer,
            Expanded(child: theContent),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: createAppBar(context),
      body: Builder(
        builder: (BuildContext context) {
          return ScreenMessengerWidget(
            key: _messengerKey,
            options: options,
            displayMessage: screenMessage,
            child: theContent,
          );
        },
      ),
      bottomNavigationBar: createBottomBar(context),
      drawer: !options.drawerIsPermanentlyVisible ? theDrawer : null,
      floatingActionButton: createFloatingActionButton(context),
      floatingActionButtonAnimator: setFloatingActionButtonAnimator(context),
      floatingActionButtonLocation: setFloatingActionButtonLocation(context),
    );
  }

  /// Create default AppBar
  @protected
  PreferredSizeWidget? createAppBar(BuildContext context);

  /// Create default BottomNavigationBar
  @protected
  Widget? createBottomBar(BuildContext context);

  /// Create default Drawer
  @protected
  Widget? createDrawer(BuildContext context);

  /// Create floating action button for screen
  @protected
  Widget? createFloatingActionButton(BuildContext context) => null;

  /// Set animator for floating action button
  @protected
  FloatingActionButtonAnimator? setFloatingActionButtonAnimator(BuildContext context) => null;

  /// Set location of floating action button
  @protected
  FloatingActionButtonLocation? setFloatingActionButtonLocation(BuildContext context) => null;

  /// If available show message for this screen
  @protected
  void screenMessage(BuildContext context, String message) {
    Future.delayed(kThemeAnimationDuration, () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ));
    });
  }

  /// This screen is now the top Route after it has been pushed
  @override
  void didPush() {
    super.didPush();

    onStartResume();
  }

  /// This screen is now the top Route after return back to this Route from next ones
  @override
  void didPopNext() {
    super.didPopNext();

    onStartResume();
    onResume();
  }

  /// This screen is now the top Route
  @protected
  void onStartResume() {}

  /// This screen is now the top Route
  @protected
  void onResume() {
    _messengerKey.currentState?.onResume();
  }
}

class AppBarOption {
  final Function(BuildContext context) onTap;
  final Widget? icon;
  final Widget? complexIcon;

  /// AppBarOption initialization
  AppBarOption({
    required this.onTap,
    required this.icon,
    this.complexIcon,
  }) : assert(icon != null || complexIcon != null);
}

class BottomBarOption {
  final Function(BuildContext context) onSelect;
  final bool Function(BuildContext context) isSelected;
  final Widget title;
  final Widget? icon;

  /// BottomBarOption initialization
  BottomBarOption({
    required this.onSelect,
    required this.isSelected,
    required this.title,
    this.icon,
  });
}

class DrawerOption {
  final Function(BuildContext context) onSelect;
  final bool Function(BuildContext context) isSelected;
  final Widget title;
  final Widget? icon;

  /// DrawerOption initialization
  DrawerOption({
    required this.onSelect,
    required this.isSelected,
    required this.title,
    this.icon,
  });
}
