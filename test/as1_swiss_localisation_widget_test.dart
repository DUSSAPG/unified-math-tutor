import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/screens/labs/early_maths_playground_hub_screen.dart';
import 'package:unified_math_tutor/screens/onboarding/accessibility_step_screen.dart';
import 'package:unified_math_tutor/screens/settings/accessibility_screen.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

import 'support/early_maths_entry_test_utils.dart';

/// AS-1, locale-aware accessibility names and selection semantics in the
/// Swiss production locales (de_CH, fr_CH, it_CH), with English as the
/// control: Settings > Accessibility, the onboarding accessibility step and
/// the Early Maths lane chooser speak the active language, the Reading Size
/// option keys are the same in every locale, and selection still works
/// through the screen reader.
const _ids = ['small', 'default', 'large'];
const _scales = [0.9, 1.0, 1.15];

/// English UI strings of the audited widgets that must not appear in a Swiss
/// locale.
const _englishSettings = [
  'Accessibility',
  'Adjust for comfort and readability',
  'Reading Size',
  'Choose a comfortable reading size',
  'Small',
  'Default',
  'Large',
  'Reduce Motion',
  'Minimise animations and transitions',
  'Quiet Study Mode',
  'Sound Cues',
  'Short, optional sounds for Interactive Labs actions',
];
const _englishLanes = [
  'Choose a starting point',
  'Early Maths Play',
  'KS1 Maths Foundations',
  "I'm not sure",
  'For grown-ups',
  'Activities to try',
  'A gentle first step',
];

const _locales = [
  Locale('en'),
  Locale('de', 'CH'),
  Locale('fr', 'CH'),
  Locale('it', 'CH'),
];

Future<AppLocalizations> _pump(WidgetTester tester, Locale locale, Widget home,
    {Size size = const Size(1170, 2532), double ratio = 3.0}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = ratio;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(
    theme: AppTheme.light(),
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  ));
  await tester.pumpAndSettle();
  return lookupAppLocalizations(locale);
}

Future<void> _initPrefs({double textScale = 1.0}) async {
  SharedPreferences.setMockInitialValues({'text_scale': textScale});
  await LocalPreferencesService.instance.init();
}

/// Visible text, either as written or as a [SectionLabel] renders it
/// (upper case).
Finder _textOrSectionLabel(String text) => find.byWidgetPredicate(
    (w) => w is Text && (w.data == text || w.data == text.toUpperCase()));

void _expectNoEnglish(List<String> english, Locale locale) {
  if (locale.languageCode == 'en') return;
  for (final text in english) {
    expect(_textOrSectionLabel(text), findsNothing,
        reason: '"$text" is English in $locale');
    expect(
      find.semantics
          .byPredicate((n) => n.getSemanticsData().label.contains(text)),
      findsNothing,
      reason: 'a screen reader would speak "$text" in English in $locale',
    );
  }
}

/// The Reading Size options are found by their stable keys and announce the
/// localised name, button role and single-choice selection.
void _expectReadingSize(
    WidgetTester tester, AppLocalizations l, String keyPrefix, int selected) {
  final labels = [
    l.accessibilityReadingSizeSmall,
    l.accessibilityReadingSizeDefault,
    l.accessibilityReadingSizeLarge,
  ];
  for (var i = 0; i < _ids.length; i++) {
    final option = find.byKey(Key('$keyPrefix${_ids[i]}'));
    expect(option, findsOneWidget, reason: 'stable key for ${_ids[i]}');
    expect(
      tester.getSemantics(option),
      isSemantics(
        label: labels[i],
        isButton: true,
        isInMutuallyExclusiveGroup: true,
        hasSelectedState: true,
        isSelected: i == selected,
        hasTapAction: true,
        isFocusable: true,
      ),
      reason: '${_ids[i]} in ${l.localeName}',
    );
  }
}

/// The switch for [title] is one stop that starts with the localised name,
/// includes the localised description and reports [on].
void _expectSwitch(String title, String subtitle, bool on) {
  final node = find.semantics.byPredicate((n) {
    final d = n.getSemanticsData();
    return d.flagsCollection.isToggled != Tristate.none &&
        d.label.startsWith(title);
  });
  expect(node, findsOneWidget, reason: title);
  final d = node.evaluate().single.getSemanticsData();
  expect(d.label, contains(subtitle), reason: title);
  expect(d.flagsCollection.isToggled, on ? Tristate.isTrue : Tristate.isFalse,
      reason: '$title state');
  expect(d.hasAction(SemanticsAction.tap), isTrue, reason: title);
}

