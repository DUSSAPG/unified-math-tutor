import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/models/lab_guidance_level.dart';
import 'package:unified_math_tutor/models/lab_narration_trigger.dart';
import 'package:unified_math_tutor/models/narration_message.dart';
import 'package:unified_math_tutor/screens/labs/flight_path_lab_screen.dart';
import 'package:unified_math_tutor/services/guided_narration_service.dart';
import 'package:unified_math_tutor/services/interactive_labs_progress_service.dart';
import 'package:unified_math_tutor/services/learner_profiles_service.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/narration_manifest_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';
import 'package:unified_math_tutor/services/tts_narrator.dart';
import 'package:unified_math_tutor/widgets/labs/guided_narration_banner.dart';

class _FakeTtsNarrator implements TtsNarrator {
  final List<String> spoken = [];
  int stopCount = 0;

  @override
  void speak(String text, {required double speed, String? localeTag}) {
    spoken.add(text);
  }

  @override
  void stop() => stopCount++;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await NarrationManifestService.instance.init();
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalPreferencesService.instance.init();
    await OnboardingProfileService.instance.init();
    await LearnerProfilesService.instance.init();
    await InteractiveLabsProgressService.instance.init();
    GuidedNarrationService.instance.debugReset();
  });

  Future<void> pumpFlightLab(WidgetTester tester) async {
    await InteractiveLabsProgressService.instance
        .markFirstUseSeen(InteractiveLabId.flightPathLab);
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: FlightPathLabScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Deterministic outcome classification', () {
    testWidgets(
        'correct heading, too far selects the matching narration message',
        (tester) async {
      await pumpFlightLab(tester);

      // Default heading (090) already matches scenario 1's target bearing;
      // pushing speed well past the target distance produces "too far"
      // while staying outside the near-miss band.
      final speedSlider = find.byKey(const Key('flightPathSpeedSlider'));
      tester.widget<Slider>(speedSlider).onChanged!(150);
      await tester.pump();

      await tester.ensureVisible(find.text('Test Flight'));
      await tester.tap(find.text('Test Flight'));
      await tester.pumpAndSettle();

      final message = GuidedNarrationService.instance.current.value;
      expect(message, isNotNull);
      expect(message!.labId, InteractiveLabId.flightPathLab);
      expect(message.trigger, LabNarrationTrigger.resultExplanation);
      // Default guidance level is Builder.
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(message.text,
          l10n.labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder);
    });

    testWidgets(
        'the same outcome selects different, level-appropriate wording per band',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      Future<String?> textForLevel(LabGuidanceLevel level) async {
        // Force a full unmount/remount — pumping the same widget type/slot
        // again would otherwise reuse the previous State (and its
        // "last tested heading/speed" memory), rather than starting fresh.
        await tester.pumpWidget(const SizedBox.shrink());
        GuidedNarrationService.instance.debugReset();
        await InteractiveLabsProgressService.instance.setGuidanceLevel(level);
        await pumpFlightLab(tester);
        final speedSlider = find.byKey(const Key('flightPathSpeedSlider'));
        tester.widget<Slider>(speedSlider).onChanged!(150);
        await tester.pump();
        await tester.ensureVisible(find.text('Test Flight'));
        await tester.tap(find.text('Test Flight'));
        await tester.pumpAndSettle();
        return GuidedNarrationService.instance.current.value?.text;
      }

      final explorerText = await textForLevel(LabGuidanceLevel.explorer);
      final builderText = await textForLevel(LabGuidanceLevel.builder);
      final navigatorText = await textForLevel(LabGuidanceLevel.navigator);

      expect(explorerText,
          l10n.labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer);
      expect(builderText,
          l10n.labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder);
      expect(navigatorText,
          l10n.labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator);
      expect(explorerText, isNot(builderText));
      expect(builderText, isNot(navigatorText));
    });

    testWidgets(
        'no generic-only response — every result message states what to change',
        (tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      const genericOnly = {
        'Wrong',
        'Wrong.',
        'Try again',
        'Try again.',
        'Almost',
        'Almost.'
      };

      final messages = [
        l10n.labsFlightPathLabNarrationResultNearMissBuilder,
        l10n.labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder,
        l10n.labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder,
        l10n.labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder,
        l10n.labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder,
      ];

      for (final message in messages) {
        expect(genericOnly.contains(message), isFalse,
            reason: 'Too generic: "$message"');
        expect(message.length, greaterThan(20));
      }
    });
  });

  group('Narration playback controls', () {
    test('mute suppresses audio but keeps the visible text', () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);
      await GuidedNarrationService.instance.setMuted(true);

      const message = NarrationMessage(
        messageId: 'test.notInManifest.muteCheck',
        text: 'Some guidance text.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.play(message, localeTag: 'en');

      expect(GuidedNarrationService.instance.current.value?.text,
          'Some guidance text.');
      expect(fake.spoken, isEmpty);
    });

    test('text-only suppresses audio but keeps the visible text', () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);
      await GuidedNarrationService.instance.setTextOnly(true);

      const message = NarrationMessage(
        messageId: 'test.notInManifest.textOnlyCheck',
        text: 'Some other guidance text.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.play(message, localeTag: 'en');

      expect(GuidedNarrationService.instance.current.value?.text,
          'Some other guidance text.');
      expect(fake.spoken, isEmpty);
    });

    test('a message with no pre-generated audio falls back to device TTS',
        () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);

      const message = NarrationMessage(
        messageId: 'test.definitelyNotInManifest',
        text: 'Fallback guidance text.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.play(message, localeTag: 'en');

      expect(fake.spoken, ['Fallback guidance text.']);
    });

    test('a message with pre-generated audio does not fall back to TTS',
        () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      final message = NarrationMessage(
        messageId: 'labsFlightPathLabNarrationIntroBuilder',
        text: l10n.labsFlightPathLabNarrationIntroBuilder,
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.introduction,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.play(message, localeTag: 'en');

      expect(fake.spoken, isEmpty);
      expect(GuidedNarrationService.instance.current.value?.text, message.text);
    });

    test('Quiet Study Mode suppresses audio the same way mute does', () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);
      await LocalPreferencesService.instance.setQuietStudyMode(true);

      const message = NarrationMessage(
        messageId: 'test.notInManifest.quietCheck',
        text: 'Quiet mode guidance text.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.play(message, localeTag: 'en');

      expect(fake.spoken, isEmpty);
      expect(GuidedNarrationService.instance.current.value?.text, message.text);
    });

    test('replayLast replays the most recent message', () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);

      const message = NarrationMessage(
        messageId: 'test.notInManifest.replayCheck',
        text: 'Replay this text.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.play(message, localeTag: 'en');
      expect(fake.spoken, ['Replay this text.']);

      GuidedNarrationService.instance.replayLast();
      expect(fake.spoken, ['Replay this text.', 'Replay this text.']);
    });

    test('a new action interrupts whatever was playing', () async {
      final fake = _FakeTtsNarrator();
      GuidedNarrationService.instance.debugSetTtsNarrator(fake);

      const first = NarrationMessage(
        messageId: 'test.notInManifest.first',
        text: 'First message.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      const second = NarrationMessage(
        messageId: 'test.notInManifest.second',
        text: 'Second message.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );

      GuidedNarrationService.instance.play(first, localeTag: 'en');
      final serialAfterFirst = GuidedNarrationService.instance.requestSerial;
      GuidedNarrationService.instance.play(second, localeTag: 'en');

      expect(GuidedNarrationService.instance.requestSerial,
          greaterThan(serialAfterFirst));
      expect(GuidedNarrationService.instance.current.value?.text,
          'Second message.');
      expect(fake.stopCount, greaterThanOrEqualTo(2));
    });
  });

  group('Profile isolation', () {
    test('narration preferences are isolated per learner profile', () async {
      final learnerAId =
          await LearnerProfilesService.instance.addLearner('Learner A');
      final learnerBId =
          await LearnerProfilesService.instance.addLearner('Learner B');

      await LearnerProfilesService.instance.setActiveLearner(learnerAId);
      await GuidedNarrationService.instance.setMuted(true);
      expect(GuidedNarrationService.instance.muted, isTrue);

      await LearnerProfilesService.instance.setActiveLearner(learnerBId);
      expect(
        GuidedNarrationService.instance.muted,
        isFalse,
        reason: 'Learner B must not inherit Learner A\'s narration preferences',
      );

      await LearnerProfilesService.instance.setActiveLearner(learnerAId);
      expect(GuidedNarrationService.instance.muted, isTrue);
    });
  });

  group('Narration manifest', () {
    test('does not require network access to load', () async {
      expect(NarrationManifestService.instance.isLoaded, isTrue);
    });

    test('falls back to a same-base-language region variant', () {
      final exact = NarrationManifestService.instance
          .lookup('labsFlightPathLabNarrationIntroBuilder', 'de-CH');
      expect(exact, isNotNull);

      final fallback = NarrationManifestService.instance
          .lookup('labsFlightPathLabNarrationIntroBuilder', 'de-AT');
      expect(fallback, isNotNull);
      expect(fallback!.locale, 'de-CH');
    });

    test('returns null for a message that genuinely has no pre-generated audio',
        () {
      final result = NarrationManifestService.instance
          .lookup('thisMessageIdDoesNotExist', 'en');
      expect(result, isNull);
    });
  });

  group('Accessibility', () {
    testWidgets('spoken guidance has an identical, screen-reader-visible text',
        (tester) async {
      const message = NarrationMessage(
        messageId: 'test.notInManifest.a11y',
        text: 'Screen reader guidance text.',
        labId: InteractiveLabId.flightPathLab,
        trigger: LabNarrationTrigger.hint,
        level: LabGuidanceLevel.builder,
      );
      GuidedNarrationService.instance.current.value = message;

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GuidedNarrationBanner(labId: InteractiveLabId.flightPathLab),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Screen reader guidance text.'), findsOneWidget);
      expect(find.bySemanticsLabel('Screen reader guidance text.'),
          findsOneWidget);
    });
  });
}
