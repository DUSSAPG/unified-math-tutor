# FIGMA → FLUTTER HANDOFF SPECIFICATION
**MathTutor Unified Design System**

---

## Project Overview

### Application Identity
- **App Name**: MathTutor (launcher), CoachSuite MathTutor (internal)
- **Global Launcher Name**: "MathTutor" (all markets)
- **Design Philosophy**: Swiss precision + friendly calm
- **Visual Language**: Metallic Royal Silver + Purple luxury palette
- **Platform Priority**: Android-first, developed on Windows
- **Baseline Device**: iPhone 16 Pro Max
- **Responsive Range**: iPhone SE → iPhone 17 + Android devices

### Target Audience
- **Primary**: Students (ages 10-18, curriculum-aligned)
- **Secondary**: Parents/Guardians (monitoring, payment)

### Market Strategy
- **Launch Market**: United Kingdom (UK, en-GB, curriculum-first)
- **Active Markets**: UK, Denmark, Norway, Sweden, South Korea, Singapore, United States, Switzerland, Germany, Arabic regions
- **Market Packs**: Each market = discrete l10n bundle inside unified app
- **Switzerland Exception**: Multi-lingual welcome screen with Deutsch/Français/Italiano language chips (never standardized to English)

### Multilingual Support (Future-Ready)
- English (en-GB, en-US)
- French (fr-FR, fr-CH)
- German (de-DE, de-CH)
- Italian (it-CH)
- Korean (ko-KR)
- Danish (da-DK)
- Norwegian (nb-NO)
- Swedish (sv-SE)
- Arabic (ar, RTL-ready)

---

## Global Design Tokens

### Color Palette (FROZEN)
**Navy Gradient Foundation**
```
Navy Base       #0B1120   Background, app shell
Card Surface    #132040   Elevated content cards
Primary Blue    #3D7EFF   CTAs, selected states, focus rings
Border Subtle   #1F3055   Dividers, card strokes
Muted Text      #8A9DC0   Secondary labels, hints
Dim Text        #4A6080   Tertiary content, timestamps
```

**Luxury Accent**
```
Metallic Royal Silver   (gradient overlay on premium badges)
Purple Accent           (premium tier indicators)
```

**Semantic Colors**
```
Success Green   #34C759   Correct answers, achievements
Warning Amber   #FF9F0A   Hints, caution states
Error Red       #FF3B30   Incorrect answers, validation errors
Info Blue       #3D7EFF   Tips, informational callouts
```

**Opacity Scale**
```
Overlay         rgba(11, 17, 32, 0.92)   Modal backgrounds
Subtle Glow     rgba(61, 126, 255, 0.15) Selected state halos
Hover           rgba(61, 126, 255, 0.08) Interactive hover states
```

### Typography (FROZEN)
**Type Scale**
```
Large Hero      DM Serif Display, 32sp, weight 600, line-height 1.2, letter-spacing -0.5%
Page Header     DM Sans, 24sp, weight 700, line-height 1.3, letter-spacing -0.3%
Section Header  DM Sans, 20sp, weight 600, line-height 1.4
Card Title      DM Sans, 18sp, weight 600, line-height 1.4
Body            DM Sans, 16sp, weight 400, line-height 1.5
Caption         DM Sans, 14sp, weight 500, line-height 1.4, color #8A9DC0
Small Label     DM Sans, 12sp, weight 500, line-height 1.3, color #4A6080
```

**Type Rules**
- **Serif Usage**: Only for hero sections (Welcome, Onboarding, Empty States)
- **Sans Usage**: All UI, navigation, body content, buttons, labels
- **Weight Restrictions**: Never use weight < 400 or > 700
- **Arabic Override**: Use system Arabic font with matching optical weights

### Spacing Scale (FROZEN)
```
xs      4dp     Icon-to-label gaps, tight chip padding
sm      8dp     Card internal padding (vertical), label margins
md      12dp    Card internal padding (horizontal), button padding
lg      16dp    Section spacing, card gaps
xl      24dp    Screen edge padding (horizontal), major section breaks
2xl     32dp    Top-of-screen safe area padding
3xl     48dp    Empty state vertical spacing
```

**Spacing Composition Rules**
- **Stack Spacing**: Always use lg (16dp) between cards in vertical scrolls
- **Edge Padding**: xl (24dp) horizontal margins on all screens
- **Bottom Nav Clearance**: 80dp + SafeArea.bottom (includes 16dp spacer)
- **Section Headers**: 2xl (32dp) top margin, lg (16dp) bottom margin

