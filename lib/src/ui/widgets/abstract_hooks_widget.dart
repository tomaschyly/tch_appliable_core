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
    final invalidate = useState<int>(0);

    useEffect(() {
      return dispose;
    }, []);

    return buildContent(context, () {
      invalidate.value = DateTime.now().microsecondsSinceEpoch;
    });
  }

  /// Create view content from widgets
  @protected
  Widget buildContent(BuildContext context, VoidCallback invalidate);
}
