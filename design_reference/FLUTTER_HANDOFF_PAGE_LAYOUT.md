# CoachSuite MathTutor — Flutter Handoff: Page Layout Specification

> **FROZEN DESIGN SYSTEM** — spacing, radii, shadows, component shapes, typography scale, and iconography are locked. Do not alter any of these without an explicit written instruction. This document is the authoritative reference for all screen layouts and responsive behaviour.

---

## 1. Global Layout Contract

### 1.1 Breakpoints

| Mode | Width | Navigation |
|---|---|---|
| **Mobile** | < 1024 px | Bottom navigation bar (6 items, fixed order) |
| **Desk Mode** | ≥ 1024 px | Left rail navigation (replaces bottom bar entirely) |

Flutter implementation:
```dart
// Use LayoutBuilder or MediaQuery, never hard-coded Device checks
final isDesk = MediaQuery.of(context).size.width >= 1024;
```

The same GoRouter routes are used in both modes. Navigation **structure** never changes — only the **chrome** (bottom bar vs. left rail).

### 1.2 App Shell

```
┌──────────────────────────────────────────────────────────────┐
│  [Mobile]   SafeArea top → content → SafeArea bottom → BottomNav │
├──────────────────────────────────────────────────────────────┤
│  [Desk]     LeftRail (240 dp fixed) | content (max 1200 dp centred)│
└──────────────────────────────────────────────────────────────┘
```

- Desk Mode content area: `max-width 1200 dp`, horizontally centred, minimum side padding `48 dp`.
- Mobile content area: horizontal padding `16 dp` (page edges), `24 dp` (card interiors).

### 1.3 Design Tokens (FROZEN)

```
— Spacing scale: 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 dp
— Radius scale:  4 / 8 / 12 / 16 / 24 dp
— Elevation:     0 / 1 / 2 / 4 (shadow tokens, not raw numbers)
— Icon size:     20 dp (inline), 24 dp (nav/action), 32 dp (feature)
```

### 1.4 Colour Palette (Swiss Precision + Friendly Calm)

| Token | Light | Dark |
|---|---|---|
| `surface` | `#FFFFFF` | `#121218` |
| `surfaceVariant` | `#F4F4F8` | `#1E1E28` |
| `onSurface` (Text/Primary) | `#0D0D14` | `#F2F2F8` |
| `onSurfaceSecondary` (Text/Secondary) | `#5A5A72` | `#9898B8` |
| `onSurfaceDisabled` (Text/Disabled) | `#ADADC8` | `#4A4A60` |
| `primary` (Royal Purple) | `#5B2D9E` | `#9B6DDE` |
| `primaryContainer` | `#EDE5FF` | `#2D1860` |
| `silver` (Metallic Royal Silver) | `#C0C4D6` | `#707898` |
| `error` | `#B3261E` | `#F2B8B5` |
| `success` | `#1B6B3A` | `#6FD49A` |

**Dark-mode rule:** Every text layer must be bound to a semantic token (`onSurface`, `onSurfaceSecondary`, `onSurfaceDisabled`). No hardcoded hex values on text layers.

### 1.5 Typography (FROZEN scale)

| Role | Font | Weight | Size |
|---|---|---|---|
| Display / Hero | DM Serif Display | Regular 400 | 40 dp |
| Headline L | DM Sans | SemiBold 600 | 28 dp |
| Headline M | DM Sans | SemiBold 600 | 22 dp |
| Title | DM Sans | Medium 500 | 18 dp |
| Body L | DM Sans | Regular 400 | 16 dp |
| Body M | DM Sans | Regular 400 | 14 dp |
| Label / Caption | DM Sans | Medium 500 | 12 dp |

---

## 2. Navigation Architecture

### 2.1 Bottom Navigation (Mobile, < 1024 dp)

Items (in order, **index and order are FROZEN**):

