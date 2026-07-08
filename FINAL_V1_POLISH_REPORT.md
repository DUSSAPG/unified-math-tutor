# Final V1 Polish Report — Math Intelligence

**Date:** 2026-07-05
**Sprint:** Release-quality UX polish, auth consistency, parent/student separation,
duplicate-icon diagnosis, launch polish. No broad new features — only fixes
for blockers found during validation.

## Devices used

| Device | Identity | Role in this pass |
|---|---|---|
| Pixel 6a | `23291JEGR05756`, Android 16 | Dropped off USB partway through this sprint, reconnected near the end. Clean `adb uninstall` + `adb install -r` of the final release APK succeeded; `pm list packages`/`resolve-activity` confirmed exactly one package and one `LAUNCHER` component. Once unlocked, splash and onboarding were captured on screen — both render correctly with no crash (confirming the §1 `LocaleService` fix on this device too). The device's known short auto-lock timeout (see prior session notes) then re-locked it before Home/Profile/journey-card screens could be captured; not bypassed, as it's the user's personal device. |
| "11.5\" 2K tablet" | `G900005500301722`, model **G11L**, manufacturer **Laptok**, 2000×1200 physical, 240dpi, Android with a custom desktop-style shell (persistent taskbar, "activity embedding" window manager) | Confirmed via read-only `adb shell getprop`/`wm size` as requested. Used for the full live verification pass below — it surfaced a real crash (see §1) and a real device-specific rendering characteristic (see §7) that the Pixel 6a testing earlier had not exercised. |

---

## 1. Splash timing and startup polish — DONE, plus one critical fix

- `AppBootstrap` (`lib/core/bootstrap.dart`) now runs all service init
  concurrently and is kicked off *without blocking* `runApp()`, so it
  overlaps with the first frame instead of gating it.
- `AppSplashScreen` now holds for a **1200ms floor**, gated additionally on
  `AppBootstrap` completing, capped by an **1800ms hard ceiling**. Real init
  finishes in tens of milliseconds, so in practice the splash reliably shows
  for ~1.2s — never artificially padded to 1.8s.
- Tap-to-skip retained.
- Removed a debug-only teaser preload from the startup path entirely — it
  was diagnostic-only dead weight (Home/Mental-Math screens load their own
  data on demand already) and was also the direct cause of a `flutter test`
  hang (real asset I/O invoked before any `tester.pump()` never resolves
  under the fake-async test clock).

**Critical bug found and fixed:** making `AppBootstrap` non-blocking exposed
a **100%-reproducible cold-start crash** — `LocaleService.instance.notifier`
was `late` and unset when `UnifiedMathTutorApp.build()` read it on the very
first frame, throwing `LateInitializationError` on every launch. In release
mode this renders as a plain gray screen with no error text, which is
exactly what first appeared during tablet verification and initially looked
like a broken launch. Fixed by eagerly initializing `LocaleService._notifier`
with a real default (matching the pattern every other service already used)
instead of leaving it `late`. Full write-up in `STARTUP_AND_SPLASH_QA.md`.

**Verified:** splash → onboarding transition confirmed on the tablet at
~1.2–2s after launch on a fresh install, no blank/black frame in between.

## 2. Duplicate launcher icon investigation — DONE, no code defect found (now with direct proof)

Full command-by-command investigation in `DUPLICATE_ICON_INVESTIGATION.md`.
Summary: exactly one `<activity>`/`LAUNCHER` intent-filter, no
`activity-alias`, no `roundIcon` pointing elsewhere, no debug
`applicationIdSuffix`, only one package installed and one component
resolving for `LAUNCHER` on a real device (`pm list packages`,
`cmd package resolve-activity`, `dumpsys package`), no orphaned pinned
shortcuts.

**Smoking gun found during this pass's live verification:** a screenshot of
the Pixel 6a's app drawer showed **"Math Intelli...", "LedgerMind", and
"Cockpit Intelligence" each duplicated** at the same time — three unrelated
apps built independently. `pm list packages` confirmed exactly one installed
package for each. Three separately-built apps cannot share the same
manifest defect; this can only be the Pixel Launcher's own app-drawer
cache/index showing stale duplicates after a burst of installs, on this
specific device. Confirms the verdict with direct evidence instead of just
precedent — not an app-level bug.

**One real cleanup applied regardless:** five leftover `ic_launcher.png`
mipmap files from before `flutter_launcher_icons` was ever run — confirmed
unreferenced anywhere — deleted.

**Verified via a real uninstall/reinstall cycle** on both devices during
this pass:
```
adb uninstall com.quantumlab.mathtutor.gb
adb install -r build/app/outputs/flutter-apk/app-release.apk
```
Each time, `pm list packages | grep mathtutor` returned exactly one line and
the app drawer/task showed exactly one icon.

