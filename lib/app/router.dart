import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/config/build_flags.dart';
import '../models/family_activity.dart';
import '../screens/home/home_shell.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/splash/app_splash_screen.dart';
import '../screens/practice/practice_screen.dart';
import '../screens/tutor/tutor_screen.dart';
import '../screens/topics/topics_screen.dart';
import '../screens/settings/help_screen.dart';
import '../screens/settings/parent_teacher_tools_screen.dart';
import '../screens/settings/parent_cheat_sheet_screen.dart';
import '../screens/family_maths/family_maths_welcome_screen.dart';
import '../screens/family_maths/family_maths_library_screen.dart';
import '../screens/family_maths/family_activity_detail_screen.dart';
import '../screens/settings/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/appearance_screen.dart';
import '../screens/settings/accessibility_screen.dart';
import '../screens/settings/subscription_screen.dart';
import '../screens/settings/curriculum_settings_screen.dart';
import '../screens/settings/privacy_data_screen.dart';
import '../screens/onboarding/user_type_screen.dart';
import '../screens/onboarding/accessibility_step_screen.dart';
import '../screens/onboarding/stage_selector_screen.dart';
import '../screens/onboarding/goal_selector_screen.dart';
import '../screens/onboarding/study_profile_screen.dart';
import '../screens/onboarding/family/family_role_detail_screen.dart';
import '../screens/onboarding/family/family_learner_context_screen.dart';
import '../screens/onboarding/family/family_goal_screen.dart';
import '../screens/onboarding/family/family_preferences_screen.dart';
import '../screens/family_studio/family_studio_hub_screen.dart';
import '../screens/family_studio/family_today_activity_screen.dart';
import '../screens/family_studio/homework_companion_screen.dart';
import '../screens/family_studio/what_your_child_is_learning_screen.dart';
import '../screens/family_studio/family_progress_snapshot_screen.dart';
import '../screens/family_studio/tutor_tools_screen.dart';
import '../screens/family_studio/conversation_starters_screen.dart';
import '../screens/family_studio/parent_recall_cards_screen.dart';
import '../widgets/settings/parent_gate.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/create_account_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/packs/exam_packs_screen.dart';
import '../screens/entrance_exam/entrance_exam_hub_screen.dart';
import '../screens/entrance_exam/entrance_exam_skill_list_screen.dart';
import '../screens/entrance_exam/entrance_exam_practice_session_screen.dart';
import '../screens/entrance_exam/entrance_exam_review_screen.dart';
import '../screens/formulas/formula_library_screen.dart';
import '../screens/explore/explore_math_intelligence_screen.dart';
import '../screens/math_studio/math_studio_hub_screen.dart';
import '../screens/build_confidence/build_confidence_screen.dart';
import '../screens/mental_maths/mental_maths_hub_screen.dart';
import '../screens/mental_maths/mental_maths_category_screen.dart';
import '../screens/visual_maths/visual_maths_hub_screen.dart';
import '../screens/visual_maths/number_line_screen.dart';
import '../screens/visual_maths/fraction_bars_screen.dart';
import '../screens/visual_maths/abacus_screen.dart';
import '../screens/visual_maths/place_value_explorer_screen.dart';
import '../screens/math_magic/math_magic_screen.dart';
import '../screens/math_magic/number_tricks_screen.dart';
import '../screens/math_magic/patterns_screen.dart';
import '../screens/math_magic/magic_squares_screen.dart';
import '../screens/math_magic/parity_screen.dart';
import '../screens/spatial_intelligence/spatial_intelligence_screen.dart';
import '../screens/spatial_intelligence/cube_nets_screen.dart';
import '../screens/spatial_intelligence/rotations_screen.dart';
import '../screens/spatial_intelligence/transformations_screen.dart';
import '../screens/spatial_intelligence/spatial_puzzles_screen.dart';
import '../screens/discovery/discovery_library_screen.dart';
import '../screens/discovery/discovery_card_detail_screen.dart';
import '../models/recall_card.dart';
import '../screens/recall/recall_cards_hub_screen.dart';
import '../screens/recall/recall_cards_browse_screen.dart';
import '../screens/recall/recall_cards_bookmarks_screen.dart';
import '../screens/recall/recall_card_detail_screen.dart';
import '../screens/recall/recall_review_session_screen.dart';
import '../screens/labs/interactive_labs_hub_screen.dart';
import '../screens/labs/fraction_builder_screen.dart';
import '../screens/labs/algebra_balance_screen.dart';
import '../screens/labs/number_line_explorer_screen.dart';
import '../screens/labs/flight_path_lab_screen.dart';
import '../screens/labs/football_precision_lab_screen.dart';
import '../screens/labs/maze_driver_lab_screen.dart';
import '../screens/labs/data_detective_screen.dart';
import '../screens/labs/spatial_cube_lab_hub_screen.dart';
import '../screens/labs/spatial_cube/spatial_cube_which_face_opposite_screen.dart';
import '../screens/labs/spatial_cube/spatial_cube_rotate_to_match_screen.dart';
import '../screens/labs/spatial_cube/spatial_cube_hidden_face_screen.dart';
import '../screens/labs/spatial_cube/spatial_cube_net_explorer_screen.dart';
import '../screens/labs/aircraft_landing_lab_hub_screen.dart';
import '../screens/labs/aircraft_landing/aircraft_landing_find_the_time_screen.dart';
import '../screens/labs/aircraft_landing/aircraft_landing_descent_line_screen.dart';
import '../screens/labs/aircraft_landing/aircraft_landing_glide_path_screen.dart';
import '../screens/labs/aircraft_landing/aircraft_landing_vector_approach_screen.dart';
import '../screens/labs/early_maths_playground_hub_screen.dart';
import '../screens/labs/feed_panda/feed_the_hungry_panda_screen.dart';
import '../screens/settings/release_notes_screen.dart';
import '../screens/settings/terms_screen.dart';
import '../screens/mental_math/daily_teaser_detail_screen.dart';
import '../screens/mental_math/mental_math_trick_detail_screen.dart';
import '../screens/mental_math/mental_math_vault_screen.dart';
import '../screens/upgrade/upgrade_screen.dart';

