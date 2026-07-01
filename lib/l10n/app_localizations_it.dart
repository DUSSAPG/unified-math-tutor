// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

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
  String get profileVersion => 'Version 1.0.0 · © 2026 Sterling Math';

  @override
  String get profileHeaderTitle => 'Profile';

  @override
  String get profileHeaderSubtitle => 'Settings & preferences';

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
      'Multi-profile support is on our roadmap. Currently each installation supports one learner profile. Parental controls and progress reports are available via the Profile screen.';

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
  String get helpPrivacyBullet3 => 'Parental controls available';

  @override
  String get helpPrivacyBullet4 => 'Deletable at any time';

  @override
  String get helpTermsTitle => 'Terms of Use';

  @override
  String get helpTermsBody =>
      'Free for students and parents. By using Sterling Math you agree to our terms of service. No payment is required for standard access.';

  @override
  String get helpParentalTitle => 'Parental Controls';

  @override
  String get helpParentalHeadline => 'Monitor your child\'s progress.';

  @override
  String get helpParentalBullet1 => 'Daily progress reports';

  @override
  String get helpParentalBullet2 => 'Weakness overview';

  @override
  String get helpParentalBullet3 => 'Set time limits';

  @override
  String get helpParentalBullet4 => 'View activity logs';

  @override
  String get helpReportButton => 'Report a Problem';

  @override
  String get helpFooter => 'Minimal data. No ads. Parental controls available.';

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
  String get homeGreeting => 'Good evening, Gabriel';

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
      'Helping every learner build confidence in mathematics.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personalized math learning, built for results';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'I\'m a Student';

  @override
  String get onboardingStudentSub =>
      'Practice maths, build confidence and prepare for exams.';

  @override
  String get onboardingParentLabel => 'I\'m a Parent or Teacher';

  @override
  String get onboardingParentSub =>
      'Monitor progress, guide learning and celebrate achievement.';

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
      'Minimal data. No ads. Parental controls available.';

  @override
  String get onboardingWelcomeStepTitle => 'Welcome';

  @override
  String get onboardingWelcomeStepBody =>
      'Let\'s personalise your learning journey.';

  @override
  String get onboardingStageTitle => 'Choose your level';

  @override
  String get onboardingStageSub =>
      'We\'ll tailor the content to the right level';

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
  String get onboardingProfileTitle => 'Choose your level';

  @override
  String get onboardingProfileSub => 'Select the right tier for School Support';

  @override
  String get onboardingShowLevelPicker => 'true';

  @override
  String get onboardingLevel1Label => 'KS2';

  @override
  String get onboardingLevel1Sub => 'Years 3-6 curriculum support';

  @override
  String get onboardingLevel2Label => 'KS3';

  @override
  String get onboardingLevel2Sub => 'Years 7-9 curriculum support';

  @override
  String get onboardingLevel3Label => 'KS4';

  @override
  String get onboardingLevel3Sub => 'Years 10-11 curriculum support';

  @override
  String get onboardingLanguageLabel => 'Selected Language';

  @override
  String get onboardingLanguageValue => 'English (UK)';

  @override
  String get onboardingParentEmailLabel => 'Parent Email (optional)';

  @override
  String get onboardingParentEmailHint => 'parent@example.co.uk';

  @override
  String get onboardingParentEmailSub =>
      'For progress reports and important updates';

  @override
  String get onboardingPrivacyNote =>
      'Your data is kept private. For reports only, no spam.';

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
  String get upgradeBenefit3Title => 'Advanced Analytics';

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
  String get homeDailyGoalProgress => '7 / 15 completed';

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
      'Parent tools and rewards animations';

  @override
  String get enableParentTools => 'Enable Parent Tools';

  @override
  String get parentToolsLocalOnly => 'Allow local-only Parent & Teacher Tools';

  @override
  String get unlockParentTools => 'Unlock Parent Tools';

  @override
  String get parentToolsPinPrompt => 'Create or enter the local 4-digit PIN';

  @override
  String get parentTeacherTools => 'Parent & Teacher Tools';

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
}

