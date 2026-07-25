import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/config/build_flags.dart';
import '../screens/home/home_shell.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/splash/app_splash_screen.dart';
import '../screens/practice/practice_screen.dart';
import '../screens/tutor/tutor_screen.dart';
import '../screens/topics/topics_screen.dart';
import '../screens/settings/help_screen.dart';
import '../screens/settings/parent_teacher_tools_screen.dart';
import '../screens/settings/parent_cheat_sheet_screen.dart';
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
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/create_account_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/packs/exam_packs_screen.dart';
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
import '../screens/spatial_intelligence/spatial_intelligence_screen.dart';
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
import '../screens/labs/data_detective_screen.dart';
import '../screens/settings/release_notes_screen.dart';
import '../screens/settings/terms_screen.dart';
import '../screens/mental_math/daily_teaser_detail_screen.dart';
import '../screens/mental_math/mental_math_trick_detail_screen.dart';
import '../screens/mental_math/mental_math_vault_screen.dart';
import '../screens/upgrade/upgrade_screen.dart';

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
        ),
        GoRoute(
          path: 'spatial-intelligence',
          builder: (context, state) => const SpatialIntelligenceScreen(),
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
                  initialTopic: topicId == null ? null : RecallTopic.fromId(topicId),
                  initialType: typeId == null ? null : RecallCardType.fromId(typeId),
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
              path: 'data-detective',
              builder: (context, state) => const DataDetectiveScreen(),
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
                    GoRoute(
                      path: 'cheat-sheet',
                      builder: (context, state) =>
                          const ParentCheatSheetScreen(),
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
