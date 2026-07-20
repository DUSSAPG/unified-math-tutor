// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

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
      'Förstå framsteg, hitta kunskapsluckor och stöd nästa steg.';

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
      'Utveckla matematiskt tänkande.\nFrigör din potential.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personanpassat lärande. Mätbara framsteg.';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'Jag är elev';

  @override
  String get onboardingStudentSub =>
      'Träna matematik med en lärresa som är utformad runt dig.';

  @override
  String get onboardingParentLabel => 'Jag stöttar en elev';

  @override
  String get onboardingParentSub =>
      'Stöd varje steg i elevens matematiska utveckling.';

  @override
  String get onboardingTeacherLabel => 'Jag är lärare';

  @override
  String get onboardingTeacherSub =>
      'Följ framsteg och tilldela övningar till dina elever.';

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
  String get onboardingParentGoal1Label =>
      'Hjälp till att bygga matematisk trygghet';

  @override
  String get onboardingParentGoal1Sub =>
      'Support steady, low-pressure practice at the learner\'s pace.';

  @override
  String get onboardingParentGoal2Label => 'Identifiera kunskapsluckor';

  @override
  String get onboardingParentGoal2Sub =>
      'Spot topics that need more attention before they become blockers.';

  @override
  String get onboardingParentGoal3Label => 'Följ framsteg över tid';

  @override
  String get onboardingParentGoal3Sub =>
      'Follow growth and consistency across completed practice.';

  @override
  String get onboardingParentGoal4Label => 'Stöd inför prov';

  @override
  String get onboardingParentGoal4Sub =>
      'Guide revision and practice for upcoming assessments.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Hur vill du använda Math Intelligence?';

  @override
  String get onboardingGoalSubTeacher => 'Välj fokus för din klass.';

  @override
  String get onboardingTeacherGoal1Label => 'Följ klassens framsteg';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Se hur dina elever utvecklas över tid.';

  @override
  String get onboardingTeacherGoal2Label => 'Tilldela övningar';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Skapa riktade övningsset för dina elever.';

  @override
  String get onboardingTeacherGoal3Label => 'Förbered inför prov';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Stöd provberedskap med riktade övningsset.';

  @override
  String get onboardingTeacherGoal4Label => 'Utforska kursplanen';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Bläddra bland ämnen och genomräknade lösningar innan du tilldelar dem.';

  @override
  String get onboardingProfileTitle => 'Spara dina framsteg';

  @override
  String get onboardingProfileSub =>
      'Valfritt — du kan alltid ändra detta senare i Profil.';

  @override
  String get onboardingDisplayNameLabel => 'Vad ska vi kalla dig?';

  @override
  String get onboardingDisplayNameSub =>
      'Ett smeknamn duger fint — det används bara till din hälsning.';

  @override
  String get onboardingDisplayNameHint => 't.ex. Alex';

  @override
  String get onboardingLearnerNameLabel => 'Vad ska vi kalla din elev?';

  @override
  String get onboardingLearnerNameSub => 'Personanpassa elevens Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 't.ex. Alex';

  @override
  String get onboardingRelationshipLabel => 'Din relation till eleven';

  @override
  String get onboardingRelationshipParent => 'Förälder';

  @override
  String get onboardingRelationshipGuardian => 'Vårdnadshavare';

  @override
  String get onboardingRelationshipGrandparent => 'Mor- eller farförälder';

  @override
  String get onboardingRelationshipTutor => 'Handledare';

  @override
  String get onboardingRelationshipOther => 'Annan familjemedlem';

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
    return 'Nästa: $topic';
  }

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsParentToolsRewards =>
      'Learning Analytics och belöningsanimationer';

  @override
  String get enableParentTools => 'Aktivera Learning Analytics';

  @override
  String get parentToolsLocalOnly => 'Tillåt lokal Learning Analytics';

  @override
  String get unlockParentTools => 'Lås upp Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Create or enter the local 4-digit PIN for Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

  @override
  String get createParentPin => 'Skapa föräldra-PIN';

  @override
  String get parentPinStorageNotice =>
      'Den fyrsiffriga PIN-koden lagras lokalt som en SHA-256-hash. Ingen data lämnar enheten.';

  @override
  String get fourDigitPin => 'Fyrsiffrig PIN-kod';

  @override
  String get openCheatSheet => 'Öppna hjälpark';

  @override
  String get unlockWithPremium => 'Lås upp med Premium';

  @override
  String get rewardsAnimations => 'Belöningsanimationer';

  @override
  String get rewardsAnimationsSubtitle =>
      'Visa firanden efter rätta svar och milstolpar';

  @override
  String get premiumLabel => 'Premium';

  @override
  String get rewardsLabel => 'Belöningar';

  @override
  String get premiumFeature => 'Premiumfunktion';

  @override
  String get includedInPremium => 'Ingår i Premium';

  @override
  String get availableInExamPacks => 'Tillgängligt i provpaket';

  @override
  String get unlockWithSubscription => 'Lås upp med prenumeration';

  @override
  String get enterParentPin => 'Ange föräldra-PIN';

  @override
  String get resetParentPin => 'Återställ föräldra-PIN';

  @override
  String get currentPin => 'Nuvarande PIN';

  @override
  String get resetLabel => 'Återställ';

  @override
  String get vaultLoadError => 'Valvet kunde inte läsas in.';

  @override
  String get pinMustBeFourDigits => 'Ange exakt 4 siffror.';

  @override
  String get pinIncorrect => 'Fel PIN-kod.';

  @override
  String get pinResetFailed => 'Återställning av PIN misslyckades.';

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
  String get onboardingTechBadge => 'Powered by Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Utveckla matematiskt tänkande.\nFrigör din potential.';

  @override
  String get onboardingSupportingStatement =>
      'Personanpassat lärande.\nMätbara framsteg.';

  @override
  String get onboardingRoleClarification =>
      'För föräldrar, vårdnadshavare, lärare, handledare och hemundervisare.';

  @override
  String get onboardingCreateAccount => 'Skapa konto';

  @override
  String get onboardingCreateAccountSub =>
      'Spara framsteg, Maths Journey-data och prestationer på den här enheten.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Förstå framsteg, hitta kunskapsluckor och stöd nästa steg.';

  @override
  String get learningAnalyticsEmptyState =>
      'Slutför ett träningspass för att börja bygga Learning Analytics.';

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
}

