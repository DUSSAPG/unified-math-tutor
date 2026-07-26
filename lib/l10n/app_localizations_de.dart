// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
      'Derzeit unterstützt jede Installation ein Lernprofil. Learning Analytics und Fortschrittsberichte sind über Mehr oder Profil erreichbar.';

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
  String get helpPrivacyBullet3 => 'Learning Analytics verfügbar';

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
      'Fortschritt verstehen, Lernlücken erkennen und den nächsten Schritt unterstützen.';

  @override
  String get helpParentalBullet1 => 'Fortschrittsübersicht';

  @override
  String get helpParentalBullet2 => 'Themenbeherrschung';

  @override
  String get helpParentalBullet3 => 'Lerntrends';

  @override
  String get helpParentalBullet4 => 'Empfohlene Übungen';

  @override
  String get helpReportButton => 'Report a Problem';

  @override
  String get helpFooter =>
      'Minimale Daten. Keine Werbung. Learning Analytics verfügbar.';

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
      'Mathematisches Denken entwickeln.\nPotenzial entfalten.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personalisiertes Lernen. Messbarer Fortschritt.';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'Ich bin Lernende oder Lernender';

  @override
  String get onboardingStudentSub =>
      'Übe Mathematik mit einem Lernweg, der auf dich ausgerichtet ist.';

  @override
  String get onboardingParentLabel => 'Ich unterstütze eine lernende Person';

  @override
  String get onboardingParentSub =>
      'Begleite jeden Schritt ihrer mathematischen Entwicklung.';

  @override
  String get onboardingTeacherLabel => 'Ich bin Lehrperson';

  @override
  String get onboardingTeacherSub =>
      'Verfolge den Fortschritt und weise deinen Lernenden Übungen zu.';

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
      'Minimale Daten. Keine Werbung. Learning Analytics verfügbar.';

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
  String get onboardingStageTitleParent => 'Niveau der lernenden Person wählen';

  @override
  String get onboardingStageSubParent =>
      'Wir passen die Inhalte an das aktuelle Niveau an.';

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
  String get onboardingGoalTitleParent => 'Wie möchtest du unterstützen?';

  @override
  String get onboardingGoalSubParent =>
      'Wähle den passenden Unterstützungsschwerpunkt.';

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
      'Mathematisches Selbstvertrauen stärken';

  @override
  String get onboardingParentGoal1Sub =>
      'Ruhiges, regelmässiges Üben im eigenen Tempo unterstützen.';

  @override
  String get onboardingParentGoal2Label => 'Lernlücken erkennen';

  @override
  String get onboardingParentGoal2Sub =>
      'Themen finden, die zusätzliche Aufmerksamkeit brauchen.';

  @override
  String get onboardingParentGoal3Label => 'Fortschritt über Zeit verfolgen';

  @override
  String get onboardingParentGoal3Sub =>
      'Entwicklung und Regelmässigkeit anhand abgeschlossener Übungen sehen.';

  @override
  String get onboardingParentGoal4Label => 'Prüfungsvorbereitung unterstützen';

  @override
  String get onboardingParentGoal4Sub =>
      'Revision und Übung für kommende Prüfungen begleiten.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Wie möchtest du Math Intelligence nutzen?';

  @override
  String get onboardingGoalSubTeacher => 'Wähle den Fokus für deine Klasse.';

  @override
  String get onboardingTeacherGoal1Label => 'Fortschritt der Klasse verfolgen';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Sieh, wie sich deine Lernenden über die Zeit entwickeln.';

  @override
  String get onboardingTeacherGoal2Label => 'Übungen zuweisen';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Lege gezielte Übungssets für deine Lernenden fest.';

  @override
  String get onboardingTeacherGoal3Label => 'Prüfungsvorbereitung';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Unterstütze die Prüfungsvorbereitung mit gezielten Übungssets.';

  @override
  String get onboardingTeacherGoal4Label => 'Lehrplan erkunden';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Durchstöbere Themen und Musterlösungen, bevor du sie zuweist.';

  @override
  String get onboardingProfileTitle => 'Speichere deinen Fortschritt';

  @override
  String get onboardingProfileSub =>
      'Optional – du kannst dies jederzeit später in deinem Profil ändern.';

  @override
  String get onboardingDisplayNameLabel => 'Wie sollen wir dich nennen?';

  @override
  String get onboardingDisplayNameSub =>
      'Ein Spitzname reicht – das ist nur für deine Begrüssung.';

  @override
  String get onboardingDisplayNameHint => 'z. B. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Wie sollen wir deine lernende Person nennen?';

  @override
  String get onboardingLearnerNameSub => 'Personalisiert die Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel =>
      'Deine Beziehung zur lernenden Person';

  @override
  String get onboardingRelationshipParent => 'Elternteil';

  @override
  String get onboardingRelationshipGuardian => 'Erziehungsberechtigte/r';

  @override
  String get onboardingRelationshipGrandparent => 'Grosselternteil';

  @override
  String get onboardingRelationshipTutor => 'Tutor/in';

  @override
  String get onboardingRelationshipOther => 'Anderes Familienmitglied';

  @override
  String get onboardingParentEmailLabel =>
      'E-Mail der unterstützenden Person (optional)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Wird zur Kontoklarheit lokal auf diesem Gerät gespeichert.';

  @override
  String get onboardingPrivacyNote =>
      'Profildaten bleiben lokal. Für diese Version wird keine Cloud-Synchronisierung versprochen.';

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
      'Learning Analytics und Belohnungsanimationen';

  @override
  String get enableParentTools => 'Learning Analytics aktivieren';

  @override
  String get parentToolsLocalOnly => 'Lokale Learning Analytics erlauben';

  @override
  String get unlockParentTools => 'Learning Analytics entsperren';

  @override
  String get parentToolsPinPrompt =>
      'Lokale 4-stellige PIN für Learning Analytics erstellen oder eingeben.';

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
  String get onboardingTechBadge => 'Powered by Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Mathematisches Denken entwickeln.\nPotenzial entfalten.';

  @override
  String get onboardingSupportingStatement =>
      'Personalisiertes Lernen.\nMessbarer Fortschritt.';

  @override
  String get onboardingRoleClarification =>
      'Für Eltern, Erziehungsberechtigte, Lehrpersonen, Tutorinnen und Tutoren sowie Homeschooling-Familien.';

  @override
  String get onboardingCreateAccount => 'Konto erstellen';

  @override
  String get onboardingCreateAccountSub =>
      'Speichert Fortschritt, Maths-Journey-Daten und Erfolge auf diesem Gerät.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Fortschritt verstehen, Lernlücken erkennen und den nächsten Schritt unterstützen.';

  @override
  String get learningAnalyticsEmptyState =>
      'Schliesse eine Übungseinheit ab, um Learning Analytics aufzubauen.';

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
  String get mathStudioDiscoveryEmptyCategory =>
      'More cards for this category are coming soon.';

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

/// The translations for German, as used in Switzerland (`de_CH`).
class AppLocalizationsDeCh extends AppLocalizationsDe {
  AppLocalizationsDeCh() : super('de_CH');

  @override
  String get navHome => 'Startseite';

  @override
  String get navTopics => 'Themen';

  @override
  String get navPractice => 'Üben';

  @override
  String get navProfile => 'Profil';

  @override
  String get navTutor => 'Tutor';

  @override
  String get navHelp => 'Hilfe';

  @override
  String get topicsSearchHint => 'Themen suchen';

  @override
  String get topicsFilterAll => 'Alle';

  @override
  String get topicsFilterPractice => 'Üben';

  @override
  String get topicsFilterRecommended => 'Empfohlen';

  @override
  String get topicsFilterOxfordTrack => 'Oxford-Pfad';

  @override
  String get topicsFilterGcse => 'Kantonalprüfung';

  @override
  String get topicsFilterMore => 'Mehr';

  @override
  String get topicsSelectTrack => 'Lernpfad wählen';

  @override
  String get topicsTrackStandard => 'Standard';

  @override
  String get topicsTrackStandardSub => 'Ausgewogener Lehrplan';

  @override
  String get topicsTrackGcseFoundation => 'Kantonalprüfung – Grundniveau';

  @override
  String get topicsTrackGcseFoundationSub => 'Grundlagen sicher beherrschen';

  @override
  String get topicsTrackGcseHigher => 'Kantonalprüfung – Erweitertes Niveau';

  @override
  String get topicsTrackGcseHigherSub => 'Anspruchsvollere Inhalte';

  @override
  String get topicsTrackOxford => 'Oxford-Pfad';

  @override
  String get topicsTrackOxfordSub => 'Vertiefung und Herausforderung';

  @override
  String get topicsPremiumComingSoon => 'Premium-Funktion';

  @override
  String get topicsPremiumLabel => 'PREMIUM';

  @override
  String get practiceChooseMode => 'Übungsmodus wählen';

  @override
  String get practiceModeLabel => 'Modus';

  @override
  String get practiceQuestionsLabel => 'Fragen';

  @override
  String get practiceStartButton => 'Übung starten';

  @override
  String get practiceModeQuickStart => 'Schnellstart';

  @override
  String get practiceModeQuickStartSub =>
      'Direkt mit einer kurzen Übung beginnen';

  @override
  String get practiceModeTopicDrill => 'Thementraining';

  @override
  String get practiceModeTopicDrillSub => 'Ein Thema gezielt üben';

  @override
  String get practiceModeTimedChallenge => 'Zeit-Challenge';

  @override
  String get practiceModeTimedChallengeSub => 'Gegen die Uhr üben';

  @override
  String get practiceModeExamSimulator => 'Prüfungssimulator';

  @override
  String get practiceModeExamSimulatorSub =>
      'Eine Prüfungssituation simulieren';

  @override
  String get practiceExit => 'Beenden';

  @override
  String practiceQuestionOf(int current, int total) {
    return 'Frage $current von $total';
  }

  @override
  String get practiceMixedReview => 'Gemischte Wiederholung';

  @override
  String get practiceExplanation => 'Erklärung';

  @override
  String get practiceCheckAnswer => 'Antwort prüfen';

  @override
  String get practiceNextQuestion => 'Nächste Frage';

  @override
  String get practiceFinishSession => 'Übung abschliessen';

  @override
  String get tutorBotName => 'TutorBot';

  @override
  String get tutorBotSubtitle =>
      'Tipps, Erklärungen und Schritt-für-Schritt-Begleitung.';

  @override
  String tutorFreeTipsLeft(int count) {
    return 'Kostenlose Tipps heute übrig: $count';
  }

  @override
  String get tutorChipExplain => 'Erkläre das';

  @override
  String get tutorChipHint => 'Gib mir einen Tipp';

  @override
  String get tutorChipSteps => 'Schritt für Schritt';

  @override
  String get tutorChipCheckMistake => 'Prüfe meinen Fehler';

  @override
  String get tutorInputHint => 'Frage den Tutor';

  @override
  String get tutorNeedMoreHelp => 'Brauchst du mehr Hilfe?';

  @override
  String get tutorUnlockDeeper =>
      'Tiefergehende Erklärungen – jetzt mit Premium freischalten.';

  @override
  String get tutorBuyCredits => 'Credits kaufen';

  @override
  String get tutorViewPacks => 'Pakete anzeigen';

  @override
  String get profileSettingsLabel => 'Einstellungen';

  @override
  String get profileAppearance => 'Darstellung';

  @override
  String get profileAppearanceSub => 'Passe das Erscheinungsbild an';

  @override
  String get profileAccessibility => 'Barrierefreiheit';

  @override
  String get profileAccessibilitySub => 'Bewegung und Textgrösse anpassen';

  @override
  String get profileSubscription => 'Abonnement';

  @override
  String get profileSubscriptionSub => 'Verwalte deinen Tarif';

  @override
  String get profileCurriculumSettings => 'Lehrplan';

  @override
  String get profileCurriculumSettingsSub => 'Wähle deinen Lernpfad';

  @override
  String get profilePrivacyData => 'Datenschutz und Daten';

