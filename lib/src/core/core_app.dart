import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/widget.dart';

class CoreApp extends AbstractStatefulWidget {
  final bool debugShowCheckedModeBanner;
  final String title;
  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final Future<void> Function(BuildContext context)? onAppInitStart;
  final Future<void> Function(BuildContext context)? onAppInitEnd;
  final String initialScreenRoute;
  final Map<String, String>? initialScreenRouteArguments;
  final Route<dynamic> Function({
    required WidgetBuilder builder,
    RouteSettings? settings,
  })? onGenerateInitialRoute;
  final RouteFactory onGenerateRoute;
  final AbstractAppDataStateSnapshot snapshot;
  final List<NavigatorObserver>? navigatorObservers;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final String? darkThemePrefsKey;
  final Widget Function(BuildContext context, Widget child)? builder;
  final TranslatorOptions? translatorOptions;
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final PreferencesOptions? preferencesOptions;
  final MainDataProviderOptions? mainDataProviderOptions;

  /// CoreApp initialization
  CoreApp({
    this.debugShowCheckedModeBanner = true,
    required this.title,
    required this.initializationUi,
    this.initializationMinDurationInMilliseconds = 0,
    this.onAppInitStart,
    this.onAppInitEnd,
    required this.initialScreenRoute,
    this.initialScreenRouteArguments,
    this.onGenerateInitialRoute,
    required this.onGenerateRoute,
    required this.snapshot,
    this.navigatorObservers,
    this.theme,
    this.darkTheme,
    this.darkThemePrefsKey,
    this.builder,
    this.translatorOptions,
    this.localizationsDelegates,
    this.preferencesOptions,
    this.mainDataProviderOptions,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => CoreAppState();
}

class CoreAppState extends AbstractStatefulWidgetState<CoreApp> with WidgetsBindingObserver {
  static CoreAppState get instance => _instance;

  static late CoreAppState _instance;

  ValueNotifier<bool> _initializeOnce = ValueNotifier(true);
  bool _isForeground = true;
  bool _isOSDarkMode = false;
  ResponsiveScreen _responsiveScreen = ResponsiveScreen.UnDetermined;
  final Map<String, List<ScreenMessage>> _messages = Map();
  Locale? _selectedLocale;

  /// State initialization
  @override
  void initState() {
    _instance = this;

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  /// Manually dispose of resources
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final theNavigatorObservers = widget.navigatorObservers;
    final theTranslatorOptions = widget.translatorOptions;
    final theLocalizationsDelegates = widget.localizationsDelegates;

    if (theTranslatorOptions != null && theTranslatorOptions.onLanguageChange == null) {
      theTranslatorOptions.onLanguageChange = (Locale locale) {
        setStateNotDisposed(() {
          _selectedLocale = locale;
        });
      };
    }

    final theDarkThemePrefsKey = widget.darkThemePrefsKey;
    bool darkMode = _isOSDarkMode;
    if (theDarkThemePrefsKey != null) {
      final darkModeType = prefsInt(theDarkThemePrefsKey) == null ? DarkMode.Automatic : DarkMode.values[prefsInt(theDarkThemePrefsKey)!];

      darkMode = darkModeType == DarkMode.Automatic ? darkMode : darkModeType == DarkMode.Enabled;
    }

    return AppDataState(
      child: MaterialApp(
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        title: widget.title,
        initialRoute: '/',
        onGenerateInitialRoutes: (String initialRoute) {
          final generate = widget.onGenerateInitialRoute;

          final builder = (BuildContext context) {
            return _InitializationScreen(
              initializeOnce: _initializeOnce,
              initializationUi: widget.initializationUi,
              initializationMinDurationInMilliseconds: widget.initializationMinDurationInMilliseconds,
              onAppInitStart: widget.onAppInitStart,
              onAppInitEnd: widget.onAppInitEnd,
              initialScreenRoute: widget.initialScreenRoute,
              initialScreenRouteArguments: widget.initialScreenRouteArguments,
              translatorOptions: theTranslatorOptions,
              preferencesOptions: widget.preferencesOptions,
              mainDataProviderOptions: widget.mainDataProviderOptions,
            );
          };

          if (generate != null) {
            return [
              generate(
                builder: builder,
              ),
            ];
          } else {
            return [
              MaterialPageRoute(
                builder: builder,
              ),
            ];
          }
        },
        onGenerateRoute: widget.onGenerateRoute,
        navigatorObservers: [
          routeObserver,
          if (theNavigatorObservers != null) ...theNavigatorObservers,
        ],
        theme: darkMode ? (widget.darkTheme ?? widget.theme) : widget.theme,
        // darkTheme: widget.darkTheme,
        builder: (BuildContext context, Widget? child) {
          addPostFrameCallback((timeStamp) {
            determineOSThemeMode(context);

            determineScreen(context);
          });

          final theBuilder = widget.builder;
          if (theBuilder != null) {
            return theBuilder(context, child ?? Container());
          } else {
            return child ?? Container();
          }
        },
        locale: _selectedLocale,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          if (theLocalizationsDelegates != null) ...theLocalizationsDelegates,
        ],
        supportedLocales: theTranslatorOptions?.supportedLocales ?? const <Locale>[Locale('en', 'US')],
      ),
      snapshot: widget.snapshot
        ..isForeground = _isForeground
        ..isOSDarkMode = _isOSDarkMode
        ..isDarkMode = darkMode
        ..responsiveScreen = _responsiveScreen
        ..addScreenMessage = addScreenMessage
        ..messages = _messages,
    );
  }

  /// Listen to change of app lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && !_isForeground) {
      _isForeground = true;

      setStateNotDisposed(() {});
    } else if (state != AppLifecycleState.resumed && _isForeground) {
      _isForeground = false;

      setStateNotDisposed(() {});
    }
  }

  /// OS changed Theme mode, determine is OS Dark mode
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    final isOSDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isOSDarkMode != _isOSDarkMode) {
      _isOSDarkMode = isOSDarkMode;

      setStateNotDisposed(() {});
    }
  }

  /// Determine if is OS Dark mode enabled
  @protected
  determineOSThemeMode(BuildContext context, [bool setState = true]) {
    final isOSDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    if (isOSDarkMode != _isOSDarkMode) {
      _isOSDarkMode = isOSDarkMode;

      if (setState) {
        setStateNotDisposed(() {});
      }
    }
  }

  /// Determine correct screen by width for responsivity
  @protected
  determineScreen(BuildContext context) {
    ResponsiveScreen responsiveScreen = determineResponsiveScreen(context);

    if (this._responsiveScreen != responsiveScreen) {
      this._responsiveScreen = responsiveScreen;

      setStateNotDisposed(() {});
    }
  }

  /// Add message to be shown on certain screen
  void addScreenMessage(
    String screenName,
    String message, {
    ScreenMessageType? type,
    Duration? duration,
  }) {
    if (_messages[screenName] == null) {
      _messages[screenName] = <ScreenMessage>[];
    }

    setStateNotDisposed(() {
      _messages[screenName]!.add(
        ScreenMessage(
          message: message,
          type: type,
          duration: duration,
        ),
      );
    });
  }

  /// ReBuild whole app
  void _invalidateApp() {
    setStateNotDisposed(() {});
  }
}