### Corner Radius (FROZEN)
```
Buttons         12dp    All CTAs, chips, segmented controls
Cards           16dp    All elevated surfaces (Topic, Progress, Tutor cards)
Modals/Sheets   20dp    Bottom sheets, dialogs (top corners only)
Avatar/Badges   50%     Circular profile images, premium badges
```

### Elevation & Shadows (FROZEN)
**Soft Premium Shadow Only**
```css
box-shadow: 0px 4px 16px rgba(0, 0, 0, 0.12),
            0px 1px 4px rgba(0, 0, 0, 0.08);
```
- **Applied To**: Cards, Bottom Nav, Floating Action Buttons, Modals
- **Never Applied To**: Chips, badges, inline buttons, text fields

### Iconography (FROZEN)
- **Library**: Lucide Icons (Flutter: `lucide_icons` package)
- **Sizes**: 20dp (inline), 24dp (navigation), 32dp (feature icons), 48dp (empty states)
- **Stroke Width**: 2dp (consistent across all sizes)
- **Color Inheritance**: Icons inherit parent text color unless specified

---

## Navigation System

### Bottom Navigation Bar
**Structure (Mobile < 1024px)**
```
Home  |  Topics  |  Practice  |  Profile  |  Tutor  |  Help
[icon]|  [icon]  |   [icon]   |  [icon]   | [icon]  | [icon]
```

**Specifications**
- **Height**: 64dp + SafeArea.bottom
- **Background**: #132040 (Card Surface)
- **Shadow**: Soft Premium Shadow (top edge only)
- **Item Spacing**: Distributed evenly with flex
- **Selected State**: 
  - Icon Color: #3D7EFF (Primary Blue)
  - Label Weight: 600
  - Glow: 0px 0px 12px rgba(61, 126, 255, 0.4)
- **Unselected State**:
  - Icon Color: #8A9DC0 (Muted)
  - Label Weight: 500
  - No glow

**Tabs Definition** (index 0–5, order is FROZEN)
1. **Home** (index 0): Dashboard — Continue Learning card, Start Practice CTA, Topics preview, Progress (Streak + This Week), Achievements, Oxford Track, Learning Paths, Exam Packs
2. **Topics** (index 1): Curriculum browser — filter chips (All / Practice / Recommended / Oxford Track / GCSE / More), Track selector panel, per-topic progress bars
3. **Practice** (index 2): Session setup — mode cards (Quick Start / Topic Drill / Timed Challenge / Exam Simulator), question count selector, in-session question player
4. **Profile** (index 3): Settings — Appearance, Accessibility, Subscription, Curriculum Settings, Privacy & Data, Sign Out
5. **Tutor** (index 4): AI assistant — free tips (3/day guest), credit chips (Deep Explanation / Step-by-step / Mistake Analysis), credit balance pill, paid pack upsell card. **This tab is intentional and must not be removed.**
6. **Help** (index 5): Support hub — FAQ (expandable), Contact, Privacy & Safety, Terms of Use, Parental Controls, Report a Problem. **This tab is intentional and must not be removed.**

**Interaction Rules**
- **Tap Behavior**: Navigate immediately, no confirmation
- **Current Tab Re-Tap**: Scroll to top of current screen
- **Overlay Rule**: Bottom nav NEVER obscured by content (always use bottom padding)
- **Safe Area**: Must extend behind home indicator on iOS