| Index | Label | Icon | GoRouter route | Notes |
|---|---|---|---|---|
| 0 | Home | `home_outline` | `/home` | Dashboard with all home sections |
| 1 | Topics | `grid_view_outlined` | `/topics` | Curriculum browser with filter chips |
| 2 | Practice | `edit_outlined` | `/practice` | Session setup + question player |
| 3 | Profile | `person_outline` | `/profile` | Settings; sub-pages push above shell |
| 4 | Tutor | `brain` / bot icon | `/tutor` | **Intentional** — free tips, credits, upsell |
| 5 | Help | `help_circle` | `/help` | **Intentional** — FAQ, contact, privacy |

Rules:
- Active tab icon: filled/glow variant, colour = `#5B8EFF` (Primary Blue).
- Inactive tab icon: outlined variant, colour = `#8A9DC0` (Muted).
- Label always visible (no icon-only mode on mobile).
- Bottom nav must always route correctly to root screens — no dead taps, no loops.
- Same-tab re-tap pops back to root of that branch (`goBranch(index, initialLocation: true)`).
- Implemented with `StatefulShellRoute.indexedStack`; each branch has its own `GlobalKey<NavigatorState>`.
- Profile sub-pages (Appearance, Accessibility, Subscription, Curriculum, Privacy) use `parentNavigatorKey: rootNavigatorKey` so they push full-screen above the shell with no bottom nav visible.

### 2.2 Left Rail Navigation (Desk Mode, ≥ 1024 dp)

```
┌──────────────┐
│  [Logo mark] │  24 dp icon + "CoachSuite" wordmark
│──────────────│
│  Home        │  ← rail item: 48 dp tall, icon 24 dp + label
│  Topics      │
│  Practice    │
│  Profile     │
│  Tutor       │  ← intentional; same as mobile tab 4
│  Help        │  ← intentional; same as mobile tab 5
└──────────────┘
```

Rail item anatomy (re-uses existing `ListRow` style):
- Width: 240 dp fixed.
- Item height: 48 dp.
- Padding: 16 dp horizontal.
- Active state: `primaryContainer` background fill, `#5B8EFF` icon + label.
- Inactive: transparent background, `#8A9DC0` icon + label.
- 6 items match 6 mobile tabs exactly — no additional "Settings" rail slot.

### 2.3 Prototype Integrity Rules

Every tappable element must have a wired destination. Audit checklist:

- [ ] All bottom nav tabs route to their root screen.
- [ ] All back buttons navigate to the correct parent.
- [ ] All list row chevrons open detail views.
- [ ] All primary CTA buttons advance the flow.
- [ ] Practice flow is end-to-end: **Practice Setup → Question Player → Results → Review Mistakes → Back to Practice**.
- [ ] "View all" / "See more" links resolve.
- [ ] Settings rows with no current destination: remove chevron affordance rather than leave a dead tap. Prefer wiring if a logical destination exists.

---

## 3. Market Pack & ENV Variant Rules

### 3.1 Market Packs

One unified app binary serves all markets. Market pack is selected at runtime (locale + subscription). Markets:

`UK · DK · NO · SE · KR · SG · US · CH · DE · AR`

- All markets share the same screen layouts defined in this document.
- Copy and currency symbols are localised via ARB/l10n — do not hardcode strings.
- Date, number, and unit formatting follows device locale.

### 3.2 Switzerland Special Variant (`_WelcomeCH`)

The Switzerland Welcome screen has a **language selector** that must never be standardised to English-only. It renders language chips before the main CTA:

```
[ Deutsch ]  [ Français ]  [ Italiano ]
```

- Chip style: `Chip` component from the design system, outlined variant.
- Selected chip: `primary` fill, `onPrimary` label.
- Unselected chip: `outline` border `silver`, `onSurface` label.
- Tapping a chip sets the app locale immediately; CTA then proceeds with the chosen locale.
- This variant lives at `WelcomeScreen` with a `isCH: true` flag — do not build a separate screen route.

