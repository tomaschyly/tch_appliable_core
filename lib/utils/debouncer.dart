import 'dart:async';
import 'dart:ui';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  /// Debouncer initialization
  Debouncer({
    required this.milliseconds,
  });

  /// Debouncer dispose timer
  void dispose() {
    _timer?.cancel();
  }

  /// Debounce action
  run(
    VoidCallback action, {
    int? milliseconds,
  }) {
    _timer?.cancel();

    _timer = Timer(
      Duration(
        milliseconds: milliseconds ?? this.milliseconds,
      ),
      action,
    );
  }
}
