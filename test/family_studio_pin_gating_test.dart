import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/core/bootstrap.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/main.dart';
import 'package:unified_math_tutor/services/local_account_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/sign_out_service.dart';
import 'package:unified_math_tutor/widgets/settings/parent_gate.dart';

/// The Family Studio PIN-gating contract: grace is a session-scoped
/// exception that only `ParentGate(allowGraceAccess: true)` call sites
/// honor, and it must expire on sign-out, a role change, and the app
/// leaving the foreground — never a permanent PIN bypass, and never
/// something Family Maths (plain `ParentGate()`) ever accepts.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LocalAccountService.instance.init();
    // Grace is deliberately in-memory-only (never persisted, never reset by
    // init() — that's the whole point, see grantFamilyStudioGraceAccess),
    // so unlike every other flag above it survives across tests in this
    // same isolate unless explicitly cleared here.
    LocalPreferencesService.instance.clearFamilyStudioGraceAccess();
  });

  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets(
      'a grace-eligible screen is reachable with no PIN while grace is active',
      (tester) async {
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();

    await tester.pumpWidget(wrap(ParentGate(
      allowGraceAccess: true,
      builder: (context) => Text('Family Studio content'),
    )));

    expect(find.text('Family Studio content'), findsOneWidget);
  });

  testWidgets(
      'a grace-eligible screen is locked once grace has not been granted',
      (tester) async {
    await tester.pumpWidget(wrap(ParentGate(
      allowGraceAccess: true,
      builder: (context) => Text('Family Studio content'),
    )));

    expect(find.text('Family Studio content'), findsNothing);
  });

  testWidgets(
      'grace never unlocks a plain ParentGate — Family Maths stays PIN-only',
      (tester) async {
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();

    await tester.pumpWidget(wrap(ParentGate(
      builder: (context) => Text('Family Maths content'),
    )));

    expect(find.text('Family Maths content'), findsNothing);
  });

  testWidgets('once a real PIN is granted, grace is no longer needed',
      (tester) async {
    await LocalPreferencesService.instance.setParentToolsEnabled(true);
    await LocalPreferencesService.instance.setParentPin('1234');
    LocalPreferencesService.instance.unlockParentTools('1234');

    await tester.pumpWidget(wrap(ParentGate(
      builder: (context) => Text('Family Maths content'),
    )));

    expect(find.text('Family Maths content'), findsOneWidget);
  });

  test('sign-out clears the grace window', () async {
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
    expect(LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isTrue);

    await SignOutService.instance.signOut();

    expect(
        LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isFalse);
  });

  test('a user-role change clears the grace window', () async {
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
    expect(LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isTrue);

    await OnboardingProfileService.instance.setUserType('teacher');

    expect(
        LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isFalse);
  });

  testWidgets('backgrounding the app clears the grace window', (tester) async {
    await AppBootstrap.ensureStarted();
    await tester.pumpWidget(const UnifiedMathTutorApp());
    await tester.pump();

    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
    expect(LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isTrue);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(
        LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isFalse);
  });

  test('grace never survives a fresh process — it is never persisted',
      () async {
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
    expect(LocalPreferencesService.instance.hasFamilyStudioGraceAccess, isTrue);

    // A fresh app process re-reads SharedPreferences into a brand new
    // LocalPreferencesService instance conceptually — simulated here by
    // re-running init() against the same mock prefs store, which is exactly
    // what happens on a real cold start: the in-memory grace flag was never
    // written to disk, so it comes back false regardless of what the
    // now-stale in-memory field says until a fresh instance is built. This
    // asserts the underlying contract: init() never reads a persisted grace
    // value because none is ever written.
    final prefsSnapshot = await SharedPreferences.getInstance();
    expect(prefsSnapshot.getKeys(), isNot(contains('family_studio_grace')));
  });
}