// ── Navigator key ownership model ───────────────────────────────────────────
// One GlobalKey<NavigatorState> per actual Navigator, created once at module
// load (never inside a build method), never reassigned:
//   - _rootNavigatorKey is the single root Navigator (GoRouter's own
//     `navigatorKey`). Any route with `parentNavigatorKey: _rootNavigatorKey`
//     (Settings/Profile sub-pages, Parent/Teacher Tools, Family Maths, Exam
//     Packs, Explore, Math Studio, ...) pushes its page onto this SAME
//     existing root Navigator — parentNavigatorKey only ever *selects* an
//     ancestor Navigator, it never instantiates a new one.
//   - Each StatefulShellBranch below owns exactly one of the 8 keys
//     (_homeNavKey.._helpNavKey), each assigned in exactly one place. The
//     StatefulShellRoute's IndexedStack keeps all 8 branch Navigators
//     permanently mounted (for per-tab back-stack preservation), which is
//     exactly why they must never be duplicated.
//
// THE BUG THIS PREVENTS: calling `context.push(path)` — instead of
// `context.go(path)` — for a path owned by one of these 8 branches, from a
// screen that lives OUTSIDE the shell (e.g. a root-navigator route like
// /explore or /math-studio), makes go_router construct a SECOND instance of
// the whole StatefulShellRoute subtree to host that push — reusing the same
// fixed branch key a second time while the first (still-mounted) shell
// instance is still using it. Flutter throws "A GlobalKey was used multiple
// times inside one widget's child list" (parent widget: HeroControllerScope)
// the moment both instances try to build in the same frame. Reproduced and
// root-caused via test/route_navigator_key_regression_test.dart — push()
// from an outside-shell route into /formulas or /journey crashes; go() from
// the same place does not; branch-to-branch push while already inside the
// shell (e.g. /topics -> push /practice) does not either, since no second
// shell instance is needed. Rule: any in-app navigation to /home, /topics,
// /practice, /journey, /formulas, /profile, /tutor, or /help from a route
// outside the shell MUST use go(), never push().
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _topicsNavKey = GlobalKey<NavigatorState>(debugLabel: 'topics');
final _practiceNavKey = GlobalKey<NavigatorState>(debugLabel: 'practice');
final _journeyNavKey = GlobalKey<NavigatorState>(debugLabel: 'journey');
final _formulasNavKey = GlobalKey<NavigatorState>(debugLabel: 'formulas');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');
final _tutorNavKey = GlobalKey<NavigatorState>(debugLabel: 'tutor');
final _helpNavKey = GlobalKey<NavigatorState>(debugLabel: 'help');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // ── Splash ────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const AppSplashScreen(),
    ),

    // ── Onboarding ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const UserTypeScreen(),
    ),
    GoRoute(
      path: '/onboarding/accessibility',
      builder: (context, state) => const AccessibilityStepScreen(),
    ),
    GoRoute(
      path: '/onboarding/stage',
      builder: (context, state) => const StageSelectorScreen(),
    ),
    GoRoute(
      path: '/onboarding/goal',
      builder: (context, state) => const GoalSelectorScreen(),
    ),
    GoRoute(
      path: '/onboarding/profile',
      builder: (context, state) => const StudyProfileScreen(),
    ),

    // ── Dedicated Parent/Tutor onboarding path ──────────────────────────────────
    // Branched from UserTypeScreen for every non-student role — see
    // lib/screens/onboarding/family/. Plain top-level routes, same as the
    // student onboarding block above (never inside the StatefulShellRoute).
    GoRoute(
      path: '/onboarding/family/role-detail',
      builder: (context, state) => const FamilyRoleDetailScreen(),
    ),
    GoRoute(
      path: '/onboarding/family/learner-context',
      builder: (context, state) => const FamilyLearnerContextScreen(),
    ),
    GoRoute(
      path: '/onboarding/family/goal',
      builder: (context, state) => const FamilyGoalScreen(),
    ),
    GoRoute(
      path: '/onboarding/family/preferences',
      builder: (context, state) => const FamilyPreferencesScreen(),
    ),

    // ── Family Studio ────────────────────────────────────────────────────────
    // Its own top-level namespace (never inside the StatefulShellRoute), so
    // it's always safe to push() from anywhere — Home, Profile, Settings,
    // or the onboarding finish step's go(). See the navigator-key ownership
    // model comment above. Each screen is individually wrapped in
    // ParentGate(allowGraceAccess: true) so a direct deep link can't bypass
    // the gate either — mirroring how Family Maths already protects itself.
    GoRoute(
      path: '/family-studio',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => FamilyStudioHubScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/today',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => FamilyTodayActivityScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/homework-companion',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => HomeworkCompanionScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/learning',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => WhatYourChildIsLearningScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/conversation-starters',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => ConversationStartersScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/parent-recall-cards',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => ParentRecallCardsScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/progress',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => FamilyProgressSnapshotScreen(),
      ),
    ),
    GoRoute(
      path: '/family-studio/tutor-tools',
      builder: (context, state) => ParentGate(
        allowGraceAccess: true,
        builder: (context) => TutorToolsScreen(),
      ),
    ),

    // ── Auth ──────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/auth/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/auth/create',
      builder: (context, state) => const CreateAccountScreen(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // ── Legacy redirect ───────────────────────────────────────────────────────
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),

    // ── Exam Packs (pushed above shell from Home / Topics) ────────────────────
    GoRoute(
      path: '/packs',
      builder: (context, state) => const ExamPacksScreen(),
    ),

    // ── Entrance Exam Preparation (pushed above shell from Practice's Exam
    //     Simulator exam-choice picker — a distinct area from GCSE Exam
    //     Simulator/Topic Drill/Practice, not a new bottom-nav item) ─────────
    GoRoute(
      path: '/entrance-exam',
      builder: (context, state) => const EntranceExamHubScreen(),
      routes: [
        GoRoute(
          path: 'skills',
          builder: (context, state) => const EntranceExamSkillListScreen(),
          routes: [
            GoRoute(
              path: ':skillId',
              builder: (context, state) => EntranceExamPracticeSessionScreen(
                skillId: state.pathParameters['skillId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'review',
          builder: (context, state) => const EntranceExamReviewScreen(),
        ),
      ],
    ),

    // ── Feature Discovery (pushed above shell from the More sheet) ────────────
    GoRoute(
      path: '/explore',
      builder: (context, state) => const ExploreMathIntelligenceScreen(),
    ),

    // ── Math Studio (curriculum-independent pillar, pushed above shell from
    //     Home / the More sheet — no exam/curriculum selection required) ─────
    GoRoute(
      path: '/math-studio',
      builder: (context, state) => const MathStudioHubScreen(),
      routes: [
        GoRoute(
          path: 'build-confidence',
          builder: (context, state) => const BuildConfidenceScreen(),
        ),
        GoRoute(
          path: 'mental-maths',
          builder: (context, state) => const MentalMathsHubScreen(),
          routes: [
            GoRoute(
              path: ':categoryId',
              builder: (context, state) => MentalMathsCategoryScreen(
                categoryId: state.pathParameters['categoryId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'visual-maths',
          builder: (context, state) => const VisualMathsHubScreen(),
          routes: [
            GoRoute(
              path: 'number-line',
              builder: (context, state) => const NumberLineScreen(),
            ),
            GoRoute(
              path: 'fraction-bars',
              builder: (context, state) => const FractionBarsScreen(),
            ),
            GoRoute(
              path: 'abacus',
              builder: (context, state) => const AbacusScreen(),
            ),
            GoRoute(
              path: 'place-value',
              builder: (context, state) => const PlaceValueExplorerScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'math-magic',
          builder: (context, state) => const MathMagicScreen(),
          routes: [
            GoRoute(
              path: 'number-tricks',
              builder: (context, state) => const NumberTricksScreen(),
            ),
            GoRoute(
              path: 'patterns',
              builder: (context, state) => const PatternsScreen(),
            ),
            GoRoute(
              path: 'magic-squares',
              builder: (context, state) => const MagicSquaresScreen(),
            ),
            GoRoute(
              path: 'parity',
              builder: (context, state) => const ParityScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'spatial-intelligence',
          builder: (context, state) => const SpatialIntelligenceScreen(),
          routes: [
            GoRoute(
              path: 'cube-nets',
              builder: (context, state) => const CubeNetsScreen(),
            ),
            GoRoute(
              path: 'rotations',
              builder: (context, state) => const RotationsScreen(),
            ),
            GoRoute(
              path: 'transformations',
              builder: (context, state) => const TransformationsScreen(),
            ),
            GoRoute(
              path: 'spatial-puzzles',
              builder: (context, state) => const SpatialPuzzlesScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'discovery',
          builder: (context, state) => const DiscoveryLibraryScreen(),
          routes: [
            GoRoute(
              path: ':cardId',
              builder: (context, state) => DiscoveryCardDetailScreen(
                cardId: state.pathParameters['cardId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'recall-cards',
          builder: (context, state) => const RecallCardsHubScreen(),
          routes: [
            GoRoute(
              path: 'browse',
              builder: (context, state) {
                final extra = state.extra;
                final filters = extra is Map ? extra : const <String, String>{};
                final topicId = filters['topic'] as String?;
                final typeId = filters['type'] as String?;
                return RecallCardsBrowseScreen(
                  initialTopic:
                      topicId == null ? null : RecallTopic.fromId(topicId),
                  initialType:
                      typeId == null ? null : RecallCardType.fromId(typeId),
                );
              },
            ),
            GoRoute(
              path: 'bookmarks',
              builder: (context, state) => const RecallCardsBookmarksScreen(),
            ),
            GoRoute(
              path: 'card/:cardId',
              builder: (context, state) => RecallCardDetailScreen(
                cardId: state.pathParameters['cardId']!,
              ),
            ),
            GoRoute(
              path: 'session',
              builder: (context, state) => RecallReviewSessionScreen(
                cards: (state.extra as List<RecallCard>?) ?? const [],
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'interactive-labs',
          builder: (context, state) => const InteractiveLabsHubScreen(),
          routes: [
            GoRoute(
              path: 'fraction-builder',
              builder: (context, state) => const FractionBuilderScreen(),
            ),
            GoRoute(
              path: 'algebra-balance',
              builder: (context, state) => const AlgebraBalanceScreen(),
            ),
            GoRoute(
              path: 'number-line-explorer',
              builder: (context, state) => const NumberLineExplorerScreen(),
            ),
            GoRoute(
              path: 'flight-path-lab',
              builder: (context, state) => const FlightPathLabScreen(),
            ),
            GoRoute(
              path: 'football-precision',
              builder: (context, state) => const FootballPrecisionLabScreen(),
            ),
            GoRoute(
              path: 'maze-driver',
              builder: (context, state) => const MazeDriverLabScreen(),
            ),
            GoRoute(
              path: 'data-detective',
              builder: (context, state) => const DataDetectiveScreen(),
            ),
            GoRoute(
              path: 'spatial-cube-lab',
              builder: (context, state) => const SpatialCubeLabHubScreen(),
              routes: [
                GoRoute(
                  path: 'which-face-opposite',
                  builder: (context, state) =>
                      const SpatialCubeWhichFaceOppositeScreen(),
                ),
                GoRoute(
                  path: 'rotate-to-match',
                  builder: (context, state) =>
                      const SpatialCubeRotateToMatchScreen(),
                ),
                GoRoute(
                  path: 'hidden-face',
                  builder: (context, state) =>
                      const SpatialCubeHiddenFaceScreen(),
                ),
                GoRoute(
                  path: 'cube-net-explorer',
                  builder: (context, state) =>
                      const SpatialCubeNetExplorerScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'aircraft-landing-lab',
              builder: (context, state) => const AircraftLandingLabHubScreen(),
              routes: [
                GoRoute(
                  path: 'find-the-time',
                  builder: (context, state) =>
                      const AircraftLandingFindTheTimeScreen(),
                ),
                GoRoute(
                  path: 'follow-the-descent-line',
                  builder: (context, state) =>
                      const AircraftLandingDescentLineScreen(),
                ),
                GoRoute(
                  path: 'land-on-the-glide-path',
                  builder: (context, state) =>
                      const AircraftLandingGlidePathScreen(),
                ),
                GoRoute(
                  path: 'vector-approach',
                  builder: (context, state) =>
                      const AircraftLandingVectorApproachScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'early-maths-playground',
              builder: (context, state) =>
                  const EarlyMathsPlaygroundHubScreen(),
              routes: [
                GoRoute(
                  path: 'feed-the-hungry-panda',
                  builder: (context, state) => const FeedTheHungryPandaScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/mental-math',
      builder: (context, state) => const MentalMathVaultScreen(),
      routes: [
        GoRoute(
          path: ':trickId',
          builder: (context, state) => MentalMathTrickDetailScreen(
            trickId: state.pathParameters['trickId']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/daily-teaser',
      builder: (context, state) => const DailyTeaserDetailScreen(),
    ),
    GoRoute(
      path: '/tricks',
      redirect: (_, __) => '/mental-math',
    ),

    // ── Premium upgrade placeholder ───────────────────────────────────────────
    GoRoute(
      path: '/upgrade',
      builder: (context, state) => const UpgradeScreen(),
    ),

    // ── Release notes ─────────────────────────────────────────────────────────
    if (BuildFlags.enableDevUi)
      GoRoute(
        path: '/release-notes',
        builder: (context, state) => const ReleaseNotesScreen(),
      ),

    // ── Main shell (StatefulShellRoute keeps per-tab back stacks) ─────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(shell: navigationShell),
      branches: [
        // 0 — Home
        StatefulShellBranch(
          navigatorKey: _homeNavKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeTabContent(),
            ),
          ],
        ),

        // 1 — Topics
        StatefulShellBranch(
          navigatorKey: _topicsNavKey,
          routes: [
            GoRoute(
              path: '/topics',
              builder: (context, state) => const TopicsScreen(),
            ),
          ],
        ),

        // 2 — Practice
        StatefulShellBranch(
          navigatorKey: _practiceNavKey,
          routes: [
            GoRoute(
              path: '/practice',
              builder: (context, state) {
                final extra = state.extra;
                final topic = extra is Map<String, dynamic>
                    ? extra['topic'] as String?
                    : null;
                final topicId = extra is Map<String, dynamic>
                    ? extra['topicId'] as String?
                    : null;
                final autoStart = extra is Map<String, dynamic>
                    ? extra['autoStart'] as bool? ?? false
                    : false;
                return PracticeScreen(
                  selectedTopic: topic,
                  selectedTopicId: topicId,
                  autoStart: autoStart,
                );
              },
            ),
          ],
        ),

        // 3 — Journey
        StatefulShellBranch(
          navigatorKey: _journeyNavKey,
          routes: [
            GoRoute(
              path: '/journey',
              builder: (context, state) => const JourneyScreen(),
            ),
          ],
        ),

        // 4 — Formula Library
        StatefulShellBranch(
          navigatorKey: _formulasNavKey,
          routes: [
            GoRoute(
              path: '/formulas',
              builder: (context, state) => const FormulaLibraryScreen(),
            ),
          ],
        ),

        // 5 — Profile (settings sub-pages break out above the shell so they
        //     appear full-screen without the nav bar, matching the old behaviour)
        StatefulShellBranch(
          navigatorKey: _profileNavKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'appearance',
                  builder: (context, state) => const AppearanceScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'accessibility',
                  builder: (context, state) => const AccessibilityScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'subscription',
                  builder: (context, state) => const SubscriptionScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'curriculum',
                  builder: (context, state) => const CurriculumSettingsScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'privacy',
                  builder: (context, state) => const PrivacyDataScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'terms',
                  builder: (context, state) => const TermsScreen(),
                ),
              ],
            ),
          ],
        ),

        // 6 — Tutor
        StatefulShellBranch(
          navigatorKey: _tutorNavKey,
          routes: [
            GoRoute(
              path: '/tutor',
              builder: (context, state) => const TutorScreen(),
            ),
          ],
        ),

        // 7 — Help
        StatefulShellBranch(
          navigatorKey: _helpNavKey,
          routes: [
            GoRoute(
              path: '/help',
              builder: (context, state) => const HelpScreen(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'parent-teacher-tools',
                  builder: (context, state) => const ParentTeacherToolsScreen(),
                  routes: [
                    // Nested GoRoutes do not inherit a parent's
                    // parentNavigatorKey — each must redeclare it, exactly
                    // like the family-maths sibling below. This one was
                    // previously missing it: pushing here defaulted to the
                    // Help branch's own (not currently visible, since
                    // parent-teacher-tools itself already lives on the
                    // root navigator) Navigator, so the push silently
                    // produced no visible change — no exception, nothing
                    // wrong in the console, just a tap that appeared to do
                    // nothing.
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      path: 'cheat-sheet',
                      builder: (context, state) =>
                          const ParentCheatSheetScreen(),
                    ),
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      path: 'family-maths',
                      builder: (context, state) =>
                          const FamilyMathsWelcomeScreen(),
                      routes: [
                        GoRoute(
                          parentNavigatorKey: _rootNavigatorKey,
                          path: 'library',
                          builder: (context, state) => FamilyMathsLibraryScreen(
                            initialCategory: state.extra is FamilyMathsCategory
                                ? state.extra as FamilyMathsCategory
                                : null,
                          ),
                        ),
                        GoRoute(
                          parentNavigatorKey: _rootNavigatorKey,
                          path: 'activity/:activityId',
                          builder: (context, state) =>
                              FamilyActivityDetailScreen(
                            activityId: state.pathParameters['activityId']!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
