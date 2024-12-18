import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/core/router_v1.dart';
import 'package:tch_appliable_core/src/ui/widgets/abstract_stateful_widget.dart';
import 'package:tch_appliable_core/src/ui/widgets/screen_messenger_widget.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class AbstractScreenOptions {
  String screenName;
  bool canPop;
  String title;
  SafeAreaOptions safeArea;
  bool extendBodyBehindAppBar;

  /// Callback used to preProcess options at the start of each build
  /// May be used to change options based on some conditions
  void Function(BuildContext context)? optionsBuildPreProcessor;
  List<AppBarOption>? appBarOptions;
  List<BottomBarOption>? bottomBarOptions;
  List<DrawerOption>? drawerOptions;
  bool drawerIsPermanentlyVisible;

  /// AbstractScreenOptions initialization for default state
  AbstractScreenOptions.basic({
    required this.screenName,
    this.canPop = false,
    required this.title,
    this.safeArea = const SafeAreaOptions(
      top: false,
      left: true,
      right: true,
      bottom: true,
    ),
    this.extendBodyBehindAppBar = false,
    this.drawerIsPermanentlyVisible = false,
  });
}

class SafeAreaOptions {
  final bool top;
  final bool left;
  final bool right;
  final bool bottom;

  /// SafeAreaOptions initialization
  const SafeAreaOptions({
    required this.top,
    required this.left,
    required this.right,
    required this.bottom,
  });
}

abstract class AbstractScreen extends AbstractStatefulWidget {
  /// AbstractScreen initialization
  AbstractScreen({super.key});
}

abstract class AbstractScreenState<T extends AbstractScreen> extends AbstractStatefulWidgetState<T> with RouteAware {
  @protected
  bool get isCurrent => _isCurrent;
  @protected
  Color? backgroundColor;

  @protected
  late AbstractScreenOptions options;
  @protected
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  bool _isCurrent = false;
  final GlobalKey<ScreenMessengerWidgetState> _messengerKey = GlobalKey();
  final List<String> _loadingTags = [];

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
    final snapshot = context.appDataStateOrNull;

    final theOptionsBuildPreProcessor = options.optionsBuildPreProcessor;
    if (theOptionsBuildPreProcessor != null) {
      theOptionsBuildPreProcessor(context);
    }

    if (widgetState == StatefulWidgetState.NotInitialized) {
      firstBuildOnly(context);
    }

    if (snapshot != null) {
      if (!snapshot.isForeground) {
        wasBackground = true;

        onBackground(context);
      } else if (wasBackground) {
        wasBackground = false;

        onForeground(context);
      }
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (BuildContext context, bool value, Widget? child) {
        Widget theContent = buildContent(context);
        if (options.safeArea.top || options.safeArea.left || options.safeArea.right || options.safeArea.bottom) {
          theContent = SafeArea(
            top: options.safeArea.top,
            left: options.safeArea.left,
            right: options.safeArea.right,
            bottom: options.safeArea.bottom,
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

        return ScreenDataState(
          child: Scaffold(
            extendBodyBehindAppBar: options.extendBodyBehindAppBar,
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
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
          ),
          isLoading: isLoading.value,
          loadingTags: _loadingTags,
          executeAsyncTaskCallback: executeAsyncTask,
          loading: isLoading,
        );
      },
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
  void screenMessage(BuildContext context, ScreenMessage message) {
    Future.delayed(kThemeAnimationDuration, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.message,
            textAlign: TextAlign.center,
          ),
          duration: message.duration,
        ),
      );
    });
  }

  /// This screen is now the top Route after it has been pushed
  @override
  void didPush() {
    super.didPush();

    _isCurrent = true;

    onStartResume();
  }

  /// This screen is now the top Route after return back to this Route from next ones
  @override
  void didPopNext() {
    super.didPopNext();

    _isCurrent = true;

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

  /// Called when a new route has been pushed, and the current route is no longer visible
  @override
  void didPushNext() {
    super.didPushNext();

    _isCurrent = false;
  }

  /// Execute any asynchronous Task that needs to display loading state
  @protected
  Future<void> executeAsyncTask(
    Future<void> Function() task, {
    String? tag,
    List<String>? tags,
  }) async {
    _loadingTags.clear();

    if (tag != null) {
      _loadingTags.add(tag);
    }

    if (tags != null) {
      _loadingTags.addAll(tags);
    }

    isLoading.value = true;

    await task();

    isLoading.value = false;
  }
}

typedef ExecuteAsyncTaskCallback = Future<void> Function(
  Future<void> Function() task, {
  String? tag,
  List<String>? tags,
});

/// Shorthand to get ScreenDataState from context
ScreenDataState getScreenDataState(BuildContext context) => ScreenDataState.of<ScreenDataState>(context)!;

/// Set loading state on parent AbstractScreenState
void setScreenStateLoadingState(BuildContext context, bool loading) {
  final state = getScreenDataState(context);

  state.loading.value = loading;
}

class ScreenDataState extends InheritedWidget {
  final bool isLoading;
  final List<String> loadingTags;
  final ExecuteAsyncTaskCallback executeAsyncTaskCallback;
  final ValueNotifier<bool> loading;

  /// ScreenDataState initialization
  ScreenDataState({
    required Widget child,
    required this.isLoading,
    required this.loadingTags,
    required this.executeAsyncTaskCallback,
    required this.loading,
  }) : super(child: child);

  /// Access current ScreenDataState anywhere from BuildContext
  static T? of<T extends ScreenDataState>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<T>();
  }

  /// Disable update notifications
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

class AppBarOption {
  final Function(BuildContext context)? onTap;
  final Widget? icon;
  final Widget? complexIcon;
  final Widget? button;
  final String? svgAssetPath;

  /// AppBarOption initialization
  AppBarOption({
    required this.onTap,
    required this.icon,
    this.complexIcon,
    this.button,
    this.svgAssetPath,
  }) : assert(icon != null || complexIcon != null || button != null || svgAssetPath != null);
}

class BottomBarOption {
  final Function(BuildContext context) onSelect;
  final bool Function(BuildContext context) isSelected;
  final Widget? title;
  final WidgetBuilder? titleBuilder;
  final Widget? icon;
  final String? svgAssetPath;

  /// BottomBarOption initialization
  BottomBarOption({
    required this.onSelect,
    required this.isSelected,
    this.title,
    this.titleBuilder,
    this.icon,
    this.svgAssetPath,
  }) : assert(title != null || titleBuilder != null);
}

class DrawerOption {
  final Function(BuildContext context) onSelect;
  final bool Function(BuildContext context) isSelected;
  final Widget? title;
  final WidgetBuilder? titleBuilder;
  final Widget? icon;
  final String? svgAssetPath;

  /// DrawerOption initialization
  DrawerOption({
    required this.onSelect,
    required this.isSelected,
    this.title,
    this.titleBuilder,
    this.icon,
    this.svgAssetPath,
  }) : assert(title != null || titleBuilder != null);
}