**Required Swiss locales (all three are mandatory at launch):**

| Locale | ARB file | Notes |
|---|---|---|
| `de_CH` | `app_de_CH.arb` | Swiss German |
| `fr_CH` | `app_fr_CH.arb` | Swiss French |
| `it_CH` | `app_it_CH.arb` | Swiss Italian |
| `en_GB` | `app_en_GB.arb` | Fallback; also the ARB base locale |

`en` is the base (template) ARB. `en_GB` contains UK-specific overrides only. When a key is absent from a Swiss locale ARB, Flutter `gen-l10n` falls back through the language locale and then to `en`. Add new user-facing keys to `app_en.arb` first, then translate them into all three Swiss ARBs.

### 3.3 ENV Variants

| ENV | Effect |
|---|---|
| `prod` | Full production; no admin entry points visible anywhere |
| `uat_admin` | UAT build + user has `platform_admin` or `support_admin` role → "Administration" settings row appears |
| `uat_user` | UAT build + standard learner role → no admin row |

Admin row rules:
- Renders **only** when `ENV == uat` AND `userRole` is an admin role.
- Opens the shared Control Plane URL via `url_launcher` (external browser).
- In `prod`: the row must not exist in the widget tree at all (not hidden, not disabled — absent).
- Admin screens do not exist inside the learner app.

---

## 4. Screen Layouts

### 4.1 Welcome / Role Select

**Purpose:** First-run onboarding and role selection (Parent / Student / Self-Study).

**Mobile layout:**
```
SafeArea
  Column
    Spacer(32)
    Logo (centred, 80 dp)
    Spacer(24)
    DisplayText  "Master Maths,  ← DM Serif Display, onSurface
    at your pace."
    Spacer(8)
    BodyL subtitle            ← onSurfaceSecondary
    Spacer(48)
    [CH only] Language chips row (Wrap, gap 8 dp)
    Spacer(32)
    RoleCard × 3              ← full-width cards, 16 dp vertical gap
    Spacer(24)
    TextButton "Sign in"      ← onSurfaceSecondary
    SafeArea bottom
```

**Desk Mode (≥ 1024 dp):**
```
Row
  Left panel (50% width, surfaceVariant bg)
    Centred vertical stack: Logo + Display headline + subtitle
  Right panel (50% width)
    Centred vertical stack: [CH chips] + RoleCards + Sign-in link
```

**GoRouter:** `/welcome` (initial route, no back button).

---

### 4.2 Home Dashboard

**Purpose:** Primary landing after authentication. All sections listed below are approved and intentional — do not remove any.

**Mobile layout:**
```
Scaffold (no AppBar — shell AppBar shows tab title)
  Body → SingleChildScrollView → Column, padding 16 dp
    _HeroGreeting
      "Good [time-of-day], [Name]"  ← headlineMedium, bold
      "· N minutes to hit your streak goal"  ← caption, #8A9BB8

    SectionLabel "CONTINUE LEARNING"  ← view-all action
    _ContinueLearningCard  (gradient card, topic + progress bar + arrow)

    _StartPracticeButton  ← gradient CTA, routes to /practice

    SectionLabel "TOPICS"  ← view-all action
    _TopicRowCard (Fractions & Percentages)
    _TopicRowCard (Algebra Basics)
    _TopicRowCard (Statistics & Probability)

    SectionLabel "PROGRESS"
    Row [
      _ProgressCompactCard: Streak (fire icon, count, first-day label)
      _ProgressCompactCard: This Week (calendar icon, days/5)
    ]

    SectionLabel "ACHIEVEMENTS"
    _AchievementsCard  (badge icon, weekly streak title + subtitle)

    SectionLabel "OXFORD TRACK"  ← premium upsell; intentional
    _OxfordTrackCard
      graduation-cap icon | "Oxford Track" + "PREMIUM REQUIRED" pill
      "11+ prep, advanced challenges & competition maths"

    SectionLabel "LEARNING PATHS"  ← intentional
    Row [
      _LearningPathCard (Fractions)
      _LearningPathCard (Statistics)
    ]

    SectionLabel "EXAM PACKS"  ← premium upsell; intentional
    _ExamPacksCard
      book icon | "Exam Packs" | "Targeted exam preparation"
      "View Exam Packs" outlined button

  BottomNav (kBottomNavigationBarHeight + SafeArea.bottom + AppSpacing.xl padding)
```

