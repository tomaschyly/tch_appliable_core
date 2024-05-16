import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

enum StatefulWidgetState {
  NotInitialized,
  Initialized,
  Disposed,
}

abstract class AbstractStatefulWidget extends StatefulWidget {
  /// AbstractStatefulWidget initialization
  AbstractStatefulWidget({super.key});
}

abstract class AbstractStatefulWidgetState<T extends AbstractStatefulWidget> extends State<T> {
  StatefulWidgetState get widgetState => _widgetState;

  StatefulWidgetState _widgetState = StatefulWidgetState.NotInitialized;

  /// Manually dispose of resources
  @override
  void dispose() {
    _widgetState = StatefulWidgetState.Disposed;

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    if (_widgetState == StatefulWidgetState.NotInitialized) {
      firstBuildOnly(context);
    }

    return Builder(
      builder: (BuildContext context) => buildContent(context),
    );
  }

  /// Run initializations of view on first build only
  @protected
  void firstBuildOnly(BuildContext context) {
    _widgetState = StatefulWidgetState.Initialized;
  }

  /// Create view content from widgets
  @protected
  Widget buildContent(BuildContext context);

  /// Call setState only if it not disposed yet
  @protected
  void setStateNotDisposed(VoidCallback fn) {
    if (mounted && context.mounted && _widgetState != StatefulWidgetState.Disposed) {
      setState(fn);
    }
  }

  /// Invalidate view for rebuild
  @protected
  void invalidate() {
    setStateNotDisposed(() {});
  }
}
