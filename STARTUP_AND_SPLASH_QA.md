# Startup & Splash QA — Math Intelligence

**Date:** 2026-07-05
**Scope:** Startup sequence timing, in-app splash duration, and the crash this work uncovered and fixed.

## What changed

### Before

`main()` awaited five service `.init()` calls sequentially, then a debug-only
teaser preload, **before** ever calling `runApp()`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleService.instance.init();
  await LocalPreferencesService.instance.init();
  await OnboardingProfileService.instance.init();
  await StreakService.instance.init();
  await TutorCreditService.instance.init();
  await MarketSmoke.printStartupState();
  if (kDebugMode) { /* preload daily brain teasers */ }
  runApp(const UnifiedMathTutorApp());
}
```

The in-app splash screen (`AppSplashScreen`) then held for a flat, fixed
1400ms regardless of how long the above took — so total dead time before the
user could interact was "however long init takes" *plus* 1400ms, unconditionally.

### After

- `lib/core/bootstrap.dart` — new `AppBootstrap` class. `ensureStarted()` is
  idempotent (caches its `Future`) and runs the five service inits
  concurrently via `Future.wait` instead of sequentially, then runs
  `MarketSmoke.printStartupState()` (a debug-only no-op in release).
- `main()` now calls `AppBootstrap.ensureStarted()` **without awaiting it**,
  then calls `runApp()` immediately. Initialization now overlaps with the
  first frame instead of blocking it.
- `AppSplashScreen` (`lib/screens/splash/app_splash_screen.dart`) now gates
  navigation on *both*:
  - a **1200ms minimum** (`_minTimer`) — so the brand moment never feels like
    a flicker even when init is instant, and
  - `AppBootstrap.ensureStarted()` completing,
  - capped by an **1800ms maximum** (`_maxTimer`) — a hard ceiling that fires
    regardless, so a pathologically slow device can never hang on the splash
    indefinitely.
  - Tap-to-skip remains and bypasses all of the above immediately.

In practice, real init (`SharedPreferences`-backed services) resolves in tens
of milliseconds, so the splash reliably displays for ~1.2s — the floor, not
the ceiling — on every device tested.

## The debug-only preload that was removed

The old `if (kDebugMode) { ... }` block in `main()` eagerly loaded
`MentalMathVaultService` teasers/tricks and printed a debug log line. This
was pure diagnostic output — the Home screen's Daily Brain Teaser card and
the Mental Math Vault screen already load and cache this data themselves,
independently, when actually needed. Removed it entirely rather than port it
into `AppBootstrap`, because:

1. It served no runtime purpose (never seen by end users; `kDebugMode`-gated).
2. It was the root cause of a `flutter test` hang discovered during this work
   (see below) — real asset-bundle I/O invoked before any `tester.pump()`
   call inside `testWidgets` hangs indefinitely under
   `AutomatedTestWidgetsFlutterBinding`'s fake-async clock, which never
   drains the pending platform-channel response without an explicit pump.

## Critical bug found and fixed during this work

Moving `AppBootstrap.ensureStarted()` to fire-and-forget (not awaited before
`runApp()`) exposed a **100%-reproducible crash on every cold start**:

```
LateInitializationError: Field '_notifier@...' has not been initialized.
  #0  UnifiedMathTutorApp.build (package:unified_math_tutor/main.dart)
```

`UnifiedMathTutorApp.build()` reads `LocaleService.instance.notifier`
synchronously on the very first frame — but `LocaleService._notifier` was
declared `late` and only assigned inside `init()`, which hadn't resolved yet
(real init needs at least one platform-channel round trip via
`SharedPreferences.getInstance()`, guaranteeing it can't finish before the
first frame builds). Every other service in this codebase initializes its
`ValueNotifier` fields eagerly with a sensible default and only *updates*
`.value` in `init()` — `LocaleService` was the sole exception, and this
inconsistency was latent (masked) as long as `main()` blocked on init before
`runApp()`.

**Fix** (`lib/services/locale_service.dart`): `_notifier` is now eagerly
initialized with `resolveDeviceLocale(PlatformDispatcher.instance.locale,
selectable)` as a best-effort default, matching the pattern used everywhere
else. `init()` now just corrects `.value` once the saved preference loads,
which the existing `ValueListenableBuilder` in `main.dart` already picks up
reactively — no visible disruption.

In release mode, a widget `build()` throw renders as a plain **gray screen**
(Flutter's default release `ErrorWidget`), not a red debug screen — this is
exactly what first surfaced during tablet verification and looked like a
launch failure before the stack trace in `logcat` identified the real cause.

**Also fixed while wiring `AppBootstrap` into tests:** `test/widget_test.dart`
and `test/profile_sign_out_widget_test.dart` previously called individual
service `.init()` methods directly. Since `AppSplashScreen` now also
triggers `AppBootstrap.ensureStarted()` on mount, this caused a *second*
call to `TutorCreditService.instance.init()` in the same test run — which
crashed with a different `LateInitializationError` because
`TutorCreditService._notifier` is `late final` (reassignment throws). Fixed
by having `widget_test.dart` call `AppBootstrap.ensureStarted()` once instead
of the individual inits, and by adding the missing
`LocalAccountService.instance.init()` call to
`profile_sign_out_widget_test.dart`'s `setUp()` (needed because `SignOutService`
now also clears the new local account state — see `FINAL_V1_POLISH_REPORT.md`).

**Residual, lower-risk observation (not fixed, out of scope for this pass):**
`TutorCreditService._notifier` is still `late final`, same pattern that broke
`LocaleService`. It's only read from `lib/screens/tutor/tutor_screen.dart`,
never on the first frame, so by the time a user reaches that tab
`AppBootstrap` has certainly finished — no reproduction found. Worth an
eventual consistency pass if this class of bug recurs.

## Verification

- `flutter analyze`: clean.
- `flutter test`: 62/62 passing (includes the widget_test.dart fix above).
- Live device, Pixel 6a: splash → onboarding transition observed at ~1.2–2s
  after launch, no blank/black frame, no visible flicker.
- Live device, 11.5" 2K tablet (see `DUPLICATE_ICON_INVESTIGATION.md` and
  `FINAL_V1_POLISH_REPORT.md` for full device profile): same splash timing
  confirmed correct on a fresh install; the cold-start crash above was
  actually *found* on this device first (gray screen on launch) and
  reproduced/fixed before re-verifying.
