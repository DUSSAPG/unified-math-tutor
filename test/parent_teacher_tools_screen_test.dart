import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/family_maths/family_maths_welcome_screen.dart';
import 'package:unified_math_tutor/screens/family_studio/family_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/settings/parent_cheat_sheet_screen.dart';
import 'package:unified_math_tutor/screens/settings/parent_teacher_tools_screen.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Learning Analytics (Parent-Teacher Tools / Parent PIN setup) — coverage
/// for the reported physical-device crash and the "Open Cheat Sheet" copy
/// question.
///
/// Root cause of the crash: unlike Feed the Hungry Panda's four sibling
/// services, `LocalPreferencesService` *was* already correctly registered
/// in `AppBootstrap`. The crash instead comes from this screen being
/// reachable before that registration's `init()` resolves — the splash
/// screen's tap-to-skip gesture, or its hard `_maxDisplay` timer, can
/// navigate onward regardless of whether bootstrap has actually finished
/// on a slow first launch. Fixed the same way as Panda: `_prefs` is
/// nullable, and `hasParentPin`/`verifyParentPin` return safe (`false`)
/// defaults instead of throwing when read before loading finishes — see
/// `late_prefs_init_hardening_test.dart` for the dedicated
/// before-init()-resolves coverage. This file covers the screen's normal,
/// already-initialized behaviour and the copy fix.
///
/// Copy fix: the primary button was always labelled "Open Cheat Sheet",
/// but on the very first use (no PIN yet) tapping it actually creates and
/// saves the PIN before navigating — "Open Cheat Sheet" misdescribed that
/// action. It's real, existing localized copy (`l10n.createParentPin`),
/// not new text, conditionally selected to match what the tap is about to
/// do — see `parent_teacher_tools_screen.dart`.
///
/// Cheat Sheet navigation fix (separate follow-up defect, same file): the
/// `cheat-sheet` GoRoute in lib/app/router.dart didn't redeclare
/// `parentNavigatorKey: _rootNavigatorKey` the way its `family-maths` and
/// `family-studio` sibling routes do — nested GoRoutes don't inherit a
/// parent's parentNavigatorKey, each must restate it. A push there landed
/// on the (not currently visible) Help branch's own shell Navigator
/// instead of the root navigator this whole screen already lives on, so
/// tapping through with a valid PIN produced no visible change and no
/// exception. Fixed by adding the missing key. The "Family Maths and
/// Family Studio gating" group below covers both the PIN flow and this
/// route-navigator fix together, including Back/system-back/Home and
/// confirming the sibling routes are unaffected.
void main() {
  const locale = Locale('en');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await FamilyActivityCatalogService.instance.all();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await OnboardingProfileService.instance.setUserType('parent');
    // The PIN-setup UI only renders once the Learning Analytics feature
    // itself is switched on — matches the realistic device state behind
    // the report (a parent who had already enabled it from Settings).
    await LocalPreferencesService.instance.setParentToolsEnabled(true);
  });

  Widget wrap(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1.0,
  }) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: child,
    );
  }

  group('First open, before any Parent PIN exists', () {
    testWidgets('renders with no exception and shows the Create PIN card',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      await tester.pumpWidget(wrap(const ParentTeacherToolsScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(l10n.createParentPin), findsWidgets);
    });

    testWidgets(
        'the primary action button reads "Create Parent PIN", not '
        '"Open Cheat Sheet", before a PIN exists', (tester) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      await tester.pumpWidget(wrap(const ParentTeacherToolsScreen()));
      await tester.pumpAndSettle();
      final button = tester.widget<FilledButton>(
          find.byKey(const Key('parentToolsPrimaryActionButton')));
      final label = (button.child! as Text).data;
      expect(label, l10n.createParentPin);
      expect(label, isNot(l10n.openCheatSheet));
    });
  });

  // Successfully creating/entering a PIN navigates via context.push(), which
  // needs a real GoRouter ancestor — the plain wrap() MaterialApp has none.
  // Only the two PIN-validation tests that stop before ever navigating
  // (too-short PIN, wrong PIN) can use the lighter plain wrap().
  Future<void> pumpRouter(WidgetTester tester) async {
    appRouter.go('/help/parent-teacher-tools');
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: appRouter,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    ));
    await tester.pumpAndSettle();
  }

  group('PIN validation', () {
    testWidgets('entering fewer than four digits shows an error, no crash',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      await tester.pumpWidget(wrap(const ParentTeacherToolsScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '12');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(l10n.pinMustBeFourDigits), findsOneWidget);
      expect(LocalPreferencesService.instance.hasParentPin, isFalse);
    });

    testWidgets(
        'entering four digits creates the PIN and opens the destination',
        (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(LocalPreferencesService.instance.hasParentPin, isTrue);
    });

    testWidgets(
        'returning and reopening: the button now reads "Open Cheat Sheet", '
        'and the correct PIN unlocks it', (tester) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      await LocalPreferencesService.instance.setParentPin('1234');

      await pumpRouter(tester);
      final button = tester.widget<FilledButton>(
          find.byKey(const Key('parentToolsPrimaryActionButton')));
      expect((button.child! as Text).data, l10n.openCheatSheet);

      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(l10n.pinIncorrect), findsNothing);
    });

    testWidgets('an incorrect PIN against an existing one shows an error',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(locale);
      await LocalPreferencesService.instance.setParentPin('1234');

      await tester.pumpWidget(wrap(const ParentTeacherToolsScreen()));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(l10n.pinIncorrect), findsOneWidget);
    });

    testWidgets(
        'rapid repeated taps on the primary action, before any PIN exists, '
        'produce no crash and create the PIN exactly once', (tester) async {
      // Taps in quick succession with no settle in between — the realistic
      // "nervous parent double/triple-taps while creating a brand-new PIN"
      // shape. Uses .first/an emptiness guard defensively: as soon as the
      // first tap's async work resolves and successfully navigates to the
      // Cheat Sheet, this button no longer exists in the tree at all, so
      // later loop iterations must no-op rather than fail on a missing
      // widget — that's what's being guarded here, not any navigation
      // defect.
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      for (var i = 0; i < 5; i++) {
        final finder = find.byKey(const Key('parentToolsPrimaryActionButton'));
        if (finder.evaluate().isEmpty) break;
        await tester.tap(finder.first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 10));
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('Family Maths and Family Studio gating (real router)', () {
    testWidgets('creating a PIN and opening Family Maths reaches the screen',
        (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.widgetWithText(
          OutlinedButton,
          (await AppLocalizations.delegate.load(locale))
              .familyMathsEntryTitle));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(FamilyMathsWelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'creating a PIN and opening Family Studio reaches the hub, no '
        'duplicate PIN prompt', (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.widgetWithText(OutlinedButton,
          (await AppLocalizations.delegate.load(locale)).familyStudioHubTitle));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(FamilyStudioHubScreen), findsOneWidget);
    });

    testWidgets(
        'a valid PIN visibly opens the Cheat Sheet route, on the intended '
        '(root) navigator', (tester) async {
      // Regression coverage for the previously-reported defect: unlike its
      // `family-maths` and `family-studio` sibling routes, the
      // `cheat-sheet` GoRoute in lib/app/router.dart didn't redeclare
      // `parentNavigatorKey: _rootNavigatorKey` — nested GoRoutes don't
      // inherit a parent's parentNavigatorKey, each must restate it — so a
      // push here landed on the Help branch's own (not currently visible)
      // shell Navigator instead of the root one ParentTeacherToolsScreen
      // itself is already showing on. No exception, just nothing visibly
      // changed. Fixed by adding the missing parentNavigatorKey, matching
      // the sibling routes exactly. Before that fix, this exact assertion
      // (`find.byType(ParentCheatSheetScreen)`) found zero widgets.
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ParentCheatSheetScreen), findsOneWidget);
      // The persistent bottom navigation bar belongs to the shell, not the
      // root navigator — its absence here confirms Cheat Sheet landed on
      // the same navigator tier as Parent-Teacher-Tools and its siblings,
      // not a second, separately-stacked shell instance.
      expect(find.byType(BottomNavigationBar), findsNothing);
    });

    testWidgets('an incomplete PIN does not navigate to the Cheat Sheet route',
        (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '12');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ParentCheatSheetScreen), findsNothing);
      expect(find.byType(ParentTeacherToolsScreen), findsOneWidget);
    });

    testWidgets('a wrong PIN does not navigate to the Cheat Sheet route',
        (tester) async {
      await LocalPreferencesService.instance.setParentPin('1234');
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ParentCheatSheetScreen), findsNothing);
      expect(find.byType(ParentTeacherToolsScreen), findsOneWidget);
    });

    testWidgets('Back from the Cheat Sheet returns to Learning Analytics',
        (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(find.byType(ParentCheatSheetScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ParentTeacherToolsScreen), findsOneWidget);
      expect(find.byType(ParentCheatSheetScreen), findsNothing);
    });

    testWidgets(
        'the Android system back gesture from the Cheat Sheet behaves the '
        'same as the in-app Back button', (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(find.byType(ParentCheatSheetScreen), findsOneWidget);

      // ParentCheatSheetScreen has no PopScope/WillPopScope of its own, so
      // the system back gesture falls through to Flutter's default
      // handling — Navigator.maybePop() on the enclosing Navigator — the
      // exact same call the in-app Back IconButton's popOrGo() makes.
      // Invoked directly here rather than via WidgetTester.pageBack()
      // (which only recognises the Material/Cupertino BackButton widget
      // types, not this screen's plain IconButton) or the deprecated
      // handlePopRoute() API.
      final navigator =
          Navigator.of(tester.element(find.byType(ParentCheatSheetScreen)));
      final popped = await navigator.maybePop();
      await tester.pumpAndSettle();
      expect(popped, isTrue);
      expect(tester.takeException(), isNull);
      expect(find.byType(ParentTeacherToolsScreen), findsOneWidget);
    });

    testWidgets(
        'navigating Home from the Cheat Sheet restores the persistent '
        'bottom navigation with no exception', (tester) async {
      await pumpRouter(tester);
      await tester.enterText(find.byType(TextField), '1234');
      await tester.tap(find.byKey(const Key('parentToolsPrimaryActionButton')));
      await tester.pumpAndSettle();
      expect(find.byType(ParentCheatSheetScreen), findsOneWidget);

      appRouter.go('/home');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget,
          reason: 'the persistent bottom nav must come back intact — proves '
              'the router-key fix did not disturb the shell/root navigator '
              'relationship elsewhere in the app');
    });
  });

  group('Theme and Reading Size coverage', () {
    testWidgets('renders without exception in dark theme', (tester) async {
      await tester.pumpWidget(
          wrap(const ParentTeacherToolsScreen(), themeMode: ThemeMode.dark));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('no overflow at text scale $scale', (tester) async {
        await tester.pumpWidget(
            wrap(const ParentTeacherToolsScreen(), textScale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Responsive / no overflow', () {
    Future<void> pumpAtSize(WidgetTester tester, Size size) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(wrap(const ParentTeacherToolsScreen()));
      await tester.pumpAndSettle();
    }

    testWidgets('no overflow on a compact phone (320x568)', (tester) async {
      await pumpAtSize(tester, const Size(320, 568));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow at Pixel 6a dimensions (412x915)', (tester) async {
      await pumpAtSize(tester, const Size(412, 915));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow at a common phone size (390x844)', (tester) async {
      await pumpAtSize(tester, const Size(390, 844));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow on a tablet-sized viewport (768x1024)',
        (tester) async {
      await pumpAtSize(tester, const Size(768, 1024));
      expect(tester.takeException(), isNull);
    });
  });
}