**Desk Mode (≥ 1024 dp):** Same sections, max content width constrained by `AppResponsive.contentMaxWidth`. Single column layout (no two-column split required on Home).

**GoRouter:** `/home`.

---

### 4.3 Topics List

**Purpose:** Browse the full curriculum by topic/strand.

**Mobile layout:**
```
Scaffold
  AppBar: "Topics"
  Body → CustomScrollView
    SliverPadding(16 dp)
    SearchBar (full width)
    Spacer 12
    ChipRow (filter by strand: All / Number / Algebra / Geometry / Statistics)
    Spacer 16
    SliverList of TopicCard
      TopicCard: icon | topic name | progress bar | "X questions" | chevron
  BottomNav
```

**Desk Mode (≥ 1024 dp):**
- 2-column `SliverGrid` for topic cards.
- Strand filter chips move to a left-side filter panel (160 dp wide) inside the content area; search bar stays top-full-width.

**GoRouter:** `/topics` → `/topics/:topicId` (detail).

---

### 4.4 Practice Setup

**Purpose:** Configure a practice session (topic, difficulty, question count, timed mode).

**Mobile layout:**
```
Scaffold
  AppBar: "Practice Setup"  ← back arrow
  Body → Column, padding 16 dp
    SectionLabel "Topic"
    TopicSelectorRow (tappable list row or bottom-sheet picker)
    Spacer 16
    SectionLabel "Difficulty"
    SegmentedControl [Starter | Core | Extension]
    Spacer 16
    SectionLabel "Questions"
    StepperRow (− 10 +), range 5–50
    Spacer 16
    SectionLabel "Timed Mode"
    SwitchRow
    Spacer 32
    PrimaryButton "Start Practice"  ← full width, 56 dp tall
  BottomNav hidden (modal flow)
```

**Desk Mode (≥ 1024 dp):**
- Centred card (max 600 dp wide), elevation 2.
- Two-column form grid: Topic + Difficulty top row; Questions + Timed bottom row.
- CTA button full-width of card.

**GoRouter:** `/practice/setup`.

---

### 4.5 Question Player

**Purpose:** Core practice experience. Full-screen, distraction-free.

**Mobile layout:**
```
Scaffold (no AppBar — custom top bar)
  SafeArea
    TopBar row: [X close] [ProgressBar flex] [Q n/N label]
    Spacer 24
    QuestionCard (elevation 1, radius 16)
      QuestionText (Headline M, onSurface)
      [Math rendering widget or image if present]
    Spacer 24
    AnswerOptions Column
      AnswerTile × 4 (full width, outlined, 56 dp tall)
      — On selection: highlight chosen tile (primaryContainer)
      — On reveal: correct=success fill, incorrect=error fill, correct answer=success outline
    Spacer auto
    FooterRow: [Skip] [Check / Next →]
```

**Desk Mode (≥ 1024 dp):**
```
AppShell (LeftRail, no bottom-nav)
  Content → Centred column max 720 dp
    TopBar (same as mobile)
    Row (gap 48 dp)
      Left (55%): QuestionCard + AnswerOptions
      Right (45%): ProgressPanel (question list, time if timed, streak indicator)
```

**GoRouter:** `/practice/play/:sessionId`.

Rules:
- Back/close on this screen must confirm exit (dialog: "End session? Progress will be saved.").
- No ads, no banners on this screen in any ENV.

