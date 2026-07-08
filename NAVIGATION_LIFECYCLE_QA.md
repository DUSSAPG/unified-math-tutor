# Mobile Navigation Lifecycle QA

Audit and fix pass for the "users should never wonder where they are or how to
return" navigation requirement. Covers every route in `lib/app/router.dart`.

## What changed

1. **Bottom nav restructured to 5 tabs + More on phone/tablet.** Home, Topics,
   Practice, and the new **Journey** tab sit directly on the bar; **More**
   opens a bottom sheet with Formula Library, Tutor, Profile, Help, and
   Settings. Desktop (`AppResponsive.isDesktop`, ≥1024px) keeps the
   `NavigationRail` with all 8 destinations visible directly — no width
   pressure there, so no collapsing.
2. **New Journey tab** (`lib/screens/journey/journey_screen.dart`,
   route `/journey`). Extracted the streak/progress/achievements/daily-goal
   sections out of Home so progress tracking has a persistent, revisitable
   home instead of living halfway down the dashboard.
3. **Formula Library promoted into the shell.** It was previously a
   `context.push`'d route living above the shell (no bottom nav while
   viewing it). It's now a `StatefulShellBranch` like Topics/Tutor/Help, so
   the nav bar stays visible while browsing formulas, per the requirement
   that Formula Library remain reachable from persistent navigation.
4. **`NavVisibilityService`** (`lib/services/nav_visibility_service.dart`) —
   a small `ValueNotifier<bool>` that `AppShell` listens to. Practice sets it
   `true` the moment a session starts (quick start, topic drill, timed
   challenge, and exam simulator all funnel through the same
   `_ScreenState.session`, so one flag covers all three "focused flow" modes
   named in the spec) and `false` on exit/finish/dispose. Bottom nav and rail
   both disappear for the duration.
5. **Exit confirmation during an active practice session.** Both the
   in-screen "Exit" control and the Android back gesture (via `PopScope`)
   now route through one confirmation dialog: *"Exit session? / Your current
   progress may not be saved."* — the exact copy from the spec — with
   Cancel/Exit actions.
6. **Exit confirmation on the onboarding profile step.** `StudyProfileScreen`
   (child name + parent email fields) now confirms before discarding typed
   input on back; if both fields are empty it just goes back immediately, no
   needless prompt.
7. **Exam Packs gained an explicit close (X) button.** It previously relied
   only on the automatic back arrow, which quietly disappears when the
   screen is reached via `context.go` (as it is from Tutor's "View Packs"
   buttons and from Upgrade) because `Navigator.canPop()` is false in that
   case — this was a real dead end for those entry points. Now mirrors the
   close-button pattern already used correctly by `UpgradeScreen` and
   `SubscriptionScreen`.
8. **Removed six dead-end routes** that were unreachable from the live app
   (splash always goes to `/onboarding`, never to these) — see "Dead ends
   removed" below.

## Screens audited

