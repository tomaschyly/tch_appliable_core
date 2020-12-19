import 'package:flutter/material.dart';
import 'package:tch_appliable_core/ui/widgets/AbstractStatefulWidget.dart';

class CoreApp extends AbstractStatefulWidget {
  final String title;
  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final String initialScreenRoute;

  /// CoreApp initialization
  CoreApp({
    required this.title,
    required this.initializationUi,
    this.initializationMinDurationInMilliseconds = 0,
    required this.initialScreenRoute,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => CoreAppState();
}

class CoreAppState extends AbstractStatefulWidgetState<CoreApp> {
  CoreAppState get instance => _instance;

  late CoreAppState _instance;

  /// State initialization
  @override
  void initState() {
    _instance = this;

    super.initState();
  }

  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      home: _InitializationScreen(
        initializationUi: widget.initializationUi,
        initializationMinDurationInMilliseconds: widget.initializationMinDurationInMilliseconds,
        initialScreenRoute: widget.initialScreenRoute,
      ),
    );
  }
}

class _InitializationScreen extends StatelessWidget {
  static bool initializeOnce = false;

  final Widget initializationUi;
  final int initializationMinDurationInMilliseconds;
  final String initialScreenRoute;

  /// InitializationScreen initialization
  _InitializationScreen({
    required this.initializationUi,
    required this.initializationMinDurationInMilliseconds,
    required this.initialScreenRoute,
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

      //TODO various integral & app specific initializations

      final diff = DateTime.now().difference(start);

      if (diff.inMilliseconds < initializationMinDurationInMilliseconds) {
        // Future.delayed(Duration(milliseconds: initializationMinDurationInMilliseconds - diff.inMilliseconds), () => pushNamedNewStack(context, initialScreenRoute)); //TODO
      } else {
        // pushNamedNewStack(context, initialScreenRoute); //TODO
      }
    }
  }
}