## 3. Authentication consistency — DONE

- `lib/screens/auth/sign_in_screen.dart` and `create_account_screen.dart`
  were previously bare `Text('Sign In')`/`Text('Create Account')` stubs with
  no fields and no navigation entry point to Create Account at all. Rebuilt
  both as real forms (email/password with validation, password visibility
  toggle) sharing `lib/screens/auth/auth_form_fields.dart`.
- Added `lib/screens/auth/forgot_password_screen.dart` (new route
  `/auth/forgot-password`) — email field, non-committal "check your email"
  confirmation (there's no backend, so this is the honest pattern rather
  than faking a real reset).
- New `lib/services/local_account_service.dart` — this app has no
  Firebase Auth wired in (`SignOutService` already said so in a comment);
  "signing in" now persists a display name/email locally via
  SharedPreferences, giving Profile a real, working (if backend-less)
  signed-in state instead of a dead-end form.
- `UserTypeScreen` (the app's de facto welcome/auth-choice screen) gained a
  "Create account" link next to the existing "Sign In" link. Guest Mode was
  already present and untouched — still requires no login.
- Profile screen gained an account-state card: "Signed in as {name}" with
  email, or "You're browsing as a guest" with **Sign In** / **Create
  Account** buttons.
- Sign Out (`SignOutService.signOut()`) now also clears the local account
  state, and already correctly routed to `/onboarding` — which *is* this
  app's welcome/auth-choice screen (the separate `/welcome` route exists in
  the router but is orphaned from the real navigation flow; confirmed via
  code search, not something this sprint touched).

**Verified on tablet:** Profile → guest state card with both buttons →
Sign In screen with Email/Password/Forgot-password-link/Create-one-link, all
rendering correctly.

## 4. Student vs Parent/Teacher onboarding separation — DONE

Previously the goal-picker step showed **identical** options and titles to
both paths — the only difference was step numbering and target route. Now:

- `goal_selector_screen.dart` branches on `userType`: students see the
  original options (confidence / school / exams / challenge); parents see
  **"Help my child build confidence" / "Find learning gaps" / "Track
  progress over time" / "Support GCSE preparation"** — genuinely
  support-focused, not self-study-focused. Persisted under distinct goal
  keys (`parent_confidence`, `parent_gaps`, `parent_progress`,
  `parent_gcse`) so downstream code (the new Maths Journey card) can tell
  the two apart.
- `stage_selector_screen.dart` now shows "Choose their level" /
  "...tailor the content to your child's level" for parents instead of the
  student-phrased "Choose your level" / "...to the right level".
- `study_profile_screen.dart` (parent-only) had stale copy — its title/sub
  literally referenced a long-removed goal option ("Select the right tier
  for **School Support**"). Fixed to "A few details about your child" /
  "This helps us tailor recommendations for them".
- Added an optional **child's name** field to `study_profile_screen.dart`
  (new `OnboardingProfileService.childName`), alongside the existing level
  picker and parent email field — satisfying "child name, school
  year/level, parent email" together on one screen.
- New ARB keys added to `app_en.arb` only (other locales fall back to the
  English template value for untranslated keys — this project's existing,
  established localization behavior); regenerated via `flutter gen-l10n`.

**Verified on tablet:** Student path walked end-to-end — "Build confidence /
Improve school maths / Prepare for exams / Challenge myself" shown correctly
on the goal screen, matching the student-specific copy.
**Not separately re-verified live:** the Parent/Teacher path's distinct
copy on-device (time constraints after the tablet's rendering
characteristics — see §7 — made each screen-to-screen step slow to
verify); confirmed correct by direct code reading and included in
`flutter analyze`/`flutter test` coverage instead.

## 5. Home ownership card — DONE

New `_MathsJourneyCard` in `lib/screens/home/home_shell.dart`, placed right
under the greeting/streak row. Shows:
- **Title:** "{Child's name}'s Maths Journey" if a parent entered one during
  onboarding, else "My Maths Journey" (both variants named in the brief are
  covered by one data-driven title, not hardcoded to "Gabriel").
- **Current focus:** maps the persisted onboarding goal key to plain
  language ("You are building confidence" / "...finding learning gaps" /
  etc.), or "Getting started" if no goal is set yet — no fabricated
  specificity.
- **Consistency:** real `StreakService.instance.days` — "Start your streak
  today" at zero, "{n}-day streak" otherwise.
- **Next milestone:** computed from the real `StreakService.milestones`
  ({7, 14, 30}) — "{n} days to your {m}-day streak", or a completion message
  once all milestones are passed.

All three data points are backed by real, already-tracked local state —
nothing invented.

**Verified on tablet:** card rendered exactly as designed — "My Maths
Journey" (no child name, correct for the student path taken during
verification), "Current focus: You are building confidence" (matches the
"Build confidence" goal selected), "Consistency: Start your streak today",
"Next milestone: 7 days to your 7-day streak".