### Desk Mode Navigation (≥1024dp)
**Left Rail Replacement**
- **Width**: 240dp fixed
- **Background**: #0B1120 (Navy Base)
- **Items**: Same 6 tabs as mobile, vertically stacked (Home, Topics, Practice, Profile, Tutor, Help)
- **Selection**: Full-width highlight bar (#3D7EFF, 4dp left border)
- **Collapse**: Not supported (always visible in desk mode)

### Navigation Behavior
- **Deep Linking**: All screens must support GoRouter named routes
- **Back Stack**: Preserve within each tab (separate navigators)
- **Cross-Tab Navigation**: Reset back stack of destination tab
- **Admin Gate**: "Administration" row only renders when `ENV=uat` AND user has admin role; opens Control Plane via `url_launcher`

---

## Component Library

### 1. Topic Card
**Purpose**: Display curriculum subject with progress indicator

**Specifications**
```
Width:          fill parent - 48dp (24dp edge padding × 2)
Height:         auto (min 120dp)
Background:     #132040 (Card Surface)
Corner Radius:  16dp
Shadow:         Soft Premium Shadow
Padding:        16dp (all sides)
```

**Content Layout**
```
┌─────────────────────────────────┐
│ [Icon 32dp]  Title (Card Title) │ ← 12dp gap between icon and text
│              Subtitle (Caption) │
│                                 │
│ ━━━━━━━━━━━━━━━━━━━ 75%        │ ← Progress bar (4dp height, 12dp radius)
│                                 │
└─────────────────────────────────┘
```

**States**
- **Default**: Opacity 1.0, no border
- **Pressed**: Opacity 0.9, scale 0.98 (150ms ease-out)
- **Disabled**: Opacity 0.5, no interaction

**Responsive Rules**
- Max width: 430dp (center in wider viewports)
- Stack vertically with 16dp gap
- Never horizontal scroll

### 2. Progress Card
**Purpose**: Visualize user achievement metrics

**Specifications**
```
Width:          fill parent - 48dp
Height:         auto (min 100dp)
Background:     #132040
Corner Radius:  16dp
Shadow:         Soft Premium Shadow
Padding:        16dp
```

**Content Layout**
```
┌─────────────────────────────────┐
│ Metric Label (Caption)          │
│ 156 (Page Header, #3D7EFF)      │ ← Large number, primary blue
│ Streak: 7 days (Body)           │
└─────────────────────────────────┘
```

**Variants**
- **Streak Card**: Fire icon, days count
- **Accuracy Card**: Target icon, percentage
- **Problems Solved**: Checkmark icon, count

### 3. Tutor Card (Monetization Component)
**Purpose**: Display AI tutor tips with paywall enforcement

**Specifications**
```
Width:          fill parent - 48dp
Height:         auto
Background:     #132040
Border:         1dp solid #1F3055
Corner Radius:  16dp
Padding:        16dp
```

**Guest State (0/3 tips used)**
```
┌─────────────────────────────────┐
│ 💡 Tutor Tip                    │
│ [Tip content] (Body)            │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Get Hint (Primary Button)   │ │ ← Deducts 1 tip
│ └─────────────────────────────┘ │
│ 2 free tips remaining (Caption) │
└─────────────────────────────────┘
```

**Guest State (3/3 tips used)**
```
┌─────────────────────────────────┐
│ 🔒 Unlock Unlimited Tips        │
│ Start your free trial (Body)    │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Start Trial (Primary Button)│ │ ← Opens paywall
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

**Paid State**
```
┌─────────────────────────────────┐
│ 💡 [Tip content]                │
│                                 │
│ ┌──────────┐ ┌────────────────┐ │
│ │ Hint     │ │ Deep Explanation│ │ ← Deep = credit deduction
│ └──────────┘ └────────────────┘ │
│ ∞ Unlimited tips (Caption)      │
└─────────────────────────────────┘
```

**Monetization Logic**
- **Guest**: 3 free tips total (not per session)
- **Trial**: Limited tips (defined in paywall config)
- **Paid**: Unlimited hints, credits for deep explanations
- **Credit System**: 1 credit = 1 deep explanation (replenishes monthly)

### 4. Premium Badge
**Purpose**: Indicate subscription status

**Specifications**
```
Width:          auto (fit content + 16dp padding)
Height:         28dp
Background:     Linear gradient (Metallic Royal Silver → Purple)
Corner Radius:  50% (pill shape)
Padding:        8dp horizontal, 4dp vertical
```

**Content**
```
★ PRO (Small Label, white, weight 600)
```

**Placement**
- Profile screen: Top-right of avatar
- Settings: Inline with "Subscription" row

### 5. Profile Settings Card
**Purpose**: Grouping related settings rows

**Specifications**
```
Width:          fill parent - 48dp
Height:         auto
Background:     #132040
Corner Radius:  16dp
Padding:        0dp (rows have internal padding)
```

**Row Structure**
```
┌─────────────────────────────────┐
│ [Icon 24dp]  Label (Body)    >  │ ← 16dp padding all sides, 12dp icon-label gap
├─────────────────────────────────┤ ← 1dp divider, #1F3055
│ [Icon 24dp]  Label (Body)    >  │
└─────────────────────────────────┘
```

**States**
- **Default**: Background #132040
- **Pressed**: Background rgba(61, 126, 255, 0.08)

### 6. Question Card (Practice Mode)
**Purpose**: Display math problem with workspace

**Specifications**
```
Width:          fill parent - 48dp
Height:         auto (min 200dp)
Background:     #132040
Corner Radius:  16dp
Padding:        20dp
```

**Content Layout**
```
┌─────────────────────────────────┐
│ Question 3 of 10 (Caption)      │
│                                 │
│ Solve for x: (Card Title)       │
│ 2x + 5 = 13 (Page Header, center)│
│                                 │
│ ┌─────────────────────────────┐ │
│ │ [Answer input field]        │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌──────────┐ ┌────────────────┐ │
│ │ Hint     │ │ Check Answer   │ │
│ └──────────┘ └────────────────┘ │
└─────────────────────────────────┘
```

**Answer States**
- **Unanswered**: Border #1F3055
- **Correct**: Border #34C759, background rgba(52, 199, 89, 0.1)
- **Incorrect**: Border #FF3B30, background rgba(255, 59, 48, 0.1)

### 7. Learning Path Card
**Purpose**: Display sequential topic progression

**Specifications**
```
Width:          fill parent - 48dp
Height:         auto
Background:     transparent
Padding:        0dp
```

**Content Layout (Vertical Timeline)**
```
● Topic 1 (complete)     ← #34C759 dot, 8dp diameter
│
● Topic 2 (current)      ← #3D7EFF dot, 12dp diameter (pulsing)
│
○ Topic 3 (locked)       ← #4A6080 dot, 8dp diameter, hollow
```

**Connection Line**
- Width: 2dp
- Color: #1F3055
- Connects center of dots

### 8. Search Field
**Purpose**: Filter topics, problems, help articles

**Specifications**
```
Width:          fill parent - 48dp
Height:         48dp
Background:     #132040
Border:         1dp solid #1F3055
Corner Radius:  12dp
Padding:        12dp horizontal
```

**Content**
```
[🔍 Icon 20dp]  Placeholder text (Body, #8A9DC0)
```

**States**
- **Default**: Border #1F3055
- **Focus**: Border #3D7EFF, glow 0px 0px 8px rgba(61, 126, 255, 0.3)
- **Filled**: Text color white

### 9. Segment Chip (Filter Control)
**Purpose**: Toggle between view modes or filters

**Specifications**
```
Height:         36dp
Background:     #132040 (unselected), #3D7EFF (selected)
Border:         1dp solid #1F3055 (unselected), none (selected)
Corner Radius:  12dp
Padding:        12dp horizontal
```

**Content**
```
Label (Small Label, #8A9DC0 unselected, white selected)
```

**Group Behavior**
- Chips inline with 8dp gap
- Single-select or multi-select (context dependent)
- Horizontal scroll if overflow

### 10. Progress Bar (Linear)
**Purpose**: Visualize completion percentage

**Specifications**
```
Width:          fill container
Height:         4dp
Background:     #1F3055 (track)
Foreground:     #3D7EFF (fill)
Corner Radius:  12dp (fully rounded)
```

**Animation**
- Fill animates from 0 → target % over 600ms ease-out
- No animation on initial render if value > 0

### 11. CTA Buttons

#### Primary Button
```
Height:         48dp
Background:     #3D7EFF
Corner Radius:  12dp
Padding:        16dp horizontal
Shadow:         0px 2px 8px rgba(61, 126, 255, 0.3)
Label:          Body weight 600, white
```

**States**
- **Pressed**: Background #2D6EEF, scale 0.97
- **Disabled**: Background #1F3055, label #4A6080, no shadow

#### Secondary Button
```
Height:         48dp
Background:     transparent
Border:         1dp solid #3D7EFF
Corner Radius:  12dp
Padding:        16dp horizontal
Label:          Body weight 600, #3D7EFF
```

**States**
- **Pressed**: Background rgba(61, 126, 255, 0.1)
- **Disabled**: Border #1F3055, label #4A6080

#### Text Button
```
Height:         auto (min 40dp)
Background:     transparent
Padding:        8dp horizontal
Label:          Body weight 600, #3D7EFF
```

**States**
- **Pressed**: Opacity 0.7

---

## Screen Specifications

### Welcome Screen
**Layout**
```
Safe Area Top (2xl padding)
─────────────────────────
Logo (48dp height)

Welcome to (Caption)
MathTutor (Large Hero, DM Serif Display)

Subtitle (Body, #8A9DC0, centered)

[Illustration 200dp height]

Spacer (flex)

[Get Started Button (Primary)]
[Sign In Button (Text)]

Safe Area Bottom + 24dp
```

**Switzerland Variant (_WelcomeCH)**
- Add language chips ABOVE "Get Started":
  - Deutsch | Français | Italiano
  - Horizontal layout, 8dp gap
  - Segment chip styling
  - Sets app locale on selection

### Home Screen (Dashboard)
**Layout** — all sections below are approved and intentional; do not remove any.
```
Safe Area Top
─────────────────────────
[Hero Greeting]
  Good [time-of-day], [Name]  (Page Header, bold)
  · N minutes to hit your streak goal  (Caption, #8A9BB8)

[Section: Continue Learning]
  _ContinueLearningCard  (gradient, topic name + progress bar)

[Start Practice Session]  ← gradient CTA button, routes to /practice

[Section: Topics]  (label + "View all" action)
  _TopicRowCard × 3 (icon · title · subtitle · progress bar)

[Section: Progress]
  Row of two _ProgressCompactCard:
    Streak card  (fire icon, streak count, first-day label)
    This Week card  (calendar icon, days active / 5)

[Section: Achievements]
  _AchievementsCard  (badge icon, weekly streak title + subtitle)

[Section: Oxford Track]  ← intentional; premium upsell
  _OxfordTrackCard  (graduation cap, "PREMIUM REQUIRED" badge,
                     "11+ prep, advanced challenges & competition maths")

[Section: Learning Paths]  ← intentional
  Row of two _LearningPathCard (icon · title · subtitle)

[Section: Exam Packs]  ← intentional; premium upsell
  _ExamPacksCard  (book icon, subtitle, "View Exam Packs" outlined button)

Bottom padding: kBottomNavigationBarHeight + SafeArea.bottom + 24dp
```

**Premium upsell sections are intentional and must not be removed:**
- **Oxford Track**: 11+ prep, advanced challenges, competition maths
- **Exam Packs**: targeted GCSE-style past-paper question sets

**Responsive**
- Max width: 430dp (mobile), centered in wider viewports
- All cards stack vertically in single column

### Topics Screen
**Layout**
```
Safe Area Top (2xl padding)
─────────────────────────
Topics (Page Header)

[Search Field]

[Segment Chips: All | Algebra | Geometry]

[Topic Card]
[Topic Card]
[Topic Card]
...

Bottom padding: 80dp + Safe Area Bottom
```

### Practice Screen
**Layout**
```
Safe Area Top (2xl padding)
─────────────────────────
[Progress Bar: Question 3/10]

[Question Card]

[Tutor Card]

[Navigation: Previous | Next buttons]

Bottom padding: 80dp + Safe Area Bottom
```

### Profile Screen
**Layout**
```
Safe Area Top (2xl padding)
─────────────────────────
Profile (Page Header)

[Avatar 80dp, centered]
[Name (Card Title, centered)]
[Email (Caption, centered)]
[Premium Badge (if applicable)]

[Settings Card: Account]
  - Edit Profile
  - Change Password

[Settings Card: Subscription]
  - Manage Subscription
  - Billing History

[Settings Card: Preferences]
  - Language
  - Notifications
  - Theme (future)

[Settings Card: Support]
  - Help Center
  - Contact Support
  - Rate App

[Settings Card: Legal]
  - Terms of Service
  - Privacy Policy
  - Licenses

[Settings Card: Administration] ← UAT only, admin role required
  - Open Control Plane (url_launcher)

[Sign Out Button (Secondary)]

Bottom padding: 80dp + Safe Area Bottom
```

---

## Responsive Design Rules

### Breakpoints
```
Mobile:         < 1024dp    Bottom nav, single-column layout
Desk Mode:      ≥ 1024dp    Left rail nav, max-width content area
```

### Content Width Constraints
```
Max Width:      430dp (mobile), 800dp (desk mode content well)
Alignment:      Center horizontally when viewport exceeds max width
Edge Padding:   24dp (xl) on all screens
```

### Scrolling Behavior
- **Always Use**: `SingleChildScrollView` or `ListView`
- **Never**: Fixed-height content that clips
- **Bottom Padding**: Always include 80dp + SafeArea.bottom clearance
- **Scroll Physics**: `BouncingScrollPhysics` on iOS, `ClampingScrollPhysics` on Android

### Safe Area Handling
```dart
SafeArea(
  minimum: EdgeInsets.only(
    top: 32,    // 2xl
    bottom: 80, // Bottom nav height + spacer
    left: 24,   // xl
    right: 24,  // xl
  ),
  child: ...
)
```

### Bottom Nav Overlap Prevention
**CRITICAL RULE**: Bottom nav must NEVER cover scrollable content

```dart
// Correct pattern:
ListView(
  padding: EdgeInsets.only(
    bottom: 80 + MediaQuery.of(context).padding.bottom,
  ),
  children: [...]
)

// Incorrect pattern (will cause overlap):
ListView(
  children: [...] // Missing bottom padding
)
```

### Responsive Images
- Use `AssetImage` with explicit width/height
- Provide @2x and @3x variants
- Never rely on intrinsic sizing

---

## Flutter Implementation Rules

### Architecture Patterns

#### State Management
- **BLoC Pattern**: Use for business logic (authentication, subscriptions, tutor state)
- **Provider**: Use for theme, locale, user preferences
- **Riverpod**: Allowed for dependency injection

#### Navigation
```dart
// GoRouter required for deep linking
final GoRouter router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => WelcomeScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithBottomNav(child: child),
      routes: [
        GoRoute(path: '/home', name: 'home', ...),
        GoRoute(path: '/topics', name: 'topics', ...),
        // etc.
      ],
    ),
  ],
);
```

#### Theme System
```dart
// Use Theme extensions for custom tokens
class AppColors extends ThemeExtension<AppColors> {
  final Color navyBase;
  final Color cardSurface;
  final Color primaryBlue;
  // ... all design tokens

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    // Required for theme transitions
  }
}

// Access in widgets:
final colors = Theme.of(context).extension<AppColors>()!;
```

### Required Widgets

#### Scrollable Screens
```dart
Scaffold(
  body: SafeArea(
    minimum: EdgeInsets.symmetric(horizontal: 24),
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(), // iOS
      child: Padding(
        padding: EdgeInsets.only(
          top: 32,
          bottom: 80 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [...],
        ),
      ),
    ),
  ),
)
```

#### Responsive Constraints
```dart
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 430),
  child: Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ...,
    ),
  ),
)
```

#### Responsive Layout Builder
```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isDeskMode = constraints.maxWidth >= 1024;
    return isDeskMode
      ? RowWithLeftRail(...)
      : ColumnWithBottomNav(...);
  },
)
```

### Typography Implementation
```dart
// Create TextTheme with DM Sans + DM Serif Display
const TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'DM Serif Display',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'DM Sans',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
  ),
  // ... rest of scale
);

