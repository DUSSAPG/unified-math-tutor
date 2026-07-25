// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navTopics => 'Topics';

  @override
  String get navPractice => 'Practice';

  @override
  String get navProfile => 'Profile';

  @override
  String get navTutor => 'Tutor';

  @override
  String get navHelp => 'Help';

  @override
  String get topicsSearchHint => 'Search topics...';

  @override
  String get topicsFilterAll => 'All';

  @override
  String get topicsFilterPractice => 'Practice';

  @override
  String get topicsFilterRecommended => 'Recommended';

  @override
  String get topicsFilterOxfordTrack => 'Oxford Track';

  @override
  String get topicsFilterGcse => 'GCSE';

  @override
  String get topicsFilterMore => 'More';

  @override
  String get topicsSelectTrack => 'Select Track';

  @override
  String get topicsTrackStandard => 'Standard';

  @override
  String get topicsTrackStandardSub => 'Core curriculum for all Key Stages';

  @override
  String get topicsTrackGcseFoundation => 'GCSE Foundation';

  @override
  String get topicsTrackGcseFoundationSub => 'Foundation tier GCSE preparation';

  @override
  String get topicsTrackGcseHigher => 'GCSE Higher';

  @override
  String get topicsTrackGcseHigherSub => 'Higher tier GCSE preparation';

  @override
  String get topicsTrackOxford => 'Oxford Track';

  @override
  String get topicsTrackOxfordSub =>
      '11+ prep, stretch questions & competition math';

  @override
  String get topicsPremiumComingSoon => 'Premium feature';

  @override
  String get topicsPremiumLabel => 'PREMIUM';

  @override
  String get practiceChooseMode => 'Choose your practice mode';

  @override
  String get practiceModeLabel => 'MODE';

  @override
  String get practiceQuestionsLabel => 'QUESTIONS';

  @override
  String get practiceStartButton => 'Start Practice';

  @override
  String get practiceModeQuickStart => 'Quick Start';

  @override
  String get practiceModeQuickStartSub => 'Mixed review, 10 questions';

  @override
  String get practiceModeTopicDrill => 'Topic Drill';

  @override
  String get practiceModeTopicDrillSub => 'Choose a specific topic';

  @override
  String get practiceModeTimedChallenge => 'Timed Challenge';

  @override
  String get practiceModeTimedChallengeSub => 'Race against the clock';

  @override
  String get practiceModeExamSimulator => 'Exam Simulator';

  @override
  String get practiceModeExamSimulatorSub => 'GCSE-style mock test';

  @override
  String practiceModeExamSimulatorSubFor(String examLabel) {
    return '$examLabel-style mock test';
  }

  @override
  String get practiceExamSimulatorSelectPrompt => 'Select an exam to begin';

  @override
  String get practiceSelectExamLabel => 'SELECT EXAM';

  @override
  String get practiceExamSwissGymnasium => 'Swiss Gymnasium';

  @override
  String get practiceExit => 'Exit';

  @override
  String practiceQuestionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get practiceMixedReview => 'Mixed Review';

  @override
  String get practiceExplanation => 'Explanation';

  @override
  String get practiceCheckAnswer => 'Check Answer';

  @override
  String get practiceNextQuestion => 'Next Question →';

  @override
  String get practiceFinishSession => 'Finish Session';

  @override
  String get tutorBotName => 'TutorBot';

  @override
  String get tutorBotSubtitle =>
      'Get hints, explanations and step-by-step support.';

  @override
  String tutorFreeTipsLeft(int count) {
    return 'Free tips left today: $count';
  }

  @override
  String get tutorChipExplain => 'Explain this';

  @override
  String get tutorChipHint => 'Give me a hint';

  @override
  String get tutorChipSteps => 'Show steps';

  @override
  String get tutorChipCheckMistake => 'Check my mistake';

  @override
  String get tutorInputHint => 'Ask TutorBot a question...';

  @override
  String get tutorNeedMoreHelp => 'Need more help?';

  @override
  String get tutorUnlockDeeper =>
      'Unlock deeper explanations with Tutor credits or a paid math pack.';

  @override
  String get tutorBuyCredits => 'Buy Tutor Credits';

  @override
  String get tutorViewPacks => 'View Packs';

  @override
  String get profileSettingsLabel => 'SETTINGS';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileAppearanceSub => 'Theme and visual settings';

  @override
  String get profileAccessibility => 'Accessibility';

  @override
  String get profileAccessibilitySub => 'Text size, contrast & animations';

  @override
  String get profileSubscription => 'Subscription';

  @override
  String get profileSubscriptionSub => 'Manage your plan';

  @override
  String get profileCurriculumSettings => 'Curriculum Settings';

  @override
  String get profileCurriculumSettingsSub => 'KS2 · School Support · ks2';

  @override
  String get profilePrivacyData => 'Privacy & Data';

  @override
  String get profilePrivacyDataSub =>
      'GDPR compliant · No ads · No third-party sharing';

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get profileSignOutSub => 'Clear session and return to welcome';

  @override
  String profileVersionNumber(String version) {
    return 'Version $version';
  }

  @override
  String get profileCopyright => '© QuantumLab Intelligence';

  @override
  String get profileHeaderTitle => 'Profile';

  @override
  String get profileHeaderSubtitle => 'Settings & preferences';

  @override
  String get profilePreferredDisplayName => 'Preferred Display Name';

  @override
  String get profilePreferredDisplayNameNotSet => 'Not set';

  @override
  String get profileChangeDisplayName => 'Change Display Name';

  @override
  String get profileGreetingPreview => 'Greeting Preview';

  @override
  String get profileSwitchLearner => 'Switch Learner';

  @override
  String get profileDisplayNameDialogHint => 'e.g. Sam or a nickname';

  @override
  String get whoIsLearningTitle => 'Who\'s learning today?';

  @override
  String get whoIsLearningAddLearner => 'Add Learner';

  @override
  String get whoIsLearningAddLearnerHint => 'Learner\'s name';

  @override
  String homeLearningAsLabel(String name) {
    return 'Learning as: $name';
  }

  @override
  String get homeSwitchLearnerAction => 'Switch';

  @override
  String get helpHeaderTitle => 'Help & Support';

  @override
  String get helpHeaderSubtitle => 'Support, safety & app information';

  @override
  String get helpFaqTitle => 'Frequently Asked Questions';

  @override
  String get helpFaq1Q => 'How does the Key Stage selection work?';

  @override
  String get helpFaq1A =>
      'During onboarding you choose your Key Stage (KS2–KS5). This tailors topics, difficulty, and exam packs to your curriculum level. You can change it anytime in Curriculum Settings.';

  @override
  String get helpFaq2Q => 'Is my data secure?';

  @override
  String get helpFaq2A =>
      'Yes. We collect only what is needed to personalize your learning. No data is sold or shared with third parties. All data is deletable at any time.';

  @override
  String get helpFaq3Q => 'Can I add multiple children?';

  @override
  String get helpFaq3A =>
      'Currently each installation supports one learner profile. Learning Analytics and progress reports are available from More or Profile.';

  @override
  String get helpFaq4Q => 'How do GCSE exam packs work?';

  @override
  String get helpFaq4A =>
      'Exam packs are curated sets of past-paper style questions grouped by topic and difficulty tier. Tap Practice → Exam Simulator to start a GCSE-style timed session.';

  @override
  String get helpContactTitle => 'Contact';

  @override
  String get helpContactIntro => 'For questions or issues, contact us:';

  @override
  String get helpContactEmail => 'support@mathtutor.app';

  @override
  String get helpPrivacyTitle => 'Privacy & Safety';

  @override
  String get helpPrivacyHeadline => 'Minimal data. No ads. GDPR compliant.';

  @override
  String get helpPrivacyBullet1 => 'We only collect necessary data';

  @override
  String get helpPrivacyBullet2 => 'No sharing with third parties';

  @override
  String get helpPrivacyBullet3 => 'Learning Analytics available';

  @override
  String get helpPrivacyBullet4 => 'Deletable at any time';

  @override
  String get helpTermsTitle => 'Terms of Use';

  @override
  String get helpTermsBody =>
      'Free for students and parents. By using Math Intelligence you agree to our terms of service. No payment is required for standard access.';

  @override
  String get helpParentalTitle => 'Learning Analytics';

  @override
  String get helpParentalHeadline =>
      'Understand progress, identify learning gaps and support the next step.';

  @override
  String get helpParentalBullet1 => 'Progress Overview';

  @override
  String get helpParentalBullet2 => 'Topic Mastery';

  @override
  String get helpParentalBullet3 => 'Learning Trends';

  @override
  String get helpParentalBullet4 => 'Recommended Practice';

  @override
  String get helpReportButton => 'Report a Problem';

  @override
  String get helpFooter =>
      'Minimal data. No ads. Learning Analytics available.';

  @override
  String get swissChooseLanguage => 'Switzerland • Choose language';

  @override
  String get tutorChipDeepExplanation => 'Deep Explanation';

  @override
  String get tutorChipStepByStep => 'Step-by-step';

  @override
  String get tutorChipMistakeAnalysis => 'Mistake Analysis';

  @override
  String get tutorCreditBadge => '1 credit';

  @override
  String tutorCreditBalance(int count) {
    return '$count credits';
  }

  @override
  String get tutorProLabel => 'Premium';

  @override
  String get tutorExhaustedTitle => 'Free tips used up';

  @override
  String get tutorExhaustedBody =>
      'You\'ve used all 3 free tips. Buy credits or upgrade to continue.';

  @override
  String get tutorCreditRequired => 'Requires 1 credit';

  @override
  String get tutorPracticeContextLabel => 'Practising';

  @override
  String get tutorContextHint => 'Hint';

  @override
  String get tutorContextExplain => 'Explanation';

  @override
  String homeGreetingMorningNamed(String name) {
    return 'Good morning, $name';
  }

  @override
  String get homeGreetingMorningDefault => 'Good morning';

  @override
  String homeGreetingAfternoonNamed(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String get homeGreetingAfternoonDefault => 'Good afternoon';

  @override
  String homeGreetingEveningNamed(String name) {
    return 'Good evening, $name';
  }

  @override
  String get homeGreetingEveningDefault => 'Good evening';

  @override
  String homeGreetingNightNamed(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get homeGreetingNightDefault => 'Welcome back';

  @override
  String get homeStreakGoalMessage => '· 10 minutes to hit your streak goal';

  @override
  String get homeSectionContinueLearning => 'Continue Learning';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeSectionProgress => 'Progress';

  @override
  String get homeStreakHeader => 'Streak';

  @override
  String get homeStreakFirstDay => 'First day of your streak';

  @override
  String get homeThisWeekHeader => 'This week';

  @override
  String get homeDaysActive => 'Days active';

  @override
  String get homeSectionAchievements => 'Achievements';

  @override
  String get homeAchievementStreakTitle => 'Weekly streak reached!';

  @override
  String get homeAchievementStreakSubtitle => '7 days of learning in a row';

  @override
  String get homeAchievementStreakLocked =>
      'Reach a 7-day streak to unlock this';

  @override
  String get homeSectionOxfordTrack => 'Oxford Track';

  @override
  String get homePremiumRequired => 'PREMIUM REQUIRED';

  @override
  String get homeOxfordTrackSubtitle =>
      '11+ prep, advanced challenges & competition math';

  @override
  String get homeSectionLearningPaths => 'Learning Paths';

  @override
  String get homeSectionExamPacks => 'Exam Packs';

  @override
  String get homeExamPacksSubtitle => 'Targeted exam preparation';

  @override
  String get homeViewExamPacks => 'View Exam Packs';

  @override
  String get homeStartPracticeSession => 'Start Practice Session';

  @override
  String get onboardingWelcomeTitle =>
      'Develop mathematical thinking.\nUnlock your potential.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personalised learning. Measurable progress.';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => '학습자입니다';

  @override
  String get onboardingStudentSub =>
      'Practice mathematics with a learning journey designed around you.';

  @override
  String get onboardingParentLabel => '학습자를 지원합니다';

  @override
  String get onboardingParentSub =>
      'Support every step of a learner\'s mathematical development.';

  @override
  String get onboardingTeacherLabel => '교사입니다';

  @override
  String get onboardingTeacherSub => '학생의 학습 진행 상황을 확인하고 연습을 배정하세요.';

  @override
  String get onboardingSelectError => 'Please select an option';

  @override
  String get onboardingSignInPrompt => 'Already have an account?';

  @override
  String get onboardingSignIn => 'Sign In';

  @override
  String get onboardingGuestMode => 'Guest Mode';

  @override
  String get onboardingGuestModeSub => 'Try a limited practice session.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingFooter =>
      'Minimal data. No ads. Learning Analytics available.';

  @override
  String get onboardingAccessibilityTitle => 'Make it comfortable to read';

  @override
  String get onboardingAccessibilitySub =>
      'You can change these anytime in Settings.';

  @override
  String get onboardingStageTitle => 'Choose your level';

  @override
  String get onboardingStageSub =>
      'We\'ll tailor the content to the right level';

  @override
  String get onboardingStageTitleParent => 'Choose the learner\'s level';

  @override
  String get onboardingStageSubParent =>
      'We\'ll tailor content to the learner\'s current level.';

  @override
  String get onboardingStageCount => '4';

  @override
  String get onboardingStage1Label => 'KS2 (Years 3–6)';

  @override
  String get onboardingStage1Sub => 'Primary school math';

  @override
  String get onboardingStage2Label => 'KS3 (Years 7–9)';

  @override
  String get onboardingStage2Sub => 'Secondary school math';

  @override
  String get onboardingStage3Label => 'KS4 GCSE (Years 10–11)';

  @override
  String get onboardingStage3Sub => 'GCSE math preparation';

  @override
  String get onboardingStage4Label => 'KS5 (Years 12–13)';

  @override
  String get onboardingStage4Sub => 'Advanced math';

  @override
  String get onboardingGoalTitle => 'What\'s the goal?';

  @override
  String get onboardingGoalSub => 'Choose the learning focus';

  @override
  String get onboardingGoalTitleParent => 'How would you like to support them?';

  @override
  String get onboardingGoalSubParent =>
      'Choose the support focus for this learner.';

  @override
  String get onboardingGoal1Label => 'Build confidence';

  @override
  String get onboardingGoal1Sub =>
      'Steady, low-pressure practice at your own pace';

  @override
  String get onboardingGoal2Label => 'Improve school maths';

  @override
  String get onboardingGoal2Sub => 'Strengthen everyday classroom topics';

  @override
  String get onboardingGoal3Label => 'Prepare for exams';

  @override
  String get onboardingGoal3Sub => 'Targeted GCSE practice & timed sets';

  @override
  String get onboardingGoal4Label => 'Challenge myself';

  @override
  String get onboardingGoal4Sub => 'Stretch challenges and advanced problems';

  @override
  String get onboardingParentGoal1Label => 'Help build mathematical confidence';

  @override
  String get onboardingParentGoal1Sub =>
      'Support steady, low-pressure practice at the learner\'s pace.';

  @override
  String get onboardingParentGoal2Label => 'Identify learning gaps';

  @override
  String get onboardingParentGoal2Sub =>
      'Spot topics that need more attention before they become blockers.';

  @override
  String get onboardingParentGoal3Label => 'Track progress over time';

  @override
  String get onboardingParentGoal3Sub =>
      'Follow growth and consistency across completed practice.';

  @override
  String get onboardingParentGoal4Label => 'Support exam preparation';

  @override
  String get onboardingParentGoal4Sub =>
      'Guide revision and practice for upcoming assessments.';

  @override
  String get onboardingGoalTitleTeacher => 'Math Intelligence를 어떻게 사용하고 싶으신가요?';

  @override
  String get onboardingGoalSubTeacher => '학급에 맞는 목표를 선택하세요.';

  @override
  String get onboardingTeacherGoal1Label => '학급 진행 상황 확인';

  @override
  String get onboardingTeacherGoal1Sub => '학생들의 학습 진행 상황을 시간에 따라 확인하세요.';

  @override
  String get onboardingTeacherGoal2Label => '연습 문제 배정';

  @override
  String get onboardingTeacherGoal2Sub => '학생들에게 맞춤 연습 세트를 배정하세요.';

  @override
  String get onboardingTeacherGoal3Label => '시험 준비';

  @override
  String get onboardingTeacherGoal3Sub => '집중 연습 세트로 시험 대비를 지원하세요.';

  @override
  String get onboardingTeacherGoal4Label => '커리큘럼 살펴보기';

  @override
  String get onboardingTeacherGoal4Sub => '배정하기 전에 주제와 풀이 과정을 살펴보세요.';

  @override
  String get onboardingProfileTitle => '진행 상황 저장하기';

  @override
  String get onboardingProfileSub => '선택 사항입니다 — 프로필에서 언제든지 변경할 수 있습니다.';

  @override
  String get onboardingDisplayNameLabel => '이름을 알려주세요';

  @override
  String get onboardingDisplayNameSub => '닉네임도 괜찮아요 — 인사말에만 사용됩니다.';

  @override
  String get onboardingDisplayNameHint => '예: Alex';

  @override
  String get onboardingLearnerNameLabel => '학습자를 어떻게 부를까요?';

  @override
  String get onboardingLearnerNameSub => '학습자만의 Maths Journey를 만들어 보세요.';

  @override
  String get onboardingLearnerNameHint => '예: Alex';

  @override
  String get onboardingRelationshipLabel => '학습자와의 관계';

  @override
  String get onboardingRelationshipParent => '부모';

  @override
  String get onboardingRelationshipGuardian => '보호자';

  @override
  String get onboardingRelationshipGrandparent => '조부모';

  @override
  String get onboardingRelationshipTutor => '과외 선생님';

  @override
  String get onboardingRelationshipOther => '기타 가족 구성원';

  @override
  String get onboardingParentEmailLabel => 'Supporting adult email (optional)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Stored locally on this device for account clarity.';

  @override
  String get onboardingPrivacyNote =>
      'Local-only profile details. No cloud sync is claimed for this release.';

  @override
  String get onboardingStartLearning => 'Start Learning';

  @override
  String get onboardingSkipEmail => 'Skip for now';

  @override
  String get appearanceLanguageTitle => 'Language';

  @override
  String get appearanceLanguageSub => 'App display language';

  @override
  String get upgradeTitle => 'Unlock Premium';

  @override
  String get upgradeBody => 'Unlock Premium features with a subscription.';

  @override
  String get upgradeViewPacks => 'View Exam Packs';

  @override
  String get upgradeMaybeLater => 'Maybe Later';

  @override
  String get termsTitle => 'Terms of Use';

  @override
  String get termsSub => 'Please read before using this app';

  @override
  String get tutorCreditComingSoon => 'Available in exam packs.';

  @override
  String get upgradeWhatsIncluded => 'What you\'ll get';

  @override
  String get upgradeBenefit1Title => 'Unlimited AI Tutor';

  @override
  String get upgradeBenefit1Sub =>
      'Ask unlimited questions, get step-by-step explanations, and receive personalized hints without credit limits.';

  @override
  String get upgradeBenefit2Title => 'Oxford-Style Track';

  @override
  String get upgradeBenefit2Sub =>
      'Access the structured Oxford curriculum track with curated problem sets and guided progression from KS3 to A-Level.';

  @override
  String get upgradeBenefit3Title => 'Learning Analytics';

  @override
  String get upgradeBenefit3Sub =>
      'Track your progress with detailed performance charts, weakness detection, and personalized study recommendations.';

  @override
  String get upgradeComingSoonLabel => 'Included in Premium';

  @override
  String get upgradeComingSoon1 => 'Monthly & annual subscription plans';

  @override
  String get upgradeComingSoon2 => 'Multi-profile family accounts';

  @override
  String get upgradeComingSoon3 =>
      'Daily streak reminders & push notifications';

  @override
  String get upgradeComingSoon4 => 'Achievements and milestone rewards';

  @override
  String get upgradeJoinEarlyAccess => 'Join Early Access';

  @override
  String get upgradeEarlyAccessSnackbar =>
      'Early access sign-up is coming soon. Stay tuned!';

  @override
  String get profileAboutLabel => 'About';

  @override
  String get profileReleaseNotes => 'Release Notes';

  @override
  String get tutorEmptyTitle => 'No messages yet';

  @override
  String get tutorEmptySubtitle =>
      'Ask a question about any topic and your AI tutor will help you step by step.';

  @override
  String get homeStreakDays => '5 Day Streak';

  @override
  String get homeAchievementUnlocked => 'Unlocked';

  @override
  String get homeBadgeLocked => 'Locked';

  @override
  String get homeWhatsNewTitle => 'What\'s New in v1.0';

  @override
  String get homeWhatsNewBody =>
      'AI Tutor, Oxford Track, and GCSE exam packs are now live.';

  @override
  String get homeDailyGoalTitle => 'Daily Goal';

  @override
  String get homeDailyGoalSubtitle => 'Solve 15 questions today';

  @override
  String homeDailyGoalProgress(int completed, int target) {
    return '$completed / $target completed';
  }

  @override
  String get tutorHowItWorksTitle => 'How Tutor Works';

  @override
  String get tutorHowItWorksStep1Title => 'Ask any question';

  @override
  String get tutorHowItWorksStep1Sub =>
      'Type a math question or tap a quick action above.';

  @override
  String get tutorHowItWorksStep2Title => 'Get a step-by-step answer';

  @override
  String get tutorHowItWorksStep2Sub =>
      'The AI breaks down the solution so you understand every step.';

  @override
  String get tutorHowItWorksStep3Title => 'Practice what you learn';

  @override
  String get tutorHowItWorksStep3Sub =>
      'Head to Practice to apply what you\'ve just learned.';

  @override
  String get practiceSummaryTitle => 'Session Complete';

  @override
  String practiceSummaryAccuracy(int percent) {
    return '$percent% accuracy';
  }

  @override
  String practiceSummaryCorrect(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get practiceSummaryEncouragement =>
      'Great work! Keep practising to improve your score.';

  @override
  String get practiceSummaryClose => 'Back to Practice';

  @override
  String get helpFeatureRequestButton => 'Request a Feature';

  @override
  String get helpFeatureRequestSnackbar =>
      'Feature requests coming soon — thanks for your interest!';

  @override
  String get helpReportSnackbar =>
      'Thanks for your report! We\'ll look into it soon.';

  @override
  String get mentalMathVaultTitle => 'Mental Math Vault';

  @override
  String get mentalMathVaultSubtitle => 'Learn powerful calculation shortcuts';

  @override
  String get homeFormulaLibraryTitle => 'Formula Library';

  @override
  String get homeFormulaLibrarySubtitle =>
      'Quick reference for key maths formulas';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get dailyBrainTeaser => 'Daily Brain Teaser';

  @override
  String get revealAnswer => 'Reveal Answer';

  @override
  String get captainNumberFuel => 'Captain Number Fuel';

  @override
  String get dailyMissionTitle => 'Captain Number needs fuel!';

  @override
  String get dailyMissionSubtitle =>
      'Solve 5 questions to power today\'s mission.';

  @override
  String get workedExample => 'Worked example';

  @override
  String get practiceExample => 'Practice example';

  @override
  String get loading => 'Loading...';

  @override
  String get practiceNoQuestions => 'No practice questions are available.';

  @override
  String get practiceTopicDrillEmpty =>
      'No questions found for this topic at this stage yet. Try a different topic or stage.';

  @override
  String get mascotGreeting => 'Ready to power up your maths?';

  @override
  String get mascotThinking => 'Take your time. Think it through!';

  @override
  String get mascotSuccess => 'Great calculation! Fuel added.';

  @override
  String get mascotEncouragement => 'Good try. The next one is yours!';

  @override
  String get mascotLevelUp => 'Mission powered! Captain Number is ready!';

  @override
  String get homeTopicFractionsTitle => 'Fractions & Percentages';

  @override
  String get homeTopicFractionsSubtitle => 'Basics & conversion';

  @override
  String get homeTopicAlgebraTitle => 'Algebra Basics';

  @override
  String get homeTopicAlgebraSubtitle => 'Equations & variables';

  @override
  String get homeTopicStatisticsTitle => 'Statistics & Probability';

  @override
  String get homeTopicStatisticsSubtitle => 'Data handling & chance';

  @override
  String get homeLearningFractionsTitle => 'Fractions';

  @override
  String get homeLearningFractionsSubtitle => 'Learn fractions and conversions';

  @override
  String get homeLearningStatisticsTitle => 'Statistics';

  @override
  String get homeLearningStatisticsSubtitle =>
      'Introduction to data and probability';

  @override
  String get topicsStandardSelected => 'Standard track selected.';

  @override
  String get topicsNoResults => 'No topics found';

  @override
  String get topicsClearFilters => 'Clear filters';

  @override
  String get examPacksCtaSubtitle =>
      'Unlock GCSE Foundation, GCSE Higher, Oxford Track and Tutor Credits.';

  @override
  String get examPacksIntro =>
      'Choose a pack to unlock focused practice and Tutor support.';

  @override
  String examPackSelected(String stage) {
    return '$stage selected';
  }

  @override
  String get examPackKs2Title => 'KS2 Maths';

  @override
  String get examPackKs3Title => 'KS3 Maths';

  @override
  String get examPackKs4Title => 'KS4 GCSE Maths';

  @override
  String get examPackKs5Title => 'KS5 Maths';

  @override
  String get examPackPrimarySubtitle => 'Primary school practice';

  @override
  String get examPackSecondarySubtitle => 'Secondary school practice';

  @override
  String get examPackGcseSubtitle => 'GCSE preparation';

  @override
  String get examPackAdvancedSubtitle => 'Advanced maths practice';

  @override
  String get examPackTutorCreditsTitle => 'Tutor Credits';

  @override
  String get examPackTutorCreditsSubtitle =>
      'Extra hints, explanations and step-by-step support';

  @override
  String get examPackIncluded => 'Included';

  @override
  String get examPackTopUp => 'Top-up';

  @override
  String homeStreakCount(int days) {
    return '$days day streak';
  }

  @override
  String homeMilestone(int days) {
    return '$days-day milestone';
  }

  @override
  String get homeRewardsOn => 'Rewards on';

  @override
  String get homeRewardsOff => 'Rewards off';

  @override
  String get homeBadgeFirstSession => 'First session';

  @override
  String get homeBadgeTenQuestions => '10 questions';

  @override
  String get homeBadgeAlgebraStarter => 'Algebra starter';

  @override
  String get homeContinueKs2Topic => 'Fractions';

  @override
  String get homeContinueKs2Subtopic => 'Equivalent fractions';

  @override
  String get homeContinueKs3Topic => 'Algebra';

  @override
  String get homeContinueKs3Subtopic => 'Solving equations';

  @override
  String get homeContinueKs4Topic => 'GCSE Maths';

  @override
  String get homeContinueKs4Subtopic => 'Quadratics & functions';

  @override
  String get homeContinueKs5Topic => 'Pure Maths';

  @override
  String get homeContinueKs5Subtopic => 'Differentiation';

  @override
  String get quietStudyModeLabel => 'Quiet Study Mode';

  @override
  String get quietStudyModeTooltip =>
      'Inspired by Nyepi, a Balinese tradition of reflection, stillness and focus.';

  @override
  String nextUp(String topic) {
    return 'Next up: $topic';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsParentToolsRewards =>
      'Learning Analytics and rewards animations';

  @override
  String get enableParentTools => 'Learning Analytics 활성화';

  @override
  String get parentToolsLocalOnly => 'Allow local-only Learning Analytics';

  @override
  String get unlockParentTools => 'Unlock Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Create or enter the local 4-digit PIN for Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

  @override
  String get createParentPin => 'Create Parent PIN';

  @override
  String get parentPinStorageNotice =>
      'The 4-digit PIN is stored locally as a SHA-256 hash. No data leaves this device.';

  @override
  String get fourDigitPin => '4-digit PIN';

  @override
  String get openCheatSheet => 'Open Cheat Sheet';

  @override
  String get unlockWithPremium => 'Unlock with Premium';

  @override
  String get rewardsAnimations => 'Rewards animations';

  @override
  String get rewardsAnimationsSubtitle =>
      'Show celebrations after correct answers and milestones';

  @override
  String get premiumLabel => 'Premium';

  @override
  String get rewardsLabel => 'Rewards';

  @override
  String get premiumFeature => 'Premium feature';

  @override
  String get includedInPremium => 'Included in Premium';

  @override
  String get availableInExamPacks => 'Available in exam packs';

  @override
  String get unlockWithSubscription => 'Unlock with subscription';

  @override
  String get enterParentPin => 'Enter Parent PIN';

  @override
  String get resetParentPin => 'Reset Parent PIN';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get resetLabel => 'Reset';

  @override
  String get vaultLoadError => 'The vault could not be loaded.';

  @override
  String get pinMustBeFourDigits => 'Enter exactly 4 digits.';

  @override
  String get pinIncorrect => 'Incorrect PIN.';

  @override
  String get pinResetFailed => 'PIN reset failed.';

  @override
  String get navJourney => 'Journey';

  @override
  String get navMore => 'More';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get journeyTitle => 'Your Journey';

  @override
  String get journeySubtitle =>
      'Streaks, achievements, and milestones in one place.';

  @override
  String get journeyTeaserSubtitle =>
      'See your streak, achievements, and milestones';

  @override
  String get practiceExitSessionTitle => 'Exit session?';

  @override
  String get practiceExitSessionBody =>
      'Your current progress may not be saved.';

  @override
  String get onboardingDiscardTitle => 'Discard your answers?';

  @override
  String get onboardingDiscardBody =>
      'Going back will clear what you\'ve entered on this step.';

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge => 'Adaptive Learning Intelligence 기반';

  @override
  String get onboardingHeroStatement => '수학적 사고를 키우세요.\n잠재력을 펼치세요.';

  @override
  String get onboardingSupportingStatement => '개인화된 학습.\n측정 가능한 성장.';

  @override
  String get onboardingRoleClarification =>
      'For parents, guardians, teachers, tutors and homeschool educators.';

  @override
  String get onboardingCreateAccount => 'Create Account';

  @override
  String get onboardingCreateAccountSub =>
      'Save progress, Maths Journey data and achievements on this device.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Understand progress, identify learning gaps and support the next step.';

  @override
  String get learningAnalyticsEmptyState =>
      'Complete a practice session to begin building Learning Analytics.';

  @override
  String get exploreMathIntelligenceTitle => 'Explore Math Intelligence';

  @override
  String get exploreHeaderSubtitle =>
      'What Math Intelligence offers today, and what\'s coming next.';

  @override
  String get exploreAvailableTodaySection => 'AVAILABLE TODAY';

  @override
  String get exploreInAtelierSection => 'IN ATELIER';

  @override
  String get exploreInAtelierBadge => 'In Atelier';

  @override
  String get exploreInDevelopmentNote =>
      'This feature is currently in development.';

  @override
  String get exploreRoadmapTitle => 'Roadmap Philosophy';

  @override
  String get exploreRoadmapBody =>
      'Math Intelligence is designed to grow over time. Some capabilities are available today. Others are currently being developed and tested before release.';

  @override
  String get explorePersonalisedPracticeTitle => 'Personalised Practice';

  @override
  String get explorePersonalisedPracticeBody =>
      'Adaptive question sessions based on your selected level and learning goals.';

  @override
  String get exploreTopicLearningTitle => 'Topic Learning';

  @override
  String get exploreTopicLearningBody =>
      'Focus on individual mathematical topics.';

  @override
  String get exploreTimedChallengesTitle => 'Timed Challenges';

  @override
  String get exploreTimedChallengesBody => 'Develop speed and confidence.';

  @override
  String get exploreExamSimulatorTitle => 'Exam Simulator';

  @override
  String get exploreExamSimulatorBody =>
      'Practise using structured exam sessions.';

  @override
  String get exploreMathsJourneyTitle => 'My Maths Journey';

  @override
  String get exploreMathsJourneyBody =>
      'Track your learning journey over time.';

  @override
  String get exploreLearningAnalyticsBody =>
      'Monitor progress and identify growth opportunities.';

  @override
  String get exploreFormulaLibraryBody => 'Quick offline reference.';

  @override
  String get explorePhotoUploadTitle => 'Photo Question Upload';

  @override
  String get explorePhotoUploadBody =>
      'Upload worksheets, textbook pages or exam questions.';

  @override
  String get exploreMarkMyPaperTitle => 'Mark My Paper';

  @override
  String get exploreMarkMyPaperBody =>
      'Receive structured feedback on completed work.';

  @override
  String get exploreExaminerIntelligenceTitle => 'Examiner Intelligence';

  @override
  String get exploreExaminerIntelligenceBody =>
      'Learn how examiners award marks and identify common mistakes.';

  @override
  String get exploreAdaptiveStudyPlansTitle => 'Adaptive Study Plans';

  @override
  String get exploreAdaptiveStudyPlansBody =>
      'Personalised study recommendations based on your learning journey.';

  @override
  String get exploreTutorConversationsTitle => 'Tutor Conversations';

  @override
  String get exploreTutorConversationsBody =>
      'Natural-language mathematical coaching.';

  @override
  String get journeyCardTitleDefault => 'My Maths Journey';

  @override
  String journeyCardTitleNamed(String name) {
    return '$name\'s Maths Journey';
  }

  @override
  String get journeyCardCurrentFocusLabel => 'Current focus';

  @override
  String get journeyCardGettingStarted => 'Getting started';

  @override
  String get journeyCardCurrentStreakLabel => 'Current streak';

  @override
  String get journeyCardStartStreakToday => 'Start your streak today';

  @override
  String journeyCardStreakDays(int days) {
    return '$days-day streak';
  }

  @override
  String get journeyCardNextMilestoneLabel => 'Next milestone';

  @override
  String journeyCardDaysToMilestoneOne(int milestone) {
    return '1 day to your $milestone-day streak';
  }

  @override
  String journeyCardDaysToMilestoneMany(int days, int milestone) {
    return '$days days to your $milestone-day streak';
  }

  @override
  String get journeyCardAllMilestonesReached =>
      'You\'ve reached every streak milestone!';

  @override
  String get journeyCardGoalConfidence => 'You are building confidence';

  @override
  String get journeyCardGoalSchool => 'You are improving school maths';

  @override
  String get journeyCardGoalExams => 'You are preparing for exams';

  @override
  String get journeyCardGoalChallenge => 'You are tackling challenge problems';

  @override
  String get journeyCardGoalParentGaps => 'You are finding learning gaps';

  @override
  String get journeyCardGoalParentProgress =>
      'You are tracking progress over time';

  @override
  String get journeyCardGoalParentGcse => 'You are preparing for GCSE';

  @override
  String get journeyCardGoalTeacherMonitor =>
      'You are monitoring class progress';

  @override
  String get journeyCardGoalTeacherAssign => 'You are assigning practice';

  @override
  String get journeyCardGoalTeacherExplore =>
      'You are exploring the curriculum';

  @override
  String get mathStudioNavCardTitle => 'Math Studio';

  @override
  String get mathStudioNavCardSubtitle => 'Discover the maths you already use';

  @override
  String get mathStudioHubTitle => 'Math Studio';

  @override
  String get mathStudioHubTagline =>
      'Discover the mathematics you\'ve been using all your life.';

  @override
  String get mathStudioBuildConfidenceTitle => 'Build Confidence';

  @override
  String get mathStudioBuildConfidenceSubtitle =>
      'Gentle, untimed practice with worked explanations';

  @override
  String get mathStudioMentalMathsTitle => 'Mental Maths';

  @override
  String get mathStudioMentalMathsSubtitle =>
      'Daily number strategies, no pressure';

  @override
  String get mathStudioVisualMathsTitle => 'Visual Maths';

  @override
  String get mathStudioVisualMathsSubtitle =>
      'See maths through models you can move';

  @override
  String get mathStudioDiscoveryTitle => 'Discovery Library';

  @override
  String get mathStudioDiscoverySubtitle =>
      'Real-world maths, one card at a time';

  @override
  String get mathStudioMathMagicTitle => 'Math & Magic';

  @override
  String get mathStudioMathMagicSubtitle =>
      'Puzzles, patterns and playful mathematical surprises';

  @override
  String get mathStudioMathMagicBody =>
      'Recreational puzzles, number tricks and mathematical curiosities';

  @override
  String get mathStudioSpatialIntelligenceTitle => 'Spatial Intelligence';

  @override
  String get mathStudioSpatialIntelligenceSubtitle =>
      'Build your sense of shape, space and movement';

  @override
  String get mathStudioSpatialIntelligenceBody =>
      'Cube nets, rotations, transformations and spatial puzzles';

  @override
  String get mathStudioInDevelopmentBadge => 'In development';

  @override
  String get mathStudioInDevelopmentNote =>
      'This area is still being built — check back soon for new content.';

  @override
  String get mathStudioSpatialCubeActivitiesLabel => 'Cube activities';

  @override
  String get mathStudioSpatialRotationsLabel => 'Rotations';

  @override
  String get mathStudioSpatialTransformationsLabel => 'Transformations';

  @override
  String get mathStudioSpatialPuzzlesLabel => 'Spatial puzzles';

  @override
  String get mathStudioFeaturedFormatsSectionLabel => 'Featured formats';

  @override
  String get mathStudioRelatedLabsSectionLabel => 'Related labs';

  @override
  String get mathStudioSpatialLabsEntrySubtitle =>
      'Try Flight Path Lab and other hands-on tools that build spatial reasoning';

  @override
  String get mathStudioCategoryEverydayLife => 'Everyday Life';

  @override
  String get mathStudioCategoryShopping => 'Shopping';

  @override
  String get mathStudioCategoryCooking => 'Cooking';

  @override
  String get mathStudioCategorySports => 'Sports';

  @override
  String get mathStudioCategoryAviation => 'Aviation';

  @override
  String get mathStudioCategoryTruckingLogistics => 'Trucking & Logistics';

  @override
  String get mathStudioCategoryHealthcare => 'Healthcare';

  @override
  String get mathStudioCategoryEngineeringConstruction =>
      'Engineering & Construction';

  @override
  String get mathStudioCategoryArtDesign => 'Art & Design';

  @override
  String get mathStudioCategoryGaming => 'Gaming';

  @override
  String get mathStudioCategoryBusinessFinance => 'Business & Finance';

  @override
  String get mathStudioCategoryAll => 'All';

  @override
  String get mathStudioDifficultyFoundation => 'Foundation';

  @override
  String get mathStudioDifficultyIntermediate => 'Intermediate';

  @override
  String get mathStudioDifficultyAdvanced => 'Advanced';

  @override
  String get mathStudioThinkLabel => 'Think it through';

  @override
  String get mathStudioRevealButton => 'Reveal the solution';

  @override
  String get mathStudioRevealedLabel => 'Worked solution';

  @override
  String get mathStudioWhereYoullUseThisLabel => 'Where you\'ll use this';

  @override
  String get mathStudioFollowUpLabel => 'Try one yourself';

  @override
  String get mathStudioFollowUpCheckButton => 'Check my answer';

  @override
  String get mathStudioFollowUpCorrect => 'Nice work — that\'s right.';

  @override
  String get mathStudioFollowUpTryAgain =>
      'Not quite — take another look at the steps above.';

  @override
  String get mathStudioFollowUpAnswerLabel => 'Answer';

  @override
  String get mathStudioExportButton => 'Print or share';

  @override
  String get mathStudioExportChallengeOnly => 'Challenge sheet';

  @override
  String get mathStudioExportSolutionOnly => 'Worked solution sheet';

  @override
  String get mathStudioExportCombined => 'Challenge + solution';

  @override
  String get mathStudioExportIncludeNameLabel =>
      'Include my name on this export';

  @override
  String get mathStudioExportShareAction => 'Share';

  @override
  String get captainMathCurious => 'There\'s a discovery here — take a look.';

  @override
  String get captainMathEncouraging => 'Nice thinking — keep going.';

  @override
  String get captainMathCalm => 'Notice how this connects to something else.';

  @override
  String get captainMathCelebrating => 'Well done!';

  @override
  String get mentalMathsCategoryNumberBonds => 'Number Bonds';

  @override
  String get mentalMathsCategoryDecomposition => 'Decomposition';

  @override
  String get mentalMathsCategoryCompensation => 'Compensation';

  @override
  String get mentalMathsCategoryEstimation => 'Estimation';

  @override
  String get mentalMathsCategoryMultiplicationStrategies =>
      'Multiplication Strategies';

  @override
  String get mentalMathsCategoryDivisionStrategies => 'Division Strategies';

  @override
  String get mentalMathsCategoryPercentages => 'Percentages';

  @override
  String get mentalMathsCategoryFractions => 'Fractions';

  @override
  String get mentalMathsCategoryPlaceValue => 'Place Value';

  @override
  String get mentalMathsCategoryPatternRecognition => 'Pattern Recognition';

  @override
  String get mentalMathsTodaysChallenge => 'Today\'s Challenge';

  @override
  String get mentalMathsUntimedNote => 'No timer — take the time you need.';

  @override
  String buildConfidenceProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get buildConfidenceContinueButton => 'Continue';

  @override
  String get buildConfidenceCompletionTitle => 'Nicely done';

  @override
  String get buildConfidenceCompletionBody =>
      'You worked through today\'s session at your own pace. Come back whenever you\'re ready for another.';

  @override
  String get buildConfidenceDoneButton => 'Done';

  @override
  String get visualMathsNumberLineTitle => 'Number Line';

  @override
  String get visualMathsNumberLineSubtitle =>
      'Drag the point to explore numbers on a line';

  @override
  String get visualMathsFractionBarsTitle => 'Fraction Bars';

  @override
  String get visualMathsFractionBarsSubtitle =>
      'Compare fractions as bars, side by side';

  @override
  String get visualMathsAbacusTitle => 'Animated Abacus';

  @override
  String get visualMathsAbacusSubtitle =>
      'See place value in action, bead by bead';

  @override
  String get visualMathsPlaceValueTitle => 'Place Value Explorer';

  @override
  String get visualMathsPlaceValueSubtitle =>
      'Break numbers apart by their place value';

  @override
  String get visualMathsInteractiveBadge => 'Interactive';

  @override
  String get visualMathsPreviewBadge => 'Preview';

  @override
  String get visualMathsComingSoonNote =>
      'Interactive version coming in a future release.';

  @override
  String get visualMathsTryAnotherExample => 'Try another example';

  @override
  String get numberLineExampleBasicWholeNumber =>
      'A whole number on a 0 to 10 line';

  @override
  String get numberLineExampleNegativeNumber =>
      'A negative number on a −10 to 10 line';

  @override
  String get numberLineExampleSimpleFraction => 'A fraction on a 0 to 1 line';

  @override
  String get numberLineExampleDecimal => 'A decimal on a 0 to 5 line';

  @override
  String get fractionBarsCaption1 => '1/2 is exactly half of the whole bar.';

  @override
  String get fractionBarsCaption2 =>
      '2/4 covers the same length as 1/2 — equivalent fractions.';

  @override
  String get fractionBarsCaption3 =>
      '3/4 is more than half, less than the whole.';

  @override
  String get fractionBarsCaption4 => '5/8 is just over half of the whole bar.';

  @override
  String get abacusCaption1 =>
      'One bead moved in the ones column represents 1.';

  @override
  String get abacusCaption2 =>
      'Ten ones regroup into a single bead in the tens column.';

  @override
  String get abacusCaption3 =>
      'A bead in the hundreds column is worth 100 ones.';

  @override
  String get placeValueCaption1 =>
      '3,742 breaks into 3 thousands, 7 hundreds, 4 tens, 2 ones.';

  @override
  String get placeValueCaption2 => '6.4 breaks into 6 ones and 4 tenths.';

  @override
  String get placeValueCaption3 =>
      '805 breaks into 8 hundreds, 0 tens, 5 ones — the 0 holds the tens place.';

  @override
  String get abacusColumnHundreds => 'Hundreds';

  @override
  String get abacusColumnTens => 'Tens';

  @override
  String get abacusColumnOnes => 'Ones';

  @override
  String get mathStudioRecallCardsTitle => 'Recall Cards';

  @override
  String get mathStudioRecallCardsSubtitle =>
      'Quick retrieval practice for the facts you need to keep';

  @override
  String get recallCardsHubTitle => 'Recall Cards';

  @override
  String get recallCardsHubSubtitle =>
      'Short, focused practice for formulas, vocabulary, symbols and the ideas behind them';

  @override
  String get recallCardsQuickReviewTitle => 'Five-Card Quick Review';

  @override
  String get recallCardsQuickReviewSubtitle =>
      'A short daily set, chosen for you';

  @override
  String get recallCardsReviewDueTitle => 'Review Due';

  @override
  String recallCardsReviewDueCount(int count) {
    return '$count due for review';
  }

  @override
  String get recallCardsReviewDueEmpty => 'Nothing due right now — nice work';

  @override
  String get recallCardsBrowseByTopicTitle => 'Browse by Topic';

  @override
  String get recallCardsBrowseByTypeTitle => 'Browse by Card Type';

  @override
  String get recallCardsSearchTitle => 'Search';

  @override
  String get recallCardsSearchHint => 'Search formulas, terms and ideas';

  @override
  String get recallCardsBookmarksTitle => 'Bookmarks';

  @override
  String get recallCardsEmptyBookmarks =>
      'No bookmarks yet — tap the bookmark icon on any card to save it here';

  @override
  String get recallCardsNoResults => 'No cards found';

  @override
  String get recallCardsRevealButton => 'Reveal the answer';

  @override
  String get recallCardsRevealedLabel => 'Answer';

  @override
  String get recallCardsExplainLabel => 'Why this works';

  @override
  String get recallCardsCommonMistakeLabel => 'Common mistake';

  @override
  String get recallCardsConnectLabel => 'Where this is used';

  @override
  String get recallCardsRelatedDiscoveryLabel => 'Related Discovery Cards';

  @override
  String get recallCardsRelatedPracticeLabel => 'Related Practice';

  @override
  String get recallCardsRelatedLabsLabel => 'Related Interactive Labs';

  @override
  String get recallCardsLabComingSoon => 'Coming soon';

  @override
  String get recallCardsRememberedButton => 'I remembered this';

  @override
  String get recallCardsNotYetButton => 'Not yet';

  @override
  String get recallCardsAskMeTomorrowButton => 'Ask Me Tomorrow';

  @override
  String get recallCardsBookmarkAdd => 'Bookmark this card';

  @override
  String get recallCardsBookmarkRemove => 'Remove bookmark';

  @override
  String get recallCardsExportButton => 'Print or share';

  @override
  String get recallCardsExportFiveCardSheet => 'Recall sheet (questions only)';

  @override
  String get recallCardsExportAnswerSheet => 'Answer sheet';

  @override
  String get recallCardsSessionComplete => 'Session complete';

  @override
  String get recallCardsSessionCompleteSubtitle =>
      'Great work — come back tomorrow for more';

  @override
  String recallCardsCardOf(int current, int total) {
    return 'Card $current of $total';
  }

  @override
  String get recallCardsStateNew => 'New';

  @override
  String get recallCardsStateLearning => 'Learning';

  @override
  String get recallCardsStateReviewDue => 'Review due';

  @override
  String get recallCardsStateMastered => 'Mastered';

  @override
  String get recallCardsTypeFormula => 'Formula';

  @override
  String get recallCardsTypeMeaning => 'Meaning';

  @override
  String get recallCardsTypeSymbol => 'Symbol';

  @override
  String get recallCardsTypeVocabulary => 'Vocabulary';

  @override
  String get recallCardsTypeStrategy => 'Strategy';

  @override
  String get recallCardsTypeMisconception => 'Common Misconception';

  @override
  String get recallCardsTypeVisual => 'Visual';

  @override
  String get recallCardsTypeRealWorldConnection => 'Real-World Connection';

  @override
  String get recallCardsTopicNumber => 'Number';

  @override
  String get recallCardsTopicRatioAndProportion => 'Ratio & Proportion';

  @override
  String get recallCardsTopicAlgebra => 'Algebra';

  @override
  String get recallCardsTopicGeometryAndMeasures => 'Geometry & Measures';

  @override
  String get recallCardsTopicStatistics => 'Statistics';

  @override
  String get recallCardsTopicProbability => 'Probability';

  @override
  String get mathStudioInteractiveLabsTitle => 'Interactive Labs';

  @override
  String get mathStudioInteractiveLabsSubtitle =>
      'Hands-on maths you can touch, change and test';

  @override
  String get labsHubTitle => 'Interactive Labs';

  @override
  String get labsHubSubtitle =>
      'See a concept, touch it, change it, and test your prediction';

  @override
  String get labsResetButton => 'Reset';

  @override
  String get labsCheckButton => 'Check';

  @override
  String get labsNextChallengeButton => 'Next';

  @override
  String get labsFeedbackCorrect => 'Nice work — that\'s right.';

  @override
  String get labsFeedbackTryAgain => 'Not quite — have another go.';

  @override
  String get labsRelatedRecallCardsLabel => 'Related Recall Cards';

  @override
  String get labsFractionBuilderTitle => 'Fraction Builder';

  @override
  String get labsFractionBuilderSubtitle =>
      'Build a fraction by filling equal parts';

  @override
  String get labsFractionBuilderConcept =>
      'A fraction is a count of equal parts out of a whole. Tap segments to fill them and match the target fraction.';

  @override
  String get labsFractionBuilderWhereUsed =>
      'Sharing food fairly, reading recipes, and measuring ingredients all rely on fractions of a whole.';

  @override
  String labsFractionBuilderPrompt(int numerator, int denominator) {
    return 'Fill in $numerator out of $denominator segments.';
  }

  @override
  String labsFractionBuilderFilledCount(int filled, int denominator) {
    return '$filled of $denominator filled';
  }

  @override
  String get labsAlgebraBalanceTitle => 'Algebra Balance';

  @override
  String get labsAlgebraBalanceSubtitle =>
      'Keep both sides equal to solve for x';

  @override
  String get labsAlgebraBalanceConcept =>
      'An equation stays true only if you do the same thing to both sides. Simplify step by step until x stands alone.';

  @override
  String get labsAlgebraBalanceWhereUsed =>
      'Working backwards from a total to find an unknown amount uses exactly this balancing idea.';

  @override
  String labsAlgebraBalanceEquationLabel(String equation) {
    return 'Equation: $equation';
  }

  @override
  String get labsAlgebraBalanceStep1Button => 'Remove the constant';

  @override
  String get labsAlgebraBalanceStep2Button => 'Divide to isolate x';

  @override
  String labsAlgebraBalanceSolvedFeedback(int x) {
    return 'Solved! x = $x';
  }

  @override
  String get labsNumberLineExplorerTitle => 'Number Line Explorer';

  @override
  String get labsNumberLineExplorerSubtitle =>
      'Drag to match a value on the line';

  @override
  String get labsNumberLineExplorerConcept =>
      'A number\'s position on a number line matches its value — including negative numbers and decimals.';

  @override
  String get labsNumberLineExplorerWhereUsed =>
      'Reading thermometers, timelines and measuring scales all rely on position matching value.';

  @override
  String labsNumberLineExplorerPrompt(String target) {
    return 'Drag the point to $target.';
  }

  @override
  String get labsFlightPathLabTitle => 'Flight Path Lab';

  @override
  String get labsFlightPathLabSubtitle =>
      'Set a heading and speed to reach the target';

  @override
  String get labsFlightPathLabConcept =>
      'A heading (bearing) and speed, held for a fixed time, fix exactly where you end up — this combines bearings with speed, distance and time.';

  @override
  String get labsFlightPathLabWhereUsed =>
      'Pilots and sailors use bearing and speed together to navigate to a destination.';

  @override
  String labsFlightPathLabPrompt(int bearing, int distance) {
    return 'Target: bearing $bearing°, $distance km away. Flight time is fixed at 2 hours — choose a heading and speed to reach it.';
  }

  @override
  String get labsFlightPathLabRadarLabel =>
      'A radar view showing the target and, after a test flight, where the aircraft landed.';

  @override
  String labsFlightPathLabSpeedLabel(int speed) {
    return 'Speed: $speed km/h';
  }

  @override
  String get labsFlightPathLabTestButton => 'Test Flight';

  @override
  String get labsFlightPathLabResultSpotOn => 'Spot on!';

  @override
  String get labsFlightPathLabResultClose => 'Close — try a small adjustment.';

  @override
  String get labsFlightPathLabResultTryAgain =>
      'Try adjusting the heading or speed.';

  @override
  String labsFlightPathLabResultDistance(int distance) {
    return 'You landed $distance km from the target.';
  }

  @override
  String get labsDataDetectiveTitle => 'Data Detective';

  @override
  String get labsDataDetectiveSubtitle =>
      'See how one outlier changes an average';

  @override
  String get labsDataDetectiveConcept =>
      'The mean is pulled toward an outlier much more than the median is. Remove values and watch each average update live.';

  @override
  String get labsDataDetectiveWhereUsed =>
      'Reporting a \'typical\' salary, price or score fairly means knowing when the mean is misleading and the median is a better summary.';

  @override
  String get labsDataDetectiveAddValueButton => 'Add a typical value';

  @override
  String get labsDataDetectivePredictionPrompt =>
      'Which will change more once the outlier is removed?';

  @override
  String get labsDataDetectivePredictMeanButton => 'Mean';

  @override
  String get labsDataDetectivePredictMedianButton => 'Median';

  @override
  String get labsDataDetectiveRevealButton => 'Remove outlier & reveal';

  @override
  String get labsDataDetectiveCorrectPrediction => 'Correct prediction!';

  @override
  String get labsDataDetectiveIncorrectPrediction =>
      'Not quite — look at the shift below.';

  @override
  String labsDataDetectiveShiftSummary(String meanShift, String medianShift) {
    return 'Mean moved by $meanShift, median moved by $medianShift.';
  }

  @override
  String get labsDataDetectiveMeanLabel => 'Mean';

  @override
  String get labsDataDetectiveMedianLabel => 'Median';

  @override
  String get labsDataDetectiveRangeLabel => 'Range';

  @override
  String get labsTryAgainButton => 'Try again';

  @override
  String get labsHelpButton => 'Help';

  @override
  String get labsNarrationReplayButton => 'Replay';

  @override
  String get labsNarrationSectionLabel => 'CAPTAIN MATH NARRATION';

  @override
  String get labsNarrationOnOffLabel => 'Narration';

  @override
  String get labsNarrationTextOnlyLabel => 'Text only (no spoken audio)';

  @override
  String get labsNarrationSpeedLabel => 'Speed';

  @override
  String get labsNarrationSpeedSlower => 'Slower';

  @override
  String get labsNarrationSpeedNormal => 'Normal';

  @override
  String get labsNarrationSpeedFaster => 'Faster';

  @override
  String get labsHelpTitle => 'Help';

  @override
  String get labsHelpWhatToDo => 'What to do';

  @override
  String get labsHelpWhatToNotice => 'What to notice';

  @override
  String get labsHelpWhatItMeans => 'What the maths means';

  @override
  String get labsHelpWhereUsed => 'Where this is used';

  @override
  String get labsFirstUseTitle => 'Before you start';

  @override
  String get labsFirstUseGotItButton => 'Got it';

  @override
  String get labsGuidanceLevelLabel => 'Guidance level';

  @override
  String get labsGuidanceExplorer => 'Explorer';

  @override
  String get labsGuidanceBuilder => 'Builder';

  @override
  String get labsGuidanceNavigator => 'Navigator';

  @override
  String get labsDirectionAway => 'Away from you';

  @override
  String get labsDirectionRight => 'Right';

  @override
  String get labsDirectionToward => 'Toward you';

  @override
  String get labsDirectionLeft => 'Left';

  @override
  String get labsFlightPathLabMission =>
      'Point the plane toward the yellow target, then press Test Flight to see where it lands.';

  @override
  String labsFlightPathLabHeadingLabel(String direction, int degrees) {
    return 'Direction: $direction  •  Heading: $degrees°';
  }

  @override
  String labsFlightPathLabHeadingNavigatorLabel(String bearing) {
    return 'Heading: $bearing';
  }

  @override
  String get labsFlightPathLabHeadingHelper =>
      'Turn this to choose which way the plane points';

  @override
  String get labsFlightPathLabSpeedHelper =>
      'Choose how far the plane should travel';

  @override
  String labsFlightPathLabTargetExplanation(int distance, String bearing) {
    return 'The yellow marker is your target. It is $distance km away, on a bearing of $bearing.';
  }

  @override
  String get labsFlightPathLabPredictionPrompt =>
      'Before you test: will you land short, on target, or overshoot?';

  @override
  String get labsFlightPathLabPredictShort => 'Short';

  @override
  String get labsFlightPathLabPredictOnTarget => 'On target';

  @override
  String get labsFlightPathLabPredictOver => 'Overshoot';

  @override
  String get labsFlightPathLabHelpWhatToDo =>
      'Set the heading and speed, make a prediction if asked, then press Test Flight.';

  @override
  String get labsFlightPathLabHelpWhatToNotice =>
      'Notice how far from the target the plane lands, and which way you need to adjust.';

  @override
  String get labsFlightPathLabHelpWhatItMeans =>
      'A steady heading and speed, held for a fixed time, always lead to exactly one landing point — that\'s speed, distance and time combined with direction.';

  @override
  String get labsFlightPathLabFirstUseStep1 =>
      'Point the plane toward the yellow target.';

  @override
  String get labsFlightPathLabFirstUseStep2 =>
      'Choose how far the plane should travel.';

  @override
  String get labsFlightPathLabFirstUseStep3 =>
      'Press Test Flight to see where it lands.';

  @override
  String get labsDataDetectiveMission =>
      'Predict what happens to the mean and median, then remove the unusual value to find out.';

  @override
  String labsDataDetectiveOutlierExplanation(int outlier) {
    return 'One value, $outlier, stands out from the rest — it\'s much higher or lower than the others. That\'s called an outlier.';
  }

  @override
  String labsDataDetectiveBeforeAfter(String meanBefore, String meanAfter,
      String medianBefore, String medianAfter) {
    return 'Mean: $meanBefore → $meanAfter. Median: $medianBefore → $medianAfter.';
  }

  @override
  String get labsDataDetectiveHelpWhatToDo =>
      'Look at the values, predict whether the mean or median will change more, then remove the outlier to reveal the answer.';

  @override
  String get labsDataDetectiveHelpWhatToNotice =>
      'Notice how much the mean moves compared to the median once the outlier is gone.';

  @override
  String get labsDataDetectiveHelpWhatItMeans =>
      'The mean uses every value, so one extreme value can pull it a long way. The median only depends on the middle position, so it barely moves.';

  @override
  String get labsDataDetectiveFirstUseStep1 =>
      'Look at the list of values — one of them stands out.';

  @override
  String get labsDataDetectiveFirstUseStep2 =>
      'Predict which will change more: the mean or the median.';

  @override
  String get labsDataDetectiveFirstUseStep3 =>
      'Remove the outlier and reveal the answer.';

  @override
  String get labsAlgebraBalanceMission =>
      'Keep both sides balanced until x is on its own.';

  @override
  String labsAlgebraBalanceStep1RemoveButton(int value) {
    return 'Remove $value from both sides';
  }

  @override
  String labsAlgebraBalanceStep1AddButton(int value) {
    return 'Add $value to both sides';
  }

  @override
  String labsAlgebraBalanceStep2DivideButton(int value) {
    return 'Divide both sides by $value';
  }

  @override
  String get labsAlgebraBalanceHelpWhatToDo =>
      'Clear the number term first, then divide to leave x on its own.';

  @override
  String get labsAlgebraBalanceHelpWhatToNotice =>
      'Notice that both pans always change together, by the same amount — the equation never stops being true.';

  @override
  String get labsAlgebraBalanceHelpWhatItMeans =>
      'Doing the same operation to both sides of an equation keeps it balanced, which is how you can safely simplify down to just x.';

  @override
  String get labsAlgebraBalanceFirstUseStep1 =>
      'Look at the equation and the balance below it.';

  @override
  String get labsAlgebraBalanceFirstUseStep2 =>
      'Use the buttons to simplify both sides together.';

  @override
  String get labsAlgebraBalanceFirstUseStep3 =>
      'Keep going until x stands alone.';

  @override
  String labsFractionBuilderMission(int numerator, int denominator) {
    return 'Fill in $numerator out of $denominator equal parts.';
  }

  @override
  String get labsFractionBuilderTapGuidance =>
      'Tap a segment to fill it in, or tap again to empty it.';

  @override
  String labsFractionBuilderSymbolicResult(int numerator, int denominator) {
    return '$numerator/$denominator — $numerator equal part(s) filled out of $denominator.';
  }

  @override
  String get labsFractionBuilderHelpWhatToDo =>
      'Tap segments until the number filled matches the fraction, then press Check.';

  @override
  String get labsFractionBuilderHelpWhatToNotice =>
      'Notice that the denominator is the total number of equal parts, and the numerator is how many are filled.';

  @override
  String get labsFractionBuilderHelpWhatItMeans =>
      'A fraction counts equal parts of a whole — the same idea whether it\'s a bar, a pizza, or a measuring cup.';

  @override
  String get labsFractionBuilderFirstUseStep1 =>
      'Look at how many parts to fill in.';

  @override
  String get labsFractionBuilderFirstUseStep2 =>
      'Tap segments to fill them in.';

  @override
  String get labsFractionBuilderFirstUseStep3 =>
      'Press Check to see if you matched the fraction.';

  @override
  String labsNumberLineExplorerMission(String target) {
    return 'Move the point to $target.';
  }

  @override
  String labsNumberLineExplorerStartInstruction(String min) {
    return 'Start at $min and move the point to the target.';
  }

  @override
  String labsNumberLineExplorerMoveRight(String distance) {
    return 'Move $distance more to the right';
  }

  @override
  String labsNumberLineExplorerMoveLeft(String distance) {
    return 'Move $distance more to the left';
  }

  @override
  String get labsNumberLineExplorerIncreaseButton => 'Move right';

  @override
  String get labsNumberLineExplorerDecreaseButton => 'Move left';

  @override
  String get labsNumberLineExplorerHelpWhatToDo =>
      'Drag the point, or use the arrow buttons, to reach the target value, then press Check.';

  @override
  String get labsNumberLineExplorerHelpWhatToNotice =>
      'Notice how the point\'s position matches its value — further right is a bigger number, further left is smaller.';

  @override
  String get labsNumberLineExplorerHelpWhatItMeans =>
      'A number line shows every number in order, in both directions from zero, including negative numbers and decimals.';

  @override
  String get labsNumberLineExplorerFirstUseStep1 =>
      'See where the point starts.';

  @override
  String get labsNumberLineExplorerFirstUseStep2 =>
      'Drag the point, or use the arrow buttons, toward the target.';

  @override
  String get labsNumberLineExplorerFirstUseStep3 =>
      'Press Check to see if you reached it.';

  @override
  String labsMissionOf(int current, int total) {
    return 'Mission $current of $total';
  }

  @override
  String get labsDirectionUp => 'Up';

  @override
  String get labsDirectionUpRight => 'Up-right';

  @override
  String get labsDirectionDownRight => 'Down-right';

  @override
  String get labsDirectionDown => 'Down';

  @override
  String get labsDirectionDownLeft => 'Down-left';

  @override
  String get labsDirectionUpLeft => 'Up-left';

  @override
  String get labsCompassNorth => 'North';

  @override
  String get labsCompassNortheast => 'Northeast';

  @override
  String get labsCompassEast => 'East';

  @override
  String get labsCompassSoutheast => 'Southeast';

  @override
  String get labsCompassSouth => 'South';

  @override
  String get labsCompassSouthwest => 'Southwest';

  @override
  String get labsCompassWest => 'West';

  @override
  String get labsCompassNorthwest => 'Northwest';

  @override
  String labsFlightPathLabHeadingExplorerLabel(String direction, int degrees) {
    return 'Direction: $direction ($degrees°)';
  }

  @override
  String labsFlightPathLabHeadingCompassLabel(String compass, String bearing) {
    return '$compass • Heading: $bearing';
  }

  @override
  String get labsFlightPathLabTapTargetHint =>
      'Tip: tap the target to aim automatically';

  @override
  String get labsFlightPathLabDragCue => 'Drag the plane to turn it';

  @override
  String get labsFlightPathLabNarrationIntroExplorer =>
      'Point the plane at the yellow target, then press Test Flight to see where it lands.';

  @override
  String get labsFlightPathLabNarrationIntroBuilder =>
      'Set a heading and speed, predict where you\'ll land, then test your prediction.';

  @override
  String get labsFlightPathLabNarrationIntroNavigator =>
      'Choose a bearing and speed; the resulting displacement is bearing and speed-time combined into one vector.';

  @override
  String get labsFlightPathLabNarrationResultNearMissExplorer =>
      'So close! Try a slightly different speed or direction and test again.';

  @override
  String get labsFlightPathLabNarrationResultNearMissBuilder =>
      'You landed close to the target. Check whether you\'re slightly early or late, and adjust speed or heading a little.';

  @override
  String get labsFlightPathLabNarrationResultNearMissNavigator =>
      'The resultant displacement is close to the target vector but not exact — refine heading and/or speed and re-test.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer =>
      'Good direction! But the plane flew too far. Try a slower speed.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder =>
      'The heading is right, but you travelled further than the target distance. Keep the direction and lower the speed.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator =>
      'Bearing matches the target vector; the magnitude (speed × time) overshoots it — reduce speed to shorten the displacement.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortExplorer =>
      'Good direction! But the plane didn\'t fly far enough. Try a faster speed.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder =>
      'The heading is right, but you didn\'t travel far enough. Keep the direction and raise the speed.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortNavigator =>
      'Bearing matches the target vector; the magnitude falls short — increase speed to extend the displacement.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceExplorer =>
      'The distance is right, but the plane is pointing the wrong way. Turn it toward the yellow target.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder =>
      'You flew the right distance, but the wrong direction. Adjust the heading toward the target bearing and keep the speed.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceNavigator =>
      'The magnitude is correct but the bearing is off — rotate the heading toward the target bearing without changing speed.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceExplorer =>
      'The plane is pointing the wrong way and went the wrong distance. Aim at the target, then choose a speed.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder =>
      'Both the direction and the distance need adjusting. Re-aim toward the target bearing, then set a speed for the right distance.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceNavigator =>
      'Both bearing and magnitude are off the target vector — correct the heading first, then adjust speed for the required distance.';

  @override
  String get labsFlightPathLabNarrationCompletionExplorer =>
      'Excellent! You aimed the plane and picked the right speed to land exactly on target.';

  @override
  String get labsFlightPathLabNarrationCompletionBuilder =>
      'Excellent! Matching heading and speed to a target is exactly how real flight plans are built.';

  @override
  String get labsFlightPathLabNarrationCompletionNavigator =>
      'Exact match: the displacement vector (bearing and magnitude) equals the target vector — this is how flight planning and navigation calculations work in practice.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedExplorer =>
      'That\'s the same try as last time. Change the direction or speed before testing again.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedBuilder =>
      'You tested the exact same heading and speed again. Try changing one of them before the next test.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedNavigator =>
      'Heading and speed are unchanged from the previous attempt — vary at least one variable to gather new information.';

  @override
  String get labsFlightPathLabNarrationHintInactivityExplorer =>
      'Still there? Drag the plane or move the speed slider to keep going.';

  @override
  String get labsFlightPathLabNarrationHintInactivityBuilder =>
      'Take your time — drag the plane to aim it, or adjust the speed, whenever you\'re ready.';

  @override
  String get labsFlightPathLabNarrationHintInactivityNavigator =>
      'No input recorded recently — adjust heading or speed to continue refining the solution.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongExplorer =>
      'Not quite — look at whether you need to move left or right, then try again.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongBuilder =>
      'Compare your value to the target: move toward it by the difference, then check again.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongNavigator =>
      'The value differs from the target by more than one step — adjust by the required increment and retest.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseExplorer =>
      'So close! Just one small step away — try nudging it once more.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseBuilder =>
      'You\'re one step away from the target. Adjust by a single increment and check again.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseNavigator =>
      'The value is within one increment of the target — a single adjustment should resolve it.';

  @override
  String get labsNumberLineExplorerNarrationCompletionExplorer =>
      'Exactly right! You found the target\'s exact position on the line.';

  @override
  String get labsNumberLineExplorerNarrationCompletionBuilder =>
      'Exactly right! Matching a value to its position is how number lines represent size and order.';

  @override
  String get labsNumberLineExplorerNarrationCompletionNavigator =>
      'Exact match: the value\'s position on the line corresponds precisely to its numeric value, including sign and magnitude.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedExplorer =>
      'That\'s the same spot as last time — move it before checking again.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedBuilder =>
      'You checked the same value again. Move it by at least one step before the next check.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedNavigator =>
      'The value is unchanged from the previous check — adjust before retesting.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityExplorer =>
      'Still there? Drag the marker or use the +/- buttons.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityBuilder =>
      'Take your time — drag the marker or use the +/- buttons whenever you\'re ready.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityNavigator =>
      'No input recorded recently — adjust the value to continue.';

  @override
  String get labsFractionBuilderNarrationResultWrongExplorer =>
      'Not quite the right number of parts — count the filled segments and compare to the target.';

  @override
  String get labsFractionBuilderNarrationResultWrongBuilder =>
      'Compare the filled segments to the numerator, then add or remove one to match.';

  @override
  String get labsFractionBuilderNarrationResultWrongNavigator =>
      'The filled-segment count must equal the numerator exactly — adjust by the difference.';

  @override
  String get labsFractionBuilderNarrationCompletionExplorer =>
      'That\'s it! You filled exactly the right number of parts.';

  @override
  String get labsFractionBuilderNarrationCompletionBuilder =>
      'That\'s it! Counting filled parts against a numerator is exactly what a fraction represents.';

  @override
  String get labsFractionBuilderNarrationCompletionNavigator =>
      'Exact match: filled segments equal the numerator over the shown denominator, matching the fraction\'s defining ratio.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedExplorer =>
      'Same count as last time — change it before checking again.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedBuilder =>
      'You checked the same filled count again. Change it before the next check.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedNavigator =>
      'The filled count is unchanged from the previous check — adjust before retesting.';

  @override
  String get labsFractionBuilderNarrationHintInactivityExplorer =>
      'Still there? Tap a segment to fill or unfill it.';

  @override
  String get labsFractionBuilderNarrationHintInactivityBuilder =>
      'Take your time — tap segments to adjust the count whenever you\'re ready.';

  @override
  String get labsFractionBuilderNarrationHintInactivityNavigator =>
      'No input recorded recently — tap a segment to continue.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepExplorer =>
      'Remove the number first, then divide to find x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepBuilder =>
      'First remove the constant from both sides, then divide both sides by the coefficient of x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepNavigator =>
      'Apply the inverse additive operation first, then the inverse multiplicative operation, to isolate x.';

  @override
  String get labsAlgebraBalanceNarrationCompletionExplorer =>
      'Solved! You found the value of x.';

  @override
  String get labsAlgebraBalanceNarrationCompletionBuilder =>
      'Solved! Every equation of this form is solved by removing the constant, then dividing.';

  @override
  String get labsAlgebraBalanceNarrationCompletionNavigator =>
      'Solved: x is isolated by inverse operations applied to both sides, preserving equality throughout.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityExplorer =>
      'Still there? Try the first button to remove the number.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityBuilder =>
      'Take your time — remove the constant, then divide, whenever you\'re ready.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityNavigator =>
      'No input recorded recently — apply the next inverse operation to continue.';

  @override
  String get labsDataDetectiveNarrationResultWrongExplorer =>
      'Not quite — look at how much each average moved and pick again.';

  @override
  String get labsDataDetectiveNarrationResultWrongBuilder =>
      'Compare how much the mean and median each changed, then predict again based on which shifted more.';

  @override
  String get labsDataDetectiveNarrationResultWrongNavigator =>
      'Re-examine the computed shifts: predict again based on which statistic changed by the larger magnitude.';

  @override
  String get labsDataDetectiveNarrationCompletionExplorer =>
      'Correct! You spotted which average the outlier affects most.';

  @override
  String get labsDataDetectiveNarrationCompletionBuilder =>
      'Correct! Identifying which statistic an outlier distorts most is exactly this lab\'s key idea.';

  @override
  String get labsDataDetectiveNarrationCompletionNavigator =>
      'Correct: the statistic with the larger shift is more sensitive to the outlier, consistent with the mean\'s sensitivity to extreme values relative to the median.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedExplorer =>
      'Same guess as last time — try the other one.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedBuilder =>
      'You predicted the same statistic again. Consider the other option.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedNavigator =>
      'The same prediction was repeated — reconsider using the computed shift values.';

  @override
  String get labsDataDetectiveNarrationHintInactivityExplorer =>
      'Still there? Pick Mean or Median, then tap Reveal.';

  @override
  String get labsDataDetectiveNarrationHintInactivityBuilder =>
      'Take your time — pick a prediction and tap Reveal whenever you\'re ready.';

  @override
  String get labsDataDetectiveNarrationHintInactivityNavigator =>
      'No input recorded recently — choose a prediction to continue.';

  @override
  String get labsFractionBuilderNarrationIntro =>
      'Tap segments to fill the fraction, then check your answer.';

  @override
  String get labsNumberLineExplorerNarrationIntro =>
      'Move the marker to the target value, then check your answer.';

  @override
  String get labsAlgebraBalanceNarrationIntro =>
      'Use the balance operations to isolate x, one step at a time.';

  @override
  String get labsDataDetectiveNarrationIntro =>
      'Predict which average the outlier affects most, then reveal the answer.';
}

/// The translations for Korean, as used in Republic of Korea (`ko_KR`).
class AppLocalizationsKoKr extends AppLocalizationsKo {
  AppLocalizationsKoKr() : super('ko_KR');

  @override
  String get navHome => '홈';

  @override
  String get navTopics => '주제';

  @override
  String get navPractice => '연습';

  @override
  String get navProfile => '프로필';

  @override
  String get navTutor => '튜터';

  @override
  String get navHelp => '도움말';

  @override
  String get topicsSearchHint => '주제 검색...';

  @override
  String get topicsFilterAll => '전체';

  @override
  String get topicsFilterPractice => '연습';

  @override
  String get topicsFilterRecommended => '추천';

  @override
  String get topicsFilterOxfordTrack => '옥스퍼드 트랙';

  @override
  String get topicsFilterGcse => '시험 대비';

  @override
  String get topicsFilterMore => '더보기';

  @override
  String get topicsSelectTrack => '트랙 선택';

  @override
  String get topicsTrackStandard => '기본 트랙';

  @override
  String get topicsTrackStandardSub => '핵심 수학 커리큘럼';

  @override
  String get topicsTrackGcseFoundation => '기초 수준';

  @override
  String get topicsTrackGcseFoundationSub => '기초 수준 준비';

  @override
  String get topicsTrackGcseHigher => '심화 수준';

  @override
  String get topicsTrackGcseHigherSub => '심화 수준 준비';

  @override
  String get topicsTrackOxford => '옥스퍼드 트랙';

  @override
  String get topicsTrackOxfordSub => '심화 수학 및 경시대회';

  @override
  String get topicsPremiumComingSoon => '프리미엄 구독 출시 예정.';

  @override
  String get topicsPremiumLabel => 'PREMIUM';

  @override
  String get practiceChooseMode => '연습 모드를 선택하세요';

  @override
  String get practiceModeLabel => '모드';

  @override
  String get practiceQuestionsLabel => '문제 수';

  @override
  String get practiceStartButton => '연습 시작';

  @override
  String get practiceModeQuickStart => '빠른 시작';

  @override
  String get practiceModeQuickStartSub => '혼합 복습, 10문제';

  @override
  String get practiceModeTopicDrill => '주제별 연습';

  @override
  String get practiceModeTopicDrillSub => '특정 주제 집중 연습';

  @override
  String get practiceModeTimedChallenge => '시간 제한 도전';

  @override
  String get practiceModeTimedChallengeSub => '시간 내에 풀기';

  @override
  String get practiceModeExamSimulator => '시험 시뮬레이터';

  @override
  String get practiceModeExamSimulatorSub => '실전 시험 형식 모의 연습';

  @override
  String get practiceExit => '종료';

  @override
  String practiceQuestionOf(int current, int total) {
    return '$current/$total 문제';
  }

  @override
  String get practiceMixedReview => '혼합 복습';

  @override
  String get practiceExplanation => '설명';

  @override
  String get practiceCheckAnswer => '정답 확인';

  @override
  String get practiceNextQuestion => '다음 문제 →';

  @override
  String get practiceFinishSession => '세션 종료';

  @override
  String get tutorBotName => '수학 튜터';

  @override
  String get tutorBotSubtitle => '힌트, 설명, 단계별 풀이를 받아보세요.';

  @override
  String tutorFreeTipsLeft(int count) {
    return '오늘 남은 무료 힌트: $count개';
  }

  @override
  String get tutorChipExplain => '설명해줘';

  @override
  String get tutorChipHint => '힌트 줘';

  @override
  String get tutorChipSteps => '풀이 보여줘';

  @override
  String get tutorChipCheckMistake => '오류 확인해줘';

  @override
  String get tutorInputHint => '수학 튜터에게 질문하세요...';

  @override
  String get tutorNeedMoreHelp => '더 많은 도움이 필요하신가요?';

  @override
  String get tutorUnlockDeeper => '튜터 크레딧 또는 유료 수학 팩으로 심층 설명을 이용하세요.';

  @override
  String get tutorBuyCredits => '튜터 크레딧 구매';

  @override
  String get tutorViewPacks => '팩 보기';

  @override
  String get profileSettingsLabel => '설정';

  @override
  String get profileAppearance => '외관';

  @override
  String get profileAppearanceSub => '테마 및 시각 설정';

  @override
  String get profileAccessibility => '접근성';

  @override
  String get profileAccessibilitySub => '글자 크기, 대비 및 애니메이션';

  @override
  String get profileSubscription => '구독';

  @override
  String get profileSubscriptionSub => '플랜 관리';

  @override
  String get profileCurriculumSettings => '커리큘럼 설정';

  @override
  String get profileCurriculumSettingsSub => '학습 단계 변경';

  @override
  String get profilePrivacyData => '개인정보 및 데이터';

  @override
  String get profilePrivacyDataSub => 'GDPR 준수 · 광고 없음 · 제3자 공유 없음';

  @override
  String get profileSignOut => '로그아웃';

  @override
  String get profileSignOutSub => '세션을 종료하고 환영 화면으로 돌아가기';

  @override
  String profileVersionNumber(String version) {
    return '버전 $version';
  }

  @override
  String get profileHeaderTitle => '프로필';

  @override
  String get profileHeaderSubtitle => '설정 및 환경설정';

  @override
  String get profilePreferredDisplayName => '선호하는 표시 이름';

  @override
  String get profilePreferredDisplayNameNotSet => '설정되지 않음';

  @override
  String get profileChangeDisplayName => '표시 이름 변경';

  @override
  String get profileGreetingPreview => '인사말 미리보기';

  @override
  String get profileSwitchLearner => '학습자 전환';

  @override
  String get profileDisplayNameDialogHint => '예: Sam 또는 별명';

  @override
  String get whoIsLearningTitle => '오늘은 누가 학습하나요?';

  @override
  String get whoIsLearningAddLearner => '학습자 추가';

  @override
  String get whoIsLearningAddLearnerHint => '학습자 이름';

  @override
  String homeLearningAsLabel(String name) {
    return '현재 학습자: $name';
  }

  @override
  String get homeSwitchLearnerAction => '전환';

  @override
  String get helpHeaderTitle => '도움말 및 지원';

  @override
  String get helpHeaderSubtitle => '지원, 안전 및 앱 정보';

  @override
  String get helpFaqTitle => '자주 묻는 질문';

  @override
  String get helpFaq1Q => '학습 단계 선택은 어떻게 작동하나요?';

  @override
  String get helpFaq1A =>
      '온보딩 중에 학습 단계를 선택합니다. 이를 통해 주제, 난이도, 시험 팩이 맞춤화됩니다. 언제든지 커리큘럼 설정에서 변경할 수 있습니다.';

  @override
  String get helpFaq2Q => '내 데이터는 안전한가요?';

  @override
  String get helpFaq2A =>
      '네. 학습 개인화에 필요한 데이터만 수집합니다. 데이터는 제3자와 공유되지 않으며 언제든지 삭제할 수 있습니다.';

  @override
  String get helpFaq3Q => '여러 자녀를 추가할 수 있나요?';

  @override
  String get helpFaq3A =>
      'Currently each installation supports one learner profile. Learning Analytics and progress reports are available from More or Profile.';

  @override
  String get helpFaq4Q => '시험 팩은 어떻게 작동하나요?';

  @override
  String get helpFaq4A =>
      '시험 팩은 주제와 난이도 별로 분류된 문제 세트입니다. 연습 → 시험 시뮬레이터를 탭하여 시작하세요.';

  @override
  String get helpContactTitle => '문의';

  @override
  String get helpContactIntro => '질문이나 문제가 있으시면 연락해 주세요:';

  @override
  String get helpContactEmail => 'support@mathtutor.app';

  @override
  String get helpPrivacyTitle => '개인정보 및 안전';

  @override
  String get helpPrivacyHeadline => '최소한의 데이터. 광고 없음. GDPR 준수.';

  @override
  String get helpPrivacyBullet1 => '필요한 데이터만 수집합니다';

  @override
  String get helpPrivacyBullet2 => '제3자와 공유하지 않습니다';

  @override
  String get helpPrivacyBullet3 => 'Learning Analytics available';

  @override
  String get helpPrivacyBullet4 => '언제든지 삭제 가능';

  @override
  String get helpTermsTitle => '이용약관';

  @override
  String get helpTermsBody =>
      '학생과 학부모에게 무료입니다. Math Intelligence를 사용하면 서비스 약관에 동의하는 것으로 간주됩니다.';

  @override
  String get helpParentalTitle => 'Learning Analytics';

  @override
  String get helpParentalHeadline =>
      'Understand progress, identify learning gaps and support the next step.';

  @override
  String get helpParentalBullet1 => 'Progress Overview';

  @override
  String get helpParentalBullet2 => 'Topic Mastery';

  @override
  String get helpParentalBullet3 => 'Learning Trends';

  @override
  String get helpParentalBullet4 => 'Recommended Practice';

  @override
  String get helpReportButton => '문제 신고';

  @override
  String get helpFooter =>
      'Minimal data. No ads. Learning Analytics available.';

  @override
  String get swissChooseLanguage => '한국어';

  @override
  String get tutorChipDeepExplanation => '심층 설명';

  @override
  String get tutorChipStepByStep => '단계별 풀이';

  @override
  String get tutorChipMistakeAnalysis => '오류 분석';

  @override
  String get tutorCreditBadge => '크레딧 1개';

  @override
  String tutorCreditBalance(int count) {
    return '$count개 크레딧';
  }

  @override
  String get tutorProLabel => 'Premium';

  @override
  String get tutorExhaustedTitle => '무료 힌트 소진';

  @override
  String get tutorExhaustedBody =>
      '무료 힌트 3개를 모두 사용했습니다. 크레딧을 구매하거나 업그레이드하여 계속하세요.';

  @override
  String get tutorCreditRequired => '크레딧 1개 필요';

  @override
  String get tutorPracticeContextLabel => '연습 중';

  @override
  String get tutorContextHint => '힌트';

  @override
  String get tutorContextExplain => '설명';

  @override
  String homeGreetingMorningNamed(String name) {
    return '좋은 아침이에요, $name';
  }

  @override
  String get homeGreetingMorningDefault => '좋은 아침이에요';

  @override
  String homeGreetingAfternoonNamed(String name) {
    return '좋은 오후예요, $name';
  }

  @override
  String get homeGreetingAfternoonDefault => '좋은 오후예요';

  @override
  String homeGreetingEveningNamed(String name) {
    return '좋은 저녁이에요, $name';
  }

  @override
  String get homeGreetingEveningDefault => '좋은 저녁이에요';

  @override
  String homeGreetingNightNamed(String name) {
    return '어서 오세요, $name';
  }

  @override
  String get homeGreetingNightDefault => '어서 오세요';

  @override
  String get homeStreakGoalMessage => '· 연속 학습 목표까지 10분 남았어요';

  @override
  String get homeSectionContinueLearning => '이어서 학습하기';

  @override
  String get homeViewAll => '모두 보기';

  @override
  String get homeSectionProgress => '학습 진도';

  @override
  String get homeStreakHeader => '연속 학습';

  @override
  String get homeStreakFirstDay => '연속 학습 첫 번째 날';

  @override
  String get homeThisWeekHeader => '이번 주';

  @override
  String get homeDaysActive => '활성 일수';

  @override
  String get homeSectionAchievements => '성취';

  @override
  String get homeAchievementStreakTitle => '주간 연속 학습 달성!';

  @override
  String get homeAchievementStreakSubtitle => '7일 연속 학습 완료';

  @override
  String get homeAchievementStreakLocked => '7일 연속 학습을 달성하면 잠금 해제됩니다';

  @override
  String get homeSectionOxfordTrack => '옥스퍼드 트랙';

  @override
  String get homePremiumRequired => 'PREMIUM';

  @override
  String get homeOxfordTrackSubtitle => '11+ 준비, 심화 문제 및 경시대회 수학';

  @override
  String get homeSectionLearningPaths => '학습 경로';

  @override
  String get homeSectionExamPacks => '시험 팩';

  @override
  String get homeExamPacksSubtitle => '집중 시험 준비';

  @override
  String get homeViewExamPacks => '시험 팩 보기';

  @override
  String get homeStartPracticeSession => '연습 시작';

  @override
  String get onboardingWelcomeTitle =>
      'Develop mathematical thinking.\nUnlock your potential.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personalised learning. Measurable progress.';

  @override
  String get onboardingWhoLabel => '사용자를 선택하세요';

  @override
  String get onboardingStudentLabel => '학습자입니다';

  @override
  String get onboardingStudentSub =>
      'Practice mathematics with a learning journey designed around you.';

  @override
  String get onboardingParentLabel => '학습자를 지원합니다';

  @override
  String get onboardingParentSub =>
      'Support every step of a learner\'s mathematical development.';

  @override
  String get onboardingTeacherLabel => '교사입니다';

  @override
  String get onboardingTeacherSub => '학생의 학습 진행 상황을 확인하고 연습을 배정하세요.';

  @override
  String get onboardingSelectError => '옵션을 선택해 주세요';

  @override
  String get onboardingContinue => '계속하기';

  @override
  String get onboardingFooter =>
      'Minimal data. No ads. Learning Analytics available.';

  @override
  String get onboardingAccessibilityTitle => '읽기 편하게 설정하세요';

  @override
  String get onboardingAccessibilitySub => '설정에서 언제든지 변경할 수 있습니다.';

  @override
  String get onboardingStageTitle => '학생의 나이는 몇 살인가요?';

  @override
  String get onboardingStageSub => '나이에 맞는 학습 내용을 제공합니다';

  @override
  String get onboardingStageTitleParent => 'Choose the learner\'s level';

  @override
  String get onboardingStageSubParent =>
      'We\'ll tailor content to the learner\'s current level.';

  @override
  String get onboardingStageCount => '3';

  @override
  String get onboardingStage1Label => '10–12세';

  @override
  String get onboardingStage1Sub => '초등학교 고학년';

  @override
  String get onboardingStage2Label => '13–15세';

  @override
  String get onboardingStage2Sub => '중학교';

  @override
  String get onboardingStage3Label => '16–20세';

  @override
  String get onboardingStage3Sub => '고등학교 / 수능 준비';

  @override
  String get onboardingStage4Label => 'KS5 (Years 12–13)';

  @override
  String get onboardingStage4Sub => 'Advanced maths';

  @override
  String get onboardingGoalTitle => '학습 목표는 무엇인가요?';

  @override
  String get onboardingGoalSub => '학습의 우선순위를 선택하세요';

  @override
  String get onboardingGoalTitleParent => 'How would you like to support them?';

  @override
  String get onboardingGoalSubParent =>
      'Choose the support focus for this learner.';

  @override
  String get onboardingGoal1Label => '학교 학습 지원';

  @override
  String get onboardingGoal1Sub => '숙제 및 학교 과목 이해';

  @override
  String get onboardingGoal2Label => '시험 대비';

  @override
  String get onboardingGoal2Sub => '시험 대비 및 모의고사 마스터';

  @override
  String get onboardingGoal3Label => '옥스퍼드 트랙';

  @override
  String get onboardingGoal3Sub => '심화 수학 및 경시대회';

  @override
  String get onboardingParentGoal1Label => 'Help build mathematical confidence';

  @override
  String get onboardingParentGoal1Sub =>
      'Support steady, low-pressure practice at the learner\'s pace.';

  @override
  String get onboardingParentGoal2Label => 'Identify learning gaps';

  @override
  String get onboardingParentGoal2Sub =>
      'Spot topics that need more attention before they become blockers.';

  @override
  String get onboardingParentGoal3Label => 'Track progress over time';

  @override
  String get onboardingParentGoal3Sub =>
      'Follow growth and consistency across completed practice.';

  @override
  String get onboardingParentGoal4Label => 'Support exam preparation';

  @override
  String get onboardingParentGoal4Sub =>
      'Guide revision and practice for upcoming assessments.';

  @override
  String get onboardingGoalTitleTeacher => 'Math Intelligence를 어떻게 사용하고 싶으신가요?';

  @override
  String get onboardingGoalSubTeacher => '학급에 맞는 목표를 선택하세요.';

  @override
  String get onboardingTeacherGoal1Label => '학급 진행 상황 확인';

  @override
  String get onboardingTeacherGoal1Sub => '학생들의 학습 진행 상황을 시간에 따라 확인하세요.';

  @override
  String get onboardingTeacherGoal2Label => '연습 문제 배정';

  @override
  String get onboardingTeacherGoal2Sub => '학생들에게 맞춤 연습 세트를 배정하세요.';

  @override
  String get onboardingTeacherGoal3Label => '시험 준비';

  @override
  String get onboardingTeacherGoal3Sub => '집중 연습 세트로 시험 대비를 지원하세요.';

  @override
  String get onboardingTeacherGoal4Label => '커리큘럼 살펴보기';

  @override
  String get onboardingTeacherGoal4Sub => '배정하기 전에 주제와 풀이 과정을 살펴보세요.';

  @override
  String get onboardingProfileTitle => '진행 상황 저장하기';

  @override
  String get onboardingProfileSub => '선택 사항입니다 — 프로필에서 언제든지 변경할 수 있습니다.';

  @override
  String get onboardingDisplayNameLabel => '이름을 알려주세요';

  @override
  String get onboardingDisplayNameSub => '닉네임도 괜찮아요 — 인사말에만 사용됩니다.';

  @override
  String get onboardingDisplayNameHint => '예: Alex';

  @override
  String get onboardingLearnerNameLabel => '학습자를 어떻게 부를까요?';

  @override
  String get onboardingLearnerNameSub => '학습자만의 Maths Journey를 만들어 보세요.';

  @override
  String get onboardingLearnerNameHint => '예: Alex';

  @override
  String get onboardingRelationshipLabel => '학습자와의 관계';

  @override
  String get onboardingRelationshipParent => '부모';

  @override
  String get onboardingRelationshipGuardian => '보호자';

  @override
  String get onboardingRelationshipGrandparent => '조부모';

  @override
  String get onboardingRelationshipTutor => '과외 선생님';

  @override
  String get onboardingRelationshipOther => '기타 가족 구성원';

  @override
  String get onboardingParentEmailLabel => 'Supporting adult email (optional)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Stored locally on this device for account clarity.';

  @override
  String get onboardingPrivacyNote =>
      'Local-only profile details. No cloud sync is claimed for this release.';

  @override
  String get onboardingStartLearning => '학습 시작';

  @override
  String get onboardingSkipEmail => '나중에 이메일 추가';

  @override
  String get appearanceLanguageTitle => '언어';

  @override
  String get appearanceLanguageSub => '앱 표시 언어';

  @override
  String get upgradeTitle => '프리미엄 잠금 해제';

  @override
  String get upgradeBody => '프리미엄 구독이 곧 출시됩니다.';

  @override
  String get upgradeViewPacks => '시험 팩 보기';

  @override
  String get upgradeMaybeLater => '나중에';

  @override
  String get termsTitle => '이용 약관';

  @override
  String get termsSub => '사용 전 읽어주세요';

  @override
  String get tutorCreditComingSoon => '튜터 크레딧이 곧 출시됩니다.';

  @override
  String get upgradeWhatsIncluded => '포함된 혜택';

  @override
  String get upgradeBenefit1Title => '무제한 AI 튜터';

  @override
  String get upgradeBenefit1Sub =>
      '크레딧 제한 없이 무제한으로 질문하고 단계별 설명과 맞춤형 힌트를 받아보세요.';

  @override
  String get upgradeBenefit2Title => '옥스퍼드 트랙 방식';

  @override
  String get upgradeBenefit2Sub =>
      'KS3부터 A-Level까지 체계적인 Oxford 커리큘럼과 엄선된 문제 세트로 단계적으로 학습하세요.';

  @override
  String get upgradeBenefit3Title => 'Learning Analytics';

  @override
  String get upgradeBenefit3Sub =>
      '상세한 성과 차트, 취약 부분 감지, 맞춤형 학습 추천으로 진도를 추적하세요.';

  @override
  String get upgradeComingSoonLabel => '출시 예정';

  @override
  String get upgradeComingSoon1 => '월간 및 연간 구독 플랜';

  @override
  String get upgradeComingSoon2 => '가족 다중 프로필 계정';

  @override
  String get upgradeComingSoon3 => '일일 연속 학습 알림 및 푸시 알림';

  @override
  String get upgradeComingSoon4 => '성취 및 마일스톤 보상';

  @override
  String get upgradeJoinEarlyAccess => '얼리 액세스 참여';

  @override
  String get upgradeEarlyAccessSnackbar => '얼리 액세스 신청이 곧 시작됩니다. 기대해주세요!';

  @override
  String get profileAboutLabel => '앱 정보';

  @override
  String get profileReleaseNotes => '릴리즈 노트';

  @override
  String get tutorEmptyTitle => '아직 메시지가 없습니다';

  @override
  String get tutorEmptySubtitle => '어떤 주제든 질문하시면 AI 튜터가 단계별로 도움을 드립니다.';

  @override
  String get homeStreakDays => '5일 연속 학습';

  @override
  String get homeAchievementUnlocked => '달성';

  @override
  String get homeBadgeLocked => '잠김';

  @override
  String get homeWhatsNewTitle => 'v1.0의 새로운 기능';

  @override
  String get homeWhatsNewBody => 'AI 튜터, 옥스퍼드 트랙, GCSE 시험 팩이 출시되었습니다.';

  @override
  String get homeDailyGoalTitle => '오늘의 목표';

  @override
  String get homeDailyGoalSubtitle => '오늘 15문제 풀기';

  @override
  String homeDailyGoalProgress(int completed, int target) {
    return '$completed / $target 완료';
  }

  @override
  String get tutorHowItWorksTitle => '튜터 사용 방법';

  @override
  String get tutorHowItWorksStep1Title => '질문하기';

  @override
  String get tutorHowItWorksStep1Sub => '수학 문제를 입력하거나 위의 빠른 동작을 선택하세요.';

  @override
  String get tutorHowItWorksStep2Title => '단계별 답변 받기';

  @override
  String get tutorHowItWorksStep2Sub => 'AI가 모든 단계를 이해할 수 있도록 풀이를 설명해줍니다.';

  @override
  String get tutorHowItWorksStep3Title => '배운 것을 연습하기';

  @override
  String get tutorHowItWorksStep3Sub => '연습 섹션으로 이동하여 방금 배운 것을 적용해보세요.';

  @override
  String get practiceSummaryTitle => '세션 완료';

  @override
  String practiceSummaryAccuracy(int percent) {
    return '$percent% 정확도';
  }

  @override
  String practiceSummaryCorrect(int correct, int total) {
    return '$correct / $total 정답';
  }

  @override
  String get practiceSummaryEncouragement => '잘 했어요! 계속 연습하여 점수를 향상시켜보세요.';

  @override
  String get practiceSummaryClose => '연습으로 돌아가기';

  @override
  String get helpFeatureRequestButton => '기능 요청';

  @override
  String get helpFeatureRequestSnackbar => '기능 요청이 곧 시작됩니다. 관심에 감사드립니다!';

  @override
  String get helpReportSnackbar => '신고해 주셔서 감사합니다! 곧 확인하겠습니다.';

  @override
  String get settingsParentToolsRewards =>
      'Learning Analytics and rewards animations';

  @override
  String get enableParentTools => 'Learning Analytics 활성화';

  @override
  String get parentToolsLocalOnly => 'Allow local-only Learning Analytics';

  @override
  String get unlockParentTools => 'Unlock Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Create or enter the local 4-digit PIN for Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge => 'Adaptive Learning Intelligence 기반';

  @override
  String get onboardingHeroStatement => '수학적 사고를 키우세요.\n잠재력을 펼치세요.';

  @override
  String get onboardingSupportingStatement => '개인화된 학습.\n측정 가능한 성장.';

  @override
  String get onboardingRoleClarification =>
      'For parents, guardians, teachers, tutors and homeschool educators.';

  @override
  String get onboardingCreateAccount => 'Create Account';

  @override
  String get onboardingCreateAccountSub =>
      'Save progress, Maths Journey data and achievements on this device.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Understand progress, identify learning gaps and support the next step.';

  @override
  String get learningAnalyticsEmptyState =>
      'Complete a practice session to begin building Learning Analytics.';
}
