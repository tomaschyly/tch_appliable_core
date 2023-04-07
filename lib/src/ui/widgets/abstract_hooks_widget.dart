import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

    useEffect(() {
      return dispose;
    }, []);

    return buildContent(context, () {
      invalidate.value = !invalidate.value;
    });
  }

  /// Create view content from widgets
  @protected
  Widget buildContent(BuildContext context, VoidCallback invalidate);
}