/// The translations for Italian, as used in Switzerland (`it_CH`).
class AppLocalizationsItCh extends AppLocalizationsIt {
  AppLocalizationsItCh() : super('it_CH');

  @override
  String get navHome => 'Inizio';

  @override
  String get navTopics => 'Argomenti';

  @override
  String get navPractice => 'Esercizi';

  @override
  String get navProfile => 'Profilo';

  @override
  String get navTutor => 'Tutor';

  @override
  String get navHelp => 'Aiuto';

  @override
  String get topicsSearchHint => 'Cerca argomenti';

  @override
  String get topicsFilterAll => 'Tutti';

  @override
  String get topicsFilterPractice => 'Esercizi';

  @override
  String get topicsFilterRecommended => 'Consigliati';

  @override
  String get topicsFilterOxfordTrack => 'Percorso Oxford';

  @override
  String get topicsFilterGcse => 'GCSE';

  @override
  String get topicsFilterMore => 'Altro';

  @override
  String get topicsSelectTrack => 'Scegli un percorso';

  @override
  String get topicsTrackStandard => 'Standard';

  @override
  String get topicsTrackStandardSub => 'Programma equilibrato';

  @override
  String get topicsTrackGcseFoundation => 'GCSE Foundation';

  @override
  String get topicsTrackGcseFoundationSub => 'Consolida le basi';

  @override
  String get topicsTrackGcseHigher => 'GCSE Higher';

  @override
  String get topicsTrackGcseHigherSub => 'Contenuti GCSE più avanzati';

  @override
  String get topicsTrackOxford => 'Percorso Oxford';

  @override
  String get topicsTrackOxfordSub => 'Approfondimento e sfide';

  @override
  String get topicsPremiumComingSoon => 'Funzione Premium';

  @override
  String get topicsPremiumLabel => 'PREMIUM';

  @override
  String get practiceChooseMode => 'Scegli una modalità di esercizio';

  @override
  String get practiceModeLabel => 'Modalità';

  @override
  String get practiceQuestionsLabel => 'Domande';

  @override
  String get practiceStartButton => 'Inizia';

  @override
  String get practiceModeQuickStart => 'Avvio rapido';

  @override
  String get practiceModeQuickStartSub => 'Inizia subito una breve sessione';

  @override
  String get practiceModeTopicDrill => 'Allenamento mirato';

  @override
  String get practiceModeTopicDrillSub => 'Esercitati su un solo argomento';

  @override
  String get practiceModeTimedChallenge => 'Sfida a tempo';

  @override
  String get practiceModeTimedChallengeSub => 'Esercitati contro il tempo';

  @override
  String get practiceModeExamSimulator => 'Simulatore d\'esame';

  @override
  String get practiceModeExamSimulatorSub => 'Simula le condizioni di un esame';

  @override
  String get practiceExit => 'Esci';

  @override
  String practiceQuestionOf(int current, int total) {
    return 'Domanda $current di $total';
  }

  @override
  String get practiceMixedReview => 'Ripasso misto';

  @override
  String get practiceExplanation => 'Spiegazione';

  @override
  String get practiceCheckAnswer => 'Controlla la risposta';

  @override
  String get practiceNextQuestion => 'Domanda successiva';

  @override
  String get practiceFinishSession => 'Termina sessione';

  @override
  String get tutorBotName => 'TutorBot';

  @override
  String get tutorBotSubtitle =>
      'Ottieni suggerimenti, spiegazioni e supporto passo passo.';

  @override
  String tutorFreeTipsLeft(int count) {
    return 'Suggerimenti gratuiti rimasti oggi: $count';
  }

  @override
  String get tutorChipExplain => 'Spiega questo';

  @override
  String get tutorChipHint => 'Dammi un suggerimento';

  @override
  String get tutorChipSteps => 'Passo passo';