// Use in widgets:
Text(
  'Welcome to MathTutor',
  style: Theme.of(context).textTheme.displayLarge,
)
```

### Shadow Implementation
```dart
// Soft Premium Shadow constant
const BoxShadow kSoftPremiumShadow = BoxShadow(
  color: Color(0x1F000000), // rgba(0,0,0,0.12)
  blurRadius: 16,
  offset: Offset(0, 4),
);

const BoxShadow kSoftPremiumShadowSubtle = BoxShadow(
  color: Color(0x14000000), // rgba(0,0,0,0.08)
  blurRadius: 4,
  offset: Offset(0, 1),
);

// Apply to containers:
Container(
  decoration: BoxDecoration(
    color: Color(0xFF132040),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      kSoftPremiumShadow,
      kSoftPremiumShadowSubtle,
    ],
  ),
)
```

### Button Implementation
```dart
// Primary Button
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF3D7EFF),
    foregroundColor: Colors.white,
    minimumSize: Size.fromHeight(48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    shadowColor: Color(0xFF3D7EFF).withOpacity(0.3),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  child: Text('Get Started'),
)

// Secondary Button
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: Color(0xFF3D7EFF),
    minimumSize: Size.fromHeight(48),
    side: BorderSide(color: Color(0xFF3D7EFF)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
  child: Text('Sign In'),
)
```

### Locale Support

**Swiss localization is required** — the following four locales must always be present:
- `de_CH` — Swiss German
- `fr_CH` — Swiss French
- `it_CH` — Swiss Italian
- `en_GB` — English fallback (also primary locale for UK market)

Swiss users select their language via the `_WelcomeCH` language chip row (Deutsch / Français / Italiano). English is the ARB base locale and the fallback when a Swiss locale key is missing.

```dart
// MaterialApp with locale support
MaterialApp.router(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en', 'GB'), // UK + Swiss fallback (primary ARB base)
    Locale('en', 'US'), // US
    Locale('da', 'DK'), // Denmark
    Locale('nb', 'NO'), // Norway
    Locale('sv', 'SE'), // Sweden
    Locale('ko', 'KR'), // South Korea
    Locale('de', 'DE'), // Germany
    Locale('de', 'CH'), // Switzerland (German) — REQUIRED
    Locale('fr', 'CH'), // Switzerland (French) — REQUIRED
    Locale('it', 'CH'), // Switzerland (Italian) — REQUIRED
    Locale('ar'),       // Arabic (region-neutral, RTL)
  ],
  locale: userSelectedLocale,
  routerConfig: router,
)
```

### Admin Gate Implementation
```dart
// Only render Administration row when conditions met
if (Environment.current == Environment.uat && user.hasAdminRole) ...[
  ListTile(
    leading: Icon(LucideIcons.shield),
    title: Text('Administration'),
    trailing: Icon(LucideIcons.externalLink),
    onTap: () async {
      final url = Uri.parse('https://control-plane.mathtutor.app');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    },
  ),
]
```

---

## Accessibility Requirements

### Minimum Touch Targets
- **All interactive elements**: 48dp × 48dp minimum
- **Exception**: Inline text links (40dp minimum height)

### Color Contrast
- **Body text on Navy**: WCAG AA compliant (white text = 17.8:1)
- **Muted text on Navy**: Minimum 4.5:1 (meets AA for large text)
- **Primary Blue on Navy**: Minimum 4.5:1

### Semantic Labels
```dart
// Always provide semantics for icons without text
IconButton(
  icon: Icon(LucideIcons.search),
  onPressed: () {},
  tooltip: 'Search topics',
  // Implicit semanticLabel from tooltip
)

