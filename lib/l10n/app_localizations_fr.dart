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
      'Chaque installation prend actuellement en charge un seul profil apprenant. Learning Analytics et les rapports de progression sont accessibles depuis Plus ou Profil.';

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
  String get helpPrivacyBullet3 => 'Learning Analytics disponible';

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
      'Comprendre les progrès, repérer les lacunes et soutenir la prochaine étape.';

  @override
  String get helpParentalBullet1 => 'Vue d\'ensemble des progrès';

  @override
  String get helpParentalBullet2 => 'Maîtrise des sujets';

  @override
  String get helpParentalBullet3 => 'Tendances d\'apprentissage';

  @override
  String get helpParentalBullet4 => 'Pratique recommandée';

  @override
  String get helpReportButton => 'Report a Problem';

  @override
  String get helpFooter =>
      'Données minimales. Pas de publicité. Learning Analytics disponible.';

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
      'Développe ta pensée mathématique.\nLibère ton potentiel.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Apprentissage personnalisé. Progrès mesurables.';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'Je suis un apprenant';

  @override
  String get onboardingStudentSub =>
      'Entraîne-toi en mathématiques avec un parcours conçu autour de toi.';

  @override
  String get onboardingParentLabel => 'J’accompagne un apprenant';

  @override
  String get onboardingParentSub =>
      'Soutiens chaque étape de son développement en mathématiques.';

  @override
  String get onboardingTeacherLabel => 'Je suis enseignant';

  @override
  String get onboardingTeacherSub =>
      'Suis la progression de ta classe et propose des exercices à tes élèves.';

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
      'Données minimales. Pas de publicité. Learning Analytics disponible.';

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
  String get onboardingStageTitleParent => 'Choisis le niveau de l\'apprenant';

  @override
  String get onboardingStageSubParent =>
      'Le contenu sera adapté à son niveau actuel.';

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
  String get onboardingGoalTitleParent => 'Comment veux-tu l\'accompagner ?';

  @override
  String get onboardingGoalSubParent =>
      'Choisis l\'objectif de soutien pour cet apprenant.';

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
      'Renforcer la confiance en mathématiques';

  @override
  String get onboardingParentGoal1Sub =>
      'Soutenir une pratique régulière et sereine à son rythme.';

  @override
  String get onboardingParentGoal2Label => 'Repérer les lacunes';

  @override
  String get onboardingParentGoal2Sub =>
      'Identifier les notions à retravailler avant qu\'elles ne bloquent l\'apprentissage.';

  @override
  String get onboardingParentGoal3Label => 'Suivre les progrès dans le temps';

  @override
  String get onboardingParentGoal3Sub =>
      'Observer la progression et la régularité à partir des exercices terminés.';

  @override
  String get onboardingParentGoal4Label =>
      'Soutenir la préparation aux examens';

  @override
  String get onboardingParentGoal4Sub =>
      'Guider la révision et l\'entraînement avant les évaluations.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Comment veux-tu utiliser Math Intelligence ?';

  @override
  String get onboardingGoalSubTeacher => 'Choisis l\'objectif pour ta classe.';

  @override
  String get onboardingTeacherGoal1Label => 'Suivre les progrès de la classe';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Observe l\'évolution de tes élèves au fil du temps.';

  @override
  String get onboardingTeacherGoal2Label => 'Assigner des exercices';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Définis des séries d\'exercices ciblés pour tes élèves.';

  @override
  String get onboardingTeacherGoal3Label => 'Préparer les examens';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Soutiens la préparation aux examens avec des séries d\'exercices ciblés.';

  @override
  String get onboardingTeacherGoal4Label => 'Explorer le programme';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Parcours les thèmes et les solutions détaillées avant de les assigner.';

  @override
  String get onboardingProfileTitle => 'Enregistre ta progression';

  @override
  String get onboardingProfileSub =>
      'Facultatif — tu peux toujours modifier cela plus tard dans ton profil.';

  @override
  String get onboardingDisplayNameLabel => 'Comment devons-nous t\'appeler ?';

  @override
  String get onboardingDisplayNameSub =>
      'Un surnom suffit — c\'est juste pour ton message de bienvenue.';

  @override
  String get onboardingDisplayNameHint => 'ex. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Comment devons-nous appeler ton apprenant ?';

  @override
  String get onboardingLearnerNameSub => 'Personnalise son Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel => 'Ton lien avec l\'apprenant';

  @override
  String get onboardingRelationshipParent => 'Parent';

  @override
  String get onboardingRelationshipGuardian => 'Tuteur légal / Tutrice légale';

  @override
  String get onboardingRelationshipGrandparent => 'Grand-parent';

  @override
  String get onboardingRelationshipTutor => 'Répétiteur/répétitrice';

  @override
  String get onboardingRelationshipOther => 'Autre membre de la famille';

  @override
  String get onboardingParentEmailLabel =>
      'E-mail de l\'adulte accompagnant (facultatif)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Stocké localement sur cet appareil pour clarifier le compte.';

  @override
  String get onboardingPrivacyNote =>
      'Données de profil locales uniquement. Aucune synchronisation cloud n\'est promise pour cette version.';

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
      'Learning Analytics et animations de récompense';

  @override
  String get enableParentTools => 'Activer Learning Analytics';

  @override
  String get parentToolsLocalOnly =>
      'Autoriser Learning Analytics en local uniquement';

  @override
  String get unlockParentTools => 'Déverrouiller Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Crée ou saisis le PIN local à 4 chiffres pour Learning Analytics.';

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
  String get onboardingTechBadge =>
      'Propulsé par Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Développe ta pensée mathématique.\nLibère ton potentiel.';

  @override
  String get onboardingSupportingStatement =>
      'Apprentissage personnalisé.\nProgrès mesurables.';

  @override
  String get onboardingRoleClarification =>
      'Pour les parents, tuteurs, enseignants, répétiteurs et familles en école à domicile.';

  @override
  String get onboardingCreateAccount => 'Créer un compte';

  @override
  String get onboardingCreateAccountSub =>
      'Enregistre la progression, le parcours Maths Journey et les réussites sur cet appareil.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Comprendre les progrès, repérer les lacunes et soutenir la prochaine étape.';

  @override
  String get learningAnalyticsEmptyState =>
      'Termine une séance d’entraînement pour commencer à créer Learning Analytics.';

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
  String profileVersionNumber(String version) {
    return 'Version $version';
  }

  @override
  String get profileCopyright => '© QuantumLab Intelligence';

  @override
  String get profileHeaderTitle => 'Profil';

  @override
  String get profileHeaderSubtitle => 'Paramètres et profil d\'apprentissage.';

  @override
  String get profilePreferredDisplayName => 'Nom d\'affichage préféré';

  @override
  String get profilePreferredDisplayNameNotSet => 'Non défini';

  @override
  String get profileChangeDisplayName => 'Modifier le nom d\'affichage';

  @override
  String get profileGreetingPreview => 'Aperçu du message d\'accueil';

  @override
  String get profileSwitchLearner => 'Changer d\'apprenant';

  @override
  String get profileDisplayNameDialogHint => 'ex. Sam ou un surnom';

  @override
  String get whoIsLearningTitle => 'Qui apprend aujourd\'hui ?';

  @override
  String get whoIsLearningAddLearner => 'Ajouter un apprenant';

  @override
  String get whoIsLearningAddLearnerHint => 'Nom de l\'apprenant';

  @override
  String homeLearningAsLabel(String name) {
    return 'Apprentissage en tant que : $name';
  }

  @override
  String get homeSwitchLearnerAction => 'Changer';

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
      'Chaque installation prend actuellement en charge un seul profil apprenant. Learning Analytics et les rapports de progression sont accessibles depuis Plus ou Profil.';

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
  String get helpPrivacyBullet3 => 'Learning Analytics disponible';

  @override
  String get helpPrivacyBullet4 =>
      'Les outils parentaux sont protégés par un code PIN';

  @override
  String get helpTermsTitle => 'Conditions d\'utilisation';

  @override
  String get helpTermsBody =>
      'Utilise l\'application comme outil d\'apprentissage. Vérifie les décisions importantes avec un enseignant ou un parent.';

  @override
  String get helpParentalTitle => 'Learning Analytics';

  @override
  String get helpParentalHeadline =>
      'Comprendre les progrès, repérer les lacunes et soutenir la prochaine étape.';

  @override
  String get helpParentalBullet1 => 'Vue d\'ensemble des progrès';

  @override
  String get helpParentalBullet2 => 'Maîtrise des sujets';

  @override
  String get helpParentalBullet3 => 'Tendances d\'apprentissage';

  @override
  String get helpParentalBullet4 => 'Pratique recommandée';

  @override
  String get helpReportButton => 'Signaler un problème';

  @override
  String get helpFooter =>
      'Données minimales. Pas de publicité. Learning Analytics disponible.';

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
  String homeGreetingMorningNamed(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get homeGreetingMorningDefault => 'Bonjour';

  @override
  String homeGreetingAfternoonNamed(String name) {
    return 'Bon après-midi, $name';
  }

  @override
  String get homeGreetingAfternoonDefault => 'Bon après-midi';

  @override
  String homeGreetingEveningNamed(String name) {
    return 'Bonsoir, $name';
  }

  @override
  String get homeGreetingEveningDefault => 'Bonsoir';

  @override
  String homeGreetingNightNamed(String name) {
    return 'Bon retour, $name';
  }

  @override
  String get homeGreetingNightDefault => 'Bon retour';

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
  String get homeAchievementStreakLocked =>
      'Atteignez une série de 7 jours pour débloquer ceci';

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
      'Développe ta pensée mathématique.\nLibère ton potentiel.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Apprentissage personnalisé. Progrès mesurables.';

  @override
  String get onboardingWhoLabel => 'QUI UTILISE L\'APPLICATION ?';

  @override
  String get onboardingStudentLabel => 'Je suis un apprenant';

  @override
  String get onboardingStudentSub =>
      'Entraîne-toi en mathématiques avec un parcours conçu autour de toi.';

  @override
  String get onboardingParentLabel => 'J’accompagne un apprenant';

  @override
  String get onboardingParentSub =>
      'Soutiens chaque étape de son développement en mathématiques.';

  @override
  String get onboardingTeacherLabel => 'Je suis enseignant';

  @override
  String get onboardingTeacherSub =>
      'Suis la progression de ta classe et propose des exercices à tes élèves.';

  @override
  String get onboardingSelectError => 'Veuillez choisir une option';

  @override
  String get onboardingContinue => 'Continuer';

  @override
  String get onboardingFooter =>
      'Données minimales. Pas de publicité. Learning Analytics disponible.';

  @override
  String get onboardingAccessibilityTitle =>
      'Rends la lecture plus confortable';

  @override
  String get onboardingAccessibilitySub =>
      'Tu peux modifier cela à tout moment dans les paramètres.';

  @override
  String get onboardingStageTitle => 'À quel degré scolaire est l\'élève ?';

  @override
  String get onboardingStageSub => 'Nous adaptons le contenu au bon niveau';

  @override
  String get onboardingStageTitleParent => 'Choisis le niveau de l\'apprenant';

  @override
  String get onboardingStageSubParent =>
      'Le contenu sera adapté à son niveau actuel.';

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
  String get onboardingGoalTitleParent => 'Comment veux-tu l\'accompagner ?';

  @override
  String get onboardingGoalSubParent =>
      'Choisis l\'objectif de soutien pour cet apprenant.';

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
  String get onboardingParentGoal1Label =>
      'Renforcer la confiance en mathématiques';

  @override
  String get onboardingParentGoal1Sub =>
      'Soutenir une pratique régulière et sereine à son rythme.';

  @override
  String get onboardingParentGoal2Label => 'Repérer les lacunes';

  @override
  String get onboardingParentGoal2Sub =>
      'Identifier les notions à retravailler avant qu\'elles ne bloquent l\'apprentissage.';

  @override
  String get onboardingParentGoal3Label => 'Suivre les progrès dans le temps';

  @override
  String get onboardingParentGoal3Sub =>
      'Observer la progression et la régularité à partir des exercices terminés.';

  @override
  String get onboardingParentGoal4Label =>
      'Soutenir la préparation aux examens';

  @override
  String get onboardingParentGoal4Sub =>
      'Guider la révision et l\'entraînement avant les évaluations.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Comment veux-tu utiliser Math Intelligence ?';

  @override
  String get onboardingGoalSubTeacher => 'Choisis l\'objectif pour ta classe.';

  @override
  String get onboardingTeacherGoal1Label => 'Suivre les progrès de la classe';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Observe l\'évolution de tes élèves au fil du temps.';

  @override
  String get onboardingTeacherGoal2Label => 'Assigner des exercices';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Définis des séries d\'exercices ciblés pour tes élèves.';

  @override
  String get onboardingTeacherGoal3Label => 'Préparer les examens';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Soutiens la préparation aux examens avec des séries d\'exercices ciblés.';

  @override
  String get onboardingTeacherGoal4Label => 'Explorer le programme';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Parcours les thèmes et les solutions détaillées avant de les assigner.';

  @override
  String get onboardingProfileTitle => 'Enregistre ta progression';

  @override
  String get onboardingProfileSub =>
      'Facultatif — tu peux toujours modifier cela plus tard dans ton profil.';

  @override
  String get onboardingDisplayNameLabel => 'Comment devons-nous t\'appeler ?';

  @override
  String get onboardingDisplayNameSub =>
      'Un surnom suffit — c\'est juste pour ton message de bienvenue.';

  @override
  String get onboardingDisplayNameHint => 'ex. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Comment devons-nous appeler ton apprenant ?';

  @override
  String get onboardingLearnerNameSub => 'Personnalise son Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel => 'Ton lien avec l\'apprenant';

  @override
  String get onboardingRelationshipParent => 'Parent';

  @override
  String get onboardingRelationshipGuardian => 'Tuteur légal / Tutrice légale';

  @override
  String get onboardingRelationshipGrandparent => 'Grand-parent';

  @override
  String get onboardingRelationshipTutor => 'Répétiteur/répétitrice';

  @override
  String get onboardingRelationshipOther => 'Autre membre de la famille';

  @override
  String get onboardingParentEmailLabel =>
      'E-mail de l\'adulte accompagnant (facultatif)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Stocké localement sur cet appareil pour clarifier le compte.';

  @override
  String get onboardingPrivacyNote =>
      'Données de profil locales uniquement. Aucune synchronisation cloud n\'est promise pour cette version.';

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
  String get upgradeBenefit3Title => 'Learning Analytics';

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
  String homeDailyGoalProgress(int completed, int target) {
    return '$completed / $target complétés';
  }

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
      'Learning Analytics et animations de récompense';

  @override
  String get enableParentTools => 'Activer Learning Analytics';

  @override
  String get parentToolsLocalOnly =>
      'Autoriser Learning Analytics en local uniquement';

  @override
  String get unlockParentTools => 'Déverrouiller Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Crée ou saisis le PIN local à 4 chiffres pour Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

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

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge =>
      'Propulsé par Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Développe ta pensée mathématique.\nLibère ton potentiel.';

  @override
  String get onboardingSupportingStatement =>
      'Apprentissage personnalisé.\nProgrès mesurables.';

  @override
  String get onboardingRoleClarification =>
      'Pour les parents, tuteurs, enseignants, répétiteurs et familles en école à domicile.';

  @override
  String get onboardingCreateAccount => 'Créer un compte';

  @override
  String get onboardingCreateAccountSub =>
      'Enregistre la progression, le parcours Maths Journey et les réussites sur cet appareil.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Comprendre les progrès, repérer les lacunes et soutenir la prochaine étape.';

  @override
  String get learningAnalyticsEmptyState =>
      'Termine une séance d’entraînement pour commencer à créer Learning Analytics.';

  @override
  String get exploreMathIntelligenceTitle => 'Découvrir Math Intelligence';

  @override
  String get exploreHeaderSubtitle =>
      'Ce que Math Intelligence propose aujourd\'hui, et ce qui arrive ensuite.';

  @override
  String get exploreAvailableTodaySection => 'DISPONIBLE AUJOURD\'HUI';

  @override
  String get exploreInAtelierSection => 'IN ATELIER';

  @override
  String get exploreInAtelierBadge => 'In Atelier';

  @override
  String get exploreInDevelopmentNote =>
      'Cette fonctionnalité est actuellement en cours de développement.';

  @override
  String get exploreRoadmapTitle => 'Philosophie de développement';

  @override
  String get exploreRoadmapBody =>
      'Math Intelligence est conçu pour évoluer avec le temps. Certaines fonctionnalités sont disponibles dès aujourd\'hui. D\'autres sont en cours de développement et de test avant leur lancement.';

  @override
  String get explorePersonalisedPracticeTitle => 'Entraînement personnalisé';

  @override
  String get explorePersonalisedPracticeBody =>
      'Des sessions de questions adaptatives selon ton niveau et tes objectifs d\'apprentissage.';

  @override
  String get exploreTopicLearningTitle => 'Apprentissage par thème';

  @override
  String get exploreTopicLearningBody =>
      'Concentre-toi sur des thèmes mathématiques précis.';

  @override
  String get exploreTimedChallengesTitle => 'Défis chronométrés';

  @override
  String get exploreTimedChallengesBody =>
      'Développe ta rapidité et ta confiance.';

  @override
  String get exploreExamSimulatorTitle => 'Simulateur d\'examen';

  @override
  String get exploreExamSimulatorBody =>
      'Entraîne-toi avec des sessions d\'examen structurées.';

  @override
  String get exploreMathsJourneyTitle => 'Mon Maths Journey';

  @override
  String get exploreMathsJourneyBody =>
      'Suis ton parcours d\'apprentissage au fil du temps.';

  @override
  String get exploreLearningAnalyticsBody =>
      'Suis tes progrès et repère les axes d\'amélioration.';

  @override
  String get exploreFormulaLibraryBody => 'Référence rapide, même hors ligne.';

  @override
  String get explorePhotoUploadTitle => 'Envoi de questions en photo';

  @override
  String get explorePhotoUploadBody =>
      'Envoie des fiches d\'exercices, des pages de manuel ou des questions d\'examen.';

  @override
  String get exploreMarkMyPaperTitle => 'Corriger mon travail';

  @override
  String get exploreMarkMyPaperBody =>
      'Reçois un retour structuré sur ton travail terminé.';

  @override
  String get exploreExaminerIntelligenceTitle =>
      'Intelligence de l\'examinateur';

  @override
  String get exploreExaminerIntelligenceBody =>
      'Découvre comment les examinateurs attribuent les points et repère les erreurs fréquentes.';

  @override
  String get exploreAdaptiveStudyPlansTitle => 'Plans de révision adaptatifs';

  @override
  String get exploreAdaptiveStudyPlansBody =>
      'Des recommandations de travail personnalisées selon ton parcours d\'apprentissage.';

  @override
  String get exploreTutorConversationsTitle => 'Conversations avec le tuteur';

  @override
  String get exploreTutorConversationsBody =>
      'Un accompagnement mathématique en langage naturel.';

  @override
  String get journeyCardTitleDefault => 'Mon Maths Journey';

  @override
  String journeyCardTitleNamed(String name) {
    return 'Le Maths Journey de $name';
  }

  @override
  String get journeyCardCurrentFocusLabel => 'Objectif actuel';

  @override
  String get journeyCardGettingStarted => 'C\'est parti';

  @override
  String get journeyCardCurrentStreakLabel => 'Série actuelle';

  @override
  String get journeyCardStartStreakToday => 'Démarre ta série aujourd\'hui';

  @override
  String journeyCardStreakDays(int days) {
    return 'Série de $days jours';
  }

  @override
  String get journeyCardNextMilestoneLabel => 'Prochain palier';

  @override
  String journeyCardDaysToMilestoneOne(int milestone) {
    return 'Encore 1 jour avant ta série de $milestone jours';
  }

  @override
  String journeyCardDaysToMilestoneMany(int days, int milestone) {
    return 'Encore $days jours avant ta série de $milestone jours';
  }

  @override
  String get journeyCardAllMilestonesReached =>
      'Tu as atteint tous les paliers de série !';

  @override
  String get journeyCardGoalConfidence => 'Tu renforces ta confiance';

  @override
  String get journeyCardGoalSchool => 'Tu améliores tes maths scolaires';

  @override
  String get journeyCardGoalExams => 'Tu te prépares aux examens';

  @override
  String get journeyCardGoalChallenge => 'Tu relèves des défis';

  @override
  String get journeyCardGoalParentGaps => 'Tu repères des lacunes';

  @override
  String get journeyCardGoalParentProgress =>
      'Tu suis les progrès dans le temps';

  @override
  String get journeyCardGoalParentGcse => 'Tu te prépares au GCSE';

  @override
  String get journeyCardGoalTeacherMonitor =>
      'Tu suis les progrès de la classe';

  @override
  String get journeyCardGoalTeacherAssign => 'Tu assignes des exercices';

  @override
  String get journeyCardGoalTeacherExplore => 'Tu explores le programme';

  @override
  String get mathStudioNavCardTitle => 'Math Studio';

  @override
  String get mathStudioNavCardSubtitle =>
      'Decouvre les maths que tu utilises deja';

  @override
  String get mathStudioHubTitle => 'Math Studio';

  @override
  String get mathStudioHubTagline =>
      'Decouvre les mathematiques que tu utilises depuis toujours.';

  @override
  String get mathStudioBuildConfidenceTitle => 'Renforcer la confiance';

  @override
  String get mathStudioBuildConfidenceSubtitle =>
      'Entrainement doux et sans chrono, avec des explications detaillees';

  @override
  String get mathStudioMentalMathsTitle => 'Calcul mental';

  @override
  String get mathStudioMentalMathsSubtitle =>
      'Strategies numeriques quotidiennes, sans pression';

  @override
  String get mathStudioVisualMathsTitle => 'Maths visuelles';

  @override
  String get mathStudioVisualMathsSubtitle =>
      'Vivre les maths a travers des modeles que tu peux manipuler';

  @override
  String get mathStudioDiscoveryTitle => 'Bibliotheque de decouvertes';

  @override
  String get mathStudioDiscoverySubtitle =>
      'Des maths bien reelles, une carte a la fois';

  @override
  String get mathStudioMathMagicTitle => 'Maths & Magie';

  @override
  String get mathStudioMathMagicSubtitle =>
      'Enigmes, motifs et surprises mathematiques ludiques';

  @override
  String get mathStudioMathMagicBody =>
      'Enigmes recreatives, tours de magie numeriques et curiosites mathematiques';

  @override
  String get mathStudioSpatialIntelligenceTitle => 'Intelligence spatiale';

  @override
  String get mathStudioSpatialIntelligenceSubtitle =>
      'Developpe ton sens de la forme, de l\'espace et du mouvement';

  @override
  String get mathStudioSpatialIntelligenceBody =>
      'Patrons de cubes, rotations, transformations et casse-tetes spatiaux';

  @override
  String get mathStudioInDevelopmentBadge => 'En developpement';

  @override
  String get mathStudioInDevelopmentNote =>
      'Cette section est encore en construction - reviens bientot pour du nouveau contenu.';

  @override
  String get mathStudioSpatialCubeActivitiesLabel => 'Activites avec des cubes';

  @override
  String get mathStudioSpatialRotationsLabel => 'Rotations';

  @override
  String get mathStudioSpatialTransformationsLabel => 'Transformations';

  @override
  String get mathStudioSpatialPuzzlesLabel => 'Casse-tetes spatiaux';

  @override
  String get mathStudioFeaturedFormatsSectionLabel => 'Formats a decouvrir';

  @override
  String get mathStudioRelatedLabsSectionLabel => 'Laboratoires lies';

  @override
  String get mathStudioSpatialLabsEntrySubtitle =>
      'Essaie Flight Path Lab et d\'autres outils pratiques qui developpent le raisonnement spatial';

  @override
  String get mathStudioDiscoveryEmptyCategory =>
      'D\'autres cartes pour cette categorie arrivent bientot.';

  @override
  String get mathStudioCategoryEverydayLife => 'Vie quotidienne';

  @override
  String get mathStudioCategoryShopping => 'Achats';

  @override
  String get mathStudioCategoryCooking => 'Cuisine';

  @override
  String get mathStudioCategorySports => 'Sport';

  @override
  String get mathStudioCategoryAviation => 'Aviation';

  @override
  String get mathStudioCategoryTruckingLogistics => 'Transport et logistique';

  @override
  String get mathStudioCategoryHealthcare => 'Sante';

  @override
  String get mathStudioCategoryEngineeringConstruction =>
      'Ingenierie et construction';

  @override
  String get mathStudioCategoryArtDesign => 'Art et design';

  @override
  String get mathStudioCategoryGaming => 'Jeux video';

  @override
  String get mathStudioCategoryBusinessFinance => 'Commerce et finance';

  @override
  String get mathStudioCategoryAll => 'Tout';

  @override
  String get mathStudioDifficultyFoundation => 'Fondamental';

  @override
  String get mathStudioDifficultyIntermediate => 'Intermediaire';

  @override
  String get mathStudioDifficultyAdvanced => 'Avance';

  @override
  String get mathStudioThinkLabel => 'Reflechis a ton rythme';

  @override
  String get mathStudioRevealButton => 'Revele la solution';

  @override
  String get mathStudioRevealedLabel => 'Solution detaillee';

  @override
  String get mathStudioWhereYoullUseThisLabel => 'Ou tu utiliseras cela';

  @override
  String get mathStudioFollowUpLabel => 'A toi d\'essayer';

  @override
  String get mathStudioFollowUpCheckButton => 'Verifier ma reponse';

  @override
  String get mathStudioFollowUpCorrect => 'Bien joue — c\'est exact.';

  @override
  String get mathStudioFollowUpTryAgain =>
      'Pas tout a fait — revois les etapes ci-dessus.';

  @override
  String get mathStudioFollowUpAnswerLabel => 'Reponse';

  @override
  String get mathStudioExportButton => 'Imprimer ou partager';

  @override
  String get mathStudioExportChallengeOnly => 'Fiche defi';

  @override
  String get mathStudioExportSolutionOnly => 'Fiche solution';

  @override
  String get mathStudioExportCombined => 'Defi + solution';

  @override
  String get mathStudioExportIncludeNameLabel =>
      'Inclure mon nom sur cet export';

  @override
  String get mathStudioExportShareAction => 'Partager';

  @override
  String get captainMathCurious => 'Il y a une decouverte ici — regarde.';

  @override
  String get captainMathEncouraging => 'Bien pense — continue.';

  @override
  String get captainMathCalm => 'Remarque comment cela se relie a autre chose.';

  @override
  String get captainMathCelebrating => 'Bravo !';

  @override
  String get mentalMathsCategoryNumberBonds => 'Complements numeriques';

  @override
  String get mentalMathsCategoryDecomposition => 'Decomposition';

  @override
  String get mentalMathsCategoryCompensation => 'Compensation';

  @override
  String get mentalMathsCategoryEstimation => 'Estimation';

  @override
  String get mentalMathsCategoryMultiplicationStrategies =>
      'Strategies de multiplication';

  @override
  String get mentalMathsCategoryDivisionStrategies => 'Strategies de division';

  @override
  String get mentalMathsCategoryPercentages => 'Pourcentages';

  @override
  String get mentalMathsCategoryFractions => 'Fractions';

  @override
  String get mentalMathsCategoryPlaceValue => 'Valeur de position';

  @override
  String get mentalMathsCategoryPatternRecognition =>
      'Reconnaissance de motifs';

  @override
  String get mentalMathsTodaysChallenge => 'Le defi du jour';

  @override
  String get mentalMathsUntimedNote =>
      'Pas de chronometre — prends le temps qu\'il te faut.';

  @override
  String buildConfidenceProgress(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get buildConfidenceContinueButton => 'Continuer';

  @override
  String get buildConfidenceCompletionTitle => 'Bien joue';

  @override
  String get buildConfidenceCompletionBody =>
      'Tu as termine la session d\'aujourd\'hui a ton propre rythme. Reviens quand tu es pret pour la suivante.';

  @override
  String get buildConfidenceDoneButton => 'Termine';

  @override
  String get visualMathsNumberLineTitle => 'Droite numerique';

  @override
  String get visualMathsNumberLineSubtitle =>
      'Fais glisser le point pour explorer les nombres sur une droite';

  @override
  String get visualMathsFractionBarsTitle => 'Barres de fractions';

  @override
  String get visualMathsFractionBarsSubtitle =>
      'Compare des fractions sous forme de barres, cote a cote';

  @override
  String get visualMathsAbacusTitle => 'Boulier anime';

  @override
  String get visualMathsAbacusSubtitle =>
      'Vois la valeur de position en action, boule par boule';

  @override
  String get visualMathsPlaceValueTitle => 'Explorateur de valeur de position';

  @override
  String get visualMathsPlaceValueSubtitle =>
      'Decompose les nombres selon leur valeur de position';

  @override
  String get visualMathsInteractiveBadge => 'Interactif';

  @override
  String get visualMathsPreviewBadge => 'Apercu';

  @override
  String get visualMathsComingSoonNote =>
      'Version interactive disponible dans une prochaine version.';

  @override
  String get visualMathsTryAnotherExample => 'Essayer un autre exemple';

  @override
  String get numberLineExampleBasicWholeNumber =>
      'Un nombre entier sur une droite de 0 a 10';

  @override
  String get numberLineExampleNegativeNumber =>
      'Un nombre negatif sur une droite de −10 a 10';

  @override
  String get numberLineExampleSimpleFraction =>
      'Une fraction sur une droite de 0 a 1';

  @override
  String get numberLineExampleDecimal =>
      'Un nombre decimal sur une droite de 0 a 5';

  @override
  String get fractionBarsCaption1 =>
      '1/2 est exactement la moitie de la barre entiere.';

  @override
  String get fractionBarsCaption2 =>
      '2/4 couvre la meme longueur que 1/2 — des fractions equivalentes.';

  @override
  String get fractionBarsCaption3 =>
      '3/4 est plus que la moitie, moins que le tout.';

  @override
  String get fractionBarsCaption4 =>
      '5/8 depasse tout juste la moitie de la barre entiere.';

  @override
  String get abacusCaption1 =>
      'Une boule deplacee dans la colonne des unites represente 1.';

  @override
  String get abacusCaption2 =>
      'Dix unites se regroupent en une boule dans la colonne des dizaines.';

  @override
  String get abacusCaption3 =>
      'Une boule dans la colonne des centaines vaut 100 unites.';

  @override
  String get placeValueCaption1 =>
      '3742 se decompose en 3 milliers, 7 centaines, 4 dizaines, 2 unites.';

  @override
  String get placeValueCaption2 =>
      '6.4 se decompose en 6 unites et 4 dixiemes.';

  @override
  String get placeValueCaption3 =>
      '805 se decompose en 8 centaines, 0 dizaine, 5 unites — le 0 occupe la position des dizaines.';

  @override
  String get abacusColumnHundreds => 'Centaines';

  @override
  String get abacusColumnTens => 'Dizaines';

  @override
  String get abacusColumnOnes => 'Unites';

  @override
  String get mathStudioRecallCardsTitle => 'Cartes memo';

  @override
  String get mathStudioRecallCardsSubtitle =>
      'Entrainement rapide pour les faits a retenir';

  @override
  String get recallCardsHubTitle => 'Cartes memo';

  @override
  String get recallCardsHubSubtitle =>
      'Entrainement court et cible pour les formules, le vocabulaire, les symboles et les idees qui les sous-tendent';

  @override
  String get recallCardsQuickReviewTitle => 'Revision rapide de cinq cartes';

  @override
  String get recallCardsQuickReviewSubtitle =>
      'Une courte selection quotidienne, choisie pour toi';

  @override
  String get recallCardsReviewDueTitle => 'Revisions dues';

  @override
  String recallCardsReviewDueCount(int count) {
    return '$count a reviser';
  }

  @override
  String get recallCardsReviewDueEmpty =>
      'Rien a reviser pour le moment — bravo';

  @override
  String get recallCardsBrowseByTopicTitle => 'Parcourir par theme';

  @override
  String get recallCardsBrowseByTypeTitle => 'Parcourir par type de carte';

  @override
  String get recallCardsSearchTitle => 'Recherche';

  @override
  String get recallCardsSearchHint =>
      'Rechercher des formules, des termes et des idees';

  @override
  String get recallCardsBookmarksTitle => 'Favoris';

  @override
  String get recallCardsEmptyBookmarks =>
      'Pas encore de favoris — appuie sur l\'icone favori d\'une carte pour l\'enregistrer ici';

  @override
  String get recallCardsNoResults => 'Aucune carte trouvee';

  @override
  String get recallCardsRevealButton => 'Reveler la reponse';

  @override
  String get recallCardsRevealedLabel => 'Reponse';

  @override
  String get recallCardsExplainLabel => 'Pourquoi ca marche';

  @override
  String get recallCardsCommonMistakeLabel => 'Erreur frequente';

  @override
  String get recallCardsConnectLabel => 'Ou c\'est utilise';

  @override
  String get recallCardsRelatedDiscoveryLabel => 'Cartes Decouverte associees';

  @override
  String get recallCardsRelatedPracticeLabel => 'Exercices associes';

  @override
  String get recallCardsRelatedLabsLabel => 'Laboratoires interactifs associes';

  @override
  String get recallCardsLabComingSoon => 'Bientot disponible';

  @override
  String get recallCardsRememberedButton => 'Je m\'en souvenais';

  @override
  String get recallCardsNotYetButton => 'Pas encore';

  @override
  String get recallCardsAskMeTomorrowButton => 'Redemande-moi demain';

  @override
  String get recallCardsBookmarkAdd => 'Ajouter cette carte aux favoris';

  @override
  String get recallCardsBookmarkRemove => 'Retirer des favoris';

  @override
  String get recallCardsExportButton => 'Imprimer ou partager';

  @override
  String get recallCardsExportFiveCardSheet =>
      'Feuille de revision (questions seulement)';

  @override
  String get recallCardsExportAnswerSheet => 'Feuille de reponses';

  @override
  String get recallCardsSessionComplete => 'Session terminee';

  @override
  String get recallCardsSessionCompleteSubtitle =>
      'Bravo — reviens demain pour continuer';

  @override
  String recallCardsCardOf(int current, int total) {
    return 'Carte $current sur $total';
  }

  @override
  String get recallCardsStateNew => 'Nouveau';

  @override
  String get recallCardsStateLearning => 'En apprentissage';

  @override
  String get recallCardsStateReviewDue => 'Revision due';

  @override
  String get recallCardsStateMastered => 'Maitrise';

  @override
  String get recallCardsTypeFormula => 'Formule';

  @override
  String get recallCardsTypeMeaning => 'Signification';

  @override
  String get recallCardsTypeSymbol => 'Symbole';

  @override
  String get recallCardsTypeVocabulary => 'Vocabulaire';

  @override
  String get recallCardsTypeStrategy => 'Strategie';

  @override
  String get recallCardsTypeMisconception => 'Idee recue';

  @override
  String get recallCardsTypeVisual => 'Visuel';

  @override
  String get recallCardsTypeRealWorldConnection => 'Lien avec le reel';

  @override
  String get recallCardsTopicNumber => 'Nombres';

  @override
  String get recallCardsTopicRatioAndProportion => 'Rapports et proportions';

  @override
  String get recallCardsTopicAlgebra => 'Algebre';

  @override
  String get recallCardsTopicGeometryAndMeasures => 'Geometrie et mesures';

  @override
  String get recallCardsTopicStatistics => 'Statistiques';

  @override
  String get recallCardsTopicProbability => 'Probabilites';

  @override
  String get mathStudioInteractiveLabsTitle => 'Laboratoires interactifs';

  @override
  String get mathStudioInteractiveLabsSubtitle =>
      'Des mathematiques concretes a toucher, modifier et tester';

  @override
  String get labsHubTitle => 'Laboratoires interactifs';

  @override
  String get labsHubSubtitle =>
      'Voir un concept, le toucher, le modifier et tester ta prediction';

  @override
  String get labsResetButton => 'Reinitialiser';

  @override
  String get labsCheckButton => 'Verifier';

  @override
  String get labsNextChallengeButton => 'Suivant';

  @override
  String get labsFeedbackCorrect => 'Bravo — c\'est exact.';

  @override
  String get labsFeedbackTryAgain => 'Pas tout a fait — essaie encore.';

  @override
  String get labsRelatedRecallCardsLabel => 'Cartes memo associees';

  @override
  String get labsFractionBuilderTitle => 'Constructeur de fractions';

  @override
  String get labsFractionBuilderSubtitle =>
      'Construis une fraction en remplissant des parts egales';

  @override
  String get labsFractionBuilderConcept =>
      'Une fraction compte des parts egales d\'un tout. Touche les segments pour les remplir et atteindre la fraction cible.';

  @override
  String get labsFractionBuilderWhereUsed =>
      'Partager la nourriture equitablement, lire une recette et mesurer des ingredients reposent tous sur des fractions d\'un tout.';

  @override
  String labsFractionBuilderPrompt(int numerator, int denominator) {
    return 'Remplis $numerator segments sur $denominator.';
  }

  @override
  String labsFractionBuilderFilledCount(int filled, int denominator) {
    return '$filled sur $denominator remplis';
  }

  @override
  String get labsAlgebraBalanceTitle => 'Balance algebrique';

  @override
  String get labsAlgebraBalanceSubtitle =>
      'Garde les deux plateaux egaux pour resoudre x';

  @override
  String get labsAlgebraBalanceConcept =>
      'Une equation reste vraie seulement si tu fais la meme chose des deux cotes. Simplifie etape par etape jusqu\'a isoler x.';

  @override
  String get labsAlgebraBalanceWhereUsed =>
      'Repartir d\'un total pour trouver une quantite inconnue utilise exactement ce principe d\'equilibre.';

  @override
  String labsAlgebraBalanceEquationLabel(String equation) {
    return 'Equation : $equation';
  }

  @override
  String get labsAlgebraBalanceStep1Button => 'Retirer la constante';

  @override
  String get labsAlgebraBalanceStep2Button => 'Diviser pour isoler x';

  @override
  String labsAlgebraBalanceSolvedFeedback(int x) {
    return 'Resolu ! x = $x';
  }

  @override
  String get labsNumberLineExplorerTitle => 'Explorateur de droite numerique';

  @override
  String get labsNumberLineExplorerSubtitle =>
      'Fais glisser pour atteindre une valeur sur la droite';

  @override
  String get labsNumberLineExplorerConcept =>
      'La position d\'un nombre sur une droite numerique correspond a sa valeur — y compris les nombres negatifs et les decimales.';

  @override
  String get labsNumberLineExplorerWhereUsed =>
      'Lire un thermometre, une frise chronologique ou une echelle de mesure repose sur cette correspondance entre position et valeur.';

  @override
  String labsNumberLineExplorerPrompt(String target) {
    return 'Fais glisser le point sur $target.';
  }

  @override
  String get labsFlightPathLabTitle => 'Laboratoire de trajectoire de vol';

  @override
  String get labsFlightPathLabSubtitle =>
      'Regle un cap et une vitesse pour atteindre la cible';

  @override
  String get labsFlightPathLabConcept =>
      'Un cap (relevement) et une vitesse, maintenus pendant un temps fixe, determinent exactement ou tu arrives — cela combine les relevements avec vitesse, distance et temps.';

  @override
  String get labsFlightPathLabWhereUsed =>
      'Les pilotes et les marins utilisent ensemble le relevement et la vitesse pour naviguer vers une destination.';

  @override
  String labsFlightPathLabPrompt(int bearing, int distance) {
    return 'Cible : relevement $bearing°, a $distance km. Le temps de vol est fixe a 2 heures — choisis un cap et une vitesse pour l\'atteindre.';
  }

  @override
  String get labsFlightPathLabRadarLabel =>
      'Une vue radar montrant la cible et, apres un vol test, l\'endroit ou l\'avion a atterri.';

  @override
  String labsFlightPathLabSpeedLabel(int speed) {
    return 'Vitesse : $speed km/h';
  }

  @override
  String get labsFlightPathLabTestButton => 'Vol test';

  @override
  String get labsFlightPathLabResultSpotOn => 'En plein dans le mille !';

  @override
  String get labsFlightPathLabResultClose =>
      'Proche — essaie un petit ajustement.';

  @override
  String get labsFlightPathLabResultTryAgain => 'Ajuste le cap ou la vitesse.';

  @override
  String labsFlightPathLabResultDistance(int distance) {
    return 'Tu as atterri a $distance km de la cible.';
  }

  @override
  String get labsDataDetectiveTitle => 'Detective des donnees';

  @override
  String get labsDataDetectiveSubtitle =>
      'Vois comment une valeur aberrante change une moyenne';

  @override
  String get labsDataDetectiveConcept =>
      'La moyenne est bien plus attiree par une valeur aberrante que la mediane. Retire des valeurs et observe chaque moyenne se mettre a jour en direct.';

  @override
  String get labsDataDetectiveWhereUsed =>
      'Rapporter un salaire, un prix ou un score \'typique\' de facon equitable suppose de savoir quand la moyenne est trompeuse et la mediane un meilleur resume.';

  @override
  String get labsDataDetectiveAddValueButton => 'Ajouter une valeur typique';

  @override
  String get labsDataDetectivePredictionPrompt =>
      'Laquelle changera le plus une fois la valeur aberrante retiree ?';

  @override
  String get labsDataDetectivePredictMeanButton => 'Moyenne';

  @override
  String get labsDataDetectivePredictMedianButton => 'Mediane';

  @override
  String get labsDataDetectiveRevealButton =>
      'Retirer la valeur aberrante et reveler';

  @override
  String get labsDataDetectiveCorrectPrediction => 'Prediction correcte !';

  @override
  String get labsDataDetectiveIncorrectPrediction =>
      'Pas tout a fait — regarde l\'ecart ci-dessous.';

  @override
  String labsDataDetectiveShiftSummary(String meanShift, String medianShift) {
    return 'La moyenne a bouge de $meanShift, la mediane de $medianShift.';
  }

  @override
  String get labsDataDetectiveMeanLabel => 'Moyenne';

  @override
  String get labsDataDetectiveMedianLabel => 'Mediane';

  @override
  String get labsDataDetectiveRangeLabel => 'Etendue';

  @override
  String get labsTryAgainButton => 'Reessayer';

  @override
  String get labsHelpButton => 'Aide';

  @override
  String get labsNarrationReplayButton => 'Rejouer';

  @override
  String get labsNarrationSectionLabel => 'NARRATION DU CAPITAINE MATH';

  @override
  String get labsNarrationOnOffLabel => 'Narration';

  @override
  String get labsNarrationTextOnlyLabel => 'Texte seul (pas de voix)';

  @override
  String get labsNarrationSpeedLabel => 'Vitesse';

  @override
  String get labsNarrationSpeedSlower => 'Plus lent';

  @override
  String get labsNarrationSpeedNormal => 'Normal';

  @override
  String get labsNarrationSpeedFaster => 'Plus rapide';

  @override
  String get labsHelpTitle => 'Aide';

  @override
  String get labsHelpWhatToDo => 'Quoi faire';

  @override
  String get labsHelpWhatToNotice => 'Quoi observer';

  @override
  String get labsHelpWhatItMeans => 'Ce que signifient les maths';

  @override
  String get labsHelpWhereUsed => 'Ou c\'est utilise';

  @override
  String get labsFirstUseTitle => 'Avant de commencer';

  @override
  String get labsFirstUseGotItButton => 'Compris';

  @override
  String get labsGuidanceLevelLabel => 'Niveau de guidage';

  @override
  String get labsGuidanceExplorer => 'Explorateur';

  @override
  String get labsGuidanceBuilder => 'Batisseur';

  @override
  String get labsGuidanceNavigator => 'Navigateur';

  @override
  String get labsDirectionAway => 'Loin de toi';

  @override
  String get labsDirectionRight => 'A droite';

  @override
  String get labsDirectionToward => 'Vers toi';

  @override
  String get labsDirectionLeft => 'A gauche';

  @override
  String get labsFlightPathLabMission =>
      'Dirige l\'avion vers la cible jaune, puis appuie sur Vol test pour voir ou il atterrit.';

  @override
  String labsFlightPathLabHeadingLabel(String direction, int degrees) {
    return 'Direction : $direction  •  Cap : $degrees°';
  }

  @override
  String labsFlightPathLabHeadingNavigatorLabel(String bearing) {
    return 'Cap : $bearing';
  }

  @override
  String get labsFlightPathLabHeadingHelper =>
      'Tourne ceci pour choisir la direction de l\'avion';

  @override
  String get labsFlightPathLabSpeedHelper =>
      'Choisis la distance que l\'avion doit parcourir';

  @override
  String labsFlightPathLabTargetExplanation(int distance, String bearing) {
    return 'Le repere jaune est ta cible. Il est a $distance km, sur un relevement de $bearing.';
  }

  @override
  String get labsFlightPathLabPredictionPrompt =>
      'Avant de tester : vas-tu atterrir trop court, sur la cible, ou trop loin ?';

  @override
  String get labsFlightPathLabPredictShort => 'Trop court';

  @override
  String get labsFlightPathLabPredictOnTarget => 'Sur la cible';

  @override
  String get labsFlightPathLabPredictOver => 'Trop loin';

  @override
  String get labsFlightPathLabHelpWhatToDo =>
      'Regle le cap et la vitesse, fais une prediction si demande, puis appuie sur Vol test.';

  @override
  String get labsFlightPathLabHelpWhatToNotice =>
      'Observe a quelle distance de la cible l\'avion atterrit, et dans quel sens ajuster.';

  @override
  String get labsFlightPathLabHelpWhatItMeans =>
      'Un cap et une vitesse constants, maintenus pendant un temps fixe, menent toujours a un seul point d\'atterrissage — c\'est la vitesse, la distance et le temps combines a une direction.';

  @override
  String get labsFlightPathLabFirstUseStep1 =>
      'Dirige l\'avion vers la cible jaune.';

  @override
  String get labsFlightPathLabFirstUseStep2 =>
      'Choisis la distance que l\'avion doit parcourir.';

  @override
  String get labsFlightPathLabFirstUseStep3 =>
      'Appuie sur Vol test pour voir ou il atterrit.';

  @override
  String get labsDataDetectiveMission =>
      'Predis ce qui arrive a la moyenne et a la mediane, puis retire la valeur inhabituelle pour verifier.';

  @override
  String labsDataDetectiveOutlierExplanation(int outlier) {
    return 'Une valeur, $outlier, se distingue des autres — elle est bien plus haute ou plus basse que le reste. On appelle ca une valeur aberrante.';
  }

  @override
  String labsDataDetectiveBeforeAfter(String meanBefore, String meanAfter,
      String medianBefore, String medianAfter) {
    return 'Moyenne : $meanBefore → $meanAfter. Mediane : $medianBefore → $medianAfter.';
  }

  @override
  String get labsDataDetectiveHelpWhatToDo =>
      'Regarde les valeurs, predis si la moyenne ou la mediane changera le plus, puis retire la valeur aberrante pour reveler la reponse.';

  @override
  String get labsDataDetectiveHelpWhatToNotice =>
      'Observe a quel point la moyenne bouge par rapport a la mediane une fois la valeur aberrante retiree.';

  @override
  String get labsDataDetectiveHelpWhatItMeans =>
      'La moyenne utilise chaque valeur, donc une valeur extreme peut beaucoup la deplacer. La mediane ne depend que de la position centrale, donc elle bouge a peine.';

  @override
  String get labsDataDetectiveFirstUseStep1 =>
      'Regarde la liste des valeurs — l\'une d\'elles se distingue.';

  @override
  String get labsDataDetectiveFirstUseStep2 =>
      'Predis ce qui changera le plus : la moyenne ou la mediane.';

  @override
  String get labsDataDetectiveFirstUseStep3 =>
      'Retire la valeur aberrante et revele la reponse.';

  @override
  String get labsAlgebraBalanceMission =>
      'Garde les deux plateaux en equilibre jusqu\'a ce que x soit seul.';

  @override
  String labsAlgebraBalanceStep1RemoveButton(int value) {
    return 'Retire $value des deux cotes';
  }

  @override
  String labsAlgebraBalanceStep1AddButton(int value) {
    return 'Ajoute $value aux deux cotes';
  }

  @override
  String labsAlgebraBalanceStep2DivideButton(int value) {
    return 'Divise les deux cotes par $value';
  }

  @override
  String get labsAlgebraBalanceHelpWhatToDo =>
      'Retire d\'abord le terme constant, puis divise pour isoler x.';

  @override
  String get labsAlgebraBalanceHelpWhatToNotice =>
      'Observe que les deux plateaux changent toujours ensemble, de la meme quantite — l\'equation reste toujours vraie.';

  @override
  String get labsAlgebraBalanceHelpWhatItMeans =>
      'Appliquer la meme operation aux deux cotes d\'une equation la garde en equilibre, ce qui permet de la simplifier en toute securite jusqu\'a x seul.';

  @override
  String get labsAlgebraBalanceFirstUseStep1 =>
      'Regarde l\'equation et la balance en dessous.';

  @override
  String get labsAlgebraBalanceFirstUseStep2 =>
      'Utilise les boutons pour simplifier les deux cotes ensemble.';

  @override
  String get labsAlgebraBalanceFirstUseStep3 =>
      'Continue jusqu\'a ce que x soit seul.';

  @override
  String labsFractionBuilderMission(int numerator, int denominator) {
    return 'Remplis $numerator parts sur $denominator parts egales.';
  }

  @override
  String get labsFractionBuilderTapGuidance =>
      'Touche un segment pour le remplir, ou touche a nouveau pour le vider.';

  @override
  String labsFractionBuilderSymbolicResult(int numerator, int denominator) {
    return '$numerator/$denominator — $numerator part(s) egale(s) remplie(s) sur $denominator.';
  }

  @override
  String get labsFractionBuilderHelpWhatToDo =>
      'Touche des segments jusqu\'a ce que le nombre rempli corresponde a la fraction, puis appuie sur Verifier.';

  @override
  String get labsFractionBuilderHelpWhatToNotice =>
      'Observe que le denominateur est le nombre total de parts egales, et le numerateur combien sont remplies.';

  @override
  String get labsFractionBuilderHelpWhatItMeans =>
      'Une fraction compte des parts egales d\'un tout — la meme idee qu\'il s\'agisse d\'une barre, d\'une pizza ou d\'une tasse a mesurer.';

  @override
  String get labsFractionBuilderFirstUseStep1 =>
      'Regarde combien de parts remplir.';

  @override
  String get labsFractionBuilderFirstUseStep2 =>
      'Touche les segments pour les remplir.';

  @override
  String get labsFractionBuilderFirstUseStep3 =>
      'Appuie sur Verifier pour voir si tu as trouve la fraction.';

  @override
  String labsNumberLineExplorerMission(String target) {
    return 'Deplace le point sur $target.';
  }

  @override
  String labsNumberLineExplorerStartInstruction(String min) {
    return 'Pars de $min et deplace le point vers la cible.';
  }

  @override
  String labsNumberLineExplorerMoveRight(String distance) {
    return 'Deplace-toi de $distance de plus vers la droite';
  }

  @override
  String labsNumberLineExplorerMoveLeft(String distance) {
    return 'Deplace-toi de $distance de plus vers la gauche';
  }

  @override
  String get labsNumberLineExplorerIncreaseButton => 'Vers la droite';

  @override
  String get labsNumberLineExplorerDecreaseButton => 'Vers la gauche';

  @override
  String get labsNumberLineExplorerHelpWhatToDo =>
      'Fais glisser le point, ou utilise les boutons fleches, pour atteindre la valeur cible, puis appuie sur Verifier.';

  @override
  String get labsNumberLineExplorerHelpWhatToNotice =>
      'Observe comment la position du point correspond a sa valeur — plus a droite est un nombre plus grand, plus a gauche plus petit.';

  @override
  String get labsNumberLineExplorerHelpWhatItMeans =>
      'Une droite numerique montre chaque nombre dans l\'ordre, dans les deux directions depuis zero, y compris les nombres negatifs et les decimales.';

  @override
  String get labsNumberLineExplorerFirstUseStep1 =>
      'Regarde ou le point commence.';

  @override
  String get labsNumberLineExplorerFirstUseStep2 =>
      'Fais glisser le point, ou utilise les boutons fleches, vers la cible.';

  @override
  String get labsNumberLineExplorerFirstUseStep3 =>
      'Appuie sur Verifier pour voir si tu l\'as atteinte.';

  @override
  String labsMissionOf(int current, int total) {
    return 'Mission $current sur $total';
  }

  @override
  String get labsDirectionUp => 'Haut';

  @override
  String get labsDirectionUpRight => 'Haut-droite';

  @override
  String get labsDirectionDownRight => 'Bas-droite';

  @override
  String get labsDirectionDown => 'Bas';

  @override
  String get labsDirectionDownLeft => 'Bas-gauche';

  @override
  String get labsDirectionUpLeft => 'Haut-gauche';

  @override
  String get labsCompassNorth => 'Nord';

  @override
  String get labsCompassNortheast => 'Nord-est';

  @override
  String get labsCompassEast => 'Est';

  @override
  String get labsCompassSoutheast => 'Sud-est';

  @override
  String get labsCompassSouth => 'Sud';

  @override
  String get labsCompassSouthwest => 'Sud-ouest';

  @override
  String get labsCompassWest => 'Ouest';

  @override
  String get labsCompassNorthwest => 'Nord-ouest';

  @override
  String labsFlightPathLabHeadingExplorerLabel(String direction, int degrees) {
    return 'Direction : $direction ($degrees°)';
  }

  @override
  String labsFlightPathLabHeadingCompassLabel(String compass, String bearing) {
    return '$compass • Cap : $bearing';
  }

  @override
  String get labsFlightPathLabTapTargetHint =>
      'Astuce : touche la cible pour viser automatiquement';

  @override
  String get labsFlightPathLabDragCue =>
      'Fais glisser l\'avion pour le tourner';

  @override
  String get labsFlightPathLabNarrationIntroExplorer =>
      'Vise la cible jaune avec l\'avion, puis appuie sur Tester le vol pour voir où il atterrit.';

  @override
  String get labsFlightPathLabNarrationIntroBuilder =>
      'Choisis un cap et une vitesse, prédis où tu vas atterrir, puis teste ta prédiction.';

  @override
  String get labsFlightPathLabNarrationIntroNavigator =>
      'Choisis un cap et une vitesse ; le déplacement obtenu combine le cap et la vitesse fois le temps en un seul vecteur.';

  @override
  String get labsFlightPathLabNarrationResultNearMissExplorer =>
      'Tout près ! Essaie une vitesse ou une direction légèrement différente et teste à nouveau.';

  @override
  String get labsFlightPathLabNarrationResultNearMissBuilder =>
      'Tu as atterri près de la cible. Vérifie si tu es un peu en avance ou en retard, et ajuste légèrement la vitesse ou le cap.';

  @override
  String get labsFlightPathLabNarrationResultNearMissNavigator =>
      'Le déplacement résultant est proche du vecteur cible mais pas exact — affine le cap et/ou la vitesse et teste à nouveau.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer =>
      'Bonne direction ! Mais l\'avion a volé trop loin. Essaie une vitesse plus lente.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder =>
      'Le cap est bon, mais tu as parcouru plus loin que la distance cible. Garde la direction et réduis la vitesse.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator =>
      'Le cap correspond au vecteur cible ; la norme (vitesse × temps) le dépasse — réduis la vitesse pour raccourcir le déplacement.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortExplorer =>
      'Bonne direction ! Mais l\'avion n\'a pas assez volé. Essaie une vitesse plus rapide.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder =>
      'Le cap est bon, mais tu n\'as pas parcouru assez de distance. Garde la direction et augmente la vitesse.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortNavigator =>
      'Le cap correspond au vecteur cible ; la norme est insuffisante — augmente la vitesse pour allonger le déplacement.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceExplorer =>
      'La distance est bonne, mais l\'avion pointe dans la mauvaise direction. Tourne-le vers la cible jaune.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder =>
      'Tu as parcouru la bonne distance, mais dans la mauvaise direction. Ajuste le cap vers le relèvement cible et garde la vitesse.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceNavigator =>
      'La norme est correcte mais le relèvement est décalé — tourne le cap vers le relèvement cible sans changer la vitesse.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceExplorer =>
      'L\'avion pointe dans la mauvaise direction et a parcouru la mauvaise distance. Vise la cible, puis choisis une vitesse.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder =>
      'La direction et la distance doivent toutes deux être ajustées. Revise vers le relèvement cible, puis choisis une vitesse pour la bonne distance.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceNavigator =>
      'Le relèvement et la norme sont tous deux décalés par rapport au vecteur cible — corrige d\'abord le cap, puis ajuste la vitesse pour la distance requise.';

  @override
  String get labsFlightPathLabNarrationCompletionExplorer =>
      'Excellent ! Tu as orienté l\'avion et choisi la bonne vitesse pour atterrir exactement sur la cible.';

  @override
  String get labsFlightPathLabNarrationCompletionBuilder =>
      'Excellent ! Faire correspondre cap et vitesse à une cible, c\'est exactement ainsi que sont établis les vrais plans de vol.';

  @override
  String get labsFlightPathLabNarrationCompletionNavigator =>
      'Correspondance exacte : le vecteur déplacement (relèvement et norme) est égal au vecteur cible — c\'est ainsi que fonctionnent la planification de vol et la navigation en pratique.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedExplorer =>
      'C\'est le même essai que la dernière fois. Change la direction ou la vitesse avant de tester à nouveau.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedBuilder =>
      'Tu as testé exactement le même cap et la même vitesse. Essaie de changer l\'un des deux avant le prochain test.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedNavigator =>
      'Le cap et la vitesse sont inchangés par rapport à l\'essai précédent — fais varier au moins une variable pour obtenir de nouvelles informations.';

  @override
  String get labsFlightPathLabNarrationHintInactivityExplorer =>
      'Toujours là ? Fais glisser l\'avion ou déplace le curseur de vitesse.';

  @override
  String get labsFlightPathLabNarrationHintInactivityBuilder =>
      'Prends ton temps — fais glisser l\'avion pour le viser, ou ajuste la vitesse, quand tu es prêt.';

  @override
  String get labsFlightPathLabNarrationHintInactivityNavigator =>
      'Aucune saisie récente — ajuste le cap ou la vitesse pour continuer.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongExplorer =>
      'Pas tout à fait — regarde si tu dois aller à gauche ou à droite, puis réessaie.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongBuilder =>
      'Compare ta valeur à la cible : déplace-toi vers elle de la différence, puis revérifie.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongNavigator =>
      'La valeur diffère de la cible de plus d\'un pas — ajuste de l\'incrément requis et reteste.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseExplorer =>
      'Tout près ! Plus qu\'un petit pas — essaie encore une fois.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseBuilder =>
      'Tu es à un pas de la cible. Ajuste d\'un seul incrément et revérifie.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseNavigator =>
      'La valeur est à moins d\'un incrément de la cible — un seul ajustement devrait suffire.';

  @override
  String get labsNumberLineExplorerNarrationCompletionExplorer =>
      'Exactement juste ! Tu as trouvé la position exacte de la cible sur la ligne.';

  @override
  String get labsNumberLineExplorerNarrationCompletionBuilder =>
      'Exactement juste ! Faire correspondre une valeur à sa position, c\'est ce que représente une droite numérique.';

  @override
  String get labsNumberLineExplorerNarrationCompletionNavigator =>
      'Correspondance exacte : la position de la valeur sur la ligne correspond précisément à sa valeur numérique, signe et amplitude compris.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedExplorer =>
      'C\'est le même endroit que la dernière fois — déplace-le avant de revérifier.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedBuilder =>
      'Tu as revérifié la même valeur. Déplace-la d\'au moins un pas avant la prochaine vérification.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedNavigator =>
      'La valeur est inchangée depuis la dernière vérification — ajuste-la avant de retester.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityExplorer =>
      'Toujours là ? Fais glisser le repère ou utilise les boutons +/-.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityBuilder =>
      'Prends ton temps — fais glisser le repère ou utilise les boutons +/- quand tu es prêt.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityNavigator =>
      'Aucune saisie récente — ajuste la valeur pour continuer.';

  @override
  String get labsFractionBuilderNarrationResultWrongExplorer =>
      'Pas le bon nombre de parts — compte les segments remplis et compare à la cible.';

  @override
  String get labsFractionBuilderNarrationResultWrongBuilder =>
      'Compare les segments remplis au numérateur, puis ajoute ou retire-en un pour correspondre.';

  @override
  String get labsFractionBuilderNarrationResultWrongNavigator =>
      'Le nombre de segments remplis doit être exactement égal au numérateur — ajuste de la différence.';

  @override
  String get labsFractionBuilderNarrationCompletionExplorer =>
      'C\'est ça ! Tu as rempli exactement le bon nombre de parts.';

  @override
  String get labsFractionBuilderNarrationCompletionBuilder =>
      'C\'est ça ! Compter les parts remplies par rapport à un numérateur, c\'est exactement ce que représente une fraction.';

  @override
  String get labsFractionBuilderNarrationCompletionNavigator =>
      'Correspondance exacte : les segments remplis égalent le numérateur sur le dénominateur affiché, conforme au rapport définissant la fraction.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedExplorer =>
      'Même nombre que la dernière fois — change-le avant de revérifier.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedBuilder =>
      'Tu as revérifié le même nombre de segments remplis. Change-le avant la prochaine vérification.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedNavigator =>
      'Le nombre rempli est inchangé depuis la dernière vérification — ajuste-le avant de retester.';

  @override
  String get labsFractionBuilderNarrationHintInactivityExplorer =>
      'Toujours là ? Touche un segment pour le remplir ou le vider.';

  @override
  String get labsFractionBuilderNarrationHintInactivityBuilder =>
      'Prends ton temps — touche les segments pour ajuster le nombre quand tu es prêt.';

  @override
  String get labsFractionBuilderNarrationHintInactivityNavigator =>
      'Aucune saisie récente — touche un segment pour continuer.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepExplorer =>
      'Retire d\'abord le nombre, puis divise pour trouver x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepBuilder =>
      'Retire d\'abord la constante des deux côtés, puis divise les deux côtés par le coefficient de x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepNavigator =>
      'Applique d\'abord l\'opération additive inverse, puis l\'opération multiplicative inverse, pour isoler x.';

  @override
  String get labsAlgebraBalanceNarrationCompletionExplorer =>
      'Résolu ! Tu as trouvé la valeur de x.';

  @override
  String get labsAlgebraBalanceNarrationCompletionBuilder =>
      'Résolu ! Toute équation de cette forme se résout en retirant la constante, puis en divisant.';

  @override
  String get labsAlgebraBalanceNarrationCompletionNavigator =>
      'Résolu : x est isolé par des opérations inverses appliquées aux deux côtés, préservant l\'égalité tout du long.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityExplorer =>
      'Toujours là ? Essaie le premier bouton pour retirer le nombre.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityBuilder =>
      'Prends ton temps — retire la constante, puis divise, quand tu es prêt.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityNavigator =>
      'Aucune saisie récente — applique la prochaine opération inverse pour continuer.';

  @override
  String get labsDataDetectiveNarrationResultWrongExplorer =>
      'Pas tout à fait — regarde de combien chaque moyenne a changé, puis choisis à nouveau.';

  @override
  String get labsDataDetectiveNarrationResultWrongBuilder =>
      'Compare de combien la moyenne et la médiane ont chacune changé, puis prédis à nouveau selon celle qui a le plus varié.';

  @override
  String get labsDataDetectiveNarrationResultWrongNavigator =>
      'Réexamine les variations calculées : prédis à nouveau selon la statistique dont l\'amplitude de changement est la plus grande.';

  @override
  String get labsDataDetectiveNarrationCompletionExplorer =>
      'Correct ! Tu as repéré quelle moyenne la valeur aberrante affecte le plus.';

  @override
  String get labsDataDetectiveNarrationCompletionBuilder =>
      'Correct ! Identifier quelle statistique une valeur aberrante déforme le plus est exactement l\'idée clé de ce labo.';

  @override
  String get labsDataDetectiveNarrationCompletionNavigator =>
      'Correct : la statistique avec la plus grande variation est plus sensible à la valeur aberrante, cohérent avec la sensibilité de la moyenne aux valeurs extrêmes par rapport à la médiane.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedExplorer =>
      'Même choix que la dernière fois — essaie l\'autre.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedBuilder =>
      'Tu as prédit la même statistique à nouveau. Envisage l\'autre option.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedNavigator =>
      'La même prédiction a été répétée — reconsidère-la à l\'aide des variations calculées.';

  @override
  String get labsDataDetectiveNarrationHintInactivityExplorer =>
      'Toujours là ? Choisis Moyenne ou Médiane, puis touche Révéler.';

  @override
  String get labsDataDetectiveNarrationHintInactivityBuilder =>
      'Prends ton temps — choisis une prédiction et touche Révéler quand tu es prêt.';

  @override
  String get labsDataDetectiveNarrationHintInactivityNavigator =>
      'Aucune saisie récente — choisis une prédiction pour continuer.';

  @override
  String get labsFractionBuilderNarrationIntro =>
      'Touche les segments pour remplir la fraction, puis vérifie ta réponse.';

  @override
  String get labsNumberLineExplorerNarrationIntro =>
      'Déplace le repère vers la valeur cible, puis vérifie ta réponse.';

  @override
  String get labsAlgebraBalanceNarrationIntro =>
      'Utilise les opérations de la balance pour isoler x, étape par étape.';

  @override
  String get labsDataDetectiveNarrationIntro =>
      'Prédis quelle moyenne la valeur aberrante affecte le plus, puis révèle la réponse.';
}