  @override
  String get profilePrivacyDataSub => 'Verwalte deine lokalen Daten';

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String get profileSignOutSub => 'Von diesem Gerät abmelden';

  @override
  String profileVersionNumber(String version) {
    return 'Version $version';
  }

  @override
  String get profileCopyright => '© QuantumLab Intelligence';

  @override
  String get profileHeaderTitle => 'Profil';

  @override
  String get profileHeaderSubtitle => 'Einstellungen & Lernprofil.';

  @override
  String get profilePreferredDisplayName => 'Bevorzugter Anzeigename';

  @override
  String get profilePreferredDisplayNameNotSet => 'Nicht festgelegt';

  @override
  String get profileChangeDisplayName => 'Anzeigename ändern';

  @override
  String get profileGreetingPreview => 'Vorschau der Begrüssung';

  @override
  String get profileSwitchLearner => 'Lernende Person wechseln';

  @override
  String get profileDisplayNameDialogHint => 'z. B. Sam oder ein Spitzname';

  @override
  String get whoIsLearningTitle => 'Wer lernt heute?';

  @override
  String get whoIsLearningAddLearner => 'Lernende Person hinzufügen';

  @override
  String get whoIsLearningAddLearnerHint => 'Name der lernenden Person';

  @override
  String homeLearningAsLabel(String name) {
    return 'Lernt als: $name';
  }

  @override
  String get homeSwitchLearnerAction => 'Wechseln';

  @override
  String get helpHeaderTitle => 'Hilfe';

  @override
  String get helpHeaderSubtitle => 'Antworten und Unterstützung';

  @override
  String get helpFaqTitle => 'Häufig gestellte Fragen';

  @override
  String get helpFaq1Q => 'Wie starte ich eine Übung?';

  @override
  String get helpFaq1A =>
      'Wähle ein Thema oder einen Übungsmodus und tippe auf Übung starten.';

  @override
  String get helpFaq2Q => 'Wie funktioniert der Tutor?';

  @override
  String get helpFaq2A =>
      'Der Tutor bietet Tipps und Erklärungen für deine aktuelle Frage.';

  @override
  String get helpFaq3Q => 'Wo werden meine Daten gespeichert?';

  @override
  String get helpFaq3A =>
      'Derzeit unterstützt jede Installation ein Lernprofil. Learning Analytics und Fortschrittsberichte sind über Mehr oder Profil erreichbar.';

  @override
  String get helpFaq4Q => 'Wie kann ich die Sprache ändern?';

  @override
  String get helpFaq4A =>
      'Öffne dein Profil und wähle die Spracheinstellungen.';

  @override
  String get helpContactTitle => 'Kontakt';

  @override
  String get helpContactIntro => 'Brauchst du weitere Hilfe? Kontaktiere uns.';

  @override
  String get helpContactEmail => 'E-Mail-Support';

  @override
  String get helpPrivacyTitle => 'Datenschutz';

  @override
  String get helpPrivacyHeadline =>
      'Deine Daten bleiben unter deiner Kontrolle.';

  @override
  String get helpPrivacyBullet1 =>
      'Lokale Speicherung für Einstellungen und Fortschritt';

  @override
  String get helpPrivacyBullet2 =>
      'Keine Weitergabe deiner Daten ohne deine Zustimmung';

  @override
  String get helpPrivacyBullet3 => 'Learning Analytics verfügbar';

  @override
  String get helpPrivacyBullet4 => 'Elternwerkzeuge sind PIN-geschützt';

  @override
  String get helpTermsTitle => 'Nutzungsbedingungen';

  @override
  String get helpTermsBody =>
      'Nutze die App als Lernhilfe. Prüfe wichtige Entscheidungen mit einer Lehrperson oder einem Elternteil.';

  @override
  String get helpParentalTitle => 'Learning Analytics';

  @override
  String get helpParentalHeadline =>
      'Fortschritt verstehen, Lernlücken erkennen und den nächsten Schritt unterstützen.';

  @override
  String get helpParentalBullet1 => 'Fortschrittsübersicht';

  @override
  String get helpParentalBullet2 => 'Themenbeherrschung';

  @override
  String get helpParentalBullet3 => 'Lerntrends';

  @override
  String get helpParentalBullet4 => 'Empfohlene Übungen';

  @override
  String get helpReportButton => 'Problem melden';

  @override
  String get helpFooter =>
      'Minimale Daten. Keine Werbung. Learning Analytics verfügbar.';

  @override
  String get swissChooseLanguage => 'Schweiz · Sprache wählen';

  @override
  String get tutorChipDeepExplanation => 'Ausführliche Erklärung';

  @override
  String get tutorChipStepByStep => 'Schrittweise Lösung';

  @override
  String get tutorChipMistakeAnalysis => 'Fehleranalyse';

  @override
  String get tutorCreditBadge => '1 Credit';

  @override
  String tutorCreditBalance(int count) {
    return '$count Credits';
  }

  @override
  String get tutorProLabel => 'Premium';

  @override
  String get tutorExhaustedTitle => 'Kostenlose Tipps aufgebraucht';

  @override
  String get tutorExhaustedBody =>
      'Kaufe Credits, um weitere Tutor-Unterstützung zu erhalten.';

  @override
  String get tutorCreditRequired => 'Credit erforderlich';

  @override
  String get tutorPracticeContextLabel => 'Übt';

  @override
  String get tutorContextHint => 'Hinweis';

  @override
  String get tutorContextExplain => 'Erklärung';

  @override
  String homeGreetingMorningNamed(String name) {
    return 'Guten Morgen, $name';
  }

  @override
  String get homeGreetingMorningDefault => 'Guten Morgen';

  @override
  String homeGreetingAfternoonNamed(String name) {
    return 'Guten Tag, $name';
  }

  @override
  String get homeGreetingAfternoonDefault => 'Guten Tag';

  @override
  String homeGreetingEveningNamed(String name) {
    return 'Guten Abend, $name';
  }

  @override
  String get homeGreetingEveningDefault => 'Guten Abend';

  @override
  String homeGreetingNightNamed(String name) {
    return 'Willkommen zurück, $name';
  }

  @override
  String get homeGreetingNightDefault => 'Willkommen zurück';

  @override
  String get homeStreakGoalMessage => '· Noch 10 Minuten bis zum Serienziel';

  @override
  String get homeSectionContinueLearning => 'Weiterlernen';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String get homeSectionProgress => 'Fortschritt';

  @override
  String get homeStreakHeader => 'Serie';

  @override
  String get homeStreakFirstDay => 'Erster Tag deiner Serie';

  @override
  String get homeThisWeekHeader => 'Diese Woche';

  @override
  String get homeDaysActive => 'Aktive Tage';

  @override
  String get homeSectionAchievements => 'Erfolge';

  @override
  String get homeAchievementStreakTitle => 'Wöchentliche Serie erreicht!';

  @override
  String get homeAchievementStreakSubtitle => '7 Tage in Folge geübt';

  @override
  String get homeAchievementStreakLocked =>
      'Erreiche eine 7-Tage-Serie, um dies freizuschalten';

  @override
  String get homeSectionOxfordTrack => 'Oxford-Track';

  @override
  String get homePremiumRequired => 'PREMIUM ERFORDERLICH';

  @override
  String get homeOxfordTrackSubtitle =>
      'Vertiefung, anspruchsvolle Aufgaben & Wettbewerbsmathematik';

  @override
  String get homeSectionLearningPaths => 'Lernpfade';

  @override
  String get homeSectionExamPacks => 'Prüfungspakete';

  @override
  String get homeExamPacksSubtitle => 'Gezielte Prüfungsvorbereitung';

  @override
  String get homeViewExamPacks => 'Prüfungspakete ansehen';

  @override
  String get homeStartPracticeSession => 'Übungssession starten';

  @override
  String get onboardingWelcomeTitle =>
      'Mathematisches Denken entwickeln.\nPotenzial entfalten.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personalisiertes Lernen. Messbarer Fortschritt.';

  @override
  String get onboardingWhoLabel => 'WER NUTZT DIE APP?';

  @override
  String get onboardingStudentLabel => 'Ich bin Lernende oder Lernender';

  @override
  String get onboardingStudentSub =>
      'Übe Mathematik mit einem Lernweg, der auf dich ausgerichtet ist.';

  @override
  String get onboardingParentLabel => 'Ich unterstütze eine lernende Person';

  @override
  String get onboardingParentSub =>
      'Begleite jeden Schritt ihrer mathematischen Entwicklung.';

  @override
  String get onboardingTeacherLabel => 'Ich bin Lehrperson';

  @override
  String get onboardingTeacherSub =>
      'Verfolge den Fortschritt und weise deinen Lernenden Übungen zu.';

  @override
  String get onboardingSelectError => 'Bitte wähle eine Option';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingFooter =>
      'Minimale Daten. Keine Werbung. Learning Analytics verfügbar.';

  @override
  String get onboardingAccessibilityTitle => 'Angenehm lesbar gestalten';

  @override
  String get onboardingAccessibilitySub =>
      'Du kannst dies jederzeit in den Einstellungen ändern.';

  @override
  String get onboardingStageTitle =>
      'Auf welcher Stufe befindet sich der Schüler?';

  @override
  String get onboardingStageSub =>
      'Wir passen den Inhalt auf das richtige Niveau an';

  @override
  String get onboardingStageTitleParent => 'Niveau der lernenden Person wählen';

  @override
  String get onboardingStageSubParent =>
      'Wir passen die Inhalte an das aktuelle Niveau an.';

  @override
  String get onboardingStageCount => '4';

  @override
  String get onboardingStage1Label => 'Primarstufe (Kl. 3–6)';

  @override
  String get onboardingStage1Sub => 'Grundschulmathematik';

  @override
  String get onboardingStage2Label => 'Sekundarstufe I (Kl. 7–9)';

  @override
  String get onboardingStage2Sub => 'Weiterführende Mathematik';

  @override
  String get onboardingStage3Label => 'Sekundarstufe II (Kl. 10–11)';

  @override
  String get onboardingStage3Sub => 'Gymnasialmathematik';

  @override
  String get onboardingStage4Label => 'Gymnasium / Maturität (Kl. 12–13)';

  @override
  String get onboardingStage4Sub => 'Höhere Mathematik';

  @override
  String get onboardingGoalTitle => 'Was ist das Ziel?';

  @override
  String get onboardingGoalSub => 'Wähle den Lernfokus';

  @override
  String get onboardingGoalTitleParent => 'Wie möchtest du unterstützen?';

  @override
  String get onboardingGoalSubParent =>
      'Wähle den passenden Unterstützungsschwerpunkt.';

  @override
  String get onboardingGoal1Label => 'Schulunterstützung';

  @override
  String get onboardingGoal1Sub => 'Vertrauen über alle Lernstufen aufbauen';

  @override
  String get onboardingGoal2Label => 'Prüfungsvorbereitung';

  @override
  String get onboardingGoal2Sub => 'Gezielte Übungen & zeitgesteuerte Sets';

  @override
  String get onboardingGoal3Label => 'Oxford-Track';

  @override
  String get onboardingGoal3Sub => 'Vertiefung und Wettbewerbsmathematik';

  @override
  String get onboardingParentGoal1Label =>
      'Mathematisches Selbstvertrauen stärken';

  @override
  String get onboardingParentGoal1Sub =>
      'Ruhiges, regelmässiges Üben im eigenen Tempo unterstützen.';

  @override
  String get onboardingParentGoal2Label => 'Lernlücken erkennen';

  @override
  String get onboardingParentGoal2Sub =>
      'Themen finden, die zusätzliche Aufmerksamkeit brauchen.';

  @override
  String get onboardingParentGoal3Label => 'Fortschritt über Zeit verfolgen';

  @override
  String get onboardingParentGoal3Sub =>
      'Entwicklung und Regelmässigkeit anhand abgeschlossener Übungen sehen.';

  @override
  String get onboardingParentGoal4Label => 'Prüfungsvorbereitung unterstützen';