  @override
  String get tutorChipCheckMistake => 'Controlla il mio errore';

  @override
  String get tutorInputHint => 'Chiedi al tutor';

  @override
  String get tutorNeedMoreHelp => 'Hai bisogno di altro aiuto?';

  @override
  String get tutorUnlockDeeper =>
      'Sblocca un supporto più approfondito del tutor.';

  @override
  String get tutorBuyCredits => 'Acquista crediti';

  @override
  String get tutorViewPacks => 'Visualizza pacchetti';

  @override
  String get profileSettingsLabel => 'Impostazioni';

  @override
  String get profileAppearance => 'Aspetto';

  @override
  String get profileAppearanceSub => 'Personalizza la visualizzazione';

  @override
  String get profileAccessibility => 'Accessibilità';

  @override
  String get profileAccessibilitySub =>
      'Regola animazioni e dimensione del testo';

  @override
  String get profileSubscription => 'Abbonamento';

  @override
  String get profileSubscriptionSub => 'Gestisci il tuo piano';

  @override
  String get profileCurriculumSettings => 'Programma';

  @override
  String get profileCurriculumSettingsSub => 'Scegli il tuo percorso';

  @override
  String get profilePrivacyData => 'Privacy e dati';

  @override
  String get profilePrivacyDataSub => 'Gestisci i tuoi dati locali';

  @override
  String get profileSignOut => 'Esci';

  @override
  String get profileSignOutSub => 'Esci da questo dispositivo';

  @override
  String get profileVersion => 'Versione';

  @override
  String get profileHeaderTitle => 'Profilo';

  @override
  String get profileHeaderSubtitle =>
      'Personalizza la tua esperienza di apprendimento.';

  @override
  String get helpHeaderTitle => 'Aiuto';

  @override
  String get helpHeaderSubtitle => 'Risposte e assistenza';

  @override
  String get helpFaqTitle => 'Domande frequenti';

  @override
  String get helpFaq1Q => 'Come inizio una sessione di esercizi?';

  @override
  String get helpFaq1A =>
      'Scegli un argomento o una modalità, quindi tocca Inizia.';

  @override
  String get helpFaq2Q => 'Come funziona il tutor?';

  @override
  String get helpFaq2A =>
      'Il tutor offre suggerimenti e spiegazioni per la domanda corrente.';

  @override
  String get helpFaq3Q => 'Dove vengono salvati i miei dati?';

  @override
  String get helpFaq3A =>
      'Le impostazioni e le attività recenti vengono salvate localmente sul dispositivo.';

  @override
  String get helpFaq4Q => 'Come posso cambiare lingua?';

  @override
  String get helpFaq4A =>
      'Apri il profilo e scegli le impostazioni della lingua.';

  @override
  String get helpContactTitle => 'Contatti';

  @override
  String get helpContactIntro => 'Hai bisogno di altro aiuto? Contattaci.';

  @override
  String get helpContactEmail => 'Assistenza via e-mail';

  @override
  String get helpPrivacyTitle => 'Privacy';

  @override
  String get helpPrivacyHeadline => 'Mantieni il controllo dei tuoi dati.';

  @override
  String get helpPrivacyBullet1 =>
      'Archiviazione locale per impostazioni e progressi';

  @override
  String get helpPrivacyBullet2 =>
      'Nessuna condivisione dei dati senza il tuo consenso';

  @override
  String get helpPrivacyBullet3 =>
      'Puoi eliminare i dati locali in qualsiasi momento';

  @override
  String get helpPrivacyBullet4 =>
      'Gli strumenti per i genitori sono protetti da PIN';

  @override
  String get helpTermsTitle => 'Condizioni d\'uso';

  @override
  String get helpTermsBody =>
      'Usa l\'app come supporto allo studio. Verifica le decisioni importanti con un insegnante o un genitore.';

  @override
  String get helpParentalTitle => 'Genitori e insegnanti';

  @override
  String get helpParentalHeadline =>
      'Supporta l\'apprendimento con strumenti locali per i genitori.';