/// The translations for Swedish, as used in Sweden (`sv_SE`).
class AppLocalizationsSvSe extends AppLocalizationsSv {
  AppLocalizationsSvSe() : super('sv_SE');

  @override
  String get helpFaq3A =>
      'Currently each installation supports one learner profile. Learning Analytics and progress reports are available from More or Profile.';

  @override
  String get helpPrivacyBullet3 => 'Learning Analytics available';

  @override
  String get helpParentalTitle => 'Learning Analytics';

  @override
  String get helpParentalHeadline =>
      'Förstå framsteg, hitta kunskapsluckor och stöd nästa steg.';

  @override
  String get helpParentalBullet1 => 'Progress Overview';

  @override
  String get helpParentalBullet2 => 'Topic Mastery';

  @override
  String get helpParentalBullet3 => 'Learning Trends';

  @override
  String get helpParentalBullet4 => 'Recommended Practice';

  @override
  String get helpFooter =>
      'Minimal data. No ads. Learning Analytics available.';

  @override
  String get onboardingWelcomeTitle =>
      'Utveckla matematiskt tänkande.\nFrigör din potential.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personanpassat lärande. Mätbara framsteg.';

  @override
  String get onboardingStudentLabel => 'Jag är elev';

  @override
  String get onboardingStudentSub =>
      'Träna matematik med en lärresa som är utformad runt dig.';

  @override
  String get onboardingParentLabel => 'Jag stöttar en elev';

  @override
  String get onboardingParentSub =>
      'Stöd varje steg i elevens matematiska utveckling.';

  @override
  String get onboardingTeacherLabel => 'Jag är lärare';

  @override
  String get onboardingTeacherSub =>
      'Följ framsteg och tilldela övningar till dina elever.';

  @override
  String get onboardingFooter =>
      'Minimal data. No ads. Learning Analytics available.';

  @override
  String get onboardingStageTitleParent => 'Choose the learner\'s level';