---

### 4.6 Results

**Purpose:** End-of-session summary.

**Mobile layout:**
```
Scaffold (no BottomNav)
  AppBar: none (full-bleed hero)
  Body → Column
    ResultHero (primaryContainer bg, top-rounded 24 dp)
      ScoreDisplay (Display/Hero size)
      Subtitle "X/N correct · Y seconds"
    Spacer 24
    StatsRow: Accuracy % | Time | Streak
    Spacer 16
    [If mistakes > 0] SecondaryButton "Review Mistakes"
    Spacer 8
    PrimaryButton "Practice Again"
    Spacer 8
    TextButton "Back to Home"
```

**Desk Mode (≥ 1024 dp):**
- Centred card max 640 dp, elevation 2.
- Stats row becomes a 3-column horizontal layout.
- Buttons full-width of card.

**GoRouter:** `/practice/results/:sessionId`.

---

### 4.7 Review Mistakes

**Purpose:** Step through incorrect answers with correct solution shown.

**Mobile layout:**
```
Scaffold
  AppBar: "Review Mistakes"  ← back arrow
  Body → PageView (horizontal swipe between questions)
    ReviewCard
      QuestionText
      YourAnswerRow (error colour)
      CorrectAnswerRow (success colour)
      [Optional] ExplanationText (BodyM, onSurfaceSecondary)
  FooterRow: [← Prev] [n/N] [Next →]
  BottomNav hidden
```

**Desk Mode:** Same centred-card approach as Question Player (max 720 dp), no side panel needed.

**GoRouter:** `/practice/review/:sessionId`.

---

### 4.8 Progress / Reports

> **⚠ SUPERSEDED — see "Superseded Previous Spec Items" at the bottom of this document.**
>
> A dedicated Progress tab and `/progress` route no longer exist. Streak and weekly-activity progress are now **sections within the Home Dashboard** (section 4.2). Do not add a `Progress` bottom-nav tab or a `/progress` route.

The streak and week-activity widgets that previously anchored this screen now live in the Home Dashboard as:
- `_ProgressCompactCard` (Streak) — fire icon, streak count
- `_ProgressCompactCard` (This Week) — calendar icon, days active / 5

Full analytics views (accuracy charts, mastery breakdowns) are on the product roadmap and will be designed as a new surface when requirements are confirmed. They must not be added to the current navigation until then.

---

### 4.9 Profile / Settings

**Purpose:** Account, subscription, preferences, support.

**Mobile layout:**
```
Scaffold
  AppBar: "Profile"
  Body → SingleChildScrollView → Column, padding 16 dp
    ProfileHeader (avatar | name | subscription badge)
    Spacer 24
    SettingsSection "Account"
      ListRow: "Email" + value
      ListRow: "Change Password"
    SettingsSection "Subscription"
      ListRow: "Current Plan" + badge
      ListRow: "Manage Subscription"
    SettingsSection "Preferences"
      SwitchRow: "Dark Mode"
      SwitchRow: "Notifications"
      ListRow: "Language" + current locale
    SettingsSection "Support"
      ListRow: "Help Centre"
      ListRow: "Privacy Policy"
      ListRow: "Terms of Service"
    [UAT admin role only]
    SettingsSection "Administration"   ← renders ONLY when ENV=uat AND admin role
      ListRow: "Control Plane →"       ← opens url_launcher, external browser
    Spacer 24
    TextButton "Sign Out" (error colour)
  BottomNav
```

**Desk Mode (≥ 1024 dp):**
- 2-column layout: left column = ProfileHeader + Account + Subscription, right column = Preferences + Support (+ Admin if applicable).

**GoRouter:** `/profile`.

**Admin row guard (Flutter):**
```dart
if (AppConfig.isUat && userRole.isAdmin)
  SettingsRow(
    label: 'Control Plane',
    onTap: () => launchUrl(Uri.parse(AppConfig.controlPlaneUrl)),
  ),
```

