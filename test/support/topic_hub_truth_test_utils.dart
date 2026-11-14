import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/topics/topic_learning_hub_screen.dart';
import 'package:unified_math_tutor/services/curriculum_service.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';
import 'package:unified_math_tutor/services/topic_supporting_learning_registry.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Shared helpers for the Topic Hub Coverage Truth Repair V1 widget tests.
/// Like support/topic_learning_hub_test_utils.dart, every scenario lives in
/// its own file with one real asset-loading `testWidgets` (see that file's
/// doc comment for the cross-test flakiness this avoids). No `main()`.

final l10nEn = lookupAppLocalizations(const Locale('en'));

/// Every destination a Hub card can push/go to, as a stub that prints the
/// full URI it was opened with — so a test can assert exactly where a tap
/// lands (including query parameters such as `set=shape-properties`).
List<String> _stubPaths() => {
      for (final route in TopicCapabilityResolver.labRoutes.values) route,
      for (final route in supportingActivityRoutes.values)
        Uri.parse(route).path,
      '/formulas',
      '/practice',
      '/math-studio/recall-cards/browse',
      '/topics',
    }.toList();

const stubPrefix = 'stub-route:';

Widget wrapTruthHub(
  String topicId, {
  Brightness brightness = Brightness.light,
  double textScale = 1.0,
}) {
  final router = GoRouter(
    initialLocation: '/hub',
    routes: [
      GoRoute(
        path: '/hub',
        builder: (_, __) => TopicLearningHubScreen(topicId: topicId),
      ),
      for (final path in _stubPaths())
        GoRoute(
          path: path,
          builder: (_, state) =>
              Scaffold(body: Text('$stubPrefix${state.uri}')),
        ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
  );
}

Future<void> selectStage(String stage) async {
  SharedPreferences.setMockInitialValues({});
  await CurriculumService.instance.select(stage.toLowerCase());
}

void useLogicalViewport(WidgetTester tester, Size size) {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
}

Future<void> pumpHubLoaded(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0;
      i < 600 && find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }
  // One more frame for the resolved FutureBuilder subtree.
  await tester.pump();
}

Finder hubCard(String activityType, [String supportingId = '']) =>
    find.byKey(Key('topicHubActivity-$activityType-$supportingId'));

Finder stageStatus(TopicStageStatus status) =>
    find.byKey(ValueKey('topicHubStageStatus-${status.name}'));

/// Text that must never appear on any Topic Hub: generic companion /
/// Applied Maths Studio cards, Feed the Hungry Panda, Angle Academy /
/// Create the Angle bindings.
const prohibitedHubText = [
  'Football Studio',
  'Applied Maths Studio',
  'Feed the Hungry Panda',
  'Angle Academy',
  'Create the Angle',
];

void expectNoProhibitedHubText() {
  for (final text in prohibitedHubText) {
    expect(find.textContaining(text), findsNothing,
        reason: '"$text" must never be shown on a Topic Hub');
  }
}

/// Asserts the content-gap status + supporting-learning section, and that
/// no MCQ card is offered.
void expectGapWithSupportingLearning() {
  expect(stageStatus(TopicStageStatus.contentGap), findsOneWidget);
  expect(find.text(l10nEn.topicHubStatusNoQuestionsTitle), findsOneWidget);
  expect(find.text(l10nEn.topicHubStatusNoQuestionsBody), findsOneWidget);
  expect(find.text(l10nEn.topicHubSectionSupporting.toUpperCase()),
      findsOneWidget);
  expect(find.text(l10nEn.topicHubSupportingDisclaimer), findsOneWidget);
  expect(hubCard('topicDrill'), findsNothing);
  expect(hubCard('quickStart'), findsNothing);
  expect(find.text(l10nEn.topicHubSectionPractise.toUpperCase()), findsNothing);
}

/// Any Topic Hub activity card at all.
final Finder anyHubCard = find.byWidgetPredicate((widget) {
  final key = widget.key;
  return key is ValueKey<String> && key.value.startsWith('topicHubActivity-');
});

/// The Hub's stage-selector chips, in display order.
const hubStages = ['KS2', 'KS3', 'KS4', 'KS5'];

Finder stageChip(String stage) => find.byKey(ValueKey('topicHubStage-$stage'));

final Finder hubBackButton = find.byKey(const ValueKey('topicHubBackButton'));

/// Release-readiness a11y contract for the stage chips and Back control:
/// every chip's tap target (and semantics rect) is at least 48×48 dp and
/// stays inside [viewport] horizontally; each chip is announced as a
/// button with its stage label, the selected one as selected; the Back
/// button is announced as "Back to Topics", button.
Future<void> expectChipAndBackA11y(
  WidgetTester tester, {
  required String selected,
  required Size viewport,
}) async {
  for (final stage in hubStages) {
    final chip = stageChip(stage);
    expect(chip, findsOneWidget, reason: stage);
    await tester.ensureVisible(chip);
    await tester.pump();
    final rect = tester.getRect(chip);
    expect(rect.height, greaterThanOrEqualTo(kMinInteractiveDimension),
        reason: '$stage chip hit area height');
    expect(rect.width, greaterThanOrEqualTo(kMinInteractiveDimension),
        reason: '$stage chip hit area width');
    expect(rect.left, greaterThanOrEqualTo(-0.5), reason: stage);
    expect(rect.right, lessThanOrEqualTo(viewport.width + 0.5), reason: stage);

    final node = tester.getSemantics(chip);
    expect(node.rect.height, greaterThanOrEqualTo(kMinInteractiveDimension),
        reason: '$stage chip semantics height');
    expect(node.rect.width, greaterThanOrEqualTo(kMinInteractiveDimension),
        reason: '$stage chip semantics width');
    expect(
      node,
      isSemantics(
        label: stage,
        isButton: true,
        hasTapAction: true,
        hasSelectedState: true,
        isSelected: stage == selected,
      ),
      reason: '$stage chip semantics',
    );
  }

  expect(hubBackButton, findsOneWidget);
  final backRect = tester.getRect(hubBackButton);
  expect(backRect.height, greaterThanOrEqualTo(kMinInteractiveDimension));
  expect(backRect.width, greaterThanOrEqualTo(kMinInteractiveDimension));
  expect(find.bySemanticsLabel(l10nEn.topicHubBackToTopics), findsOneWidget);
  expect(
    tester.getSemantics(find.bySemanticsLabel(l10nEn.topicHubBackToTopics)),
    isSemantics(
      label: l10nEn.topicHubBackToTopics,
      isButton: true,
      hasTapAction: true,
    ),
  );
}
