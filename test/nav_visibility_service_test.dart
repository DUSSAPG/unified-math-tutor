import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/nav_visibility_service.dart';

/// Regression test for the "setState() or markNeedsBuild() called during
/// build" exception dispatched from [NavVisibilityService.hidden]: several
/// screens call [NavVisibilityService.hide]/[show] from `initState()`/
/// `dispose()`, which run while the widget tree is locked. The fix defers
/// the notifier mutation to the next frame — these tests assert that
/// deferral directly, independent of reproducing the exact production
/// route-transition timing in a widget test.
void main() {
  setUp(() {
    // Leave the singleton in a known state between tests.
    NavVisibilityService.instance.hidden.value = false;
  });

  testWidgets('hide() does not mutate hidden synchronously, only after a frame',
      (tester) async {
    await tester.pumpWidget(const SizedBox.shrink());

    NavVisibilityService.instance.hide();
    expect(
      NavVisibilityService.instance.hidden.value,
      isFalse,
      reason: 'Mutating synchronously would notify listeners mid-build if called from '
          'initState()/dispose() — the fix must defer to a post-frame callback',
    );

    await tester.pump();
    expect(NavVisibilityService.instance.hidden.value, isTrue);
  });

  testWidgets('show() does not mutate hidden synchronously, only after a frame',
      (tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    NavVisibilityService.instance.hide();
    await tester.pump();
    expect(NavVisibilityService.instance.hidden.value, isTrue);

    NavVisibilityService.instance.show();
    expect(NavVisibilityService.instance.hidden.value, isTrue);

    await tester.pump();
    expect(NavVisibilityService.instance.hidden.value, isFalse);
  });

  testWidgets(
    'calling hide() from initState() does not throw when a ValueListenableBuilder '
    'elsewhere in the tree is listening to hidden',
    (tester) async {
      // Mirrors the real production shape: an ancestor ValueListenableBuilder
      // (AppShell) plus a descendant whose initState() calls hide() during
      // the same build pass that mounts it.
      // Mirrors the real shape: AppShell's ValueListenableBuilder reacts to
      // `hidden` to decide whether to show nav chrome, but the pushed
      // screen that calls hide()/show() is mounted independently of that
      // decision (a separate route, not conditionally built by it) — unlike
      // an earlier draft of this test, `_HidesNavOnInit` must stay mounted
      // regardless of `hidden`'s value, or its own dispose() re-triggering
      // show() creates a self-inflicted oscillation that isn't how
      // production behaves.
      await tester.pumpWidget(
        MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: NavVisibilityService.instance.hidden,
            builder: (context, hidden, child) => Scaffold(
              bottomNavigationBar: hidden ? null : const Text('nav chrome'),
              body: child,
            ),
            child: const _HidesNavOnInit(),
          ),
        ),
      );

      expect(tester.takeException(), isNull);

      await tester.pump();
      expect(NavVisibilityService.instance.hidden.value, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

class _HidesNavOnInit extends StatefulWidget {
  const _HidesNavOnInit();

  @override
  State<_HidesNavOnInit> createState() => _HidesNavOnInitState();
}

class _HidesNavOnInitState extends State<_HidesNavOnInit> {
  @override
  void initState() {
    super.initState();
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