  @override
  String get helpParentalBullet1 => 'Visualizza le sessioni recenti';

  @override
  String get helpParentalBullet2 => 'Mostra risposte corrette e spiegazioni';

  @override
  String get helpParentalBullet3 => 'Visualizzazione in sola lettura';

  @override
  String get helpParentalBullet4 => 'Proteggi l\'accesso con un PIN locale';

  @override
  String get helpReportButton => 'Segnala un problema';

  @override
  String get helpFooter => 'Progettato per uno studio autonomo e concentrato.';

  @override
  String get swissChooseLanguage => 'Svizzera · Scegli la lingua';

  @override
  String get tutorChipDeepExplanation => 'Spiegazione dettagliata';

  @override
  String get tutorChipStepByStep => 'Soluzione passo passo';

  @override
  String get tutorChipMistakeAnalysis => 'Analisi dell\'errore';

  @override
  String get tutorCreditBadge => '1 credito';

  @override
  String tutorCreditBalance(int count) {
    return '$count crediti';
  }

  @override
  String get tutorProLabel => 'Premium';

  @override
  String get tutorExhaustedTitle => 'Suggerimenti gratuiti esauriti';

  @override
  String get tutorExhaustedBody =>
      'Acquista crediti per ricevere altro supporto dal tutor.';

  @override
  String get tutorCreditRequired => 'Credito richiesto';

  @override
  String get tutorPracticeContextLabel => 'In esercizio';

  @override
  String get tutorContextHint => 'Suggerimento';

  @override
  String get tutorContextExplain => 'Spiegazione';

  @override
  String get homeGreeting => 'Buonasera, Gabriel';

  @override
  String get homeStreakGoalMessage =>
      '· 10 minuti per raggiungere il tuo obiettivo';

  @override
  String get homeSectionContinueLearning => 'Continua ad imparare';

  @override
  String get homeViewAll => 'Vedi tutto';

  @override
  String get homeSectionProgress => 'Progressi';

  @override
  String get homeStreakHeader => 'Serie';

  @override
  String get homeStreakFirstDay => 'Primo giorno della tua serie';

  @override
  String get homeThisWeekHeader => 'Questa settimana';

  @override
  String get homeDaysActive => 'Giorni attivi';

  @override
  String get homeSectionAchievements => 'Risultati';

  @override
  String get homeAchievementStreakTitle => 'Serie settimanale raggiunta!';

  @override
  String get homeAchievementStreakSubtitle =>
      '7 giorni di apprendimento di fila';

  @override
  String get homeSectionOxfordTrack => 'Percorso Oxford';

  @override
  String get homePremiumRequired => 'PREMIUM RICHIESTO';

  @override
  String get homeOxfordTrackSubtitle =>
      'Preparazione 11+, sfide avanzate e matematica competitiva';

  @override
  String get homeSectionLearningPaths => 'Percorsi di apprendimento';

  @override
  String get homeSectionExamPacks => 'Pacchetti esame';

  @override
  String get homeExamPacksSubtitle => 'Preparazione mirata agli esami';

  @override
  String get homeViewExamPacks => 'Vedi i pacchetti esame';

  @override
  String get homeStartPracticeSession => 'Avvia una sessione di pratica';

  @override
  String get onboardingWelcomeTitle =>
      'Aiutiamo ogni studente a costruire fiducia in matematica.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Apprendimento della matematica personalizzato, con risultati concreti';

  @override
  String get onboardingWhoLabel => 'CHI UTILIZZA L\'APP?';

  @override
  String get onboardingStudentLabel => 'Sono uno studente';

  @override
  String get onboardingStudentSub =>
      'Esercitati in matematica, costruisci fiducia e preparati per gli esami.';

  @override
  String get onboardingParentLabel => 'Sono un genitore o insegnante';

  @override
  String get onboardingParentSub =>
      'Monitora i progressi, guida l\'apprendimento e festeggia i traguardi.';

