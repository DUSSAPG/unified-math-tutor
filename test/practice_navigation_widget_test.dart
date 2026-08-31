import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/packs/exam_packs_screen.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';

/// The Hub's capability resolution does real asset I/O (packs, formula
/// catalog, recall cards) — pumpAndSettle never returns while its
/// CircularProgressIndicator keeps scheduling frames, so this drives real
/// async work via runAsync instead, matching the pattern already
/// established for other real-pack-loading tests in this suite.
Future<void> _pumpUntil(
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

void main() {
  testWidgets(
      'Practice topic filter navigates through the Topic Learning Hub '
      'without index errors, and Topic Drill still launches Practice',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final router = GoRouter(
      initialLocation: '/topics',
      routes: [
        GoRoute(
          path: '/topics',
          builder: (_, __) => const Scaffold(body: TopicsScreen()),
          routes: [
            GoRoute(
              path: 'hub',
              builder: (_, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return TopicLearningHubScreen(
                  topicId: extra?['topicId'] as String? ?? 'mixed_review',
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/practice',
          builder: (_, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return Scaffold(
              body: PracticeScreen(
                selectedTopic: extra?['topic'] as String?,
                selectedTopicId: extra?['topicId'] as String?,
                initialStage: extra?['stage'] as String?,
              ),
            );
          },
        ),
        GoRoute(
          path: '/packs',
          builder: (_, __) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: '/upgrade',
          builder: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Practice').first);
    await tester.pumpAndSettle();
    // Fractions has real KS2 Topic Drill content (the learner's default
    // stage) — see topic_capability_resolver_test.dart's audited matrix.
    await tester.tap(find.text('Fractions').first);
    await tester.pump();

    final topicDrillCard =
        find.byKey(const Key('topicHubActivity-topicDrill-'));
    await _pumpUntil(tester, () => topicDrillCard.evaluate().isNotEmpty);

    expect(find.byType(TopicLearningHubScreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(topicDrillCard);
    await tester.tap(topicDrillCard);
    await tester.pumpAndSettle();

    expect(find.byType(PracticeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Exam Packs selection falls back home when there is no page to pop',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final router = GoRouter(
      initialLocation: '/packs',
      routes: [
        GoRoute(
          path: '/packs',
          builder: (_, __) => const ExamPacksScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('home-safe-fallback')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('KS2 Maths'));
    await tester.pumpAndSettle();

    expect(find.text('home-safe-fallback'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
