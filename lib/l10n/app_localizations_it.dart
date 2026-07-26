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
  String get mathStudioMathMagicTitle => 'Matematica & Magia';

  @override
  String get mathStudioMathMagicSubtitle =>
      'Enigmi, schemi e sorprese matematiche divertenti';

  @override
  String get mathStudioMathMagicBody =>
      'Enigmi ricreativi, trucchi numerici e curiosita matematiche';

  @override
  String get mathStudioSpatialIntelligenceTitle => 'Intelligenza spaziale';

  @override
  String get mathStudioSpatialIntelligenceSubtitle =>
      'Sviluppa il tuo senso della forma, dello spazio e del movimento';

  @override
  String get mathStudioSpatialIntelligenceBody =>
      'Sviluppi del cubo, rotazioni, trasformazioni e puzzle spaziali';

  @override
  String get mathStudioInDevelopmentBadge => 'In sviluppo';

  @override
  String get mathStudioInDevelopmentNote =>
      'Questa sezione e ancora in costruzione - torna presto per nuovi contenuti.';

  @override
  String get mathStudioSpatialCubeActivitiesLabel => 'Attivita con i cubi';

  @override
  String get mathStudioSpatialRotationsLabel => 'Rotazioni';

  @override
  String get mathStudioSpatialTransformationsLabel => 'Trasformazioni';

  @override
  String get mathStudioSpatialPuzzlesLabel => 'Puzzle spaziali';

  @override
  String get mathStudioFeaturedFormatsSectionLabel => 'Formati in evidenza';

  @override
  String get mathStudioRelatedLabsSectionLabel => 'Laboratori correlati';

  @override
  String get mathStudioSpatialLabsEntrySubtitle =>
      'Prova Flight Path Lab e altri strumenti pratici che sviluppano il ragionamento spaziale';

  @override
  String get mathStudioDiscoveryEmptyCategory =>
      'Altre carte per questa categoria arriveranno presto.';

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

  @override
  String get mathStudioRecallCardsTitle => 'Schede mnemoniche';

  @override
  String get mathStudioRecallCardsSubtitle =>
      'Allenamento rapido per i fatti da ricordare';

  @override
  String get recallCardsHubTitle => 'Schede mnemoniche';

  @override
  String get recallCardsHubSubtitle =>
      'Allenamento breve e mirato per formule, vocabolario, simboli e le idee alla base';

  @override
  String get recallCardsQuickReviewTitle => 'Ripasso rapido di cinque schede';

  @override
  String get recallCardsQuickReviewSubtitle =>
      'Una breve selezione giornaliera, scelta per te';

  @override
  String get recallCardsReviewDueTitle => 'Ripasso in scadenza';

  @override
  String recallCardsReviewDueCount(int count) {
    return '$count da ripassare';
  }

  @override
  String get recallCardsReviewDueEmpty =>
      'Niente da ripassare al momento — ottimo lavoro';

  @override
  String get recallCardsBrowseByTopicTitle => 'Sfoglia per argomento';

  @override
  String get recallCardsBrowseByTypeTitle => 'Sfoglia per tipo di scheda';

  @override
  String get recallCardsSearchTitle => 'Ricerca';

  @override
  String get recallCardsSearchHint => 'Cerca formule, termini e idee';

  @override
  String get recallCardsBookmarksTitle => 'Preferiti';

  @override
  String get recallCardsEmptyBookmarks =>
      'Ancora nessun preferito — tocca l\'icona preferiti su una scheda per salvarla qui';

  @override
  String get recallCardsNoResults => 'Nessuna scheda trovata';

  @override
  String get recallCardsRevealButton => 'Mostra la risposta';

  @override
  String get recallCardsRevealedLabel => 'Risposta';

  @override
  String get recallCardsExplainLabel => 'Perche funziona';

  @override
  String get recallCardsCommonMistakeLabel => 'Errore comune';

  @override
  String get recallCardsConnectLabel => 'Dove viene usato';

  @override
  String get recallCardsRelatedDiscoveryLabel => 'Schede Scoperta correlate';

  @override
  String get recallCardsRelatedPracticeLabel => 'Esercizi correlati';

  @override
  String get recallCardsRelatedLabsLabel => 'Laboratori interattivi correlati';

  @override
  String get recallCardsLabComingSoon => 'Prossimamente disponibile';

  @override
  String get recallCardsRememberedButton => 'Me lo ricordavo';

  @override
  String get recallCardsNotYetButton => 'Non ancora';

  @override
  String get recallCardsAskMeTomorrowButton => 'Richiedimelo domani';

  @override
  String get recallCardsBookmarkAdd => 'Aggiungi questa scheda ai preferiti';

  @override
  String get recallCardsBookmarkRemove => 'Rimuovi dai preferiti';

  @override
  String get recallCardsExportButton => 'Stampa o condividi';

  @override
  String get recallCardsExportFiveCardSheet =>
      'Foglio di ripasso (solo domande)';

  @override
  String get recallCardsExportAnswerSheet => 'Foglio delle risposte';

  @override
  String get recallCardsSessionComplete => 'Sessione completata';

  @override
  String get recallCardsSessionCompleteSubtitle =>
      'Ottimo lavoro — torna domani per continuare';

  @override
  String recallCardsCardOf(int current, int total) {
    return 'Scheda $current di $total';
  }

  @override
  String get recallCardsStateNew => 'Nuovo';

  @override
  String get recallCardsStateLearning => 'In apprendimento';

  @override
  String get recallCardsStateReviewDue => 'Ripasso in scadenza';

  @override
  String get recallCardsStateMastered => 'Padroneggiato';

  @override
  String get recallCardsTypeFormula => 'Formula';

  @override
  String get recallCardsTypeMeaning => 'Significato';

  @override
  String get recallCardsTypeSymbol => 'Simbolo';

  @override
  String get recallCardsTypeVocabulary => 'Vocabolario';

  @override
  String get recallCardsTypeStrategy => 'Strategia';

  @override
  String get recallCardsTypeMisconception => 'Errore concettuale comune';

  @override
  String get recallCardsTypeVisual => 'Visivo';

  @override
  String get recallCardsTypeRealWorldConnection => 'Collegamento con la realta';

  @override
  String get recallCardsTopicNumber => 'Numeri';

  @override
  String get recallCardsTopicRatioAndProportion => 'Rapporti e proporzioni';

  @override
  String get recallCardsTopicAlgebra => 'Algebra';

  @override
  String get recallCardsTopicGeometryAndMeasures => 'Geometria e misure';

  @override
  String get recallCardsTopicStatistics => 'Statistica';

  @override
  String get recallCardsTopicProbability => 'Probabilita';

  @override
  String get mathStudioInteractiveLabsTitle => 'Laboratori interattivi';

  @override
  String get mathStudioInteractiveLabsSubtitle =>
      'Matematica pratica da toccare, modificare e testare';

  @override
  String get labsHubTitle => 'Laboratori interattivi';

  @override
  String get labsHubSubtitle =>
      'Vedi un concetto, toccalo, modificalo e testa la tua previsione';

  @override
  String get labsResetButton => 'Reimposta';

  @override
  String get labsCheckButton => 'Verifica';

  @override
  String get labsNextChallengeButton => 'Avanti';

  @override
  String get labsFeedbackCorrect => 'Ottimo lavoro — e corretto.';

  @override
  String get labsFeedbackTryAgain => 'Non proprio — riprova.';

  @override
  String get labsRelatedRecallCardsLabel => 'Schede mnemoniche correlate';

  @override
  String get labsFractionBuilderTitle => 'Costruttore di frazioni';

  @override
  String get labsFractionBuilderSubtitle =>
      'Costruisci una frazione riempiendo parti uguali';

  @override
  String get labsFractionBuilderConcept =>
      'Una frazione conta parti uguali di un intero. Tocca i segmenti per riempirli e raggiungere la frazione obiettivo.';

  @override
  String get labsFractionBuilderWhereUsed =>
      'Condividere il cibo in modo equo, leggere una ricetta e misurare gli ingredienti si basano tutti su frazioni di un intero.';

  @override
  String labsFractionBuilderPrompt(int numerator, int denominator) {
    return 'Riempi $numerator segmenti su $denominator.';
  }

  @override
  String labsFractionBuilderFilledCount(int filled, int denominator) {
    return '$filled su $denominator riempiti';
  }

  @override
  String get labsAlgebraBalanceTitle => 'Bilancia algebrica';

  @override
  String get labsAlgebraBalanceSubtitle =>
      'Mantieni i due piatti in equilibrio per risolvere x';

  @override
  String get labsAlgebraBalanceConcept =>
      'Un\'equazione resta vera solo se fai la stessa cosa su entrambi i lati. Semplifica passo dopo passo finche x non resta isolata.';

  @override
  String get labsAlgebraBalanceWhereUsed =>
      'Risalire da un totale a una quantita sconosciuta usa esattamente questo principio di equilibrio.';

  @override
  String labsAlgebraBalanceEquationLabel(String equation) {
    return 'Equazione: $equation';
  }

  @override
  String get labsAlgebraBalanceStep1Button => 'Rimuovi la costante';

  @override
  String get labsAlgebraBalanceStep2Button => 'Dividi per isolare x';

  @override
  String labsAlgebraBalanceSolvedFeedback(int x) {
    return 'Risolto! x = $x';
  }

  @override
  String get labsNumberLineExplorerTitle => 'Esploratore della retta numerica';

  @override
  String get labsNumberLineExplorerSubtitle =>
      'Trascina per raggiungere un valore sulla retta';

  @override
  String get labsNumberLineExplorerConcept =>
      'La posizione di un numero sulla retta numerica corrisponde al suo valore — inclusi numeri negativi e decimali.';

  @override
  String get labsNumberLineExplorerWhereUsed =>
      'Leggere un termometro, una linea del tempo o una scala di misura si basa su questa corrispondenza tra posizione e valore.';

  @override
  String labsNumberLineExplorerPrompt(String target) {
    return 'Trascina il punto su $target.';
  }

  @override
  String get labsFlightPathLabTitle => 'Laboratorio di rotta di volo';

  @override
  String get labsFlightPathLabSubtitle =>
      'Imposta rotta e velocita per raggiungere il bersaglio';

  @override
  String get labsFlightPathLabConcept =>
      'Una rotta (rilevamento) e una velocita, mantenute per un tempo fisso, determinano esattamente dove si atterra — questo combina i rilevamenti con velocita, distanza e tempo.';

  @override
  String get labsFlightPathLabWhereUsed =>
      'Piloti e naviganti usano insieme rilevamento e velocita per navigare verso una destinazione.';

  @override
  String labsFlightPathLabPrompt(int bearing, int distance) {
    return 'Bersaglio: rilevamento $bearing°, a $distance km. Il tempo di volo e fisso a 2 ore — scegli rotta e velocita per raggiungerlo.';
  }

  @override
  String get labsFlightPathLabRadarLabel =>
      'Una vista radar che mostra il bersaglio e, dopo un volo di prova, dove e atterrato l\'aereo.';

  @override
  String labsFlightPathLabSpeedLabel(int speed) {
    return 'Velocita: $speed km/h';
  }

  @override
  String get labsFlightPathLabTestButton => 'Volo di prova';

  @override
  String get labsFlightPathLabResultSpotOn => 'Centrato in pieno!';

  @override
  String get labsFlightPathLabResultClose =>
      'Vicino — prova una piccola correzione.';

  @override
  String get labsFlightPathLabResultTryAgain =>
      'Regola la rotta o la velocita.';

  @override
  String labsFlightPathLabResultDistance(int distance) {
    return 'Sei atterrato a $distance km dal bersaglio.';
  }

  @override
  String get labsDataDetectiveTitle => 'Investigatore dei dati';

  @override
  String get labsDataDetectiveSubtitle =>
      'Scopri come un valore anomalo cambia una media';

  @override
  String get labsDataDetectiveConcept =>
      'La media viene attratta da un valore anomalo molto piu della mediana. Rimuovi valori e osserva ogni media aggiornarsi dal vivo.';

  @override
  String get labsDataDetectiveWhereUsed =>
      'Riportare uno stipendio, un prezzo o un punteggio \'tipico\' in modo equo significa sapere quando la media e fuorviante e la mediana e un riassunto migliore.';

  @override
  String get labsDataDetectiveAddValueButton => 'Aggiungi un valore tipico';

  @override
  String get labsDataDetectivePredictionPrompt =>
      'Quale cambiera di piu una volta rimosso il valore anomalo?';

  @override
  String get labsDataDetectivePredictMeanButton => 'Media';

  @override
  String get labsDataDetectivePredictMedianButton => 'Mediana';

  @override
  String get labsDataDetectiveRevealButton =>
      'Rimuovi il valore anomalo e rivela';

  @override
  String get labsDataDetectiveCorrectPrediction => 'Previsione corretta!';

  @override
  String get labsDataDetectiveIncorrectPrediction =>
      'Non proprio — guarda lo scarto qui sotto.';

  @override
  String labsDataDetectiveShiftSummary(String meanShift, String medianShift) {
    return 'La media si e spostata di $meanShift, la mediana di $medianShift.';
  }

  @override
  String get labsDataDetectiveMeanLabel => 'Media';

  @override
  String get labsDataDetectiveMedianLabel => 'Mediana';

  @override
  String get labsDataDetectiveRangeLabel => 'Intervallo';

  @override
  String get labsTryAgainButton => 'Riprova';

  @override
  String get labsHelpButton => 'Aiuto';

  @override
  String get labsNarrationReplayButton => 'Ripeti';

  @override
  String get labsNarrationSectionLabel => 'NARRAZIONE DI CAPITAN MATH';

  @override
  String get labsNarrationOnOffLabel => 'Narrazione';

  @override
  String get labsNarrationTextOnlyLabel => 'Solo testo (nessun audio parlato)';

  @override
  String get labsNarrationSpeedLabel => 'Velocità';

  @override
  String get labsNarrationSpeedSlower => 'Più lento';

  @override
  String get labsNarrationSpeedNormal => 'Normale';

  @override
  String get labsNarrationSpeedFaster => 'Più veloce';

  @override
  String get labsHelpTitle => 'Aiuto';

  @override
  String get labsHelpWhatToDo => 'Cosa fare';

  @override
  String get labsHelpWhatToNotice => 'Cosa notare';

  @override
  String get labsHelpWhatItMeans => 'Cosa significa la matematica';

  @override
  String get labsHelpWhereUsed => 'Dove viene usato';

  @override
  String get labsFirstUseTitle => 'Prima di iniziare';

  @override
  String get labsFirstUseGotItButton => 'Capito';

  @override
  String get labsGuidanceLevelLabel => 'Livello di guida';

  @override
  String get labsGuidanceExplorer => 'Esploratore';

  @override
  String get labsGuidanceBuilder => 'Costruttore';

  @override
  String get labsGuidanceNavigator => 'Navigatore';

  @override
  String get labsDirectionAway => 'Lontano da te';

  @override
  String get labsDirectionRight => 'A destra';

  @override
  String get labsDirectionToward => 'Verso di te';

  @override
  String get labsDirectionLeft => 'A sinistra';

  @override
  String get labsFlightPathLabMission =>
      'Punta l\'aereo verso il bersaglio giallo, poi premi Volo di prova per vedere dove atterra.';

  @override
  String labsFlightPathLabHeadingLabel(String direction, int degrees) {
    return 'Direzione: $direction  •  Rotta: $degrees°';
  }

  @override
  String labsFlightPathLabHeadingNavigatorLabel(String bearing) {
    return 'Rotta: $bearing';
  }

  @override
  String get labsFlightPathLabHeadingHelper =>
      'Gira questo per scegliere la direzione dell\'aereo';

  @override
  String get labsFlightPathLabSpeedHelper =>
      'Scegli quanto lontano deve volare l\'aereo';

  @override
  String labsFlightPathLabTargetExplanation(int distance, String bearing) {
    return 'Il segnale giallo e il tuo bersaglio. E a $distance km di distanza, con un rilevamento di $bearing.';
  }

  @override
  String get labsFlightPathLabPredictionPrompt =>
      'Prima di testare: atterrerai corto, sul bersaglio, o oltre?';

  @override
  String get labsFlightPathLabPredictShort => 'Corto';

  @override
  String get labsFlightPathLabPredictOnTarget => 'Sul bersaglio';

  @override
  String get labsFlightPathLabPredictOver => 'Oltre';

  @override
  String get labsFlightPathLabHelpWhatToDo =>
      'Imposta rotta e velocita, fai una previsione se richiesto, poi premi Volo di prova.';

  @override
  String get labsFlightPathLabHelpWhatToNotice =>
      'Nota quanto lontano dal bersaglio atterra l\'aereo, e in che direzione correggere.';

  @override
  String get labsFlightPathLabHelpWhatItMeans =>
      'Una rotta e una velocita costanti, mantenute per un tempo fisso, portano sempre a un solo punto di atterraggio — questo unisce velocita, distanza e tempo a una direzione.';

  @override
  String get labsFlightPathLabFirstUseStep1 =>
      'Punta l\'aereo verso il bersaglio giallo.';

  @override
  String get labsFlightPathLabFirstUseStep2 =>
      'Scegli quanto lontano deve volare l\'aereo.';

  @override
  String get labsFlightPathLabFirstUseStep3 =>
      'Premi Volo di prova per vedere dove atterra.';

  @override
  String get labsDataDetectiveMission =>
      'Prevedi cosa succede alla media e alla mediana, poi rimuovi il valore insolito per scoprirlo.';

  @override
  String labsDataDetectiveOutlierExplanation(int outlier) {
    return 'Un valore, $outlier, si distingue dagli altri — e molto piu alto o piu basso degli altri. Si chiama valore anomalo.';
  }

  @override
  String labsDataDetectiveBeforeAfter(String meanBefore, String meanAfter,
      String medianBefore, String medianAfter) {
    return 'Media: $meanBefore → $meanAfter. Mediana: $medianBefore → $medianAfter.';
  }

  @override
  String get labsDataDetectiveHelpWhatToDo =>
      'Guarda i valori, prevedi se la media o la mediana cambiera di piu, poi rimuovi il valore anomalo per rivelare la risposta.';

  @override
  String get labsDataDetectiveHelpWhatToNotice =>
      'Nota quanto si sposta la media rispetto alla mediana una volta rimosso il valore anomalo.';

  @override
  String get labsDataDetectiveHelpWhatItMeans =>
      'La media usa ogni valore, quindi un valore estremo puo spostarla molto. La mediana dipende solo dalla posizione centrale, quindi si muove a malapena.';

  @override
  String get labsDataDetectiveFirstUseStep1 =>
      'Guarda l\'elenco dei valori — uno di essi si distingue.';

  @override
  String get labsDataDetectiveFirstUseStep2 =>
      'Prevedi cosa cambiera di piu: la media o la mediana.';

  @override
  String get labsDataDetectiveFirstUseStep3 =>
      'Rimuovi il valore anomalo e rivela la risposta.';

  @override
  String get labsAlgebraBalanceMission =>
      'Mantieni i due piatti in equilibrio finche x non resta da solo.';

  @override
  String labsAlgebraBalanceStep1RemoveButton(int value) {
    return 'Rimuovi $value da entrambi i lati';
  }

  @override
  String labsAlgebraBalanceStep1AddButton(int value) {
    return 'Aggiungi $value a entrambi i lati';
  }

  @override
  String labsAlgebraBalanceStep2DivideButton(int value) {
    return 'Dividi entrambi i lati per $value';
  }

  @override
  String get labsAlgebraBalanceHelpWhatToDo =>
      'Rimuovi prima il termine numerico, poi dividi per lasciare x da solo.';

  @override
  String get labsAlgebraBalanceHelpWhatToNotice =>
      'Nota che i due piatti cambiano sempre insieme, della stessa quantita — l\'equazione resta sempre vera.';

  @override
  String get labsAlgebraBalanceHelpWhatItMeans =>
      'Applicare la stessa operazione a entrambi i lati di un\'equazione la mantiene in equilibrio, permettendo di semplificarla in sicurezza fino a x da solo.';

  @override
  String get labsAlgebraBalanceFirstUseStep1 =>
      'Guarda l\'equazione e la bilancia sotto di essa.';

  @override
  String get labsAlgebraBalanceFirstUseStep2 =>
      'Usa i pulsanti per semplificare entrambi i lati insieme.';

  @override
  String get labsAlgebraBalanceFirstUseStep3 =>
      'Continua finche x non resta da solo.';

  @override
  String labsFractionBuilderMission(int numerator, int denominator) {
    return 'Riempi $numerator parti su $denominator parti uguali.';
  }

  @override
  String get labsFractionBuilderTapGuidance =>
      'Tocca un segmento per riempirlo, o tocca di nuovo per svuotarlo.';

  @override
  String labsFractionBuilderSymbolicResult(int numerator, int denominator) {
    return '$numerator/$denominator — $numerator parte/i uguale/i riempita/e su $denominator.';
  }

  @override
  String get labsFractionBuilderHelpWhatToDo =>
      'Tocca i segmenti finche il numero riempito corrisponde alla frazione, poi premi Verifica.';

  @override
  String get labsFractionBuilderHelpWhatToNotice =>
      'Nota che il denominatore e il numero totale di parti uguali, e il numeratore quante sono riempite.';

  @override
  String get labsFractionBuilderHelpWhatItMeans =>
      'Una frazione conta parti uguali di un intero — la stessa idea che sia una barra, una pizza o una tazza dosatrice.';

  @override
  String get labsFractionBuilderFirstUseStep1 =>
      'Guarda quante parti riempire.';

  @override
  String get labsFractionBuilderFirstUseStep2 =>
      'Tocca i segmenti per riempirli.';

  @override
  String get labsFractionBuilderFirstUseStep3 =>
      'Premi Verifica per vedere se hai indovinato la frazione.';

  @override
  String labsNumberLineExplorerMission(String target) {
    return 'Sposta il punto su $target.';
  }

  @override
  String labsNumberLineExplorerStartInstruction(String min) {
    return 'Parti da $min e sposta il punto verso il bersaglio.';
  }

  @override
  String labsNumberLineExplorerMoveRight(String distance) {
    return 'Sposta $distance in piu verso destra';
  }

  @override
  String labsNumberLineExplorerMoveLeft(String distance) {
    return 'Sposta $distance in piu verso sinistra';
  }

  @override
  String get labsNumberLineExplorerIncreaseButton => 'Verso destra';

  @override
  String get labsNumberLineExplorerDecreaseButton => 'Verso sinistra';

  @override
  String get labsNumberLineExplorerHelpWhatToDo =>
      'Trascina il punto, o usa i pulsanti freccia, per raggiungere il valore bersaglio, poi premi Verifica.';

  @override
  String get labsNumberLineExplorerHelpWhatToNotice =>
      'Nota come la posizione del punto corrisponda al suo valore — piu a destra e un numero piu grande, piu a sinistra piu piccolo.';

  @override
  String get labsNumberLineExplorerHelpWhatItMeans =>
      'Una retta numerica mostra ogni numero in ordine, in entrambe le direzioni da zero, inclusi numeri negativi e decimali.';

  @override
  String get labsNumberLineExplorerFirstUseStep1 =>
      'Guarda da dove parte il punto.';

  @override
  String get labsNumberLineExplorerFirstUseStep2 =>
      'Trascina il punto, o usa i pulsanti freccia, verso il bersaglio.';

  @override
  String get labsNumberLineExplorerFirstUseStep3 =>
      'Premi Verifica per vedere se lo hai raggiunto.';

  @override
  String labsMissionOf(int current, int total) {
    return 'Missione $current di $total';
  }

  @override
  String get labsDirectionUp => 'Su';

  @override
  String get labsDirectionUpRight => 'Su-destra';

  @override
  String get labsDirectionDownRight => 'Giu-destra';

  @override
  String get labsDirectionDown => 'Giu';

  @override
  String get labsDirectionDownLeft => 'Giu-sinistra';

  @override
  String get labsDirectionUpLeft => 'Su-sinistra';

  @override
  String get labsCompassNorth => 'Nord';

  @override
  String get labsCompassNortheast => 'Nordest';

  @override
  String get labsCompassEast => 'Est';

  @override
  String get labsCompassSoutheast => 'Sudest';

  @override
  String get labsCompassSouth => 'Sud';

  @override
  String get labsCompassSouthwest => 'Sudovest';

  @override
  String get labsCompassWest => 'Ovest';

  @override
  String get labsCompassNorthwest => 'Nordovest';

  @override
  String labsFlightPathLabHeadingExplorerLabel(String direction, int degrees) {
    return 'Direzione: $direction ($degrees°)';
  }

  @override
  String labsFlightPathLabHeadingCompassLabel(String compass, String bearing) {
    return '$compass • Rotta: $bearing';
  }

  @override
  String get labsFlightPathLabTapTargetHint =>
      'Suggerimento: tocca il bersaglio per puntare automaticamente';

  @override
  String get labsFlightPathLabDragCue => 'Trascina l\'aereo per girarlo';

  @override
  String get labsFlightPathLabNarrationIntroExplorer =>
      'Punta l\'aereo verso il bersaglio giallo, poi premi Prova volo per vedere dove atterra.';

  @override
  String get labsFlightPathLabNarrationIntroBuilder =>
      'Imposta rotta e velocità, prevedi dove atterrerai, poi verifica la tua previsione.';

  @override
  String get labsFlightPathLabNarrationIntroNavigator =>
      'Scegli una rotta e una velocità; lo spostamento risultante combina rotta e velocità per tempo in un unico vettore.';

  @override
  String get labsFlightPathLabNarrationResultNearMissExplorer =>
      'Vicinissimo! Prova una velocità o una direzione leggermente diversa e riprova.';

  @override
  String get labsFlightPathLabNarrationResultNearMissBuilder =>
      'Sei atterrato vicino al bersaglio. Controlla se sei leggermente in anticipo o in ritardo, e regola un po\' velocità o rotta.';

  @override
  String get labsFlightPathLabNarrationResultNearMissNavigator =>
      'Lo spostamento risultante è vicino al vettore bersaglio ma non esatto — affina rotta e/o velocità e riprova.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer =>
      'Buona direzione! Ma l\'aereo ha volato troppo lontano. Prova una velocità più bassa.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder =>
      'La rotta è giusta, ma hai percorso più della distanza bersaglio. Mantieni la direzione e riduci la velocità.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator =>
      'La rotta corrisponde al vettore bersaglio; il modulo (velocità × tempo) lo supera — riduci la velocità per accorciare lo spostamento.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortExplorer =>
      'Buona direzione! Ma l\'aereo non ha volato abbastanza lontano. Prova una velocità più alta.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder =>
      'La rotta è giusta, ma non hai percorso abbastanza distanza. Mantieni la direzione e aumenta la velocità.';

  @override
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortNavigator =>
      'La rotta corrisponde al vettore bersaglio; il modulo è insufficiente — aumenta la velocità per allungare lo spostamento.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceExplorer =>
      'La distanza è giusta, ma l\'aereo punta nella direzione sbagliata. Giralo verso il bersaglio giallo.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder =>
      'Hai percorso la distanza giusta, ma nella direzione sbagliata. Regola la rotta verso il rilevamento bersaglio e mantieni la velocità.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceNavigator =>
      'Il modulo è corretto ma il rilevamento è sbagliato — ruota la rotta verso il rilevamento bersaglio senza cambiare la velocità.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceExplorer =>
      'L\'aereo punta nella direzione sbagliata ed è andato alla distanza sbagliata. Punta al bersaglio, poi scegli una velocità.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder =>
      'Sia la direzione che la distanza vanno corrette. Ripunta verso il rilevamento bersaglio, poi imposta una velocità per la distanza giusta.';

  @override
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceNavigator =>
      'Sia il rilevamento che il modulo sono sbagliati rispetto al vettore bersaglio — correggi prima la rotta, poi regola la velocità per la distanza richiesta.';

  @override
  String get labsFlightPathLabNarrationCompletionExplorer =>
      'Centro perfetto! Hai orientato l\'aereo e scelto la velocità giusta per atterrare esattamente sul bersaglio.';

  @override
  String get labsFlightPathLabNarrationCompletionBuilder =>
      'Centro perfetto! Far corrispondere rotta e velocità a un bersaglio è esattamente come si costruiscono i piani di volo reali.';

  @override
  String get labsFlightPathLabNarrationCompletionNavigator =>
      'Corrispondenza esatta: il vettore spostamento (rilevamento e modulo) è uguale al vettore bersaglio — è così che funzionano in pratica la pianificazione del volo e la navigazione.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedExplorer =>
      'È lo stesso tentativo di prima. Cambia direzione o velocità prima di riprovare.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedBuilder =>
      'Hai testato di nuovo esattamente la stessa rotta e velocità. Prova a cambiarne una prima del prossimo test.';

  @override
  String get labsFlightPathLabNarrationHintRepeatedNavigator =>
      'Rotta e velocità sono invariate rispetto al tentativo precedente — varia almeno una variabile per ottenere nuove informazioni.';

  @override
  String get labsFlightPathLabNarrationHintInactivityExplorer =>
      'Sei ancora lì? Trascina l\'aereo o muovi il cursore della velocità.';

  @override
  String get labsFlightPathLabNarrationHintInactivityBuilder =>
      'Prenditi il tuo tempo — trascina l\'aereo per puntarlo, o regola la velocità, quando sei pronto.';

  @override
  String get labsFlightPathLabNarrationHintInactivityNavigator =>
      'Nessun input registrato di recente — regola rotta o velocità per continuare.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongExplorer =>
      'Non proprio — pensa se devi andare a sinistra o a destra, poi riprova.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongBuilder =>
      'Confronta il tuo valore con il bersaglio: spostati verso di esso della differenza, poi ricontrolla.';

  @override
  String get labsNumberLineExplorerNarrationResultWrongNavigator =>
      'Il valore differisce dal bersaglio di più di un passo — regola dell\'incremento richiesto e riprova.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseExplorer =>
      'Vicinissimo! Manca solo un piccolo passo — prova ancora una volta.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseBuilder =>
      'Sei a un passo dal bersaglio. Regola di un singolo incremento e ricontrolla.';

  @override
  String get labsNumberLineExplorerNarrationResultCloseNavigator =>
      'Il valore è entro un incremento dal bersaglio — un solo aggiustamento dovrebbe bastare.';

  @override
  String get labsNumberLineExplorerNarrationCompletionExplorer =>
      'Esatto! Hai trovato la posizione esatta del bersaglio sulla linea.';

  @override
  String get labsNumberLineExplorerNarrationCompletionBuilder =>
      'Esatto! Far corrispondere un valore alla sua posizione è proprio ciò che rappresenta una linea dei numeri.';

  @override
  String get labsNumberLineExplorerNarrationCompletionNavigator =>
      'Corrispondenza esatta: la posizione del valore sulla linea corrisponde precisamente al suo valore numerico, segno e modulo inclusi.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedExplorer =>
      'È lo stesso punto di prima — spostalo prima di ricontrollare.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedBuilder =>
      'Hai ricontrollato lo stesso valore. Spostalo di almeno un passo prima del prossimo controllo.';

  @override
  String get labsNumberLineExplorerNarrationHintRepeatedNavigator =>
      'Il valore è invariato rispetto all\'ultimo controllo — regolalo prima di riprovare.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityExplorer =>
      'Sei ancora lì? Trascina il indicatore o usa i pulsanti +/-.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityBuilder =>
      'Prenditi il tuo tempo — trascina il indicatore o usa i pulsanti +/- quando sei pronto.';

  @override
  String get labsNumberLineExplorerNarrationHintInactivityNavigator =>
      'Nessun input registrato di recente — regola il valore per continuare.';

  @override
  String get labsFractionBuilderNarrationResultWrongExplorer =>
      'Non è il numero giusto di parti — conta i segmenti riempiti e confrontali con il bersaglio.';

  @override
  String get labsFractionBuilderNarrationResultWrongBuilder =>
      'Confronta i segmenti riempiti con il numeratore, poi aggiungine o rimuovine uno per farli corrispondere.';

  @override
  String get labsFractionBuilderNarrationResultWrongNavigator =>
      'Il numero di segmenti riempiti deve essere esattamente uguale al numeratore — regola della differenza.';

  @override
  String get labsFractionBuilderNarrationCompletionExplorer =>
      'Esatto! Hai riempito esattamente il numero giusto di parti.';

  @override
  String get labsFractionBuilderNarrationCompletionBuilder =>
      'Esatto! Contare le parti riempite rispetto a un numeratore è esattamente ciò che rappresenta una frazione.';

  @override
  String get labsFractionBuilderNarrationCompletionNavigator =>
      'Corrispondenza esatta: i segmenti riempiti corrispondono al numeratore sul denominatore mostrato, in linea con il rapporto che definisce la frazione.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedExplorer =>
      'Stesso numero di prima — cambialo prima di ricontrollare.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedBuilder =>
      'Hai ricontrollato lo stesso numero di segmenti riempiti. Cambialo prima del prossimo controllo.';

  @override
  String get labsFractionBuilderNarrationHintRepeatedNavigator =>
      'Il numero riempito è invariato rispetto all\'ultimo controllo — regolalo prima di riprovare.';

  @override
  String get labsFractionBuilderNarrationHintInactivityExplorer =>
      'Sei ancora lì? Tocca un segmento per riempirlo o svuotarlo.';

  @override
  String get labsFractionBuilderNarrationHintInactivityBuilder =>
      'Prenditi il tuo tempo — tocca i segmenti per regolare il numero quando sei pronto.';

  @override
  String get labsFractionBuilderNarrationHintInactivityNavigator =>
      'Nessun input registrato di recente — tocca un segmento per continuare.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepExplorer =>
      'Rimuovi prima il numero, poi dividi per trovare x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepBuilder =>
      'Rimuovi prima la costante da entrambi i lati, poi dividi entrambi i lati per il coefficiente di x.';

  @override
  String get labsAlgebraBalanceNarrationHintNextStepNavigator =>
      'Applica prima l\'operazione additiva inversa, poi quella moltiplicativa inversa, per isolare x.';

  @override
  String get labsAlgebraBalanceNarrationCompletionExplorer =>
      'Risolto! Hai trovato il valore di x.';

  @override
  String get labsAlgebraBalanceNarrationCompletionBuilder =>
      'Risolto! Ogni equazione di questa forma si risolve rimuovendo la costante e poi dividendo.';

  @override
  String get labsAlgebraBalanceNarrationCompletionNavigator =>
      'Risolto: x è isolato tramite operazioni inverse applicate a entrambi i lati, preservando sempre l\'uguaglianza.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityExplorer =>
      'Sei ancora lì? Prova il primo pulsante per rimuovere il numero.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityBuilder =>
      'Prenditi il tuo tempo — rimuovi la costante, poi dividi, quando sei pronto.';

  @override
  String get labsAlgebraBalanceNarrationHintInactivityNavigator =>
      'Nessun input registrato di recente — applica la prossima operazione inversa per continuare.';

  @override
  String get labsDataDetectiveNarrationResultWrongExplorer =>
      'Non proprio — guarda quanto è cambiata ciascuna media, poi scegli di nuovo.';

  @override
  String get labsDataDetectiveNarrationResultWrongBuilder =>
      'Confronta quanto sono cambiate media e mediana, poi prevedi di nuovo in base a quale è cambiata di più.';

  @override
  String get labsDataDetectiveNarrationResultWrongNavigator =>
      'Riesamina le variazioni calcolate: prevedi di nuovo in base a quale statistica è cambiata in misura maggiore.';

  @override
  String get labsDataDetectiveNarrationCompletionExplorer =>
      'Corretto! Hai individuato quale media è più influenzata dal valore anomalo.';

  @override
  String get labsDataDetectiveNarrationCompletionBuilder =>
      'Corretto! Identificare quale statistica un valore anomalo distorce di più è proprio l\'idea chiave di questo laboratorio.';

  @override
  String get labsDataDetectiveNarrationCompletionNavigator =>
      'Corretto: la statistica con la variazione maggiore è più sensibile al valore anomalo, coerentemente con la sensibilità della media ai valori estremi rispetto alla mediana.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedExplorer =>
      'Stessa ipotesi di prima — prova l\'altra.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedBuilder =>
      'Hai previsto di nuovo la stessa statistica. Considera l\'altra opzione.';

  @override
  String get labsDataDetectiveNarrationHintRepeatedNavigator =>
      'La stessa previsione è stata ripetuta — riconsiderala usando i valori di variazione calcolati.';

  @override
  String get labsDataDetectiveNarrationHintInactivityExplorer =>
      'Sei ancora lì? Scegli Media o Mediana, poi tocca Rivela.';

  @override
  String get labsDataDetectiveNarrationHintInactivityBuilder =>
      'Prenditi il tuo tempo — scegli una previsione e tocca Rivela quando sei pronto.';

  @override
  String get labsDataDetectiveNarrationHintInactivityNavigator =>
      'Nessun input registrato di recente — scegli una previsione per continuare.';

  @override
  String get labsFractionBuilderNarrationIntro =>
      'Tocca i segmenti per riempire la frazione, poi controlla la tua risposta.';

  @override
  String get labsNumberLineExplorerNarrationIntro =>
      'Sposta l\'indicatore sul valore bersaglio, poi controlla la tua risposta.';

  @override
  String get labsAlgebraBalanceNarrationIntro =>
      'Usa le operazioni della bilancia per isolare x, un passo alla volta.';

  @override
  String get labsDataDetectiveNarrationIntro =>
      'Prevedi quale media il valore anomalo influenza di più, poi rivela la risposta.';
}