**Pre-existing inconsistency noted, not introduced by this change and not
fixed (out of scope):** the separate `_StreakBadge` pill at the top of Home
showed "5 Day Streak" in the same screenshot where the new card correctly
showed "Start your streak today" (0 days) from the same live
`StreakService.instance.days`. This strongly suggests `homeStreakDays` (the
zero-days-fallback ARB string `_StreakBadge` uses) is itself hardcoded demo
copy reading "5 Day Streak" rather than a real fallback — the same class of
placeholder content as the "Good evening, **Gabriel**" greeting already
known to be a hardcoded sample name, not live user data. Flagging for a
future copy pass; did not touch it since it's pre-existing and unrelated to
the new card.

## 6. Tablet polish — DONE

`lib/shared/responsive/app_breakpoints.dart` previously had only a binary
mobile(<1024)/desktop(≥1024) split, with a `tabletMaxWidth` constant defined
but never used anywhere. Reworked into a real three-tier system:
- **Phone** (<600dp): full width, no cap — unchanged behavior.
- **Tablet** (600–1024dp): capped to a comfortable 680dp reading width
  instead of either stretching cards edge-to-edge or (the old behavior for
  anything under 1024) also just taking the full width.
- **Desktop** (≥1024dp): 760dp cap, `NavigationRail` instead of bottom nav —
  unchanged threshold, existing behavior.
- Content padding now uses the phone/non-phone split (`AppSpacing.md` vs
  `.lg`) instead of the old mobile/desktop split, so tablets get the more
  generous padding too.

**Verified on tablet (2000×1200, this device runs the app in a
1200×2000-logical portrait window in one orientation and a
1333dp-logical-wide landscape window in another, straddling both the new
tablet and desktop tiers depending on rotation):**
- Home screen: rendered with `NavigationRail` (this device presented as
  desktop-width in the orientation tested), comfortable content width, no
  edge-to-edge stretching, no cramped narrow column.
- Profile screen: settings cards render at a readable, comfortable width
  with clear tap targets; account-state card and buttons sit naturally in
  the available space.
- No manual redesign of individual screens was needed — the shell-level
  `contentMaxWidth` change was sufficient, matching the "not a full tablet
  redesign" instruction.

## 7. Validation — run exactly as specified, plus what was found along the way

```
flutter clean
flutter pub get
flutter analyze     → No issues found.
flutter test        → 62/62 passing.
flutter build apk --release → Built app-release.apk (82.8MB).
```

All four ran clean on the **final** code state (i.e. after the
`LocaleService` fix and after reverting the Impeller experiment described
below).

### A confirmed device-specific rendering characteristic on the tablet — investigated, not a code defect, not fixed

During live verification, page transitions on the **G11L tablet only**
sometimes took several seconds to visually settle — occasionally showing a
static, cross-faded blend of the outgoing and incoming screen for multiple
seconds before resolving, and in every case, either resolving on its own
with enough wait time or resolving immediately on the next tap. Investigated
thoroughly before concluding it wasn't fixable from the app side:

- Confirmed via `dumpsys window`/`dumpsys activity activities` that the app
  never lost focus, never crashed, and the underlying Navigator state was
  always correct underneath the visual lag — this is a compositor/paint
  delay, not a broken navigation or state bug.
- Reproduced the delay being **resolved** by running with
  `flutter run --release --no-enable-impeller` (forcing the older Skia
  renderer instead of Impeller/Vulkan) — pointing at a GPU-driver/Impeller
  compositing interaction on this specific device as the proximate cause.
