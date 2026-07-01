import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/settings/profile_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/session_history_service.dart';

Widget _testApp(GoRouter router) {
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

GoRouter _router() {
  return GoRouter(
    initialLocation: '/profile',
    routes: [
      GoRoute(
        path: '/profile',
        builder: (_, __) => const Scaffold(body: ProfileScreen()),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const Scaffold(body: Text('onboarding-login')),
      ),
    ],
  );
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
  });

  testWidgets('Sign Out opens confirmation and Cancel closes it',
      (tester) async {
    await tester.pumpWidget(_testApp(_router()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('profile-sign-out')));
    await tester.tap(find.byKey(const ValueKey('profile-sign-out')));
    await tester.pumpAndSettle();

    expect(find.text('Sign out of Sterling Math?'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign Out'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out of Unified Math Tutor?'), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('confirmed Sign Out clears local session and routes onboarding',
      (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('guest_tips_used', 2);
    await SessionHistoryService.instance.add(
      PracticeSessionResult(
        stage: 'KS2',
        completedAt: DateTime(2026, 6, 29),
        questions: const [
          SessionQuestionResult(
            question: '1 + 1',
            options: ['1', '2'],
            correctIndex: 1,
            selectedIndex: 1,
          ),
        ],
      ),
    );

    await tester.pumpWidget(_testApp(_router()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('profile-sign-out')));
    await tester.tap(find.byKey(const ValueKey('profile-sign-out')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Sign Out'));
    await tester.pumpAndSettle();

    expect(find.text('onboarding-login'), findsOneWidget);
    expect(prefs.getInt('guest_tips_used'), isNull);
    expect(await SessionHistoryService.instance.load(), isEmpty);
  });
}
