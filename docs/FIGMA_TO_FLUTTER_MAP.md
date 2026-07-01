# Figma To Flutter Map

Figma frame identifiers are not checked into this repository. The names below are
stable engineering aliases. Rename a Figma frame only with the matching route or
widget update recorded here.

| Figma screen alias | Route path | Widget class | File path | Key components / state |
| --- | --- | --- | --- | --- |
| `Tab.Home.Default` | `/home` | `HomeTabContent` | `lib/screens/home/home_shell.dart` | Greeting, streak badge, `RewardsToggle`, learning cards, milestone badge |
| `Tab.Topics.Default` | `/topics` | `TopicsScreen` | `lib/screens/topics/topics_screen.dart` | Topic search, filters, curriculum tracks |
| `Tab.Practice.Setup` | `/practice` | `PracticeScreen` | `lib/screens/practice/practice_screen.dart` | Pack selector, mode, count, topic context |
| `Tab.Practice.Session` | `/practice` | `PracticeScreen` | `lib/screens/practice/practice_screen.dart` | MCQ state, checked answer, explanation, attempt persistence |
| `Tab.Practice.Summary` | `/practice` | `PracticeScreen` | `lib/screens/practice/practice_screen.dart` | Score summary, motion-aware confetti |
| `Tab.Practice.QuestionPlaceholder` | `/practice/question` | `QuestionScreen` | `lib/screens/practice/question_screen.dart` | Placeholder route; active session remains in `PracticeScreen` |
| `Tab.Practice.ResultsPlaceholder` | `/practice/results` | `ResultsScreen` | `lib/screens/results/results_screen.dart` | Placeholder results route |
| `Tab.Profile.Default` | `/profile` | `ProfileScreen` | `lib/screens/settings/profile_screen.dart` | Settings cards and about links |
| `Profile.Settings.Default` | `/profile/settings` | `SettingsScreen` | `lib/screens/settings/settings_screen.dart` | Parent Tools and Rewards preferences |
| `Profile.Appearance.Default` | `/profile/appearance` | `AppearanceScreen` | `lib/screens/settings/appearance_screen.dart` | Theme controls and market-gated locale selector |
| `Profile.Accessibility.Default` | `/profile/accessibility` | `AccessibilityScreen` | `lib/screens/settings/accessibility_screen.dart` | Text size, contrast, persisted Reduce Motion |
| `Profile.Subscription.Default` | `/profile/subscription` | `SubscriptionScreen` | `lib/screens/settings/subscription_screen.dart` | Subscription placeholder |
| `Profile.Curriculum.Default` | `/profile/curriculum` | `CurriculumSettingsScreen` | `lib/screens/settings/curriculum_settings_screen.dart` | Stage and learning mode |
| `Profile.Privacy.Default` | `/profile/privacy` | `PrivacyDataScreen` | `lib/screens/settings/privacy_data_screen.dart` | Privacy information |
| `Profile.Terms.Default` | `/profile/terms` | `TermsScreen` | `lib/screens/settings/terms_screen.dart` | Terms |
| `Tab.Tutor.Default` | `/tutor` | `TutorScreen` | `lib/screens/tutor/tutor_screen.dart` | Tutor chat, credit state, practice context |
| `Tab.Help.Default` | `/help` | `HelpScreen` | `lib/screens/settings/help_screen.dart` | FAQ, privacy, parent-tools entry when enabled |
| `Help.ParentTools.PinGate` | `/help/parent-teacher-tools` | `ParentTeacherToolsScreen` | `lib/screens/settings/parent_teacher_tools_screen.dart` | Local SHA-256 PIN gate |
| `Help.ParentTools.CheatSheet` | `/help/parent-teacher-tools/cheat-sheet` | `ParentCheatSheetScreen` | `lib/screens/settings/parent_cheat_sheet_screen.dart` | View-only sessions, topics, answers, explanations, disabled PDF stub |
| `Global.Packs.Default` | `/packs` | `ExamPacksScreen` | `lib/screens/packs/exam_packs_screen.dart` | Exam-pack catalogue |
| `Global.Upgrade.Default` | `/upgrade` | `UpgradeScreen` | `lib/screens/upgrade/upgrade_screen.dart` | Upgrade placeholder |
| `Global.ReleaseNotes.Default` | `/release-notes` | `ReleaseNotesScreen` | `lib/screens/settings/release_notes_screen.dart` | Release notes |
| `Onboarding.UserType.Default` | `/onboarding` | `UserTypeScreen` | `lib/screens/onboarding/user_type_screen.dart` | User type and dev-gated locale selector |
| `Onboarding.Stage.Default` | `/onboarding/stage` | `StageSelectorScreen` | `lib/screens/onboarding/stage_selector_screen.dart` | Curriculum stage |
| `Onboarding.Goal.Default` | `/onboarding/goal` | `GoalSelectorScreen` | `lib/screens/onboarding/goal_selector_screen.dart` | Learning goal |
| `Onboarding.Profile.Default` | `/onboarding/profile` | `StudyProfileScreen` | `lib/screens/onboarding/study_profile_screen.dart` | Study profile |
| `Auth.SignIn.Default` | `/auth/sign-in` | `SignInScreen` | `lib/screens/auth/sign_in_screen.dart` | Placeholder |
| `Auth.Create.Default` | `/auth/create` | `CreateAccountScreen` | `lib/screens/auth/create_account_screen.dart` | Placeholder |

## Unrouted Screens

| Widget class | File path | Notes |
| --- | --- | --- |
| `SkillsScreen` | `lib/screens/practice/skills_screen.dart` | Register a route before linking from Figma |
| `WeaknessScreen` | `lib/screens/practice/weakness_screen.dart` | Register a route before linking from Figma |
| `GrowthScreen` | `lib/screens/results/growth_screen.dart` | Register a route before linking from Figma |
| `AdminConsoleScreen` | `lib/screens/admin_console_screen.dart` | Development-only candidate |

## Do Not Drift Checklist

- Keep the Figma frame alias, route, public widget class, and source path aligned.
- Update this file in the same change as any route rename or screen move.
- Add new screen states explicitly: `Default`, `Loading`, `Empty`, `Error`,
  `Session`, `Summary`, or `PinGate`.
- Test LTR and RTL layouts when changing row alignment, directional padding, or
  fixed-width text.
- Keep student navigation free of parent-only routes until the local unlock gate
  is satisfied.
- Run `flutter analyze`, `flutter test`, and `flutter build web --release`.

## Change Control

1. Add or update the proposed Figma alias in this document.
2. Record the route path, widget owner, file path, and state impact.
3. Review navigation visibility, localization, RTL behavior, and Reduce Motion.
4. Add or update a focused test for new routes or state transitions.
5. Merge design and Flutter changes together so neither side lands alone.

