import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum HookWidgetState {
  notInitialized,
  initialized,
}

abstract class AbstractHooksWidget extends HookWidget {
  /// AbstractHooksWidget initialization
  AbstractHooksWidget({
    Key? key,
  }) : super(key: key);

  /// Manually dispose of resources
  @protected
  void dispose() {}

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final invalidate = useState<bool>(false);
    final state = useState<HookWidgetState>(HookWidgetState.notInitialized);

    useEffect(() {
      return dispose;
    }, []);

    if (state.value == HookWidgetState.notInitialized) {
      state.value = HookWidgetState.initialized;

      firstBuildOnly(context);
    }

    return buildContent(context, () {
      invalidate.value = !invalidate.value;
    });
  }

  /// Run initializations of view on first build only
  @protected
  firstBuildOnly(BuildContext context) {}

  /// Create view content from widgets
  @protected
  Widget buildContent(BuildContext context, VoidCallback invalidate);
}