// Explicit semantics for custom widgets
Semantics(
  label: 'Progress: 75% complete',
  child: ProgressBar(value: 0.75),
)
```

### Screen Reader Support
- All navigation items must have clear labels
- Progress bars must announce percentage
- Form fields must have associated labels
- Error states must announce error messages

---

## Testing Requirements

### Widget Tests (Mandatory)
```dart
// Test all component states
testWidgets('TopicCard shows correct progress', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TopicCard(
        title: 'Algebra',
        progress: 0.75,
      ),
    ),
  );

  expect(find.text('Algebra'), findsOneWidget);
  expect(find.byType(ProgressBar), findsOneWidget);
  // Verify progress value
});
```

### Golden Tests (Required for Components)
```dart
testWidgets('TopicCard matches golden', (tester) async {
  await tester.pumpWidget(MaterialApp(home: TopicCard(...)));
  await expectLater(
    find.byType(TopicCard),
    matchesGoldenFile('goldens/topic_card_default.png'),
  );
});
```

### Integration Tests (Critical User Flows)
- Onboarding → Home navigation
- Topic selection → Practice mode
- Tutor tip → Paywall (guest state)
- Profile → Subscription management

---

## Build Variants & Environment

### ENV-Based Configuration
```dart
enum Environment {
  prod,
  uatAdmin,
  uatUser,
}

