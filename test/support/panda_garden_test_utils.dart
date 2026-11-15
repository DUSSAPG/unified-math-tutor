import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import 'package:unified_math_tutor/services/feed_the_hungry_panda_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';
import 'package:unified_math_tutor/widgets/labs/feed_panda/fruit_tile.dart';

/// Shared helpers for the Panda Garden V1 tests. Mirrors the setup used by
/// test/feed_the_hungry_panda_widget_test.dart. No `main()`.

final pandaL10n = lookupAppLocalizations(const Locale('en'));

const portrait = Size(390, 844);
const landscape = Size(844, 390);

Future<void> resetPandaServices({bool reduceMotion = false}) async {
  SharedPreferences.setMockInitialValues({});
  await LocalPreferencesService.instance.init();
  await OnboardingProfileService.instance.init();
  await LearnerProfilesService.instance.init();
  await FeedTheHungryPandaProgressService.instance.init();
  await LocalPreferencesService.instance.setReduceMotion(reduceMotion);
}

Future<void> pumpPandaGarden(
  WidgetTester tester, {
  int seed = 100,
  Size size = portrait,
  ThemeMode themeMode = ThemeMode.light,
  double textScale = 1.0,
}) async {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(MaterialApp(
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
    home: FeedTheHungryPandaScreen(initialSeed: seed),
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

final Finder dropTarget = find.byKey(const Key('feedPandaDropTarget'));
final Finder feedingArea = find.byKey(const Key('feedPandaFeedingArea'));
final Finder bowlApples = find.byWidgetPredicate((w) {
  final key = w.key;
  return key is ValueKey<String> && key.value.startsWith('feedPandaBowlApple_');
});

(int, int) readProgress(WidgetTester tester) {
  final text = tester
      .widget<Text>(find.byKey(const Key('feedPandaProgressCaption')))
      .data!;
  final parts = text.split(' / ');
  return (int.parse(parts[0]), int.parse(parts[1]));
}

int visibleApples() => find.byType(FruitTile).evaluate().length;

/// Drags the first apple in the basket onto Panda's feeding area.
Future<void> dragFirstAppleToPanda(WidgetTester tester) async {
  final apple = find.byType(FruitTile).first;
  await tester.ensureVisible(apple);
  await tester.pump();
  final start = tester.getCenter(apple);
  final gesture = await tester.startGesture(start);
  await gesture.moveBy(const Offset(0, 20));
  await tester.pump();
  await tester.ensureVisible(dropTarget);
  final end = tester.getCenter(dropTarget);
  await gesture.moveTo(end);
  await tester.pump();
  await gesture.up();
  await tester.pump();
}

/// The tap alternative: tap an apple, then tap Panda.
Future<void> tapFeedOneApple(WidgetTester tester) async {
  final apple = find.byType(FruitTile).first;
  await tester.ensureVisible(apple);
  await tester.tap(apple);
  await tester.pump();
  await tester.ensureVisible(feedingArea);
  await tester.tap(feedingArea);
  await tester.pump();
}

/// Feeds Panda up to its target with the tap path, then waits out the
/// chew transition so "How many apples are left?" is showing.
Future<void> feedToTargetAndSettle(WidgetTester tester) async {
  final (_, target) = readProgress(tester);
  for (var i = 0; i < target; i++) {
    await tapFeedOneApple(tester);
  }
  await tester.pump(const Duration(milliseconds: 800));
  await tester.pump();
}

/// Asserts there are no layout overflows or other framework exceptions.
void expectNoLayoutErrors(WidgetTester tester) {
  expect(tester.takeException(), isNull);
}
