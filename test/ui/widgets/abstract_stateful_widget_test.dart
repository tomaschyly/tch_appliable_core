import 'package:flutter_test/flutter_test.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

void main() {
  testWidgets('dummy focus node detaches when its state is disposed', (
    tester,
  ) async {
    var displayFirstState = true;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                FilledButton(
                  key: const ValueKey('switch-state'),
                  onPressed: () => setState(() => displayFirstState = false),
                  child: const Text('Switch state'),
                ),
                _FocusTestWidget(
                  key: ValueKey(
                    displayFirstState ? 'first-state' : 'second-state',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('clear-focus')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('switch-state')));
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('clear-focus')));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

class _FocusTestWidget extends AbstractStatefulWidget {
  /// Focus test widget initialization
  const _FocusTestWidget({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _FocusTestWidgetState();
}

class _FocusTestWidgetState
    extends AbstractStatefulWidgetState<_FocusTestWidget> {
  /// Build a button that moves focus to the state's dummy node
  @override
  Widget buildContent(BuildContext context) {
    return FilledButton(
      key: const ValueKey('clear-focus'),
      onPressed: () => clearFocusToDummy(context),
      child: const Text('Clear focus'),
    );
  }
}
