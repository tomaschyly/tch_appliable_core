import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tch_appliable_core/src/core/Preferences.dart';
import 'package:tch_appliable_core/src/core/RouterV1.dart';
import 'package:tch_appliable_core/src/core/Translator.dart';
import 'package:tch_appliable_core/src/providers/MainDataProvider.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractResponsiveWidget.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractStatefulWidget.dart';

class CoreApp extends AbstractStatefulWidget {
  final String title;
  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final Future<void> Function(BuildContext context)? onAppInitStart;
  final Future<void> Function(BuildContext context)? onAppInitEnd;
  final String initialScreenRoute;
  final RouteFactory onGenerateRoute;
  final AbstractAppDataStateSnapshot snapshot;
  final List<NavigatorObserver>? navigatorObservers;
  final ThemeData? theme;
  final TranslatorOptions? translatorOptions;
  final PreferencesOptions? preferencesOptions;
  final MainDataProviderOptions? mainDataProviderOptions;

  /// CoreApp initialization
  CoreApp({
    required this.title,
    required this.initializationUi,
    this.initializationMinDurationInMilliseconds = 0,
    this.onAppInitStart,
    this.onAppInitEnd,
    required this.initialScreenRoute,
    required this.onGenerateRoute,
    required this.snapshot,
    this.navigatorObservers,
    this.theme,
    this.translatorOptions,
    this.preferencesOptions,
    this.mainDataProviderOptions,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => CoreAppState();
}

class CoreAppState extends AbstractStatefulWidgetState<CoreApp> {
  static CoreAppState get instance => _instance;

  static late CoreAppState _instance;

  ResponsiveScreen _responsiveScreen = ResponsiveScreen.UnDetermined;
  final Map<String, List<String>> _messages = Map();

  /// State initialization
  @override
  void initState() {
    _instance = this;

    super.initState();
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final theNavigatorObservers = widget.navigatorObservers;
    final theTranslatorOptions = widget.translatorOptions;

    return AppDataState(
      child: MaterialApp(
        title: widget.title,
        home: _InitializationScreen(
          initializationUi: widget.initializationUi,
          initializationMinDurationInMilliseconds: widget.initializationMinDurationInMilliseconds,
          onAppInitStart: widget.onAppInitStart,
          onAppInitEnd: widget.onAppInitEnd,
          initialScreenRoute: widget.initialScreenRoute,
          translatorOptions: widget.translatorOptions,
          preferencesOptions: widget.preferencesOptions,
          mainDataProviderOptions: widget.mainDataProviderOptions,
        ),
        onGenerateRoute: widget.onGenerateRoute,
        navigatorObservers: [
          routeObserver,
          if (theNavigatorObservers != null) ...theNavigatorObservers,
        ],
        theme: widget.theme,
        builder: (BuildContext context, Widget? child) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            determineScreen(context);
          });

          return child ?? Container();
        },
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: theTranslatorOptions?.supportedLocales ?? List.empty(),
      ),
      snapshot: widget.snapshot
        ..responsiveScreen = _responsiveScreen
        ..messages = _messages,
    );
  }

  /// Determine correct screen by width for responsivity
  @protected
  determineScreen(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    ResponsiveScreen responsiveScreen = ResponsiveScreen.UnDetermined;

    if (width >= 1500) {
      responsiveScreen = ResponsiveScreen.ExtraLargeDesktop;
    } else if (width > 1200) {
      responsiveScreen = ResponsiveScreen.LargeDesktop;
    } else if (width > 992) {
      responsiveScreen = ResponsiveScreen.SmallDesktop;
    } else if (width > 768) {
      responsiveScreen = ResponsiveScreen.Tablet;
    } else if (width > 576) {
      responsiveScreen = ResponsiveScreen.LargePhone;
    } else {
      responsiveScreen = ResponsiveScreen.SmallPhone;
    }

    if (this._responsiveScreen != responsiveScreen) {
      this._responsiveScreen = responsiveScreen;

      setStateNotDisposed(() {});
    }
  }

  /// Add message to be shown on certain screen
  void addScreenMessage(String screenName, String message) {
    if (_messages[screenName] == null) {
      _messages[screenName] = List<String>.empty(growable: true);
    }

    _messages[screenName]!.add(message);
  }

  /// ReBuild whole app
  void invalidateApp() {
    setStateNotDisposed(() {});
  }
}

class _InitializationScreen extends StatelessWidget {
  static bool initializeOnce = false;

  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final Future<void> Function(BuildContext context)? onAppInitStart;
  final Future<void> Function(BuildContext context)? onAppInitEnd;
  final String initialScreenRoute;
  final TranslatorOptions? translatorOptions;
  final PreferencesOptions? preferencesOptions;
  final MainDataProviderOptions? mainDataProviderOptions;

  /// InitializationScreen initialization
  _InitializationScreen({
    required this.initializationUi,
    required this.initializationMinDurationInMilliseconds,
    this.onAppInitStart,
    this.onAppInitEnd,
    required this.initialScreenRoute,
    this.translatorOptions,
    this.preferencesOptions,
    this.mainDataProviderOptions,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _appInit(context);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: initializationUi,
    );
  }

  /// Initialize resources before app is started
  Future<void> _appInit(BuildContext context) async {
    final bool wasInitialized = initializeOnce;
    initializeOnce = true;

    if (!wasInitialized) {
      final start = DateTime.now();

      if (onAppInitStart != null) {
        await onAppInitStart!(context);
      }

      final thePreferencesOptions = preferencesOptions;
      if (thePreferencesOptions != null) {
        final preferences = Preferences(options: thePreferencesOptions);

        await preferences.init();
      }

      final theTranslatorOptions = translatorOptions;
      if (theTranslatorOptions != null) {
        final translator = Translator(options: theTranslatorOptions);

        await translator.init(context);
      }

      final theMainDataProviderOptions = mainDataProviderOptions;
      if (theMainDataProviderOptions != null) {
        MainDataProvider(options: theMainDataProviderOptions);
      }

      if (onAppInitEnd != null) {
        await onAppInitEnd!(context);
      }

      final diff = DateTime.now().difference(start);

      if (diff.inMilliseconds < initializationMinDurationInMilliseconds) {
        Future.delayed(
          Duration(milliseconds: initializationMinDurationInMilliseconds - diff.inMilliseconds),
          () => pushNamedNewStack(context, initialScreenRoute),
        );
      } else {
        pushNamedNewStack(context, initialScreenRoute);
      }
    }
  }
}

class AppDataState extends InheritedWidget {
  final AbstractAppDataStateSnapshot snapshot;

  /// AppDataState
  AppDataState({
    required Widget child,
    required this.snapshot,
  }) : super(child: child);

  /// AbstractAppDataState access current snapshot anywhere from BuildContext
  static T? of<T extends AbstractAppDataStateSnapshot>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDataState>()?.snapshot as T?;
  }

  /// Disable update notifications
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

abstract class AbstractAppDataStateSnapshot {
  late ResponsiveScreen responsiveScreen;
  late Map<String, List<String>> messages;

  /// AbstractAppDataStateSnapshot initialization
  AbstractAppDataStateSnapshot();

  /// Get message for screen if available
  String? getMessage(String? screenName) {
    if (screenName == null) return null;

    final theMessage = messages[screenName];
    if (theMessage != null && theMessage.isNotEmpty) {
      return theMessage.removeAt(0);
    }

    return null;
  }
}
