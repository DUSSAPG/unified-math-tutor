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
  String get homeDailyGoalProgress => '7 / 15 abgeschlossen';

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
}
