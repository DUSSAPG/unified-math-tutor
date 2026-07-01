import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/packs/exam_packs_screen.dart';
import 'package:unified_math_tutor/screens/practice/practice_screen.dart';
import 'package:unified_math_tutor/screens/topics/topics_screen.dart';

void main() {
  testWidgets('Practice topic filter navigates without index errors',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/topics',
      routes: [
        GoRoute(
          path: '/topics',
          builder: (_, __) => const Scaffold(body: TopicsScreen()),
        ),
        GoRoute(
          path: '/practice',
          builder: (_, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return Scaffold(
              body: PracticeScreen(
                selectedTopic: extra?['topic'] as String?,
                selectedTopicId: extra?['topicId'] as String?,
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
    await tester.tap(find.text('Number & Place Value').first);
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