  @override
  String get onboardingSelectError => 'Seleziona un\'opzione';

  @override
  String get onboardingContinue => 'Continua';

  @override
  String get onboardingFooter =>
      'Dati minimi. Nessuna pubblicità. Controllo parentale disponibile.';

  @override
  String get onboardingStageTitle => 'A quale livello si trova lo studente?';

  @override
  String get onboardingStageSub =>
      'Adatteremo il contenuto al livello appropriato';

  @override
  String get onboardingStageCount => '4';

  @override
  String get onboardingStage1Label => 'Scuola primaria (anni 3–6)';

  @override
  String get onboardingStage1Sub => 'Matematica di base';

  @override
  String get onboardingStage2Label => 'Scuola media (anni 7–9)';

  @override
  String get onboardingStage2Sub => 'Matematica intermedia';

  @override
  String get onboardingStage3Label => 'Scuola superiore (anni 10–11)';

  @override
  String get onboardingStage3Sub => 'Matematica liceale';

  @override
  String get onboardingStage4Label => 'Liceo / Maturità (anni 12–13)';

  @override
  String get onboardingStage4Sub => 'Matematica avanzata';

  @override
  String get onboardingGoalTitle => 'Qual è l\'obiettivo?';

  @override
  String get onboardingGoalSub => 'Scegli il focus di apprendimento';

  @override
  String get onboardingGoal1Label => 'Supporto scolastico';

  @override
  String get onboardingGoal1Sub => 'Costruire fiducia in tutte le materie';

  @override
  String get onboardingGoal2Label => 'Preparazione agli esami';

  @override
  String get onboardingGoal2Sub => 'Esercizi mirati & sessioni a tempo';

  @override
  String get onboardingGoal3Label => 'Percorso Oxford';

  @override
  String get onboardingGoal3Sub => 'Preparazione 11+ e sfide avanzate';

  @override
  String get onboardingProfileTitle => 'Scegli il tuo livello';

  @override
  String get onboardingProfileSub =>
      'Seleziona il livello giusto per il supporto scolastico';

  @override
  String get onboardingShowLevelPicker => 'true';

  @override
  String get onboardingLevel1Label => 'Scuola primaria';

  @override
  String get onboardingLevel1Sub => 'Anni 3–6';

  @override
  String get onboardingLevel2Label => 'Scuola media';

  @override
  String get onboardingLevel2Sub => 'Anni 7–9';

  @override
  String get onboardingLevel3Label => 'Scuola superiore';

  @override
  String get onboardingLevel3Sub => 'Anni 10–11';

  @override
  String get onboardingLanguageLabel => 'Lingua selezionata';

  @override
  String get onboardingLanguageValue => 'Italiano (Svizzera)';

  @override
  String get onboardingParentEmailLabel => 'Email genitore (facoltativa)';

  @override
  String get onboardingParentEmailHint => 'genitore@esempio.ch';

  @override
  String get onboardingParentEmailSub =>
      'Per rapporti sui progressi e aggiornamenti importanti';

  @override
  String get onboardingPrivacyNote =>
      'I tuoi dati rimangono privati. Solo per i rapporti, nessuno spam.';

  @override
  String get onboardingStartLearning => 'Inizia ad imparare';

  @override
  String get onboardingSkipEmail => 'Salta per ora';

  @override
  String get appearanceLanguageTitle => 'Lingua';

  @override
  String get appearanceLanguageSub => 'Lingua di visualizzazione dell\'app';

  @override
  String get upgradeTitle => 'Sblocca Premium';

  @override
  String get upgradeBody => 'Sblocca le funzioni Premium con un abbonamento.';

  @override
  String get upgradeViewPacks => 'Vedi i pacchetti esame';

  @override
  String get upgradeMaybeLater => 'Forse più tardi';

  @override
  String get termsTitle => 'Termini di utilizzo';

  @override
  String get termsSub => 'Si prega di leggere prima dell\'uso';

