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
  String get practiceExamEntranceExamPrep => 'Entrance Exam Prep';

  @override
  String get entranceExamHubTitle => 'Entrance Exam Preparation';

  @override
  String get entranceExamHubIntro =>
      'Independent-school entrance exam practice, separate from GCSE Exam Simulator — built for the 11+ age group and marked by comparing your own working to a model answer, not typed multiple choice.';

  @override
  String get entranceExamDisclaimerHeading =>
      'Not affiliated with any school or exam board';

  @override
  String get entranceExamAgeBandLabel => 'Age band';

  @override
  String get entranceExamDurationLabel => 'Duration';

  @override
  String get entranceExamCalculatorLabel => 'Calculator';

  @override
  String get entranceExamCalculatorNone => 'Not allowed';

  @override
  String get entranceExamCalculatorAllowed => 'Allowed';

  @override
  String get entranceExamCalculatorAllowedNonScientific =>
      'Allowed (non-scientific)';

  @override
  String entranceExamDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get entranceExamModePracticeBySkillTitle => 'Practice by Skill';

  @override
  String get entranceExamModePracticeBySkillSub =>
      'Work through questions grouped by skill, with worked methods to compare against.';

  @override
  String get entranceExamModeReviewMethodsTitle => 'Review Methods';

  @override
  String get entranceExamModeReviewMethodsSub =>
      'Revisit every available question\'s full worked method — no timer, no marking.';

  @override
  String get entranceExamModeUntimedPaperTitle => 'Untimed Paper';

  @override
  String get entranceExamModeUntimedPaperSub =>
      'Sit the complete paper with no time limit.';

  @override
  String get entranceExamModeTimedMockTitle => 'Timed Mock';

  @override
  String get entranceExamModeTimedMockSub =>
      'Sit the complete paper under real exam timing.';

  @override
  String get entranceExamModeScholarshipChallengeTitle =>
      'Scholarship Challenge';

  @override
  String get entranceExamModeScholarshipChallengeSub =>
      'A stretch paper for scholarship-tier candidates.';

  @override
  String entranceExamModeLockedFullPaperReason(int declared, int authored) {
    return 'Unlocks once the full $declared-question paper is ready — $authored authored so far.';
  }

  @override
  String get entranceExamModeLockedScholarshipReason =>
      'This pack is Foundation tier — Scholarship Challenge needs a scholarship-tier pack.';

  @override
  String get entranceExamModeLockedBadge => 'Coming soon';

  @override
  String get entranceExamSkillPickerTitle => 'Choose a Skill';

  @override
  String entranceExamSkillQuestionCountLabel(int count) {
    return '$count questions available';
  }

  @override
  String get entranceExamSkillNumberFluency => 'Number Fluency';

  @override
  String get entranceExamSkillFractionsAndPercentages =>
      'Fractions & Percentages';

  @override
  String get entranceExamSkillRatioAndProportion => 'Ratio & Proportion';

  @override
  String get entranceExamSkillAlgebraicReasoning => 'Algebraic Reasoning';

  @override
  String get entranceExamSkillShapeAndSpace => 'Shape & Space';

  @override
  String get entranceExamSkillDataAndLogic => 'Data & Logic';

  @override
  String entranceExamQuestionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get entranceExamRevealMethodButton => 'Reveal worked method';

  @override
  String get entranceExamMethodMarkPrompt =>
      'Compare this to your own working. Which best matches what you wrote?';

  @override
  String get entranceExamMethodMarkCorrect => 'Correct — full method shown';

  @override
  String get entranceExamMethodMarkSlip => 'Method right, one slip';

  @override
  String get entranceExamMethodMarkPartial => 'Partial reasoning';

  @override
  String get entranceExamMethodMarkUnsupported => 'Answer only, no method';

  @override
  String get entranceExamMethodMarkBlank => 'I didn\'t attempt this';

  @override
  String get entranceExamNextQuestionButton => 'Next question';

  @override
  String get entranceExamSessionCompleteTitle => 'Practice Complete';

  @override
  String entranceExamSessionEstimatedMarks(String marks, int total) {
    return 'Estimated marks: $marks / $total';
  }

  @override
  String get entranceExamSessionEstimatedMarksNote =>
      'An estimate from your own self-marking, not an official mark scheme — see the guidance under each question.';

  @override
  String get entranceExamReviewTitle => 'Review Methods';

  @override
  String get entranceExamNoHandwritingNote =>
      'This app never reads or grades your handwritten working — you compare it yourself against the worked method shown.';

  @override
  String get practiceExit => 'Exit';

  @override
  String practiceQuestionOf(int current) {
    return 'Question $current';
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
  String get practiceUnavailableTitle =>
      'This practice area is not available yet.';

  @override
  String get practiceUnavailableAction => 'Choose a different topic';

  @override
  String get practiceEnglishContentNotice =>
      'Practice questions are currently only available in English.';

  @override
  String practiceTopicUnavailableForStage(
      String topic, String stage, String stages) {
    return '$topic isn\'t available for $stage yet — try $stages.';
  }

  @override
  String practiceTopicUnavailableEverywhere(String topic) {
    return '$topic isn\'t available for practice yet in any stage.';
  }

  @override
  String get topicHubSubtitle =>
      'See what you can genuinely do with this topic';

  @override
  String get topicHubStageLabel => 'Stage';

  @override
  String get topicHubSectionPractise => 'Practise';

  @override
  String get topicHubSectionLearn => 'Learn';

  @override
  String get topicHubSectionExplore => 'Explore';

  @override
  String topicHubNoActivities(String stage) {
    return 'No activities are available for this topic at $stage yet.';
  }

  @override
  String get ratioFoundationsHubCardTitle => 'Ratio scaling foundations';

  @override
  String get ratioFoundationsHubCardReason =>
      'Recognise equivalent ratios, then guided and independent practice scaling both parts consistently.';

  @override
  String get ratioFoundationsScreenTitle => 'Ratio Scaling Foundations';

  @override
  String get ratioFoundationsRungRecognise => 'Recognise';

  @override
  String get ratioFoundationsRungGuided => 'Guided practice';

  @override
  String get ratioFoundationsRungFluency => 'Fluency practice';

  @override
  String get ratioFoundationsShowHint => 'Show hint';

  @override
  String get ratioFoundationsHideHint => 'Hide hint';

  @override
  String get ratioFoundationsCorrect => 'Correct!';

  @override
  String get ratioFoundationsIncorrect => 'Not quite';

  @override
  String get ratioFoundationsContinue => 'Continue';

  @override
  String get ratioFoundationsNextItem => 'Next item';

  @override
  String ratioFoundationsFluencyProgress(int correct, int target) {
    return '$correct of $target fluency items correct so far';
  }

  @override
  String get ratioFoundationsCompletionTitle =>
      'Ratio scaling foundations completed.';

  @override
  String get ratioFoundationsCompletionBody =>
      'More Ratio learning is coming soon.';

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
  String homeThemeToggleSemanticLabel(String mode) {
    return 'Theme: $mode. Change theme';
  }

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
  String get interactiveStudiosTitle => 'Interactive Studios';

  @override
  String get footballStudioDescription =>
      'Football Studio includes applied-learning activities in Coordinates, Ratio & Scale, Angles, Distance-Time-Speed, Area, and Algebra.';

  @override
  String get footballStudioChecking =>
      'Checking whether Football Studio is installed…';

  @override
  String get footballStudioInstalled =>
      'Football Studio is installed and ready to open.';

  @override
  String get footballStudioUnavailable =>
      'Football Studio is not installed on this device.';

  @override
  String get footballStudioInstallNeeded =>
      'Install Football Studio separately to open these activities.';

  @override
  String get footballStudioOpen => 'Open Football Studio';

  @override
  String get footballStudioOpening => 'Opening Football Studio…';

  @override
  String get footballStudioCheckFailed =>
      'Could not check whether Football Studio is installed.';

  @override
  String get footballStudioLaunchFailed =>
      'Football Studio is installed, but Android could not open it.';

  @override
  String get footballStudioTryAgain => 'Try opening again';

  @override
  String get footballStudioCheckAgain => 'Check again';

  @override
  String get footballStudioAndroidOnly =>
      'Football Studio is available as a separate Android app.';

  @override
  String get footballStudioProgressOwnership =>
      'Achievements and progress stay on this device in Football Studio for V1. Unified Math Tutor does not read or share them.';

  @override
  String get navHideAction => 'Hide navigation';

  @override
  String get navShowAction => 'Show navigation';

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
  String get mathStudioMathMagicNumberTricksLabel => 'Visual Number Tricks';

  @override
  String get mathStudioMathMagicNumberTricksSubtitle =>
      'Watch a number trick unfold, step by step';

  @override
  String get mathStudioMathMagicPatternsLabel => 'Patterns';

  @override
  String get mathStudioMathMagicPatternsSubtitle =>
      'Grow a dot pattern and discover the rule behind it';

  @override
  String get mathStudioMathMagicMagicSquaresLabel => 'Magic Squares';

  @override
  String get mathStudioMathMagicMagicSquaresSubtitle =>
      'Arrange numbers so every line adds up the same';

  @override
  String get mathStudioMathMagicParityLabel => 'Parity';

  @override
  String get mathStudioMathMagicParitySubtitle =>
      'Explore what happens when you add odd and even numbers';

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
  String get mathStudioSpatialCubeNetsLabel => 'Cube Nets';

  @override
  String get mathStudioSpatialCubeNetsSubtitle =>
      'Decide which nets fold into a closed cube';

  @override
  String get mathStudioSpatialRotationsSubtitle =>
      'Turn a shape around a fixed point and see what changes';

  @override
  String get mathStudioSpatialTransformationsSubtitle =>
      'Translate, reflect, rotate and enlarge on a coordinate grid';

  @override
  String get mathStudioSpatialPuzzlesSubtitle =>
      'Short puzzles about shape, space and 3D thinking';

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
  String get mathStudioCategoryArchitectureConstruction =>
      'Architecture & Construction';

  @override
  String get mathStudioCategoryEnvironmentClimate => 'Environment & Climate';

  @override
  String get mathStudioCategoryComputingCryptography =>
      'Computing & Cryptography';

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
  String get recallCardsTopicFilterGroupLabel => 'Topic';

  @override
  String get recallCardsTypeFilterGroupLabel => 'Card type';

  @override
  String get recallCardsMoreChipLabel => 'More';

  @override
  String get recallCardsMoreTopicsSheetTitle => 'More topics';

  @override
  String get recallCardsMoreTypesSheetTitle => 'More card types';

  @override
  String get recallCardsClearFiltersButton => 'Clear filters';

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
  String get labsSpatialCubeLabTitle => 'Spatial Cube Lab';

  @override
  String get labsSpatialCubeLabSubtitle =>
      'Rotate, fold and explore a labelled cube';

  @override
  String get labsSpatialCubeLabIntro =>
      'Drag the cube to turn it. Notice how faces stay in the same place relative to each other, no matter which way you turn.';

  @override
  String get labsSpatialCubeLabFreePlayCaption =>
      'Try it: drag the cube, or use the buttons below.';

  @override
  String get labsSpatialCubeWhichFaceOppositeTitle => 'Which Face Is Opposite?';

  @override
  String get labsSpatialCubeWhichFaceOppositeSubtitle =>
      'Predict the opposite face, then check by rotating';

  @override
  String get labsSpatialCubeRotateToMatchTitle => 'Rotate to Match';

  @override
  String get labsSpatialCubeRotateToMatchSubtitle =>
      'Turn your cube to match the target orientation';

  @override
  String get labsSpatialCubeHiddenFaceTitle => 'Hidden Face';

  @override
  String get labsSpatialCubeHiddenFaceSubtitle =>
      'Work out which label is on a face you can\'t see';

  @override
  String get labsSpatialCubeNetExplorerTitle => 'Cube Net Explorer';

  @override
  String get labsSpatialCubeNetExplorerSubtitle =>
      'Predict opposite faces on a flat net, then fold it';

  @override
  String get labsEarlyMathsPlaygroundTitle => 'Early Maths Playground';

  @override
  String get labsEarlyMathsPlaygroundSubtitle =>
      'Calm, playful counting, sharing and early-fraction activities for younger learners';

  @override
  String get earlyMathsPlaygroundIntro =>
      'A calm, untimed space for younger learners to practise counting, sharing and early fractions — no scores, no timers, no pressure.';

  @override
  String get feedTheHungryPandaTitle => 'Feed the Hungry Panda';

  @override
  String get feedTheHungryPandaSubtitle =>
      'Count out apples one at a time to feed Panda';

  @override
  String get abacusPlayModeGuided => 'Guided';

  @override
  String get abacusPlayModeFree => 'Free explore';

  @override
  String get abacusPlayFreeTitle => 'Free explore';

  @override
  String get abacusPlayFreeIntro =>
      'Slide beads across the bar to make any number up to 999. There is no goal here. Just explore.';

  @override
  String get abacusPlayHowTo =>
      'Tap a bead, or drag it across the bar, to count it. Tap a counted bead to send it back.';

  @override
  String get abacusPlayReset => 'Reset';

  @override
  String get abacusPlayBuildTitle => 'Build a number';

  @override
  String get abacusPlayBuildTask =>
      'Build 34. Slide 3 tens and 4 ones across the bar.';

  @override
  String get abacusPlayBuildDone => 'You built 34: 3 tens and 4 ones.';

  @override
  String get abacusPlayBreakTitle => 'Break a number apart';

  @override
  String get abacusPlayBreakTask =>
      'This is 47. Slide the 7 ones back so only the tens are left.';

  @override
  String get abacusPlayBreakDone => '47 breaks apart into 40 and 7.';

  @override
  String get abacusPlayExchangeTitle => 'Swap ten ones for one ten';

  @override
  String get abacusPlayExchangeTask =>
      'This is 29. Press +1 to add one more, and watch what happens to the ones.';

  @override
  String get abacusPlayExchangeDone =>
      '10 ones swapped for 1 ten, so 29 + 1 = 30.';

  @override
  String get abacusPlayNoteTenOnes => '10 ones swapped for 1 ten.';

  @override
  String get abacusPlayNoteTenTens => '10 tens swapped for 1 hundred.';

  @override
  String get abacusPlayNoteTenOnesAndTens =>
      '10 ones swapped for 1 ten, and 10 tens for 1 hundred.';

  @override
  String get abacusPlayNoteTenToOnes => '1 ten swapped for 10 ones.';

  @override
  String get abacusPlayNoteHundredToTens => '1 hundred swapped for 10 tens.';

  @override
  String get abacusPlayNoteHundredCascade =>
      '1 hundred swapped for 10 tens, and 1 ten for 10 ones.';

  @override
  String get abacusPlayParentNote =>
      'For grown-ups: each rod holds up to nine beads. The Number Board shows the same number in digits, and the two always match. Ten beads on one rod swap for one bead on the rod to its left. Ask your child to say what changed. This is a hands-on picture of place value, not a test.';

  @override
  String get abacusBoardTitle => 'Number Board';

  @override
  String get abacusBoardZero => '0: no beads counted yet';

  @override
  String get abacusBoardAddOne => 'Add 1';

  @override
  String get abacusBoardSubtractOne => 'Take away 1';

  @override
  String get abacusBoardAddTen => 'Add 10';

  @override
  String get abacusBoardSubtractTen => 'Take away 10';

  @override
  String get abacusSpokenZero => '0. No beads are counted yet.';

  @override
  String abacusPlayRodLabel(String name) {
    return '$name rod';
  }

  @override
  String abacusPlayRodValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count beads counted',
      one: '1 bead counted',
      zero: 'No beads counted',
    );
    return '$_temp0';
  }

  @override
  String abacusPlayPartHundreds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hundreds',
      one: '1 hundred',
    );
    return '$_temp0';
  }

  @override
  String abacusPlayPartTens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tens',
      one: '1 ten',
    );
    return '$_temp0';
  }

  @override
  String abacusPlayPartOnes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ones',
      one: '1 one',
    );
    return '$_temp0';
  }

  @override
  String abacusBoardEquationOne(int value, String a) {
    return '$value = $a';
  }

  @override
  String abacusBoardEquationTwo(int value, String a, String b) {
    return '$value = $a + $b';
  }

  @override
  String abacusBoardEquationThree(int value, String a, String b, String c) {
    return '$value = $a + $b + $c';
  }

  @override
  String abacusSpokenOne(int value, String a) {
    return '$value is $a';
  }

  @override
  String abacusSpokenTwo(int value, String a, String b) {
    return '$value is $a and $b';
  }

  @override
  String abacusSpokenThree(int value, String a, String b, String c) {
    return '$value is $a, $b and $c';
  }

  @override
  String feedPandaInstruction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apples',
      one: '1 apple',
    );
    return 'Feed Panda $_temp0.';
  }

  @override
  String feedPandaWellDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apples',
      one: '1 apple',
    );
    return 'Well done! Panda ate $_temp0.';
  }

  @override
  String get feedPandaHowManyLeft => 'How many apples are left?';

  @override
  String get feedPandaHasEnough => 'Panda has enough. Let\'s count together.';

  @override
  String get feedPandaReplayInstructionButton => 'Replay instruction';

  @override
  String get feedPandaNewRoundButton => 'New Round';

  @override
  String feedPandaFruitSemanticLabel(int position, int total) {
    return 'Apple $position of $total. Double tap to select.';
  }

  @override
  String get feedPandaSelectedSuffix => 'Selected.';

  @override
  String feedPandaPandaSemanticReady(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining more apples needed',
      one: '1 more apple needed',
    );
    return 'Feed Panda. $_temp0.';
  }

  @override
  String get feedPandaPandaSemanticFull => 'Panda has enough for this round.';

  @override
  String feedPandaAnswerChoiceSemanticLabel(int value) {
    return 'Answer $value.';
  }

  @override
  String get feedPandaTryAgainMessage => 'Not quite — let\'s try again!';

  @override
  String get feedPandaRoundCompleteMessage => 'You counted brilliantly!';

  @override
  String feedPandaBasketSemanticLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apples in the basket.',
      one: '1 apple in the basket.',
      zero: 'The basket is empty.',
    );
    return '$_temp0';
  }

  @override
  String feedPandaBowlSemanticLabel(int given, int target) {
    String _temp0 = intl.Intl.pluralLogic(
      target,
      locale: localeName,
      other: '$target apples',
      one: '1 apple',
    );
    return 'Panda has $given of $_temp0.';
  }

  @override
  String get feedPandaDropZoneLabel => 'Give apples to Panda here';

  @override
  String get feedPandaTapPandaHint => 'Apple picked. Now tap Panda to give it.';

  @override
  String get labsSpatialCubeWhichFaceOppositeMission =>
      'Look at the cube, then decide which face is opposite the one asked about.';

  @override
  String labsSpatialCubeWhichFaceOppositeQuestion(String faceLabel) {
    return 'Which face is opposite $faceLabel?';
  }

  @override
  String get labsSpatialCubeWhichFaceOppositeHintButton => 'Hint';

  @override
  String get labsSpatialCubeWhichFaceOppositeHintText =>
      'Opposite faces never share an edge — front/back, top/bottom and left/right are always the three pairs.';

  @override
  String get labsSpatialCubeWhichFaceOppositeCorrect =>
      'Good thinking. You kept the face relationships in mind.';

  @override
  String get labsSpatialCubeWhichFaceOppositeIncorrect =>
      'Nearly there. Try looking at which faces share an edge.';

  @override
  String get labsSpatialCubeWhichFaceOppositeWhereUsed =>
      'Packing boxes, reading dice, and working with 3D nets all rely on knowing which faces of a cube are opposite each other.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToDo =>
      'Rotate the cube if you like, then choose the face you think is opposite the one asked about.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToNotice =>
      'Notice that opposite faces are never next to each other, however you turn the cube.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatItMeans =>
      'Every cube has exactly three pairs of opposite faces — front/back, top/bottom, left/right — and rotating the cube never changes which faces are paired.';

  @override
  String labsSpatialCubeWhichFaceOppositeReveal(
      String correctLabel, String askedLabel) {
    return '$correctLabel is opposite $askedLabel.';
  }

  @override
  String get labsSpatialCubeRotateToMatchMission =>
      'Rotate your cube until it matches the target orientation shown.';

  @override
  String get labsSpatialCubeRotateToMatchTargetLabel => 'Target orientation';

  @override
  String get labsSpatialCubeRotateToMatchYourCubeLabel => 'Your cube';

  @override
  String get labsSpatialCubeRotateToMatchTestButton => 'Test my rotation';

  @override
  String get labsSpatialCubeRotateToMatchCorrect =>
      'Well done — that\'s a close match.';

  @override
  String get labsSpatialCubeRotateToMatchIncorrect =>
      'Not quite yet. Compare which face is at the front and which is on top.';

  @override
  String get labsSpatialCubeRotateToMatchWhereUsed =>
      'Matching an object\'s orientation to a diagram is part of reading technical drawings and assembly instructions.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatToDo =>
      'Drag your cube so its faces line up with the target shown alongside it, then test your rotation.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatToNotice =>
      'Notice you don\'t need a pixel-perfect match — being close enough that the same faces are at the front and top counts.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatItMeans =>
      'An orientation is fully described by which face is at the front and which is on top — those two facts fix everything else.';

  @override
  String get labsSpatialCubeHiddenFaceMission =>
      'Look at the three visible faces, then work out what\'s on the hidden one.';

  @override
  String labsSpatialCubeHiddenFaceQuestion(String direction) {
    return 'Which label is on the face $direction?';
  }

  @override
  String get labsSpatialCubeHiddenFaceHintButton => 'Hint';

  @override
  String get labsSpatialCubeHiddenFaceHintText =>
      'Work out which faces you CAN see first — the hidden face is one of the three left over.';

  @override
  String get labsSpatialCubeHiddenFaceCorrect =>
      'Well done. You predicted the hidden face correctly.';

  @override
  String get labsSpatialCubeHiddenFaceIncorrect =>
      'Good attempt. Rotate the cube to check, then try the next one.';

  @override
  String get labsSpatialCubeHiddenFaceWhereUsed =>
      'Reading isometric diagrams and technical drawings means reasoning about faces you can\'t directly see.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatToDo =>
      'Look at the three faces you can see, then choose the label you think is on the hidden face named.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatToNotice =>
      'Notice only three faces are ever visible at once from this angle — the other three are always hidden.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatItMeans =>
      'A cube only ever shows three faces from one viewpoint, so working out a hidden face means reasoning about the whole cube, not just what\'s in view.';

  @override
  String get labsSpatialCubeNetExplorerMission =>
      'Look at the flat net, predict which faces will end up opposite each other, then fold it to check.';

  @override
  String get labsSpatialCubeNetExplorerPredictPrompt =>
      'Which two squares do you think will end up opposite each other?';

  @override
  String get labsSpatialCubeNetExplorerFoldButton => 'Fold';

  @override
  String get labsSpatialCubeNetExplorerUnfoldButton => 'Unfold';

  @override
  String get labsSpatialCubeNetExplorerNextNetButton => 'Next net';

  @override
  String get labsSpatialCubeNetExplorerStepBackButton => 'Back';

  @override
  String get labsSpatialCubeNetExplorerStepForwardButton => 'Next step';

  @override
  String get labsSpatialCubeNetExplorerWhereUsed =>
      'Packaging design and sheet-metal work both start from a flat net that folds into a finished 3D shape.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatToDo =>
      'Study the flat net, then press Fold to see whether it closes into a cube.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatToNotice =>
      'Notice that not every arrangement of six squares folds into a closed cube — some overlap or leave a gap.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatItMeans =>
      'A net is a 2D shape that folds along its edges into a 3D solid — the same square can end up on very different sides of the cube depending on the net\'s shape.';

  @override
  String get labsAircraftLandingLabTitle => 'Aircraft Landing Lab';

  @override
  String get labsAircraftLandingLabSubtitle =>
      'Fly the descent angle, distance and speed that bring a plane in safely';

  @override
  String get labsAircraftLandingLabIntro =>
      'Adjust the descent angle and speed, then press Test Approach to watch the aircraft fly the path and see where it touches down.';

  @override
  String get labsAircraftLandingLabFreePlayCaption =>
      'Try it: drag the sliders, then press Test Approach.';

  @override
  String get labsAircraftLandingFindTheTimeTitle => 'Find the Time';

  @override
  String get labsAircraftLandingFindTheTimeSubtitle =>
      'Work out how long the flight to the runway takes';

  @override
  String get labsAircraftLandingDescentLineTitle => 'Follow the Descent Line';

  @override
  String get labsAircraftLandingDescentLineSubtitle =>
      'Match your descent angle to a target glide line';

  @override
  String get labsAircraftLandingGlidePathTitle => 'Land on the Glide Path';

  @override
  String get labsAircraftLandingGlidePathSubtitle =>
      'Choose angle and speed to land safely on the runway';

  @override
  String get labsAircraftLandingVectorApproachTitle => 'Vector Approach';

  @override
  String get labsAircraftLandingVectorApproachSubtitle =>
      'Adjust horizontal and vertical speed to match a target approach';

  @override
  String labsAircraftLandingDescentAngleLabel(int degrees) {
    return 'Descent angle: $degrees°';
  }

  @override
  String labsAircraftLandingAirspeedLabel(int metresPerSecond) {
    return 'Airspeed: $metresPerSecond m/s';
  }

  @override
  String get labsAircraftLandingTestApproachButton => 'Test Approach';

  @override
  String labsAircraftLandingFindTheTimeDiagramLabel(
      int distanceM, int speedMps) {
    return 'An aircraft $distanceM metres from the runway, flying at $speedMps metres per second.';
  }

  @override
  String labsAircraftLandingFindTheTimeSpeedLabel(int speedMps) {
    return 'Speed: $speedMps m/s';
  }

  @override
  String get labsAircraftLandingFindTheTimeQuestion =>
      'How long will it take to reach the runway?';

  @override
  String get labsAircraftLandingFindTheTimeHintButton => 'Hint';

  @override
  String get labsAircraftLandingFindTheTimeHintText =>
      'Time = distance ÷ speed.';

  @override
  String get labsAircraftLandingFindTheTimeMission =>
      'Use the distance and speed shown to work out how long the flight to the runway will take.';

  @override
  String get labsAircraftLandingFindTheTimeWhereUsed =>
      'Pilots and air traffic controllers constantly estimate time-to-runway from speed and distance to sequence safe landings.';

  @override
  String get labsAircraftLandingFindTheTimeCorrect =>
      'Correct — you found the time to the runway.';

  @override
  String get labsAircraftLandingFindTheTimeIncorrect =>
      'Not quite. Try dividing the distance by the speed.';

  @override
  String labsAircraftLandingFindTheTimeReveal(int seconds) {
    return 'The correct time is $seconds seconds.';
  }

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatToDo =>
      'Read the distance and speed shown, then choose the matching time from the options.';

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatToNotice =>
      'Notice that a faster speed always means a shorter time for the same distance.';

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatItMeans =>
      'Time, distance and speed are always connected by time = distance ÷ speed — the same relationship used for any journey, not just flights.';

  @override
  String get labsAircraftLandingDescentLineTestButton => 'Test my line';

  @override
  String get labsAircraftLandingDescentLineMission =>
      'Adjust your descent angle until your line matches the dashed target line.';

  @override
  String get labsAircraftLandingDescentLineWhereUsed =>
      'Matching a required gradient comes up whenever a path, ramp or pipe has to follow a fixed slope.';

  @override
  String get labsAircraftLandingDescentLineCorrect =>
      'Well done — your line matches the target glide path.';

  @override
  String get labsAircraftLandingDescentLineIncorrect =>
      'Not yet. Compare how steep your line is against the dashed target.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatToDo =>
      'Move the descent-angle slider until your solid line sits on top of the dashed target line, then test it.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatToNotice =>
      'Notice that a steeper angle makes the line fall faster — a bigger negative gradient.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatItMeans =>
      'The descent angle is the line\'s gradient: altitude change divided by distance travelled, written as y = mx + c with a negative m.';

  @override
  String get labsAircraftLandingGlidePathSafe =>
      'Smooth landing — right on the runway.';

  @override
  String get labsAircraftLandingGlidePathTooSteep =>
      'Too steep — the aircraft touched down before the runway.';

  @override
  String get labsAircraftLandingGlidePathTooShallow =>
      'Too shallow — the aircraft was still airborne past the runway.';

  @override
  String get labsAircraftLandingGlidePathMission =>
      'Choose an angle and speed, then test your approach to land safely on the runway.';

  @override
  String get labsAircraftLandingGlidePathWhereUsed =>
      'Every real landing balances a safe descent angle against speed and distance to touch down in exactly the right place.';

  @override
  String labsAircraftLandingGlidePathTouchdownError(int metres) {
    return '$metres metres from the runway threshold.';
  }

  @override
  String get labsAircraftLandingGlidePathHelpWhatToDo =>
      'Adjust the angle and speed, then press Test Approach to see where the aircraft actually touches down.';

  @override
  String get labsAircraftLandingGlidePathHelpWhatToNotice =>
      'Notice how the touchdown point moves as you change the angle, even when the speed stays the same.';

  @override
  String get labsAircraftLandingGlidePathHelpWhatItMeans =>
      'tan(angle) = altitude ÷ distance — this exact ratio is what makes a descent land precisely on the runway instead of short or long.';

  @override
  String labsAircraftLandingVectorHorizontalLabel(int metresPerSecond) {
    return 'Horizontal speed: $metresPerSecond m/s';
  }

  @override
  String labsAircraftLandingVectorVerticalLabel(int metresPerSecond) {
    return 'Vertical speed: $metresPerSecond m/s';
  }

  @override
  String labsAircraftLandingVectorResultantLabel(int metresPerSecond) {
    return 'Combined (resultant) speed: $metresPerSecond m/s';
  }

  @override
  String get labsAircraftLandingVectorApproachMission =>
      'Adjust the horizontal and vertical speed components to match the target approach.';

  @override
  String get labsAircraftLandingVectorApproachWhereUsed =>
      'Combining a horizontal and vertical speed into one resultant vector is exactly how a real flight path, or any 2D motion, is described mathematically.';

  @override
  String get labsAircraftLandingVectorApproachCorrect =>
      'Correct — your components match the target approach.';

  @override
  String get labsAircraftLandingVectorApproachIncorrect =>
      'Not yet. Compare your horizontal and vertical speeds to the target.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatToDo =>
      'Adjust the horizontal and vertical speed sliders, then test your approach.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatToNotice =>
      'Notice how the resultant speed and the descent path both change as you adjust either component.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatItMeans =>
      'Any velocity can be split into a horizontal and a vertical component, and recombined using Pythagoras\' theorem to find the resultant speed.';

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

  @override
  String get allieLabel => 'Allie';

  @override
  String get familyMathsEntryTitle => 'Family Maths';

  @override
  String get familyMathsWelcomeTitle => 'Welcome';

  @override
  String get familyMathsWelcomeBody =>
      'Helping your child with maths doesn\'t require perfect knowledge. Small conversations. Simple games. Curiosity. Consistency. We\'ll help with the rest.';

  @override
  String get familyMathsAllieIntro =>
      'You don\'t need to remember every school method. Choose one topic. I\'ll suggest a five-minute activity that helps your child think mathematically.';

  @override
  String get familyMathsPhilosophyTagline =>
      'Parents don\'t need to become teachers.';

  @override
  String get familyMathsStartActivityButton => 'Start a Family Activity';

  @override
  String get familyMathsBrowseTopicsButton => 'Browse Topics';

  @override
  String get familyMathsLibraryTitle => 'Family Activities';

  @override
  String get familyMathsEmptyCategory =>
      'No activities yet for this topic. More are on the way.';

  @override
  String familyActivityAgeRange(int min, int max) {
    return 'Ages $min-$max';
  }

  @override
  String familyActivityTimeRange(int min, int max) {
    return '$min-$max min';
  }

  @override
  String get familyActivityMaterialsLabel => 'Materials Needed';

  @override
  String get familyActivityWhatYourChildLearnsLabel => 'What Your Child Learns';

  @override
  String get familyActivityLetsExploreLabel => 'Let\'s Explore';

  @override
  String get familyActivityQuestionsToAskLabel => 'Questions to Ask';

  @override
  String get familyActivityMisconceptionsLabel => 'Common Misconceptions';

  @override
  String get familyActivityTryTomorrowLabel => 'Try Tomorrow';

  @override
  String get familyActivityStudioConnectionLabel => 'Studio Connection';

  @override
  String get familyMathsCategoryNumberSense => 'Number Sense';

  @override
  String get familyMathsCategoryAddition => 'Addition';

  @override
  String get familyMathsCategorySubtraction => 'Subtraction';

  @override
  String get familyMathsCategoryMultiplication => 'Multiplication';

  @override
  String get familyMathsCategoryDivision => 'Division';

  @override
  String get familyMathsCategoryFractions => 'Fractions';

  @override
  String get familyMathsCategoryDecimals => 'Decimals';

  @override
  String get familyMathsCategoryRatio => 'Ratio';

  @override
  String get familyMathsCategoryPercentages => 'Percentages';

  @override
  String get familyMathsCategoryGeometry => 'Geometry';

  @override
  String get familyMathsCategoryMeasurement => 'Measurement';

  @override
  String get familyMathsCategoryAlgebra => 'Algebra';

  @override
  String get familyMathsCategoryPatterns => 'Patterns';

  @override
  String get familyMathsCategoryLogic => 'Logic';

  @override
  String get familyMathsCategorySpatialReasoning => 'Spatial Reasoning';

  @override
  String get familyMathsReassurance1 =>
      'You do not need to know the answer immediately.';

  @override
  String get familyMathsReassurance2 =>
      'Ask your child to explain what they notice.';

  @override
  String get familyMathsReassurance3 =>
      'A wrong answer can start a useful conversation.';

  @override
  String get familyMathsReassurance4 => 'Five focused minutes is enough.';

  @override
  String get familyMathsReassurance5 => 'Let your child choose the objects.';

  @override
  String get familyMathsReassurance6 =>
      'Try a different representation if the first one does not help.';

  @override
  String get onboardingFamilyRoleDetailTitle => 'Tell us about your family';

  @override
  String get onboardingFamilyRoleDetailSub =>
      'A couple of quick questions so we can help the right way.';

  @override
  String get onboardingFamilyLearnerNamesLabel => 'Learner name(s)';

  @override
  String get onboardingFamilyLearnerNamesSub =>
      'Add at least one — you can add more later.';

  @override
  String get onboardingFamilyAddAnotherLearner => 'Add another learner';

  @override
  String get onboardingFamilyLearnerContextTitle =>
      'What stage is your child at?';

  @override
  String get onboardingFamilyLearnerContextSub =>
      'This helps us suggest the right activities and topics.';

  @override
  String get onboardingFamilyGoalTitle => 'What brings you here?';

  @override
  String get onboardingFamilyGoalSub =>
      'Choose what matters most right now — you can change this later.';

  @override
  String get onboardingFamilyGoalHomework => 'Help with homework';

  @override
  String get onboardingFamilyGoalUnderstandMethods =>
      'Understand modern methods';

  @override
  String get onboardingFamilyGoalBuildConfidence => 'Build confidence';

  @override
  String get onboardingFamilyGoalPractiseTogether => 'Practise together';

  @override
  String get onboardingFamilyGoalPrepareExam => 'Prepare for an exam';

  @override
  String get onboardingFamilyGoalMonitorProgress => 'Monitor progress';

  @override
  String get onboardingFamilyGoalSupportStruggling =>
      'Support a learner who finds maths difficult';

  @override
  String get onboardingFamilyActivityLengthLabel => 'Preferred activity length';

  @override
  String get onboardingFamilyActivityLengthShort => '~10 minutes';

  @override
  String get onboardingFamilyActivityLengthMedium => '~20 minutes';

  @override
  String get onboardingFamilyActivityLengthLong => '~30 minutes';

  @override
  String get onboardingFamilyPreferencesTitle => 'Almost done';

  @override
  String get onboardingFamilyPreferencesSub =>
      'A couple of optional extras, then you\'re in.';

  @override
  String get onboardingFamilyAllieIntro =>
      'You do not need to explain everything immediately.';

  @override
  String get onboardingFamilyNotificationsLabel => 'Gentle reminders';

  @override
  String get onboardingFamilyNotificationsSub =>
      'Optional — occasional nudges about your family activity.';

  @override
  String get onboardingFamilyPinLabel => 'Set a Parent PIN (optional)';

  @override
  String get onboardingFamilyPinSub =>
      'Protects Family Maths and parent content on a shared device. You can set this later in Settings instead.';

  @override
  String get onboardingFamilyFinishButton => 'Go to Family Studio';

  @override
  String get recallTopicNumber => 'Number';

  @override
  String get recallTopicRatioAndProportion => 'Ratio and Proportion';

  @override
  String get recallTopicAlgebra => 'Algebra';

  @override
  String get recallTopicGeometryAndMeasures => 'Geometry and Measures';

  @override
  String get recallTopicStatistics => 'Statistics';

  @override
  String get recallTopicProbability => 'Probability';

  @override
  String get familyStudioHubTitle => 'Family Studio';

  @override
  String get familyStudioHubOpeningPromise =>
      'Parents do not need to become teachers.';

  @override
  String get familyStudioHubSupportingCopy =>
      'Choose a topic, a short activity or a homework goal. Math Intelligence will help you begin.';

  @override
  String get familyStudioHubAllieMessage =>
      'Ask what your child notices first.';

  @override
  String get familyStudioProfileEntrySubtitle =>
      'Activities, homework help and progress for your family.';

  @override
  String get familyStudioPrimaryActionStartActivity =>
      'Start a Family Activity';

  @override
  String get familyStudioPrimaryActionHomework => 'Help with Homework';

  @override
  String get familyStudioPrimaryActionLearning =>
      'See What My Child Is Learning';

  @override
  String get familyStudioPrimaryActionGuides => 'Browse Parent Guides';

  @override
  String get familyStudioSectionTodaysActivityTitle =>
      'Today\'s Family Activity';

  @override
  String get familyStudioSectionTodaysActivitySubtitle =>
      'One deterministic pick for today, from Family Maths.';

  @override
  String get familyStudioSectionHomeworkCompanionTitle => 'Homework Companion';

  @override
  String get familyStudioSectionHomeworkCompanionSubtitle =>
      'A short, deterministic session for tonight\'s homework.';

  @override
  String get familyStudioSectionLearningTitle => 'What Your Child Is Learning';

  @override
  String get familyStudioSectionLearningSubtitle => 'Recent Practice topics.';

  @override
  String get familyStudioSectionExplainTitle => 'Explain This Method';

  @override
  String get familyStudioSectionExplainSubtitle => 'Open the Formula Library.';

  @override
  String get familyStudioSectionConversationStartersTitle =>
      'Conversation Starters';

  @override
  String get familyStudioSectionConversationStartersSubtitle =>
      'Questions to ask while you work together.';

  @override
  String get familyStudioSectionParentRecallCardsTitle =>
      'Schede mnemoniche per genitori';

  @override
  String get familyStudioSectionParentRecallCardsSubtitle =>
      'Consigli calorosi e pratici — non domande d\'esame.';

  @override
  String get familyStudioSectionFractionsRatioTitle => 'Fractions and Ratio';

  @override
  String get familyStudioSectionFractionsRatioSubtitle =>
      'Family Maths activities for this topic.';

  @override
  String get familyStudioSectionMentalMathsTitle => 'Mental Maths Together';

  @override
  String get familyStudioSectionMentalMathsSubtitle =>
      'Quick number challenges for two.';

  @override
  String get familyStudioSectionCubeSpatialTitle =>
      'Cube and Spatial Activities';

  @override
  String get familyStudioSectionCubeSpatialSubtitle =>
      'Build and view together.';

  @override
  String get familyStudioSectionProgressTitle => 'Progress Snapshot';

  @override
  String get familyStudioSectionProgressSubtitle =>
      'Topics studied, strengths and areas to revisit.';

  @override
  String get familyStudioSectionTutorToolsTitle => 'Tutor Tools';

  @override
  String get familyStudioSectionTutorToolsSubtitle =>
      'Choose a learner, assign practice, add a note.';

  @override
  String get familyStudioPinReminderTitle => 'Proteggi Family Studio';

  @override
  String get familyStudioPinReminderBody =>
      'Crea un PIN genitore per proteggere compiti, report e impostazioni dell\'apprendista.';

  @override
  String get familyStudioPinReminderSetPinButton => 'Imposta PIN';

  @override
  String get familyStudioPinReminderLaterButton => 'Ricordamelo più tardi';

  @override
  String get familyStudioTodayStartButton => 'Start this activity';

  @override
  String get familyStudioLearningNoDataYet =>
      'No Practice sessions yet — recent topics will appear here.';

  @override
  String get familyStudioLearningTopicSubtitle =>
      'Recently studied in Practice.';

  @override
  String get familyStudioConversationAllieMessage =>
      'A mistake can start a useful conversation.';

  @override
  String get familyStudioHomeworkTopicLabel => 'Topic';

  @override
  String get familyStudioHomeworkTimeLabel => 'Time available';

  @override
  String familyStudioHomeworkMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get familyStudioHomeworkHelpTypeLabel => 'Type of help needed';

  @override
  String get familyStudioHomeworkHelpUnderstandMethod =>
      'Understand the method';

  @override
  String get familyStudioHomeworkHelpPractiseTogether => 'Practise together';

  @override
  String get familyStudioHomeworkHelpReviewMistakes => 'Review mistakes';

  @override
  String get familyStudioHomeworkHelpPrepareTomorrow => 'Prepare for tomorrow';

  @override
  String get familyStudioHomeworkHelpBuildConfidence => 'Build confidence';

  @override
  String get familyStudioHomeworkGenerateButton => 'Generate session';

  @override
  String get familyStudioHomeworkEmptySession =>
      'Nothing to suggest yet for this combination — try a different topic or time.';

  @override
  String get familyStudioProgressRecentTopics => 'Topics recently studied';

  @override
  String get familyStudioProgressActivitiesCompleted => 'Activities completed';

  @override
  String get familyStudioProgressAreasToRevisit => 'Areas to revisit';

  @override
  String get familyStudioProgressSuggestedActivity =>
      'Suggested family activity';

  @override
  String get familyStudioProgressNoDataYet =>
      'Not enough data yet — this will fill in as your family uses the app.';

  @override
  String get familyStudioTutorChooseLearnerLabel => 'Choose a learner';

  @override
  String get familyStudioTutorAssignLabel => 'Assign';

  @override
  String get familyStudioTutorAssignPractice => 'Assign Practice';

  @override
  String get familyStudioTutorAssignRecallCards => 'Assign Recall Cards';

  @override
  String familyStudioTutorCompletionLabel(int count) {
    return '$count interactive lab completions so far';
  }

  @override
  String get familyStudioTutorNotesLabel => 'Notes';

  @override
  String get familyStudioTutorNotesHint => 'A short note for next time';

  @override
  String get appearanceThemeTitle => 'Appearance';

  @override
  String get appearanceThemeSub =>
      'Choose how Math Intelligence looks — match your device, or pick Dark or Light.';

  @override
  String get appearanceThemeSystem => 'System';

  @override
  String get appearanceThemeDark => 'Dark';

  @override
  String get appearanceThemeLight => 'Light';

  @override
  String get appearanceAccessibilityHeading => 'ACCESSIBILITY';

  @override
  String get appearanceReadingSizeTitle => 'Reading Size';

  @override
  String get appearanceReadingSizeSub =>
      'Small, Default, or Large text scaling';

  @override
  String get appearanceTouchTargetsTitle => 'Touch Targets 44px';

  @override
  String get appearanceTouchTargetsSub => 'Ergonomic controls';

  @override
  String get appearanceTypographyTitle => 'Clear Typography';

  @override
  String get appearanceTypographySub => 'Readable font at all sizes';

  @override
  String get appearanceResetOnboardingHeading => 'RESET ONBOARDING';

  @override
  String get appearanceResetOnboardingSub =>
      'Reset the app introduction to go through the initial setup again.';

  @override
  String get numberSenseLabTitle => 'Number Sense Lab';

  @override
  String get numberSenseModeGuided => 'Guided';

  @override
  String get numberSenseModeFreeExplore => 'Free explore';

  @override
  String get numberSenseExampleEquivalenceTitle =>
      'Make an equivalent fraction';

  @override
  String get numberSenseExampleEquivalenceTask =>
      'Show one half using equal parts.';

  @override
  String get numberSenseExamplePlacementTitle => 'Place a fraction';

  @override
  String get numberSenseExamplePlacementTask =>
      'Place three eighths on the number line.';

  @override
  String get numberSenseExampleComparisonTitle => 'Compare fractions';

  @override
  String get numberSenseExampleComparisonTask =>
      'Choose how these fractions compare.';

  @override
  String numberSenseTarget(String fraction) {
    return 'Target: $fraction';
  }

  @override
  String get numberSenseCompareLessThan => 'Less than';

  @override
  String get numberSenseCompareEqualTo => 'Equal to';

  @override
  String get numberSenseCompareGreaterThan => 'Greater than';

  @override
  String get numberSenseComplete => 'You found it.';

  @override
  String get numberSenseReset => 'Reset';

  @override
  String get numberSenseTryAnotherExample => 'Try another example';

  @override
  String get numberSenseLabDescription =>
      'Build, place and compare unit fractions.';

  @override
  String get appearanceResetOnboardingButton => 'Reset Onboarding';

  @override
  String get numberSenseFreeExploreInstruction =>
      'Choose a model, then tap equal parts or tap/drag a point to explore fractions.';

  @override
  String get numberSenseClearExplore => 'Clear';

  @override
  String get numberSenseScopeStatement =>
      'This starter whole-part model supports 2, 3, 4, 6 or 8 equal parts only. Hundredths are supported on the precision line; other unsupported denominators need a precision or zoomed line.';

  @override
  String get numberSenseWholePartModel => 'Whole-part bar';

  @override
  String get numberSensePrecisionLine => 'Precision line';

  @override
  String get numberSenseExampleHundredthsTitle => 'Find one hundredth';

  @override
  String get numberSenseExampleHundredthsTask =>
      'Use the zoomed number line to find one hundredth. Each step is one hundredth.';

  @override
  String get numberSenseHundredthsExploreInstruction =>
      'Choose a hundredth from 0.00 to 0.10. Tap a labelled point or drag along the line.';

  @override
  String get numberSenseHundredthsTargetEquation => '1/100 = 0.01';

  @override
  String get numberSenseHundredthsLineLabel =>
      'Zoomed number line from 0.00 to 0.10, marked in hundredths';

  @override
  String numberSenseHundredthsSelectionExplanation(
      String fraction, String decimal, int count) {
    return '$fraction means $decimal: $count of 100 equal parts.';
  }

  @override
  String numberSenseHundredthsIncorrectFeedback(String decimal) {
    return 'You selected $decimal. One hundredth is the next tick after 0.00: choose 0.01.';
  }

  @override
  String get numberSenseHundredthsZeroExplanation =>
      'Zero is at the start of the line.';

  @override
  String get numberSenseHundredthsZeroGuidedFeedback =>
      '0.00 is zero. One hundredth is the first tick to the right: 0.01.';

  @override
  String numberSenseGuidedWrongAdjacent(
      String selected, String direction, String target) {
    return 'Not quite. You chose $selected. Move one tick $direction to reach $target.';
  }

  @override
  String numberSenseGuidedWrongGeneral(String selected, String target) {
    return 'Not quite. You chose $selected. The target is $target. Change the shaded equal parts to show the target amount.';
  }

  @override
  String numberSenseGuidedWrongPartition(String selected, String target) {
    return 'Not quite. You chose $selected. The target is $target. Choose equal parts that can show the target fraction.';
  }

  @override
  String numberSenseGuidedWrongEquivalenceWhole(
      String selected, String target) {
    return '$selected is one whole, not $target. Shade half of the equal parts.';
  }

  @override
  String get numberSenseGuidedDirectionLeft => 'left';

  @override
  String get numberSenseGuidedDirectionRight => 'right';

  @override
  String get numberSenseEqualPartsLabel => 'Equal parts';

  @override
  String numberSenseCompareLeftLabel(String fraction) {
    return 'Left: $fraction';
  }

  @override
  String numberSenseCompareRightLabel(String fraction) {
    return 'Right: $fraction';
  }

  @override
  String get numberSenseCompareSharedLineLabel =>
      'Shared number line from zero to one. The circle marks the left fraction and the diamond marks the right fraction.';

  @override
  String get numberSenseCompareLeftMarkerSemantics =>
      'Number line marker for two thirds, 2/3';

  @override
  String get numberSenseCompareRightMarkerSemantics =>
      'Number line marker for three fourths, 3/4';

  @override
  String get numberSenseCompareLeftMarkerExplanation =>
      '2/3 = 0.666… — two of three equal parts';

  @override
  String get numberSenseCompareRightMarkerExplanation =>
      '3/4 = 0.75 — three of four equal parts';

  @override
  String get numberSenseComparisonProof =>
      '2 × 4 = 8; 3 × 3 = 9; since 8 < 9, 2/3 < 3/4.';

  @override
  String get numberSenseComparisonIncorrectResult =>
      'Not quite. 2/3 is less than 3/4.';

  @override
  String get numberSenseComparisonCorrectResult => 'Correct: 2/3 < 3/4.';

  @override
  String numberSenseComparisonCorrectResultDynamic(
      String leftFraction, String relation, String rightFraction) {
    return 'Correct: $leftFraction $relation $rightFraction.';
  }

  @override
  String numberSenseComparisonIncorrectResultDynamic(
      String leftFraction, String relationWords, String rightFraction) {
    return 'Not quite. $leftFraction is $relationWords $rightFraction.';
  }

  @override
  String numberSenseComparisonProofDynamic(
      int leftNumerator,
      int rightDenominator,
      int leftProduct,
      int rightNumerator,
      int leftDenominator,
      int rightProduct,
      String relation,
      String leftFraction,
      String rightFraction) {
    return '$leftNumerator × $rightDenominator = $leftProduct; $rightNumerator × $leftDenominator = $rightProduct; since $leftProduct $relation $rightProduct, $leftFraction $relation $rightFraction.';
  }

  @override
  String get numberSenseCompareLessThanWords => 'less than';

  @override
  String get numberSenseCompareEqualWords => 'equal to';

  @override
  String get numberSenseCompareGreaterThanWords => 'greater than';

  @override
  String numberSenseCompareMarkerExplanation(
      String fraction, String decimal, int numerator, int denominator) {
    return '$fraction = $decimal — $numerator of $denominator equal parts';
  }

  @override
  String numberSenseComparisonCorrectFeedback(String proof) {
    return 'Correct. $proof';
  }

  @override
  String numberSenseComparisonIncorrectFeedback(String proof) {
    return 'Not quite. The correct relation is 2/3 < 3/4. $proof';
  }

  @override
  String get numberSenseComparisonCorrectLabel => 'Correct';

  @override
  String get numberSenseComparisonReviewLabel => 'Review the comparison';

  @override
  String get numberSenseHelpNumeratorLabel => 'Numerator';

  @override
  String get numberSenseHelpDenominatorLabel => 'Denominator';

  @override
  String get numberSenseHelpEquivalentLabel => 'Equivalent';

  @override
  String get numberSenseHelpNumeratorDescription =>
      'The numerator is the top number. It counts how many equal parts are selected.';

  @override
  String get numberSenseHelpDenominatorDescription =>
      'The denominator is the bottom number. It tells how many equal parts make one whole.';

  @override
  String get numberSenseHelpEquivalentDescription =>
      'Equivalent fractions name the same amount, even when they use different-sized equal parts.';

  @override
  String get numberSenseHelpLessThanLabel => 'Explain the less-than symbol';

  @override
  String get numberSenseHelpEqualLabel => 'Explain the equal-to symbol';

  @override
  String get numberSenseHelpGreaterThanLabel =>
      'Explain the greater-than symbol';

  @override
  String get numberSenseHelpLessThanDescription =>
      'The less-than symbol means the value on its left is smaller than the value on its right.';

  @override
  String get numberSenseHelpEqualDescription =>
      'The equal-to symbol means both values are the same amount.';

  @override
  String get numberSenseHelpGreaterThanDescription =>
      'The greater-than symbol means the value on its left is larger than the value on its right.';

  @override
  String get numberSenseHelpWhatToDo =>
      'Read the fraction or symbol, then connect it to the amount shown.';

  @override
  String get numberSenseHelpWhatItMeans =>
      'Use this idea to read, describe and compare fractions.';

  @override
  String get numberSenseHelpWhereUsed =>
      'These words and symbols help explain fractions in maths and everyday sharing.';

  @override
  String numberSenseSkillProgress(int current, int total, String name) {
    return 'Skill $current of $total: $name';
  }

  @override
  String get numberSenseSkillPlaceFraction => 'Place a fraction';

  @override
  String get numberSenseSkillMakeEquivalent => 'Make an equivalent fraction';

  @override
  String get numberSenseSkillCompareFractions => 'Compare fractions';

  @override
  String get numberSenseSkillFindOneHundredth => 'Find one hundredth';

  @override
  String get numberSensePractiseThis => 'Practise this';

  @override
  String get numberSenseNextSkill => 'Next skill';

  @override
  String get numberSenseChooseSkill => 'Choose a skill';

  @override
  String get numberSenseChooseComparisonType => 'Choose a comparison type';

  @override
  String get numberSenseSkillSheetClose => 'Close';

  @override
  String get numberSenseFocusSameDenominator => 'Same denominator';

  @override
  String get numberSenseFocusSameNumerator => 'Same numerator';

  @override
  String get numberSenseFocusEquivalent => 'Equivalent fractions';

  @override
  String get numberSenseFocusCompareToHalf => 'Compare to one half';

  @override
  String get numberSenseFocusMixed => 'Mixed practice';

  @override
  String numberSenseComparisonExplanationEquivalent(
      String leftFraction, String rightFraction) {
    return '$leftFraction is the same value as $rightFraction. Both are at the same point on the number line.';
  }

  @override
  String numberSenseComparisonExplanationSameDenominator(
      String unit,
      int largerCount,
      int smallerCount,
      String leftFraction,
      String relation,
      String rightFraction) {
    return 'Both fractions are in $unit. $largerCount $unit is more than $smallerCount $unit, so $leftFraction $relation $rightFraction.';
  }

  @override
  String numberSenseComparisonExplanationSameNumerator(
      int numerator,
      String largerUnit,
      String smallerUnit,
      String largerFraction,
      String relation,
      String smallerFraction) {
    return 'Both fractions show $numerator parts. $largerUnit are larger pieces than $smallerUnit, so $largerFraction $relation $smallerFraction.';
  }

  @override
  String numberSenseComparisonExplanationBenchmarkHalf(
      String halfEquivalent,
      String otherFraction,
      String unit,
      String direction,
      String leftFraction,
      String relation,
      String rightFraction) {
    return 'One half is $halfEquivalent. Since $otherFraction is one $unit $direction than $halfEquivalent, $leftFraction $relation $rightFraction.';
  }

  @override
  String get numberSenseComparisonHalf => 'half';

  @override
  String get numberSenseComparisonThird => 'third';

  @override
  String get numberSenseComparisonFourth => 'fourth';

  @override
  String get numberSenseComparisonSixth => 'sixth';

  @override
  String get numberSenseComparisonEighth => 'eighth';

  @override
  String get numberSenseComparisonHalves => 'halves';

  @override
  String get numberSenseComparisonThirds => 'thirds';

  @override
  String get numberSenseComparisonFourths => 'fourths';

  @override
  String get numberSenseComparisonSixths => 'sixths';

  @override
  String get numberSenseComparisonEighths => 'eighths';

  @override
  String get numberSenseComparisonCapHalves => 'Halves';

  @override
  String get numberSenseComparisonCapThirds => 'Thirds';

  @override
  String get numberSenseComparisonCapFourths => 'Fourths';

  @override
  String get numberSenseComparisonCapSixths => 'Sixths';

  @override
  String get numberSenseComparisonCapEighths => 'Eighths';

  @override
  String get numberSenseComparisonMore => 'more';

  @override
  String get numberSenseComparisonLess => 'less';

  @override
  String get numberSenseAnotherExample => 'Another example';

  @override
  String get numberSenseExamplePlacementTaskHalf =>
      'Place one half on the number line.';

  @override
  String get numberSenseExamplePlacementTaskTwoThirds =>
      'Place two thirds on the number line.';

  @override
  String numberSenseExampleEquivalenceTaskParts(int count) {
    return 'Show one half using $count equal parts.';
  }

  @override
  String numberSenseExampleHundredthsTitleCount(int count) {
    return 'Find $count hundredths';
  }

  @override
  String numberSenseExampleHundredthsTaskCount(int count) {
    return 'Use the zoomed number line to find $count hundredths. Each step is one hundredth.';
  }

  @override
  String numberSenseHundredthsTargetEquationDynamic(
      String fraction, String decimal) {
    return '$fraction = $decimal';
  }

  @override
  String numberSenseHundredthsIncorrectFeedbackTarget(
      String decimal, int count, String target) {
    return 'You selected $decimal. Count $count ticks to the right of 0.00 to reach $target.';
  }

  @override
  String numberSenseHundredthsZeroGuidedFeedbackTarget(
      int count, String target) {
    return '0.00 is zero. Count $count ticks to the right to reach $target.';
  }

  @override
  String get pandaPortionsTitle => 'Panda Portions';

  @override
  String get pandaPortionsSubtitle =>
      'Share an apple fairly and discover fractions.';

  @override
  String get pandaPortionsMenuIntro =>
      'Choose where to start. You can change lessons at any time.';

  @override
  String get pandaPortionsGuidedPathTitle => 'Guided Path';

  @override
  String get pandaPortionsGuidedPathDescription =>
      'Equal parts, then halves, then quarters — one step at a time.';

  @override
  String get pandaPortionsPractiseHalvesTitle => 'Practise Halves';

  @override
  String get pandaPortionsPractiseHalvesDescription =>
      'Share one apple into 2 equal parts.';

  @override
  String get pandaPortionsPractiseQuartersTitle => 'Practise Quarters';

  @override
  String get pandaPortionsPractiseQuartersDescription =>
      'Share one apple into 4 equal parts.';

  @override
  String pandaPortionsGuidedStep(int step, int total) {
    return 'Guided Path · step $step of $total';
  }

  @override
  String get pandaPortionsLessonEqualPartsTitle => 'Equal parts';

  @override
  String get pandaPortionsLessonEqualPartsPurpose =>
      'Find the apple that is shared fairly.';

  @override
  String get pandaPortionsLessonHalvesTitle => 'Halves';

  @override
  String get pandaPortionsLessonHalvesPurpose =>
      'Feed Panda one half of an apple.';

  @override
  String get pandaPortionsLessonQuartersTitle => 'Quarters';

  @override
  String get pandaPortionsLessonQuartersPurpose =>
      'Feed Panda one quarter of an apple.';

  @override
  String get pandaPortionsPromptEqualParts =>
      'Which plate shows one apple shared into equal parts?';

  @override
  String get pandaPortionsPromptHalves => 'Feed Panda one half.';

  @override
  String get pandaPortionsPromptQuarters => 'Feed Panda one quarter.';

  @override
  String get pandaPortionsTeachEqualParts =>
      'Fractions are equal parts of one whole.';

  @override
  String get pandaPortionsSuccessEqualParts =>
      'Yes — every part on this plate is the same size.';

  @override
  String pandaPortionsSuccessFedPart(int parts, String fraction) {
    return 'You fed Panda 1 of $parts equal parts: $fraction.';
  }

  @override
  String pandaPortionsSuccessAte(int parts, String fraction) {
    return 'Panda ate 1 of $parts equal parts. That is $fraction.';
  }

  @override
  String pandaPortionsRemainingLeft(String fraction) {
    return '$fraction of the apple is left.';
  }

  @override
  String get pandaPortionsMisconceptionUnequal =>
      'These parts are not equal, so they are not halves or quarters.';

  @override
  String get pandaPortionsIncorrectSelection =>
      'Try again. Look for one equal part of the whole apple.';

  @override
  String get pandaPortionsHintEqualParts =>
      'In a fair share, every part is the same size. Compare the parts on each plate.';

  @override
  String get pandaPortionsHintHalves =>
      'Halves are 2 equal parts. Both parts of one whole apple are the same size.';

  @override
  String get pandaPortionsHintQuarters =>
      'Quarters are 4 equal parts. All 4 parts of one whole apple are the same size.';

  @override
  String get pandaPortionsRetryEqualParts => 'Try another example';

  @override
  String get pandaPortionsRetryHalves => 'Try another half';

  @override
  String get pandaPortionsRetryQuarters => 'Try another quarter';

  @override
  String get pandaPortionsSuggestTryHalves => 'You could try halves next.';

  @override
  String get pandaPortionsSuggestTryQuarters => 'You could try quarters next.';

  @override
  String get pandaPortionsSuggestNewChallenge => 'Ready for a new challenge?';

  @override
  String get pandaPortionsWhatNext => 'What next?';

  @override
  String get pandaPortionsNextLesson => 'Next lesson';

  @override
  String get pandaPortionsKeepPractising => 'Keep practising this';

  @override
  String get pandaPortionsChooseLesson => 'Choose a lesson';

  @override
  String get pandaPortionsResetApple => 'Reset apple';

  @override
  String get pandaPortionsShowHint => 'Show me a hint';

  @override
  String get pandaPortionsHideHint => 'Hide hint';

  @override
  String get pandaPortionsWholeApple => '1 whole apple';

  @override
  String pandaPortionsPlateLabel(String plate) {
    return 'Plate $plate';
  }

  @override
  String pandaPortionsPlateEqualSemantic(String plate, int parts) {
    return 'Plate $plate: one apple cut into $parts equal parts.';
  }

  @override
  String pandaPortionsPlateUnequalSemantic(String plate, int parts) {
    return 'Plate $plate: one apple cut into $parts parts that are not the same size.';
  }

  @override
  String pandaPortionsPieceEqualSemantic(
      String plate, int index, int parts, String fraction) {
    return 'Plate $plate, piece $index of $parts. An equal part: $fraction of the apple.';
  }

  @override
  String pandaPortionsPieceUnequalSemantic(String plate, int index, int parts) {
    return 'Plate $plate, piece $index of $parts. Not an equal part.';
  }

  @override
  String pandaPortionsPlatePiecesSemantic(String plate, int parts) {
    return 'Plate $plate: one apple cut into $parts pieces.';
  }

  @override
  String pandaPortionsPlateLargerSmallerSemantic(String plate) {
    return 'Plate $plate: one apple cut into 2 pieces, one larger piece and one smaller piece.';
  }

  @override
  String pandaPortionsPlateMixedSizesSemantic(String plate, int parts) {
    return 'Plate $plate: one apple cut into $parts pieces, some larger and some smaller.';
  }

  @override
  String pandaPortionsPieceSemantic(String plate, int index, int parts) {
    return 'Plate $plate, piece $index of $parts.';
  }

  @override
  String get pandaPortionsPiecePicked =>
      'Piece picked. Now tap Panda to give it.';

  @override
  String get pandaPortionsFeedPanda => 'Give the piece to Panda';

  @override
  String get pandaPortionsBowlEmpty => 'Panda\'s bowl is empty.';

  @override
  String pandaPortionsBowlHas(String fraction) {
    return 'Panda\'s bowl has $fraction of the apple.';
  }

  @override
  String pandaPortionsStripLabel(int fed, int parts) {
    return 'Fraction strip: $fed of $parts equal parts given to Panda.';
  }

  @override
  String get pandaPortionsStripFed => 'fed';

  @override
  String pandaPortionsChoosePlate(String plate) {
    return 'Choose plate $plate';
  }

  @override
  String get labsAppliedMathsStudioTitle => 'Applied Maths Studio';

  @override
  String get labsAppliedMathsStudioSubtitle =>
      'Interactive explorations for mathematical ideas you can see, move and test.';

  @override
  String get labsAppliedMathsStudioIntro =>
      'Choose an exploration to investigate a mathematical idea through an interactive model.';

  @override
  String get labsBinomialVolumeLabTitle => 'Binomial Volume Lab';

  @override
  String get labsBinomialVolumeLabSubtitle =>
      'Pull apart a cube to see the terms in (a + b)³.';

  @override
  String get labsBinomialVolumeLabKind => 'Binomial expansion visualisation';

  @override
  String get labsBinomialIntro =>
      'A cube with side length a + b can be split into smaller volumes. Move the slider to pull the pieces apart.';

  @override
  String labsBinomialModelSemantic(int percent) {
    return 'Cube model with side length a + b, split into eight pieces. Pulled apart $percent percent.';
  }

  @override
  String get labsBinomialModelHint =>
      'Use the left and right arrow keys to move between pieces.';

  @override
  String get labsBinomialExplosionLabel => 'Explosion amount';

  @override
  String labsBinomialExplosionValue(int percent) {
    return '$percent percent';
  }

  @override
  String get labsBinomialAssemble => 'Assemble';

  @override
  String get labsBinomialAssembleSemantic => 'Assemble cube';

  @override
  String get labsBinomialPullApart => 'Pull apart';

  @override
  String get labsBinomialPullApartSemantic => 'Pull cube apart';

  @override
  String get labsBinomialResetView => 'Reset view';

  @override
  String get labsBinomialResetViewSemantic => 'Reset cube view';

  @override
  String get labsBinomialPiecesHeading => 'The pieces';

  @override
  String get labsBinomialSelectACubed => 'Select a cubed block';

  @override
  String get labsBinomialSelectASquaredB => 'Select an a squared b prism';

  @override
  String get labsBinomialSelectABSquared => 'Select an a b squared prism';

  @override
  String get labsBinomialSelectBCubed => 'Select b cubed block';

  @override
  String get labsBinomialOneCube => 'one cube';

  @override
  String get labsBinomialThreePrisms => 'three prisms';

  @override
  String get labsBinomialExplainACubed =>
      'This cube measures a × a × a, so its volume is a³. There is one of these cubes.';

  @override
  String get labsBinomialExplainASquaredB =>
      'This prism measures a × a × b, so its volume is a²b. There are three of these prisms.';

  @override
  String get labsBinomialExplainABSquared =>
      'This prism measures a × b × b, so its volume is ab². There are three of these prisms.';

  @override
  String get labsBinomialExplainBCubed =>
      'This cube measures b × b × b, so its volume is b³. There is one of these cubes.';

  @override
  String labsBinomialExplainNumeric(int a, int b, int volume) {
    return 'With a = $a and b = $b, each one has volume $volume.';
  }

  @override
  String get labsBinomialSelectPrompt =>
      'Tap a piece in the model, or choose one from the list, to see its volume.';

  @override
  String get labsBinomialStepsHeading => 'Guided steps';

  @override
  String get labsBinomialStepsNote => 'Choose any step, in any order.';

  @override
  String labsBinomialStepChip(int number) {
    return 'Step $number';
  }

  @override
  String labsBinomialStepChipSemantic(int number, String title) {
    return 'Step $number: $title';
  }

  @override
  String get labsBinomialStep1 => 'Find the a³ cube';

  @override
  String get labsBinomialStep2 => 'Find the three a²b prisms';

  @override
  String get labsBinomialStep3 => 'Find the three ab² prisms';

  @override
  String get labsBinomialStep4 => 'Find the b³ cube';

  @override
  String get labsBinomialStep5 => 'Reveal the complete expansion';

  @override
  String get labsBinomialStepFound =>
      'Found it. Every matching piece is outlined.';

  @override
  String get labsBinomialStepKeepLooking =>
      'That piece has a different volume. Keep looking for the one this step asks for.';

  @override
  String get labsBinomialNextStep => 'Next step';

  @override
  String get labsBinomialRevealBody =>
      'Each of the eight pieces is one term. Grouping the pieces with the same volume gives:';

  @override
  String get labsBinomialDimensionsHeading => 'Side lengths';

  @override
  String get labsBinomialSideA => 'Length a';

  @override
  String get labsBinomialSideB => 'Length b';

  @override
  String get labsBinomialNumericCheckHeading => 'Numeric check';

  @override
  String labsBinomialNumericCheckSpoken(int side, int aCubed, int aSquaredB,
      int aBSquared, int bCubed, int total) {
    return '$side cubed equals $aCubed plus $aSquaredB plus $aBSquared plus $bCubed, which equals $total.';
  }

  @override
  String get labsBinomialLegendHeading => 'Key';

  @override
  String get labsBinomialLegendBody =>
      'Each edge is cut into a length a and a length b. Every piece is named by a label and a pattern, not only by its colour.';

  @override
  String get labsBinomialCompleteHeading => 'You have seen the whole expansion';

  @override
  String get labsBinomialCompleteBody =>
      'Whatever lengths you choose, the eight pieces always fill the same cube of side a + b.';

  @override
  String get labsBinomialExploreAgain => 'Explore again';

  @override
  String get labsBinomialChooseStep => 'Choose a step';

  @override
  String get labsBinomialBackToStudio => 'Back to Applied Maths Studio';

  @override
  String get labsCreateAngleTitle => 'Create the Angle';

  @override
  String get labsCreateAngleCardSubtitle =>
      'Aim a pass or shot to create the target angle.';

  @override
  String get labsCreateAngleCardKind => 'Applied exploration';

  @override
  String get labsCreateAngleIntro =>
      'Aim the pass. Drag the round handle from the ball until the dashed aim line makes the target angle with the solid baseline, then check your angle.';

  @override
  String get labsCreateAngleLegend =>
      'Solid line: baseline · Dashed line: your aim';

  @override
  String get labsCreateAngleTargetsHeading => 'Choose a target angle';

  @override
  String labsCreateAngleDegrees(String angle) {
    return '$angle°';
  }

  @override
  String labsCreateAngleTargetChipSemantic(String target) {
    return '$target degree target';
  }

  @override
  String labsCreateAngleTargetChipMatchedSemantic(String target) {
    return '$target degree target, created';
  }

  @override
  String labsCreateAngleTargetReadout(String target) {
    return 'Target: $target°';
  }

  @override
  String labsCreateAngleCurrentReadout(String angle) {
    return 'Your angle: $angle°';
  }

  @override
  String labsCreateAngleTargetSemantic(String target) {
    return 'Target angle: $target degrees';
  }

  @override
  String labsCreateAngleCurrentSemantic(String angle) {
    return 'Your angle: $angle degrees';
  }

  @override
  String get labsCreateAnglePitchSemantic =>
      'Football pitch. The solid baseline runs right from the ball. Drag the round aim handle, or use the arrow keys, to turn the dashed aim line.';

  @override
  String labsCreateAnglePitchValue(String angle) {
    return '$angle degrees';
  }

  @override
  String get labsCreateAngleDecrease => 'Decrease angle';

  @override
  String get labsCreateAngleIncrease => 'Increase angle';

  @override
  String get labsCreateAngleReset => 'Reset pitch';

  @override
  String get labsCreateAngleCheck => 'Check angle';

  @override
  String labsCreateAngleToleranceNote(String tolerance) {
    return 'A match is within $tolerance° of the target.';
  }

  @override
  String get labsCreateAngleKeyboardHint =>
      'No dragging needed: use the buttons, or focus the pitch and press the left and right arrow keys to turn one degree at a time.';

  @override
  String labsCreateAngleMatched(String target, String attempted) {
    return 'You created a $target° angle. Your aim was $attempted°, so the aim line has snapped to exactly $target°.';
  }

  @override
  String labsCreateAngleTurnWider(
      String attempted, String difference, String target) {
    return 'Your angle is $attempted°. Turn the aim line $difference° wider to reach $target°.';
  }

  @override
  String labsCreateAngleTurnNarrower(
      String attempted, String difference, String target) {
    return 'Your angle is $attempted°. Turn the aim line $difference° narrower to reach $target°.';
  }

  @override
  String get labsCreateAngleExplain30 =>
      '30° is a narrow angle: one third of a right angle.';

  @override
  String get labsCreateAngleExplain45 =>
      '45° is exactly half a right angle: the diagonal pass.';

  @override
  String get labsCreateAngleExplain60 =>
      '60° is two thirds of a right angle, a wider turn than 45°.';

  @override
  String get labsCreateAngleExplain90 =>
      '90° is a right angle: a quarter turn, square to the baseline.';

  @override
  String labsCreateAngleNextTarget(String target) {
    return 'Try $target° next';
  }

  @override
  String labsCreateAngleProgress(int count, int total) {
    return '$count of $total target angles created this visit';
  }

  @override
  String get labsCreateAngleCompleteTitle => 'All four angles created';

  @override
  String get labsCreateAngleCompleteBody =>
      'You created 30°, 45°, 60° and 90° in this visit. Explore again, pick any target to revisit, or head back to Applied Maths Studio.';

  @override
  String get labsCreateAngleExploreAgain => 'Explore again';

  @override
  String get labsCreateAngleBackToStudio => 'Back to Applied Maths Studio';

  @override
  String get labsCreateAngleSessionNote =>
      'Optional exploration. Nothing is saved: leaving this screen clears this visit.';

  @override
  String get labsPitchCoordinatesTitle => 'Pitch Coordinates';

  @override
  String get labsPitchCoordinatesCardSubtitle =>
      'Find and move players using coordinates on a grid.';

  @override
  String get labsPitchCoordinatesCardKind => 'Applied exploration';

  @override
  String get labsPitchCoordinatesIntro =>
      'Each player stands where two grid lines cross. The first number tells you how many steps right or left from the origin. The second tells you how many steps up or down.';

  @override
  String get labsPitchCoordinatesChooseStart => 'Where should the grid start?';

  @override
  String get labsPitchCoordinatesCornerStart => 'Corner start';

  @override
  String get labsPitchCoordinatesCornerStartHint =>
      'The origin is the corner flag. Numbers go right and up.';

  @override
  String get labsPitchCoordinatesCentreStart => 'Centre start';

  @override
  String get labsPitchCoordinatesCentreStartHint =>
      'The origin is the centre spot. Numbers go right, left, up and down.';

  @override
  String get labsPitchCoordinatesPromptRead =>
      'Where is this player? Enter their coordinates.';

  @override
  String labsPitchCoordinatesPromptPlace(int x, int y) {
    return 'Put the player at ($x, $y).';
  }

  @override
  String labsPitchCoordinatesPromptTranslate(String move) {
    return 'Move the player $move. Where do they finish?';
  }

  @override
  String get labsPitchCoordinatesPromptInverse =>
      'What move takes the player from the start to the finish?';

  @override
  String labsPitchCoordinatesPromptTransfer(String move) {
    return 'Grid only: move the player $move. Where do they finish?';
  }

  @override
  String labsPitchCoordinatesMoveBoth(String h, String v) {
    return '$h and $v';
  }

  @override
  String labsPitchCoordinatesStepsRight(int n) {
    return '$n right';
  }

  @override
  String labsPitchCoordinatesStepsLeft(int n) {
    return '$n left';
  }

  @override
  String labsPitchCoordinatesStepsUp(int n) {
    return '$n up';
  }

  @override
  String labsPitchCoordinatesStepsDown(int n) {
    return '$n down';
  }

  @override
  String get labsPitchCoordinatesNoHorizontal => 'no steps right or left';

  @override
  String get labsPitchCoordinatesNoVertical => 'no steps up or down';

  @override
  String labsPitchCoordinatesSelectedWords(String h, String v) {
    return 'Selected: $h, $v.';
  }

  @override
  String get labsPitchCoordinatesFirstNumber => 'First number';

  @override
  String get labsPitchCoordinatesSecondNumber => 'Second number';

  @override
  String labsPitchCoordinatesYourPair(int x, int y) {
    return 'Your coordinates: ($x, $y)';
  }

  @override
  String get labsPitchCoordinatesExploreGrid => 'Explore the grid';

  @override
  String get labsPitchCoordinatesStepperIncrease => 'Increase';

  @override
  String get labsPitchCoordinatesStepperDecrease => 'Decrease';

  @override
  String get labsPitchCoordinatesConfirmSpot => 'Confirm this spot';

  @override
  String get labsPitchCoordinatesConfirmNumbers => 'Confirm these numbers';

  @override
  String get labsPitchCoordinatesConfirmMove => 'Confirm this move';

  @override
  String get labsPitchCoordinatesMoveRight => 'Move right';

  @override
  String get labsPitchCoordinatesMoveLeft => 'Move left';

  @override
  String get labsPitchCoordinatesMoveUp => 'Move up';

  @override
  String get labsPitchCoordinatesMoveDown => 'Move down';

  @override
  String get labsPitchCoordinatesEdgeRight => 'No more steps right';

  @override
  String get labsPitchCoordinatesEdgeLeft => 'No more steps left';

  @override
  String get labsPitchCoordinatesEdgeUp => 'No more steps up';

  @override
  String get labsPitchCoordinatesEdgeDown => 'No more steps down';

  @override
  String get labsPitchCoordinatesPickHorizontal => 'Right or left';

  @override
  String get labsPitchCoordinatesPickVertical => 'Up or down';

  @override
  String get labsPitchCoordinatesOptRight => 'Right';

  @override
  String get labsPitchCoordinatesOptLeft => 'Left';

  @override
  String get labsPitchCoordinatesOptUp => 'Up';

  @override
  String get labsPitchCoordinatesOptDown => 'Down';

  @override
  String get labsPitchCoordinatesOptNone => 'No move';

  @override
  String get labsPitchCoordinatesSteps => 'Steps';

  @override
  String get labsPitchCoordinatesPlayerUnanswered => 'Player';

  @override
  String labsPitchCoordinatesPlayerAnswered(String h, String v, int x, int y) {
    return 'Player at $h, $v: coordinates $x, $y';
  }

  @override
  String labsPitchCoordinatesStartMarker(String h, String v) {
    return 'Start: $h, $v';
  }

  @override
  String labsPitchCoordinatesFinishMarker(String h, String v) {
    return 'Finish: $h, $v';
  }

  @override
  String get labsPitchCoordinatesSameColumn => 'Same column as the player';

  @override
  String get labsPitchCoordinatesSameRow => 'Same row as the player';

  @override
  String get labsPitchCoordinatesOnPlayer => 'On the player';

  @override
  String labsPitchCoordinatesAxisHorizontal(int lo, int hi) {
    return 'Horizontal number line, from $lo to $hi';
  }

  @override
  String labsPitchCoordinatesAxisVertical(int lo, int hi) {
    return 'Vertical number line, from $lo to $hi';
  }

  @override
  String get labsPitchCoordinatesCorrect => 'Yes, that\'s correct.';

  @override
  String get labsPitchCoordinatesFbGeneric =>
      'Not yet. Check the first number for right or left, then the second number for up or down.';

  @override
  String get labsPitchCoordinatesFbOrderSwapped =>
      'The numbers are the wrong way round. The first number is right or left; the second is up or down.';

  @override
  String get labsPitchCoordinatesFbOriginCounted =>
      'The origin counts as 0. Count each step along the lines from there.';

  @override
  String get labsPitchCoordinatesFbStartNotMoved =>
      'That is where the player started. Now make the move.';

  @override
  String get labsPitchCoordinatesFbHorizontalOnly =>
      'You made the right-or-left move. Now make the up-or-down move too.';

  @override
  String get labsPitchCoordinatesFbVerticalOnly =>
      'You made the up-or-down move. Now make the right-or-left move too.';

  @override
  String get labsPitchCoordinatesFbBothReversed =>
      'Both moves went the opposite way. Right and up make the numbers bigger; left and down make them smaller.';

  @override
  String get labsPitchCoordinatesFbHorizontalReversed =>
      'Check the right-or-left move: right makes the first number bigger, left makes it smaller.';

  @override
  String get labsPitchCoordinatesFbVerticalReversed =>
      'Check the up-or-down move: up makes the second number bigger, down makes it smaller.';

  @override
  String get labsPitchCoordinatesFbMovesSwapped =>
      'The two moves were swapped. The right-or-left move changes the first number.';

  @override
  String get labsPitchCoordinatesFbGaveMove =>
      'That is the move. Where does the player finish?';

  @override
  String get labsPitchCoordinatesFbGaveFinish =>
      'That is where the player finishes. What move gets them there?';

  @override
  String get labsPitchCoordinatesFbGaveStart =>
      'That is where the player started. What move gets them to the finish?';

  @override
  String get labsPitchCoordinatesFbMoveReversed =>
      'That move goes from the finish back to the start. Go from the start to the finish.';

  @override
  String get labsPitchCoordinatesTryAgain => 'Try again';

  @override
  String get labsPitchCoordinatesShowMe => 'Show me';

  @override
  String get labsPitchCoordinatesNext => 'Next';

  @override
  String get labsPitchCoordinatesExploreAgain => 'Explore again';

  @override
  String get labsFractionsOfASetTitle => 'Fractions of a Set';

  @override
  String get labsFractionsOfASetCardSubtitle =>
      'Share a collection into equal groups to find a fraction of it.';

  @override
  String get labsFractionsOfASetCardKind => 'Number model';

  @override
  String get labsFractionsOfASetIntro =>
      'The bottom number says how many equal groups to make. The top number says how many groups to take.';

  @override
  String labsFractionsOfASetPromptFind(int total, String fraction) {
    return 'What is $fraction of these $total counters?';
  }

  @override
  String labsFractionsOfASetPromptTransfer(int total, String fraction) {
    return '$fraction of $total = ?';
  }

  @override
  String labsFractionsOfASetPromptWhat(int total, int chosen) {
    return '$chosen of these $total counters are chosen. What fraction of the collection is that?';
  }

  @override
  String labsFractionsOfASetPromptCompare(
      int total, String fractionA, String fractionB) {
    return 'Which is more: $fractionA of $total or $fractionB of $total?';
  }

  @override
  String labsFractionsOfASetPromptEqual(int groups) {
    return 'Is this a fair split into $groups equal groups?';
  }

  @override
  String get labsFractionsOfASetPrediction => 'Your answer';

  @override
  String get labsFractionsOfASetConfirmAnswer => 'Confirm my answer';

  @override
  String labsFractionsOfASetStepGroup(int groups) {
    return 'Make $groups equal groups. Tap a tray to put a counter in it.';
  }

  @override
  String get labsFractionsOfASetDeal => 'Deal one to each tray';

  @override
  String labsFractionsOfASetTakeOneOutOfTray(int index) {
    return 'Take one out of tray $index';
  }

  @override
  String get labsFractionsOfASetStartAgain => 'Start again';

  @override
  String labsFractionsOfASetLeftToPlace(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count counters left to place',
      one: '1 counter left to place',
      zero: 'Every counter is placed.',
    );
    return '$_temp0';
  }

  @override
  String get labsFractionsOfASetGroupsReady => 'These groups are ready';

  @override
  String labsFractionsOfASetStepTake(int groups, int n) {
    return 'Take $n of the $groups groups. Tap the trays you want.';
  }

  @override
  String get labsFractionsOfASetTakeConfirm => 'Take these groups';

  @override
  String labsFractionsOfASetTakeCount(int chosen, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Take $n trays.',
      one: 'Take 1 tray.',
    );
    return '$_temp0 You have chosen $chosen.';
  }

  @override
  String labsFractionsOfASetTray(int groups, int count, int index) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count counters',
      one: '1 counter',
      zero: 'empty',
    );
    return 'Tray $index of $groups: $_temp0';
  }

  @override
  String get labsFractionsOfASetChosen => 'chosen';

  @override
  String get labsFractionsOfASetDifferent => 'different';

  @override
  String labsFractionsOfASetCollection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Collection: $count counters to place',
      one: 'Collection: 1 counter to place',
      zero: 'Collection: empty',
    );
    return '$_temp0';
  }

  @override
  String get labsFractionsOfASetTopNumber => 'Top number';

  @override
  String labsFractionsOfASetOutOfGroups(int groups) {
    return 'out of $groups equal groups';
  }

  @override
  String get labsFractionsOfASetSame => 'They are the same';

  @override
  String get labsFractionsOfASetYes => 'Yes, it\'s fair';

  @override
  String get labsFractionsOfASetNo => 'No, it\'s not fair';

  @override
  String labsFractionsOfASetRevealFind(int total, int answer, String fraction) {
    return '$fraction of $total is $answer.';
  }

  @override
  String labsFractionsOfASetRevealSteps(
      int total, int groups, int n, int size, int answer) {
    return '$total ÷ $groups = $size, then $n × $size = $answer';
  }

  @override
  String labsFractionsOfASetRevealWhat(
      int total, int chosen, int groups, int n, String fraction) {
    return '$chosen of $total is $fraction: $n of the $groups equal groups.';
  }

  @override
  String labsFractionsOfASetRevealCompare(
      int total, int valueA, int valueB, String fractionA, String fractionB) {
    return '$fractionA of $total is $valueA; $fractionB of $total is $valueB.';
  }

  @override
  String labsFractionsOfASetRevealEqual(int groups, int size) {
    return '$groups trays with $size in each.';
  }

  @override
  String get labsFractionsOfASetCorrect => 'Yes, that\'s correct.';

  @override
  String labsFractionsOfASetFbDivNum(int groups, int n) {
    return 'The bottom number, $groups, says how many equal groups to make. The top number, $n, says how many of those groups to take.';
  }

  @override
  String get labsFractionsOfASetFbTookN =>
      'The fraction is of the whole collection, so take whole groups, not single counters.';

  @override
  String labsFractionsOfASetFbOneGroup(int n) {
    return 'That is one group. The top number says take $n groups, so count them all.';
  }

  @override
  String labsFractionsOfASetFbOtherGroups(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'the $n groups',
      one: 'the group',
    );
    return 'That counts the groups you did not take. Count only $_temp0 the top number asks for.';
  }

  @override
  String get labsFractionsOfASetFbWhole =>
      'That is the whole collection. The fraction is only part of it.';

  @override
  String labsFractionsOfASetFbFindGeneric(int groups, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n of them',
      one: 'one of them',
    );
    return 'Make $groups equal groups, then count the counters in $_temp0.';
  }

  @override
  String get labsFractionsOfASetFbObjectCount =>
      'That is the number of chosen counters. The top number counts groups, not counters.';

  @override
  String get labsFractionsOfASetFbGroupSize =>
      'That is how many counters are in one group. The top number counts the chosen groups.';

  @override
  String get labsFractionsOfASetFbNotChosen =>
      'That counts the groups that are not chosen.';

  @override
  String labsFractionsOfASetFbWhatWhole(int groups) {
    return 'That would be all $groups groups: the whole collection.';
  }

  @override
  String labsFractionsOfASetFbWhatGeneric(int groups) {
    return 'Share the counters into $groups equal groups, then count the groups that are chosen.';
  }

  @override
  String labsFractionsOfASetFbBiggerDenominator(
      int total, String fractionA, String fractionB) {
    return 'More equal groups means each group is smaller, so $fractionB of $total is less than $fractionA of $total.';
  }

  @override
  String get labsFractionsOfASetFbSame =>
      'Different numbers of equal groups give different group sizes, so these are not the same.';

  @override
  String get labsFractionsOfASetFbUnequalTrays =>
      'Some trays have different numbers of counters, so the groups are not equal. The trays that differ are outlined. \"Deal one to each tray\" shares fairly.';

  @override
  String get labsFractionsOfASetFbUnequalAccepted =>
      'Look again: two trays have different counts. They are outlined. Equal groups must all be the same size.';

  @override
  String labsFractionsOfASetFbEqualRejected(int size) {
    return 'Every tray has $size counters, so these groups are equal.';
  }

  @override
  String get labsFractionsOfASetNext => 'Next';

  @override
  String get labsFractionsOfASetExploreAgain => 'Explore again';

  @override
  String get labsFractionsOfASetBack => 'Back';

  @override
  String get labsFractionsOfASetStepperIncrease => 'Increase';

  @override
  String get labsFractionsOfASetStepperDecrease => 'Decrease';

  @override
  String labsFractionsOfASetHalves(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n halves',
      one: 'one half',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetThirds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n thirds',
      one: 'one third',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetQuarters(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n quarters',
      one: 'one quarter',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetFifths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fifths',
      one: 'one fifth',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetSixths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sixths',
      one: 'one sixth',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetEighths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eighths',
      one: 'one eighth',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetTenths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tenths',
      one: 'one tenth',
    );
    return '$_temp0';
  }

  @override
  String get earlyMathsEntryIntro =>
      'Pick a friendly place to start. Age is only a suggestion, not a level. There is no test, and you can switch at any time.';

  @override
  String get earlyMathsLaneChooserLabel => 'Choose a starting point';

  @override
  String get earlyMathsLanePlayTitle => 'Early Maths Play';

  @override
  String get earlyMathsLanePlayAges => 'Typical ages 4–5 · Reception';

  @override
  String get earlyMathsLaneKs1Title => 'KS1 Maths Foundations';

  @override
  String get earlyMathsLaneKs1Ages => 'Typical ages 5–7 · Years 1–2';

  @override
  String get earlyMathsLaneNotSureTitle => 'I\'m not sure';

  @override
  String get earlyMathsLaneNotSureSubtitle =>
      'No test needed. We\'ll suggest one gentle first step.';

  @override
  String get earlyMathsLaneSwitchNote =>
      'Switching never removes anything your child has already done.';

  @override
  String get earlyMathsActivitiesHeading => 'Activities to try';

  @override
  String get earlyMathsNotSureHeading => 'A gentle first step';

  @override
  String get earlyMathsNotSureBody =>
      'There is no right or wrong choice. Try this one small activity and see how it feels. You can choose a different starting point above whenever you like.';

  @override
  String get earlyMathsPandaScope =>
      'Count out 1 to 3 apples from 5, then say how many are left.';

  @override
  String get earlyMathsAbacusTitle => 'Abacus';

  @override
  String get earlyMathsAbacusScope =>
      'An interactive place-value tool: tap or drag beads to explore hundreds, tens and ones.';

  @override
  String get earlyMathsParentHeading => 'For grown-ups';

  @override
  String get earlyMathsParentCardTitle => 'Parent-led activities';

  @override
  String get earlyMathsParentCardSubtitle =>
      'Short activities to do together. Opens with your parent PIN.';

  @override
  String earlyMathsParentTitlesLine(String titles) {
    return 'Includes: $titles';
  }

  @override
  String get accessibilitySettingsSubtitle =>
      'Adjust for comfort and readability';

  @override
  String get accessibilityReadingSizeSubtitle =>
      'Choose a comfortable reading size';

  @override
  String get accessibilityReadingSizeSmall => 'Small';

  @override
  String get accessibilityReadingSizeDefault => 'Default';

  @override
  String get accessibilityReadingSizeLarge => 'Large';

  @override
  String get accessibilityReduceMotionTitle => 'Reduce Motion';

  @override
  String get accessibilityReduceMotionSubtitle =>
      'Minimise animations and transitions';

  @override
  String get accessibilityQuietStudyModeSubtitle =>
      'Inspired by Nyepi, a Balinese tradition of reflection, stillness and focus — reduces Captain Math and sound cues';

  @override
  String get accessibilitySoundCuesTitle => 'Sound Cues';

  @override
  String get accessibilitySoundCuesSubtitle =>
      'Short, optional sounds for Interactive Labs actions';

  @override
  String onboardingTimeEstimateSeconds(int seconds) {
    return '~$seconds seconds';
  }
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
  String practiceModeExamSimulatorSubFor(String examLabel) {
    return 'Simulazione d\'esame in stile $examLabel';
  }

  @override
  String get practiceExamSimulatorSelectPrompt =>
      'Scegli un esame per iniziare';

  @override
  String get practiceSelectExamLabel => 'SCEGLI L\'ESAME';

  @override
  String get practiceExamEntranceExamPrep => 'Preparazione esame di ammissione';

  @override
  String get entranceExamHubTitle => 'Preparazione all\'esame di ammissione';

  @override
  String get entranceExamHubIntro =>
      'Esercitazione per esami di ammissione alle scuole indipendenti inglesi (independent schools), distinta dal simulatore d\'esame GCSE – pensata per la fascia d\'età 11+ e valutata confrontando il tuo procedimento con una soluzione modello, non con risposte a scelta multipla.';

  @override
  String get entranceExamDisclaimerHeading =>
      'Nessuna affiliazione con una scuola o un ente d\'esame';

  @override
  String get entranceExamAgeBandLabel => 'Fascia d\'età';

  @override
  String get entranceExamDurationLabel => 'Durata';

  @override
  String get entranceExamCalculatorLabel => 'Calcolatrice';

  @override
  String get entranceExamCalculatorNone => 'Non consentita';

  @override
  String get entranceExamCalculatorAllowed => 'Consentita';

  @override
  String get entranceExamCalculatorAllowedNonScientific =>
      'Consentita (non scientifica)';

  @override
  String entranceExamDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get entranceExamModePracticeBySkillTitle =>
      'Esercitazione per abilita';

  @override
  String get entranceExamModePracticeBySkillSub =>
      'Svolgi domande raggruppate per abilita, con procedimenti svolti da confrontare.';

  @override
  String get entranceExamModeReviewMethodsTitle => 'Rivedi i metodi';

  @override
  String get entranceExamModeReviewMethodsSub =>
      'Rivedi il procedimento completo di ogni domanda disponibile — senza timer, senza valutazione.';

  @override
  String get entranceExamModeUntimedPaperTitle => 'Prova senza limite di tempo';

  @override
  String get entranceExamModeUntimedPaperSub =>
      'Svolgi la prova completa senza limite di tempo.';

  @override
  String get entranceExamModeTimedMockTitle => 'Simulazione a tempo';

  @override
  String get entranceExamModeTimedMockSub =>
      'Svolgi la prova completa con la tempistica reale dell\'esame.';

  @override
  String get entranceExamModeScholarshipChallengeTitle =>
      'Sfida borsa di studio';

  @override
  String get entranceExamModeScholarshipChallengeSub =>
      'Una prova più impegnativa per candidati di livello borsa di studio.';

  @override
  String entranceExamModeLockedFullPaperReason(int declared, int authored) {
    return 'Si sblocca quando la prova completa di $declared domande sara pronta — finora ne sono state redatte $authored.';
  }

  @override
  String get entranceExamModeLockedScholarshipReason =>
      'Questo pacchetto e di livello Base — la Sfida borsa di studio richiede un pacchetto di livello borsa di studio.';

  @override
  String get entranceExamModeLockedBadge => 'Prossimamente';

  @override
  String get entranceExamSkillPickerTitle => 'Scegli un\'abilita';

  @override
  String entranceExamSkillQuestionCountLabel(int count) {
    return '$count domande disponibili';
  }

  @override
  String get entranceExamSkillNumberFluency => 'Abilita di calcolo';

  @override
  String get entranceExamSkillFractionsAndPercentages =>
      'Frazioni e percentuali';

  @override
  String get entranceExamSkillRatioAndProportion => 'Rapporti e proporzioni';

  @override
  String get entranceExamSkillAlgebraicReasoning => 'Ragionamento algebrico';

  @override
  String get entranceExamSkillShapeAndSpace => 'Forme e spazio';

  @override
  String get entranceExamSkillDataAndLogic => 'Dati e logica';

  @override
  String entranceExamQuestionOf(int current, int total) {
    return 'Domanda $current di $total';
  }

  @override
  String get entranceExamRevealMethodButton => 'Mostra il procedimento';

  @override
  String get entranceExamMethodMarkPrompt =>
      'Confronta questo con il tuo procedimento. Che cosa corrisponde meglio a ciò che hai scritto?';

  @override
  String get entranceExamMethodMarkCorrect =>
      'Corretto — procedimento completo mostrato';

  @override
  String get entranceExamMethodMarkSlip => 'Procedimento corretto, un errore';

  @override
  String get entranceExamMethodMarkPartial => 'Ragionamento parziale';

  @override
  String get entranceExamMethodMarkUnsupported =>
      'Solo risposta, senza procedimento';

  @override
  String get entranceExamMethodMarkBlank => 'Non ho provato';

  @override
  String get entranceExamNextQuestionButton => 'Domanda successiva';

  @override
  String get entranceExamSessionCompleteTitle => 'Esercitazione completata';

  @override
  String entranceExamSessionEstimatedMarks(String marks, int total) {
    return 'Punti stimati: $marks / $total';
  }

  @override
  String get entranceExamSessionEstimatedMarksNote =>
      'Una stima basata sulla tua autovalutazione, non uno schema di valutazione ufficiale — vedi le indicazioni sotto ogni domanda.';

  @override
  String get entranceExamReviewTitle => 'Rivedi i metodi';

  @override
  String get entranceExamNoHandwritingNote =>
      'Questa app non legge ne valuta mai il tuo procedimento scritto a mano — sei tu a confrontarlo con il procedimento mostrato.';

  @override
  String get practiceExit => 'Esci';

  @override
  String practiceQuestionOf(int current) {
    return 'Domanda $current';
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
      'Gratuito per studenti e genitori. Usando Math Intelligence accetti i nostri termini di servizio. Per l\'accesso standard non è richiesto alcun pagamento.';

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
  String get onboardingSignInPrompt => 'Hai già un account?';

  @override
  String get onboardingSignIn => 'Accedi';

  @override
  String get onboardingGuestMode => 'Modalità ospite';

  @override
  String get onboardingGuestModeSub =>
      'Prova una sessione di esercizi limitata.';

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
  String get onboardingStage1Label => 'KS2 (Year 3–6, Inghilterra)';

  @override
  String get onboardingStage1Sub => 'Matematica di base';

  @override
  String get onboardingStage2Label => 'KS3 (Year 7–9, Inghilterra)';

  @override
  String get onboardingStage2Sub => 'Matematica intermedia';

  @override
  String get onboardingStage3Label => 'KS4 GCSE (Year 10–11, Inghilterra)';

  @override
  String get onboardingStage3Sub => 'Preparazione al GCSE di matematica';

  @override
  String get onboardingStage4Label => 'KS5 (Year 12–13, Inghilterra)';

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
  String get onboardingGoal1Label => 'Acquisire sicurezza';

  @override
  String get onboardingGoal1Sub =>
      'Esercizi regolari e senza pressione, al tuo ritmo';

  @override
  String get onboardingGoal2Label => 'Migliorare in matematica a scuola';

  @override
  String get onboardingGoal2Sub =>
      'Consolidare gli argomenti affrontati in classe';

  @override
  String get onboardingGoal3Label => 'Prepararsi agli esami';

  @override
  String get onboardingGoal3Sub =>
      'Esercizi mirati per il GCSE e serie a tempo';

  @override
  String get onboardingGoal4Label => 'Mettermi alla prova';

  @override
  String get onboardingGoal4Sub => 'Sfide impegnative e problemi avanzati';

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
  String get onboardingDisplayNameHint => 'ad es. Alex';

  @override
  String get onboardingLearnerNameLabel =>
      'Come vuoi che chiamiamo il tuo studente?';

  @override
  String get onboardingLearnerNameSub => 'Personalizza il suo Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'ad es. Alex';

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
  String get upgradeBenefit2Title => 'Percorso in stile Oxford';

  @override
  String get upgradeBenefit2Sub =>
      'Percorso strutturato in stile Oxford, con set di problemi selezionati e progressione guidata da KS3 ad A-Level (programma inglese).';

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
  String get homeFormulaLibraryTitle => 'Formulario';

  @override
  String get homeFormulaLibrarySubtitle =>
      'Riferimento rapido alle principali formule matematiche';

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
  String get practiceTopicDrillEmpty =>
      'Ancora nessuna domanda per questo argomento a questo livello. Prova un altro argomento o livello.';

  @override
  String get practiceUnavailableTitle =>
      'Quest\'area di esercizio non è ancora disponibile.';

  @override
  String get practiceUnavailableAction => 'Scegli un altro argomento';

  @override
  String get practiceEnglishContentNotice =>
      'Le domande di esercizio sono attualmente disponibili solo in inglese.';

  @override
  String practiceTopicUnavailableForStage(
      String topic, String stage, String stages) {
    return '$topic non è ancora disponibile per $stage — prova $stages.';
  }

  @override
  String practiceTopicUnavailableEverywhere(String topic) {
    return '$topic non è ancora disponibile per nessun livello.';
  }

  @override
  String get topicHubSubtitle =>
      'Scopri cosa puoi davvero fare con questo argomento';

  @override
  String get topicHubStageLabel => 'Livello';

  @override
  String get topicHubSectionPractise => 'Esercitati';

  @override
  String get topicHubSectionLearn => 'Impara';

  @override
  String get topicHubSectionExplore => 'Esplora';

  @override
  String topicHubNoActivities(String stage) {
    return 'Nessuna attività disponibile per questo argomento a $stage per ora.';
  }

  @override
  String get ratioFoundationsHubCardTitle => 'Basi: scalare i rapporti';

  @override
  String get ratioFoundationsHubCardReason =>
      'Riconoscere rapporti equivalenti, poi esercitarsi, prima guidati e poi da soli, a moltiplicare entrambi i termini per lo stesso numero.';

  @override
  String get ratioFoundationsScreenTitle => 'Basi: scalare i rapporti';

  @override
  String get ratioFoundationsRungRecognise => 'Riconoscere';

  @override
  String get ratioFoundationsRungGuided => 'Esercizio guidato';

  @override
  String get ratioFoundationsRungFluency => 'Consolidamento';

  @override
  String get ratioFoundationsShowHint => 'Mostra il suggerimento';

  @override
  String get ratioFoundationsHideHint => 'Nascondi il suggerimento';

  @override
  String get ratioFoundationsCorrect => 'Corretto!';

  @override
  String get ratioFoundationsIncorrect => 'Non proprio';

  @override
  String get ratioFoundationsContinue => 'Continua';

  @override
  String get ratioFoundationsNextItem => 'Esercizio successivo';

  @override
  String ratioFoundationsFluencyProgress(int correct, int target) {
    return 'Finora $correct esercizi di consolidamento corretti su $target';
  }

  @override
  String get ratioFoundationsCompletionTitle =>
      'Basi della scalatura dei rapporti completate.';

  @override
  String get ratioFoundationsCompletionBody =>
      'Presto arriveranno altre attività sui rapporti.';

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
      'Sblocca GCSE Foundation, GCSE Higher, il percorso Oxford e i crediti Tutor.';

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
  String homeThemeToggleSemanticLabel(String mode) {
    return 'Tema: $mode. Cambia tema';
  }

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
  String get navJourney => 'Journey';

  @override
  String get navMore => 'Altro';

  @override
  String get interactiveStudiosTitle => 'Studi interattivi';

  @override
  String get footballStudioDescription =>
      'Football Studio include attività applicate su coordinate, rapporti e scale, angoli, distanza-tempo-velocità, aree e algebra.';

  @override
  String get footballStudioChecking =>
      'Verifica dell\'installazione di Football Studio…';

  @override
  String get footballStudioInstalled =>
      'Football Studio è installato e pronto per l\'apertura.';

  @override
  String get footballStudioUnavailable =>
      'Football Studio non è installato su questo dispositivo.';

  @override
  String get footballStudioInstallNeeded =>
      'Installa Football Studio separatamente per aprire queste attività.';

  @override
  String get footballStudioOpen => 'Apri Football Studio';

  @override
  String get footballStudioOpening => 'Apertura di Football Studio…';

  @override
  String get footballStudioCheckFailed =>
      'Impossibile verificare se Football Studio è installato.';

  @override
  String get footballStudioLaunchFailed =>
      'Football Studio è installato, ma Android non è riuscito ad aprirlo.';

  @override
  String get footballStudioTryAgain => 'Riprova ad aprire';

  @override
  String get footballStudioCheckAgain => 'Controlla di nuovo';

  @override
  String get footballStudioAndroidOnly =>
      'Football Studio è disponibile come app Android separata.';

  @override
  String get footballStudioProgressOwnership =>
      'Nella V1 traguardi e progressi restano su questo dispositivo, in Football Studio. Unified Math Tutor non li legge né li condivide.';

  @override
  String get navHideAction => 'Nascondi la navigazione';

  @override
  String get navShowAction => 'Mostra la navigazione';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get journeyTitle => 'Il tuo Journey';

  @override
  String get journeySubtitle =>
      'Serie, traguardi e obiettivi in un unico posto.';

  @override
  String get journeyTeaserSubtitle =>
      'Guarda la tua serie, i traguardi e gli obiettivi';

  @override
  String get practiceExitSessionTitle => 'Uscire dalla sessione?';

  @override
  String get practiceExitSessionBody =>
      'I tuoi progressi attuali potrebbero non essere salvati.';

  @override
  String get onboardingDiscardTitle => 'Eliminare le risposte?';

  @override
  String get onboardingDiscardBody =>
      'Se torni indietro, quanto inserito in questo passaggio verrà cancellato.';

  @override
  String get onboardingProductName => 'Math Intelligence';

  @override
  String get onboardingTechBadge => 'Basato su Adaptive Learning Intelligence';

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
  String get exploreInAtelierBadge => 'In atelier';

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
  String get mathStudioNavCardSubtitle => 'Scopri la matematica che usi già';

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
  String get mathStudioMathMagicNumberTricksLabel => 'Trucchi numerici visivi';

  @override
  String get mathStudioMathMagicNumberTricksSubtitle =>
      'Segui un trucco numerico passo dopo passo';

  @override
  String get mathStudioMathMagicPatternsLabel => 'Motivi';

  @override
  String get mathStudioMathMagicPatternsSubtitle =>
      'Fai crescere uno schema di punti e scopri la regola che lo governa';

  @override
  String get mathStudioMathMagicMagicSquaresLabel => 'Quadrati magici';

  @override
  String get mathStudioMathMagicMagicSquaresSubtitle =>
      'Disponi i numeri in modo che ogni linea dia lo stesso totale';

  @override
  String get mathStudioMathMagicParityLabel => 'Parita';

  @override
  String get mathStudioMathMagicParitySubtitle =>
      'Scopri cosa succede sommando numeri pari e dispari';

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
  String get mathStudioSpatialCubeNetsLabel => 'Sviluppi del cubo';

  @override
  String get mathStudioSpatialCubeNetsSubtitle =>
      'Stabilisci quali sviluppi si piegano in un cubo chiuso';

  @override
  String get mathStudioSpatialRotationsSubtitle =>
      'Ruota una figura attorno a un punto fisso e osserva cosa cambia';

  @override
  String get mathStudioSpatialTransformationsSubtitle =>
      'Trasla, rifletti, ruota e ingrandisci su una griglia di coordinate';

  @override
  String get mathStudioSpatialPuzzlesSubtitle =>
      'Brevi enigmi su forma, spazio e pensiero 3D';

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
  String get mathStudioCategoryArchitectureConstruction =>
      'Architettura e costruzioni';

  @override
  String get mathStudioCategoryEnvironmentClimate => 'Ambiente e clima';

  @override
  String get mathStudioCategoryComputingCryptography =>
      'Informatica e crittografia';

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
  String get captainMathEncouraging => 'Ben pensato – continua così.';

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
  String get fractionBarsCaption3 => '3/4 è più della metà, meno dell\'intero.';

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
  String get recallCardsTopicFilterGroupLabel => 'Argomento';

  @override
  String get recallCardsTypeFilterGroupLabel => 'Tipo di scheda';

  @override
  String get recallCardsMoreChipLabel => 'Altro';

  @override
  String get recallCardsMoreTopicsSheetTitle => 'Altri argomenti';

  @override
  String get recallCardsMoreTypesSheetTitle => 'Altri tipi di scheda';

  @override
  String get recallCardsClearFiltersButton => 'Cancella filtri';

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
  String get recallCardsTopicProbability => 'Probabilità';

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
      'Un\'equazione resta vera solo se fai la stessa cosa su entrambi i lati. Semplifica passo dopo passo finché x non resta isolata.';

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
      'La media viene attratta da un valore anomalo molto più della mediana. Rimuovi valori e osserva ogni media aggiornarsi dal vivo.';

  @override
  String get labsDataDetectiveWhereUsed =>
      'Riportare uno stipendio, un prezzo o un punteggio \'tipico\' in modo equo significa sapere quando la media è fuorviante e la mediana è un riassunto migliore.';

  @override
  String get labsDataDetectiveAddValueButton => 'Aggiungi un valore tipico';

  @override
  String get labsDataDetectivePredictionPrompt =>
      'Quale cambierà di più una volta rimosso il valore anomalo?';

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
  String get labsSpatialCubeLabTitle => 'Laboratorio del cubo spaziale';

  @override
  String get labsSpatialCubeLabSubtitle =>
      'Ruota, piega ed esplora un cubo etichettato';

  @override
  String get labsSpatialCubeLabIntro =>
      'Trascina il cubo per ruotarlo. Osserva come le facce restano nella stessa posizione relativa tra loro, comunque tu lo giri.';

  @override
  String get labsSpatialCubeLabFreePlayCaption =>
      'Provaci: trascina il cubo, oppure usa i pulsanti qui sotto.';

  @override
  String get labsSpatialCubeWhichFaceOppositeTitle => 'Quale faccia e opposta?';

  @override
  String get labsSpatialCubeWhichFaceOppositeSubtitle =>
      'Prevedi la faccia opposta, poi verifica ruotando';

  @override
  String get labsSpatialCubeRotateToMatchTitle => 'Ruota per corrispondere';

  @override
  String get labsSpatialCubeRotateToMatchSubtitle =>
      'Ruota il tuo cubo per farlo corrispondere all\'orientamento target';

  @override
  String get labsSpatialCubeHiddenFaceTitle => 'Faccia nascosta';

  @override
  String get labsSpatialCubeHiddenFaceSubtitle =>
      'Scopri quale etichetta si trova su una faccia che non vedi';

  @override
  String get labsSpatialCubeNetExplorerTitle =>
      'Esploratore di sviluppi del cubo';

  @override
  String get labsSpatialCubeNetExplorerSubtitle =>
      'Prevedi le facce opposte su uno sviluppo piatto, poi piegalo';

  @override
  String get labsEarlyMathsPlaygroundTitle =>
      'Parco giochi di matematica per i più piccoli';

  @override
  String get labsEarlyMathsPlaygroundSubtitle =>
      'Attività calme e giocose per contare, condividere e scoprire le prime frazioni, per i giovani studenti';

  @override
  String get earlyMathsPlaygroundIntro =>
      'Uno spazio calmo e senza limiti di tempo dove i giovani studenti possono esercitarsi a contare, a condividere e a scoprire le prime frazioni — senza punteggi, senza timer, senza pressione.';

  @override
  String get feedTheHungryPandaTitle => 'Dai da mangiare al panda affamato';

  @override
  String get feedTheHungryPandaSubtitle =>
      'Conta le mele una alla volta per dar da mangiare al panda';

  @override
  String get abacusPlayModeGuided => 'Guidato';

  @override
  String get abacusPlayModeFree => 'Esplorazione libera';

  @override
  String get abacusPlayFreeTitle => 'Esplorazione libera';

  @override
  String get abacusPlayFreeIntro =>
      'Fai scorrere le palline oltre la barra per formare qualsiasi numero fino a 999. Qui non c\'è nessun obiettivo. Esplora e basta.';

  @override
  String get abacusPlayHowTo =>
      'Tocca una pallina o trascinala oltre la barra per contarla. Tocca una pallina contata per rimandarla indietro.';

  @override
  String get abacusPlayReset => 'Reimposta';

  @override
  String get abacusPlayBuildTitle => 'Formare un numero';

  @override
  String get abacusPlayBuildTask =>
      'Forma 34. Fai scorrere 3 decine e 4 unità oltre la barra.';

  @override
  String get abacusPlayBuildDone => 'Hai formato 34: 3 decine e 4 unità.';

  @override
  String get abacusPlayBreakTitle => 'Scomporre un numero';

  @override
  String get abacusPlayBreakTask =>
      'Questo è 47. Fai scorrere indietro le 7 unità in modo che restino solo le decine.';

  @override
  String get abacusPlayBreakDone => '47 si scompone in 40 e 7.';

  @override
  String get abacusPlayExchangeTitle => 'Scambiare dieci unità con una decina';

  @override
  String get abacusPlayExchangeTask =>
      'Questo è 29. Premi +1 per aggiungerne uno e osserva che cosa succede alle unità.';

  @override
  String get abacusPlayExchangeDone =>
      '10 unità scambiate con 1 decina, quindi 29 + 1 = 30.';

  @override
  String get abacusPlayNoteTenOnes => '10 unità scambiate con 1 decina.';

  @override
  String get abacusPlayNoteTenTens => '10 decine scambiate con 1 centinaio.';

  @override
  String get abacusPlayNoteTenOnesAndTens =>
      '10 unità scambiate con 1 decina e 10 decine con 1 centinaio.';

  @override
  String get abacusPlayNoteTenToOnes => '1 decina scambiata con 10 unità.';

  @override
  String get abacusPlayNoteHundredToTens =>
      '1 centinaio scambiato con 10 decine.';

  @override
  String get abacusPlayNoteHundredCascade =>
      '1 centinaio scambiato con 10 decine e 1 decina con 10 unità.';

  @override
  String get abacusPlayParentNote =>
      'Per gli adulti: ogni asta contiene fino a nove palline. La tabella dei numeri mostra lo stesso numero in cifre e i due coincidono sempre. Dieci palline su un\'asta si scambiano con una pallina sull\'asta alla sua sinistra. Chiedi a tuo figlio di dire che cosa è cambiato. È un\'immagine concreta del valore posizionale, non un test.';

  @override
  String get abacusBoardTitle => 'Tabella dei numeri';

  @override
  String get abacusBoardZero => '0: ancora nessuna pallina contata';

  @override
  String get abacusBoardAddOne => 'Aggiungi 1';

  @override
  String get abacusBoardSubtractOne => 'Togli 1';

  @override
  String get abacusBoardAddTen => 'Aggiungi 10';

  @override
  String get abacusBoardSubtractTen => 'Togli 10';

  @override
  String get abacusSpokenZero => '0. Ancora nessuna pallina contata.';

  @override
  String abacusPlayRodLabel(String name) {
    return 'Asta: $name';
  }

  @override
  String abacusPlayRodValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palline contate',
      one: '1 pallina contata',
      zero: 'Nessuna pallina contata',
    );
    return '$_temp0';
  }

  @override
  String abacusPlayPartHundreds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count centinaia',
      one: '1 centinaio',
    );
    return '$_temp0';
  }

  @override
  String abacusPlayPartTens(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count decine',
      one: '1 decina',
    );
    return '$_temp0';
  }

  @override
  String abacusPlayPartOnes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unità',
      one: '1 unità',
    );
    return '$_temp0';
  }

  @override
  String abacusBoardEquationOne(int value, String a) {
    return '$value = $a';
  }

  @override
  String abacusBoardEquationTwo(int value, String a, String b) {
    return '$value = $a + $b';
  }

  @override
  String abacusBoardEquationThree(int value, String a, String b, String c) {
    return '$value = $a + $b + $c';
  }

  @override
  String abacusSpokenOne(int value, String a) {
    return '$value è $a';
  }

  @override
  String abacusSpokenTwo(int value, String a, String b) {
    return '$value è $a e $b';
  }

  @override
  String abacusSpokenThree(int value, String a, String b, String c) {
    return '$value è $a, $b e $c';
  }

  @override
  String feedPandaInstruction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mele',
      one: '1 mela',
    );
    return 'Dai al panda $_temp0.';
  }

  @override
  String feedPandaWellDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mele',
      one: '1 mela',
    );
    return 'Bravo! Il panda ha mangiato $_temp0.';
  }

  @override
  String get feedPandaHowManyLeft => 'Quante mele sono rimaste?';

  @override
  String get feedPandaHasEnough =>
      'Il panda ha mangiato abbastanza. Contiamo insieme.';

  @override
  String get feedPandaReplayInstructionButton => 'Riascolta l\'istruzione';

  @override
  String get feedPandaNewRoundButton => 'Nuovo turno';

  @override
  String feedPandaFruitSemanticLabel(int position, int total) {
    return 'Mela $position di $total. Tocca due volte per selezionare.';
  }

  @override
  String get feedPandaSelectedSuffix => 'Selezionata.';

  @override
  String feedPandaPandaSemanticReady(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Ancora $remaining mele necessarie',
      one: 'Ancora 1 mela necessaria',
    );
    return 'Dai da mangiare al panda. $_temp0.';
  }

  @override
  String get feedPandaPandaSemanticFull =>
      'Il panda ha mangiato abbastanza per questo turno.';

  @override
  String feedPandaAnswerChoiceSemanticLabel(int value) {
    return 'Risposta $value.';
  }

  @override
  String get feedPandaTryAgainMessage => 'Non proprio — riprova!';

  @override
  String get feedPandaRoundCompleteMessage => 'Hai contato benissimo!';

  @override
  String feedPandaBasketSemanticLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mele nel cesto.',
      one: '1 mela nel cesto.',
      zero: 'Il cesto e vuoto.',
    );
    return '$_temp0';
  }

  @override
  String feedPandaBowlSemanticLabel(int given, int target) {
    String _temp0 = intl.Intl.pluralLogic(
      target,
      locale: localeName,
      other: '$target mele',
      one: '1 mela',
    );
    return 'Il panda ha $given di $_temp0.';
  }

  @override
  String get feedPandaDropZoneLabel => 'Dai le mele al panda qui';

  @override
  String get feedPandaTapPandaHint =>
      'Mela scelta. Ora tocca il panda per dargliela.';

  @override
  String get labsSpatialCubeWhichFaceOppositeMission =>
      'Osserva il cubo, poi decidi quale faccia e opposta a quella indicata.';

  @override
  String labsSpatialCubeWhichFaceOppositeQuestion(String faceLabel) {
    return 'Quale faccia e opposta a $faceLabel?';
  }

  @override
  String get labsSpatialCubeWhichFaceOppositeHintButton => 'Suggerimento';

  @override
  String get labsSpatialCubeWhichFaceOppositeHintText =>
      'Le facce opposte non condividono mai uno spigolo — davanti/dietro, sopra/sotto e sinistra/destra sono sempre le tre coppie.';

  @override
  String get labsSpatialCubeWhichFaceOppositeCorrect =>
      'Ben pensato. Hai tenuto conto delle relazioni tra le facce.';

  @override
  String get labsSpatialCubeWhichFaceOppositeIncorrect =>
      'Quasi. Guarda quali facce condividono uno spigolo.';

  @override
  String get labsSpatialCubeWhichFaceOppositeWhereUsed =>
      'Imballare scatole, leggere un dado e lavorare con gli sviluppi 3D dipendono tutti dal sapere quali facce di un cubo sono opposte tra loro.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToDo =>
      'Ruota il cubo se vuoi, poi scegli la faccia che pensi sia opposta a quella indicata.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToNotice =>
      'Osserva che le facce opposte non sono mai adiacenti, comunque tu giri il cubo.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatItMeans =>
      'Ogni cubo ha esattamente tre coppie di facce opposte — davanti/dietro, sopra/sotto, sinistra/destra — e ruotare il cubo non cambia mai quali facce sono abbinate.';

  @override
  String labsSpatialCubeWhichFaceOppositeReveal(
      String correctLabel, String askedLabel) {
    return '$correctLabel e opposta a $askedLabel.';
  }

  @override
  String get labsSpatialCubeRotateToMatchMission =>
      'Ruota il tuo cubo finché non corrisponde all\'orientamento target mostrato.';

  @override
  String get labsSpatialCubeRotateToMatchTargetLabel => 'Orientamento target';

  @override
  String get labsSpatialCubeRotateToMatchYourCubeLabel => 'Il tuo cubo';

  @override
  String get labsSpatialCubeRotateToMatchTestButton =>
      'Verifica la mia rotazione';

  @override
  String get labsSpatialCubeRotateToMatchCorrect =>
      'Ben fatto — e una buona corrispondenza.';

  @override
  String get labsSpatialCubeRotateToMatchIncorrect =>
      'Non ancora. Confronta quale faccia e davanti e quale e sopra.';

  @override
  String get labsSpatialCubeRotateToMatchWhereUsed =>
      'Far corrispondere l\'orientamento di un oggetto a uno schema fa parte della lettura di disegni tecnici e istruzioni di montaggio.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatToDo =>
      'Trascina il tuo cubo per allineare le sue facce con il target mostrato accanto, poi verifica la tua rotazione.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatToNotice =>
      'Osserva che non serve una corrispondenza perfetta al pixel — basta che le stesse facce siano davanti e sopra.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatItMeans =>
      'Un orientamento e descritto completamente da quale faccia e davanti e quale e sopra — questi due dati fissano tutto il resto.';

  @override
  String get labsSpatialCubeHiddenFaceMission =>
      'Osserva le tre facce visibili, poi scopri cosa c\'e su quella nascosta.';

  @override
  String labsSpatialCubeHiddenFaceQuestion(String direction) {
    return 'Quale etichetta si trova sulla faccia $direction?';
  }

  @override
  String get labsSpatialCubeHiddenFaceHintButton => 'Suggerimento';

  @override
  String get labsSpatialCubeHiddenFaceHintText =>
      'Scopri prima quali facce PUOI vedere — la faccia nascosta e una delle tre restanti.';

  @override
  String get labsSpatialCubeHiddenFaceCorrect =>
      'Ben fatto. Hai previsto correttamente la faccia nascosta.';

  @override
  String get labsSpatialCubeHiddenFaceIncorrect =>
      'Buon tentativo. Ruota il cubo per controllare, poi prova il prossimo.';

  @override
  String get labsSpatialCubeHiddenFaceWhereUsed =>
      'Leggere diagrammi isometrici e disegni tecnici richiede di ragionare su facce che non si vedono direttamente.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatToDo =>
      'Osserva le tre facce visibili, poi scegli l\'etichetta che pensi si trovi sulla faccia nascosta indicata.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatToNotice =>
      'Osserva che da questa angolazione sono sempre visibili solo tre facce — le altre tre sono sempre nascoste.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatItMeans =>
      'Un cubo mostra sempre solo tre facce da un punto di vista, quindi scoprire una faccia nascosta significa ragionare sull\'intero cubo, non solo su ciò che si vede.';

  @override
  String get labsSpatialCubeNetExplorerMission =>
      'Osserva lo sviluppo piatto, prevedi quali facce finiranno opposte tra loro, poi piegalo per verificare.';

  @override
  String get labsSpatialCubeNetExplorerPredictPrompt =>
      'Quali due quadrati pensi finiranno opposti tra loro?';

  @override
  String get labsSpatialCubeNetExplorerFoldButton => 'Piega';

  @override
  String get labsSpatialCubeNetExplorerUnfoldButton => 'Distendi';

  @override
  String get labsSpatialCubeNetExplorerNextNetButton => 'Sviluppo successivo';

  @override
  String get labsSpatialCubeNetExplorerStepBackButton => 'Indietro';

  @override
  String get labsSpatialCubeNetExplorerStepForwardButton => 'Passo successivo';

  @override
  String get labsSpatialCubeNetExplorerWhereUsed =>
      'Il design degli imballaggi e la lavorazione della lamiera iniziano entrambi da uno sviluppo piatto che si piega in una forma 3D finita.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatToDo =>
      'Studia lo sviluppo piatto, poi premi Piega per vedere se si chiude in un cubo.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatToNotice =>
      'Osserva che non ogni disposizione di sei quadrati si piega in un cubo chiuso — alcune si sovrappongono o lasciano un vuoto.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatItMeans =>
      'Uno sviluppo è una forma 2D che si piega lungo i suoi bordi in un solido 3D — lo stesso quadrato può finire su lati molto diversi del cubo a seconda della forma dello sviluppo.';

  @override
  String get labsAircraftLandingLabTitle => 'Laboratorio di atterraggio';

  @override
  String get labsAircraftLandingLabSubtitle =>
      'Pilota l\'angolo di discesa, la distanza e la velocita che permettono un atterraggio sicuro';

  @override
  String get labsAircraftLandingLabIntro =>
      'Regola l\'angolo di discesa e la velocita, poi premi Verifica avvicinamento per vedere l\'aereo seguire il percorso e dove tocca terra.';

  @override
  String get labsAircraftLandingLabFreePlayCaption =>
      'Provaci: trascina i cursori, poi premi Verifica avvicinamento.';

  @override
  String get labsAircraftLandingFindTheTimeTitle => 'Trova il tempo';

  @override
  String get labsAircraftLandingFindTheTimeSubtitle =>
      'Scopri quanto dura il volo fino alla pista';

  @override
  String get labsAircraftLandingDescentLineTitle => 'Segui la linea di discesa';

  @override
  String get labsAircraftLandingDescentLineSubtitle =>
      'Fai corrispondere il tuo angolo di discesa a una linea di planata target';

  @override
  String get labsAircraftLandingGlidePathTitle =>
      'Atterra sul sentiero di planata';

  @override
  String get labsAircraftLandingGlidePathSubtitle =>
      'Scegli angolo e velocita per atterrare in sicurezza sulla pista';

  @override
  String get labsAircraftLandingVectorApproachTitle =>
      'Avvicinamento vettoriale';

  @override
  String get labsAircraftLandingVectorApproachSubtitle =>
      'Regola la velocita orizzontale e verticale per corrispondere a un avvicinamento target';

  @override
  String labsAircraftLandingDescentAngleLabel(int degrees) {
    return 'Angolo di discesa: $degrees°';
  }

  @override
  String labsAircraftLandingAirspeedLabel(int metresPerSecond) {
    return 'Velocita: $metresPerSecond m/s';
  }

  @override
  String get labsAircraftLandingTestApproachButton => 'Verifica avvicinamento';

  @override
  String labsAircraftLandingFindTheTimeDiagramLabel(
      int distanceM, int speedMps) {
    return 'Un aereo a $distanceM metri dalla pista, che vola a $speedMps metri al secondo.';
  }

  @override
  String labsAircraftLandingFindTheTimeSpeedLabel(int speedMps) {
    return 'Velocita: $speedMps m/s';
  }

  @override
  String get labsAircraftLandingFindTheTimeQuestion =>
      'Quanto tempo ci vorra per raggiungere la pista?';

  @override
  String get labsAircraftLandingFindTheTimeHintButton => 'Suggerimento';

  @override
  String get labsAircraftLandingFindTheTimeHintText =>
      'Tempo = distanza / velocita.';

  @override
  String get labsAircraftLandingFindTheTimeMission =>
      'Usa la distanza e la velocita mostrate per calcolare quanto durera il volo fino alla pista.';

  @override
  String get labsAircraftLandingFindTheTimeWhereUsed =>
      'I piloti e i controllori del traffico aereo stimano costantemente il tempo alla pista da velocita e distanza per sequenziare atterraggi sicuri.';

  @override
  String get labsAircraftLandingFindTheTimeCorrect =>
      'Corretto — hai trovato il tempo alla pista.';

  @override
  String get labsAircraftLandingFindTheTimeIncorrect =>
      'Non proprio. Prova a dividere la distanza per la velocita.';

  @override
  String labsAircraftLandingFindTheTimeReveal(int seconds) {
    return 'Il tempo corretto e $seconds secondi.';
  }

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatToDo =>
      'Leggi la distanza e la velocita mostrate, poi scegli il tempo corrispondente tra le opzioni.';

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatToNotice =>
      'Osserva che una velocità maggiore significa sempre un tempo più breve per la stessa distanza.';

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatItMeans =>
      'Tempo, distanza e velocita sono sempre collegati da tempo = distanza / velocita — la stessa relazione usata per qualsiasi viaggio, non solo per i voli.';

  @override
  String get labsAircraftLandingDescentLineTestButton =>
      'Verifica la mia linea';

  @override
  String get labsAircraftLandingDescentLineMission =>
      'Regola il tuo angolo di discesa finché la tua linea non corrisponde alla linea target tratteggiata.';

  @override
  String get labsAircraftLandingDescentLineWhereUsed =>
      'Far corrispondere una pendenza richiesta capita ogni volta che un percorso, una rampa o un tubo deve seguire un\'inclinazione fissa.';

  @override
  String get labsAircraftLandingDescentLineCorrect =>
      'Ben fatto — la tua linea corrisponde al sentiero di planata target.';

  @override
  String get labsAircraftLandingDescentLineIncorrect =>
      'Non ancora. Confronta quanto e ripida la tua linea rispetto alla linea target tratteggiata.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatToDo =>
      'Sposta il cursore dell\'angolo di discesa finché la tua linea piena non si sovrappone alla linea target tratteggiata, poi verificala.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatToNotice =>
      'Osserva che un angolo più ripido fa scendere la linea più velocemente — una pendenza negativa maggiore.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatItMeans =>
      'L\'angolo di discesa e la pendenza della linea: variazione di altitudine divisa per la distanza percorsa, scritta come y = mx + c con una m negativa.';

  @override
  String get labsAircraftLandingGlidePathSafe =>
      'Atterraggio morbido — proprio sulla pista.';

  @override
  String get labsAircraftLandingGlidePathTooSteep =>
      'Troppo ripido — l\'aereo ha toccato terra prima della pista.';

  @override
  String get labsAircraftLandingGlidePathTooShallow =>
      'Troppo piatto — l\'aereo era ancora in volo oltre la pista.';

  @override
  String get labsAircraftLandingGlidePathMission =>
      'Scegli angolo e velocita, poi verifica il tuo avvicinamento per atterrare in sicurezza sulla pista.';

  @override
  String get labsAircraftLandingGlidePathWhereUsed =>
      'Ogni atterraggio reale bilancia un angolo di discesa sicuro con velocita e distanza per toccare terra esattamente nel punto giusto.';

  @override
  String labsAircraftLandingGlidePathTouchdownError(int metres) {
    return '$metres metri dalla soglia pista.';
  }

  @override
  String get labsAircraftLandingGlidePathHelpWhatToDo =>
      'Regola l\'angolo e la velocita, poi premi Verifica avvicinamento per vedere dove l\'aereo tocca davvero terra.';

  @override
  String get labsAircraftLandingGlidePathHelpWhatToNotice =>
      'Osserva come il punto di contatto si sposta quando cambi l\'angolo, anche se la velocita resta la stessa.';

  @override
  String get labsAircraftLandingGlidePathHelpWhatItMeans =>
      'tan(angolo) = altitudine / distanza — proprio questo rapporto fa si che una discesa atterri precisamente sulla pista invece che corta o lunga.';

  @override
  String labsAircraftLandingVectorHorizontalLabel(int metresPerSecond) {
    return 'Velocita orizzontale: $metresPerSecond m/s';
  }

  @override
  String labsAircraftLandingVectorVerticalLabel(int metresPerSecond) {
    return 'Velocita verticale: $metresPerSecond m/s';
  }

  @override
  String labsAircraftLandingVectorResultantLabel(int metresPerSecond) {
    return 'Velocita combinata (risultante): $metresPerSecond m/s';
  }

  @override
  String get labsAircraftLandingVectorApproachMission =>
      'Regola le componenti di velocita orizzontale e verticale per corrispondere all\'avvicinamento target.';

  @override
  String get labsAircraftLandingVectorApproachWhereUsed =>
      'Combinare una velocita orizzontale e verticale in un unico vettore risultante e esattamente come una vera traiettoria di volo, o qualsiasi moto 2D, viene descritta matematicamente.';

  @override
  String get labsAircraftLandingVectorApproachCorrect =>
      'Corretto — le tue componenti corrispondono all\'avvicinamento target.';

  @override
  String get labsAircraftLandingVectorApproachIncorrect =>
      'Non ancora. Confronta le tue velocita orizzontale e verticale con il target.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatToDo =>
      'Regola i cursori di velocita orizzontale e verticale, poi verifica il tuo avvicinamento.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatToNotice =>
      'Osserva come la velocita risultante e il percorso di discesa cambiano entrambi quando regoli una delle due componenti.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatItMeans =>
      'Ogni velocità può essere scomposta in una componente orizzontale e una verticale, e ricombinata usando il teorema di Pitagora per trovare la velocità risultante.';

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
    return 'Un valore, $outlier, si distingue dagli altri — è molto più alto o più basso degli altri. Si chiama valore anomalo.';
  }

  @override
  String labsDataDetectiveBeforeAfter(String meanBefore, String meanAfter,
      String medianBefore, String medianAfter) {
    return 'Media: $meanBefore → $meanAfter. Mediana: $medianBefore → $medianAfter.';
  }

  @override
  String get labsDataDetectiveHelpWhatToDo =>
      'Guarda i valori, prevedi se la media o la mediana cambierà di più, poi rimuovi il valore anomalo per rivelare la risposta.';

  @override
  String get labsDataDetectiveHelpWhatToNotice =>
      'Nota quanto si sposta la media rispetto alla mediana una volta rimosso il valore anomalo.';

  @override
  String get labsDataDetectiveHelpWhatItMeans =>
      'La media usa ogni valore, quindi un valore estremo può spostarla molto. La mediana dipende solo dalla posizione centrale, quindi si muove a malapena.';

  @override
  String get labsDataDetectiveFirstUseStep1 =>
      'Guarda l\'elenco dei valori — uno di essi si distingue.';

  @override
  String get labsDataDetectiveFirstUseStep2 =>
      'Prevedi cosa cambierà di più: la media o la mediana.';

  @override
  String get labsDataDetectiveFirstUseStep3 =>
      'Rimuovi il valore anomalo e rivela la risposta.';

  @override
  String get labsAlgebraBalanceMission =>
      'Mantieni i due piatti in equilibrio finché x non resta da solo.';

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
      'Continua finché x non resta da solo.';

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
      'Tocca i segmenti finché il numero riempito corrisponde alla frazione, poi premi Verifica.';

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
    return 'Sposta $distance in più verso destra';
  }

  @override
  String labsNumberLineExplorerMoveLeft(String distance) {
    return 'Sposta $distance in più verso sinistra';
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
      'Nota come la posizione del punto corrisponda al suo valore — più a destra è un numero più grande, più a sinistra più piccolo.';

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
  String get labsDirectionDownRight => 'Giù-destra';

  @override
  String get labsDirectionDown => 'Giù';

  @override
  String get labsDirectionDownLeft => 'Giù-sinistra';

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

  @override
  String get allieLabel => 'Allie';

  @override
  String get familyMathsEntryTitle => 'Matematica in famiglia';

  @override
  String get familyMathsWelcomeTitle => 'Benvenuti';

  @override
  String get familyMathsWelcomeBody =>
      'Aiutare tuo figlio con la matematica non richiede una conoscenza perfetta. Piccole conversazioni. Giochi semplici. Curiosità. Costanza. Al resto pensiamo noi.';

  @override
  String get familyMathsAllieIntro =>
      'Non devi ricordare ogni metodo scolastico. Scegli un argomento. Ti suggerirò un\'attività di cinque minuti che aiuta tuo figlio a pensare in modo matematico.';

  @override
  String get familyMathsPhilosophyTagline =>
      'I genitori non devono diventare insegnanti.';

  @override
  String get familyMathsStartActivityButton =>
      'Inizia un\'attività in famiglia';

  @override
  String get familyMathsBrowseTopicsButton => 'Sfoglia gli argomenti';

  @override
  String get familyMathsLibraryTitle => 'Attività in famiglia';

  @override
  String get familyMathsEmptyCategory =>
      'Ancora nessuna attività per questo argomento. Presto ne arriveranno altre.';

  @override
  String familyActivityAgeRange(int min, int max) {
    return '$min-$max anni';
  }

  @override
  String familyActivityTimeRange(int min, int max) {
    return '$min-$max min';
  }

  @override
  String get familyActivityMaterialsLabel => 'Materiale necessario';

  @override
  String get familyActivityWhatYourChildLearnsLabel => 'Cosa impara tuo figlio';

  @override
  String get familyActivityLetsExploreLabel => 'Esploriamo insieme';

  @override
  String get familyActivityQuestionsToAskLabel => 'Domande da porre';

  @override
  String get familyActivityMisconceptionsLabel => 'Errori comuni';

  @override
  String get familyActivityTryTomorrowLabel => 'Da provare domani';

  @override
  String get familyActivityStudioConnectionLabel => 'Collegamento allo Studio';

  @override
  String get familyMathsCategoryNumberSense => 'Senso del numero';

  @override
  String get familyMathsCategoryAddition => 'Addizione';

  @override
  String get familyMathsCategorySubtraction => 'Sottrazione';

  @override
  String get familyMathsCategoryMultiplication => 'Moltiplicazione';

  @override
  String get familyMathsCategoryDivision => 'Divisione';

  @override
  String get familyMathsCategoryFractions => 'Frazioni';

  @override
  String get familyMathsCategoryDecimals => 'Numeri decimali';

  @override
  String get familyMathsCategoryRatio => 'Rapporto';

  @override
  String get familyMathsCategoryPercentages => 'Percentuali';

  @override
  String get familyMathsCategoryGeometry => 'Geometria';

  @override
  String get familyMathsCategoryMeasurement => 'Misura';

  @override
  String get familyMathsCategoryAlgebra => 'Algebra';

  @override
  String get familyMathsCategoryPatterns => 'Sequenze';

  @override
  String get familyMathsCategoryLogic => 'Logica';

  @override
  String get familyMathsCategorySpatialReasoning => 'Ragionamento spaziale';

  @override
  String get familyMathsReassurance1 =>
      'Non devi conoscere subito la risposta.';

  @override
  String get familyMathsReassurance2 =>
      'Chiedi a tuo figlio di spiegare cosa nota.';

  @override
  String get familyMathsReassurance3 =>
      'Una risposta sbagliata può avviare una conversazione utile.';

  @override
  String get familyMathsReassurance4 => 'Cinque minuti concentrati bastano.';

  @override
  String get familyMathsReassurance5 =>
      'Lascia che tuo figlio scelga gli oggetti.';

  @override
  String get familyMathsReassurance6 =>
      'Provate una rappresentazione diversa se la prima non aiuta.';

  @override
  String get onboardingFamilyRoleDetailTitle => 'Parlaci della tua famiglia';

  @override
  String get onboardingFamilyRoleDetailSub =>
      'Qualche domanda veloce per aiutarti nel modo giusto.';

  @override
  String get onboardingFamilyLearnerNamesLabel =>
      'Nome/i dello studente o degli studenti';

  @override
  String get onboardingFamilyLearnerNamesSub =>
      'Aggiungine almeno uno – potrai aggiungerne altri in seguito.';

  @override
  String get onboardingFamilyAddAnotherLearner => 'Aggiungi un altro studente';

  @override
  String get onboardingFamilyLearnerContextTitle => 'A che punto è tuo figlio?';

  @override
  String get onboardingFamilyLearnerContextSub =>
      'Ci aiuta a suggerire le attività e gli argomenti giusti.';

  @override
  String get onboardingFamilyGoalTitle => 'Che cosa ti porta qui?';

  @override
  String get onboardingFamilyGoalSub =>
      'Scegli ciò che conta di più in questo momento – potrai cambiarlo in seguito.';

  @override
  String get onboardingFamilyGoalHomework => 'Aiutare con i compiti';

  @override
  String get onboardingFamilyGoalUnderstandMethods => 'Capire i metodi attuali';

  @override
  String get onboardingFamilyGoalBuildConfidence => 'Acquisire sicurezza';

  @override
  String get onboardingFamilyGoalPractiseTogether => 'Esercitarsi insieme';

  @override
  String get onboardingFamilyGoalPrepareExam => 'Prepararsi a un esame';

  @override
  String get onboardingFamilyGoalMonitorProgress => 'Seguire i progressi';

  @override
  String get onboardingFamilyGoalSupportStruggling =>
      'Sostenere uno studente che trova difficile la matematica';

  @override
  String get onboardingFamilyActivityLengthLabel =>
      'Durata preferita dell\'attività';

  @override
  String get onboardingFamilyActivityLengthShort => 'circa 10 minuti';

  @override
  String get onboardingFamilyActivityLengthMedium => 'circa 20 minuti';

  @override
  String get onboardingFamilyActivityLengthLong => 'circa 30 minuti';

  @override
  String get onboardingFamilyPreferencesTitle => 'Quasi fatto';

  @override
  String get onboardingFamilyPreferencesSub =>
      'Qualche opzione facoltativa e ci siamo.';

  @override
  String get onboardingFamilyAllieIntro => 'Non devi spiegare tutto subito.';

  @override
  String get onboardingFamilyNotificationsLabel => 'Promemoria discreti';

  @override
  String get onboardingFamilyNotificationsSub =>
      'Facoltativo – promemoria occasionali sulla vostra attività in famiglia.';

  @override
  String get onboardingFamilyPinLabel =>
      'Imposta un PIN genitore (facoltativo)';

  @override
  String get onboardingFamilyPinSub =>
      'Protegge Matematica in famiglia e i contenuti per i genitori su un dispositivo condiviso. Puoi impostarlo anche più tardi nelle impostazioni.';

  @override
  String get onboardingFamilyFinishButton => 'Vai a Family Studio';

  @override
  String get recallTopicNumber => 'Numeri';

  @override
  String get recallTopicRatioAndProportion => 'Rapporti e proporzionalità';

  @override
  String get recallTopicAlgebra => 'Algebra';

  @override
  String get recallTopicGeometryAndMeasures => 'Geometria e misure';

  @override
  String get recallTopicStatistics => 'Statistica';

  @override
  String get recallTopicProbability => 'Probabilità';

  @override
  String get familyStudioHubTitle => 'Family Studio';

  @override
  String get familyStudioHubOpeningPromise =>
      'I genitori non devono diventare insegnanti.';

  @override
  String get familyStudioHubSupportingCopy =>
      'Scegli un argomento, un\'attività breve o un obiettivo per i compiti. Math Intelligence ti aiuta a iniziare.';

  @override
  String get familyStudioHubAllieMessage =>
      'Chiedi prima a tuo figlio che cosa nota.';

  @override
  String get familyStudioProfileEntrySubtitle =>
      'Attività, aiuto per i compiti e progressi per la tua famiglia.';

  @override
  String get familyStudioPrimaryActionStartActivity =>
      'Inizia un\'attività in famiglia';

  @override
  String get familyStudioPrimaryActionHomework => 'Aiutare con i compiti';

  @override
  String get familyStudioPrimaryActionLearning =>
      'Vedere che cosa impara mio figlio';

  @override
  String get familyStudioPrimaryActionGuides => 'Sfoglia le guide per genitori';

  @override
  String get familyStudioSectionTodaysActivityTitle =>
      'Attività in famiglia di oggi';

  @override
  String get familyStudioSectionTodaysActivitySubtitle =>
      'Una proposta fissa per oggi, da Matematica in famiglia.';

  @override
  String get familyStudioSectionHomeworkCompanionTitle =>
      'Compagno per i compiti';

  @override
  String get familyStudioSectionHomeworkCompanionSubtitle =>
      'Una sessione breve e prevedibile per i compiti di stasera.';

  @override
  String get familyStudioSectionLearningTitle => 'Che cosa impara tuo figlio';

  @override
  String get familyStudioSectionLearningSubtitle =>
      'Argomenti recenti degli esercizi.';

  @override
  String get familyStudioSectionExplainTitle => 'Spiegare questo metodo';

  @override
  String get familyStudioSectionExplainSubtitle => 'Apri il formulario.';

  @override
  String get familyStudioSectionConversationStartersTitle =>
      'Spunti di conversazione';

  @override
  String get familyStudioSectionConversationStartersSubtitle =>
      'Domande da fare mentre lavorate insieme.';

  @override
  String get familyStudioSectionParentRecallCardsTitle =>
      'Schede mnemoniche per genitori';

  @override
  String get familyStudioSectionParentRecallCardsSubtitle =>
      'Consigli calorosi e pratici — non domande d\'esame.';

  @override
  String get familyStudioSectionFractionsRatioTitle => 'Frazioni e rapporti';

  @override
  String get familyStudioSectionFractionsRatioSubtitle =>
      'Attività di Matematica in famiglia su questo argomento.';

  @override
  String get familyStudioSectionMentalMathsTitle => 'Calcolo mentale insieme';

  @override
  String get familyStudioSectionMentalMathsSubtitle =>
      'Sfide numeriche veloci in due.';

  @override
  String get familyStudioSectionCubeSpatialTitle => 'Cubi e attività spaziali';

  @override
  String get familyStudioSectionCubeSpatialSubtitle =>
      'Costruire e osservare insieme.';

  @override
  String get familyStudioSectionProgressTitle => 'Panoramica dei progressi';

  @override
  String get familyStudioSectionProgressSubtitle =>
      'Argomenti studiati, punti di forza e aree da ripassare.';

  @override
  String get familyStudioSectionTutorToolsTitle => 'Strumenti per tutor';

  @override
  String get familyStudioSectionTutorToolsSubtitle =>
      'Scegli uno studente, assegna esercizi, aggiungi una nota.';

  @override
  String get familyStudioPinReminderTitle => 'Proteggi Family Studio';

  @override
  String get familyStudioPinReminderBody =>
      'Crea un PIN genitore per proteggere compiti, report e impostazioni dell\'apprendista.';

  @override
  String get familyStudioPinReminderSetPinButton => 'Imposta PIN';

  @override
  String get familyStudioPinReminderLaterButton => 'Ricordamelo più tardi';

  @override
  String get familyStudioTodayStartButton => 'Inizia questa attività';

  @override
  String get familyStudioLearningNoDataYet =>
      'Ancora nessuna sessione di esercizi – qui appariranno gli argomenti recenti.';

  @override
  String get familyStudioLearningTopicSubtitle =>
      'Studiato di recente negli Esercizi.';

  @override
  String get familyStudioConversationAllieMessage =>
      'Un errore può aprire una conversazione utile.';

  @override
  String get familyStudioHomeworkTopicLabel => 'Argomento';

  @override
  String get familyStudioHomeworkTimeLabel => 'Tempo disponibile';

  @override
  String familyStudioHomeworkMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get familyStudioHomeworkHelpTypeLabel => 'Tipo di aiuto necessario';

  @override
  String get familyStudioHomeworkHelpUnderstandMethod => 'Capire il metodo';

  @override
  String get familyStudioHomeworkHelpPractiseTogether => 'Esercitarsi insieme';

  @override
  String get familyStudioHomeworkHelpReviewMistakes => 'Rivedere gli errori';

  @override
  String get familyStudioHomeworkHelpPrepareTomorrow => 'Prepararsi per domani';

  @override
  String get familyStudioHomeworkHelpBuildConfidence => 'Acquisire sicurezza';

  @override
  String get familyStudioHomeworkGenerateButton => 'Crea una sessione';

  @override
  String get familyStudioHomeworkEmptySession =>
      'Ancora nessuna proposta per questa combinazione – prova un altro argomento o un\'altra durata.';

  @override
  String get familyStudioProgressRecentTopics =>
      'Argomenti studiati di recente';

  @override
  String get familyStudioProgressActivitiesCompleted => 'Attività completate';

  @override
  String get familyStudioProgressAreasToRevisit => 'Aree da ripassare';

  @override
  String get familyStudioProgressSuggestedActivity =>
      'Attività in famiglia suggerita';

  @override
  String get familyStudioProgressNoDataYet =>
      'Dati non ancora sufficienti – si completerà man mano che la tua famiglia usa l\'app.';

  @override
  String get familyStudioTutorChooseLearnerLabel => 'Scegli uno studente';

  @override
  String get familyStudioTutorAssignLabel => 'Assegna';

  @override
  String get familyStudioTutorAssignPractice => 'Assegna esercizi';

  @override
  String get familyStudioTutorAssignRecallCards => 'Assegna schede mnemoniche';

  @override
  String familyStudioTutorCompletionLabel(int count) {
    return '$count laboratori interattivi completati finora';
  }

  @override
  String get familyStudioTutorNotesLabel => 'Note';

  @override
  String get familyStudioTutorNotesHint =>
      'Una breve nota per la prossima volta';

  @override
  String get appearanceThemeTitle => 'Aspetto';

  @override
  String get appearanceThemeSub =>
      'Scegli l\'aspetto di Math Intelligence – come il tuo dispositivo, oppure scuro o chiaro.';

  @override
  String get appearanceThemeSystem => 'Sistema';

  @override
  String get appearanceThemeDark => 'Scuro';

  @override
  String get appearanceThemeLight => 'Chiaro';

  @override
  String get appearanceAccessibilityHeading => 'ACCESSIBILITÀ';

  @override
  String get appearanceReadingSizeTitle => 'Dimensione del testo';

  @override
  String get appearanceReadingSizeSub =>
      'Dimensione del testo Piccolo, Predefinito o Grande';

  @override
  String get appearanceTouchTargetsTitle => 'Aree di tocco da 44 px';

  @override
  String get appearanceTouchTargetsSub => 'Comandi ergonomici';

  @override
  String get appearanceTypographyTitle => 'Tipografia chiara';

  @override
  String get appearanceTypographySub => 'Carattere leggibile a ogni dimensione';

  @override
  String get appearanceResetOnboardingHeading => 'REIMPOSTA L\'INTRODUZIONE';

  @override
  String get appearanceResetOnboardingSub =>
      'Reimposta l\'introduzione dell\'app per ripetere la configurazione iniziale.';

  @override
  String get numberSenseLabTitle => 'Laboratorio del senso del numero';

  @override
  String get numberSenseModeGuided => 'Guidato';

  @override
  String get numberSenseModeFreeExplore => 'Esplorazione libera';

  @override
  String get numberSenseExampleEquivalenceTitle =>
      'Formare una frazione equivalente';

  @override
  String get numberSenseExampleEquivalenceTask =>
      'Mostra un mezzo usando parti uguali.';

  @override
  String get numberSenseExamplePlacementTitle => 'Posizionare una frazione';

  @override
  String get numberSenseExamplePlacementTask =>
      'Posiziona tre ottavi sulla retta numerica.';

  @override
  String get numberSenseExampleComparisonTitle => 'Confrontare frazioni';

  @override
  String get numberSenseExampleComparisonTask =>
      'Scegli come si confrontano queste frazioni.';

  @override
  String numberSenseTarget(String fraction) {
    return 'Obiettivo: $fraction';
  }

  @override
  String get numberSenseCompareLessThan => 'Minore di';

  @override
  String get numberSenseCompareEqualTo => 'Uguale a';

  @override
  String get numberSenseCompareGreaterThan => 'Maggiore di';

  @override
  String get numberSenseComplete => 'L\'hai trovato.';

  @override
  String get numberSenseReset => 'Reimposta';

  @override
  String get numberSenseLabDescription =>
      'Costruire, posizionare e confrontare frazioni unitarie.';

  @override
  String get appearanceResetOnboardingButton => 'Reimposta l\'introduzione';

  @override
  String get numberSenseFreeExploreInstruction =>
      'Scegli un modello, poi tocca le parti uguali o tocca/trascina un punto per esplorare le frazioni.';

  @override
  String get numberSenseClearExplore => 'Cancella';

  @override
  String get numberSenseScopeStatement =>
      'Questo modello iniziale tutto-parti supporta solo 2, 3, 4, 6 o 8 parti uguali. I centesimi sono supportati sulla retta di precisione; gli altri denominatori non supportati richiedono una retta di precisione o ingrandita.';

  @override
  String get numberSenseWholePartModel => 'Barra tutto-parti';

  @override
  String get numberSensePrecisionLine => 'Retta di precisione';

  @override
  String get numberSenseExampleHundredthsTitle => 'Trovare un centesimo';

  @override
  String get numberSenseExampleHundredthsTask =>
      'Usa la retta numerica ingrandita per trovare un centesimo. Ogni passo è un centesimo.';

  @override
  String get numberSenseHundredthsExploreInstruction =>
      'Scegli un centesimo da 0.00 a 0.10. Tocca un punto etichettato o trascina lungo la retta.';

  @override
  String get numberSenseHundredthsLineLabel =>
      'Retta numerica ingrandita da 0.00 a 0.10, suddivisa in centesimi';

  @override
  String numberSenseHundredthsSelectionExplanation(
      String fraction, String decimal, int count) {
    return '$fraction significa $decimal: $count parti uguali su 100.';
  }

  @override
  String numberSenseHundredthsIncorrectFeedback(String decimal) {
    return 'Hai scelto $decimal. Un centesimo è la tacca successiva a 0.00: scegli 0.01.';
  }

  @override
  String get numberSenseHundredthsZeroExplanation =>
      'Lo zero è all\'inizio della retta.';

  @override
  String get numberSenseHundredthsZeroGuidedFeedback =>
      '0.00 è zero. Un centesimo è la prima tacca a destra: 0.01.';

  @override
  String numberSenseGuidedWrongAdjacent(
      String selected, String direction, String target) {
    return 'Non proprio. Hai scelto $selected. Spostati di una tacca a $direction per arrivare a $target.';
  }

  @override
  String numberSenseGuidedWrongGeneral(String selected, String target) {
    return 'Non proprio. Hai scelto $selected. L\'obiettivo è $target. Cambia le parti uguali colorate per mostrare la quantità richiesta.';
  }

  @override
  String numberSenseGuidedWrongPartition(String selected, String target) {
    return 'Non proprio. Hai scelto $selected. L\'obiettivo è $target. Scegli parti uguali che possano mostrare la frazione richiesta.';
  }

  @override
  String numberSenseGuidedWrongEquivalenceWhole(
      String selected, String target) {
    return '$selected è un intero, non $target. Colora metà delle parti uguali.';
  }

  @override
  String get numberSenseGuidedDirectionLeft => 'sinistra';

  @override
  String get numberSenseGuidedDirectionRight => 'destra';

  @override
  String get numberSenseEqualPartsLabel => 'Parti uguali';

  @override
  String get numberSenseCompareSharedLineLabel =>
      'Retta numerica comune da zero a uno. Il cerchio indica la frazione di sinistra e il rombo quella di destra.';

  @override
  String get numberSenseCompareLeftMarkerSemantics =>
      'Indicatore sulla retta numerica per due terzi, 2/3';

  @override
  String get numberSenseCompareRightMarkerSemantics =>
      'Indicatore sulla retta numerica per tre quarti, 3/4';

  @override
  String numberSenseComparisonCorrectResultDynamic(
      String leftFraction, String relation, String rightFraction) {
    return 'Corretto: $leftFraction $relation $rightFraction.';
  }

  @override
  String numberSenseComparisonIncorrectResultDynamic(
      String leftFraction, String relationWords, String rightFraction) {
    return 'Non proprio. $leftFraction è $relationWords $rightFraction.';
  }

  @override
  String numberSenseComparisonProofDynamic(
      int leftNumerator,
      int rightDenominator,
      int leftProduct,
      int rightNumerator,
      int leftDenominator,
      int rightProduct,
      String relation,
      String leftFraction,
      String rightFraction) {
    return '$leftNumerator × $rightDenominator = $leftProduct; $rightNumerator × $leftDenominator = $rightProduct; poiché $leftProduct $relation $rightProduct, $leftFraction $relation $rightFraction.';
  }

  @override
  String get numberSenseCompareLessThanWords => 'minore di';

  @override
  String get numberSenseCompareEqualWords => 'uguale a';

  @override
  String get numberSenseCompareGreaterThanWords => 'maggiore di';

  @override
  String numberSenseCompareMarkerExplanation(
      String fraction, String decimal, int numerator, int denominator) {
    return '$fraction = $decimal – $numerator parti uguali su $denominator';
  }

  @override
  String get numberSenseComparisonCorrectLabel => 'Corretto';

  @override
  String get numberSenseComparisonReviewLabel => 'Rivedi il confronto';

  @override
  String numberSenseSkillProgress(int current, int total, String name) {
    return 'Abilità $current di $total: $name';
  }

  @override
  String get numberSenseSkillPlaceFraction => 'Posizionare una frazione';

  @override
  String get numberSenseSkillMakeEquivalent =>
      'Formare una frazione equivalente';

  @override
  String get numberSenseSkillCompareFractions => 'Confrontare frazioni';

  @override
  String get numberSenseSkillFindOneHundredth => 'Trovare un centesimo';

  @override
  String get numberSensePractiseThis => 'Esercitati su questo';

  @override
  String get numberSenseNextSkill => 'Abilità successiva';

  @override
  String get numberSenseChooseSkill => 'Scegli un\'abilità';

  @override
  String get numberSenseChooseComparisonType => 'Scegli un tipo di confronto';

  @override
  String get numberSenseSkillSheetClose => 'Chiudi';

  @override
  String get numberSenseFocusSameDenominator => 'Stesso denominatore';

  @override
  String get numberSenseFocusSameNumerator => 'Stesso numeratore';

  @override
  String get numberSenseFocusEquivalent => 'Frazioni equivalenti';

  @override
  String get numberSenseFocusCompareToHalf => 'Confrontare con un mezzo';

  @override
  String get numberSenseFocusMixed => 'Esercizi misti';

  @override
  String numberSenseComparisonExplanationEquivalent(
      String leftFraction, String rightFraction) {
    return '$leftFraction ha lo stesso valore di $rightFraction. Entrambe si trovano nello stesso punto della retta numerica.';
  }

  @override
  String numberSenseComparisonExplanationSameDenominator(
      String unit,
      int largerCount,
      int smallerCount,
      String leftFraction,
      String relation,
      String rightFraction) {
    return 'Entrambe le frazioni sono in $unit. $largerCount $unit sono più di $smallerCount $unit, quindi $leftFraction $relation $rightFraction.';
  }

  @override
  String numberSenseComparisonExplanationSameNumerator(
      int numerator,
      String largerUnit,
      String smallerUnit,
      String largerFraction,
      String relation,
      String smallerFraction) {
    return 'Entrambe le frazioni mostrano $numerator parti. $largerUnit: parti più grandi dei $smallerUnit, quindi $largerFraction $relation $smallerFraction.';
  }

  @override
  String numberSenseComparisonExplanationBenchmarkHalf(
      String halfEquivalent,
      String otherFraction,
      String unit,
      String direction,
      String leftFraction,
      String relation,
      String rightFraction) {
    return 'Un mezzo è $halfEquivalent. Poiché $otherFraction è un $unit in $direction rispetto a $halfEquivalent, $leftFraction $relation $rightFraction.';
  }

  @override
  String get numberSenseComparisonHalf => 'mezzo';

  @override
  String get numberSenseComparisonThird => 'terzo';

  @override
  String get numberSenseComparisonFourth => 'quarto';

  @override
  String get numberSenseComparisonSixth => 'sesto';

  @override
  String get numberSenseComparisonEighth => 'ottavo';

  @override
  String get numberSenseComparisonHalves => 'mezzi';

  @override
  String get numberSenseComparisonThirds => 'terzi';

  @override
  String get numberSenseComparisonFourths => 'quarti';

  @override
  String get numberSenseComparisonSixths => 'sesti';

  @override
  String get numberSenseComparisonEighths => 'ottavi';

  @override
  String get numberSenseComparisonCapHalves => 'Mezzi';

  @override
  String get numberSenseComparisonCapThirds => 'Terzi';

  @override
  String get numberSenseComparisonCapFourths => 'Quarti';

  @override
  String get numberSenseComparisonCapSixths => 'Sesti';

  @override
  String get numberSenseComparisonCapEighths => 'Ottavi';

  @override
  String get numberSenseComparisonMore => 'più';

  @override
  String get numberSenseComparisonLess => 'meno';

  @override
  String get numberSenseAnotherExample => 'Un altro esempio';

  @override
  String get numberSenseExamplePlacementTaskHalf =>
      'Posiziona un mezzo sulla retta numerica.';

  @override
  String get numberSenseExamplePlacementTaskTwoThirds =>
      'Posiziona due terzi sulla retta numerica.';

  @override
  String numberSenseExampleEquivalenceTaskParts(int count) {
    return 'Mostra un mezzo usando $count parti uguali.';
  }

  @override
  String numberSenseExampleHundredthsTitleCount(int count) {
    return 'Trovare $count centesimi';
  }

  @override
  String numberSenseExampleHundredthsTaskCount(int count) {
    return 'Usa la retta numerica ingrandita per trovare $count centesimi. Ogni passo è un centesimo.';
  }

  @override
  String numberSenseHundredthsTargetEquationDynamic(
      String fraction, String decimal) {
    return '$fraction = $decimal';
  }

  @override
  String numberSenseHundredthsIncorrectFeedbackTarget(
      String decimal, int count, String target) {
    return 'Hai scelto $decimal. Conta $count tacche a destra di 0.00 per arrivare a $target.';
  }

  @override
  String numberSenseHundredthsZeroGuidedFeedbackTarget(
      int count, String target) {
    return '0.00 è zero. Conta $count tacche verso destra per arrivare a $target.';
  }

  @override
  String get pandaPortionsTitle => 'Panda Portions';

  @override
  String get pandaPortionsSubtitle =>
      'Dividi una mela in modo equo e scopri le frazioni.';

  @override
  String get pandaPortionsMenuIntro =>
      'Scegli da dove iniziare. Puoi cambiare lezione in qualsiasi momento.';

  @override
  String get pandaPortionsGuidedPathTitle => 'Percorso guidato';

  @override
  String get pandaPortionsGuidedPathDescription =>
      'Parti uguali, poi metà, poi quarti – un passo alla volta.';

  @override
  String get pandaPortionsPractiseHalvesTitle => 'Esercitarsi con le metà';

  @override
  String get pandaPortionsPractiseHalvesDescription =>
      'Dividi una mela in 2 parti uguali.';

  @override
  String get pandaPortionsPractiseQuartersTitle => 'Esercitarsi con i quarti';

  @override
  String get pandaPortionsPractiseQuartersDescription =>
      'Dividi una mela in 4 parti uguali.';

  @override
  String pandaPortionsGuidedStep(int step, int total) {
    return 'Percorso guidato · passo $step di $total';
  }

  @override
  String get pandaPortionsLessonEqualPartsTitle => 'Parti uguali';

  @override
  String get pandaPortionsLessonEqualPartsPurpose =>
      'Trova la mela divisa in modo equo.';

  @override
  String get pandaPortionsLessonHalvesTitle => 'Metà';

  @override
  String get pandaPortionsLessonHalvesPurpose => 'Dai al panda metà mela.';

  @override
  String get pandaPortionsLessonQuartersTitle => 'Quarti';

  @override
  String get pandaPortionsLessonQuartersPurpose =>
      'Dai al panda un quarto di mela.';

  @override
  String get pandaPortionsPromptEqualParts =>
      'Quale piatto mostra una mela divisa in parti uguali?';

  @override
  String get pandaPortionsPromptHalves => 'Dai una metà al panda.';

  @override
  String get pandaPortionsPromptQuarters => 'Dai un quarto al panda.';

  @override
  String get pandaPortionsTeachEqualParts =>
      'Le frazioni sono parti uguali di un intero.';

  @override
  String get pandaPortionsSuccessEqualParts =>
      'Sì – tutte le parti su questo piatto hanno la stessa grandezza.';

  @override
  String pandaPortionsSuccessFedPart(int parts, String fraction) {
    return 'Hai dato al panda 1 parte uguale su $parts: $fraction.';
  }

  @override
  String pandaPortionsSuccessAte(int parts, String fraction) {
    return 'Il panda ha mangiato 1 parte uguale su $parts. Cioè $fraction.';
  }

  @override
  String pandaPortionsRemainingLeft(String fraction) {
    return 'Resta $fraction della mela.';
  }

  @override
  String get pandaPortionsMisconceptionUnequal =>
      'Queste parti non sono uguali, quindi non sono metà né quarti.';

  @override
  String get pandaPortionsIncorrectSelection =>
      'Riprova. Cerca una parte uguale della mela intera.';

  @override
  String get pandaPortionsHintEqualParts =>
      'In una divisione equa ogni parte ha la stessa grandezza. Confronta le parti su ogni piatto.';

  @override
  String get pandaPortionsHintHalves =>
      'Le metà sono 2 parti uguali. Entrambe le parti di una mela intera hanno la stessa grandezza.';

  @override
  String get pandaPortionsHintQuarters =>
      'I quarti sono 4 parti uguali. Tutte e 4 le parti di una mela intera hanno la stessa grandezza.';

  @override
  String get pandaPortionsRetryEqualParts => 'Prova un altro esempio';

  @override
  String get pandaPortionsRetryHalves => 'Prova un\'altra metà';

  @override
  String get pandaPortionsRetryQuarters => 'Prova un altro quarto';

  @override
  String get pandaPortionsSuggestTryHalves =>
      'Potresti provare le metà la prossima volta.';

  @override
  String get pandaPortionsSuggestTryQuarters =>
      'Potresti provare i quarti la prossima volta.';

  @override
  String get pandaPortionsSuggestNewChallenge => 'Pronto per una nuova sfida?';

  @override
  String get pandaPortionsWhatNext => 'E adesso?';

  @override
  String get pandaPortionsNextLesson => 'Lezione successiva';

  @override
  String get pandaPortionsKeepPractising => 'Continua a esercitarti';

  @override
  String get pandaPortionsChooseLesson => 'Scegli una lezione';

  @override
  String get pandaPortionsResetApple => 'Reimposta la mela';

  @override
  String get pandaPortionsShowHint => 'Mostrami un suggerimento';

  @override
  String get pandaPortionsHideHint => 'Nascondi il suggerimento';

  @override
  String get pandaPortionsWholeApple => '1 mela intera';

  @override
  String pandaPortionsPlateLabel(String plate) {
    return 'Piatto $plate';
  }

  @override
  String pandaPortionsPlateEqualSemantic(String plate, int parts) {
    return 'Piatto $plate: una mela tagliata in $parts parti uguali.';
  }

  @override
  String pandaPortionsPlateUnequalSemantic(String plate, int parts) {
    return 'Piatto $plate: una mela tagliata in $parts parti che non hanno la stessa grandezza.';
  }

  @override
  String pandaPortionsPieceEqualSemantic(
      String plate, int index, int parts, String fraction) {
    return 'Piatto $plate, pezzo $index di $parts. Una parte uguale: $fraction della mela.';
  }

  @override
  String pandaPortionsPieceUnequalSemantic(String plate, int index, int parts) {
    return 'Piatto $plate, pezzo $index di $parts. Non è una parte uguale.';
  }

  @override
  String pandaPortionsPlatePiecesSemantic(String plate, int parts) {
    return 'Piatto $plate: una mela tagliata in $parts pezzi.';
  }

  @override
  String pandaPortionsPlateLargerSmallerSemantic(String plate) {
    return 'Piatto $plate: una mela tagliata in 2 pezzi, uno più grande e uno più piccolo.';
  }

  @override
  String pandaPortionsPlateMixedSizesSemantic(String plate, int parts) {
    return 'Piatto $plate: una mela tagliata in $parts pezzi, alcuni più grandi e altri più piccoli.';
  }

  @override
  String pandaPortionsPieceSemantic(String plate, int index, int parts) {
    return 'Piatto $plate, pezzo $index di $parts.';
  }

  @override
  String get pandaPortionsPiecePicked =>
      'Pezzo scelto. Ora tocca il panda per darglielo.';

  @override
  String get pandaPortionsFeedPanda => 'Dai il pezzo al panda';

  @override
  String get pandaPortionsBowlEmpty => 'La ciotola del panda è vuota.';

  @override
  String pandaPortionsBowlHas(String fraction) {
    return 'Nella ciotola del panda c\'è $fraction della mela.';
  }

  @override
  String pandaPortionsStripLabel(int fed, int parts) {
    return 'Striscia delle frazioni: $fed parti uguali su $parts date al panda.';
  }

  @override
  String get pandaPortionsStripFed => 'dato';

  @override
  String pandaPortionsChoosePlate(String plate) {
    return 'Scegli il piatto $plate';
  }

  @override
  String get labsAppliedMathsStudioTitle => 'Studio di matematica applicata';

  @override
  String get labsAppliedMathsStudioSubtitle =>
      'Esplorazioni interattive di idee matematiche che puoi vedere, muovere e mettere alla prova.';

  @override
  String get labsAppliedMathsStudioIntro =>
      'Scegli un’esplorazione per indagare un’idea matematica attraverso un modello interattivo.';

  @override
  String get labsBinomialVolumeLabTitle => 'Laboratorio del volume binomiale';

  @override
  String get labsBinomialVolumeLabSubtitle =>
      'Separa un cubo per vedere i termini di (a + b)³.';

  @override
  String get labsBinomialVolumeLabKind =>
      'Visualizzazione dello sviluppo binomiale';

  @override
  String get labsBinomialIntro =>
      'Un cubo di lato a + b può essere diviso in volumi più piccoli. Sposta il cursore per separare i pezzi.';

  @override
  String labsBinomialModelSemantic(int percent) {
    return 'Modello di cubo di lato a + b, diviso in otto pezzi. Separato al $percent percento.';
  }

  @override
  String get labsBinomialModelHint =>
      'Usa le frecce sinistra e destra per passare da un pezzo all’altro.';

  @override
  String get labsBinomialExplosionLabel => 'Grado di separazione';

  @override
  String labsBinomialExplosionValue(int percent) {
    return '$percent percento';
  }

  @override
  String get labsBinomialAssemble => 'Ricomponi';

  @override
  String get labsBinomialAssembleSemantic => 'Ricomponi il cubo';

  @override
  String get labsBinomialPullApart => 'Separa';

  @override
  String get labsBinomialPullApartSemantic => 'Separa il cubo';

  @override
  String get labsBinomialResetView => 'Ripristina la vista';

  @override
  String get labsBinomialResetViewSemantic => 'Ripristina la vista del cubo';

  @override
  String get labsBinomialPiecesHeading => 'I pezzi';

  @override
  String get labsBinomialSelectACubed => 'Seleziona il blocco a al cubo';

  @override
  String get labsBinomialSelectASquaredB => 'Seleziona un prisma a quadro b';

  @override
  String get labsBinomialSelectABSquared => 'Seleziona un prisma a b quadro';

  @override
  String get labsBinomialSelectBCubed => 'Seleziona il blocco b al cubo';

  @override
  String get labsBinomialOneCube => 'un cubo';

  @override
  String get labsBinomialThreePrisms => 'tre prismi';

  @override
  String get labsBinomialExplainACubed =>
      'Questo cubo misura a × a × a, quindi il suo volume è a³. C’è un solo cubo come questo.';

  @override
  String get labsBinomialExplainASquaredB =>
      'Questo prisma misura a × a × b, quindi il suo volume è a²b. Ci sono tre prismi come questo.';

  @override
  String get labsBinomialExplainABSquared =>
      'Questo prisma misura a × b × b, quindi il suo volume è ab². Ci sono tre prismi come questo.';

  @override
  String get labsBinomialExplainBCubed =>
      'Questo cubo misura b × b × b, quindi il suo volume è b³. C’è un solo cubo come questo.';

  @override
  String labsBinomialExplainNumeric(int a, int b, int volume) {
    return 'Con a = $a e b = $b, ognuno ha volume $volume.';
  }

  @override
  String get labsBinomialSelectPrompt =>
      'Tocca un pezzo nel modello o scegline uno dall’elenco per vederne il volume.';

  @override
  String get labsBinomialStepsHeading => 'Passi guidati';

  @override
  String get labsBinomialStepsNote =>
      'Scegli qualsiasi passo, nell’ordine che preferisci.';

  @override
  String labsBinomialStepChip(int number) {
    return 'Passo $number';
  }

  @override
  String labsBinomialStepChipSemantic(int number, String title) {
    return 'Passo $number: $title';
  }

  @override
  String get labsBinomialStep1 => 'Trova il cubo a³';

  @override
  String get labsBinomialStep2 => 'Trova i tre prismi a²b';

  @override
  String get labsBinomialStep3 => 'Trova i tre prismi ab²';

  @override
  String get labsBinomialStep4 => 'Trova il cubo b³';

  @override
  String get labsBinomialStep5 => 'Mostra lo sviluppo completo';

  @override
  String get labsBinomialStepFound =>
      'Trovato. Ogni pezzo corrispondente è contornato.';

  @override
  String get labsBinomialStepKeepLooking =>
      'Questo pezzo ha un volume diverso. Continua a cercare quello richiesto da questo passo.';

  @override
  String get labsBinomialNextStep => 'Passo successivo';

  @override
  String get labsBinomialRevealBody =>
      'Ognuno degli otto pezzi è un termine. Raggruppando i pezzi con lo stesso volume si ottiene:';

  @override
  String get labsBinomialDimensionsHeading => 'Lunghezze dei lati';

  @override
  String get labsBinomialSideA => 'Lunghezza a';

  @override
  String get labsBinomialSideB => 'Lunghezza b';

  @override
  String get labsBinomialNumericCheckHeading => 'Verifica numerica';

  @override
  String labsBinomialNumericCheckSpoken(int side, int aCubed, int aSquaredB,
      int aBSquared, int bCubed, int total) {
    return '$side al cubo è uguale a $aCubed più $aSquaredB più $aBSquared più $bCubed, cioè $total.';
  }

  @override
  String get labsBinomialLegendHeading => 'Legenda';

  @override
  String get labsBinomialLegendBody =>
      'Ogni spigolo è diviso in una lunghezza a e una lunghezza b. Ogni pezzo è indicato da un’etichetta e da un motivo, non solo dal colore.';

  @override
  String get labsBinomialCompleteHeading => 'Hai visto tutto lo sviluppo';

  @override
  String get labsBinomialCompleteBody =>
      'Qualunque lunghezza tu scelga, gli otto pezzi riempiono sempre lo stesso cubo di lato a + b.';

  @override
  String get labsBinomialExploreAgain => 'Esplora di nuovo';

  @override
  String get labsBinomialChooseStep => 'Scegli un passo';

  @override
  String get labsBinomialBackToStudio =>
      'Torna allo Studio di matematica applicata';

  @override
  String get labsCreateAngleTitle => 'Crea l\'angolo';

  @override
  String get labsCreateAngleCardSubtitle =>
      'Mira un passaggio o un tiro per creare l\'angolo obiettivo.';

  @override
  String get labsCreateAngleCardKind => 'Esplorazione applicata';

  @override
  String get labsCreateAngleIntro =>
      'Mira il passaggio. Trascina la maniglia rotonda dalla palla finché la linea di mira tratteggiata forma l\'angolo obiettivo con la linea di base continua, poi controlla il tuo angolo.';

  @override
  String get labsCreateAngleLegend =>
      'Linea continua: linea di base · Tratteggio: la tua mira';

  @override
  String get labsCreateAngleTargetsHeading => 'Scegli un angolo obiettivo';

  @override
  String labsCreateAngleDegrees(String angle) {
    return '$angle°';
  }

  @override
  String labsCreateAngleTargetChipSemantic(String target) {
    return 'Angolo obiettivo di $target gradi';
  }

  @override
  String labsCreateAngleTargetChipMatchedSemantic(String target) {
    return 'Angolo obiettivo di $target gradi, creato';
  }

  @override
  String labsCreateAngleTargetReadout(String target) {
    return 'Obiettivo: $target°';
  }

  @override
  String labsCreateAngleCurrentReadout(String angle) {
    return 'Il tuo angolo: $angle°';
  }

  @override
  String labsCreateAngleTargetSemantic(String target) {
    return 'Angolo obiettivo: $target gradi';
  }

  @override
  String labsCreateAngleCurrentSemantic(String angle) {
    return 'Il tuo angolo: $angle gradi';
  }

  @override
  String get labsCreateAnglePitchSemantic =>
      'Campo da calcio. La linea di base continua parte dalla palla verso destra. Trascina la maniglia rotonda o usa i tasti freccia per ruotare la linea tratteggiata.';

  @override
  String labsCreateAnglePitchValue(String angle) {
    return '$angle gradi';
  }

  @override
  String get labsCreateAngleDecrease => 'Riduci l\'angolo';

  @override
  String get labsCreateAngleIncrease => 'Aumenta l\'angolo';

  @override
  String get labsCreateAngleReset => 'Reimposta il campo';

  @override
  String get labsCreateAngleCheck => 'Controlla l\'angolo';

  @override
  String labsCreateAngleToleranceNote(String tolerance) {
    return 'L\'angolo va bene se è entro $tolerance° dall\'obiettivo.';
  }

  @override
  String get labsCreateAngleKeyboardHint =>
      'Non serve trascinare: usa i pulsanti, oppure seleziona il campo e premi le frecce sinistra e destra per ruotare di un grado alla volta.';

  @override
  String labsCreateAngleMatched(String target, String attempted) {
    return 'Hai creato un angolo di $target°. La tua mira era $attempted°, quindi la linea si è allineata esattamente a $target°.';
  }

  @override
  String labsCreateAngleTurnWider(
      String attempted, String difference, String target) {
    return 'Il tuo angolo è $attempted°. Apri la linea di mira di altri $difference° per arrivare a $target°.';
  }

  @override
  String labsCreateAngleTurnNarrower(
      String attempted, String difference, String target) {
    return 'Il tuo angolo è $attempted°. Chiudi la linea di mira di $difference° per arrivare a $target°.';
  }

  @override
  String get labsCreateAngleExplain30 =>
      '30° è un angolo stretto: un terzo di un angolo retto.';

  @override
  String get labsCreateAngleExplain45 =>
      '45° è esattamente metà di un angolo retto: il passaggio in diagonale.';

  @override
  String get labsCreateAngleExplain60 =>
      '60° sono due terzi di un angolo retto, una rotazione più ampia di 45°.';

  @override
  String get labsCreateAngleExplain90 =>
      '90° è un angolo retto: un quarto di giro, perpendicolare alla linea di base.';

  @override
  String labsCreateAngleNextTarget(String target) {
    return 'Prova $target° adesso';
  }

  @override
  String labsCreateAngleProgress(int count, int total) {
    return '$count angoli obiettivo su $total creati in questa visita';
  }

  @override
  String get labsCreateAngleCompleteTitle =>
      'Tutti e quattro gli angoli creati';

  @override
  String get labsCreateAngleCompleteBody =>
      'In questa visita hai creato 30°, 45°, 60° e 90°. Esplora di nuovo, scegli un obiettivo da rivedere o torna allo Studio di matematica applicata.';

  @override
  String get labsCreateAngleExploreAgain => 'Esplora di nuovo';

  @override
  String get labsCreateAngleBackToStudio =>
      'Torna allo Studio di matematica applicata';

  @override
  String get labsCreateAngleSessionNote =>
      'Esplorazione facoltativa. Non viene salvato nulla: uscendo da questa schermata la visita si azzera.';

  @override
  String get labsPitchCoordinatesTitle => 'Coordinate sul campo';

  @override
  String get labsPitchCoordinatesCardSubtitle =>
      'Trova e sposta i giocatori usando le coordinate su una griglia.';

  @override
  String get labsPitchCoordinatesCardKind => 'Esplorazione applicata';

  @override
  String get labsPitchCoordinatesIntro =>
      'Ogni giocatore sta dove si incrociano due linee della griglia. Il primo numero dice quanti passi a destra o a sinistra dall\'origine. Il secondo dice quanti passi in su o in giù.';

  @override
  String get labsPitchCoordinatesChooseStart =>
      'Da dove deve partire la griglia?';

  @override
  String get labsPitchCoordinatesCornerStart => 'Partenza dal corner';

  @override
  String get labsPitchCoordinatesCornerStartHint =>
      'L\'origine è la bandierina del corner. I numeri vanno a destra e in su.';

  @override
  String get labsPitchCoordinatesCentreStart => 'Partenza dal centro';

  @override
  String get labsPitchCoordinatesCentreStartHint =>
      'L\'origine è il centro del campo. I numeri vanno a destra, a sinistra, in su e in giù.';

  @override
  String get labsPitchCoordinatesPromptRead =>
      'Dove si trova questo giocatore? Inserisci le sue coordinate.';

  @override
  String labsPitchCoordinatesPromptPlace(int x, int y) {
    return 'Metti il giocatore in ($x, $y).';
  }

  @override
  String labsPitchCoordinatesPromptTranslate(String move) {
    return 'Sposta il giocatore: $move. Dove arriva?';
  }

  @override
  String get labsPitchCoordinatesPromptInverse =>
      'Quale spostamento porta il giocatore dalla partenza all\'arrivo?';

  @override
  String labsPitchCoordinatesPromptTransfer(String move) {
    return 'Solo griglia. Sposta il giocatore: $move. Dove arriva?';
  }

  @override
  String labsPitchCoordinatesMoveBoth(String h, String v) {
    return '$h e $v';
  }

  @override
  String labsPitchCoordinatesStepsRight(int n) {
    return '$n a destra';
  }

  @override
  String labsPitchCoordinatesStepsLeft(int n) {
    return '$n a sinistra';
  }

  @override
  String labsPitchCoordinatesStepsUp(int n) {
    return '$n in su';
  }

  @override
  String labsPitchCoordinatesStepsDown(int n) {
    return '$n in giù';
  }

  @override
  String get labsPitchCoordinatesNoHorizontal =>
      'nessun passo a destra o a sinistra';

  @override
  String get labsPitchCoordinatesNoVertical => 'nessun passo in su o in giù';

  @override
  String labsPitchCoordinatesSelectedWords(String h, String v) {
    return 'Selezione: $h, $v.';
  }

  @override
  String get labsPitchCoordinatesFirstNumber => 'Primo numero';

  @override
  String get labsPitchCoordinatesSecondNumber => 'Secondo numero';

  @override
  String labsPitchCoordinatesYourPair(int x, int y) {
    return 'Le tue coordinate: ($x, $y)';
  }

  @override
  String get labsPitchCoordinatesExploreGrid => 'Esplora la griglia';

  @override
  String get labsPitchCoordinatesStepperIncrease => 'Aumenta';

  @override
  String get labsPitchCoordinatesStepperDecrease => 'Diminuisci';

  @override
  String get labsPitchCoordinatesConfirmSpot => 'Conferma questa posizione';

  @override
  String get labsPitchCoordinatesConfirmNumbers => 'Conferma questi numeri';

  @override
  String get labsPitchCoordinatesConfirmMove => 'Conferma questo spostamento';

  @override
  String get labsPitchCoordinatesMoveRight => 'Un passo a destra';

  @override
  String get labsPitchCoordinatesMoveLeft => 'Un passo a sinistra';

  @override
  String get labsPitchCoordinatesMoveUp => 'Un passo in su';

  @override
  String get labsPitchCoordinatesMoveDown => 'Un passo in giù';

  @override
  String get labsPitchCoordinatesEdgeRight => 'Nessun altro passo a destra';

  @override
  String get labsPitchCoordinatesEdgeLeft => 'Nessun altro passo a sinistra';

  @override
  String get labsPitchCoordinatesEdgeUp => 'Nessun altro passo in su';

  @override
  String get labsPitchCoordinatesEdgeDown => 'Nessun altro passo in giù';

  @override
  String get labsPitchCoordinatesPickHorizontal => 'Destra o sinistra';

  @override
  String get labsPitchCoordinatesPickVertical => 'Su o giù';

  @override
  String get labsPitchCoordinatesOptRight => 'Destra';

  @override
  String get labsPitchCoordinatesOptLeft => 'Sinistra';

  @override
  String get labsPitchCoordinatesOptUp => 'Su';

  @override
  String get labsPitchCoordinatesOptDown => 'Giù';

  @override
  String get labsPitchCoordinatesOptNone => 'Nessuno spostamento';

  @override
  String get labsPitchCoordinatesSteps => 'Passi';

  @override
  String get labsPitchCoordinatesPlayerUnanswered => 'Giocatore';

  @override
  String labsPitchCoordinatesPlayerAnswered(String h, String v, int x, int y) {
    return 'Giocatore a $h, $v: coordinate $x, $y';
  }

  @override
  String labsPitchCoordinatesStartMarker(String h, String v) {
    return 'Partenza: $h, $v';
  }

  @override
  String labsPitchCoordinatesFinishMarker(String h, String v) {
    return 'Arrivo: $h, $v';
  }

  @override
  String get labsPitchCoordinatesSameColumn => 'Stessa colonna del giocatore';

  @override
  String get labsPitchCoordinatesSameRow => 'Stessa riga del giocatore';

  @override
  String get labsPitchCoordinatesOnPlayer => 'Sul giocatore';

  @override
  String labsPitchCoordinatesAxisHorizontal(int lo, int hi) {
    return 'Retta dei numeri orizzontale, da $lo a $hi';
  }

  @override
  String labsPitchCoordinatesAxisVertical(int lo, int hi) {
    return 'Retta dei numeri verticale, da $lo a $hi';
  }

  @override
  String get labsPitchCoordinatesCorrect => 'Sì, è corretto.';

  @override
  String get labsPitchCoordinatesFbGeneric =>
      'Non ancora. Guarda il primo numero per destra o sinistra, poi il secondo per su o giù.';

  @override
  String get labsPitchCoordinatesFbOrderSwapped =>
      'I numeri sono scambiati. Il primo numero è destra o sinistra; il secondo è su o giù.';

  @override
  String get labsPitchCoordinatesFbOriginCounted =>
      'L\'origine conta come 0. Conta ogni passo lungo le linee a partire da lì.';

  @override
  String get labsPitchCoordinatesFbStartNotMoved =>
      'Lì è dove il giocatore è partito. Ora fai lo spostamento.';

  @override
  String get labsPitchCoordinatesFbHorizontalOnly =>
      'Hai fatto lo spostamento a destra o a sinistra. Ora fai anche quello in su o in giù.';

  @override
  String get labsPitchCoordinatesFbVerticalOnly =>
      'Hai fatto lo spostamento in su o in giù. Ora fai anche quello a destra o a sinistra.';

  @override
  String get labsPitchCoordinatesFbBothReversed =>
      'Entrambi gli spostamenti sono andati nel verso opposto. Destra e su rendono i numeri più grandi; sinistra e giù li rendono più piccoli.';

  @override
  String get labsPitchCoordinatesFbHorizontalReversed =>
      'Controlla lo spostamento a destra o a sinistra: destra rende più grande il primo numero, sinistra lo rende più piccolo.';

  @override
  String get labsPitchCoordinatesFbVerticalReversed =>
      'Controlla lo spostamento in su o in giù: su rende più grande il secondo numero, giù lo rende più piccolo.';

  @override
  String get labsPitchCoordinatesFbMovesSwapped =>
      'I due spostamenti sono stati scambiati. Lo spostamento a destra o a sinistra cambia il primo numero.';

  @override
  String get labsPitchCoordinatesFbGaveMove =>
      'Questo è lo spostamento. Dove arriva il giocatore?';

  @override
  String get labsPitchCoordinatesFbGaveFinish =>
      'Lì è dove arriva il giocatore. Quale spostamento lo porta lì?';

  @override
  String get labsPitchCoordinatesFbGaveStart =>
      'Lì è dove il giocatore è partito. Quale spostamento lo porta all\'arrivo?';

  @override
  String get labsPitchCoordinatesFbMoveReversed =>
      'Questo spostamento va dall\'arrivo alla partenza. Vai dalla partenza all\'arrivo.';

  @override
  String get labsPitchCoordinatesTryAgain => 'Riprova';

  @override
  String get labsPitchCoordinatesShowMe => 'Mostramelo';

  @override
  String get labsPitchCoordinatesNext => 'Avanti';

  @override
  String get labsPitchCoordinatesExploreAgain => 'Esplora di nuovo';

  @override
  String get labsFractionsOfASetTitle => 'Frazioni di un insieme';

  @override
  String get labsFractionsOfASetCardSubtitle =>
      'Dividi una raccolta in gruppi uguali per trovarne una frazione.';

  @override
  String get labsFractionsOfASetCardKind => 'Modello numerico';

  @override
  String get labsFractionsOfASetIntro =>
      'Il numero in basso dice quanti gruppi uguali formare. Il numero in alto dice quanti gruppi prendere.';

  @override
  String labsFractionsOfASetPromptFind(int total, String fraction) {
    return 'Quanto fa $fraction di questi $total gettoni?';
  }

  @override
  String labsFractionsOfASetPromptTransfer(int total, String fraction) {
    return '$fraction di $total = ?';
  }

  @override
  String labsFractionsOfASetPromptWhat(int total, int chosen) {
    return '$chosen di questi $total gettoni sono scelti. Che frazione della raccolta è?';
  }

  @override
  String labsFractionsOfASetPromptCompare(
      int total, String fractionA, String fractionB) {
    return 'Che cosa è di più: $fractionA di $total o $fractionB di $total?';
  }

  @override
  String labsFractionsOfASetPromptEqual(int groups) {
    return 'È una divisione equa in $groups gruppi uguali?';
  }

  @override
  String get labsFractionsOfASetPrediction => 'La tua risposta';

  @override
  String get labsFractionsOfASetConfirmAnswer => 'Conferma la mia risposta';

  @override
  String labsFractionsOfASetStepGroup(int groups) {
    return 'Forma $groups gruppi uguali. Tocca un vassoio per metterci un gettone.';
  }

  @override
  String get labsFractionsOfASetDeal => 'Uno in ogni vassoio';

  @override
  String labsFractionsOfASetTakeOneOutOfTray(int index) {
    return 'Togline uno dal vassoio $index';
  }

  @override
  String get labsFractionsOfASetStartAgain => 'Ricomincia';

  @override
  String labsFractionsOfASetLeftToPlace(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ancora $count gettoni da sistemare',
      one: 'Ancora 1 gettone da sistemare',
      zero: 'Tutti i gettoni sono sistemati.',
    );
    return '$_temp0';
  }

  @override
  String get labsFractionsOfASetGroupsReady => 'Questi gruppi sono pronti';

  @override
  String labsFractionsOfASetStepTake(int groups, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gruppi',
      one: '1 gruppo',
    );
    return 'Prendi $_temp0 su $groups. Tocca i vassoi che vuoi.';
  }

  @override
  String get labsFractionsOfASetTakeConfirm => 'Prendi questi gruppi';

  @override
  String labsFractionsOfASetTakeCount(int chosen, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Prendi $n vassoi.',
      one: 'Prendi 1 vassoio.',
    );
    return '$_temp0 Ne hai scelti $chosen.';
  }

  @override
  String labsFractionsOfASetTray(int groups, int count, int index) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gettoni',
      one: '1 gettone',
      zero: 'vuoto',
    );
    return 'Vassoio $index di $groups: $_temp0';
  }

  @override
  String get labsFractionsOfASetChosen => 'scelto';

  @override
  String get labsFractionsOfASetDifferent => 'diverso';

  @override
  String labsFractionsOfASetCollection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Raccolta: ancora $count gettoni da sistemare',
      one: 'Raccolta: ancora 1 gettone da sistemare',
      zero: 'Raccolta: vuota',
    );
    return '$_temp0';
  }

  @override
  String get labsFractionsOfASetTopNumber => 'Numero in alto';

  @override
  String labsFractionsOfASetOutOfGroups(int groups) {
    return 'su $groups gruppi uguali';
  }

  @override
  String get labsFractionsOfASetSame => 'Sono uguali';

  @override
  String get labsFractionsOfASetYes => 'Sì, è equa';

  @override
  String get labsFractionsOfASetNo => 'No, non è equa';

  @override
  String labsFractionsOfASetRevealFind(int total, int answer, String fraction) {
    return '$fraction di $total è $answer.';
  }

  @override
  String labsFractionsOfASetRevealSteps(
      int total, int groups, int n, int size, int answer) {
    return '$total ÷ $groups = $size, poi $n × $size = $answer';
  }

  @override
  String labsFractionsOfASetRevealWhat(
      int total, int chosen, int groups, int n, String fraction) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gruppi uguali',
      one: '1 gruppo uguale',
    );
    return '$chosen su $total è $fraction: $_temp0 su $groups.';
  }

  @override
  String labsFractionsOfASetRevealCompare(
      int total, int valueA, int valueB, String fractionA, String fractionB) {
    return '$fractionA di $total è $valueA; $fractionB di $total è $valueB.';
  }

  @override
  String labsFractionsOfASetRevealEqual(int groups, int size) {
    return '$groups vassoi con $size in ciascuno.';
  }

  @override
  String get labsFractionsOfASetCorrect => 'Sì, è corretto.';

  @override
  String labsFractionsOfASetFbDivNum(int groups, int n) {
    return 'Il numero in basso, $groups, dice quanti gruppi uguali formare. Il numero in alto, $n, dice quanti di quei gruppi prendere.';
  }

  @override
  String get labsFractionsOfASetFbTookN =>
      'La frazione è di tutta la raccolta: prendi gruppi interi, non singoli gettoni.';

  @override
  String labsFractionsOfASetFbOneGroup(int n) {
    return 'Questo è un solo gruppo. Il numero in alto dice di prendere $n gruppi: contali tutti.';
  }

  @override
  String labsFractionsOfASetFbOtherGroups(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n',
      one: 'uno',
    );
    return 'Così conti i gruppi che non hai preso. Conta solo i gruppi che chiede il numero in alto: $_temp0.';
  }

  @override
  String get labsFractionsOfASetFbWhole =>
      'Questa è tutta la raccolta. La frazione ne è solo una parte.';

  @override
  String labsFractionsOfASetFbFindGeneric(int groups, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n di essi',
      one: 'uno di essi',
    );
    return 'Forma $groups gruppi uguali, poi conta i gettoni in $_temp0.';
  }

  @override
  String get labsFractionsOfASetFbObjectCount =>
      'Questo è il numero di gettoni scelti. Il numero in alto conta i gruppi, non i gettoni.';

  @override
  String get labsFractionsOfASetFbGroupSize =>
      'Questo è quanti gettoni ci sono in un gruppo. Il numero in alto conta i gruppi scelti.';

  @override
  String get labsFractionsOfASetFbNotChosen =>
      'Così conti i gruppi che non sono scelti.';

  @override
  String labsFractionsOfASetFbWhatWhole(int groups) {
    return 'Sarebbero tutti i gruppi ($groups su $groups): l\'intera raccolta.';
  }

  @override
  String labsFractionsOfASetFbWhatGeneric(int groups) {
    return 'Dividi i gettoni in $groups gruppi uguali, poi conta i gruppi scelti.';
  }

  @override
  String labsFractionsOfASetFbBiggerDenominator(
      int total, String fractionA, String fractionB) {
    return 'Più gruppi uguali significa che ogni gruppo è più piccolo. Quindi $fractionB di $total è meno di $fractionA di $total.';
  }

  @override
  String get labsFractionsOfASetFbSame =>
      'Numeri diversi di gruppi uguali danno gruppi di grandezza diversa: quindi non sono uguali.';

  @override
  String get labsFractionsOfASetFbUnequalTrays =>
      'Alcuni vassoi hanno un numero diverso di gettoni: i gruppi non sono uguali. I vassoi diversi sono contornati. «Uno in ogni vassoio» divide in modo equo.';

  @override
  String get labsFractionsOfASetFbUnequalAccepted =>
      'Guarda di nuovo: due vassoi hanno un numero diverso. Sono contornati. I gruppi uguali hanno tutti la stessa grandezza.';

  @override
  String labsFractionsOfASetFbEqualRejected(int size) {
    return 'Ogni vassoio ha $size gettoni: quindi questi gruppi sono uguali.';
  }

  @override
  String get labsFractionsOfASetNext => 'Avanti';

  @override
  String get labsFractionsOfASetExploreAgain => 'Esplora di nuovo';

  @override
  String get labsFractionsOfASetBack => 'Indietro';

  @override
  String get labsFractionsOfASetStepperIncrease => 'Aumenta';

  @override
  String get labsFractionsOfASetStepperDecrease => 'Diminuisci';

  @override
  String labsFractionsOfASetHalves(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mezzi',
      one: 'un mezzo',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetThirds(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n terzi',
      one: 'un terzo',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetQuarters(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n quarti',
      one: 'un quarto',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetFifths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n quinti',
      one: 'un quinto',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetSixths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sesti',
      one: 'un sesto',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetEighths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ottavi',
      one: 'un ottavo',
    );
    return '$_temp0';
  }

  @override
  String labsFractionsOfASetTenths(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n decimi',
      one: 'un decimo',
    );
    return '$_temp0';
  }

  @override
  String get earlyMathsEntryIntro =>
      'Scegli un punto di partenza adatto. L\'età è solo un suggerimento, non un livello. Non c\'è nessun test e puoi cambiare in qualsiasi momento.';

  @override
  String get earlyMathsLaneChooserLabel => 'Scegli un punto di partenza';

  @override
  String get earlyMathsLanePlayTitle => 'Scoprire la matematica giocando';

  @override
  String get earlyMathsLanePlayAges => 'Età tipica: 4–5 anni';

  @override
  String get earlyMathsLaneKs1Title =>
      'Basi di matematica KS1 (programma dell\'Inghilterra)';

  @override
  String get earlyMathsLaneKs1Ages =>
      'Età tipica: 5–7 anni · Year 1–2 (Inghilterra)';

  @override
  String get earlyMathsLaneNotSureTitle => 'Non lo so ancora';

  @override
  String get earlyMathsLaneNotSureSubtitle =>
      'Nessun test necessario. Ti suggeriremo un primo passo tranquillo.';

  @override
  String get earlyMathsLaneSwitchNote =>
      'Cambiare non cancella mai ciò che tuo figlio ha già fatto.';

  @override
  String get earlyMathsActivitiesHeading => 'Attività da provare';

  @override
  String get earlyMathsNotSureHeading => 'Un primo passo tranquillo';

  @override
  String get earlyMathsNotSureBody =>
      'Non esiste una scelta giusta o sbagliata. Prova questa piccola attività e vedi come va. Puoi scegliere un altro punto di partenza qui sopra quando vuoi.';

  @override
  String get earlyMathsPandaScope =>
      'Conta da 1 a 3 mele su 5, poi di\' quante ne restano.';

  @override
  String get earlyMathsAbacusTitle => 'Abaco';

  @override
  String get earlyMathsAbacusScope =>
      'Uno strumento interattivo sul valore posizionale: tocca o trascina le perline per esplorare centinaia, decine e unità.';

  @override
  String get earlyMathsParentHeading => 'Per gli adulti';

  @override
  String get earlyMathsParentCardTitle => 'Attività guidate dai genitori';

  @override
  String get earlyMathsParentCardSubtitle =>
      'Brevi attività da fare insieme. Si apre con il tuo PIN genitore.';

  @override
  String earlyMathsParentTitlesLine(String titles) {
    return 'Include: $titles';
  }

  @override
  String get accessibilitySettingsSubtitle =>
      'Regola per maggiore comfort e leggibilità';

  @override
  String get accessibilityReadingSizeSubtitle =>
      'Scegli una dimensione del testo comoda';

  @override
  String get accessibilityReadingSizeSmall => 'Piccolo';

  @override
  String get accessibilityReadingSizeDefault => 'Predefinito';

  @override
  String get accessibilityReadingSizeLarge => 'Grande';

  @override
  String get accessibilityReduceMotionTitle => 'Riduci movimento';

  @override
  String get accessibilityReduceMotionSubtitle =>
      'Riduci al minimo animazioni e transizioni';

  @override
  String get accessibilityQuietStudyModeSubtitle =>
      'Ispirata a Nyepi, una tradizione balinese di riflessione, quiete e concentrazione — riduce Captain Math e i segnali sonori';

  @override
  String get accessibilitySoundCuesTitle => 'Segnali sonori';

  @override
  String get accessibilitySoundCuesSubtitle =>
      'Suoni brevi e facoltativi per le azioni nei laboratori interattivi';

  @override
  String onboardingTimeEstimateSeconds(int seconds) {
    return '~$seconds secondi';
  }
}
