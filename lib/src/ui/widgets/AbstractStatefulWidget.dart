import 'package:flutter/material.dart';

enum WidgetState {
  NotInitialized,
  Initialized,
  Disposed,
}

abstract class AbstractStatefulWidget extends StatefulWidget {
  /// AbstractStatefulWidget initialization
  AbstractStatefulWidget({Key? key}) : super(key: key);
}

abstract class AbstractStatefulWidgetState<T extends AbstractStatefulWidget> extends State<T> {
  WidgetState get widgetState => _widgetState;

  WidgetState _widgetState = WidgetState.NotInitialized;

  /// Manually dispose of resources
  @override
  void dispose() {
    _widgetState = WidgetState.Disposed;

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    if (_widgetState == WidgetState.NotInitialized) {
      firstBuildOnly(context);
    }

    return Builder(
      builder: (BuildContext context) => buildContent(context),
    );
  }

  /// Run initializations of screen on first build only
  @protected
  firstBuildOnly(BuildContext context) {
    _widgetState = WidgetState.Initialized;
  }

  /// Create screen content from widgets
  @protected
  Widget buildContent(BuildContext context);

  /// Call setState only if it not disposed yet
  @protected
  void setStateNotDisposed(VoidCallback fn) {
    if (_widgetState != WidgetState.Disposed) {
      setState(fn);
    }
  }

  /// Invalidate screen for rebuild
  @protected
  void invalidate() {
    setStateNotDisposed(() {});
  }
}
