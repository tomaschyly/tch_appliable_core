import 'package:flutter/material.dart';
import 'package:tch_appliable_core/core/RouterV1.dart';
import 'package:tch_appliable_core/ui/widgets/AbstractStatefulWidget.dart';

class AbstractScreenStateOptions {
  String screenName;
  String title;
  bool safeArea;
  List<AppBarOption>? appBarOptions;
  List<BottomBarOption>? bottomBarOptions;
  List<DrawerOption>? drawerOptions;

  /// AbstractScreenStateOptions initialization for default state
  AbstractScreenStateOptions.basic({
    required this.screenName,
    required this.title,
    this.safeArea = true,
  });
}

abstract class AbstractScreen extends AbstractStatefulWidget {}

abstract class AbstractScreenState<T extends AbstractScreen> extends AbstractStatefulWidgetState<T> with RouteAware {
  @protected
  AbstractScreenStateOptions get options;
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
    if (widgetState == WidgetState.NotInitialized) {
      firstBuildOnly(context);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: createAppBar(context),
      body: Builder(
        builder: (BuildContext context) {
          return options.safeArea
              ? SafeArea(
                  top: false,
                  child: buildContent(context),
                )
              : buildContent(context);
        },
      ),
      bottomNavigationBar: createBottomBar(context),
      drawer: createDrawer(context),
    );
  }

  /// Create default AppBar
  @protected
  AppBar? createAppBar(BuildContext context);

  /// Create default BottomNavigationBar
  @protected
  BottomNavigationBar? createBottomBar(BuildContext context);

  /// Create default Drawer
  @protected
  Drawer? createDrawer(BuildContext context);

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
  }

  /// This screen is now the top Route
  @protected
  void onStartResume() {}
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
