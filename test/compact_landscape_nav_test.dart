import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/services/compact_landscape_nav_preference_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';
import 'package:unified_math_tutor/services/nav_visibility_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/streak_service.dart';
import 'package:unified_math_tutor/shared/responsive/app_breakpoints.dart';
import 'package:unified_math_tutor/widgets/navigation/compact_landscape_nav_bar.dart';

/// D2.1 Phase A — compact-landscape root navigation.
const _pixel6aLandscape = Size(915, 412);
const _pixel6aPortrait = Size(412, 915);
const _tabletLandscape = Size(1024, 768);

Future<void> _pumpHome(WidgetTester tester, Size size) async {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;

  appRouter.go('/home');
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: appRouter,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    ),
  );
  await tester.pump();
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await StreakService.instance.init();
    await MascotFuelService.instance.init();
    await OnboardingProfileService.instance.init();
    CompactLandscapeNavPreferenceService.instance.resetForTests();
    NavVisibilityService.instance.show();
  });

  group('AppResponsive.isCompactLandscapePhone', () {
    testWidgets('true for Pixel 6a landscape', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }));
      tester.view.physicalSize = _pixel6aLandscape;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pump();
      expect(AppResponsive.isCompactLandscapePhone(ctx), isTrue);
    });

    testWidgets('false for Pixel 6a portrait', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }));
      tester.view.physicalSize = _pixel6aPortrait;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pump();
      expect(AppResponsive.isCompactLandscapePhone(ctx), isFalse);
    });

    testWidgets('false for tablet landscape (has height to spare)',
        (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(Builder(builder: (context) {
        ctx = context;
        return const SizedBox();
      }));
      tester.view.physicalSize = _tabletLandscape;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pump();
      expect(AppResponsive.isCompactLandscapePhone(ctx), isFalse);
    });
  });

  group('CompactLandscapeNavPreferenceService', () {
    test('defaults to not collapsed', () async {
      await CompactLandscapeNavPreferenceService.instance.init();
      expect(CompactLandscapeNavPreferenceService.instance.collapsed.value,
          isFalse);
    });

    test('persists across a simulated restart', () async {
      await CompactLandscapeNavPreferenceService.instance.init();
      await CompactLandscapeNavPreferenceService.instance.setCollapsed(true);
      CompactLandscapeNavPreferenceService.instance.resetForTests();
      await CompactLandscapeNavPreferenceService.instance.init();
      expect(CompactLandscapeNavPreferenceService.instance.collapsed.value,
          isTrue);
    });

    test('toggle flips the value', () async {
      await CompactLandscapeNavPreferenceService.instance.init();
      await CompactLandscapeNavPreferenceService.instance.toggle();
      expect(CompactLandscapeNavPreferenceService.instance.collapsed.value,
          isTrue);
      await CompactLandscapeNavPreferenceService.instance.toggle();
      expect(CompactLandscapeNavPreferenceService.instance.collapsed.value,
          isFalse);
    });
  });

  group('AppShell — compact landscape presentation', () {
    testWidgets(
        'portrait Pixel 6a keeps the established BottomNavigationBar '
        'unchanged', (tester) async {
      await _pumpHome(tester, _pixel6aPortrait);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(CompactLandscapeNavBar), findsNothing);
    });

    testWidgets(
        'Pixel 6a landscape shows the compact bar, initially visible, not '
        'the portrait bar', (tester) async {
      await _pumpHome(tester, _pixel6aLandscape);
      expect(find.byType(CompactLandscapeNavBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(CompactLandscapeNavHandle), findsNothing);
    });

    testWidgets(
        'tapping the explicit Hide navigation control collapses to the '
        'Show navigation handle, and the body genuinely reclaims height '
        '(the handle is shorter than the bar)', (tester) async {
      await _pumpHome(tester, _pixel6aLandscape);
      expect(find.byType(CompactLandscapeNavBar), findsOneWidget);

      await tester.tap(find.byKey(const Key('compactLandscapeNavHideButton')));
      await tester.pumpAndSettle();

      expect(find.byType(CompactLandscapeNavBar), findsNothing);
      expect(find.byType(CompactLandscapeNavHandle), findsOneWidget);
      // The handle is a real, visible, accessible control — not zero-sized
      // "invisible padding" — but shorter than the full compact bar, so the
      // body above it is taller.
      final handleHeight =
          tester.getSize(find.byType(CompactLandscapeNavHandle)).height;
      expect(handleHeight, lessThan(CompactLandscapeNavBar.height));
      expect(handleHeight, greaterThan(0));
    });

    testWidgets('the Show navigation handle restores the full compact bar',
        (tester) async {
      await _pumpHome(tester, _pixel6aLandscape);
      await tester.tap(find.byKey(const Key('compactLandscapeNavHideButton')));
      await tester.pumpAndSettle();
      expect(find.byType(CompactLandscapeNavHandle), findsOneWidget);

      await tester.tap(find.byKey(const Key('compactLandscapeNavShowHandle')));
      await tester.pumpAndSettle();

      expect(find.byType(CompactLandscapeNavBar), findsOneWidget);
      expect(find.byType(CompactLandscapeNavHandle), findsNothing);
    });

    testWidgets(
        'double-tapping the compact bar is an additional shortcut to '
        'collapse — it is not the only way (the explicit button already '
        'covered above)', (tester) async {
      await _pumpHome(tester, _pixel6aLandscape);
      // Tap on a destination icon (inside the double-tap detector's
      // subtree) rather than the bar's own geometric centre, which is not
      // guaranteed to land inside that subtree.
      final homeIcon = find.byWidgetPredicate(
        (w) => w is Tooltip && w.message == 'Home',
      );
      await tester.tap(homeIcon, warnIfMissed: false);
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(homeIcon, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(CompactLandscapeNavHandle), findsOneWidget);
    });

    testWidgets(
        'selecting a destination on the compact bar navigates and '
        'preserves the collapse-state mechanism (branch switch does not '
        'crash or lose the bar)', (tester) async {
      await _pumpHome(tester, _pixel6aLandscape);
      final topicsIcon = find.byWidgetPredicate(
        (w) => w is Tooltip && w.message == 'Topics',
      );
      expect(topicsIcon, findsOneWidget);
      await tester.tap(topicsIcon);
      await tester.pumpAndSettle();
      expect(find.byType(CompactLandscapeNavBar), findsOneWidget);
    });

    testWidgets(
        'an active session (NavVisibilityService.hide()) still hides all '
        'chrome in compact landscape too — existing integrity rule is '
        'preserved', (tester) async {
      await _pumpHome(tester, _pixel6aLandscape);
      expect(find.byType(CompactLandscapeNavBar), findsOneWidget);

      NavVisibilityService.instance.hide();
      await tester.pumpAndSettle();

      expect(find.byType(CompactLandscapeNavBar), findsNothing);
      expect(find.byType(CompactLandscapeNavHandle), findsNothing);
      expect(find.byType(BottomNavigationBar), findsNothing);
    });
  });
}
