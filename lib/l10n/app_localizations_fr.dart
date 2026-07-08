// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

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
  String get profileVersion => 'Version 1.0.0 · © 2026 Math Intelligence';

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
      'Free for students and parents. By using Math Intelligence you agree to our terms of service. No payment is required for standard access.';

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
  String get onboardingStageTitleParent => 'Choose their level';

  @override
  String get onboardingStageSubParent =>
      'We\'ll tailor the content to your child\'s level';

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
  String get onboardingGoalTitleParent => 'What matters most?';

  @override
  String get onboardingGoalSubParent =>
      'Choose how you\'d like to support them';

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
  String get onboardingParentGoal1Label => 'Help my child build confidence';

  @override
  String get onboardingParentGoal1Sub =>
      'Steady, low-pressure practice at their own pace';

  @override
  String get onboardingParentGoal2Label => 'Find learning gaps';

  @override
  String get onboardingParentGoal2Sub =>
      'Spot weak topics before they become a problem';

  @override
  String get onboardingParentGoal3Label => 'Track progress over time';

  @override
  String get onboardingParentGoal3Sub =>
      'See how they\'re improving week to week';

  @override
  String get onboardingParentGoal4Label => 'Support GCSE preparation';

  @override
  String get onboardingParentGoal4Sub =>
      'Targeted revision aligned to the exam';

  @override
  String get onboardingProfileTitle => 'A few details about your child';

  @override
  String get onboardingProfileSub =>
      'This helps us tailor recommendations for them';

  @override
  String get onboardingChildNameLabel => 'Child\'s name (optional)';

  @override
  String get onboardingChildNameSub => 'Personalise their experience';

  @override
  String get onboardingChildNameHint => 'e.g. Alex';

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
}

/// The translations for French, as used in Switzerland (`fr_CH`).
class AppLocalizationsFrCh extends AppLocalizationsFr {
  AppLocalizationsFrCh() : super('fr_CH');

  @override
  String get navHome => 'Accueil';

  @override
  String get navTopics => 'Thèmes';

  @override
  String get navPractice => 'Entraînement';

  @override
  String get navProfile => 'Profil';

  @override
  String get navTutor => 'Tuteur';

  @override
  String get navHelp => 'Aide';

  @override
  String get topicsSearchHint => 'Rechercher des thèmes';

  @override
  String get topicsFilterAll => 'Tous';

  @override
  String get topicsFilterPractice => 'Entraînement';

  @override
  String get topicsFilterRecommended => 'Recommandés';

  @override
  String get topicsFilterOxfordTrack => 'Parcours Oxford';

  @override
  String get topicsFilterGcse => 'Examen cantonal';

  @override
  String get topicsFilterMore => 'Plus';

  @override
  String get topicsSelectTrack => 'Choisir un parcours';

  @override
  String get topicsTrackStandard => 'Standard';

  @override
  String get topicsTrackStandardSub => 'Programme équilibré';

  @override
  String get topicsTrackGcseFoundation => 'Examen cantonal — Base';

  @override
  String get topicsTrackGcseFoundationSub => 'Maîtriser les fondamentaux';

  @override
  String get topicsTrackGcseHigher => 'Examen cantonal — Avancé';

  @override
  String get topicsTrackGcseHigherSub => 'Contenus plus exigeants';

  @override
  String get topicsTrackOxford => 'Parcours Oxford';

  @override
  String get topicsTrackOxfordSub => 'Approfondissement et défi';

  @override
  String get topicsPremiumComingSoon => 'Fonction Premium';

  @override
  String get topicsPremiumLabel => 'PREMIUM';

  @override
  String get practiceChooseMode => 'Choisir un mode d\'entraînement';

  @override
  String get practiceModeLabel => 'Mode';

  @override
  String get practiceQuestionsLabel => 'Questions';

  @override
  String get practiceStartButton => 'Démarrer l\'entraînement';

  @override
  String get practiceModeQuickStart => 'Démarrage rapide';

  @override
  String get practiceModeQuickStartSub =>
      'Commencer directement avec un exercice court';

  @override
  String get practiceModeTopicDrill => 'Entraînement thématique';

