import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/core/CoreApp.dart';
import 'package:tch_appliable_core/src/ui/screens/AbstractScreen.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractStatefulWidget.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

typedef DisplayMessage = void Function(BuildContext context, ScreenMessage message);

class ScreenMessengerWidget extends AbstractStatefulWidget {
  final AbstractScreenOptions options;
  final DisplayMessage displayMessage;
  final Widget child;

  /// ScreenMessengerWidget initialization
  ScreenMessengerWidget({
    Key? key,
    required this.options,
    required this.displayMessage,
    required this.child,
  }) : super(key: key);

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => ScreenMessengerWidgetState();
}

class ScreenMessengerWidgetState extends AbstractStatefulWidgetState<ScreenMessengerWidget> {
  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    final routingArguments = RoutingArguments.of(context)!;

    if (routingArguments.isCurrent) {
      final AbstractAppDataStateSnapshot? snapshot = AppDataState.of(context);
      final ScreenMessage? message = snapshot?.getMessage(widget.options.screenName);

      if (message != null) {
        widget.displayMessage(context, message);
      }
    }

    return widget.child;
  }

  /// Display message when already on current screen
  void onResume() {
    final routingArguments = RoutingArguments.of(context)!;

    if (routingArguments.isCurrent) {
      final AbstractAppDataStateSnapshot? snapshot = AppDataState.of(context);
      final ScreenMessage? message = snapshot?.getMessage(widget.options.screenName);

      if (message != null) {
        widget.displayMessage(context, message);
      }
    }
  }
}

enum ScreenMessageType {
  none,
  success,
  error,
  info,
  loading,
}

class ScreenMessage {
  final ScreenMessageType type;
  final String message;
  final Duration duration;

  /// ScreenMessage initialization
  ScreenMessage({
    ScreenMessageType? type,
    required this.message,
    Duration? duration,
  })  : this.type = type ?? ScreenMessageType.none,
        this.duration = duration ?? const Duration(milliseconds: 4000);
}
