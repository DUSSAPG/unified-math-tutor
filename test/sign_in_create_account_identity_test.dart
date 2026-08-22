import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/auth/create_account_screen.dart';
import 'package:unified_math_tutor/screens/auth/sign_in_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

/// Sign In / Create Account identity reconciliation.
///
/// These lock in behaviour that was already correct when audited (no code
/// change to sign_in_screen.dart/create_account_screen.dart was needed —
/// see the foundation implementation report) but had no regression coverage
/// until now.
Widget _testApp(GoRouter router) => MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );

GoRouter _signInRouter() => GoRouter(
      initialLocation: '/auth/sign-in',
      routes: [
        GoRoute(
          path: '/auth/sign-in',
          builder: (_, __) => const SignInScreen(),
        ),
        GoRoute(
          path: '/auth/forgot-password',
          builder: (_, __) => const Scaffold(body: Text('forgot-password')),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('home')),
        ),
      ],
    );

GoRouter _createAccountRouter() => GoRouter(
      initialLocation: '/auth/create',
      routes: [
        GoRoute(
          path: '/auth/create',
          builder: (_, __) => const CreateAccountScreen(),
        ),
        GoRoute(
          path: '/auth/sign-in',
          builder: (_, __) => const SignInScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('home')),
        ),
      ],
    );

Future<void> _fillAndSubmitSignIn(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), email); // Email
  await tester.enterText(fields.at(1), password); // Password
  final submit = find.widgetWithText(FilledButton, 'Sign In');
  await tester.ensureVisible(submit);
  await tester.tap(submit);
  await tester.pumpAndSettle();
}

Future<void> _fillAndSubmitCreateAccount(
  WidgetTester tester, {
  required String name,
  required String email,
  required String password,
}) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), name); // Name
  await tester.enterText(fields.at(1), email); // Email
  await tester.enterText(fields.at(2), password); // Password
  await tester.enterText(fields.at(3), password); // Confirm password
  final submit = find.widgetWithText(FilledButton, 'Create Account');
  await tester.ensureVisible(submit);
  await tester.tap(submit);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await LocalAccountService.instance.init();
  });

  group('Sign In', () {
    testWidgets(
        'signing in with only an email never writes the email or its '
        'prefix into the learner-facing preferred-name store', (tester) async {
      await tester.pumpWidget(_testApp(_signInRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitSignIn(
        tester,
        email: 'gerald@example.com',
        password: 'password1',
      );

      expect(find.text('home'), findsOneWidget);
      expect(
          OnboardingProfileService.instance.preferredDisplayName.value, isNull);
      // The account layer is allowed to derive a metadata display name from
      // the email prefix — that's LocalAccountService's own documented
      // behaviour — but it must never leak into the learner-facing store.
      expect(LocalAccountService.instance.state.displayName, 'gerald');
      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          isNot('gerald'));
      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          isNot('gerald@example.com'));
    });

    testWidgets('an existing guest preferred name survives sign-in unchanged',
        (tester) async {
      await OnboardingProfileService.instance.setPreferredDisplayName('Gerald');

      await tester.pumpWidget(_testApp(_signInRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitSignIn(
        tester,
        email: 'someone-else@example.com',
        password: 'password1',
      );

      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          'Gerald');
    });

    testWidgets('parent/teacher active learner identity survives sign-in',
        (tester) async {
      await OnboardingProfileService.instance.setUserType('parent');
      await LearnerProfilesService.instance.addLearner('Emily');

      await tester.pumpWidget(_testApp(_signInRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitSignIn(
        tester,
        email: 'parent@example.com',
        password: 'password1',
      );

      expect(LearnerProfilesService.instance.activeLearner?.name, 'Emily');
      expect(OnboardingProfileService.instance.childName.value, 'Emily');
    });

    testWidgets('leaves LocalAccountService signed in', (tester) async {
      await tester.pumpWidget(_testApp(_signInRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitSignIn(
        tester,
        email: 'gerald@example.com',
        password: 'password1',
      );

      expect(LocalAccountService.instance.state.isSignedIn, isTrue);
    });
  });

  group('Create Account', () {
    testWidgets(
        'initialises the learner-facing preferred name only when none exists',
        (tester) async {
      expect(
          OnboardingProfileService.instance.preferredDisplayName.value, isNull);

      await tester.pumpWidget(_testApp(_createAccountRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitCreateAccount(
        tester,
        name: 'Gerald',
        email: 'gerald@example.com',
        password: 'password1',
      );

      expect(find.text('home'), findsOneWidget);
      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          'Gerald');
    });

    testWidgets('does not overwrite a non-empty existing preferred name',
        (tester) async {
      await OnboardingProfileService.instance
          .setPreferredDisplayName('ExistingName');

      await tester.pumpWidget(_testApp(_createAccountRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitCreateAccount(
        tester,
        name: 'NewName',
        email: 'newname@example.com',
        password: 'password1',
      );

      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          'ExistingName');
    });

    testWidgets('leaves LocalAccountService signed in with the entered name',
        (tester) async {
      await tester.pumpWidget(_testApp(_createAccountRouter()));
      await tester.pumpAndSettle();

      await _fillAndSubmitCreateAccount(
        tester,
        name: 'Gerald',
        email: 'gerald@example.com',
        password: 'password1',
      );

      expect(LocalAccountService.instance.state.isSignedIn, isTrue);
      expect(LocalAccountService.instance.state.displayName, 'Gerald');
    });
  });

  group('Sign In / Create Account parity', () {
    testWidgets(
        'neither entry point ever puts an email-shaped string into the '
        'learner-facing preferred-name store on its own', (tester) async {
      // Sign In path.
      await tester.pumpWidget(_testApp(_signInRouter()));
      await tester.pumpAndSettle();
      await _fillAndSubmitSignIn(
        tester,
        email: 'first@example.com',
        password: 'password1',
      );
      expect(
          OnboardingProfileService.instance.preferredDisplayName.value, isNull);

      // Reset for the Create Account path in isolation.
      SharedPreferences.setMockInitialValues({});
      await OnboardingProfileService.instance.init();
      await LearnerProfilesService.instance.init();
      await LocalAccountService.instance.init();

      await tester.pumpWidget(_testApp(_createAccountRouter()));
      await tester.pumpAndSettle();
      await _fillAndSubmitCreateAccount(
        tester,
        name: 'A Real Name',
        email: 'second@example.com',
        password: 'password1',
      );
      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          'A Real Name');
      expect(OnboardingProfileService.instance.preferredDisplayName.value,
          isNot(contains('@')));
    });
  });
}