  @override
  String get practiceModeTopicDrillSub => 'S\'entraîner sur un thème précis';

  @override
  String get practiceModeTimedChallenge => 'Défi chronométré';

  @override
  String get practiceModeTimedChallengeSub => 'S\'entraîner contre la montre';

  @override
  String get practiceModeExamSimulator => 'Simulateur d\'examen';

  @override
  String get practiceModeExamSimulatorSub =>
      'Simuler les conditions d\'un examen';

  @override
  String get practiceExit => 'Quitter';

  @override
  String practiceQuestionOf(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get practiceMixedReview => 'Révision mixte';

  @override
  String get practiceExplanation => 'Explication';

  @override
  String get practiceCheckAnswer => 'Vérifier la réponse';

  @override
  String get practiceNextQuestion => 'Question suivante';

  @override
  String get practiceFinishSession => 'Terminer la session';

  @override
  String get tutorBotName => 'TutorBot';

  @override
  String get tutorBotSubtitle =>
      'Indices, explications et accompagnement étape par étape.';

  @override
  String tutorFreeTipsLeft(int count) {
    return 'Indices gratuits restants aujourd\'hui : $count';
  }

  @override
  String get tutorChipExplain => 'Explique-moi ça';

  @override
  String get tutorChipHint => 'Donne-moi un indice';

  @override
  String get tutorChipSteps => 'Étape par étape';

  @override
  String get tutorChipCheckMistake => 'Vérifie mon erreur';

  @override
  String get tutorInputHint => 'Interroge le tuteur';

  @override
  String get tutorNeedMoreHelp => 'Tu as besoin de plus d\'aide ?';

  @override
  String get tutorUnlockDeeper =>
      'Des explications plus approfondies — à débloquer avec Premium.';

  @override
  String get tutorBuyCredits => 'Acheter des crédits';

  @override
  String get tutorViewPacks => 'Voir les packs';

  @override
  String get profileSettingsLabel => 'Paramètres';

  @override
  String get profileAppearance => 'Apparence';

  @override
  String get profileAppearanceSub => 'Personnalise l\'interface';

  @override
  String get profileAccessibility => 'Accessibilité';

  @override
  String get profileAccessibilitySub =>
      'Ajuster les animations et la taille du texte';

  @override
  String get profileSubscription => 'Abonnement';

  @override
  String get profileSubscriptionSub => 'Gère ton forfait';

  @override
  String get profileCurriculumSettings => 'Programme';

  @override
  String get profileCurriculumSettingsSub =>
      'Choisis ton parcours d\'apprentissage';

  @override
  String get profilePrivacyData => 'Confidentialité et données';

  @override
  String get profilePrivacyDataSub => 'Gère tes données locales';

  @override
  String get profileSignOut => 'Se déconnecter';

  @override
  String get profileSignOutSub => 'Se déconnecter de cet appareil';

  @override
  String get profileVersion => 'Version';

  @override
  String get profileHeaderTitle => 'Profil';

  @override
  String get profileHeaderSubtitle => 'Paramètres et profil d\'apprentissage.';

  @override
  String get helpHeaderTitle => 'Aide';

  @override
  String get helpHeaderSubtitle => 'Réponses et assistance';

  @override
  String get helpFaqTitle => 'Questions fréquentes';

  @override
  String get helpFaq1Q => 'Comment démarrer un entraînement ?';

  @override
  String get helpFaq1A =>
      'Choisis un thème ou un mode d\'entraînement, puis appuie sur Démarrer l\'entraînement.';

  @override
  String get helpFaq2Q => 'Comment fonctionne le tuteur ?';

  @override
  String get helpFaq2A =>
      'Le tuteur fournit des indices et des explications pour la question en cours.';

  @override
  String get helpFaq3Q => 'Où sont stockées mes données ?';

  @override
  String get helpFaq3A =>
      'Tes paramètres et activités récentes sont enregistrés localement sur ton appareil.';

  @override
  String get helpFaq4Q => 'Comment changer la langue ?';

  @override
  String get helpFaq4A =>
      'Ouvre ton profil et sélectionne les paramètres de langue.';

  @override
  String get helpContactTitle => 'Contact';

  @override
  String get helpContactIntro =>
      'Besoin d\'aide supplémentaire ? Contacte-nous.';

  @override
  String get helpContactEmail => 'Assistance par e-mail';

  @override
  String get helpPrivacyTitle => 'Confidentialité';

  @override
  String get helpPrivacyHeadline => 'Tes données restent sous ton contrôle.';

  @override
  String get helpPrivacyBullet1 =>
      'Stockage local pour les paramètres et la progression';

  @override
  String get helpPrivacyBullet2 =>
      'Aucun partage de tes données sans ton consentement';

  @override
  String get helpPrivacyBullet3 =>
      'Tu peux supprimer tes données locales à tout moment';

  @override
  String get helpPrivacyBullet4 =>
      'Les outils parentaux sont protégés par un code PIN';

  @override
  String get helpTermsTitle => 'Conditions d\'utilisation';

  @override
  String get helpTermsBody =>
      'Utilise l\'application comme outil d\'apprentissage. Vérifie les décisions importantes avec un enseignant ou un parent.';

  @override
  String get helpParentalTitle => 'Parents et enseignants';

  @override
  String get helpParentalHeadline =>
      'Un aperçu clair de la progression — sécurisé et stocké localement.';

  @override
  String get helpParentalBullet1 => 'Consulter les derniers exercices';

  @override
  String get helpParentalBullet2 =>
      'Afficher les réponses correctes et les explications';

  @override
  String get helpParentalBullet3 => 'La vue est en lecture seule';

  @override
  String get helpParentalBullet4 => 'Protéger l\'accès avec un code PIN local';

  @override
  String get helpReportButton => 'Signaler un problème';

  @override
  String get helpFooter => 'Conçu pour un apprentissage autonome et concentré.';

  @override
  String get swissChooseLanguage => 'Suisse · Choisir la langue';

  @override
  String get tutorChipDeepExplanation => 'Explication approfondie';

  @override
  String get tutorChipStepByStep => 'Solution étape par étape';

  @override
  String get tutorChipMistakeAnalysis => 'Analyse des erreurs';

  @override
  String get tutorCreditBadge => '1 crédit';

  @override
  String tutorCreditBalance(int count) {
    return '$count crédits';
  }

  @override
  String get tutorProLabel => 'Premium';

  @override
  String get tutorExhaustedTitle => 'Indices gratuits épuisés';

  @override
  String get tutorExhaustedBody =>
      'Achète des crédits pour continuer à bénéficier de l\'aide du tuteur.';

  @override
  String get tutorCreditRequired => 'Crédit requis';

  @override
  String get tutorPracticeContextLabel => 'S\'entraîne';

  @override
  String get tutorContextHint => 'Indice';

  @override
  String get tutorContextExplain => 'Explication';

  @override
  String get homeGreeting => 'Bonsoir, Gabriel';

  @override
  String get homeStreakGoalMessage =>
      '· Encore 10 minutes pour atteindre ton objectif de série';

  @override
  String get homeSectionContinueLearning => 'Continuer à apprendre';

  @override
  String get homeViewAll => 'Tout afficher';

  @override
  String get homeSectionProgress => 'Progression';

  @override
  String get homeStreakHeader => 'Série';

  @override
  String get homeStreakFirstDay => 'Premier jour de ta série';

  @override
  String get homeThisWeekHeader => 'Cette semaine';

  @override
  String get homeDaysActive => 'Jours actifs';

  @override
  String get homeSectionAchievements => 'Succès';

  @override
  String get homeAchievementStreakTitle => 'Série hebdomadaire atteinte !';

  @override
  String get homeAchievementStreakSubtitle => '7 jours d\'affilée';

  @override
  String get homeSectionOxfordTrack => 'Parcours Oxford';

  @override
  String get homePremiumRequired => 'PREMIUM REQUIS';

  @override
  String get homeOxfordTrackSubtitle =>
      'Approfondissement, exercices exigeants et mathématiques de compétition';

  @override
  String get homeSectionLearningPaths => 'Parcours d\'apprentissage';

  @override
  String get homeSectionExamPacks => 'Packs d\'examens';

  @override
  String get homeExamPacksSubtitle => 'Préparation ciblée aux examens';

  @override
  String get homeViewExamPacks => 'Voir les packs d\'examens';

  @override
  String get homeStartPracticeSession => 'Démarrer une session d\'entraînement';

  @override
  String get onboardingWelcomeTitle =>
      'Nous aidons chaque apprenant à développer sa confiance en mathématiques.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Entraînement mathématique de précision. Adapté à ton niveau.';

  @override
  String get onboardingWhoLabel => 'QUI UTILISE L\'APPLICATION ?';

  @override
  String get onboardingStudentLabel => 'Je suis élève';

  @override
  String get onboardingStudentSub =>
      'Entraîne-toi en maths, gagne en confiance et prépare tes examens.';

  @override
  String get onboardingParentLabel => 'Je suis parent ou enseignant';

  @override
  String get onboardingParentSub =>
      'Suivre les progrès, accompagner l\'apprentissage et célébrer les réussites.';

  @override
  String get onboardingSelectError => 'Veuillez choisir une option';

  @override
  String get onboardingContinue => 'Continuer';

  @override
  String get onboardingFooter =>
      'Données minimales. Pas de publicité. Contrôle parental disponible.';

  @override
  String get onboardingStageTitle => 'À quel degré scolaire est l\'élève ?';

  @override
  String get onboardingStageSub => 'Nous adaptons le contenu au bon niveau';

  @override
  String get onboardingStageCount => '4';

  @override
  String get onboardingStage1Label => 'Primaire (degrés 3–6)';

  @override
  String get onboardingStage1Sub => 'Mathématiques de base';

  @override
  String get onboardingStage2Label => 'Secondaire I (degrés 7–9)';

  @override
  String get onboardingStage2Sub => 'Mathématiques approfondies';

  @override
  String get onboardingStage3Label => 'Secondaire II (degrés 10–11)';

  @override
  String get onboardingStage3Sub => 'Mathématiques gymnasiales';

  @override
  String get onboardingStage4Label => 'Gymnase / Maturité (degrés 12–13)';

  @override
  String get onboardingStage4Sub => 'Mathématiques avancées';

  @override
  String get onboardingGoalTitle => 'Quel est l\'objectif ?';

  @override
  String get onboardingGoalSub => 'Choisis ton axe d\'apprentissage';

  @override
  String get onboardingGoal1Label => 'Soutien scolaire';

  @override
  String get onboardingGoal1Sub => 'Gagner en confiance à tous les niveaux';

  @override
  String get onboardingGoal2Label => 'Préparation aux examens';

  @override
  String get onboardingGoal2Sub => 'Exercices ciblés et séries chronométrées';

  @override
  String get onboardingGoal3Label => 'Parcours Oxford';

  @override
  String get onboardingGoal3Sub =>
      'Approfondissement et mathématiques de compétition';

  @override
  String get onboardingProfileTitle => 'Choisis ton niveau';

  @override
  String get onboardingProfileSub =>
      'Sélectionne le bon degré pour le soutien scolaire';

  @override
  String get onboardingShowLevelPicker => 'true';

  @override
  String get onboardingLevel1Label => 'Primaire';

  @override
  String get onboardingLevel1Sub => 'Degrés 3–6';

  @override
  String get onboardingLevel2Label => 'Secondaire I';

  @override
  String get onboardingLevel2Sub => 'Degrés 7–9';

  @override
  String get onboardingLevel3Label => 'Secondaire II';

  @override
  String get onboardingLevel3Sub => 'Degrés 10–11';

  @override
  String get onboardingLanguageLabel => 'Langue sélectionnée';

  @override
  String get onboardingLanguageValue => 'Français (Suisse)';

  @override
  String get onboardingParentEmailLabel => 'E-mail du parent (facultatif)';

  @override
  String get onboardingParentEmailHint => 'parent@exemple.ch';

  @override
  String get onboardingParentEmailSub =>
      'Pour les rapports de progression et les mises à jour importantes';

  @override
  String get onboardingPrivacyNote =>
      'Tes données sont utilisées exclusivement pour les rapports de progression.';

  @override
  String get onboardingStartLearning => 'Commencer à apprendre';

  @override
  String get onboardingSkipEmail => 'Ignorer pour l\'instant';

  @override
  String get appearanceLanguageTitle => 'Langue';

  @override
  String get appearanceLanguageSub => 'Langue d\'affichage de l\'application';

  @override
  String get upgradeTitle => 'Activer Premium';

  @override
  String get upgradeBody =>
      'Déverrouille les fonctions Premium avec un abonnement.';

  @override
  String get upgradeViewPacks => 'Voir les packs d\'examens';

  @override
  String get upgradeMaybeLater => 'Peut-être plus tard';

  @override
  String get termsTitle => 'Conditions d\'utilisation';

  @override
  String get termsSub => 'À lire avant utilisation';

  @override
  String get tutorCreditComingSoon => 'Disponible dans les packs d\'examens.';

  @override
  String get upgradeWhatsIncluded => 'Ce qui est inclus';

  @override
  String get upgradeBenefit1Title => 'Tuteur IA illimité';

  @override
  String get upgradeBenefit1Sub =>
      'Pose autant de questions que tu veux, reçois des explications étape par étape et des indices personnalisés — sans limite de crédits.';

  @override
  String get upgradeBenefit2Title => 'Parcours Oxford';

  @override
  String get upgradeBenefit2Sub =>
      'Accès au programme Oxford structuré avec des séries d\'exercices sélectionnés et une progression guidée du primaire à la maturité.';

  @override
  String get upgradeBenefit3Title => 'Analyses avancées';

  @override
  String get upgradeBenefit3Sub =>
      'Suis ta progression grâce à des graphiques de performance détaillés, la détection de tes points faibles et des recommandations d\'apprentissage personnalisées.';

  @override
  String get upgradeComingSoonLabel => 'Inclus dans Premium';

  @override
  String get upgradeComingSoon1 => 'Abonnements mensuels et annuels';

  @override
  String get upgradeComingSoon2 => 'Comptes familiaux avec plusieurs profils';

  @override
  String get upgradeComingSoon3 =>
      'Rappels de série quotidiens et notifications push';

  @override
  String get upgradeComingSoon4 => 'Succès et récompenses de jalons';

  @override
  String get upgradeJoinEarlyAccess => 'M\'inscrire maintenant';

  @override
  String get upgradeEarlyAccessSnackbar =>
      'Nous te préviendrons dès que Premium sera disponible.';

  @override
  String get profileAboutLabel => 'À propos de l\'application';

  @override
  String get profileReleaseNotes => 'Notes de version';

  @override
  String get tutorEmptyTitle => 'Aucun message pour l\'instant';

  @override
  String get tutorEmptySubtitle =>
      'Pose une question sur n\'importe quel sujet et ton tuteur IA t\'accompagnera étape par étape.';

  @override
  String get homeStreakDays => '5 jours d\'affilée';

  @override
  String get homeAchievementUnlocked => 'Débloqué';

  @override
  String get homeBadgeLocked => 'Verrouillé';

  @override
  String get homeWhatsNewTitle => 'Nouveau dans v1.0';

  @override
  String get homeWhatsNewBody =>
      'Le tuteur IA, le parcours Oxford et les nouveaux packs d\'examens sont désormais disponibles.';

  @override
  String get homeDailyGoalTitle => 'Objectif du jour';

  @override
  String get homeDailyGoalSubtitle => 'Résous 15 exercices aujourd\'hui';

  @override
  String get homeDailyGoalProgress => '7 / 15 complétés';

  @override
  String get tutorHowItWorksTitle => 'Comment fonctionne le tuteur';

  @override
  String get tutorHowItWorksStep1Title => 'Pose une question';

  @override
  String get tutorHowItWorksStep1Sub =>
      'Saisis un problème de maths ou sélectionne une action rapide en haut.';

  @override
  String get tutorHowItWorksStep2Title => 'Reçois une réponse étape par étape';

  @override
  String get tutorHowItWorksStep2Sub =>
      'L\'IA explique la solution pour que tu comprennes chaque étape.';

  @override
  String get tutorHowItWorksStep3Title => 'Mets-le en pratique';

  @override
  String get tutorHowItWorksStep3Sub =>
      'Va à la page d\'entraînement et applique ce que tu as appris.';

  @override
  String get practiceSummaryTitle => 'Session terminée';

  @override
  String practiceSummaryAccuracy(int percent) {
    return '$percent% de précision';
  }

  @override
  String practiceSummaryCorrect(int correct, int total) {
    return '$correct / $total correct';
  }

  @override
  String get practiceSummaryEncouragement =>
      'Bien joué. Un entraînement régulier apporte des progrès durables.';

  @override
  String get practiceSummaryClose => 'Retour à l\'entraînement';

  @override
  String get helpFeatureRequestButton => 'Suggérer une fonctionnalité';

  @override
  String get helpFeatureRequestSnackbar =>
      'Les suggestions de fonctionnalités arrivent bientôt — merci de ton intérêt !';

  @override
  String get helpReportSnackbar =>
      'Merci pour ton signalement ! Nous y jetterons un œil rapidement.';

  @override
  String get mentalMathVaultTitle => 'Coffre de calcul mental';

  @override
  String get mentalMathVaultSubtitle =>
      'Apprends de puissantes astuces de calcul';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get dailyBrainTeaser => 'Énigme du jour';

  @override
  String get revealAnswer => 'Afficher la réponse';

  @override
  String get captainNumberFuel => 'Énergie de Captain Number';

  @override
  String get dailyMissionTitle => 'Captain Number a besoin d\'énergie !';

  @override
  String get dailyMissionSubtitle =>
      'Résous 5 questions pour la mission du jour.';

  @override
  String get workedExample => 'Exemple résolu';

  @override
  String get practiceExample => 'Exercice';

  @override
  String get loading => 'Chargement...';

  @override
  String get practiceNoQuestions =>
      'Aucune question d\'entraînement n\'est disponible.';

  @override
  String get mascotGreeting =>
      'Prêt à faire le plein d\'énergie mathématique ?';

  @override
  String get mascotThinking => 'Prends ton temps et réfléchis bien !';

  @override
  String get mascotSuccess => 'Excellent calcul ! Énergie ajoutée.';

  @override
  String get mascotEncouragement => 'Bien essayé. La prochaine est pour toi !';

  @override
  String get mascotLevelUp => 'Mission alimentée ! Captain Number est prêt !';

  @override
  String get homeTopicFractionsTitle => 'Fractions et pourcentages';

  @override
  String get homeTopicFractionsSubtitle => 'Bases et conversions';

  @override
  String get homeTopicAlgebraTitle => 'Bases de l\'algèbre';

  @override
  String get homeTopicAlgebraSubtitle => 'Équations et variables';

  @override
  String get homeTopicStatisticsTitle => 'Statistiques et probabilités';

  @override
  String get homeTopicStatisticsSubtitle => 'Données et hasard';

  @override
  String get homeLearningFractionsTitle => 'Fractions';

  @override
  String get homeLearningFractionsSubtitle =>
      'Apprendre les fractions et les conversions';

  @override
  String get homeLearningStatisticsTitle => 'Statistiques';

  @override
  String get homeLearningStatisticsSubtitle =>
      'Introduction aux données et aux probabilités';

  @override
  String get topicsStandardSelected => 'Parcours standard sélectionné.';

  @override
  String get topicsNoResults => 'Aucun thème trouvé';

  @override
  String get topicsClearFilters => 'Effacer les filtres';

  @override
  String get examPacksCtaSubtitle =>
      'Débloque les niveaux GCSE, le parcours Oxford et les crédits Tutor.';

  @override
  String get examPacksIntro =>
      'Choisis un pack pour un entraînement ciblé et l\'aide du Tutor.';

  @override
  String examPackSelected(String stage) {
    return '$stage sélectionné';
  }

  @override
  String get examPackKs2Title => 'Mathématiques KS2';

  @override
  String get examPackKs3Title => 'Mathématiques KS3';

  @override
  String get examPackKs4Title => 'Mathématiques KS4 GCSE';

  @override
  String get examPackKs5Title => 'Mathématiques KS5';

  @override
  String get examPackPrimarySubtitle => 'Entraînement de niveau primaire';

  @override
  String get examPackSecondarySubtitle => 'Entraînement de niveau secondaire';

  @override
  String get examPackGcseSubtitle => 'Préparation au GCSE';

  @override
  String get examPackAdvancedSubtitle => 'Entraînement avancé en mathématiques';

  @override
  String get examPackTutorCreditsTitle => 'Crédits Tutor';

  @override
  String get examPackTutorCreditsSubtitle =>
      'Indices, explications et aide pas à pas supplémentaires';

  @override
  String get examPackIncluded => 'Inclus';

  @override
  String get examPackTopUp => 'Recharge';

  @override
  String homeStreakCount(int days) {
    return 'Série de $days jours';
  }

  @override
  String homeMilestone(int days) {
    return 'Palier de $days jours';
  }

  @override
  String get homeRewardsOn => 'Récompenses activées';

  @override
  String get homeRewardsOff => 'Récompenses désactivées';

  @override
  String get homeBadgeFirstSession => 'Première session';

  @override
  String get homeBadgeTenQuestions => '10 questions';

  @override
  String get homeBadgeAlgebraStarter => 'Début en algèbre';

  @override
  String get homeContinueKs2Topic => 'Fractions';

  @override
  String get homeContinueKs2Subtopic => 'Fractions équivalentes';

  @override
  String get homeContinueKs3Topic => 'Algèbre';

  @override
  String get homeContinueKs3Subtopic => 'Résolution d\'équations';

  @override
  String get homeContinueKs4Topic => 'Mathématiques GCSE';

  @override
  String get homeContinueKs4Subtopic => 'Fonctions quadratiques';

  @override
  String get homeContinueKs5Topic => 'Mathématiques pures';

  @override
  String get homeContinueKs5Subtopic => 'Dérivation';

  @override
  String get quietStudyModeLabel => 'Mode d\'étude calme';

  @override
  String get quietStudyModeTooltip =>
      'Inspiré de Nyepi, une tradition balinaise de réflexion, de calme et de concentration.';

  @override
  String nextUp(String topic) {
    return 'À suivre : $topic';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsParentToolsRewards =>
      'Outils parentaux et animations de récompense';

  @override
  String get enableParentTools => 'Activer les outils parentaux';

  @override
  String get parentToolsLocalOnly =>
      'Autoriser les outils Parents et enseignants locaux';

  @override
  String get unlockParentTools => 'Déverrouiller les outils parentaux';

  @override
  String get parentToolsPinPrompt =>
      'Créer ou saisir le code PIN local à 4 chiffres';

  @override
  String get parentTeacherTools => 'Outils Parents et enseignants';

  @override
  String get createParentPin => 'Créer le code PIN parental';

  @override
  String get parentPinStorageNotice =>
      'Le code PIN à 4 chiffres est stocké localement sous forme de hachage SHA-256. Aucune donnée ne quitte cet appareil.';

  @override
  String get fourDigitPin => 'Code PIN à 4 chiffres';

  @override
  String get openCheatSheet => 'Ouvrir la fiche d\'aide';

  @override
  String get unlockWithPremium => 'Déverrouiller avec Premium';

  @override
  String get rewardsAnimations => 'Animations de récompense';

  @override
  String get rewardsAnimationsSubtitle =>
      'Afficher des célébrations après les bonnes réponses et les jalons';

  @override
  String get premiumLabel => 'Premium';

  @override
  String get rewardsLabel => 'Récompenses';

  @override
  String get premiumFeature => 'Fonction Premium';

  @override
  String get includedInPremium => 'Inclus dans Premium';

  @override
  String get availableInExamPacks => 'Disponible dans les packs d\'examens';

  @override
  String get unlockWithSubscription => 'Déverrouiller avec un abonnement';

  @override
  String get enterParentPin => 'Entrer le code PIN parental';

  @override
  String get resetParentPin => 'Réinitialiser le code PIN parental';

  @override
  String get currentPin => 'Code PIN actuel';

  @override
  String get resetLabel => 'Réinitialiser';

  @override
  String get vaultLoadError => 'Le coffre n\'a pas pu être chargé.';

  @override
  String get pinMustBeFourDigits => 'Entrez exactement 4 chiffres.';

  @override
  String get pinIncorrect => 'Code PIN incorrect.';

  @override
  String get pinResetFailed => 'Échec de la réinitialisation du PIN.';
}