void main() {
  // The parent-led section reads the real Family Maths catalogue.
  setUpAll(preloadCrashRegressionCatalogs);

  for (final locale in _locales) {
    group('$locale', () {
      testWidgets('Settings > Accessibility speaks the active language',
          (tester) async {
        final handle = tester.ensureSemantics();
        await _initPrefs();
        final l = await _pump(tester, locale, const AccessibilityScreen());

        expect(find.text(l.profileAccessibility), findsOneWidget);
        expect(find.text(l.accessibilitySettingsSubtitle), findsOneWidget);
        expect(find.text(l.appearanceReadingSizeTitle), findsOneWidget);
        expect(find.text(l.accessibilityReadingSizeSubtitle), findsOneWidget);
        _expectReadingSize(tester, l, 'readingSizeOption-', 1);
        _expectSwitch(l.accessibilityReduceMotionTitle,
            l.accessibilityReduceMotionSubtitle, false);
        _expectSwitch(l.quietStudyModeLabel,
            l.accessibilityQuietStudyModeSubtitle, false);
        _expectSwitch(
            l.accessibilitySoundCuesTitle,
            l.accessibilitySoundCuesSubtitle,
            LocalPreferencesService.instance.soundEnabled.value);
        _expectNoEnglish(_englishSettings, locale);

        // Selecting through the screen reader works in this locale and
        // stores the unchanged preference values.
        for (final i in [2, 0, 1]) {
          tester.semantics.tap(find.semantics.byPredicate((n) =>
              n.getSemanticsData().label ==
              [
                l.accessibilityReadingSizeSmall,
                l.accessibilityReadingSizeDefault,
                l.accessibilityReadingSizeLarge,
              ][i]));
          await tester.pumpAndSettle();
          _expectReadingSize(tester, l, 'readingSizeOption-', i);
          expect(
              (await SharedPreferences.getInstance()).getDouble('text_scale'),
              _scales[i]);
        }
        tester.semantics.tap(find.semantics.byPredicate((n) {
          final d = n.getSemanticsData();
          return d.flagsCollection.isToggled != Tristate.none &&
              d.label.startsWith(l.accessibilityReduceMotionTitle);
        }));
        await tester.pumpAndSettle();
        _expectSwitch(l.accessibilityReduceMotionTitle,
            l.accessibilityReduceMotionSubtitle, true);
        expect(LocalPreferencesService.instance.reduceMotion.value, isTrue);
        handle.dispose();
      });

      testWidgets(
          'the onboarding accessibility step speaks the active '
          'language', (tester) async {
        final handle = tester.ensureSemantics();
        await _initPrefs(textScale: 1.15);
        final l = await _pump(tester, locale, const AccessibilityStepScreen());

        expect(find.text(l.onboardingAccessibilityTitle), findsOneWidget);
        expect(find.text(l.appearanceReadingSizeTitle), findsOneWidget);
        expect(find.text(l.accessibilityReadingSizeSubtitle), findsOneWidget);
        expect(find.text(l.onboardingTimeEstimateSeconds(15)), findsOneWidget);
        _expectReadingSize(tester, l, 'onboardingReadingSizeOption-', 2);
        _expectSwitch(l.accessibilityReduceMotionTitle,
            l.accessibilityReduceMotionSubtitle, false);
        _expectNoEnglish([..._englishSettings, '~15 seconds'], locale);

        tester.semantics.tap(find.semantics.byPredicate((n) =>
            n.getSemanticsData().label == l.accessibilityReadingSizeSmall));
        await tester.pumpAndSettle();
        _expectReadingSize(tester, l, 'onboardingReadingSizeOption-', 0);
        expect((await SharedPreferences.getInstance()).getDouble('text_scale'),
            0.9);
        handle.dispose();
      });

      testWidgets('the Early Maths lane chooser speaks the active language',
          (tester) async {
        await initEarlyMathsEntryServices();
        final handle = tester.ensureSemantics();
        final l = await _pump(
            tester, locale, const EarlyMathsPlaygroundHubScreen(),
            size: const Size(1280, 2400), ratio: 1);

        final lanes = {
          EarlyMathsLane.earlyMathsPlay: (
            l.earlyMathsLanePlayTitle,
            l.earlyMathsLanePlayAges
          ),
          EarlyMathsLane.ks1MathsFoundations: (
            l.earlyMathsLaneKs1Title,
            l.earlyMathsLaneKs1Ages
          ),
          EarlyMathsLane.notSure: (
            l.earlyMathsLaneNotSureTitle,
            l.earlyMathsLaneNotSureSubtitle
          ),
        };

        expect(
            _textOrSectionLabel(l.earlyMathsLaneChooserLabel), findsOneWidget);
        void expectLanes(EarlyMathsLane? selected) {
          for (final MapEntry(key: lane, value: (title, subtitle))
              in lanes.entries) {
            final node = find.semantics.byPredicate(
                (n) => n.getSemanticsData().label == '$title. $subtitle');
            expect(node, findsOneWidget, reason: '$lane in $locale');
            final d = node.evaluate().single.getSemanticsData();
            expect(d.flagsCollection.isButton, isTrue);
            expect(d.flagsCollection.isSelected,
                lane == selected ? Tristate.isTrue : Tristate.isFalse,
                reason: '$lane selected in $locale');
          }
        }

        expectLanes(null);
        final (ks1Title, ks1Ages) = lanes[EarlyMathsLane.ks1MathsFoundations]!;
        tester.semantics.tap(find.semantics.byPredicate(
            (n) => n.getSemanticsData().label == '$ks1Title. $ks1Ages'));
        await tester.pumpAndSettle();
        expectLanes(EarlyMathsLane.ks1MathsFoundations);
        expect(
            _textOrSectionLabel(l.earlyMathsActivitiesHeading), findsOneWidget);
        expect(_textOrSectionLabel(l.earlyMathsAbacusTitle), findsOneWidget);
        expect(_textOrSectionLabel(l.earlyMathsParentHeading), findsOneWidget);
        // The parent-led titles line substitutes its placeholder.
        final titlesLine = tester
            .widget<Text>(find.byKey(const Key('earlyMathsParentLedTitles')));
        expect(titlesLine.data, isNot(contains('{')));
        expect(titlesLine.data,
            startsWith(l.earlyMathsParentTitlesLine('').trimRight()));
        _expectNoEnglish(_englishLanes, locale);
        handle.dispose();
      });
    });
  }
}
