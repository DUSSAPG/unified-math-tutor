# Brand and Role Alignment QA

## Status

**NOT READY for final user testing**

The copy, role terminology, localisation source keys, and release APK validation passed. Live Pixel 6a and Android tablet validation is blocked because Flutter cannot see either requested Android device from this environment.

## Files Changed

- `lib/screens/onboarding/user_type_screen.dart`
- `lib/widgets/onboarding/onboarding_option_card.dart`
- `lib/screens/home/home_shell.dart`
- `lib/screens/auth/sign_in_screen.dart`
- `lib/screens/auth/create_account_screen.dart`
- `lib/screens/settings/profile_screen.dart`
- `lib/screens/settings/help_screen.dart`
- `lib/screens/settings/parent_teacher_tools_screen.dart`
- `lib/app.dart`
- `lib/l10n/*.arb`
- `lib/l10n/app_localizations*.dart`
- `untranslated_messages.txt`
- `test/brand_role_alignment_test.dart`
- `docs/branding/BRAND_POSITIONING.md`
- `BRAND_AND_ROLE_ALIGNMENT_QA.md`

## Localisation Keys Added or Revised

Added:

- `onboardingProductName`
- `onboardingTechBadge`
- `onboardingHeroStatement`
- `onboardingSupportingStatement`
- `onboardingRoleClarification`
- `onboardingCreateAccount`
- `onboardingCreateAccountSub`
- `learningAnalyticsTitle`
- `learningAnalyticsSummary`
- `learningAnalyticsEmptyState`

Revised:

- `onboardingWelcomeTitle`
- `onboardingWelcomeSubtitle`
- `onboardingStudentLabel`
- `onboardingStudentSub`
- `onboardingParentLabel`
- `onboardingParentSub`
- `onboardingStageTitleParent`
- `onboardingStageSubParent`
- `onboardingGoalTitleParent`
- `onboardingGoalSubParent`
- `onboardingParentGoal1Label`
- `onboardingParentGoal1Sub`
- `onboardingParentGoal2Label`
- `onboardingParentGoal2Sub`
- `onboardingParentGoal3Label`
- `onboardingParentGoal3Sub`
- `onboardingParentGoal4Label`
- `onboardingParentGoal4Sub`
- `helpParentalTitle`
- `helpParentalHeadline`
- `settingsParentToolsRewards`
- `enableParentTools`
- `parentToolsLocalOnly`
- `unlockParentTools`
- `parentTeacherTools`
- `upgradeBenefit3Title`

## Screens Tested

- Welcome/onboarding role screen via widget test.
- Mobile bottom navigation and More sheet via existing navigation/localisation tests.
- Profile/settings navigation via existing tests.
- Home/Journey rendering via existing widget tests.

Manual device screenshots were not captured because no Android devices were visible to Flutter.

## Learner vs Supporting Role Differences

- Learner role copy now says: `I'm a Learner`.
- Learner goal path remains focused on confidence, school maths, exams and challenge.
- Supporting role copy now says: `I'm supporting a learner`.
- Supporting goals use support-oriented language: confidence, learning gaps, progress over time and exam preparation.
- Existing persisted role identifiers remain unchanged (`student` / `parent`) to avoid migration risk.

## Accessibility Checks

- Welcome headline uses white text on the dark background.
- Hero supporting text uses high-opacity white.
- Role-card titles are explicitly white.
- Selected role cards retain a stronger blue border and selected icon state.
- Bottom navigation remains Home, Topics, Practice, Journey and More on mobile.

## Validation Results

- `flutter clean`: PASS
- `flutter pub get`: PASS
- `flutter gen-l10n`: PASS
- `flutter analyze`: PASS
- `flutter test --reporter compact`: PASS
- `flutter build apk --release`: PASS
  - Built `build/app/outputs/flutter-apk/app-release.apk`
- `flutter devices`: BLOCKED for Android hardware
  - Visible devices: Windows, Chrome, Edge
- `flutter run -d 23291JEGR05756`: BLOCKED
  - Pixel 6a not visible to Flutter.
- `flutter run -d G900005500301722`: BLOCKED
  - Android tablet not visible to Flutter.

## Known Limitations

- Account state remains local-only for this release. Copy no longer claims cloud sync.
- Learning Analytics is a renamed local reporting/tools surface; no new analytics engine or fabricated recommendations were added.
- `flutter gen-l10n` still reports broader untranslated legacy keys in `untranslated_messages.txt`; this pass specifically covered the configured brand/role/Learning Analytics keys and verified them with tests.
- Live phone/tablet runtime, overflow and launcher-entry checks still require connected Android devices.

## Recommendation

**NOT READY** until Pixel 6a and Android tablet device validation can be completed.
