import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tch_appliable_core/core/RouterV1.dart';
import 'package:tch_appliable_core/core/Translator.dart';
import 'package:tch_appliable_core/ui/widgets/AbstractResponsiveWidget.dart';
import 'package:tch_appliable_core/ui/widgets/AbstractStatefulWidget.dart';

class CoreApp extends AbstractStatefulWidget {
  final String title;
  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final String initialScreenRoute;
  final RouteFactory onGenerateRoute;
  final AbstractAppDataStateSnapshot snapshot;
  final List<NavigatorObserver>? navigatorObservers;
  final TranslatorOptions? translatorOptions;

  /// CoreApp initialization
  CoreApp({
    required this.title,
    required this.initializationUi,
    this.initializationMinDurationInMilliseconds = 0,
    required this.initialScreenRoute,
    required this.onGenerateRoute,
    required this.snapshot,
    this.navigatorObservers,
    this.translatorOptions,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => CoreAppState();
}

class CoreAppState extends AbstractStatefulWidgetState<CoreApp> {
  static CoreAppState get instance => _instance;

  static late CoreAppState _instance;

  @protected
  ResponsiveScreen responsiveScreen = ResponsiveScreen.UnDetermined;

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
          initialScreenRoute: widget.initialScreenRoute,
          translatorOptions: widget.translatorOptions,
        ),
        onGenerateRoute: widget.onGenerateRoute,
        navigatorObservers: [
          routeObserver,
          if (theNavigatorObservers != null) ...theNavigatorObservers,
        ],
        builder: (BuildContext context, Widget? child) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            determineScreen(context);
          });

          return child ?? Container();
        },
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: theTranslatorOptions?.supportedLocales ?? List.empty(),
      ),
      snapshot: widget.snapshot..responsiveScreen = responsiveScreen,
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

    if (this.responsiveScreen != responsiveScreen) {
      this.responsiveScreen = responsiveScreen;

      setStateNotDisposed(() {});
    }
  }
}

class _InitializationScreen extends StatelessWidget {
  static bool initializeOnce = false;

  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final String initialScreenRoute;
  final TranslatorOptions? translatorOptions;

  /// InitializationScreen initialization
  _InitializationScreen({
    required this.initializationUi,
    required this.initializationMinDurationInMilliseconds,
    required this.initialScreenRoute,
    this.translatorOptions,
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

      final theTranslatorOptions = translatorOptions;
      if (theTranslatorOptions != null) {
        final translator = Translator(options: theTranslatorOptions);

        await translator.init(context);
      }

      //TODO various integral & app specific initializations

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

  /// AbstractAppDataStateSnapshot initialization
  AbstractAppDataStateSnapshot();
}
