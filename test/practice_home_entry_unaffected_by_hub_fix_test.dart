import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';

import 'support/topic_hub_practice_crash_test_utils.dart';

/// Guards non-Hub '/practice' callers (Home's quick-start tile, onboarding
/// guest mode, Explore) against regressing while fixing the Hub's stale-
/// state bug: PracticeScreen.returnToHubTopicId is null for all of them, so
/// neither the new PracticeScreen key nor the new Back-to-Hub PopScope
/// should change anything about how they behave. Exercises Home's own
/// `{'autoStart': true}` extra (home_shell.dart) directly against the real
/// appRouter, matching route_navigator_key_regression_test.dart's pattern
/// of driving appRouter without needing the calling screen's UI.
void main() {
  setUpAll(preloadCrashRegressionCatalogs);
  setUp(initCrashRegressionServices);

  testWidgets(
      'Home autoStart still starts a session directly, and Back shows the '
      'ordinary exit-confirmation dialog rather than jumping to the Hub',
      (tester) async {
    final l10n = await AppLocalizations.delegate.load(testLocale);

    appRouter.go('/practice', extra: const {'autoStart': true});
    await tester.pumpWidget(appWithRealRouter());
    await tester.pump();
    // autoStart's own _startSession() does real async pack I/O behind an
    // indeterminate CircularProgressIndicator — the same reason the Hub's
    // own tests use pumpUntilLoaded instead of pumpAndSettle (see
    // topic_hub_practice_crash_test_utils.dart's tapNoSettle comment).
    await pumpUntilLoaded(tester);

    expect(find.byType(PracticeScreen), findsOneWidget);
    // autoStart's existing contract: skip setup, go straight into a
    // session — unchanged by this sprint's fix.
    expect(find.text(l10n.practiceStartButton), findsNothing,
        reason: 'Home autoStart entry must still go straight into a '
            'session exactly as before');
    expect(tester.takeException(), isNull);

    final navigator = Navigator.of(tester.element(find.byType(PracticeScreen)));
    await navigator.maybePop();
    await tester.pumpAndSettle();

    // The session-state exit-confirmation dialog (pre-existing, untouched
    // behaviour) must still be what shows — not a silent jump to
    // '/topics/hub', which would be wrong since this session was never
    // reached via any Hub.
    expect(find.text(l10n.practiceExitSessionTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
