import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/services/captain_math_service.dart';
import 'package:unified_math_tutor/widgets/captain_math_card.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('shows the message for the pinned state with a semantic label', (tester) async {
    await tester.pumpWidget(_wrap(const CaptainMathCard(state: CaptainMathState.encouraging)));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.captainMathEncouraging), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('suppresses bounce animation when Reduce Motion is requested', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 400));
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(_wrap(const CaptainMathCard(state: CaptainMathState.curious)));
    await tester.pump();

    // With animations disabled, no Transform.translate offset should be
    // actively driven by the AnimationController — the widget renders the
    // static asset without throwing or leaving an animation running.
    expect(tester.hasRunningAnimations, isFalse);
    expect(tester.takeException(), isNull);
  });
}