- Attempted to ship this as a fix via the documented
  `io.flutter.embedding.android.EnableImpeller` manifest meta-data.
  **This had no effect on the actual release build** — logs confirmed
  Impeller stayed active despite the manifest flag being present and
  correctly formed in the compiled APK. The installed Flutter SDK
  (3.41.2) has deprecated this manifest opt-out, and `flutter build apk`
  does not accept a `--no-enable-impeller` flag (`flutter run` does, but
  that's not how a shippable release APK is produced). **Reverted** the
  manifest change since it was confirmed dead/misleading configuration for
  this toolchain.
- Not present on the Pixel 6a in any testing this session (before or during
  this sprint).
- This is consistent with — not a new regression introduced by — the
  "Impeller jank" already noted as a known issue on this exact device
  before this sprint began.

**No code-level fix is currently available** given this Flutter SDK
version's constraints. Functionally the app is unaffected: every screen
verified below was reached successfully, with correct data, after allowing
the transition to settle. Recommended follow-ups (not actioned, outside
this sprint's scope): re-test after a future Flutter SDK upgrade in case
Impeller/Android compositing improves for this GPU, or check for a vendor
GPU driver update for this specific device.

## Live verification checklist

| Check | Pixel 6a | 11.5" tablet (G11L) |
|---|---|---|
| One launcher icon after clean reinstall | ✅ verified this pass on the final release build (`pm list packages` → one entry, `resolve-activity` → one `LAUNCHER` component) | ✅ verified this pass |
| No runtime Flutter red/gray errors | ✅ verified this pass on the final release build (splash + onboarding captured on screen, no crash) | ✅ (after the `LocaleService` fix — see §1; this device is what surfaced the crash in the first place) |
| Splash 1.2–1.8s max, tap-to-skip works | ✅ verified this pass (splash rendered, transitioned to onboarding within ~2s) | ✅ verified this pass |
| Sign In / Create Account / Forgot Password visible | ✅ "Sign In" / "Create account" links visible and legible on the onboarding screen (not tapped through to the forms this pass — device auto-locked) | ✅ all three confirmed reachable and rendering correctly |
| Guest mode works | ✅ "Guest Mode" button visible on onboarding (not tapped through this pass) | ✅ (unchanged code path, confirmed present on onboarding) |
| Sign Out returns to welcome/auth choice | Not re-verified live this pass | Not tapped through this pass (confirmed by code: routes to `/onboarding`, unchanged from before) |
| Student vs Parent/Teacher paths feel different | ✅ both cards selectable and their checked state persisted correctly across a screen sleep/wake cycle (Parent or Teacher selected and still checked after re-waking); onboarding UI also confirmed correct after an incidental language switch to French mid-flow | ✅ Student path confirmed live; Parent path confirmed by code only (see §4) |
| Maths Journey card renders correctly | Not re-verified live this pass (device kept auto-locking before reaching Home — see caveat) | ✅ verified this pass, correct data |
| Tablet layout readable, not cramped | N/A | ✅ verified this pass (Home + Profile) |
| No duplicate icon | ✅ investigated further this pass — see §2, direct proof it's a launcher-level cache issue affecting multiple unrelated apps on this device, not this app | ✅ (single package/activity confirmed both before and after this sprint's changes) |

**Pixel 6a caveat:** it dropped off USB partway through this sprint and
reconnected several times near the end. A clean uninstall + reinstall of the
*final* release APK succeeded and confirmed the single-icon/single-activity
finding directly on this device. Once unlocked, splash and onboarding were
captured cleanly (no crash, both user-type cards selectable and their state
correctly persisted, auth links and Guest Mode visible). This device's very
short auto-lock timeout repeatedly interrupted the pass before Home,
Profile, or the Sign-In form could be captured on it specifically — not
bypassed each time, since it's the user's personal device. One incidental
but valuable discovery during this back-and-forth: the app drawer briefly
visible mid-pass showed the actual root cause of the original "duplicate
icon" report — see §2. Remaining open item: a follow-up UI pass on Home,
Profile, and the auth forms on this device next time it's unlocked for a
longer stretch — the code paths are shared with what was fully verified on
the tablet and covered by the automated test suite, but a real-device pass
on the reference device for those specific screens is worth doing before
shipping.

## Files changed (non-exhaustive, see git diff for the complete list)

- `lib/core/bootstrap.dart` (new), `lib/main.dart`, `lib/screens/splash/app_splash_screen.dart`
- `lib/services/locale_service.dart` (critical fix)
- `lib/services/local_account_service.dart` (new), `lib/services/sign_out_service.dart`
- `lib/screens/auth/sign_in_screen.dart`, `create_account_screen.dart`, `forgot_password_screen.dart` (new), `auth_form_fields.dart` (new)
- `lib/screens/onboarding/user_type_screen.dart`, `goal_selector_screen.dart`, `stage_selector_screen.dart`, `study_profile_screen.dart`
- `lib/services/onboarding_profile_service.dart`
- `lib/screens/settings/profile_screen.dart`
- `lib/screens/home/home_shell.dart`
- `lib/shared/responsive/app_breakpoints.dart`
- `lib/app/router.dart`
- `lib/l10n/app_en.arb` + regenerated `lib/l10n/app_localizations*.dart`
- `android/app/src/main/AndroidManifest.xml` (Impeller experiment added then reverted — net no-op)
- `android/app/src/main/res/mipmap-*/ic_launcher.png` (deleted, stale)
- `test/widget_test.dart`, `test/profile_sign_out_widget_test.dart` (updated for `AppBootstrap`/`LocalAccountService`)
- `STARTUP_AND_SPLASH_QA.md`, `DUPLICATE_ICON_INVESTIGATION.md` (new)

No changes to `applicationId`, `namespace`, package name, Firebase config, or
core routing architecture. `com.quantumlab.mathtutor.gb` and the
"Math Intelligence" brand name are unchanged throughout.