/// Determine correct screen by width for responsivity
determineResponsiveScreen(BuildContext context) {
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

  return responsiveScreen;
}

class _InitializationScreen extends StatelessWidget {
  final ValueNotifier<bool> initializeOnce;
  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final Future<void> Function(BuildContext context)? onAppInitStart;
  final Future<void> Function(BuildContext context)? onAppInitEnd;
  final String initialScreenRoute;
  final Map<String, String>? initialScreenRouteArguments;
  final TranslatorOptions? translatorOptions;
  final PreferencesOptions? preferencesOptions;
  final MainDataProviderOptions? mainDataProviderOptions;

  /// InitializationScreen initialization
  _InitializationScreen({
    required this.initializeOnce,
    required this.initializationUi,
    required this.initializationMinDurationInMilliseconds,
    this.onAppInitStart,
    this.onAppInitEnd,
    required this.initialScreenRoute,
    this.initialScreenRouteArguments,
    this.translatorOptions,
    this.preferencesOptions,
    this.mainDataProviderOptions,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    addPostFrameCallback((timeStamp) {
      _appInit(context);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: initializationUi,
    );
  }

  /// Initialize resources before app is started
  Future<void> _appInit(BuildContext context) async {
    final bool initialize = initializeOnce.value;

    initializeOnce.value = false;

    if (initialize) {
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

      CoreAppState.instance._invalidateApp();

      final diff = DateTime.now().difference(start);

      if (diff.inMilliseconds < initializationMinDurationInMilliseconds) {
        Future.delayed(
          Duration(milliseconds: initializationMinDurationInMilliseconds - diff.inMilliseconds),
          () => pushNamedNewStack(context, initialScreenRoute, arguments: initialScreenRouteArguments),
        );
      } else {
        pushNamedNewStack(context, initialScreenRoute, arguments: initialScreenRouteArguments);
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

/// Shorthand to get AbstractAppDataStateSnapshot from context
AbstractAppDataStateSnapshot getAbstractAppDataStateSnapshot(BuildContext context) => AppDataState.of<AbstractAppDataStateSnapshot>(context)!;

extension AppDataStateExtension on BuildContext {
  /// Shorthand to get AbstractAppDataStateSnapshot from context
  AbstractAppDataStateSnapshot get appDataState => AppDataState.of<AbstractAppDataStateSnapshot>(this)!;

  /// Shorthand to get nullable AbstractAppDataStateSnapshot from context
  AbstractAppDataStateSnapshot? get appDataStateOrNull => AppDataState.of<AbstractAppDataStateSnapshot>(this);
}

typedef AddScreenMessage = void Function(
  String screenName,
  String message, {
  ScreenMessageType? type,
  Duration? duration,
});

abstract class AbstractAppDataStateSnapshot {
  bool isForeground = true;
  bool isOSDarkMode = false;
  bool isDarkMode = false;
  late ResponsiveScreen responsiveScreen;
  late AddScreenMessage addScreenMessage;
  late Map<String, List<ScreenMessage>> messages;

  /// AbstractAppDataStateSnapshot initialization
  AbstractAppDataStateSnapshot();

  /// Get message for screen if available
  ScreenMessage? getMessage(String? screenName) {
    if (screenName == null) return null;

    final theMessage = messages[screenName];
    if (theMessage != null && theMessage.isNotEmpty) {
      return theMessage.removeAt(0);
    }

    return null;
  }

  /// Convert to String
  @override
  String toString() {
    return 'AbstractAppDataStateSnapshot{responsiveScreen: $responsiveScreen, isForeground: $isForeground, isOSDarkMode: $isOSDarkMode, isDarkMode: $isDarkMode, messages: $messages}';
  }
}

enum DarkMode {
  Automatic,
  Enabled,
  Disabled,
}