// Access via:
Environment.current == Environment.prod
```

### Feature Flags
- **Admin Controls**: Only visible when `ENV=uat` AND `user.hasAdminRole`
- **Debug UI**: Only visible when `kDebugMode == true`
- **Tutor Credits**: Configurable per environment (prod=20/month, uat=1000/month)

---

## Assets & Resources

### Font Files
```
assets/fonts/
  DMSans-Regular.ttf
  DMSans-Medium.ttf
  DMSans-SemiBold.ttf
  DMSans-Bold.ttf
  DMSerifDisplay-Regular.ttf
  DMSerifDisplay-Medium.ttf
```

### Icon Package
```yaml
dependencies:
  lucide_icons: ^0.468.0
```

### Image Assets
```
assets/images/
  logo.png (48dp height, @2x @3x variants)
  welcome_illustration.png (200dp height)
  empty_state_*.png (various)
```

### Localization Files
```
lib/l10n/
  app_en_GB.arb (UK English, primary)
  app_en_US.arb
  app_da_DK.arb
  app_nb_NO.arb
  app_sv_SE.arb
  app_ko_KR.arb
  app_de_DE.arb
  app_de_CH.arb
  app_fr_CH.arb
  app_it_CH.arb
  app_ar.arb (RTL support)
```

---

## Performance Guidelines

### Image Optimization
- Max resolution: 2x device pixel ratio
- Format: WebP for illustrations, PNG for logos/icons
- Lazy loading: Use `Image.asset` with cacheWidth/cacheHeight

### List Performance
```dart
// Always use ListView.builder for dynamic lists
ListView.builder(
  itemCount: topics.length,
  itemBuilder: (context, index) {
    return TopicCard(topic: topics[index]);
  },
)