| Route | Nav bar visible? | Back / Cancel / Home | Notes |
|---|---|---|---|
| `/splash` | n/a (pre-shell) | none needed (entry point) | auto-continues to `/onboarding` |
| `/onboarding` (UserTypeScreen) | hidden | none needed (entry point) | doubles as the "welcome/auth choice" screen — Sign In / Create Account / Guest Mode |
| `/onboarding/welcome`, `/stage`, `/goal`, `/profile` | hidden | custom back arrow via `OnboardingProgressHeader` | `/onboarding/profile` (StudyProfileScreen) now confirms before discarding typed input |
| `/auth/sign-in`, `/auth/create` | hidden | automatic AppBar back (reliable — always `push`'d) | forms discard input silently on back; low priority, see Remaining risks |
| `/auth/forgot-password` | hidden | automatic AppBar back + "Back to Sign In" | fine |
| `/home` | **visible** | primary destination, no back needed | |
| `/topics` | **visible** | primary destination | |
| `/practice` (setup) | **visible** | primary destination | |
| `/practice` (active session — any mode) | **hidden** (new) | in-screen Exit → confirmation dialog; system back → same dialog via `PopScope` | covers quick start, topic drill, timed challenge, exam simulator |
| `/practice` (summary) | **visible** (restored) | "Close" button returns to setup | |
| `/journey` (new) | **visible** | primary destination | |
| `/formulas` | **visible** (was hidden before this fix) | primary destination (moved into shell) | |
| `/profile` | **visible** | primary destination | Sign Out has a real confirm dialog |
| `/profile/settings`, `/appearance`, `/accessibility`, `/subscription`, `/curriculum`, `/privacy`, `/terms` | hidden (full-screen over shell) | explicit back/close (`popOrGo`) | `/subscription` and (new) `/packs` use an X close button; rest use a back arrow |
| `/tutor` | **visible** | primary destination | |
| `/help`, `/help/parent-teacher-tools`, `.../cheat-sheet` | hidden for the sub-pages | explicit back (`popOrGo`) | PIN reset has its own confirm dialog |
| `/packs` | hidden (pushed above shell) | **explicit close (X), new** | previously a real dead end when reached via `context.go` from Tutor/Upgrade |
| `/mental-math`, `/mental-math/:id`, `/daily-teaser` | hidden (pushed above shell) | automatic AppBar back (reliable — always `push`'d) | fine |
| `/upgrade` | hidden | explicit close (X) + "Maybe Later" | already correct |
| `/release-notes` (dev builds only) | hidden | explicit back (`popOrGo`) | fine |

## Bottom nav visibility decision

- **Persistent tabs (phone/tablet):** Home, Topics, Practice, Journey, More.
- **Behind More (phone/tablet):** Formula Library, Tutor, Profile, Help,
  Settings — a modal bottom sheet, dismissible by swipe/tap-outside like any
  standard sheet.
- **Desktop rail (≥1024px):** all 8 — Home, Topics, Practice, Journey,
  Formula Library, Profile, Tutor, Help — shown directly, no More needed
  since width isn't constrained.
- **Hidden entirely during:** onboarding, sign in / create account / forgot
  password, and an active practice session (quick start, topic drill, timed
  challenge, exam simulator). Settings sub-pages, Exam Packs, Mental Math
  Vault, and Upgrade already push full-screen above the shell and correctly
  have no bottom nav — unchanged by this pass.

## Back / Cancel / Home behavior

Every screen now has at least one of: an automatic AppBar back button that's
reliably present (verified against how it's actually navigated to —
`push` vs `go` matters, see below), an explicit back/close icon via
`popOrGo`, or (for shell tabs) no back needed because it's a primary,
always-reachable destination.

The recurring bug pattern found and fixed: a screen with only the *automatic*
back button, reached via `context.go(...)` instead of `context.push(...)`.
`go` replaces the whole stack, so `Navigator.canPop()` is false and the
automatic back arrow silently doesn't render — the screen becomes a dead end
with no way out except backgrounding the app. This is what was wrong with
Exam Packs; Upgrade and Subscription already avoided it with an explicit
close button, which is the pattern now applied consistently.

## Sign Out

Verified end-to-end: `ProfileScreen` → confirm dialog ("Sign out of Math
Intelligence?" / Cancel / Sign Out) → `SignOutService.instance.signOut()` →
`context.go('/onboarding')`. `/onboarding` is `UserTypeScreen`, which presents
Sign In / Create Account / Guest Mode — functionally the welcome/auth choice
screen, matching the requirement despite the button's subtitle literally
saying "return to welcome" (that's a `/welcome`-named route from an older,
now-removed flow; the destination is correct, just the wording is a
historical artifact). No code change made here; already correct.

## Dead ends removed

These routes were **not reachable from the live app** — `AppSplashScreen`
always continues to `/onboarding`, and nothing else in the shipped app links
to them. They were only reachable from `lib/features/onboarding/bootstrap_screen.dart`,
itself dead code (never referenced by the router). Confirmed via full-repo
grep before removal, and confirmed `flutter analyze` / `flutter test` stay
clean after removal:

- `/choose-market`, `/choose-canton-ch`, `/choose-language-ch`, `/welcome` —
  a legacy Swiss-market onboarding flow. `/welcome` (`WelcomeRouterScreen`)
  was additionally a genuine dead end even if reached: every locale branch
  rendered a placeholder with zero forward navigation.
- `/practice/question`, `/practice/results` — unused stub screens
  (`QuestionScreen`, `ResultsScreen`) with no AppBar, no back button, and
  (per their own doc comments) no production code path that ever navigated
  to them.

Files deleted: `lib/screens/practice/question_screen.dart`,
`lib/screens/results/results_screen.dart`,
`lib/features/onboarding/swiss_language_picker_screen.dart`,
`lib/features/onboarding/bootstrap_screen.dart`,
`lib/features/welcome/welcome_router_screen.dart`.

`lib/features/onboarding/market_picker_screen.dart` and
`swiss_canton_picker_screen.dart` were **kept** — `test/swiss_onboarding_widget_test.dart`
builds them directly in an isolated `MaterialApp` harness, independent of
`app/router.dart`. They are still unrouted in the live app; see Remaining
risks.

## Verification

- `flutter analyze` — no issues found.
- `flutter test` — 62/62 passed, including an updated
  `navigation_localization_widget_test.dart` that now exercises the new
  5-tab + More structure (direct taps for Home/Topics/Practice/Journey, plus
  opening More and tapping through to Profile/Tutor/Help) across all 10
  supported locales.
- `flutter build apk --release` — **passed** after `flutter clean` +
  `flutter pub get` (the first attempt failed with a stale
  `GeneratedPluginRegistrant.java` referencing `flutter_native_splash`, a
  pre-existing generated-file staleness issue unrelated to this change —
  regenerating plugin registration files fixed it). Final artifact:
  `build/app/outputs/flutter-apk/app-release.apk` (83.0 MB).

## Remaining risks

- **New l10n strings are English-only for now.** `navJourney`, `navMore`,
  `journeyTitle`/`journeySubtitle`/`journeyTeaserSubtitle`,
  `practiceExitSessionTitle`/`Body`, `onboardingDiscardTitle`/`Body`, and
  `commonCancel` were added to the base template (`lib/l10n/app_en.arb`) per
  this project's existing fallback pattern (`l10n.yaml`'s
  `template-arb-file: app_en.arb`; regional ARB files only carry overrides
  and fall back to the template for anything missing). All locales will show
  English text for these strings until translated. Follow-up: translate for
  de-CH / fr-CH / it-CH and the rest.
- **Auth forms don't confirm on back.** Sign In and Create Account discard
  typed email/password silently when backed out of. Left out of scope for
  this pass (short-lived input, not the "progress" the spec calls out —
  practice sessions and the onboarding profile step were the two real
  data-entry-loss risks), but worth a follow-up if user feedback flags it.
- **`market_picker_screen.dart` / `swiss_canton_picker_screen.dart` are dead
  code in the live app** (kept only for their widget test). Candidate for
  either full removal + a widget-test rewrite, or wiring back into the
  router if the Swiss-market flow is coming back — needs a product decision,
  not a navigation-lifecycle one.
- **Pre-existing unrelated dead code, left untouched:**
  `lib/features/welcome/welcome_ch_de_screen.dart` /
  `welcome_ch_fr_screen.dart` / `welcome_ch_it_screen.dart` /
  `welcome_screen.dart`, and `lib/features/onboarding/welcome/`. None of
  these were ever wired into the router, even before this fix — out of scope
  for a navigation-lifecycle pass.
- **"More" sheet has no explicit close button**, relying on standard
  swipe-down/tap-outside dismissal. Flag for a follow-up if usability testing
  shows it isn't discoverable enough.
- **Pre-existing stub actions, unrelated to navigation:** Tutor's "Buy
  Credits", Subscription's "Subscribe"/"Restore Purchases", Exam Packs'
  premium/top-up taps, and Privacy's "Request Data Deletion" are all
  SnackBar-only no-ops. Noted for product awareness, not a navigation defect.