  @override
  String get onboardingParentGoal4Sub =>
      'Revision und Übung für kommende Prüfungen begleiten.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Wie möchtest du Math Intelligence nutzen?';

  @override
  String get onboardingGoalSubTeacher => 'Wähle den Fokus für deine Klasse.';

  @override
  String get onboardingTeacherGoal1Label => 'Fortschritt der Klasse verfolgen';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Sieh, wie sich deine Lernenden über die Zeit entwickeln.';

  @override
  String get onboardingTeacherGoal2Label => 'Übungen zuweisen';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Lege gezielte Übungssets für deine Lernenden fest.';

  @override
  String get onboardingTeacherGoal3Label => 'Prüfungsvorbereitung';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Unterstütze die Prüfungsvorbereitung mit gezielten Übungssets.';

  @override
  String get onboardingTeacherGoal4Label => 'Lehrplan erkunden';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Durchstöbere Themen und Musterlösungen, bevor du sie zuweist.';

  @override
  String get onboardingProfileTitle => 'Speichere deinen Fortschritt';

  @override
  String get onboardingProfileSub =>
      'Optional – du kannst dies jederzeit später in deinem Profil ändern.';

  @override
  String get onboardingDisplayNameLabel => 'Wie sollen wir dich nennen?';

  @override
  String get onboardingDisplayNameSub =>
      'Ein Spitzname reicht – das ist nur für deine Begrüssung.';

  @override
  String get onboardingDisplayNameHint => 'z. B. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Wie sollen wir deine lernende Person nennen?';

  @override
  String get onboardingLearnerNameSub => 'Personalisiert die Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel =>
      'Deine Beziehung zur lernenden Person';

  @override
  String get onboardingRelationshipParent => 'Elternteil';

  @override
  String get onboardingRelationshipGuardian => 'Erziehungsberechtigte/r';

  @override
  String get onboardingRelationshipGrandparent => 'Grosselternteil';

  @override
  String get onboardingRelationshipTutor => 'Tutor/in';

  @override
  String get onboardingRelationshipOther => 'Anderes Familienmitglied';

  @override
  String get onboardingParentEmailLabel =>
      'E-Mail der unterstützenden Person (optional)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Wird zur Kontoklarheit lokal auf diesem Gerät gespeichert.';

  @override
  String get onboardingPrivacyNote =>
      'Profildaten bleiben lokal. Für diese Version wird keine Cloud-Synchronisierung versprochen.';

  @override
  String get onboardingStartLearning => 'Lernen beginnen';

  @override
  String get onboardingSkipEmail => 'Vorerst überspringen';

  @override
  String get appearanceLanguageTitle => 'Sprache';

  @override
  String get appearanceLanguageSub => 'App-Anzeigesprache';

  @override
  String get upgradeTitle => 'Premium freischalten';

  @override
  String get upgradeBody =>
      'Schalte Premium-Funktionen mit einem Abonnement frei.';

  @override
  String get upgradeViewPacks => 'Prüfungspakete ansehen';

  @override
  String get upgradeMaybeLater => 'Vielleicht später';

  @override
  String get termsTitle => 'Nutzungsbedingungen';

  @override
  String get termsSub => 'Bitte vor der Nutzung lesen';

  @override
  String get tutorCreditComingSoon => 'In Prüfungspaketen verfügbar.';

  @override
  String get upgradeWhatsIncluded => 'Das ist enthalten';

  @override
  String get upgradeBenefit1Title => 'Unbegrenzter KI-Tutor';

  @override
  String get upgradeBenefit1Sub =>
      'Stelle unbegrenzt Fragen, erhalte Schritt-für-Schritt-Erklärungen und persönliche Hinweise ohne Kreditlimit.';

  @override
  String get upgradeBenefit2Title => 'Oxford-Kurs';

  @override
  String get upgradeBenefit2Sub =>
      'Zugang zum strukturierten Oxford-Lehrplan mit kuratierten Aufgabensets und geführtem Fortschritt von der Primarstufe bis zur Maturität.';

  @override
  String get upgradeBenefit3Title => 'Learning Analytics';

  @override
  String get upgradeBenefit3Sub =>
      'Verfolge deinen Fortschritt mit detaillierten Leistungsdiagrammen, Schwächenerkennung und personalisierten Lernempfehlungen.';

  @override
  String get upgradeComingSoonLabel => 'In Premium enthalten';

  @override
  String get upgradeComingSoon1 => 'Monatliche & jährliche Abonnementpläne';

  @override
  String get upgradeComingSoon2 => 'Familienkonten mit mehreren Profilen';

  @override
  String get upgradeComingSoon3 =>
      'Tägliche Serien-Erinnerungen & Push-Benachrichtigungen';

  @override
  String get upgradeComingSoon4 => 'Erfolge und Meilensteinbelohnungen';

  @override
  String get upgradeJoinEarlyAccess => 'Jetzt vormerken';

  @override
  String get upgradeEarlyAccessSnackbar =>
      'Wir benachrichtigen dich, sobald Premium verfügbar ist.';

  @override
  String get profileAboutLabel => 'Über die App';

  @override
  String get profileReleaseNotes => 'Versionshinweise';

  @override
  String get tutorEmptyTitle => 'Noch keine Nachrichten';

  @override
  String get tutorEmptySubtitle =>
      'Stelle eine Frage zu einem beliebigen Thema und dein KI-Tutor hilft dir Schritt für Schritt.';

  @override
  String get homeStreakDays => '5 Tage in Folge';

  @override
  String get homeAchievementUnlocked => 'Freigeschaltet';

  @override
  String get homeBadgeLocked => 'Gesperrt';

  @override
  String get homeWhatsNewTitle => 'Neu in v1.0';

  @override
  String get homeWhatsNewBody =>
      'KI-Tutor, Oxford-Kurs und neue Prüfungspakete sind jetzt verfügbar.';

  @override
  String get homeDailyGoalTitle => 'Tagesziel';

  @override
  String get homeDailyGoalSubtitle => 'Löse heute 15 Aufgaben';

  @override
  String homeDailyGoalProgress(int completed, int target) {
    return '$completed / $target abgeschlossen';
  }

  @override
  String get tutorHowItWorksTitle => 'So funktioniert der Tutor';

  @override
  String get tutorHowItWorksStep1Title => 'Stell eine Frage';

  @override
  String get tutorHowItWorksStep1Sub =>
      'Tippe eine Matheaufgabe ein oder wähle oben eine Schnellaktion.';

  @override
  String get tutorHowItWorksStep2Title =>
      'Schritt-für-Schritt-Antwort erhalten';

  @override
  String get tutorHowItWorksStep2Sub =>
      'Die KI erklärt die Lösung so, dass du jeden Schritt verstehst.';

  @override
  String get tutorHowItWorksStep3Title => 'Wende es an';

  @override
  String get tutorHowItWorksStep3Sub =>
      'Geh zur Übungsseite und wende das Gelernte an.';

  @override
  String get practiceSummaryTitle => 'Sitzung abgeschlossen';

  @override
  String practiceSummaryAccuracy(int percent) {
    return '$percent% Genauigkeit';
  }

  @override
  String practiceSummaryCorrect(int correct, int total) {
    return '$correct / $total richtig';
  }

  @override
  String get practiceSummaryEncouragement =>
      'Gut gemacht. Regelmässiges Üben bringt dauerhaften Fortschritt.';

  @override
  String get practiceSummaryClose => 'Zurück zur Übung';

  @override
  String get helpFeatureRequestButton => 'Funktion anfragen';

  @override
  String get helpFeatureRequestSnackbar =>
      'Funktionsanfragen kommen bald — danke für dein Interesse!';

  @override
  String get helpReportSnackbar =>
      'Danke für deine Meldung! Wir schauen es uns bald an.';

  @override
  String get mentalMathVaultTitle => 'Kopfrechnen-Tresor';

  @override
  String get mentalMathVaultSubtitle => 'Lerne starke Rechentricks';

  @override
  String get comingSoon => 'Demnächst';

  @override
  String get dailyBrainTeaser => 'Tägliches Zahlenrätsel';

  @override
  String get revealAnswer => 'Antwort zeigen';

  @override
  String get captainNumberFuel => 'Captain Numbers Energie';

  @override
  String get dailyMissionTitle => 'Captain Number braucht Energie!';

  @override
  String get dailyMissionSubtitle => 'Löse 5 Aufgaben für die heutige Mission.';

  @override
  String get workedExample => 'Gelöstes Beispiel';

  @override
  String get practiceExample => 'Übungsbeispiel';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get practiceNoQuestions => 'Es sind keine Übungsaufgaben verfügbar.';

  @override
  String get mascotGreeting => 'Bereit für neue Mathe-Energie?';

  @override
  String get mascotThinking => 'Nimm dir Zeit und denk gut nach!';

  @override
  String get mascotSuccess => 'Stark gerechnet! Energie hinzugefügt.';

  @override
  String get mascotEncouragement => 'Gut versucht. Die nächste schaffst du!';

  @override
  String get mascotLevelUp => 'Mission aufgeladen! Captain Number ist bereit!';

  @override
  String get homeTopicFractionsTitle => 'Brüche und Prozente';

  @override
  String get homeTopicFractionsSubtitle => 'Grundlagen und Umwandlungen';

  @override
  String get homeTopicAlgebraTitle => 'Algebra-Grundlagen';

  @override
  String get homeTopicAlgebraSubtitle => 'Gleichungen und Variablen';

  @override
  String get homeTopicStatisticsTitle => 'Statistik und Wahrscheinlichkeit';

  @override
  String get homeTopicStatisticsSubtitle => 'Daten und Zufall';

  @override
  String get homeLearningFractionsTitle => 'Brüche';

  @override
  String get homeLearningFractionsSubtitle => 'Brüche und Umwandlungen lernen';

  @override
  String get homeLearningStatisticsTitle => 'Statistik';

  @override
  String get homeLearningStatisticsSubtitle =>
      'Einführung in Daten und Wahrscheinlichkeit';

  @override
  String get topicsStandardSelected => 'Standardpfad ausgewählt.';

  @override
  String get topicsNoResults => 'Keine Themen gefunden';

  @override
  String get topicsClearFilters => 'Filter löschen';

  @override
  String get examPacksCtaSubtitle =>
      'Schalte GCSE-Stufen, den Oxford-Pfad und Tutor-Guthaben frei.';

  @override
  String get examPacksIntro =>
      'Wähle ein Paket für gezieltes Üben und Tutor-Unterstützung.';

  @override
  String examPackSelected(String stage) {
    return '$stage ausgewählt';
  }

  @override
  String get examPackKs2Title => 'KS2 Mathematik';

  @override
  String get examPackKs3Title => 'KS3 Mathematik';

  @override
  String get examPackKs4Title => 'KS4 GCSE Mathematik';

  @override
  String get examPackKs5Title => 'KS5 Mathematik';

  @override
  String get examPackPrimarySubtitle => 'Übungen für die Primarstufe';

  @override
  String get examPackSecondarySubtitle => 'Übungen für die Sekundarstufe';

  @override
  String get examPackGcseSubtitle => 'GCSE-Vorbereitung';

  @override
  String get examPackAdvancedSubtitle => 'Fortgeschrittene Mathematikübungen';

  @override
  String get examPackTutorCreditsTitle => 'Tutor-Guthaben';

  @override
  String get examPackTutorCreditsSubtitle =>
      'Zusätzliche Hinweise, Erklärungen und Schritt-für-Schritt-Hilfe';

  @override
  String get examPackIncluded => 'Enthalten';

  @override
  String get examPackTopUp => 'Aufladen';

  @override
  String homeStreakCount(int days) {
    return '$days Tage in Folge';
  }

  @override
  String homeMilestone(int days) {
    return '$days-Tage-Meilenstein';
  }

  @override
  String get homeRewardsOn => 'Belohnungen an';

  @override
  String get homeRewardsOff => 'Belohnungen aus';

  @override
  String get homeBadgeFirstSession => 'Erste Übung';

