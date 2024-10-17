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

  final _dummyFocusNode = FocusNode();

  @protected
  bool wasBackground = false;

  /// Manually dispose of resources
  @override
  void dispose() {
    _widgetState = StatefulWidgetState.Disposed;

    _dummyFocusNode.dispose();

    super.dispose();
  }

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final snapshot = context.appDataStateOrNull;

    if (_widgetState == StatefulWidgetState.NotInitialized) {
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

    return Builder(
      builder: (BuildContext context) => buildContent(context),
    );
  }

  /// Run initializations of view on first build only
  @protected
  void firstBuildOnly(BuildContext context) {
    _widgetState = StatefulWidgetState.Initialized;
  }

  /// Build content from widgets
  @protected
  Widget buildContent(BuildContext context);

  /// Last build for actions before app goes to background from foreground
  @protected
  void onBackground(BuildContext context) {}

  /// First build for actions after app goes to foreground from background
  @protected
  void onForeground(BuildContext context) {}

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

  /// Clear current focus using dummy FocusNode
  /// This should solve some situations on Android, where the focus jumps back to input when it should not do so
  @protected
  void clearFocusToDummy() {
    _dummyFocusNode.requestFocus();
  }
}