---

## 5. Accessibility Requirements

- Minimum tap target: **48 × 48 dp** for all interactive elements. Achieve via padding; do not change layout geometry.
- All text meets WCAG AA contrast in both light and dark modes (use semantic tokens only).
- All icons must have `semanticsLabel` set.
- Screen reader traversal order must match visual top-to-bottom, left-to-right.
- Form input labels must always be visible (not placeholder-only).
- Small helper text: use `onSurfaceSecondary` (not `onSurfaceDisabled`) to preserve legibility.

---

## 6. Dark Mode Rules

1. All text must use semantic colour tokens — never hardcoded hex.
2. Semantic mapping:

   | Text role | Token |
   |---|---|
   | Screen titles, section headers, primary numbers | `onSurface` |
   | Subtitles, helper text, descriptions | `onSurfaceSecondary` |
   | Disabled labels, non-essential hints | `onSurfaceDisabled` |
   | Text on coloured fills (e.g. primary button) | `onPrimary` |

3. Validate all 8 core screens in dark mode before handoff sign-off.
4. Surface backgrounds must swap to dark tokens — no white surface visible in dark mode.

---

## 7. Stability Pass Rules (Design Reviews)

When performing a design review or stability pass, the following scope rules are **non-negotiable**:

**NEVER change in a pass:**
- Navigation structure or screen count.
- Layout geometry, spacing scale, or radius scale.
- Typography scale or font families.
- Component shapes or iconography.
- Copy (unless fixing missing/incorrect accessibility label).
- Feature set or user flows.

**ONLY fix in a pass:**
- Dark-mode text legibility (token bindings).
- Missing or broken prototype links.
- Accessibility: contrast, tap target padding, semantic labels.
- Admin env-guard compliance (remove admin surfaces from prod variants).

---

## 8. Desk Mode — Build Checklist

For each screen converted to Desk Mode:

- [ ] Frame renamed with suffix ` (Desk Mode ≥1024)`.
- [ ] Annotation note present: *"Desk Mode: Auto at ≥1024px. Mobile layout unchanged."*
- [ ] Left rail present and correctly wired.
- [ ] Bottom nav absent.
- [ ] Content max-width 1200 dp, centred, min side padding 48 dp.
- [ ] 2-column grid applied to dashboard/list screens.
- [ ] Mobile frames pixel-identical to pre-Desk-Mode state.
- [ ] Dark mode validated on Desk Mode frames.
- [ ] All prototype connections work from Desk Mode frames.

---

## 9. Flutter Implementation Notes

### 9.1 Routing

Implemented with `StatefulShellRoute.indexedStack` (6 branches). Settings sub-pages use `parentNavigatorKey: rootNavigatorKey` so they appear full-screen above the shell without a bottom nav bar.

```dart
// GoRouter — all routes defined centrally
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(path: '/onboarding',  builder: ...),  // onboarding flow
    GoRoute(path: '/auth/sign-in', builder: ...),
    GoRoute(path: '/auth/create',  builder: ...),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(navigatorKey: _homeNavKey, routes: [
          GoRoute(path: '/home',     builder: ...),  // tab 0
        ]),
        StatefulShellBranch(navigatorKey: _topicsNavKey, routes: [
          GoRoute(path: '/topics',   builder: ...),  // tab 1
        ]),
        StatefulShellBranch(navigatorKey: _practiceNavKey, routes: [
          GoRoute(path: '/practice', builder: ..., routes: [
            GoRoute(path: 'question', builder: ...),
            GoRoute(path: 'results',  builder: ...),
          ]),
        ]),
        StatefulShellBranch(navigatorKey: _profileNavKey, routes: [
          GoRoute(path: '/profile',  builder: ..., routes: [  // tab 3
            GoRoute(parentNavigatorKey: _rootNavigatorKey, path: 'appearance',   builder: ...),
            GoRoute(parentNavigatorKey: _rootNavigatorKey, path: 'accessibility',builder: ...),
            GoRoute(parentNavigatorKey: _rootNavigatorKey, path: 'subscription', builder: ...),
            GoRoute(parentNavigatorKey: _rootNavigatorKey, path: 'curriculum',   builder: ...),
            GoRoute(parentNavigatorKey: _rootNavigatorKey, path: 'privacy',      builder: ...),
          ]),
        ]),
        StatefulShellBranch(navigatorKey: _tutorNavKey, routes: [
          GoRoute(path: '/tutor',    builder: ...),  // tab 4
        ]),
        StatefulShellBranch(navigatorKey: _helpNavKey, routes: [
          GoRoute(path: '/help',     builder: ...),  // tab 5
        ]),
      ],
    ),
  ],
);
```

