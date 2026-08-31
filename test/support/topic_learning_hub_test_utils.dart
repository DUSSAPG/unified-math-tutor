import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';

/// Shared helpers for the Topic Learning Hub's test files. Each scenario
/// lives in its own top-level test file (one real asset-loading
/// `testWidgets` per file) rather than stacked in one — stacking several
/// real-asset-loading Hub tests in one file/process reproducibly caused
/// cross-test flakiness in this environment (a widget-tree query that
/// passed in isolation intermittently found nothing once a second real
/// load shared the process), matching the "one real load per file"
/// discipline already established by
/// practice_screen_continue_learning_test.dart for the same underlying
/// reason. This file itself is never picked up by `flutter test` (no
/// `main()`/no `_test.dart` suffix).
Future<void> pumpUntil(
  WidgetTester tester,
  bool Function() condition, {
  int maxIterations = 600,
}) async {
  await tester.pump();
  for (var i = 0; i < maxIterations && !condition(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
}

/// After a stage change, the screen briefly shows its loading spinner
/// before the new capability rows resolve — waiting for a card to become
/// ABSENT can spuriously succeed *during* that transient gap (every card,
/// quickStart included, is absent while loading), not just once the new
/// data has genuinely resolved without it. Waiting for the spinner itself
/// to clear avoids that race entirely.
Future<void> pumpUntilLoaded(WidgetTester tester) => pumpUntil(
      tester,
      () => find.byType(CircularProgressIndicator).evaluate().isEmpty,
    );

Widget wrapHubWithRouter(
  String topicId, {
  bool withTopicsFallback = false,
}) {
  final router = GoRouter(
    initialLocation: '/hub',
    routes: [
      if (withTopicsFallback)
        GoRoute(
          path: '/topics',
          builder: (_, __) => const Scaffold(body: Text('topics-fallback')),
        ),
      GoRoute(
        path: '/hub',
        builder: (_, __) => TopicLearningHubScreen(topicId: topicId),
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

Finder activityCard(String activityType, [String supportingId = '']) =>
    find.byKey(Key('topicHubActivity-$activityType-$supportingId'));
