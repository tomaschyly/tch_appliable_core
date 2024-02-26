import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

enum WidgetState {
  NotInitialized,
  Initialized,
  Disposed,
}

abstract class AbstractStatefulWidget extends StatefulWidget {
  /// AbstractStatefulWidget initialization
  AbstractStatefulWidget({super.key});
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

  /// Run initializations of view on first build only
  @protected
  firstBuildOnly(BuildContext context) {
    _widgetState = WidgetState.Initialized;
  }

  /// Create view content from widgets
  @protected
  Widget buildContent(BuildContext context);

  /// Call setState only if it not disposed yet
  @protected
  void setStateNotDisposed(VoidCallback fn) {
    if (context.mounted && mounted && _widgetState != WidgetState.Disposed) {
      setState(fn);
    }
  }

  /// Invalidate view for rebuild
  @protected
  void invalidate() {
    setStateNotDisposed(() {});
  }
}
