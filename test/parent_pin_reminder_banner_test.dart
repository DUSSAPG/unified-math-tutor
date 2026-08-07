import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/settings/parent_teacher_tools_screen.dart';
import 'package:unified_math_tutor/services/discovery_card_catalog_service.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/recall_card_catalog_service.dart';
import 'package:unified_math_tutor/services/recall_cards_progress_service.dart';

/// Covers both halves of Sprint 3 — Parent PIN Reminder: the pure
/// frequency-policy logic on [LocalPreferencesService], and the banner's
/// actual on-screen behaviour on the real Family Studio hub route.
void main() {
  const locale = Locale('en');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await DiscoveryCardCatalogService.instance.all();
    await RecallCardCatalogService.instance.all();
    await FamilyActivityCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await RecallCardsProgressService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    await MentalMathsProgressService.instance.init();
    await OnboardingProfileService.instance.setUserType('parent');
    LocalPreferencesService.instance.grantFamilyStudioGraceAccess();
  });

  group('LocalPreferencesService.shouldShowParentPinReminder', () {
    test('is due on the very first check (never shown, no PIN)', () {
      expect(LocalPreferencesService.instance.shouldShowParentPinReminder(),
          isTrue);
    });

    test('is false once a PIN exists, regardless of last-shown state',
        () async {
      await LocalPreferencesService.instance.setParentPin('1234');
      expect(LocalPreferencesService.instance.shouldShowParentPinReminder(),
          isFalse);
    });

    test('is false immediately after being recorded as shown', () async {
      final prefs = LocalPreferencesService.instance;
      final now = DateTime(2026, 1, 1);
      await prefs.recordParentPinReminderShown(now);
      expect(prefs.shouldShowParentPinReminder(now), isFalse);
      expect(
          prefs.shouldShowParentPinReminder(now.add(const Duration(days: 3))),
          isFalse);
    });

    test('becomes due again once the documented interval has elapsed',
        () async {
      final prefs = LocalPreferencesService.instance;
      final shownAt = DateTime(2026, 1, 1);
      await prefs.recordParentPinReminderShown(shownAt);

      expect(
          prefs.shouldShowParentPinReminder(
              shownAt.add(const Duration(days: 6))),
          isFalse,
          reason: 'still within the 7-day cooldown');
      expect(
          prefs.shouldShowParentPinReminder(
              shownAt.add(LocalPreferencesService.parentPinReminderInterval)),
          isTrue,
          reason: 'exactly at the documented interval, due again');
    });

    test('documented interval is 7 days', () {
      expect(LocalPreferencesService.parentPinReminderInterval,
          const Duration(days: 7));
    });
  });

  group('ParentPinReminderBanner on the Family Studio hub', () {
    Widget app() => MaterialApp.router(
          routerConfig: appRouter,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );

    Future<AppLocalizations> pumpHub(WidgetTester tester) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      appRouter.go('/family-studio');
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      return l10n;
    }

    testWidgets('appears on a first, PIN-less visit', (tester) async {
      final l10n = await pumpHub(tester);
      expect(find.text(l10n.familyStudioPinReminderTitle), findsOneWidget);
      expect(find.text(l10n.familyStudioPinReminderBody), findsOneWidget);
      expect(
          find.text(l10n.familyStudioPinReminderSetPinButton), findsOneWidget);
      expect(
          find.text(l10n.familyStudioPinReminderLaterButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('never appears once a Parent PIN exists', (tester) async {
      await LocalPreferencesService.instance.setParentPin('1234');
      final l10n = await pumpHub(tester);
      expect(find.text(l10n.familyStudioPinReminderTitle), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not reappear while the cooldown is still active',
        (tester) async {
      await LocalPreferencesService.instance
          .recordParentPinReminderShown(DateTime.now());
      final l10n = await pumpHub(tester);
      expect(find.text(l10n.familyStudioPinReminderTitle), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('"Remind Me Later" dismisses it without blocking the hub',
        (tester) async {
      final l10n = await pumpHub(tester);
      expect(find.text(l10n.familyStudioPinReminderTitle), findsOneWidget);

      await tester.tap(find.text(l10n.familyStudioPinReminderLaterButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.familyStudioPinReminderTitle), findsNothing);
      // The hub itself is still fully usable — dismissing never navigates
      // away or blocks anything else on the page.
      expect(find.text(l10n.familyStudioHubOpeningPromise), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Dismissing also starts the cooldown, exactly like actually being
      // shown does — a parent who says "later" isn't asked again next visit.
      expect(LocalPreferencesService.instance.parentPinReminderLastShownAt,
          isNotNull);
    });

    testWidgets(
        '"Set PIN" opens the real, existing Parent/Teacher Tools PIN flow',
        (tester) async {
      final l10n = await pumpHub(tester);

      await tester.tap(find.text(l10n.familyStudioPinReminderSetPinButton));
      await tester.pumpAndSettle();

      expect(find.byType(ParentTeacherToolsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