  @override
  String get homeBadgeTenQuestions => '10 Aufgaben';

  @override
  String get homeBadgeAlgebraStarter => 'Algebra-Einstieg';

  @override
  String get homeContinueKs2Topic => 'Brüche';

  @override
  String get homeContinueKs2Subtopic => 'Gleichwertige Brüche';

  @override
  String get homeContinueKs3Topic => 'Algebra';

  @override
  String get homeContinueKs3Subtopic => 'Gleichungen lösen';

  @override
  String get homeContinueKs4Topic => 'GCSE-Mathematik';

  @override
  String get homeContinueKs4Subtopic => 'Quadratische Funktionen';

  @override
  String get homeContinueKs5Topic => 'Reine Mathematik';

  @override
  String get homeContinueKs5Subtopic => 'Differenzieren';

  @override
  String get quietStudyModeLabel => 'Ruhiger Lernmodus';

  @override
  String get quietStudyModeTooltip =>
      'Inspiriert von Nyepi, einer balinesischen Tradition der Reflexion, Stille und Konzentration.';

  @override
  String nextUp(String topic) {
    return 'Als Nächstes: $topic';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsParentToolsRewards =>
      'Learning Analytics und Belohnungsanimationen';

  @override
  String get enableParentTools => 'Learning Analytics aktivieren';

  @override
  String get parentToolsLocalOnly => 'Lokale Learning Analytics erlauben';

  @override
  String get unlockParentTools => 'Learning Analytics entsperren';

  @override
  String get parentToolsPinPrompt =>
      'Lokale 4-stellige PIN für Learning Analytics erstellen oder eingeben.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

  @override
  String get createParentPin => 'Eltern-PIN erstellen';

  @override
  String get parentPinStorageNotice =>
      'Die 4-stellige PIN wird lokal als SHA-256-Hash gespeichert. Keine Daten verlassen dieses Gerät.';

  @override
  String get fourDigitPin => '4-stellige PIN';

  @override
  String get openCheatSheet => 'Merkblatt öffnen';

  @override
  String get unlockWithPremium => 'Mit Premium entsperren';

  @override
  String get rewardsAnimations => 'Belohnungsanimationen';

  @override
  String get rewardsAnimationsSubtitle =>
      'Feiern nach richtigen Antworten und Meilensteinen anzeigen';

  @override
  String get premiumLabel => 'Premium';

  @override
  String get rewardsLabel => 'Belohnungen';

  @override
  String get premiumFeature => 'Premium-Funktion';

  @override
  String get includedInPremium => 'In Premium enthalten';

  @override
  String get availableInExamPacks => 'In Prüfungspaketen verfügbar';

  @override
  String get unlockWithSubscription => 'Mit Abonnement entsperren';

  @override
  String get enterParentPin => 'Eltern-PIN eingeben';

  @override
  String get resetParentPin => 'Eltern-PIN zurücksetzen';

  @override
  String get currentPin => 'Aktuelle PIN';

  @override
  String get resetLabel => 'Zurücksetzen';

  @override
  String get vaultLoadError => 'Das Archiv konnte nicht geladen werden.';

  @override
  String get pinMustBeFourDigits => 'Bitte genau 4 Ziffern eingeben.';

  @override
  String get pinIncorrect => 'Falsche PIN.';

  @override
  String get pinResetFailed => 'PIN-Zurücksetzung fehlgeschlagen.';

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge => 'Powered by Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Mathematisches Denken entwickeln.\nPotenzial entfalten.';

  @override
  String get onboardingSupportingStatement =>
      'Personalisiertes Lernen.\nMessbarer Fortschritt.';

  @override
  String get onboardingRoleClarification =>
      'Für Eltern, Erziehungsberechtigte, Lehrpersonen, Tutorinnen und Tutoren sowie Homeschooling-Familien.';

  @override
  String get onboardingCreateAccount => 'Konto erstellen';

  @override
  String get onboardingCreateAccountSub =>
      'Speichert Fortschritt, Maths-Journey-Daten und Erfolge auf diesem Gerät.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Fortschritt verstehen, Lernlücken erkennen und den nächsten Schritt unterstützen.';

  @override
  String get learningAnalyticsEmptyState =>
      'Schliesse eine Übungseinheit ab, um Learning Analytics aufzubauen.';

  @override
  String get exploreMathIntelligenceTitle => 'Math Intelligence entdecken';

  @override
  String get exploreHeaderSubtitle =>
      'Was Math Intelligence heute bietet – und was als Nächstes kommt.';

  @override
  String get exploreAvailableTodaySection => 'HEUTE VERFÜGBAR';

  @override
  String get exploreInAtelierSection => 'IN ATELIER';

  @override
  String get exploreInAtelierBadge => 'In Atelier';

  @override
  String get exploreInDevelopmentNote =>
      'Diese Funktion befindet sich derzeit in der Entwicklung.';

  @override
  String get exploreRoadmapTitle => 'Entwicklungsphilosophie';

  @override
  String get exploreRoadmapBody =>
      'Math Intelligence ist so konzipiert, dass es sich stetig weiterentwickelt. Einige Funktionen sind bereits heute verfügbar. Andere befinden sich derzeit in Entwicklung und werden vor der Veröffentlichung getestet.';

  @override
  String get explorePersonalisedPracticeTitle => 'Personalisiertes Üben';

  @override
  String get explorePersonalisedPracticeBody =>
      'Adaptive Übungssitzungen, angepasst an dein gewähltes Niveau und deine Lernziele.';

  @override
  String get exploreTopicLearningTitle => 'Themenlernen';

  @override
  String get exploreTopicLearningBody =>
      'Konzentriere dich auf einzelne mathematische Themen.';

  @override
  String get exploreTimedChallengesTitle => 'Zeitchallenges';

  @override
  String get exploreTimedChallengesBody =>
      'Entwickle Tempo und Selbstvertrauen.';

  @override
  String get exploreExamSimulatorTitle => 'Prüfungssimulator';

  @override
  String get exploreExamSimulatorBody =>
      'Übe mit strukturierten Prüfungssitzungen.';

  @override
  String get exploreMathsJourneyTitle => 'Meine Maths Journey';

  @override
  String get exploreMathsJourneyBody =>
      'Verfolge deine Lernreise über die Zeit.';

  @override
  String get exploreLearningAnalyticsBody =>
      'Verfolge den Fortschritt und erkenne Entwicklungsmöglichkeiten.';

  @override
  String get exploreFormulaLibraryBody => 'Schnelle Referenz, auch offline.';

  @override
  String get explorePhotoUploadTitle => 'Foto-Aufgaben-Upload';

  @override
  String get explorePhotoUploadBody =>
      'Lade Arbeitsblätter, Lehrbuchseiten oder Prüfungsaufgaben hoch.';

  @override
  String get exploreMarkMyPaperTitle => 'Meine Arbeit bewerten lassen';

  @override
  String get exploreMarkMyPaperBody =>
      'Erhalte strukturiertes Feedback zu abgeschlossenen Arbeiten.';

  @override
  String get exploreExaminerIntelligenceTitle => 'Prüfer-Einblicke';

  @override
  String get exploreExaminerIntelligenceBody =>
      'Erfahre, wie Prüfer Punkte vergeben und häufige Fehler erkennen.';

  @override
  String get exploreAdaptiveStudyPlansTitle => 'Adaptive Lernpläne';

  @override
  String get exploreAdaptiveStudyPlansBody =>
      'Personalisierte Lernempfehlungen auf Basis deiner Lernreise.';

  @override
  String get exploreTutorConversationsTitle => 'Tutor-Gespräche';

  @override
  String get exploreTutorConversationsBody =>
      'Mathematische Begleitung in natürlicher Sprache.';

  @override
  String get journeyCardTitleDefault => 'Meine Maths Journey';

  @override
  String journeyCardTitleNamed(String name) {
    return '${name}s Maths Journey';
  }

  @override
  String get journeyCardCurrentFocusLabel => 'Aktueller Fokus';

  @override
  String get journeyCardGettingStarted => 'Los geht\'s';

  @override
  String get journeyCardCurrentStreakLabel => 'Aktuelle Serie';

  @override
  String get journeyCardStartStreakToday => 'Starte heute deine Serie';

  @override
  String journeyCardStreakDays(int days) {
    return '$days-Tage-Serie';
  }

  @override
  String get journeyCardNextMilestoneLabel => 'Nächster Meilenstein';

  @override
  String journeyCardDaysToMilestoneOne(int milestone) {
    return 'Noch 1 Tag bis zu deiner $milestone-Tage-Serie';
  }

  @override
  String journeyCardDaysToMilestoneMany(int days, int milestone) {
    return 'Noch $days Tage bis zu deiner $milestone-Tage-Serie';
  }

  @override
  String get journeyCardAllMilestonesReached =>
      'Du hast jeden Serien-Meilenstein erreicht!';

  @override
  String get journeyCardGoalConfidence => 'Du baust Selbstvertrauen auf';

  @override
  String get journeyCardGoalSchool => 'Du verbesserst deine Schulmathematik';

  @override
  String get journeyCardGoalExams => 'Du bereitest dich auf Prüfungen vor';

  @override
  String get journeyCardGoalChallenge => 'Du löst Herausforderungsaufgaben';

  @override
  String get journeyCardGoalParentGaps => 'Du findest Lernlücken';

  @override
  String get journeyCardGoalParentProgress =>
      'Du verfolgst den Fortschritt über die Zeit';

  @override
  String get journeyCardGoalParentGcse =>
      'Du bereitest dich auf die GCSE-Prüfung vor';

  @override
  String get journeyCardGoalTeacherMonitor =>
      'Du verfolgst den Fortschritt der Klasse';

  @override
  String get journeyCardGoalTeacherAssign => 'Du weist Übungen zu';

  @override
  String get journeyCardGoalTeacherExplore => 'Du erkundest den Lehrplan';

  @override
  String get mathStudioNavCardTitle => 'Math Studio';

  @override
  String get mathStudioNavCardSubtitle =>
      'Entdecke die Mathematik, die du schon kennst';

  @override
  String get mathStudioHubTitle => 'Math Studio';

  @override
  String get mathStudioHubTagline =>
      'Entdecke die Mathematik, die du dein ganzes Leben lang schon nutzt.';

  @override
  String get mathStudioBuildConfidenceTitle => 'Selbstvertrauen aufbauen';

  @override
  String get mathStudioBuildConfidenceSubtitle =>
      'Sanftes, unbefristetes Ueben mit ausfuehrlichen Erklaerungen';

  @override
  String get mathStudioMentalMathsTitle => 'Kopfrechnen';

  @override
  String get mathStudioMentalMathsSubtitle =>
      'Taegliche Zahlenstrategien, ganz ohne Druck';

  @override
  String get mathStudioVisualMathsTitle => 'Visuelle Mathematik';

  @override
  String get mathStudioVisualMathsSubtitle =>
      'Mathematik durch bewegliche Modelle erleben';

  @override
  String get mathStudioDiscoveryTitle => 'Entdeckungsbibliothek';

  @override
  String get mathStudioDiscoverySubtitle =>
      'Mathematik aus dem echten Leben, Karte fuer Karte';

  @override
  String get mathStudioMathMagicTitle => 'Mathe & Magie';

  @override
  String get mathStudioMathMagicSubtitle =>
      'Raetsel, Muster und verblueffende mathematische Ueberraschungen';

  @override
  String get mathStudioMathMagicBody =>
      'Denksportaufgaben, Zahlentricks und mathematische Kuriositaeten';

  @override
  String get mathStudioSpatialIntelligenceTitle => 'Raeumliches Denken';

  @override
  String get mathStudioSpatialIntelligenceSubtitle =>
      'Entwickle dein Gefuehl fuer Form, Raum und Bewegung';

  @override
  String get mathStudioSpatialIntelligenceBody =>
      'Wuerfelnetze, Drehungen, Transformationen und Raumraetsel';

  @override
  String get mathStudioInDevelopmentBadge => 'In Entwicklung';

  @override
  String get mathStudioInDevelopmentNote =>
      'Dieser Bereich wird noch aufgebaut - schau bald wieder vorbei fuer neue Inhalte.';

  @override
  String get mathStudioSpatialCubeActivitiesLabel => 'Wuerfelaufgaben';

  @override
  String get mathStudioSpatialRotationsLabel => 'Drehungen';

  @override
  String get mathStudioSpatialTransformationsLabel => 'Transformationen';

  @override
  String get mathStudioSpatialPuzzlesLabel => 'Raumraetsel';

  @override
  String get mathStudioFeaturedFormatsSectionLabel => 'Ausgewaehlte Formate';

  @override
  String get mathStudioRelatedLabsSectionLabel => 'Verwandte Labore';

  @override
  String get mathStudioSpatialLabsEntrySubtitle =>
      'Probiere Flight Path Lab und weitere praktische Werkzeuge fuer raeumliches Denken aus';

  @override
  String get mathStudioDiscoveryEmptyCategory =>
      'Weitere Karten fuer diese Kategorie folgen bald.';

  @override
  String get mathStudioCategoryEverydayLife => 'Alltag';

  @override
  String get mathStudioCategoryShopping => 'Einkaufen';

  @override
  String get mathStudioCategoryCooking => 'Kochen';

  @override
  String get mathStudioCategorySports => 'Sport';

  @override
  String get mathStudioCategoryAviation => 'Luftfahrt';

  @override
  String get mathStudioCategoryTruckingLogistics => 'Transport & Logistik';

  @override
  String get mathStudioCategoryHealthcare => 'Gesundheitswesen';

  @override
  String get mathStudioCategoryEngineeringConstruction => 'Technik & Bauwesen';

  @override
  String get mathStudioCategoryArtDesign => 'Kunst & Design';

  @override
  String get mathStudioCategoryGaming => 'Gaming';

  @override
  String get mathStudioCategoryBusinessFinance => 'Wirtschaft & Finanzen';

  @override
  String get mathStudioCategoryAll => 'Alle';

  @override
  String get mathStudioDifficultyFoundation => 'Grundlagen';

  @override
  String get mathStudioDifficultyIntermediate => 'Mittel';

  @override
  String get mathStudioDifficultyAdvanced => 'Fortgeschritten';

  @override
  String get mathStudioThinkLabel => 'Ueberlege in Ruhe';

  @override
  String get mathStudioRevealButton => 'Loesung anzeigen';

  @override
  String get mathStudioRevealedLabel => 'Ausfuehrliche Loesung';

  @override
  String get mathStudioWhereYoullUseThisLabel => 'Wo du das brauchst';

  @override
  String get mathStudioFollowUpLabel => 'Probier es selbst';

  @override
  String get mathStudioFollowUpCheckButton => 'Antwort pruefen';

  @override
  String get mathStudioFollowUpCorrect => 'Gut gemacht — das stimmt.';

  @override
  String get mathStudioFollowUpTryAgain =>
      'Noch nicht ganz — schau dir die Schritte oben nochmal an.';

  @override
  String get mathStudioFollowUpAnswerLabel => 'Antwort';

  @override
  String get mathStudioExportButton => 'Drucken oder teilen';

  @override
  String get mathStudioExportChallengeOnly => 'Aufgabenblatt';

  @override
  String get mathStudioExportSolutionOnly => 'Loesungsblatt';

  @override
  String get mathStudioExportCombined => 'Aufgabe + Loesung';

  @override
  String get mathStudioExportIncludeNameLabel =>
      'Meinen Namen auf diesem Export anzeigen';

  @override
  String get mathStudioExportShareAction => 'Teilen';

  @override
  String get captainMathCurious =>
      'Hier gibt es etwas zu entdecken — schau mal.';

  @override
  String get captainMathEncouraging => 'Gut mitgedacht — weiter so.';

  @override
  String get captainMathCalm =>
      'Sieh mal, wie das mit etwas anderem zusammenhaengt.';

  @override
  String get captainMathCelebrating => 'Gut gemacht!';

  @override
  String get mentalMathsCategoryNumberBonds => 'Zahlenpaare';

  @override
  String get mentalMathsCategoryDecomposition => 'Zerlegen';

  @override
  String get mentalMathsCategoryCompensation => 'Ausgleichen';

  @override
  String get mentalMathsCategoryEstimation => 'Schaetzen';

  @override
  String get mentalMathsCategoryMultiplicationStrategies =>
      'Multiplikationsstrategien';

  @override
  String get mentalMathsCategoryDivisionStrategies => 'Divisionsstrategien';

  @override
  String get mentalMathsCategoryPercentages => 'Prozente';

  @override
  String get mentalMathsCategoryFractions => 'Brueche';

  @override
  String get mentalMathsCategoryPlaceValue => 'Stellenwert';

  @override
  String get mentalMathsCategoryPatternRecognition => 'Muster erkennen';

  @override
  String get mentalMathsTodaysChallenge => 'Heutige Aufgabe';

  @override
  String get mentalMathsUntimedNote =>
      'Kein Timer — nimm dir die Zeit, die du brauchst.';

  @override
  String buildConfidenceProgress(int current, int total) {
    return 'Frage $current von $total';
  }

  @override
  String get buildConfidenceContinueButton => 'Weiter';

  @override
  String get buildConfidenceCompletionTitle => 'Gut gemacht';

  @override
  String get buildConfidenceCompletionBody =>
      'Du hast die heutige Sitzung in deinem eigenen Tempo durchgearbeitet. Komm zurueck, wann immer du bereit fuer die naechste bist.';

  @override
  String get buildConfidenceDoneButton => 'Fertig';

  @override
  String get visualMathsNumberLineTitle => 'Zahlenstrahl';

  @override
  String get visualMathsNumberLineSubtitle =>
      'Ziehe den Punkt, um Zahlen auf einem Strahl zu erkunden';

  @override
  String get visualMathsFractionBarsTitle => 'Bruchbalken';

  @override
  String get visualMathsFractionBarsSubtitle =>
      'Vergleiche Brueche als Balken, nebeneinander';

  @override
  String get visualMathsAbacusTitle => 'Animierter Abakus';

  @override
  String get visualMathsAbacusSubtitle =>
      'Sieh Stellenwert in Aktion, Perle fuer Perle';

  @override
  String get visualMathsPlaceValueTitle => 'Stellenwert-Explorer';

  @override
  String get visualMathsPlaceValueSubtitle =>
      'Zerlege Zahlen nach ihrem Stellenwert';

  @override
  String get visualMathsInteractiveBadge => 'Interaktiv';

  @override
  String get visualMathsPreviewBadge => 'Vorschau';

  @override
  String get visualMathsComingSoonNote =>
      'Interaktive Version folgt in einer zukuenftigen Version.';

  @override
  String get visualMathsTryAnotherExample => 'Anderes Beispiel probieren';

  @override
  String get numberLineExampleBasicWholeNumber =>
      'Eine ganze Zahl auf einem Strahl von 0 bis 10';

  @override
  String get numberLineExampleNegativeNumber =>
      'Eine negative Zahl auf einem Strahl von −10 bis 10';

  @override
  String get numberLineExampleSimpleFraction =>
      'Ein Bruch auf einem Strahl von 0 bis 1';

  @override
  String get numberLineExampleDecimal =>
      'Eine Dezimalzahl auf einem Strahl von 0 bis 5';

  @override
  String get fractionBarsCaption1 =>
      '1/2 ist genau die Haelfte des ganzen Balkens.';

  @override
  String get fractionBarsCaption2 =>
      '2/4 deckt dieselbe Laenge wie 1/2 ab — aequivalente Brueche.';

  @override
  String get fractionBarsCaption3 =>
      '3/4 ist mehr als die Haelfte, weniger als das Ganze.';

  @override
  String get fractionBarsCaption4 =>
      '5/8 ist knapp mehr als die Haelfte des ganzen Balkens.';

  @override
  String get abacusCaption1 =>
      'Eine verschobene Perle in der Einerspalte steht fuer 1.';

  @override
  String get abacusCaption2 =>
      'Zehn Einer werden zu einer Perle in der Zehnerspalte umgruppiert.';

  @override
  String get abacusCaption3 =>
      'Eine Perle in der Hunderterspalte ist 100 Einer wert.';

  @override
  String get placeValueCaption1 =>
      '3742 zerlegt sich in 3 Tausender, 7 Hunderter, 4 Zehner, 2 Einer.';

  @override
  String get placeValueCaption2 => '6.4 zerlegt sich in 6 Einer und 4 Zehntel.';

  @override
  String get placeValueCaption3 =>
      '805 zerlegt sich in 8 Hunderter, 0 Zehner, 5 Einer — die 0 haelt die Zehnerstelle.';

  @override
  String get abacusColumnHundreds => 'Hunderter';

  @override
  String get abacusColumnTens => 'Zehner';

  @override
  String get abacusColumnOnes => 'Einer';

  @override
  String get mathStudioRecallCardsTitle => 'Merkkarten';

  @override
  String get mathStudioRecallCardsSubtitle =>
      'Schnelles Abrufen fuer die Fakten, die du behalten musst';

  @override
  String get recallCardsHubTitle => 'Merkkarten';

  @override
  String get recallCardsHubSubtitle =>
      'Kurzes, gezieltes Training fuer Formeln, Begriffe, Symbole und die Ideen dahinter';

  @override
  String get recallCardsQuickReviewTitle => 'Fuenf-Karten-Schnellwiederholung';

  @override
  String get recallCardsQuickReviewSubtitle =>
      'Eine kurze taegliche Auswahl, fuer dich zusammengestellt';

  @override
  String get recallCardsReviewDueTitle => 'Faellige Wiederholung';

  @override
  String recallCardsReviewDueCount(int count) {
    return '$count zur Wiederholung faellig';
  }

  @override
  String get recallCardsReviewDueEmpty => 'Gerade nichts faellig — gut gemacht';

  @override
  String get recallCardsBrowseByTopicTitle => 'Nach Thema durchsuchen';

  @override
  String get recallCardsBrowseByTypeTitle => 'Nach Kartentyp durchsuchen';

  @override
  String get recallCardsSearchTitle => 'Suche';

  @override
  String get recallCardsSearchHint => 'Formeln, Begriffe und Ideen suchen';

  @override
  String get recallCardsBookmarksTitle => 'Lesezeichen';

  @override
  String get recallCardsEmptyBookmarks =>
      'Noch keine Lesezeichen — tippe auf das Lesezeichen-Symbol einer Karte, um sie hier zu speichern';

  @override
  String get recallCardsNoResults => 'Keine Karten gefunden';

  @override
  String get recallCardsRevealButton => 'Antwort anzeigen';

  @override
  String get recallCardsRevealedLabel => 'Antwort';

  @override
  String get recallCardsExplainLabel => 'Warum das funktioniert';

  @override
  String get recallCardsCommonMistakeLabel => 'Haeufiger Fehler';

  @override
  String get recallCardsConnectLabel => 'Wo das verwendet wird';

  @override
  String get recallCardsRelatedDiscoveryLabel => 'Verwandte Entdeckerkarten';

  @override
  String get recallCardsRelatedPracticeLabel => 'Verwandte Uebungen';

  @override
  String get recallCardsRelatedLabsLabel => 'Verwandte interaktive Labore';

  @override
  String get recallCardsLabComingSoon => 'Demnaechst verfuegbar';

  @override
  String get recallCardsRememberedButton => 'Das wusste ich noch';

  @override
  String get recallCardsNotYetButton => 'Noch nicht';

  @override
  String get recallCardsAskMeTomorrowButton => 'Morgen nochmal fragen';

  @override
  String get recallCardsBookmarkAdd => 'Diese Karte mit Lesezeichen versehen';

  @override
  String get recallCardsBookmarkRemove => 'Lesezeichen entfernen';

  @override
  String get recallCardsExportButton => 'Drucken oder teilen';

  @override
  String get recallCardsExportFiveCardSheet => 'Merkblatt (nur Fragen)';

  @override
  String get recallCardsExportAnswerSheet => 'Antwortblatt';

  @override
  String get recallCardsSessionComplete => 'Sitzung abgeschlossen';

  @override
  String get recallCardsSessionCompleteSubtitle =>
      'Gut gemacht — komm morgen fuer mehr wieder';

  @override
  String recallCardsCardOf(int current, int total) {
    return 'Karte $current von $total';
  }

  @override
  String get recallCardsStateNew => 'Neu';

  @override
  String get recallCardsStateLearning => 'Lernphase';

  @override
  String get recallCardsStateReviewDue => 'Wiederholung faellig';

  @override
  String get recallCardsStateMastered => 'Gemeistert';

  @override
  String get recallCardsTypeFormula => 'Formel';

  @override
  String get recallCardsTypeMeaning => 'Bedeutung';

  @override
  String get recallCardsTypeSymbol => 'Symbol';

  @override
  String get recallCardsTypeVocabulary => 'Fachbegriff';

  @override
  String get recallCardsTypeStrategy => 'Strategie';

  @override
  String get recallCardsTypeMisconception => 'Haeufiger Irrtum';

  @override
  String get recallCardsTypeVisual => 'Visuell';

  @override
  String get recallCardsTypeRealWorldConnection => 'Alltagsbezug';

  @override
  String get recallCardsTopicNumber => 'Zahlen';

  @override
  String get recallCardsTopicRatioAndProportion => 'Verhaeltnis & Proportion';

  @override
  String get recallCardsTopicAlgebra => 'Algebra';

  @override
  String get recallCardsTopicGeometryAndMeasures => 'Geometrie & Masse';

  @override
  String get recallCardsTopicStatistics => 'Statistik';

  @override
  String get recallCardsTopicProbability => 'Wahrscheinlichkeit';

  @override
  String get mathStudioInteractiveLabsTitle => 'Interaktive Labore';

  @override
  String get mathStudioInteractiveLabsSubtitle =>
      'Praktische Mathematik zum Anfassen, Veraendern und Testen';

  @override
  String get labsHubTitle => 'Interaktive Labore';

  @override
  String get labsHubSubtitle =>
      'Ein Konzept sehen, anfassen, veraendern und deine Vermutung testen';

  @override
  String get labsResetButton => 'Zuruecksetzen';

  @override
  String get labsCheckButton => 'Pruefen';

  @override
  String get labsNextChallengeButton => 'Weiter';

  @override
  String get labsFeedbackCorrect => 'Gut gemacht — das stimmt.';

  @override
  String get labsFeedbackTryAgain => 'Noch nicht ganz — versuch es nochmal.';

  @override
  String get labsRelatedRecallCardsLabel => 'Verwandte Merkkarten';

  @override
  String get labsFractionBuilderTitle => 'Bruch-Baukasten';

  @override
  String get labsFractionBuilderSubtitle =>
      'Baue einen Bruch, indem du gleiche Teile fuellst';

  @override
  String get labsFractionBuilderConcept =>
      'Ein Bruch zaehlt gleiche Teile eines Ganzen. Tippe auf Segmente, um sie zu fuellen und den Zielbruch zu erreichen.';

  @override
  String get labsFractionBuilderWhereUsed =>
      'Essen gerecht teilen, Rezepte lesen und Zutaten abmessen beruhen alle auf Bruechen eines Ganzen.';

  @override
  String labsFractionBuilderPrompt(int numerator, int denominator) {
    return 'Fuelle $numerator von $denominator Segmenten.';
  }

  @override
  String labsFractionBuilderFilledCount(int filled, int denominator) {
    return '$filled von $denominator gefuellt';
  }

  @override
  String get labsAlgebraBalanceTitle => 'Algebra-Waage';

  @override
  String get labsAlgebraBalanceSubtitle =>
      'Halte beide Seiten gleich, um x zu loesen';

  @override
  String get labsAlgebraBalanceConcept =>
      'Eine Gleichung bleibt nur wahr, wenn du auf beiden Seiten dasselbe tust. Vereinfache Schritt fuer Schritt, bis x allein steht.';

  @override
  String get labsAlgebraBalanceWhereUsed =>
      'Von einer Summe rueckwaerts zu einer unbekannten Menge zu rechnen nutzt genau dieses Gleichgewichtsprinzip.';

  @override
  String labsAlgebraBalanceEquationLabel(String equation) {
    return 'Gleichung: $equation';
  }

  @override
  String get labsAlgebraBalanceStep1Button => 'Konstante entfernen';

  @override
  String get labsAlgebraBalanceStep2Button => 'Durch Teilen x isolieren';

  @override
  String labsAlgebraBalanceSolvedFeedback(int x) {
    return 'Geloest! x = $x';
  }

  @override
  String get labsNumberLineExplorerTitle => 'Zahlenstrahl-Entdecker';

  @override
  String get labsNumberLineExplorerSubtitle =>
      'Ziehe den Punkt auf einen Wert am Zahlenstrahl';

  @override
  String get labsNumberLineExplorerConcept =>
      'Die Position einer Zahl auf dem Zahlenstrahl entspricht ihrem Wert — auch bei negativen Zahlen und Dezimalzahlen.';

  @override
  String get labsNumberLineExplorerWhereUsed =>
      'Thermometer, Zeitstrahlen und Messskalen lesen beruht alles darauf, dass Position und Wert uebereinstimmen.';

  @override
  String labsNumberLineExplorerPrompt(String target) {
    return 'Ziehe den Punkt auf $target.';
  }

  @override
  String get labsFlightPathLabTitle => 'Flugbahn-Labor';

  @override
  String get labsFlightPathLabSubtitle =>
      'Stelle Kurs und Geschwindigkeit ein, um das Ziel zu erreichen';

  @override
  String get labsFlightPathLabConcept =>
      'Ein Kurs (Peilung) und eine Geschwindigkeit, ueber eine feste Zeit gehalten, legen genau fest, wo du landest — das verbindet Peilung mit Geschwindigkeit, Strecke und Zeit.';

  @override
  String get labsFlightPathLabWhereUsed =>
      'Piloten und Seefahrer nutzen Peilung und Geschwindigkeit gemeinsam, um ein Ziel anzusteuern.';

  @override
  String labsFlightPathLabPrompt(int bearing, int distance) {
    return 'Ziel: Peilung $bearing°, $distance km entfernt. Die Flugzeit ist fest bei 2 Stunden — waehle Kurs und Geschwindigkeit, um es zu erreichen.';
  }

  @override
  String get labsFlightPathLabRadarLabel =>
      'Eine Radaransicht mit dem Ziel und, nach einem Testflug, wo das Flugzeug gelandet ist.';

  @override
  String labsFlightPathLabSpeedLabel(int speed) {
    return 'Geschwindigkeit: $speed km/h';
  }

  @override
  String get labsFlightPathLabTestButton => 'Testflug';

  @override
  String get labsFlightPathLabResultSpotOn => 'Genau getroffen!';

  @override
  String get labsFlightPathLabResultClose =>
      'Nah dran — versuche eine kleine Anpassung.';

  @override
  String get labsFlightPathLabResultTryAgain =>
      'Passe Kurs oder Geschwindigkeit an.';

  @override
  String labsFlightPathLabResultDistance(int distance) {
    return 'Du bist $distance km vom Ziel entfernt gelandet.';
  }

  @override
  String get labsDataDetectiveTitle => 'Daten-Detektiv';

  @override
  String get labsDataDetectiveSubtitle =>
      'Sieh, wie ein Ausreisser einen Durchschnitt veraendert';

  @override
  String get labsDataDetectiveConcept =>
      'Der Mittelwert wird viel staerker von einem Ausreisser angezogen als der Median. Entferne Werte und beobachte, wie sich jeder Durchschnitt sofort aendert.';

  @override
  String get labsDataDetectiveWhereUsed =>
      'Ein \'typisches\' Gehalt, einen Preis oder eine Punktzahl fair zu berichten bedeutet zu wissen, wann der Mittelwert irrefuehrend ist und der Median die bessere Zusammenfassung ist.';

  @override
  String get labsDataDetectiveAddValueButton => 'Typischen Wert hinzufuegen';

  @override
  String get labsDataDetectivePredictionPrompt =>
      'Was aendert sich mehr, wenn der Ausreisser entfernt wird?';

  @override
  String get labsDataDetectivePredictMeanButton => 'Mittelwert';

  @override
  String get labsDataDetectivePredictMedianButton => 'Median';

  @override
  String get labsDataDetectiveRevealButton =>
      'Ausreisser entfernen & aufdecken';

  @override
  String get labsDataDetectiveCorrectPrediction => 'Richtig vorhergesagt!';

  @override
  String get labsDataDetectiveIncorrectPrediction =>
      'Nicht ganz — sieh dir die Verschiebung unten an.';

  @override
  String labsDataDetectiveShiftSummary(String meanShift, String medianShift) {
    return 'Der Mittelwert verschob sich um $meanShift, der Median um $medianShift.';
  }

  @override
  String get labsDataDetectiveMeanLabel => 'Mittelwert';

  @override
  String get labsDataDetectiveMedianLabel => 'Median';

  @override
  String get labsDataDetectiveRangeLabel => 'Spannweite';

  @override
  String get labsTryAgainButton => 'Nochmal versuchen';

  @override
  String get labsHelpButton => 'Hilfe';

  @override
  String get labsNarrationReplayButton => 'Wiederholen';

  @override
  String get labsNarrationSectionLabel => 'CAPTAIN-MATH-ANSAGE';

  @override
  String get labsNarrationOnOffLabel => 'Ansage';

  @override
  String get labsNarrationTextOnlyLabel =>
      'Nur Text (keine gesprochene Ausgabe)';

  @override
  String get labsNarrationSpeedLabel => 'Geschwindigkeit';

  @override
  String get labsNarrationSpeedSlower => 'Langsamer';

  @override
  String get labsNarrationSpeedNormal => 'Normal';

  @override
  String get labsNarrationSpeedFaster => 'Schneller';

  @override
  String get labsHelpTitle => 'Hilfe';

  @override
  String get labsHelpWhatToDo => 'Was zu tun ist';

  @override
  String get labsHelpWhatToNotice => 'Worauf zu achten ist';

  @override
  String get labsHelpWhatItMeans => 'Was die Mathematik bedeutet';

  @override
  String get labsHelpWhereUsed => 'Wo das verwendet wird';

  @override
  String get labsFirstUseTitle => 'Bevor du startest';

  @override
  String get labsFirstUseGotItButton => 'Verstanden';

  @override
  String get labsGuidanceLevelLabel => 'Fuehrungsstufe';

  @override
  String get labsGuidanceExplorer => 'Entdecker';

  @override
  String get labsGuidanceBuilder => 'Baumeister';

  @override
  String get labsGuidanceNavigator => 'Navigator';

  @override
  String get labsDirectionAway => 'Von dir weg';

  @override
  String get labsDirectionRight => 'Rechts';

  @override
  String get labsDirectionToward => 'Zu dir hin';

  @override
  String get labsDirectionLeft => 'Links';

  @override
  String get labsFlightPathLabMission =>
      'Richte das Flugzeug auf das gelbe Ziel, dann druecke Testflug, um zu sehen, wo es landet.';

  @override
  String labsFlightPathLabHeadingLabel(String direction, int degrees) {
    return 'Richtung: $direction  •  Kurs: $degrees°';
  }

  @override
  String labsFlightPathLabHeadingNavigatorLabel(String bearing) {
    return 'Kurs: $bearing';
  }

  @override
  String get labsFlightPathLabHeadingHelper =>
      'Drehe das, um zu waehlen, wohin das Flugzeug zeigt';

  @override
  String get labsFlightPathLabSpeedHelper =>
      'Waehle, wie weit das Flugzeug fliegen soll';

  @override
  String labsFlightPathLabTargetExplanation(int distance, String bearing) {
    return 'Die gelbe Markierung ist dein Ziel. Sie ist $distance km entfernt, auf einer Peilung von $bearing.';
  }

  @override
  String get labsFlightPathLabPredictionPrompt =>
      'Bevor du testest: landest du zu kurz, genau im Ziel oder darueber hinaus?';

  @override
  String get labsFlightPathLabPredictShort => 'Zu kurz';

  @override
  String get labsFlightPathLabPredictOnTarget => 'Im Ziel';

  @override
  String get labsFlightPathLabPredictOver => 'Darueber hinaus';

  @override
  String get labsFlightPathLabHelpWhatToDo =>
      'Stelle Kurs und Geschwindigkeit ein, mache wenn gefragt eine Vorhersage, dann druecke Testflug.';

  @override
  String get labsFlightPathLabHelpWhatToNotice =>
      'Achte darauf, wie weit vom Ziel das Flugzeug landet und in welche Richtung du anpassen musst.';

  @override
  String get labsFlightPathLabHelpWhatItMeans =>
      'Ein gleichbleibender Kurs und eine gleichbleibende Geschwindigkeit fuehren ueber eine feste Zeit immer zu genau einem Landepunkt — das ist Geschwindigkeit, Strecke und Zeit zusammen mit einer Richtung.';

  @override
  String get labsFlightPathLabFirstUseStep1 =>
      'Richte das Flugzeug auf das gelbe Ziel.';

  @override
  String get labsFlightPathLabFirstUseStep2 =>
      'Waehle, wie weit das Flugzeug fliegen soll.';

  @override
  String get labsFlightPathLabFirstUseStep3 =>
      'Druecke Testflug, um zu sehen, wo es landet.';

  @override
  String get labsDataDetectiveMission =>
      'Sage voraus, was mit Mittelwert und Median passiert, dann entferne den ungewoehnlichen Wert, um es herauszufinden.';

  @override
  String labsDataDetectiveOutlierExplanation(int outlier) {
    return 'Ein Wert, $outlier, sticht aus den anderen heraus — er ist viel hoeher oder tiefer als die uebrigen. Das nennt man einen Ausreisser.';
  }

  @override
  String labsDataDetectiveBeforeAfter(String meanBefore, String meanAfter,
      String medianBefore, String medianAfter) {
    return 'Mittelwert: $meanBefore → $meanAfter. Median: $medianBefore → $medianAfter.';
  }

  @override
  String get labsDataDetectiveHelpWhatToDo =>
      'Schau dir die Werte an, sage voraus, ob sich Mittelwert oder Median staerker aendert, dann entferne den Ausreisser, um die Antwort zu sehen.';

  @override
  String get labsDataDetectiveHelpWhatToNotice =>
      'Achte darauf, wie stark sich der Mittelwert im Vergleich zum Median veraendert, sobald der Ausreisser weg ist.';

  @override
  String get labsDataDetectiveHelpWhatItMeans =>
      'Der Mittelwert nutzt jeden Wert, daher kann ihn ein extremer Wert stark verschieben. Der Median haengt nur von der mittleren Position ab, darum bewegt er sich kaum.';

  @override
  String get labsDataDetectiveFirstUseStep1 =>
      'Schau dir die Liste der Werte an — einer sticht heraus.';

  @override
  String get labsDataDetectiveFirstUseStep2 =>
      'Sage voraus, was sich staerker aendert: Mittelwert oder Median.';

  @override
  String get labsDataDetectiveFirstUseStep3 =>
      'Entferne den Ausreisser und decke die Antwort auf.';

  @override
  String get labsAlgebraBalanceMission =>
      'Halte beide Seiten im Gleichgewicht, bis x allein steht.';

  @override
  String labsAlgebraBalanceStep1RemoveButton(int value) {
    return 'Entferne $value von beiden Seiten';
  }

  @override
  String labsAlgebraBalanceStep1AddButton(int value) {
    return 'Addiere $value zu beiden Seiten';
  }

  @override
  String labsAlgebraBalanceStep2DivideButton(int value) {
    return 'Teile beide Seiten durch $value';
  }

  @override
  String get labsAlgebraBalanceHelpWhatToDo =>
      'Entferne zuerst die Zahl, dann teile, um x allein stehen zu lassen.';

  @override
  String get labsAlgebraBalanceHelpWhatToNotice =>
      'Achte darauf, dass sich beide Waagschalen immer gemeinsam und um den gleichen Betrag aendern — die Gleichung bleibt immer wahr.';

  @override
  String get labsAlgebraBalanceHelpWhatItMeans =>
      'Dieselbe Operation auf beiden Seiten einer Gleichung anzuwenden haelt sie im Gleichgewicht — so kannst du sicher bis auf x vereinfachen.';

  @override
  String get labsAlgebraBalanceFirstUseStep1 =>
      'Schau dir die Gleichung und die Waage darunter an.';

  @override
  String get labsAlgebraBalanceFirstUseStep2 =>
      'Nutze die Knoepfe, um beide Seiten gemeinsam zu vereinfachen.';

  @override
  String get labsAlgebraBalanceFirstUseStep3 =>
      'Mach weiter, bis x allein steht.';

  @override
  String labsFractionBuilderMission(int numerator, int denominator) {
    return 'Fuelle $numerator von $denominator gleichen Teilen.';
  }

  @override
  String get labsFractionBuilderTapGuidance =>
      'Tippe auf ein Segment, um es zu fuellen, oder nochmal, um es zu leeren.';

  @override
  String labsFractionBuilderSymbolicResult(int numerator, int denominator) {
    return '$numerator/$denominator — $numerator gleiche(r) Teil(e) von $denominator gefuellt.';
  }

  @override
  String get labsFractionBuilderHelpWhatToDo =>
      'Tippe Segmente, bis die gefuellte Anzahl zum Bruch passt, dann druecke Pruefen.';

  @override
  String get labsFractionBuilderHelpWhatToNotice =>
      'Achte darauf, dass der Nenner die Gesamtzahl gleicher Teile ist und der Zaehler, wie viele gefuellt sind.';

  @override
  String get labsFractionBuilderHelpWhatItMeans =>
      'Ein Bruch zaehlt gleiche Teile eines Ganzen — dieselbe Idee, egal ob Balken, Pizza oder Messbecher.';

  @override
  String get labsFractionBuilderFirstUseStep1 =>
      'Schau, wie viele Teile zu fuellen sind.';

  @override
  String get labsFractionBuilderFirstUseStep2 =>
      'Tippe Segmente, um sie zu fuellen.';

  @override
  String get labsFractionBuilderFirstUseStep3 =>
      'Druecke Pruefen, um zu sehen, ob du den Bruch getroffen hast.';

  @override
  String labsNumberLineExplorerMission(String target) {
    return 'Bewege den Punkt auf $target.';
  }

  @override
  String labsNumberLineExplorerStartInstruction(String min) {
    return 'Starte bei $min und bewege den Punkt zum Ziel.';
  }

  @override
  String labsNumberLineExplorerMoveRight(String distance) {
    return 'Bewege $distance weiter nach rechts';
  }

  @override
  String labsNumberLineExplorerMoveLeft(String distance) {
    return 'Bewege $distance weiter nach links';
  }

  @override
  String get labsNumberLineExplorerIncreaseButton => 'Nach rechts';

  @override
  String get labsNumberLineExplorerDecreaseButton => 'Nach links';

  @override
  String get labsNumberLineExplorerHelpWhatToDo =>
      'Ziehe den Punkt, oder nutze die Pfeilknoepfe, um den Zielwert zu erreichen, dann druecke Pruefen.';

  @override
  String get labsNumberLineExplorerHelpWhatToNotice =>
      'Achte darauf, wie die Position des Punktes seinem Wert entspricht — weiter rechts ist eine groessere Zahl, weiter links eine kleinere.';

  @override
  String get labsNumberLineExplorerHelpWhatItMeans =>
      'Ein Zahlenstrahl zeigt jede Zahl der Reihe nach, in beiden Richtungen von null, einschliesslich negativer Zahlen und Dezimalzahlen.';

  @override
  String get labsNumberLineExplorerFirstUseStep1 =>
      'Schau, wo der Punkt startet.';

  @override
  String get labsNumberLineExplorerFirstUseStep2 =>
      'Ziehe den Punkt, oder nutze die Pfeilknoepfe, zum Ziel.';

  @override
  String get labsNumberLineExplorerFirstUseStep3 =>
      'Druecke Pruefen, um zu sehen, ob du es erreicht hast.';

  @override
  String labsMissionOf(int current, int total) {
    return 'Auftrag $current von $total';
  }

  @override
  String get labsDirectionUp => 'Hoch';

  @override
  String get labsDirectionUpRight => 'Hoch-rechts';

  @override
  String get labsDirectionDownRight => 'Runter-rechts';

  @override
  String get labsDirectionDown => 'Runter';

  @override
  String get labsDirectionDownLeft => 'Runter-links';

  @override
  String get labsDirectionUpLeft => 'Hoch-links';

  @override
  String get labsCompassNorth => 'Norden';

  @override
  String get labsCompassNortheast => 'Nordosten';

  @override
  String get labsCompassEast => 'Osten';

  @override
  String get labsCompassSoutheast => 'Suedosten';

  @override
  String get labsCompassSouth => 'Sueden';

  @override
  String get labsCompassSouthwest => 'Suedwesten';

  @override
  String get labsCompassWest => 'Westen';

  @override
  String get labsCompassNorthwest => 'Nordwesten';

  @override
  String labsFlightPathLabHeadingExplorerLabel(String direction, int degrees) {
    return 'Richtung: $direction ($degrees°)';
  }

  @override
  String labsFlightPathLabHeadingCompassLabel(String compass, String bearing) {
    return '$compass • Kurs: $bearing';
  }

  @override
  String get labsFlightPathLabTapTargetHint =>
      'Tipp: Tippe auf das Ziel, um automatisch zu zielen';

  @override
  String get labsFlightPathLabDragCue => 'Ziehe das Flugzeug, um es zu drehen';

  @override
  String get labsFlightPathLabNarrationIntroExplorer =>
      'Ziele mit dem Flugzeug auf das gelbe Ziel und drücke dann Testflug, um zu sehen, wo es landet.';

  @override
  String get labsFlightPathLabNarrationIntroBuilder =>
      'Wähle Kurs und Geschwindigkeit, sage die Landung voraus und teste dann deine Vorhersage.';

  @override
  String get labsFlightPathLabNarrationIntroNavigator =>
      'Wähle einen Kurs und eine Geschwindigkeit; die Verschiebung ergibt sich aus Kurs und Geschwindigkeit-mal-Zeit als ein einziger Vektor.';

  @override
  String get labsFlightPathLabNarrationResultNearMissExplorer =>
      'Ganz nah dran! Versuche eine etwas andere Geschwindigkeit oder Richtung und teste erneut.';

  @override
  String get labsFlightPathLabNarrationResultNearMissBuilder =>
      'Du bist nahe am Ziel gelandet. Prüfe, ob du etwas zu früh oder zu spät bist, und passe Geschwindigkeit oder Kurs leicht an.';

  @override
  String get labsFlightPathLabNarrationResultNearMissNavigator =>
      'Die resultierende Verschiebung liegt nahe am Zielvektor, aber nicht exakt — verfeinere Kurs und/oder Geschwindigkeit und teste erneut.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer =>
      'Gute Richtung! Aber das Flugzeug ist zu weit geflogen. Versuche eine langsamere Geschwindigkeit.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder =>
      'Der Kurs stimmt, aber du bist weiter geflogen als die Zielentfernung. Behalte die Richtung bei und verringere die Geschwindigkeit.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator =>
      'Der Kurs entspricht dem Zielvektor; der Betrag (Geschwindigkeit × Zeit) übersteigt ihn — verringere die Geschwindigkeit, um die Verschiebung zu verkürzen.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortExplorer =>
      'Gute Richtung! Aber das Flugzeug ist nicht weit genug geflogen. Versuche eine schnellere Geschwindigkeit.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder =>
      'Der Kurs stimmt, aber du bist nicht weit genug geflogen. Behalte die Richtung bei und erhöhe die Geschwindigkeit.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortNavigator =>
      'Der Kurs entspricht dem Zielvektor; der Betrag reicht nicht aus — erhöhe die Geschwindigkeit, um die Verschiebung zu verlängern.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceExplorer =>
      'Die Entfernung stimmt, aber das Flugzeug zeigt in die falsche Richtung. Drehe es zum gelben Ziel.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder =>
      'Du bist die richtige Entfernung geflogen, aber in die falsche Richtung. Passe den Kurs zum Zielpeilung an und behalte die Geschwindigkeit bei.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceNavigator =>
      'Der Betrag stimmt, aber die Peilung weicht ab — drehe den Kurs zur Zielpeilung, ohne die Geschwindigkeit zu ändern.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceExplorer =>
      'Das Flugzeug zeigt in die falsche Richtung und ist die falsche Entfernung geflogen. Ziele auf das Ziel und wähle dann eine Geschwindigkeit.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder =>
      'Sowohl Richtung als auch Entfernung müssen angepasst werden. Ziele erneut auf die Zielpeilung und wähle dann eine passende Geschwindigkeit.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceNavigator =>
      'Sowohl Peilung als auch Betrag weichen vom Zielvektor ab — korrigiere zuerst den Kurs, dann die Geschwindigkeit für die geforderte Entfernung.';

  @override
  String get labsFlightPathLabNarrationCompletionExplorer =>
      'Genau richtig! Du hast das Flugzeug ausgerichtet und die passende Geschwindigkeit gewählt, um genau im Ziel zu landen.';

  @override
  String get labsFlightPathLabNarrationCompletionBuilder =>
      'Genau richtig! Kurs und Geschwindigkeit auf ein Ziel abzustimmen ist genau so, wie echte Flugpläne erstellt werden.';

  @override
  String get labsFlightPathLabNarrationCompletionNavigator =>
      'Exakte Übereinstimmung: Der Verschiebungsvektor (Peilung und Betrag) entspricht dem Zielvektor — genau so funktionieren Flugplanung und Navigation in der Praxis.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedExplorer =>
      'Das ist derselbe Versuch wie zuvor. Ändere Richtung oder Geschwindigkeit, bevor du erneut testest.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedBuilder =>
      'Du hast genau denselben Kurs und dieselbe Geschwindigkeit erneut getestet. Ändere eines von beidem vor dem nächsten Test.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedNavigator =>
      'Kurs und Geschwindigkeit sind unverändert gegenüber dem letzten Versuch — verändere mindestens eine Variable, um neue Informationen zu gewinnen.';

  @override
  String get labsFlightPathLabNarrationHintInactivityExplorer =>
      'Noch da? Ziehe das Flugzeug oder bewege den Geschwindigkeitsregler.';

  @override
  String get labsFlightPathLabNarrationHintInactivityBuilder =>
      'Lass dir Zeit — ziehe das Flugzeug, um es auszurichten, oder passe die Geschwindigkeit an, wann immer du bereit bist.';

  @override
  String get labsFlightPathLabNarrationHintInactivityNavigator =>
      'Seit einiger Zeit keine Eingabe erfasst — passe Kurs oder Geschwindigkeit an, um fortzufahren.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongExplorer =>
      'Nicht ganz — überlege, ob du nach links oder rechts musst, und versuche es erneut.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongBuilder =>
      'Vergleiche deinen Wert mit dem Ziel: bewege dich um die Differenz darauf zu und prüfe erneut.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongNavigator =>
      'Der Wert weicht um mehr als einen Schritt vom Ziel ab — passe um den erforderlichen Schritt an und teste erneut.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseExplorer =>
      'Ganz nah dran! Nur ein kleiner Schritt entfernt — versuche es noch einmal.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseBuilder =>
      'Du bist einen Schritt vom Ziel entfernt. Passe um einen einzigen Schritt an und prüfe erneut.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseNavigator =>
      'Der Wert liegt innerhalb eines Schritts vom Ziel — eine einzige Anpassung sollte genügen.';

  @override
  String get labsNumberLineExplorerNarrationCompletionExplorer =>
      'Genau richtig! Du hast die exakte Position des Ziels auf der Linie gefunden.';

  @override
  String get labsNumberLineExplorerNarrationCompletionBuilder =>
      'Genau richtig! Einen Wert seiner Position zuzuordnen ist genau das, was eine Zahlenlinie darstellt.';

  @override
  String get labsNumberLineExplorerNarrationCompletionNavigator =>
      'Exakte Übereinstimmung: Die Position des Werts auf der Linie entspricht genau seinem Zahlenwert, einschließlich Vorzeichen und Betrag.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedExplorer =>
      'Das ist derselbe Punkt wie zuvor — bewege ihn, bevor du erneut prüfst.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedBuilder =>
      'Du hast denselben Wert erneut geprüft. Bewege ihn um mindestens einen Schritt vor der nächsten Prüfung.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedNavigator =>
      'Der Wert ist unverändert gegenüber der letzten Prüfung — passe ihn vor dem erneuten Test an.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityExplorer =>
      'Noch da? Ziehe die Markierung oder nutze die Plus/Minus-Tasten.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityBuilder =>
      'Lass dir Zeit — ziehe die Markierung oder nutze die Plus/Minus-Tasten, wann immer du bereit bist.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityNavigator =>
      'Seit einiger Zeit keine Eingabe erfasst — passe den Wert an, um fortzufahren.';

  @override
  String get labsFractionBuilderNarrationResultWrongExplorer =>
      'Nicht die richtige Anzahl an Teilen — zähle die gefüllten Segmente und vergleiche mit dem Ziel.';

  @override
  String get labsFractionBuilderNarrationResultWrongBuilder =>
      'Vergleiche die gefüllten Segmente mit dem Zähler und füge eines hinzu oder entferne eines, um es anzupassen.';

  @override
  String get labsFractionBuilderNarrationResultWrongNavigator =>
      'Die Anzahl gefüllter Segmente muss genau dem Zähler entsprechen — passe um die Differenz an.';

  @override
  String get labsFractionBuilderNarrationCompletionExplorer =>
      'Genau das! Du hast genau die richtige Anzahl an Teilen gefüllt.';

  @override
  String get labsFractionBuilderNarrationCompletionBuilder =>
      'Genau das! Gefüllte Teile gegen einen Zähler zu zählen ist genau das, was ein Bruch darstellt.';

  @override
  String get labsFractionBuilderNarrationCompletionNavigator =>
      'Exakte Übereinstimmung: gefüllte Segmente entsprechen dem Zähler über dem gezeigten Nenner, passend zum definierenden Verhältnis des Bruchs.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedExplorer =>
      'Dieselbe Anzahl wie zuvor — ändere sie, bevor du erneut prüfst.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedBuilder =>
      'Du hast dieselbe gefüllte Anzahl erneut geprüft. Ändere sie vor der nächsten Prüfung.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedNavigator =>
      'Die gefüllte Anzahl ist unverändert gegenüber der letzten Prüfung — passe sie vor dem erneuten Test an.';

  @override
  String get labsFractionBuilderNarrationHintInactivityExplorer =>
      'Noch da? Tippe auf ein Segment, um es zu füllen oder zu leeren.';

  @override
  String get labsFractionBuilderNarrationHintInactivityBuilder =>
      'Lass dir Zeit — tippe auf Segmente, um die Anzahl anzupassen, wann immer du bereit bist.';

  @override
  String get labsFractionBuilderNarrationHintInactivityNavigator =>
      'Seit einiger Zeit keine Eingabe erfasst — tippe auf ein Segment, um fortzufahren.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepExplorer =>
      'Entferne zuerst die Zahl, dividiere dann, um x zu finden.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepBuilder =>
      'Entferne zuerst die Konstante von beiden Seiten, dividiere dann beide Seiten durch den Koeffizienten von x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepNavigator =>
      'Wende zuerst die inverse additive Operation an, dann die inverse multiplikative Operation, um x zu isolieren.';

  @override
  String get labsAlgebraBalanceNarrationCompletionExplorer =>
      'Gelöst! Du hast den Wert von x gefunden.';

  @override
  String get labsAlgebraBalanceNarrationCompletionBuilder =>
      'Gelöst! Jede Gleichung dieser Form wird gelöst, indem man die Konstante entfernt und dann dividiert.';

  @override
  String get labsAlgebraBalanceNarrationCompletionNavigator =>
      'Gelöst: x wird durch inverse Operationen auf beiden Seiten isoliert, wobei die Gleichheit stets erhalten bleibt.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityExplorer =>
      'Noch da? Versuche die erste Schaltfläche, um die Zahl zu entfernen.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityBuilder =>
      'Lass dir Zeit — entferne die Konstante und dividiere dann, wann immer du bereit bist.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityNavigator =>
      'Seit einiger Zeit keine Eingabe erfasst — wende die nächste inverse Operation an, um fortzufahren.';

  @override
  String get labsDataDetectiveNarrationResultWrongExplorer =>
      'Nicht ganz — schau, wie stark sich jeder Durchschnitt verändert hat, und wähle erneut.';

  @override
  String get labsDataDetectiveNarrationResultWrongBuilder =>
      'Vergleiche, wie stark sich Mittelwert und Median jeweils verändert haben, und sage dann erneut voraus, welcher sich stärker verschoben hat.';

  @override
  String get labsDataDetectiveNarrationResultWrongNavigator =>
      'Überprüfe die berechneten Verschiebungen erneut: sage voraus, welche Kennzahl sich stärker verändert hat.';

  @override
  String get labsDataDetectiveNarrationCompletionExplorer =>
      'Richtig! Du hast erkannt, welchen Durchschnitt der Ausreißer am stärksten beeinflusst.';

  @override
  String get labsDataDetectiveNarrationCompletionBuilder =>
      'Richtig! Zu erkennen, welche Kennzahl ein Ausreißer am stärksten verzerrt, ist genau die Kernidee dieses Labors.';

  @override
  String get labsDataDetectiveNarrationCompletionNavigator =>
      'Richtig: Die Kennzahl mit der größeren Verschiebung reagiert empfindlicher auf den Ausreißer, passend zur Empfindlichkeit des Mittelwerts gegenüber Extremwerten im Vergleich zum Median.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedExplorer =>
      'Dieselbe Vermutung wie zuvor — versuche die andere.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedBuilder =>
      'Du hast erneut dieselbe Kennzahl vorhergesagt. Erwäge die andere Option.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedNavigator =>
      'Dieselbe Vorhersage wurde wiederholt — überdenke sie anhand der berechneten Verschiebungswerte.';

  @override
  String get labsDataDetectiveNarrationHintInactivityExplorer =>
      'Noch da? Wähle Mittelwert oder Median und tippe dann auf Aufdecken.';

  @override
  String get labsDataDetectiveNarrationHintInactivityBuilder =>
      'Lass dir Zeit — wähle eine Vorhersage und tippe auf Aufdecken, wann immer du bereit bist.';

  @override
  String get labsDataDetectiveNarrationHintInactivityNavigator =>
      'Seit einiger Zeit keine Eingabe erfasst — wähle eine Vorhersage, um fortzufahren.';

  @override
  String get labsFractionBuilderNarrationIntro =>
      'Tippe auf Segmente, um den Bruch zu füllen, und prüfe dann deine Antwort.';

  @override
  String get labsNumberLineExplorerNarrationIntro =>
      'Bewege die Markierung zum Zielwert und prüfe dann deine Antwort.';

  @override
  String get labsAlgebraBalanceNarrationIntro =>
      'Nutze die Waage-Operationen, um x Schritt für Schritt zu isolieren.';

  @override
  String get labsDataDetectiveNarrationIntro =>
      'Sage voraus, welchen Durchschnitt der Ausreißer am stärksten beeinflusst, und decke dann die Antwort auf.';
}
