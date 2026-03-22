import 'package:tch_appliable_core/tch_appliable_core.dart';

typedef DisplayMessage = void Function(BuildContext context, ScreenMessage message);

class ScreenMessengerWidget extends AbstractStatefulWidget {
  final AbstractScreenOptions options;
  final DisplayMessage displayMessage;
  final Widget child;

  /// ScreenMessengerWidget initialization
  ScreenMessengerWidget({
    super.key,
    required this.options,
    required this.displayMessage,
    required this.child,
  });

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => ScreenMessengerWidgetState();
}

class ScreenMessengerWidgetState extends AbstractStatefulWidgetState<ScreenMessengerWidget> {
  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    if (_isCurrent(context)) {
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
    if (_isCurrent(context)) {
      final AbstractAppDataStateSnapshot? snapshot = AppDataState.of(context);
      final ScreenMessage? message = snapshot?.getMessage(widget.options.screenName);

      if (message != null) {
        widget.displayMessage(context, message);
      }
    }
  }

  /// Resolve isCurrent from V2 routing args, then V1 fallback, then true
  bool _isCurrent(BuildContext context) {
    return RoutingArgumentsV2.of(context)?.isCurrent ?? RoutingArguments.of(context)?.isCurrent ?? true;
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
  })  : type = type ?? ScreenMessageType.none,
        duration = duration ?? const Duration(milliseconds: 4000);
}