  @override
  String get onboardingStageSubParent =>
      'We\'ll tailor content to the learner\'s current level.';

  @override
  String get onboardingGoalTitleParent => 'How would you like to support them?';

  @override
  String get onboardingGoalSubParent =>
      'Choose the support focus for this learner.';

  @override
  String get onboardingParentGoal1Label =>
      'Hjälp till att bygga matematisk trygghet';

  @override
  String get onboardingParentGoal1Sub =>
      'Support steady, low-pressure practice at the learner\'s pace.';

  @override
  String get onboardingParentGoal2Label => 'Identifiera kunskapsluckor';

  @override
  String get onboardingParentGoal2Sub =>
      'Spot topics that need more attention before they become blockers.';

  @override
  String get onboardingParentGoal3Label => 'Följ framsteg över tid';

  @override
  String get onboardingParentGoal3Sub =>
      'Follow growth and consistency across completed practice.';

  @override
  String get onboardingParentGoal4Label => 'Stöd inför prov';

  @override
  String get onboardingParentGoal4Sub =>
      'Guide revision and practice for upcoming assessments.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Hur vill du använda Math Intelligence?';

  @override
  String get onboardingGoalSubTeacher => 'Välj fokus för din klass.';

  @override
  String get onboardingTeacherGoal1Label => 'Följ klassens framsteg';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Se hur dina elever utvecklas över tid.';

  @override
  String get onboardingTeacherGoal2Label => 'Tilldela övningar';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Skapa riktade övningsset för dina elever.';

  @override
  String get onboardingTeacherGoal3Label => 'Förbered inför prov';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Stöd provberedskap med riktade övningsset.';

  @override
  String get onboardingTeacherGoal4Label => 'Utforska kursplanen';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Bläddra bland ämnen och genomräknade lösningar innan du tilldelar dem.';

  @override
  String get onboardingProfileTitle => 'Spara dina framsteg';

  @override
  String get onboardingProfileSub =>
      'Valfritt — du kan alltid ändra detta senare i Profil.';

  @override
  String get onboardingDisplayNameLabel => 'Vad ska vi kalla dig?';

  @override
  String get onboardingDisplayNameSub =>
      'Ett smeknamn duger fint — det används bara till din hälsning.';

  @override
  String get onboardingDisplayNameHint => 't.ex. Alex';

  @override
  String get onboardingLearnerNameLabel => 'Vad ska vi kalla din elev?';

  @override
  String get onboardingLearnerNameSub => 'Personanpassa elevens Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 't.ex. Alex';

  @override
  String get onboardingRelationshipLabel => 'Din relation till eleven';

  @override
  String get onboardingRelationshipParent => 'Förälder';

  @override
  String get onboardingRelationshipGuardian => 'Vårdnadshavare';

  @override
  String get onboardingRelationshipGrandparent => 'Mor- eller farförälder';

  @override
  String get onboardingRelationshipTutor => 'Handledare';

  @override
  String get onboardingRelationshipOther => 'Annan familjemedlem';

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
  String get upgradeBenefit3Title => 'Learning Analytics';

  @override
  String get settingsParentToolsRewards =>
      'Learning Analytics och belöningsanimationer';

  @override
  String get enableParentTools => 'Aktivera Learning Analytics';

  @override
  String get parentToolsLocalOnly => 'Tillåt lokal Learning Analytics';

  @override
  String get unlockParentTools => 'Lås upp Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Create or enter the local 4-digit PIN for Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge => 'Powered by Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Utveckla matematiskt tänkande.\nFrigör din potential.';

  @override
  String get onboardingSupportingStatement =>
      'Personanpassat lärande.\nMätbara framsteg.';

  @override
  String get onboardingRoleClarification =>
      'För föräldrar, vårdnadshavare, lärare, handledare och hemundervisare.';

  @override
  String get onboardingCreateAccount => 'Skapa konto';

  @override
  String get onboardingCreateAccountSub =>
      'Spara framsteg, Maths Journey-data och prestationer på den här enheten.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Förstå framsteg, hitta kunskapsluckor och stöd nästa steg.';

  @override
  String get learningAnalyticsEmptyState =>
      'Complete a practice session to begin building Learning Analytics.';
}
