# Screen To Widget Map

Figma frame names are not stored in this repository. Placeholder names below follow
the deterministic convention in `FIGMA_NAMING_RULES.md`.

## Main Tabs

| FigmaFrameName | RouteName | WidgetClass | SourceFilePath | Notes/TODO |
| --- | --- | --- | --- | --- |
| `Tab.Home.Default` | `/home` | `HomeTabContent` | `lib/screens/home/home_shell.dart` | Confirm Figma frame name |
| `Tab.Topics.Default` | `/topics` | `TopicsScreen` | `lib/screens/topics/topics_screen.dart` | Confirm Figma frame name |
| `Tab.Practice.Setup` | `/practice` | `PracticeScreen` | `lib/screens/practice/practice_screen.dart` | Includes setup, session, summary states |
| `Tab.Profile.Default` | `/profile` | `ProfileScreen` | `lib/screens/settings/profile_screen.dart` | Confirm Figma frame name |
| `Tab.Tutor.Default` | `/tutor` | `TutorScreen` | `lib/screens/tutor/tutor_screen.dart` | Confirm Figma frame name |
| `Tab.Help.Default` | `/help` | `HelpScreen` | `lib/screens/settings/help_screen.dart` | Confirm Figma frame name |

## Practice

| FigmaFrameName | RouteName | WidgetClass | SourceFilePath | Notes/TODO |
| --- | --- | --- | --- | --- |
| `Tab.Practice.Question` | `/practice/question` | `QuestionScreen` | `lib/screens/practice/question_screen.dart` | Placeholder route; active questions render in `PracticeScreen` |
| `Tab.Practice.Results` | `/practice/results` | `ResultsScreen` | `lib/screens/results/results_screen.dart` | Placeholder route |
| `Tab.Practice.Skills` | TODO | `SkillsScreen` | `lib/screens/practice/skills_screen.dart` | No route registered |
| `Tab.Practice.Weakness` | TODO | `WeaknessScreen` | `lib/screens/practice/weakness_screen.dart` | No route registered |

## Profile And Settings

| FigmaFrameName | RouteName | WidgetClass | SourceFilePath | Notes/TODO |
| --- | --- | --- | --- | --- |
| `Profile.Settings.Default` | `/profile/settings` | `SettingsScreen` | `lib/screens/settings/settings_screen.dart` | Parent tools and rewards toggles |
| `Profile.Appearance.Default` | `/profile/appearance` | `AppearanceScreen` | `lib/screens/settings/appearance_screen.dart` | Locale selector is production-gated |
| `Profile.Accessibility.Default` | `/profile/accessibility` | `AccessibilityScreen` | `lib/screens/settings/accessibility_screen.dart` | Reduce Motion persists locally |
| `Profile.Subscription.Default` | `/profile/subscription` | `SubscriptionScreen` | `lib/screens/settings/subscription_screen.dart` | Confirm Figma frame name |
| `Profile.Curriculum.Default` | `/profile/curriculum` | `CurriculumSettingsScreen` | `lib/screens/settings/curriculum_settings_screen.dart` | Confirm Figma frame name |
| `Profile.Privacy.Default` | `/profile/privacy` | `PrivacyDataScreen` | `lib/screens/settings/privacy_data_screen.dart` | Confirm Figma frame name |
| `Profile.Terms.Default` | `/profile/terms` | `TermsScreen` | `lib/screens/settings/terms_screen.dart` | Confirm Figma frame name |

## Help

| FigmaFrameName | RouteName | WidgetClass | SourceFilePath | Notes/TODO |
| --- | --- | --- | --- | --- |
| `Help.ParentTools.PinGate` | `/help/parent-teacher-tools` | `ParentTeacherToolsScreen` | `lib/screens/settings/parent_teacher_tools_screen.dart` | Local-only hashed PIN gate |
| `Help.ParentTools.CheatSheet` | `/help/parent-teacher-tools/cheat-sheet` | `ParentCheatSheetScreen` | `lib/screens/settings/parent_cheat_sheet_screen.dart` | View-only recent answers |

