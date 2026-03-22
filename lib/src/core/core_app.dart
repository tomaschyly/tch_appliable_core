import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
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
  final RouteFactory? onGenerateRoute;
  final GoRouter? router;
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
  final Color? color;
  final ScrollBehavior? scrollBehavior;
  final Duration? themeAnimationDuration;
  final Curve? themeAnimationCurve;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final String? restorationScopeId;

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
    this.onGenerateRoute,
    this.router,
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
    this.color,
    this.scrollBehavior,
    this.themeAnimationDuration,
    this.themeAnimationCurve,
    this.shortcuts,
    this.actions,
    this.localeResolutionCallback,
    this.restorationScopeId,
  }) : assert(
          (onGenerateRoute != null) != (router != null),
          'Provide either onGenerateRoute (V1) or router (GoRouter V2), not both or neither.',
        );

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => CoreAppState();
}

class CoreAppState extends AbstractStatefulWidgetState<CoreApp> with WidgetsBindingObserver {
  static CoreAppState get instance => _instance;

  static late CoreAppState _instance;

  final ValueNotifier<bool> _initializeOnce = ValueNotifier(true);
  final ValueNotifier<bool> _v2InitComplete = ValueNotifier(false);
  bool _isForeground = true;
  bool _isOSDarkMode = false;
  ResponsiveScreen _responsiveScreen = ResponsiveScreen.unDetermined;
  final Map<String, List<ScreenMessage>> _messages = {};
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
    final theRouter = widget.router;

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
      final darkModeType = prefsInt(theDarkThemePrefsKey) == null ? DarkMode.automatic : DarkMode.values[prefsInt(theDarkThemePrefsKey)!];

      darkMode = darkModeType == DarkMode.automatic ? darkMode : darkModeType == DarkMode.enabled;
    }

    final snapshot = widget.snapshot
      ..isForeground = _isForeground
      ..isOSDarkMode = _isOSDarkMode
      ..isDarkMode = darkMode
      ..responsiveScreen = _responsiveScreen
      ..addScreenMessage = addScreenMessage
      ..messages = _messages;

    if (theRouter != null) {
      return AppDataState(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          title: widget.title,
          routerConfig: theRouter,
          theme: darkMode ? (widget.darkTheme ?? widget.theme) : widget.theme,
          color: widget.color,
          scrollBehavior: widget.scrollBehavior,
          themeAnimationDuration: widget.themeAnimationDuration ?? kThemeAnimationDuration,
          themeAnimationCurve: widget.themeAnimationCurve ?? Curves.linear,
          shortcuts: widget.shortcuts,
          actions: widget.actions,
          restorationScopeId: widget.restorationScopeId,
          builder: (BuildContext context, Widget? child) {
            addPostFrameCallback((timeStamp) {
              determineOSThemeMode(context);
              determineScreen(context);
            });

            Widget routerChild = child ?? SizedBox.shrink();

            final theBuilder = widget.builder;
            if (theBuilder != null) {
              routerChild = theBuilder(context, routerChild);
            }

            return ValueListenableBuilder<bool>(
              valueListenable: _v2InitComplete,
              builder: (context, initComplete, _) {
                if (!initComplete) {
                  return Stack(
                    children: [
                      routerChild,
                      Positioned.fill(
                        child: _V2InitializationWidget(
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
                          router: theRouter,
                          v2InitComplete: _v2InitComplete,
                        ),
                      ),
                    ],
                  );
                }

                return routerChild;
              },
            );
          },
          locale: _selectedLocale,
          localeResolutionCallback: widget.localeResolutionCallback,
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
            if (theLocalizationsDelegates != null) ...theLocalizationsDelegates,
          ],
          supportedLocales: theTranslatorOptions?.supportedLocales ?? const <Locale>[Locale('en', 'US')],
        ),
        snapshot: snapshot,
      );
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
        color: widget.color,
        scrollBehavior: widget.scrollBehavior,
        themeAnimationDuration: widget.themeAnimationDuration ?? kThemeAnimationDuration,
        themeAnimationCurve: widget.themeAnimationCurve ?? Curves.linear,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
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
        localeResolutionCallback: widget.localeResolutionCallback,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          if (theLocalizationsDelegates != null) ...theLocalizationsDelegates,
        ],
        supportedLocales: theTranslatorOptions?.supportedLocales ?? const <Locale>[Locale('en', 'US')],
      ),
      snapshot: snapshot,
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

    determineOSThemeMode(context);
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

    if (_responsiveScreen != responsiveScreen) {
      _responsiveScreen = responsiveScreen;

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
  ResponsiveScreen responsiveScreen = ResponsiveScreen.unDetermined;

  if (width >= 1500) {
    responsiveScreen = ResponsiveScreen.extraLargeDesktop;
  } else if (width > 1200) {
    responsiveScreen = ResponsiveScreen.largeDesktop;
  } else if (width > 992) {
    responsiveScreen = ResponsiveScreen.smallDesktop;
  } else if (width > 768) {
    responsiveScreen = ResponsiveScreen.tablet;
  } else if (width > 576) {
    responsiveScreen = ResponsiveScreen.largePhone;
  } else {
    responsiveScreen = ResponsiveScreen.smallPhone;
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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

class _V2InitializationWidget extends StatelessWidget {
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
  final GoRouter router;
  final ValueNotifier<bool> v2InitComplete;

  /// _V2InitializationWidget initialization
  _V2InitializationWidget({
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
    required this.router,
    required this.v2InitComplete,
  });

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    addPostFrameCallback((timeStamp) {
      _appInit(context);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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

      void navigate() {
        final args = initialScreenRouteArguments;
        final location = args != null && args.isNotEmpty
            ? Uri(path: initialScreenRoute, queryParameters: args).toString()
            : initialScreenRoute;

        router.go(location);
        v2InitComplete.value = true;
      }

      if (diff.inMilliseconds < initializationMinDurationInMilliseconds) {
        Future.delayed(
          Duration(milliseconds: initializationMinDurationInMilliseconds - diff.inMilliseconds),
          navigate,
        );
      } else {
        navigate();
      }
    }
  }
}

class AppDataState extends InheritedWidget {
  final AbstractAppDataStateSnapshot snapshot;

  /// AppDataState
  AppDataState({
    super.key,
    required Widget child,
    required this.snapshot,
  }) : super(child: child);

  /// AbstractAppDataState access current snapshot anywhere from BuildContext
  static T? of<T extends AbstractAppDataStateSnapshot>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDataState>()?.snapshot as T?;
  }

  /// Notify dependents to rebuild when snapshot changes
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
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
  automatic,
  enabled,
  disabled,
}
