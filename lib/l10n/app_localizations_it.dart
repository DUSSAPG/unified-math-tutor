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
      'Ogni installazione supporta attualmente un profilo studente. Learning Analytics e report sui progressi sono disponibili da Altro o Profilo.';

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
  String get helpPrivacyBullet3 => 'Learning Analytics disponibile';

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
      'Comprendi i progressi, individua le lacune e sostieni il prossimo passo.';

  @override
  String get helpParentalBullet1 => 'Panoramica progressi';

  @override
  String get helpParentalBullet2 => 'Padronanza degli argomenti';

  @override
  String get helpParentalBullet3 => 'Tendenze di apprendimento';

  @override
  String get helpParentalBullet4 => 'Pratica consigliata';

  @override
  String get helpReportButton => 'Report a Problem';

  @override
  String get helpFooter =>
      'Dati minimi. Niente pubblicità. Learning Analytics disponibile.';

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
      'Sviluppa il pensiero matematico.\nLibera il tuo potenziale.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Apprendimento personalizzato. Progressi misurabili.';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'Sono uno studente';

  @override
  String get onboardingStudentSub =>
      'Esercitati in matematica con un percorso pensato intorno a te.';

  @override
  String get onboardingParentLabel => 'Supporto uno studente';

  @override
  String get onboardingParentSub =>
      'Sostieni ogni fase del suo sviluppo matematico.';

  @override
  String get onboardingTeacherLabel => 'Sono un insegnante';

  @override
  String get onboardingTeacherSub =>
      'Monitora i progressi e assegna esercizi ai tuoi studenti.';

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
      'Dati minimi. Niente pubblicità. Learning Analytics disponibile.';

  @override
  String get onboardingAccessibilityTitle => 'Rendi la lettura più comoda';

  @override
  String get onboardingAccessibilitySub =>
      'Puoi modificare queste impostazioni in qualsiasi momento nelle Impostazioni.';

  @override
  String get onboardingStageTitle => 'Choose your level';

  @override
  String get onboardingStageSub =>
      'We\'ll tailor the content to the right level';

  @override
  String get onboardingStageTitleParent => 'Scegli il livello dello studente';

  @override
  String get onboardingStageSubParent =>
      'Adatteremo i contenuti al suo livello attuale.';

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
  String get onboardingGoalTitleParent => 'Come vuoi supportarlo?';

  @override
  String get onboardingGoalSubParent =>
      'Scegli l\'obiettivo di supporto per questo studente.';

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
      'Aiutare a costruire fiducia in matematica';

  @override
  String get onboardingParentGoal1Sub =>
      'Sostenere una pratica regolare e serena al suo ritmo.';

  @override
  String get onboardingParentGoal2Label =>
      'Individuare lacune di apprendimento';

  @override
  String get onboardingParentGoal2Sub =>
      'Riconoscere gli argomenti che richiedono più attenzione.';

  @override
  String get onboardingParentGoal3Label => 'Seguire i progressi nel tempo';

  @override
  String get onboardingParentGoal3Sub =>
      'Osservare crescita e costanza dagli esercizi completati.';

  @override
  String get onboardingParentGoal4Label =>
      'Supportare la preparazione agli esami';

  @override
  String get onboardingParentGoal4Sub =>
      'Guidare ripasso e pratica per le prossime verifiche.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Come vuoi utilizzare Math Intelligence?';

  @override
  String get onboardingGoalSubTeacher => 'Scegli il focus per la tua classe.';

  @override
  String get onboardingTeacherGoal1Label =>
      'Monitorare i progressi della classe';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Osserva come stanno progredendo i tuoi studenti nel tempo.';

  @override
  String get onboardingTeacherGoal2Label => 'Assegnare esercizi';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Imposta set di esercizi mirati per i tuoi studenti.';

  @override
  String get onboardingTeacherGoal3Label => 'Prepararsi per gli esami';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Sostieni la preparazione agli esami con esercizi mirati.';

  @override
  String get onboardingTeacherGoal4Label => 'Esplorare il programma';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Sfoglia gli argomenti e le soluzioni svolte prima di assegnarli.';

  @override
  String get onboardingProfileTitle => 'Salva i tuoi progressi';

  @override
  String get onboardingProfileSub =>
      'Facoltativo — puoi sempre modificarlo più tardi nel tuo Profilo.';

  @override
  String get onboardingDisplayNameLabel => 'Come vuoi che ti chiamiamo?';

  @override
  String get onboardingDisplayNameSub =>
      'Va bene anche un soprannome: serve solo per il tuo saluto.';

  @override
  String get onboardingDisplayNameHint => 'e.g. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Come vuoi che chiamiamo il tuo studente?';

  @override
  String get onboardingLearnerNameSub => 'Personalizza il suo Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel => 'La tua relazione con lo studente';

  @override
  String get onboardingRelationshipParent => 'Genitore';

  @override
  String get onboardingRelationshipGuardian => 'Tutore legale';

  @override
  String get onboardingRelationshipGrandparent => 'Nonno/a';

  @override
  String get onboardingRelationshipTutor => 'Tutor';

  @override
  String get onboardingRelationshipOther => 'Altro familiare';

  @override
  String get onboardingParentEmailLabel =>
      'Email dell\'adulto di supporto (facoltativa)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Salvata localmente su questo dispositivo per chiarezza dell\'account.';

  @override
  String get onboardingPrivacyNote =>
      'Dettagli profilo solo locali. In questa versione non è promessa sincronizzazione cloud.';

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
      'Learning Analytics e animazioni ricompensa';

  @override
  String get enableParentTools => 'Attiva Learning Analytics';

  @override
  String get parentToolsLocalOnly => 'Consenti Learning Analytics solo locale';

  @override
  String get unlockParentTools => 'Sblocca Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Crea o inserisci il PIN locale a 4 cifre per Learning Analytics.';

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
      'Sviluppa il pensiero matematico.\nLibera il tuo potenziale.';

  @override
  String get onboardingSupportingStatement =>
      'Apprendimento personalizzato.\nProgressi misurabili.';

  @override
  String get onboardingRoleClarification =>
      'Per genitori, tutori, insegnanti, tutor ed educatori homeschool.';

  @override
  String get onboardingCreateAccount => 'Crea account';

  @override
  String get onboardingCreateAccountSub =>
      'Salva progressi, dati di Maths Journey e risultati su questo dispositivo.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Comprendi i progressi, individua le lacune e sostieni il prossimo passo.';

  @override
  String get learningAnalyticsEmptyState =>
      'Completa una sessione di pratica per iniziare a creare Learning Analytics.';

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
  String profileVersionNumber(String version) {
    return 'Versione $version';
  }

  @override
  String get profileCopyright => '© QuantumLab Intelligence';

  @override
  String get profileHeaderTitle => 'Profilo';

  @override
  String get profileHeaderSubtitle =>
      'Personalizza la tua esperienza di apprendimento.';

  @override
  String get profilePreferredDisplayName => 'Nome visualizzato preferito';

  @override
  String get profilePreferredDisplayNameNotSet => 'Non impostato';

  @override
  String get profileChangeDisplayName => 'Cambia nome visualizzato';

  @override
  String get profileGreetingPreview => 'Anteprima saluto';

  @override
  String get profileSwitchLearner => 'Cambia studente';

  @override
  String get profileDisplayNameDialogHint => 'es. Sam o un soprannome';

  @override
  String get whoIsLearningTitle => 'Chi sta imparando oggi?';

  @override
  String get whoIsLearningAddLearner => 'Aggiungi studente';

  @override
  String get whoIsLearningAddLearnerHint => 'Nome dello studente';

  @override
  String homeLearningAsLabel(String name) {
    return 'Stai imparando come: $name';
  }

  @override
  String get homeSwitchLearnerAction => 'Cambia';

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
      'Ogni installazione supporta attualmente un profilo studente. Learning Analytics e report sui progressi sono disponibili da Altro o Profilo.';

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
  String get helpPrivacyBullet3 => 'Learning Analytics disponibile';

  @override
  String get helpPrivacyBullet4 =>
      'Gli strumenti per i genitori sono protetti da PIN';

  @override
  String get helpTermsTitle => 'Condizioni d\'uso';

  @override
  String get helpTermsBody =>
      'Usa l\'app come supporto allo studio. Verifica le decisioni importanti con un insegnante o un genitore.';

  @override
  String get helpParentalTitle => 'Learning Analytics';

  @override
  String get helpParentalHeadline =>
      'Comprendi i progressi, individua le lacune e sostieni il prossimo passo.';

  @override
  String get helpParentalBullet1 => 'Panoramica progressi';

  @override
  String get helpParentalBullet2 => 'Padronanza degli argomenti';

  @override
  String get helpParentalBullet3 => 'Tendenze di apprendimento';

  @override
  String get helpParentalBullet4 => 'Pratica consigliata';

  @override
  String get helpReportButton => 'Segnala un problema';

  @override
  String get helpFooter =>
      'Dati minimi. Niente pubblicità. Learning Analytics disponibile.';

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
  String homeGreetingMorningNamed(String name) {
    return 'Buongiorno, $name';
  }

  @override
  String get homeGreetingMorningDefault => 'Buongiorno';

  @override
  String homeGreetingAfternoonNamed(String name) {
    return 'Buon pomeriggio, $name';
  }

  @override
  String get homeGreetingAfternoonDefault => 'Buon pomeriggio';

  @override
  String homeGreetingEveningNamed(String name) {
    return 'Buonasera, $name';
  }

  @override
  String get homeGreetingEveningDefault => 'Buonasera';

  @override
  String homeGreetingNightNamed(String name) {
    return 'Bentornato, $name';
  }

  @override
  String get homeGreetingNightDefault => 'Bentornato';

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
  String get homeAchievementStreakLocked =>
      'Raggiungi una serie di 7 giorni per sbloccare questo';

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
      'Sviluppa il pensiero matematico.\nLibera il tuo potenziale.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Apprendimento personalizzato. Progressi misurabili.';

  @override
  String get onboardingWhoLabel => 'CHI UTILIZZA L\'APP?';

  @override
  String get onboardingStudentLabel => 'Sono uno studente';

  @override
  String get onboardingStudentSub =>
      'Esercitati in matematica con un percorso pensato intorno a te.';

  @override
  String get onboardingParentLabel => 'Supporto uno studente';

  @override
  String get onboardingParentSub =>
      'Sostieni ogni fase del suo sviluppo matematico.';

  @override
  String get onboardingTeacherLabel => 'Sono un insegnante';

  @override
  String get onboardingTeacherSub =>
      'Monitora i progressi e assegna esercizi ai tuoi studenti.';

  @override
  String get onboardingSelectError => 'Seleziona un\'opzione';

  @override
  String get onboardingContinue => 'Continua';

  @override
  String get onboardingFooter =>
      'Dati minimi. Niente pubblicità. Learning Analytics disponibile.';

  @override
  String get onboardingAccessibilityTitle => 'Rendi la lettura più comoda';

  @override
  String get onboardingAccessibilitySub =>
      'Puoi modificare queste impostazioni in qualsiasi momento nelle Impostazioni.';

  @override
  String get onboardingStageTitle => 'A quale livello si trova lo studente?';

  @override
  String get onboardingStageSub =>
      'Adatteremo il contenuto al livello appropriato';

  @override
  String get onboardingStageTitleParent => 'Scegli il livello dello studente';

  @override
  String get onboardingStageSubParent =>
      'Adatteremo i contenuti al suo livello attuale.';

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
  String get onboardingGoalTitleParent => 'Come vuoi supportarlo?';

  @override
  String get onboardingGoalSubParent =>
      'Scegli l\'obiettivo di supporto per questo studente.';

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
  String get onboardingParentGoal1Label =>
      'Aiutare a costruire fiducia in matematica';

  @override
  String get onboardingParentGoal1Sub =>
      'Sostenere una pratica regolare e serena al suo ritmo.';

  @override
  String get onboardingParentGoal2Label =>
      'Individuare lacune di apprendimento';

  @override
  String get onboardingParentGoal2Sub =>
      'Riconoscere gli argomenti che richiedono più attenzione.';

  @override
  String get onboardingParentGoal3Label => 'Seguire i progressi nel tempo';

  @override
  String get onboardingParentGoal3Sub =>
      'Osservare crescita e costanza dagli esercizi completati.';

  @override
  String get onboardingParentGoal4Label =>
      'Supportare la preparazione agli esami';

  @override
  String get onboardingParentGoal4Sub =>
      'Guidare ripasso e pratica per le prossime verifiche.';

  @override
  String get onboardingGoalTitleTeacher =>
      'Come vuoi utilizzare Math Intelligence?';

  @override
  String get onboardingGoalSubTeacher => 'Scegli il focus per la tua classe.';

  @override
  String get onboardingTeacherGoal1Label =>
      'Monitorare i progressi della classe';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Osserva come stanno progredendo i tuoi studenti nel tempo.';

  @override
  String get onboardingTeacherGoal2Label => 'Assegnare esercizi';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Imposta set di esercizi mirati per i tuoi studenti.';

  @override
  String get onboardingTeacherGoal3Label => 'Prepararsi per gli esami';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Sostieni la preparazione agli esami con esercizi mirati.';

  @override
  String get onboardingTeacherGoal4Label => 'Esplorare il programma';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Sfoglia gli argomenti e le soluzioni svolte prima di assegnarli.';

  @override
  String get onboardingProfileTitle => 'Salva i tuoi progressi';

  @override
  String get onboardingProfileSub =>
      'Facoltativo — puoi sempre modificarlo più tardi nel tuo Profilo.';

  @override
  String get onboardingDisplayNameLabel => 'Come vuoi che ti chiamiamo?';

  @override
  String get onboardingDisplayNameSub =>
      'Va bene anche un soprannome: serve solo per il tuo saluto.';

  @override
  String get onboardingDisplayNameHint => 'e.g. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Come vuoi che chiamiamo il tuo studente?';

  @override
  String get onboardingLearnerNameSub => 'Personalizza il suo Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel => 'La tua relazione con lo studente';

  @override
  String get onboardingRelationshipParent => 'Genitore';

  @override
  String get onboardingRelationshipGuardian => 'Tutore legale';

  @override
  String get onboardingRelationshipGrandparent => 'Nonno/a';

  @override
  String get onboardingRelationshipTutor => 'Tutor';

  @override
  String get onboardingRelationshipOther => 'Altro familiare';

  @override
  String get onboardingParentEmailLabel =>
      'Email dell\'adulto di supporto (facoltativa)';

  @override
  String get onboardingParentEmailHint => 'name@example.com';

  @override
  String get onboardingParentEmailSub =>
      'Salvata localmente su questo dispositivo per chiarezza dell\'account.';

  @override
  String get onboardingPrivacyNote =>
      'Dettagli profilo solo locali. In questa versione non è promessa sincronizzazione cloud.';

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
  String get upgradeBenefit3Title => 'Learning Analytics';

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
  String homeDailyGoalProgress(int completed, int target) {
    return '$completed / $target completati';
  }

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
      'Learning Analytics e animazioni ricompensa';

  @override
  String get enableParentTools => 'Attiva Learning Analytics';

  @override
  String get parentToolsLocalOnly => 'Consenti Learning Analytics solo locale';

  @override
  String get unlockParentTools => 'Sblocca Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Crea o inserisci il PIN locale a 4 cifre per Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

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

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge => 'Powered by Adaptive Learning Intelligence';

  @override
  String get onboardingHeroStatement =>
      'Sviluppa il pensiero matematico.\nLibera il tuo potenziale.';

  @override
  String get onboardingSupportingStatement =>
      'Apprendimento personalizzato.\nProgressi misurabili.';

  @override
  String get onboardingRoleClarification =>
      'Per genitori, tutori, insegnanti, tutor ed educatori homeschool.';

  @override
  String get onboardingCreateAccount => 'Crea account';

  @override
  String get onboardingCreateAccountSub =>
      'Salva progressi, dati di Maths Journey e risultati su questo dispositivo.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Comprendi i progressi, individua le lacune e sostieni il prossimo passo.';

  @override
  String get learningAnalyticsEmptyState =>
      'Completa una sessione di pratica per iniziare a creare Learning Analytics.';

  @override
  String get exploreMathIntelligenceTitle => 'Scopri Math Intelligence';

  @override
  String get exploreHeaderSubtitle =>
      'Cosa offre oggi Math Intelligence, e cosa arriverà.';

  @override
  String get exploreAvailableTodaySection => 'DISPONIBILE OGGI';

  @override
  String get exploreInAtelierSection => 'IN ATELIER';

  @override
  String get exploreInAtelierBadge => 'In Atelier';

  @override
  String get exploreInDevelopmentNote =>
      'Questa funzione è attualmente in fase di sviluppo.';

  @override
  String get exploreRoadmapTitle => 'Filosofia di sviluppo';

  @override
  String get exploreRoadmapBody =>
      'Math Intelligence è pensato per crescere nel tempo. Alcune funzioni sono già disponibili oggi. Altre sono attualmente in fase di sviluppo e test prima del rilascio.';

  @override
  String get explorePersonalisedPracticeTitle => 'Esercitazione personalizzata';

  @override
  String get explorePersonalisedPracticeBody =>
      'Sessioni di domande adattive in base al tuo livello e ai tuoi obiettivi di apprendimento.';

  @override
  String get exploreTopicLearningTitle => 'Apprendimento per argomento';

  @override
  String get exploreTopicLearningBody =>
      'Concentrati su singoli argomenti matematici.';

  @override
  String get exploreTimedChallengesTitle => 'Sfide a tempo';

  @override
  String get exploreTimedChallengesBody => 'Sviluppa velocità e sicurezza.';

  @override
  String get exploreExamSimulatorTitle => 'Simulatore d\'esame';

  @override
  String get exploreExamSimulatorBody =>
      'Esercitati con sessioni d\'esame strutturate.';

  @override
  String get exploreMathsJourneyTitle => 'Il mio Maths Journey';

  @override
  String get exploreMathsJourneyBody =>
      'Segui il tuo percorso di apprendimento nel tempo.';

  @override
  String get exploreLearningAnalyticsBody =>
      'Monitora i progressi e individua le opportunità di crescita.';

  @override
  String get exploreFormulaLibraryBody => 'Riferimento rapido, anche offline.';

  @override
  String get explorePhotoUploadTitle => 'Caricamento foto di esercizi';

  @override
  String get explorePhotoUploadBody =>
      'Carica schede di esercizi, pagine di libri di testo o domande d\'esame.';

  @override
  String get exploreMarkMyPaperTitle => 'Correggi il mio lavoro';

  @override
  String get exploreMarkMyPaperBody =>
      'Ricevi un riscontro strutturato sul lavoro completato.';

  @override
  String get exploreExaminerIntelligenceTitle => 'Logica dell\'esaminatore';

  @override
  String get exploreExaminerIntelligenceBody =>
      'Scopri come gli esaminatori assegnano i punti e individua gli errori più comuni.';

  @override
  String get exploreAdaptiveStudyPlansTitle => 'Piani di studio adattivi';

  @override
  String get exploreAdaptiveStudyPlansBody =>
      'Consigli di studio personalizzati in base al tuo percorso di apprendimento.';

  @override
  String get exploreTutorConversationsTitle => 'Conversazioni con il tutor';

  @override
  String get exploreTutorConversationsBody =>
      'Supporto matematico in linguaggio naturale.';

  @override
  String get journeyCardTitleDefault => 'Il mio Maths Journey';

  @override
  String journeyCardTitleNamed(String name) {
    return 'Il Maths Journey di $name';
  }

  @override
  String get journeyCardCurrentFocusLabel => 'Obiettivo attuale';

  @override
  String get journeyCardGettingStarted => 'Si comincia';

  @override
  String get journeyCardCurrentStreakLabel => 'Serie attuale';

  @override
  String get journeyCardStartStreakToday => 'Inizia oggi la tua serie';

  @override
  String journeyCardStreakDays(int days) {
    return 'Serie di $days giorni';
  }

  @override
  String get journeyCardNextMilestoneLabel => 'Prossimo traguardo';

  @override
  String journeyCardDaysToMilestoneOne(int milestone) {
    return 'Ancora 1 giorno per la tua serie di $milestone giorni';
  }

  @override
  String journeyCardDaysToMilestoneMany(int days, int milestone) {
    return 'Ancora $days giorni per la tua serie di $milestone giorni';
  }

  @override
  String get journeyCardAllMilestonesReached =>
      'Hai raggiunto tutti i traguardi di serie!';

  @override
  String get journeyCardGoalConfidence => 'Stai costruendo fiducia';

  @override
  String get journeyCardGoalSchool =>
      'Stai migliorando la matematica scolastica';

  @override
  String get journeyCardGoalExams => 'Ti stai preparando per gli esami';

  @override
  String get journeyCardGoalChallenge => 'Stai affrontando sfide impegnative';

  @override
  String get journeyCardGoalParentGaps =>
      'Stai individuando lacune di apprendimento';

  @override
  String get journeyCardGoalParentProgress =>
      'Stai seguendo i progressi nel tempo';

  @override
  String get journeyCardGoalParentGcse => 'Ti stai preparando per il GCSE';

  @override
  String get journeyCardGoalTeacherMonitor =>
      'Stai monitorando i progressi della classe';

  @override
  String get journeyCardGoalTeacherAssign => 'Stai assegnando esercizi';

  @override
  String get journeyCardGoalTeacherExplore => 'Stai esplorando il programma';

  @override
  String get mathStudioNavCardTitle => 'Math Studio';

  @override
  String get mathStudioNavCardSubtitle => 'Scopri la matematica che usi gia';

  @override
  String get mathStudioHubTitle => 'Math Studio';

  @override
  String get mathStudioHubTagline =>
      'Scopri la matematica che usi da sempre nella tua vita.';

  @override
  String get mathStudioBuildConfidenceTitle => 'Costruire fiducia';

  @override
  String get mathStudioBuildConfidenceSubtitle =>
      'Esercizi calmi e senza cronometro, con spiegazioni dettagliate';

  @override
  String get mathStudioMentalMathsTitle => 'Calcolo mentale';

  @override
  String get mathStudioMentalMathsSubtitle =>
      'Strategie numeriche quotidiane, senza pressione';

  @override
  String get mathStudioVisualMathsTitle => 'Matematica visiva';

  @override
  String get mathStudioVisualMathsSubtitle =>
      'Vivi la matematica con modelli che puoi muovere';

  @override
  String get mathStudioDiscoveryTitle => 'Libreria delle scoperte';

  @override
  String get mathStudioDiscoverySubtitle =>
      'Matematica reale, una carta alla volta';

  @override
  String get mathStudioCategoryEverydayLife => 'Vita quotidiana';

  @override
  String get mathStudioCategoryShopping => 'Shopping';

  @override
  String get mathStudioCategoryCooking => 'Cucina';

  @override
  String get mathStudioCategorySports => 'Sport';

  @override
  String get mathStudioCategoryAviation => 'Aviazione';

  @override
  String get mathStudioCategoryTruckingLogistics => 'Trasporti e logistica';

  @override
  String get mathStudioCategoryHealthcare => 'Sanita';

  @override
  String get mathStudioCategoryEngineeringConstruction =>
      'Ingegneria e costruzioni';

  @override
  String get mathStudioCategoryArtDesign => 'Arte e design';

  @override
  String get mathStudioCategoryGaming => 'Videogiochi';

  @override
  String get mathStudioCategoryBusinessFinance => 'Business e finanza';

  @override
  String get mathStudioCategoryAll => 'Tutte';

  @override
  String get mathStudioDifficultyFoundation => 'Base';

  @override
  String get mathStudioDifficultyIntermediate => 'Intermedio';

  @override
  String get mathStudioDifficultyAdvanced => 'Avanzato';

  @override
  String get mathStudioThinkLabel => 'Rifletti con calma';

  @override
  String get mathStudioRevealButton => 'Mostra la soluzione';

  @override
  String get mathStudioRevealedLabel => 'Soluzione dettagliata';

  @override
  String get mathStudioWhereYoullUseThisLabel => 'Dove la userai';

  @override
  String get mathStudioFollowUpLabel => 'Prova tu stesso';

  @override
  String get mathStudioFollowUpCheckButton => 'Controlla la mia risposta';

  @override
  String get mathStudioFollowUpCorrect => 'Ottimo lavoro — e corretto.';

  @override
  String get mathStudioFollowUpTryAgain =>
      'Non proprio — ricontrolla i passaggi sopra.';

  @override
  String get mathStudioFollowUpAnswerLabel => 'Risposta';

  @override
  String get mathStudioExportButton => 'Stampa o condividi';

  @override
  String get mathStudioExportChallengeOnly => 'Scheda sfida';

  @override
  String get mathStudioExportSolutionOnly => 'Scheda soluzione';

  @override
  String get mathStudioExportCombined => 'Sfida + soluzione';

  @override
  String get mathStudioExportIncludeNameLabel =>
      'Includi il mio nome in questo export';

  @override
  String get mathStudioExportShareAction => 'Condividi';

  @override
  String get captainMathCurious => 'C\'e una scoperta qui — dai un\'occhiata.';

  @override
  String get captainMathEncouraging => 'Ben pensato — continua cosi.';

  @override
  String get captainMathCalm => 'Nota come questo si collega a qualcos\'altro.';

  @override
  String get captainMathCelebrating => 'Ottimo lavoro!';

  @override
  String get mentalMathsCategoryNumberBonds => 'Complementi numerici';

  @override
  String get mentalMathsCategoryDecomposition => 'Scomposizione';

  @override
  String get mentalMathsCategoryCompensation => 'Compensazione';

  @override
  String get mentalMathsCategoryEstimation => 'Stima';

  @override
  String get mentalMathsCategoryMultiplicationStrategies =>
      'Strategie di moltiplicazione';

  @override
  String get mentalMathsCategoryDivisionStrategies => 'Strategie di divisione';

  @override
  String get mentalMathsCategoryPercentages => 'Percentuali';

  @override
  String get mentalMathsCategoryFractions => 'Frazioni';

  @override
  String get mentalMathsCategoryPlaceValue => 'Valore posizionale';

  @override
  String get mentalMathsCategoryPatternRecognition =>
      'Riconoscimento di schemi';

  @override
  String get mentalMathsTodaysChallenge => 'La sfida di oggi';

  @override
  String get mentalMathsUntimedNote =>
      'Nessun cronometro — prenditi il tempo che ti serve.';

  @override
  String buildConfidenceProgress(int current, int total) {
    return 'Domanda $current di $total';
  }

  @override
  String get buildConfidenceContinueButton => 'Continua';

  @override
  String get buildConfidenceCompletionTitle => 'Ben fatto';

  @override
  String get buildConfidenceCompletionBody =>
      'Hai completato la sessione di oggi al tuo ritmo. Torna quando sei pronto per la prossima.';

  @override
  String get buildConfidenceDoneButton => 'Fatto';

  @override
  String get visualMathsNumberLineTitle => 'Retta numerica';

  @override
  String get visualMathsNumberLineSubtitle =>
      'Trascina il punto per esplorare i numeri su una retta';

  @override
  String get visualMathsFractionBarsTitle => 'Barre delle frazioni';

  @override
  String get visualMathsFractionBarsSubtitle =>
      'Confronta le frazioni come barre, una accanto all\'altra';

  @override
  String get visualMathsAbacusTitle => 'Abaco animato';

  @override
  String get visualMathsAbacusSubtitle =>
      'Vedi il valore posizionale in azione, pallina per pallina';

  @override
  String get visualMathsPlaceValueTitle => 'Esploratore del valore posizionale';

  @override
  String get visualMathsPlaceValueSubtitle =>
      'Scomponi i numeri secondo il loro valore posizionale';

  @override
  String get visualMathsInteractiveBadge => 'Interattivo';

  @override
  String get visualMathsPreviewBadge => 'Anteprima';

  @override
  String get visualMathsComingSoonNote =>
      'Versione interattiva disponibile in una futura release.';

  @override
  String get visualMathsTryAnotherExample => 'Prova un altro esempio';

  @override
  String get numberLineExampleBasicWholeNumber =>
      'Un numero intero su una retta da 0 a 10';

  @override
  String get numberLineExampleNegativeNumber =>
      'Un numero negativo su una retta da −10 a 10';

  @override
  String get numberLineExampleSimpleFraction =>
      'Una frazione su una retta da 0 a 1';

  @override
  String get numberLineExampleDecimal => 'Un decimale su una retta da 0 a 5';

  @override
  String get fractionBarsCaption1 =>
      '1/2 e esattamente meta della barra intera.';

  @override
  String get fractionBarsCaption2 =>
      '2/4 copre la stessa lunghezza di 1/2 — frazioni equivalenti.';

  @override
  String get fractionBarsCaption3 => '3/4 e piu della meta, meno dell\'intero.';

  @override
  String get fractionBarsCaption4 =>
      '5/8 supera di poco la meta della barra intera.';

  @override
  String get abacusCaption1 =>
      'Una pallina spostata nella colonna delle unita rappresenta 1.';

  @override
  String get abacusCaption2 =>
      'Dieci unita si raggruppano in una pallina nella colonna delle decine.';

  @override
  String get abacusCaption3 =>
      'Una pallina nella colonna delle centinaia vale 100 unita.';

  @override
  String get placeValueCaption1 =>
      '3742 si scompone in 3 migliaia, 7 centinaia, 4 decine, 2 unita.';

  @override
  String get placeValueCaption2 => '6.4 si scompone in 6 unita e 4 decimi.';

  @override
  String get placeValueCaption3 =>
      '805 si scompone in 8 centinaia, 0 decine, 5 unita — lo 0 occupa la posizione delle decine.';

  @override
  String get abacusColumnHundreds => 'Centinaia';

  @override
  String get abacusColumnTens => 'Decine';

  @override
  String get abacusColumnOnes => 'Unita';
}