## Onboarding And Auth

| FigmaFrameName | RouteName | WidgetClass | SourceFilePath | Notes/TODO |
| --- | --- | --- | --- | --- |
| `Onboarding.UserType.Default` | `/onboarding` | `UserTypeScreen` | `lib/screens/onboarding/user_type_screen.dart` | Initial route |
| `Onboarding.Stage.Default` | `/onboarding/stage` | `StageSelectorScreen` | `lib/screens/onboarding/stage_selector_screen.dart` | Confirm Figma frame name |
| `Onboarding.Goal.Default` | `/onboarding/goal` | `GoalSelectorScreen` | `lib/screens/onboarding/goal_selector_screen.dart` | Confirm Figma frame name |
| `Onboarding.Profile.Default` | `/onboarding/profile` | `StudyProfileScreen` | `lib/screens/onboarding/study_profile_screen.dart` | Confirm Figma frame name |
| `Auth.SignIn.Default` | `/auth/sign-in` | `SignInScreen` | `lib/screens/auth/sign_in_screen.dart` | Placeholder |
| `Auth.Create.Default` | `/auth/create` | `CreateAccountScreen` | `lib/screens/auth/create_account_screen.dart` | Placeholder |

## Global And Unrouted Screens

| FigmaFrameName | RouteName | WidgetClass | SourceFilePath | Notes/TODO |
| --- | --- | --- | --- | --- |
| `Global.Packs.Default` | `/packs` | `ExamPacksScreen` | `lib/screens/packs/exam_packs_screen.dart` | Root-level push route |
| `Global.Upgrade.Default` | `/upgrade` | `UpgradeScreen` | `lib/screens/upgrade/upgrade_screen.dart` | Root-level route |
| `Global.ReleaseNotes.Default` | `/release-notes` | `ReleaseNotesScreen` | `lib/screens/settings/release_notes_screen.dart` | Root-level route |
| `TODO` | TODO | `AdminConsoleScreen` | `lib/screens/admin_console_screen.dart` | No route registered |
| `TODO` | TODO | `GrowthScreen` | `lib/screens/results/growth_screen.dart` | No route registered |
| `TODO` | TODO | `StudentHomeScreen` | `lib/screens/home/student_home_screen.dart` | No route registered |

## State Ownership

| Area | Owner | Notes |
| --- | --- | --- |
| Practice packs | `PackRegistryService` | `assets/pack_registry.json` is the runtime source. Practice exposes `KS2`-`KS5`; Tutor uses `all` separately. |
| Practice session | `PracticeScreen` | Owns setup, active-question, and summary state. Completed attempts are written to `SessionHistoryService`. |
| Parent tools | `LocalPreferencesService`, `SessionHistoryService` | Local-only toggle, SHA-256 PIN hash, unlock state, and last 20 sessions. |
| Rewards | `LocalPreferencesService`, `StreakService` | Local rewards toggle and Reduce Motion preference control dependency-free confetti. |
| Locales | `LocaleService` | Production picker is limited to `en-GB`, `de-CH`, `fr-CH`, and `it-CH`; UAT can opt into all compiled locales. |

## Do Not Drift Checklist

- Update this map in the same change as any route, screen class, or owning-file rename.
- Keep Figma frame names aligned with `FIGMA_NAMING_RULES.md`.
- Record new modal, empty, loading, error, and gated states as separate frames.
- Confirm state ownership before adding a second persistence or navigation path.
- Run `flutter analyze`, `flutter test`, and `dart run tools/validate_packs.dart`.

## Change Control

1. Treat `lib/app/router.dart` as the route source of truth.
2. Add the route, widget class, owning file, and state owner to this document in the same review.
3. Flag placeholder frame names as TODO until design confirms the final Figma frame.
4. Do not create a Figma-only route name or a code-only major screen without updating this map.