> **Note:** `/progress` as a standalone route is **superseded** — see "Superseded Previous Spec Items".

### 9.2 Responsive Shell

```dart
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final isDesk = MediaQuery.of(context).size.width >= 1024;
    return isDesk
        ? Row(children: [const LeftRailNav(), Expanded(child: child)])
        : Scaffold(body: child, bottomNavigationBar: const BottomNav());
  }
}
```

### 9.3 Market Pack Locale

```dart
// Pass locale through MaterialApp; never hardcode strings
MaterialApp.router(
  locale: userSelectedLocale, // CH: user-selected from chip
  supportedLocales: AppLocales.supported,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  ...
)
```

### 9.4 ENV Config

```dart
enum AppEnv { prod, uatAdmin, uatUser }

class AppConfig {
  static final AppEnv env = _resolveEnv();
  static bool get isUat => env == AppEnv.uatAdmin || env == AppEnv.uatUser;
  static final String controlPlaneUrl = const String.fromEnvironment('CONTROL_PLANE_URL');

  static AppEnv _resolveEnv() {
    const e = String.fromEnvironment('APP_ENV', defaultValue: 'prod');
    return switch (e) {
      'uat_admin' => AppEnv.uatAdmin,
      'uat_user'  => AppEnv.uatUser,
      _           => AppEnv.prod,
    };
  }
}
```

---

---

## Superseded Previous Spec Items

The following items from earlier drafts are **superseded** and must no longer be treated as requirements.

| Superseded Item | Approved Replacement |
|---|---|
| 5-item bottom nav: Home / Topics / Practice / Progress / Profile | **6-tab nav: Home / Topics / Practice / Profile / Tutor / Help** |
| "Bottom navigation bar (5 items max)" breakpoint rule | **6 items, fixed order** |
| Progress as a dedicated nav tab (index 3, `/progress` route) | **Progress sections live within Home Dashboard** |
| Left rail showing: Home / Topics / Practice / Progress / Profile | **Left rail shows all 6 tabs: + Tutor + Help** |
| Home Dashboard showing: StreakBanner / Today's Focus / Weak Spots / Recent Activity | **Approved Home sections: Greeting, Continue Learning, Start Practice CTA, Topics, Progress, Achievements, Oxford Track, Learning Paths, Exam Packs** |
| Oxford Track / GCSE Foundation / GCSE Higher / Exam Packs / Tutor credits as provisional | **All are confirmed, intentional premium upsell features** |
| Swiss locales optional or future-ready | **de_CH, fr_CH, it_CH required at launch; en_GB is the ARB base and fallback** |
| Tutor and Help surfaces buried under "More" tab | **Tutor (tab 4) and Help (tab 5) are first-class destinations** |

Any implementation that reverts to a 5-tab layout, removes the Tutor or Help tab, restores a standalone Progress tab, or treats Swiss locales as optional is **non-compliant** with the current approved spec.

---

*Document version: 2026-05-18. All changes require explicit written approval against the frozen design system.*