// Never:
ListView(
  children: topics.map((t) => TopicCard(topic: t)).toList(),
)
```

### Animation Performance
- Use `AnimatedContainer` for simple transitions
- Complex animations: `AnimationController` + `AnimatedBuilder`
- Avoid `setState()` during animation ticks (use `AnimatedBuilder`)

---

## Design System Governance

### FROZEN Tokens (NO CHANGES WITHOUT APPROVAL)
- Color palette (all 10 colors)
- Typography scale (7 styles)
- Spacing scale (xs through 3xl)
- Corner radius (4 values)
- Shadow style (single definition)
- Icon stroke width (2dp)

### Allowed Flexibility
- **Content**: Text copy, images, illustrations (with l10n)
- **Layout Composition**: Arrangement of frozen components
- **New Components**: Must use frozen tokens exclusively

### Change Request Process
1. Propose change in DEVELOPER_NOTES.md
2. Document rationale (accessibility, platform convention, user feedback)
3. Await explicit approval
4. Update FIGMA_FLUTTER_HANDOFF_SPEC.md with new frozen state

---

## Claude Implementation Instructions

### Pre-Implementation Checklist
1. **Read This Document Fully**: Understand all frozen tokens before writing code
2. **Check Existing Components**: Never recreate what exists (TopicCard, ProgressBar, etc.)
3. **Verify Dependencies**: Ensure `lucide_icons`, `go_router`, `url_launcher` are in pubspec.yaml
4. **Confirm Environment**: Understand ENV-based feature gates (admin controls, debug UI)

### Implementation Order
1. **Theme System**: Create `AppColors` + `AppTypography` extensions
2. **Core Components**: Build 11 component library widgets (Topic Card → CTA Buttons)
3. **Navigation Shell**: Implement 6-tab Bottom Nav + Left Rail (desk mode) using `StatefulShellRoute.indexedStack`
4. **Screens**: Build 7 primary screens (Welcome, Home, Topics, Practice, Profile, Tutor, Help)
5. **Localization**: Add .arb files for all 11 supported locales; Swiss locales (de_CH, fr_CH, it_CH) are required
6. **Admin Gate**: Implement UAT + role check for Administration row
7. **Testing**: Write widget tests + golden tests for all components

### Code Review Criteria
- ✅ Uses ONLY frozen design tokens (no magic numbers)
- ✅ All interactive elements ≥ 48dp touch target
- ✅ Bottom padding on scrollable content = 80dp + SafeArea.bottom
- ✅ Max width constraints (430dp mobile, 800dp desk)
- ✅ SafeArea wraps all screen content
- ✅ No hardcoded strings (all text from l10n .arb files)
- ✅ Admin controls gated behind ENV + role check
- ✅ Switzerland welcome screen includes language chips (never standardized)

### Common Mistakes to Avoid
- ❌ Stretching content to fill width without max-width constraint
- ❌ Bottom nav covering scrollable content (missing padding)
- ❌ Using `Container` height without constraints (causes overflow)
- ❌ Hardcoding colors instead of theme extension
- ❌ Creating new spacing values instead of using frozen scale
- ❌ Rendering admin UI in production builds
- ❌ Standardizing Swiss language selection to English-only

### When to Ask for Clarification
- Localized copy for new screens (provide en-GB, request others)
- New component not in 11-component library (verify it's truly needed)
- Deviation from frozen tokens (must be approved first)
- Uncertain ENV logic (prod vs. uat_admin vs. uat_user behavior)

### Success Criteria
- App builds without errors on Android + iOS
- All screens responsive from iPhone SE → iPhone 17 Pro Max
- Bottom nav never overlaps content; all 6 tabs wired and functional
- Tutor tab present and functional (free tips, credit chips, upsell card)
- Help tab present and functional (FAQ, contact, privacy, parental controls)
- Admin controls only visible when ENV=uat + admin role
- Swiss welcome screen shows language chips (Deutsch / Français / Italiano)
- de_CH, fr_CH, it_CH locales load correctly; missing keys fall back to en_GB
- Widget tests pass for all components
- Golden tests match Figma designs within 98% pixel similarity

---

## Superseded Previous Spec Items

The following items from earlier drafts of this specification are **superseded** and must no longer be treated as requirements. They are recorded here to prevent regression.

| Superseded Item | Approved Replacement | Reason |
|---|---|---|
| 5-tab bottom nav: Home / Topics / Practice / Profile / More | **6-tab nav: Home / Topics / Practice / Profile / Tutor / Help** | Tutor and Help are first-class destinations, not buried under "More" |
| "More" tab as a catch-all for Help, About, Legal | **Dedicated Help tab (index 5)** | Help is a required safety and support surface; must be directly accessible |
| Progress as a dedicated bottom nav tab (`/progress`) | **Progress is a section within Home** | Streak and weekly progress are dashboard widgets, not a separate nav destination |
| 5-items-max rule for mobile bottom nav | **6 items, fixed order** | Navigation was deliberately expanded; do not collapse back to 5 |
| Home showing only: StreakBanner, Today's Focus, Weak Spots, Recent Activity | **Home now shows**: Continue Learning, Start Practice CTA, Topics, Progress, Achievements, Oxford Track, Learning Paths, Exam Packs | Full dashboard layout approved; all sections are intentional |
| Swiss localization treated as optional or future-ready | **de_CH, fr_CH, it_CH are required locales with en_GB fallback** | Switzerland is a live market requiring multi-lingual support at launch |
| Oxford Track, GCSE Foundation, GCSE Higher, Exam Packs, Tutor credits as provisional/future features | **All are approved, intentional premium upsell features** | Monetisation model is confirmed; do not remove or stub these surfaces |

---

**Document Version**: 1.1.0  
**Last Updated**: 2026-05-18  
**Maintained By**: MathTutor Design System Team  
**Questions**: Reference DEVELOPER_NOTES.md for project context

