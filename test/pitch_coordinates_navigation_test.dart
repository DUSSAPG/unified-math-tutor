import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/app/router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/labs/applied_maths_studio_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/create_angle/create_angle_screen.dart';
import 'package:unified_math_tutor/screens/labs/interactive_labs_hub_screen.dart';
import 'package:unified_math_tutor/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/widgets/shared/route_link_card.dart';

/// Pitch Coordinates is reached Interactive Labs → Applied Maths Studio →
/// Pitch Coordinates, through one card placed right after Create the Angle,
/// and Back returns to the studio. Uses the real [appRouter].
void main() {
  const labsPath = '/math-studio/interactive-labs';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
  });

  Future<void> pumpAt(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    appRouter.go(location);
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: appRouter,
      locale: const Locale('en'),
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

  String path() => appRouter.routerDelegate.currentConfiguration.uri.path;

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  test('the route is a sibling of Create the Angle under the studio', () {
    expect(pitchCoordinatesPath,
        '/math-studio/interactive-labs/applied-maths-studio/pitch-coordinates');
    expect(pitchCoordinatesPath.replaceFirst('pitch-coordinates', ''),
        createAnglePath.replaceFirst('create-the-angle', ''));
  });

  testWidgets('one card, immediately after Create the Angle, grid icon',
      (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    final cards =
        tester.widgetList<RouteLinkCard>(find.byType(RouteLinkCard)).toList();
    final titles = cards.map((c) => c.title).toList();
    expect(titles.where((t) => t == 'Pitch Coordinates').length, 1);
    expect(titles.indexOf('Pitch Coordinates'),
        titles.indexOf('Create the Angle') + 1);
    final card = tester.widget<RouteLinkCard>(
        find.byKey(const Key('pitchCoordinatesEntryCard')));
    expect(card.icon, LucideIcons.grid);
    expect(card.subtitle, 'Find and move players using coordinates on a grid.');
    expect(
        tester
            .widget<Text>(find.byKey(const Key('pitchCoordinatesKindLabel')))
            .data,
        'Applied exploration');
    // The card sits below the Create the Angle card on screen.
    expect(
        tester
            .getTopLeft(find.byKey(const Key('pitchCoordinatesEntryCard')))
            .dy,
        greaterThan(tester
            .getTopLeft(find.byKey(const Key('createAngleEntryCard')))
            .dy));
  });

  testWidgets('Interactive Labs → studio → Pitch Coordinates → Back → Back',
      (tester) async {
    await pumpAt(tester, labsPath);
    await tap(tester, find.byKey(const Key('appliedMathsStudioEntryCard')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('pitchCoordinatesEntryCard')));
    expect(find.byType(PitchCoordinatesScreen), findsOneWidget);

    await tap(tester, find.byKey(const Key('pitchCoordinatesBackButton')));
    expect(find.byType(PitchCoordinatesScreen), findsNothing);
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('appliedMathsStudioBackButton')));
    expect(find.byType(InteractiveLabsHubScreen), findsOneWidget);
    expect(path(), labsPath);
  });

  testWidgets('opened directly by URL, Back returns to the studio',
      (tester) async {
    await pumpAt(tester, pitchCoordinatesPath);
    expect(find.byType(PitchCoordinatesScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('pitchCoordinatesBackButton')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
    expect(path(), appliedMathsStudioPath);
  });

  testWidgets('leaving the screen clears the visit', (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, find.byKey(const Key('pitchCoordinatesEntryCard')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesCornerStart')));
    expect(find.byKey(const Key('pitchCoordinatesPrompt')), findsOneWidget);
    await tap(tester, find.byKey(const Key('pitchCoordinatesBackButton')));
    await tap(tester, find.byKey(const Key('pitchCoordinatesEntryCard')));
    expect(find.byKey(const Key('pitchCoordinatesChooser')), findsOneWidget,
        reason: 'a fresh visit starts at the start chooser');
  });

  testWidgets('Create the Angle route and card are unchanged', (tester) async {
    await pumpAt(tester, appliedMathsStudioPath);
    await tap(tester, find.byKey(const Key('createAngleEntryCard')));
    expect(find.byType(CreateAngleScreen), findsOneWidget);
    await tap(tester, find.byKey(const Key('createAngleBackButton')));
    expect(find.byType(AppliedMathsStudioHubScreen), findsOneWidget);
  });
}