  @override
  String get tutorCreditComingSoon => 'Disponibile nei pacchetti d\'esame.';

  @override
  String get upgradeWhatsIncluded => 'Cosa otterrai';

  @override
  String get upgradeBenefit1Title => 'Tutor IA illimitato';

  @override
  String get upgradeBenefit1Sub =>
      'Fai domande illimitate, ricevi spiegazioni passo dopo passo e suggerimenti personalizzati senza limiti di crediti.';

  @override
  String get upgradeBenefit2Title => 'Percorso Oxford';

  @override
  String get upgradeBenefit2Sub =>
      'Accedi al percorso Oxford strutturato con set di problemi curati e progressione guidata da KS3 a A-Level.';

  @override
  String get upgradeBenefit3Title => 'Analisi avanzate';

  @override
  String get upgradeBenefit3Sub =>
      'Monitora i tuoi progressi con grafici dettagliati, rilevamento dei punti deboli e consigli di studio personalizzati.';

  @override
  String get upgradeComingSoonLabel => 'Incluso in Premium';

  @override
  String get upgradeComingSoon1 => 'Piani di abbonamento mensili e annuali';

  @override
  String get upgradeComingSoon2 => 'Account familiari multi-profilo';

  @override
  String get upgradeComingSoon3 =>
      'Promemoria streak giornalieri e notifiche push';

  @override
  String get upgradeComingSoon4 => 'Obiettivi e premi per i traguardi';

  @override
  String get upgradeJoinEarlyAccess => 'Accesso anticipato';

  @override
  String get upgradeEarlyAccessSnackbar =>
      'L\'iscrizione all\'accesso anticipato è in arrivo. Restate sintonizzati!';

  @override
  String get profileAboutLabel => 'Informazioni';

  @override
  String get profileReleaseNotes => 'Note di rilascio';

  @override
  String get tutorEmptyTitle => 'Nessun messaggio ancora';

  @override
  String get tutorEmptySubtitle =>
      'Fai una domanda su qualsiasi argomento e il tuo tutor AI ti aiuterà passo dopo passo.';

  @override
  String get homeStreakDays => '5 giorni di fila';

  @override
  String get homeAchievementUnlocked => 'Sbloccato';

  @override
  String get homeBadgeLocked => 'Bloccato';

  @override
  String get homeWhatsNewTitle => 'Novità in v1.0';

  @override
  String get homeWhatsNewBody =>
      'Il Tutore IA, il percorso Oxford e i pacchetti esame GCSE sono ora disponibili.';

  @override
  String get homeDailyGoalTitle => 'Obiettivo giornaliero';

  @override
  String get homeDailyGoalSubtitle => 'Risolvi 15 domande oggi';

  @override
  String get homeDailyGoalProgress => '7 / 15 completati';

  @override
  String get tutorHowItWorksTitle => 'Come funziona il Tutore';

  @override
  String get tutorHowItWorksStep1Title => 'Fai una domanda';

  @override
  String get tutorHowItWorksStep1Sub =>
      'Scrivi una domanda di matematica o scegli un\'azione rapida sopra.';

  @override
  String get tutorHowItWorksStep2Title =>
      'Ottieni una risposta passo dopo passo';

  @override
  String get tutorHowItWorksStep2Sub =>
      'L\'IA scompone la soluzione in modo che tu capisca ogni passo.';

  @override
  String get tutorHowItWorksStep3Title => 'Metti in pratica ciò che impari';

  @override
  String get tutorHowItWorksStep3Sub =>
      'Vai alla sezione Pratica per applicare quello che hai appena imparato.';

  @override
  String get practiceSummaryTitle => 'Sessione completata';

  @override
  String practiceSummaryAccuracy(int percent) {
    return '$percent% di precisione';
  }

  @override
  String practiceSummaryCorrect(int correct, int total) {
    return '$correct / $total corretti';
  }

  @override
  String get practiceSummaryEncouragement =>
      'Ottimo lavoro! Continua a praticare per migliorare.';

