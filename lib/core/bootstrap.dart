import 'dart:async';

import 'market/market_smoke.dart';
import '../services/locale_service.dart';
import '../services/learner_profiles_service.dart';
import '../services/local_account_service.dart';
import '../services/local_preferences_service.dart';
import '../services/interactive_labs_progress_service.dart';
import '../services/mental_maths_progress_service.dart';
import '../services/narration_manifest_service.dart';
import '../services/onboarding_profile_service.dart';
import '../services/recall_cards_progress_service.dart';
import '../services/streak_service.dart';
import '../services/tutor_credit_service.dart';
import '../services/tutor_notes_service.dart';

/// Runs all service initialization concurrently and exactly once. Kicked off
/// as early as possible in `main()`, before `runApp`, so it overlaps with the
/// first Flutter frame (the in-app splash) instead of blocking it.
class AppBootstrap {
  AppBootstrap._();

  static Future<void>? _future;

  static Future<void> ensureStarted() => _future ??= _run();

  static Future<void> _run() async {
    // Narration audio manifest loading is deliberately NOT part of this
    // Future.wait: it's a progressive enhancement (a missing/slow-to-load
    // manifest already falls back gracefully to device TTS/text-only, see
    // NarrationManifestService), so it must never be able to delay app
    // boot — or a test's simulated boot — while it loads.
    unawaited(NarrationManifestService.instance.init());

    await Future.wait([
      LocaleService.instance.init(),
      LocalAccountService.instance.init(),
      LocalPreferencesService.instance.init(),
      // LearnerProfilesService migrates the legacy childName field, so it
      // must run after OnboardingProfileService has loaded.
      OnboardingProfileService.instance
          .init()
          .then((_) => LearnerProfilesService.instance.init()),
      StreakService.instance.init(),
      TutorCreditService.instance.init(),
      RecallCardsProgressService.instance.init(),
      InteractiveLabsProgressService.instance.init(),
      MentalMathsProgressService.instance.init(),
      TutorNotesService.instance.init(),
    ]);
    await MarketSmoke.printStartupState();
  }
}