  @override
  String get practiceSummaryClose => 'Torna alla pratica';

  @override
  String get helpFeatureRequestButton => 'Richiedi una funzione';

  @override
  String get helpFeatureRequestSnackbar =>
      'Le richieste di funzioni arriveranno presto — grazie per il tuo interesse!';

  @override
  String get helpReportSnackbar =>
      'Grazie per la segnalazione! Ce ne occuperemo presto.';

  @override
  String get mentalMathVaultTitle => 'Tesoro del calcolo mentale';

  @override
  String get mentalMathVaultSubtitle => 'Impara potenti trucchi di calcolo';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String get dailyBrainTeaser => 'Rompicapo del giorno';

  @override
  String get revealAnswer => 'Mostra risposta';

  @override
  String get captainNumberFuel => 'Energia di Captain Number';

  @override
  String get dailyMissionTitle => 'Captain Number ha bisogno di energia!';

  @override
  String get dailyMissionSubtitle =>
      'Risolvi 5 domande per la missione di oggi.';

  @override
  String get workedExample => 'Esempio svolto';

  @override
  String get practiceExample => 'Esercizio';

  @override
  String get loading => 'Caricamento...';

  @override
  String get practiceNoQuestions =>
      'Non sono disponibili domande di esercizio.';

  @override
  String get mascotGreeting => 'Pronto a fare il pieno di energia matematica?';

  @override
  String get mascotThinking => 'Prenditi il tuo tempo e rifletti bene!';

  @override
  String get mascotSuccess => 'Ottimo calcolo! Energia aggiunta.';

  @override
  String get mascotEncouragement => 'Bel tentativo. La prossima è tua!';

  @override
  String get mascotLevelUp => 'Missione caricata! Captain Number è pronto!';

  @override
  String get homeTopicFractionsTitle => 'Frazioni e percentuali';

  @override
  String get homeTopicFractionsSubtitle => 'Basi e conversioni';

  @override
  String get homeTopicAlgebraTitle => 'Basi di algebra';

  @override
  String get homeTopicAlgebraSubtitle => 'Equazioni e variabili';

  @override
  String get homeTopicStatisticsTitle => 'Statistica e probabilità';

  @override
  String get homeTopicStatisticsSubtitle => 'Dati e casualità';

  @override
  String get homeLearningFractionsTitle => 'Frazioni';

  @override
  String get homeLearningFractionsSubtitle => 'Impara frazioni e conversioni';

  @override
  String get homeLearningStatisticsTitle => 'Statistica';

  @override
  String get homeLearningStatisticsSubtitle =>
      'Introduzione ai dati e alla probabilità';

  @override
  String get topicsStandardSelected => 'Percorso standard selezionato.';

  @override
  String get topicsNoResults => 'Nessun argomento trovato';

  @override
  String get topicsClearFilters => 'Cancella filtri';

  @override
  String get examPacksCtaSubtitle =>
      'Sblocca i livelli GCSE, il percorso Oxford e i crediti Tutor.';

  @override
  String get examPacksIntro =>
      'Scegli un pacchetto per esercizi mirati e supporto Tutor.';

  @override
  String examPackSelected(String stage) {
    return '$stage selezionato';
  }

  @override
  String get examPackKs2Title => 'Matematica KS2';

  @override
  String get examPackKs3Title => 'Matematica KS3';

  @override
  String get examPackKs4Title => 'Matematica KS4 GCSE';

  @override
  String get examPackKs5Title => 'Matematica KS5';

  @override
  String get examPackPrimarySubtitle => 'Esercizi per la scuola primaria';

  @override
  String get examPackSecondarySubtitle => 'Esercizi per la scuola secondaria';

  @override
  String get examPackGcseSubtitle => 'Preparazione GCSE';

  @override
  String get examPackAdvancedSubtitle => 'Esercizi di matematica avanzata';

  @override
  String get examPackTutorCreditsTitle => 'Crediti Tutor';

  @override
  String get examPackTutorCreditsSubtitle =>
      'Indizi, spiegazioni e supporto passo dopo passo aggiuntivi';

  @override
  String get examPackIncluded => 'Incluso';

  @override
  String get examPackTopUp => 'Ricarica';

  @override
  String homeStreakCount(int days) {
    return 'Serie di $days giorni';
  }

  @override
  String homeMilestone(int days) {
    return 'Traguardo di $days giorni';
  }

  @override
  String get homeRewardsOn => 'Ricompense attive';

  @override
  String get homeRewardsOff => 'Ricompense disattivate';

  @override
  String get homeBadgeFirstSession => 'Prima sessione';

  @override
  String get homeBadgeTenQuestions => '10 domande';

  @override
  String get homeBadgeAlgebraStarter => 'Inizio algebra';

  @override
  String get homeContinueKs2Topic => 'Frazioni';

  @override
  String get homeContinueKs2Subtopic => 'Frazioni equivalenti';

  @override
  String get homeContinueKs3Topic => 'Algebra';

  @override
  String get homeContinueKs3Subtopic => 'Risoluzione di equazioni';

  @override
  String get homeContinueKs4Topic => 'Matematica GCSE';

  @override
  String get homeContinueKs4Subtopic => 'Funzioni quadratiche';

  @override
  String get homeContinueKs5Topic => 'Matematica pura';

  @override
  String get homeContinueKs5Subtopic => 'Derivazione';

  @override
  String get quietStudyModeLabel => 'Modalità studio tranquillo';

  @override
  String get quietStudyModeTooltip =>
      'Ispirata a Nyepi, una tradizione balinese di riflessione, quiete e concentrazione.';

  @override
  String nextUp(String topic) {
    return 'Prossimo: $topic';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsParentToolsRewards =>
      'Strumenti genitori e animazioni premio';

  @override
  String get enableParentTools => 'Attiva strumenti genitori';

  @override
  String get parentToolsLocalOnly =>
      'Consenti strumenti locali per genitori e insegnanti';

  @override
  String get unlockParentTools => 'Sblocca strumenti genitori';

  @override
  String get parentToolsPinPrompt =>
      'Crea o inserisci il PIN locale di 4 cifre';

  @override
  String get parentTeacherTools => 'Strumenti per genitori e insegnanti';

  @override
  String get createParentPin => 'Crea PIN genitore';

  @override
  String get parentPinStorageNotice =>
      'Il PIN di 4 cifre viene memorizzato localmente come hash SHA-256. Nessun dato lascia questo dispositivo.';

  @override
  String get fourDigitPin => 'PIN di 4 cifre';

  @override
  String get openCheatSheet => 'Apri scheda di supporto';

  @override
  String get unlockWithPremium => 'Sblocca con Premium';

  @override
  String get rewardsAnimations => 'Animazioni premio';

  @override
  String get rewardsAnimationsSubtitle =>
      'Mostra celebrazioni dopo risposte corrette e traguardi';

  @override
  String get premiumLabel => 'Premium';

  @override
  String get rewardsLabel => 'Premi';

  @override
  String get premiumFeature => 'Funzione Premium';

  @override
  String get includedInPremium => 'Incluso in Premium';

  @override
  String get availableInExamPacks => 'Disponibile nei pacchetti d\'esame';

  @override
  String get unlockWithSubscription => 'Sblocca con abbonamento';

  @override
  String get enterParentPin => 'Inserire il PIN parentale';

  @override
  String get resetParentPin => 'Reimposta PIN parentale';

  @override
  String get currentPin => 'PIN attuale';

  @override
  String get resetLabel => 'Reimposta';

  @override
  String get vaultLoadError => 'Il vault non è stato caricato.';

  @override
  String get pinMustBeFourDigits => 'Inserire esattamente 4 cifre.';

  @override
  String get pinIncorrect => 'PIN errato.';

  @override
  String get pinResetFailed => 'Reimpostazione del PIN non riuscita.';
}
