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
      'Calm, playful counting activities for younger learners';

  @override
  String get earlyMathsPlaygroundIntro =>
      'A calm, untimed space for younger learners to practise counting — no scores, no timers, no pressure.';

  @override
  String get feedTheHungryPandaTitle => 'Feed the Hungry Panda';

  @override
  String get feedTheHungryPandaSubtitle =>
      'Count out apples one at a time to feed Panda';

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
      'Cartes memo pour parents';

  @override
  String get familyStudioSectionParentRecallCardsSubtitle =>
      'Des astuces chaleureuses et pratiques — pas des questions d\'examen.';

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
  String get familyStudioPinReminderTitle => 'Protéger Family Studio';

  @override
  String get familyStudioPinReminderBody =>
      'Créez un code PIN parent pour protéger les devoirs, les rapports et les paramètres de l\'apprenant.';

  @override
  String get familyStudioPinReminderSetPinButton => 'Définir le code PIN';

  @override
  String get familyStudioPinReminderLaterButton => 'Me le rappeler plus tard';

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
  String get appearanceResetOnboardingButton => 'Reset Onboarding';
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
  String get practiceExamEntranceExamPrep => 'Preparation examen d\'entree';

  @override
  String get entranceExamHubTitle => 'Preparation a l\'examen d\'entree';

  @override
  String get entranceExamHubIntro =>
      'Entrainement aux examens d\'entree des ecoles independantes, distinct du simulateur d\'examen GCSE — concu pour la tranche d\'age 11+ et evalue en comparant ta propre demarche a une solution modele, pas par choix multiple.';

  @override
  String get entranceExamDisclaimerHeading =>
      'Aucune affiliation avec une ecole ou un office d\'examen';

  @override
  String get entranceExamAgeBandLabel => 'Tranche d\'age';

  @override
  String get entranceExamDurationLabel => 'Duree';

  @override
  String get entranceExamCalculatorLabel => 'Calculatrice';

  @override
  String get entranceExamCalculatorNone => 'Non autorisee';

  @override
  String get entranceExamCalculatorAllowed => 'Autorisee';

  @override
  String get entranceExamCalculatorAllowedNonScientific =>
      'Autorisee (non scientifique)';

  @override
  String entranceExamDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get entranceExamModePracticeBySkillTitle =>
      'Entrainement par competence';

  @override
  String get entranceExamModePracticeBySkillSub =>
      'Travaille des questions regroupees par competence, avec des demarches types pour te comparer.';

  @override
  String get entranceExamModeReviewMethodsTitle => 'Revoir les methodes';

  @override
  String get entranceExamModeReviewMethodsSub =>
      'Revois la demarche complete de chaque question disponible — sans chronometre, sans notation.';

  @override
  String get entranceExamModeUntimedPaperTitle => 'Epreuve sans chronometre';

  @override
  String get entranceExamModeUntimedPaperSub =>
      'Passe l\'epreuve complete sans limite de temps.';

  @override
  String get entranceExamModeTimedMockTitle => 'Examen blanc chronometre';

  @override
  String get entranceExamModeTimedMockSub =>
      'Passe l\'epreuve complete dans les conditions reelles de l\'examen, chronometree.';

  @override
  String get entranceExamModeScholarshipChallengeTitle =>
      'Defi bourse d\'etudes';

  @override
  String get entranceExamModeScholarshipChallengeSub =>
      'Une epreuve plus exigeante pour les candidats de niveau bourse d\'etudes.';

  @override
  String entranceExamModeLockedFullPaperReason(int declared, int authored) {
    return 'Se debloque une fois l\'epreuve complete de $declared questions prete — $authored redigees pour l\'instant.';
  }

  @override
  String get entranceExamModeLockedScholarshipReason =>
      'Ce pack est de niveau Fondamental — le Defi bourse d\'etudes necessite un pack de niveau bourse d\'etudes.';

  @override
  String get entranceExamModeLockedBadge => 'Bientot disponible';

  @override
  String get entranceExamSkillPickerTitle => 'Choisis une competence';

  @override
  String entranceExamSkillQuestionCountLabel(int count) {
    return '$count questions disponibles';
  }

  @override
  String get entranceExamSkillNumberFluency => 'Aisance avec les nombres';

  @override
  String get entranceExamSkillFractionsAndPercentages =>
      'Fractions et pourcentages';

  @override
  String get entranceExamSkillRatioAndProportion => 'Rapports et proportions';

  @override
  String get entranceExamSkillAlgebraicReasoning => 'Raisonnement algebrique';

  @override
  String get entranceExamSkillShapeAndSpace => 'Formes et espace';

  @override
  String get entranceExamSkillDataAndLogic => 'Donnees et logique';

  @override
  String entranceExamQuestionOf(int current, int total) {
    return 'Question $current sur $total';
  }

  @override
  String get entranceExamRevealMethodButton => 'Afficher la demarche';

  @override
  String get entranceExamMethodMarkPrompt =>
      'Compare cela a ta propre demarche. Qu\'est-ce qui correspond le mieux a ce que tu as ecrit ?';

  @override
  String get entranceExamMethodMarkCorrect =>
      'Correct — demarche complete montree';

  @override
  String get entranceExamMethodMarkSlip =>
      'Demarche correcte, une erreur d\'etourderie';

  @override
  String get entranceExamMethodMarkPartial => 'Raisonnement partiel';

  @override
  String get entranceExamMethodMarkUnsupported =>
      'Reponse seule, sans demarche';

  @override
  String get entranceExamMethodMarkBlank => 'Je n\'ai pas essaye';

  @override
  String get entranceExamNextQuestionButton => 'Question suivante';

  @override
  String get entranceExamSessionCompleteTitle => 'Entrainement termine';

  @override
  String entranceExamSessionEstimatedMarks(String marks, int total) {
    return 'Points estimes : $marks / $total';
  }

  @override
  String get entranceExamSessionEstimatedMarksNote =>
      'Une estimation basee sur ta propre auto-evaluation, pas un bareme officiel — voir les indications sous chaque question.';

  @override
  String get entranceExamReviewTitle => 'Revoir les methodes';

  @override
  String get entranceExamNoHandwritingNote =>
      'Cette application ne lit ni ne note jamais ta demarche manuscrite — c\'est toi qui la compares a la demarche affichee.';

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
  String get mathStudioMathMagicNumberTricksLabel => 'Tours de nombres visuels';

  @override
  String get mathStudioMathMagicNumberTricksSubtitle =>
      'Suis un tour de nombres, etape par etape';

  @override
  String get mathStudioMathMagicPatternsLabel => 'Motifs';

  @override
  String get mathStudioMathMagicPatternsSubtitle =>
      'Fais grandir un motif de points et decouvre la regle qui se cache derriere';

  @override
  String get mathStudioMathMagicMagicSquaresLabel => 'Carres magiques';

  @override
  String get mathStudioMathMagicMagicSquaresSubtitle =>
      'Place les nombres pour que chaque ligne fasse le meme total';

  @override
  String get mathStudioMathMagicParityLabel => 'Parite';

  @override
  String get mathStudioMathMagicParitySubtitle =>
      'Explore ce qui se passe quand on additionne des nombres pairs et impairs';

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
  String get mathStudioSpatialCubeNetsLabel => 'Patrons de cube';

  @override
  String get mathStudioSpatialCubeNetsSubtitle =>
      'Determine quels patrons se replient en un cube ferme';

  @override
  String get mathStudioSpatialRotationsSubtitle =>
      'Fais tourner une forme autour d\'un point fixe et observe ce qui change';

  @override
  String get mathStudioSpatialTransformationsSubtitle =>
      'Translation, reflexion, rotation et agrandissement sur un quadrillage';

  @override
  String get mathStudioSpatialPuzzlesSubtitle =>
      'Courtes enigmes sur les formes, l\'espace et la pensee en 3D';

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
  String get mathStudioCategoryArchitectureConstruction =>
      'Architecture et construction';

  @override
  String get mathStudioCategoryEnvironmentClimate => 'Environnement et climat';

  @override
  String get mathStudioCategoryComputingCryptography =>
      'Informatique et cryptographie';

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
  String get recallCardsTopicFilterGroupLabel => 'Sujet';

  @override
  String get recallCardsTypeFilterGroupLabel => 'Type de carte';

  @override
  String get recallCardsMoreChipLabel => 'Plus';

  @override
  String get recallCardsMoreTopicsSheetTitle => 'Plus de sujets';

  @override
  String get recallCardsMoreTypesSheetTitle => 'Plus de types de cartes';

  @override
  String get recallCardsClearFiltersButton => 'Effacer les filtres';

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
  String get labsSpatialCubeLabTitle => 'Laboratoire du cube spatial';

  @override
  String get labsSpatialCubeLabSubtitle =>
      'Fais pivoter, deplie et explore un cube etiquete';

  @override
  String get labsSpatialCubeLabIntro =>
      'Fais glisser le cube pour le tourner. Remarque que les faces restent a la meme place les unes par rapport aux autres, quel que soit le sens de rotation.';

  @override
  String get labsSpatialCubeLabFreePlayCaption =>
      'Essaie: fais glisser le cube, ou utilise les boutons ci-dessous.';

  @override
  String get labsSpatialCubeWhichFaceOppositeTitle =>
      'Quelle face est opposee?';

  @override
  String get labsSpatialCubeWhichFaceOppositeSubtitle =>
      'Predis la face opposee, puis verifie en tournant le cube';

  @override
  String get labsSpatialCubeRotateToMatchTitle =>
      'Tourner pour faire correspondre';

  @override
  String get labsSpatialCubeRotateToMatchSubtitle =>
      'Tourne ton cube pour qu\'il corresponde a l\'orientation cible';

  @override
  String get labsSpatialCubeHiddenFaceTitle => 'Face cachee';

  @override
  String get labsSpatialCubeHiddenFaceSubtitle =>
      'Trouve quelle etiquette se trouve sur une face que tu ne vois pas';

  @override
  String get labsSpatialCubeNetExplorerTitle =>
      'Explorateur de patrons de cube';

  @override
  String get labsSpatialCubeNetExplorerSubtitle =>
      'Predis les faces opposees sur un patron a plat, puis plie-le';

  @override
  String get labsEarlyMathsPlaygroundTitle =>
      'Aire de jeu de maths pour les tout-petits';

  @override
  String get labsEarlyMathsPlaygroundSubtitle =>
      'Activites de comptage calmes et ludiques pour les jeunes apprenants';

  @override
  String get earlyMathsPlaygroundIntro =>
      'Un espace calme et sans limite de temps ou les jeunes apprenants peuvent s\'exercer a compter — sans points, sans chronometre, sans pression.';

  @override
  String get feedTheHungryPandaTitle => 'Nourris le panda affame';

  @override
  String get feedTheHungryPandaSubtitle =>
      'Compte les pommes une par une pour nourrir le panda';

  @override
  String feedPandaInstruction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pommes',
      one: '1 pomme',
    );
    return 'Donne au panda $_temp0.';
  }

  @override
  String feedPandaWellDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pommes',
      one: '1 pomme',
    );
    return 'Bravo ! Le panda a mange $_temp0.';
  }

  @override
  String get feedPandaHowManyLeft => 'Combien de pommes reste-t-il ?';

  @override
  String get feedPandaHasEnough => 'Le panda a assez mange. Comptons ensemble.';

  @override
  String get feedPandaReplayInstructionButton => 'Reecouter la consigne';

  @override
  String get feedPandaNewRoundButton => 'Nouvelle partie';

  @override
  String feedPandaFruitSemanticLabel(int position, int total) {
    return 'Pomme $position sur $total. Double-tape pour selectionner.';
  }

  @override
  String get feedPandaSelectedSuffix => 'Selectionnee.';

  @override
  String feedPandaPandaSemanticReady(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Encore $remaining pommes necessaires',
      one: 'Encore 1 pomme necessaire',
    );
    return 'Nourris le panda. $_temp0.';
  }

  @override
  String get feedPandaPandaSemanticFull =>
      'Le panda a assez mange pour cette partie.';

  @override
  String feedPandaAnswerChoiceSemanticLabel(int value) {
    return 'Reponse $value.';
  }

  @override
  String get feedPandaTryAgainMessage => 'Pas tout a fait — essaie encore !';

  @override
  String get feedPandaRoundCompleteMessage => 'Tu as super bien compte !';

  @override
  String get labsSpatialCubeWhichFaceOppositeMission =>
      'Regarde le cube, puis decide quelle face est opposee a celle indiquee.';

  @override
  String labsSpatialCubeWhichFaceOppositeQuestion(String faceLabel) {
    return 'Quelle face est opposee a $faceLabel?';
  }

  @override
  String get labsSpatialCubeWhichFaceOppositeHintButton => 'Indice';

  @override
  String get labsSpatialCubeWhichFaceOppositeHintText =>
      'Les faces opposees ne partagent jamais une arete — avant/arriere, dessus/dessous et gauche/droite sont toujours les trois paires.';

  @override
  String get labsSpatialCubeWhichFaceOppositeCorrect =>
      'Bien vu. Tu as bien tenu compte des relations entre les faces.';

  @override
  String get labsSpatialCubeWhichFaceOppositeIncorrect =>
      'Presque. Regarde quelles faces partagent une arete.';

  @override
  String get labsSpatialCubeWhichFaceOppositeWhereUsed =>
      'Emballer des boites, lire un de a jouer et travailler avec des patrons 3D reposent tous sur le fait de savoir quelles faces d\'un cube sont opposees.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToDo =>
      'Fais pivoter le cube si tu veux, puis choisis la face que tu penses etre opposee a celle indiquee.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToNotice =>
      'Remarque que les faces opposees ne sont jamais cote a cote, quelle que soit la facon dont tu tournes le cube.';

  @override
  String get labsSpatialCubeWhichFaceOppositeHelpWhatItMeans =>
      'Chaque cube a exactement trois paires de faces opposees — avant/arriere, dessus/dessous, gauche/droite — et faire pivoter le cube ne change jamais quelles faces sont associees.';

  @override
  String labsSpatialCubeWhichFaceOppositeReveal(
      String correctLabel, String askedLabel) {
    return '$correctLabel est oppose a $askedLabel.';
  }

  @override
  String get labsSpatialCubeRotateToMatchMission =>
      'Fais pivoter ton cube jusqu\'a ce qu\'il corresponde a l\'orientation cible affichee.';

  @override
  String get labsSpatialCubeRotateToMatchTargetLabel => 'Orientation cible';

  @override
  String get labsSpatialCubeRotateToMatchYourCubeLabel => 'Ton cube';

  @override
  String get labsSpatialCubeRotateToMatchTestButton => 'Tester ma rotation';

  @override
  String get labsSpatialCubeRotateToMatchCorrect =>
      'Bravo — c\'est une bonne correspondance.';

  @override
  String get labsSpatialCubeRotateToMatchIncorrect =>
      'Pas encore tout a fait. Compare quelle face est devant et laquelle est dessus.';

  @override
  String get labsSpatialCubeRotateToMatchWhereUsed =>
      'Faire correspondre l\'orientation d\'un objet a un schema fait partie de la lecture des dessins techniques et des instructions de montage.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatToDo =>
      'Fais glisser ton cube pour aligner ses faces avec la cible affichee a cote, puis teste ta rotation.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatToNotice =>
      'Remarque que tu n\'as pas besoin d\'une correspondance parfaite au pixel pres — il suffit que les memes faces soient devant et dessus.';

  @override
  String get labsSpatialCubeRotateToMatchHelpWhatItMeans =>
      'Une orientation est entierement decrite par la face qui est devant et celle qui est dessus — ces deux informations fixent tout le reste.';

  @override
  String get labsSpatialCubeHiddenFaceMission =>
      'Regarde les trois faces visibles, puis trouve ce qui se trouve sur celle qui est cachee.';

  @override
  String labsSpatialCubeHiddenFaceQuestion(String direction) {
    return 'Quelle etiquette se trouve sur la face $direction?';
  }

  @override
  String get labsSpatialCubeHiddenFaceHintButton => 'Indice';

  @override
  String get labsSpatialCubeHiddenFaceHintText =>
      'Trouve d\'abord les faces que tu PEUX voir — la face cachee est l\'une des trois restantes.';

  @override
  String get labsSpatialCubeHiddenFaceCorrect =>
      'Bravo. Tu as correctement predit la face cachee.';

  @override
  String get labsSpatialCubeHiddenFaceIncorrect =>
      'Bon essai. Fais pivoter le cube pour verifier, puis essaie le suivant.';

  @override
  String get labsSpatialCubeHiddenFaceWhereUsed =>
      'Lire des schemas isometriques et des dessins techniques demande de raisonner sur des faces que l\'on ne voit pas directement.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatToDo =>
      'Regarde les trois faces visibles, puis choisis l\'etiquette que tu penses se trouver sur la face cachee indiquee.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatToNotice =>
      'Remarque que seulement trois faces sont visibles a la fois depuis cet angle — les trois autres sont toujours cachees.';

  @override
  String get labsSpatialCubeHiddenFaceHelpWhatItMeans =>
      'Un cube ne montre jamais que trois faces depuis un point de vue, donc trouver une face cachee demande de raisonner sur tout le cube, pas seulement sur ce qui est visible.';

  @override
  String get labsSpatialCubeNetExplorerMission =>
      'Regarde le patron a plat, predis quelles faces finiront opposees l\'une a l\'autre, puis plie-le pour verifier.';

  @override
  String get labsSpatialCubeNetExplorerPredictPrompt =>
      'Quels deux carres penses-tu finiront opposes l\'un a l\'autre?';

  @override
  String get labsSpatialCubeNetExplorerFoldButton => 'Plier';

  @override
  String get labsSpatialCubeNetExplorerUnfoldButton => 'Deplier';

  @override
  String get labsSpatialCubeNetExplorerNextNetButton => 'Patron suivant';

  @override
  String get labsSpatialCubeNetExplorerStepBackButton => 'Precedent';

  @override
  String get labsSpatialCubeNetExplorerStepForwardButton => 'Etape suivante';

  @override
  String get labsSpatialCubeNetExplorerWhereUsed =>
      'La conception d\'emballages et la tolerie commencent toutes deux par un patron a plat qui se plie en une forme 3D finie.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatToDo =>
      'Etudie le patron a plat, puis appuie sur Plier pour voir s\'il se referme en cube.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatToNotice =>
      'Remarque que tous les arrangements de six carres ne se plient pas en cube ferme — certains se chevauchent ou laissent un vide.';

  @override
  String get labsSpatialCubeNetExplorerHelpWhatItMeans =>
      'Un patron est une forme 2D qui se plie le long de ses aretes en un solide 3D — le meme carre peut finir sur des faces tres differentes du cube selon la forme du patron.';

  @override
  String get labsAircraftLandingLabTitle => 'Laboratoire d\'atterrissage';

  @override
  String get labsAircraftLandingLabSubtitle =>
      'Pilote l\'angle de descente, la distance et la vitesse qui permettent un atterrissage en toute securite';

  @override
  String get labsAircraftLandingLabIntro =>
      'Ajuste l\'angle de descente et la vitesse, puis appuie sur Tester l\'approche pour voir l\'avion suivre la trajectoire et voir ou il se pose.';

  @override
  String get labsAircraftLandingLabFreePlayCaption =>
      'Essaie: fais glisser les curseurs, puis appuie sur Tester l\'approche.';

  @override
  String get labsAircraftLandingFindTheTimeTitle => 'Trouve le temps';

  @override
  String get labsAircraftLandingFindTheTimeSubtitle =>
      'Calcule combien de temps prend le vol jusqu\'a la piste';

  @override
  String get labsAircraftLandingDescentLineTitle => 'Suis la ligne de descente';

  @override
  String get labsAircraftLandingDescentLineSubtitle =>
      'Fais correspondre ton angle de descente a une ligne de planee cible';

  @override
  String get labsAircraftLandingGlidePathTitle =>
      'Atterris sur le plan de descente';

  @override
  String get labsAircraftLandingGlidePathSubtitle =>
      'Choisis l\'angle et la vitesse pour atterrir en toute securite sur la piste';

  @override
  String get labsAircraftLandingVectorApproachTitle => 'Approche vectorielle';

  @override
  String get labsAircraftLandingVectorApproachSubtitle =>
      'Ajuste la vitesse horizontale et verticale pour correspondre a une approche cible';

  @override
  String labsAircraftLandingDescentAngleLabel(int degrees) {
    return 'Angle de descente: $degrees°';
  }

  @override
  String labsAircraftLandingAirspeedLabel(int metresPerSecond) {
    return 'Vitesse: $metresPerSecond m/s';
  }

  @override
  String get labsAircraftLandingTestApproachButton => 'Tester l\'approche';

  @override
  String labsAircraftLandingFindTheTimeDiagramLabel(
      int distanceM, int speedMps) {
    return 'Un avion a $distanceM metres de la piste, volant a $speedMps metres par seconde.';
  }

  @override
  String labsAircraftLandingFindTheTimeSpeedLabel(int speedMps) {
    return 'Vitesse: $speedMps m/s';
  }

  @override
  String get labsAircraftLandingFindTheTimeQuestion =>
      'Combien de temps faudra-t-il pour atteindre la piste?';

  @override
  String get labsAircraftLandingFindTheTimeHintButton => 'Indice';

  @override
  String get labsAircraftLandingFindTheTimeHintText =>
      'Temps = distance / vitesse.';

  @override
  String get labsAircraftLandingFindTheTimeMission =>
      'Utilise la distance et la vitesse indiquees pour calculer combien de temps prendra le vol jusqu\'a la piste.';

  @override
  String get labsAircraftLandingFindTheTimeWhereUsed =>
      'Les pilotes et les controleurs aeriens estiment constamment le temps jusqu\'a la piste a partir de la vitesse et de la distance pour sequencer des atterrissages surs.';

  @override
  String get labsAircraftLandingFindTheTimeCorrect =>
      'Correct — tu as trouve le temps jusqu\'a la piste.';

  @override
  String get labsAircraftLandingFindTheTimeIncorrect =>
      'Pas tout a fait. Essaie de diviser la distance par la vitesse.';

  @override
  String labsAircraftLandingFindTheTimeReveal(int seconds) {
    return 'Le temps correct est $seconds secondes.';
  }

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatToDo =>
      'Lis la distance et la vitesse indiquees, puis choisis le temps correspondant parmi les options.';

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatToNotice =>
      'Remarque qu\'une vitesse plus elevee signifie toujours un temps plus court pour la meme distance.';

  @override
  String get labsAircraftLandingFindTheTimeHelpWhatItMeans =>
      'Le temps, la distance et la vitesse sont toujours lies par temps = distance / vitesse — la meme relation utilisee pour n\'importe quel trajet, pas seulement les vols.';

  @override
  String get labsAircraftLandingDescentLineTestButton => 'Tester ma ligne';

  @override
  String get labsAircraftLandingDescentLineMission =>
      'Ajuste ton angle de descente jusqu\'a ce que ta ligne corresponde a la ligne cible en pointilles.';

  @override
  String get labsAircraftLandingDescentLineWhereUsed =>
      'Faire correspondre une pente requise se produit chaque fois qu\'un chemin, une rampe ou un tuyau doit suivre une inclinaison fixe.';

  @override
  String get labsAircraftLandingDescentLineCorrect =>
      'Bravo — ta ligne correspond au plan de descente cible.';

  @override
  String get labsAircraftLandingDescentLineIncorrect =>
      'Pas encore. Compare a quel point ta ligne est raide par rapport a la ligne cible en pointilles.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatToDo =>
      'Deplace le curseur d\'angle de descente jusqu\'a ce que ta ligne pleine se superpose a la ligne cible en pointilles, puis teste-la.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatToNotice =>
      'Remarque qu\'un angle plus raide fait descendre la ligne plus vite — une pente negative plus grande.';

  @override
  String get labsAircraftLandingDescentLineHelpWhatItMeans =>
      'L\'angle de descente est la pente de la ligne: variation d\'altitude divisee par la distance parcourue, ecrite y = mx + c avec un m negatif.';

  @override
  String get labsAircraftLandingGlidePathSafe =>
      'Atterrissage en douceur — pile sur la piste.';

  @override
  String get labsAircraftLandingGlidePathTooSteep =>
      'Trop raide — l\'avion a touche le sol avant la piste.';

  @override
  String get labsAircraftLandingGlidePathTooShallow =>
      'Trop plat — l\'avion etait encore en vol apres la piste.';

  @override
  String get labsAircraftLandingGlidePathMission =>
      'Choisis un angle et une vitesse, puis teste ton approche pour atterrir en toute securite sur la piste.';

  @override
  String get labsAircraftLandingGlidePathWhereUsed =>
      'Chaque atterrissage reel equilibre un angle de descente sur avec la vitesse et la distance pour toucher le sol exactement au bon endroit.';

  @override
  String labsAircraftLandingGlidePathTouchdownError(int metres) {
    return '$metres metres du seuil de piste.';
  }

  @override
  String get labsAircraftLandingGlidePathHelpWhatToDo =>
      'Ajuste l\'angle et la vitesse, puis appuie sur Tester l\'approche pour voir ou l\'avion touche vraiment le sol.';

  @override
  String get labsAircraftLandingGlidePathHelpWhatToNotice =>
      'Remarque comment le point de toucher des roues se deplace quand tu changes l\'angle, meme si la vitesse reste la meme.';

  @override
  String get labsAircraftLandingGlidePathHelpWhatItMeans =>
      'tan(angle) = altitude / distance — c\'est exactement ce rapport qui fait qu\'une descente atterrit precisement sur la piste plutot que trop court ou trop long.';

  @override
  String labsAircraftLandingVectorHorizontalLabel(int metresPerSecond) {
    return 'Vitesse horizontale: $metresPerSecond m/s';
  }

  @override
  String labsAircraftLandingVectorVerticalLabel(int metresPerSecond) {
    return 'Vitesse verticale: $metresPerSecond m/s';
  }

  @override
  String labsAircraftLandingVectorResultantLabel(int metresPerSecond) {
    return 'Vitesse combinee (resultante): $metresPerSecond m/s';
  }

  @override
  String get labsAircraftLandingVectorApproachMission =>
      'Ajuste les composantes de vitesse horizontale et verticale pour correspondre a l\'approche cible.';

  @override
  String get labsAircraftLandingVectorApproachWhereUsed =>
      'Combiner une vitesse horizontale et verticale en un seul vecteur resultant est exactement la facon dont une trajectoire de vol reelle, ou tout mouvement 2D, est decrite mathematiquement.';

  @override
  String get labsAircraftLandingVectorApproachCorrect =>
      'Correct — tes composantes correspondent a l\'approche cible.';

  @override
  String get labsAircraftLandingVectorApproachIncorrect =>
      'Pas encore. Compare tes vitesses horizontale et verticale a la cible.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatToDo =>
      'Ajuste les curseurs de vitesse horizontale et verticale, puis teste ton approche.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatToNotice =>
      'Remarque comment la vitesse resultante et la trajectoire de descente changent toutes deux quand tu ajustes l\'une ou l\'autre composante.';

  @override
  String get labsAircraftLandingVectorApproachHelpWhatItMeans =>
      'Toute vitesse peut etre decomposee en une composante horizontale et une composante verticale, puis recombinee avec le theoreme de Pythagore pour trouver la vitesse resultante.';

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

  @override
  String get allieLabel => 'Allie';

  @override
  String get familyMathsEntryTitle => 'Maths en famille';

  @override
  String get familyMathsWelcomeTitle => 'Bienvenue';

  @override
  String get familyMathsWelcomeBody =>
      'Aider ton enfant en maths ne demande pas un savoir parfait. De petites conversations. Des jeux simples. De la curiosité. De la régularité. On s\'occupe du reste.';

  @override
  String get familyMathsAllieIntro =>
      'Tu n\'as pas besoin de te souvenir de chaque méthode scolaire. Choisis un thème. Je te proposerai une activité de cinq minutes qui aide ton enfant à penser mathématiquement.';

  @override
  String get familyMathsPhilosophyTagline =>
      'Les parents n\'ont pas besoin de devenir enseignants.';

  @override
  String get familyMathsStartActivityButton =>
      'Démarrer une activité en famille';

  @override
  String get familyMathsBrowseTopicsButton => 'Parcourir les thèmes';

  @override
  String get familyMathsLibraryTitle => 'Activités en famille';

  @override
  String get familyMathsEmptyCategory =>
      'Pas encore d\'activités pour ce thème. D\'autres arrivent bientôt.';

  @override
  String familyActivityAgeRange(int min, int max) {
    return '$min-$max ans';
  }

  @override
  String familyActivityTimeRange(int min, int max) {
    return '$min-$max min';
  }

  @override
  String get familyActivityMaterialsLabel => 'Matériel nécessaire';

  @override
  String get familyActivityWhatYourChildLearnsLabel =>
      'Ce que ton enfant apprend';

  @override
  String get familyActivityLetsExploreLabel => 'Explorons ensemble';

  @override
  String get familyActivityQuestionsToAskLabel => 'Questions à poser';

  @override
  String get familyActivityMisconceptionsLabel => 'Erreurs fréquentes';

  @override
  String get familyActivityTryTomorrowLabel => 'À essayer demain';

  @override
  String get familyActivityStudioConnectionLabel => 'Lien avec Studio';

  @override
  String get familyMathsCategoryNumberSense => 'Sens du nombre';

  @override
  String get familyMathsCategoryAddition => 'Addition';

  @override
  String get familyMathsCategorySubtraction => 'Soustraction';

  @override
  String get familyMathsCategoryMultiplication => 'Multiplication';

  @override
  String get familyMathsCategoryDivision => 'Division';

  @override
  String get familyMathsCategoryFractions => 'Fractions';

  @override
  String get familyMathsCategoryDecimals => 'Nombres décimaux';

  @override
  String get familyMathsCategoryRatio => 'Proportion';

  @override
  String get familyMathsCategoryPercentages => 'Pourcentages';

  @override
  String get familyMathsCategoryGeometry => 'Géométrie';

  @override
  String get familyMathsCategoryMeasurement => 'Mesures';

  @override
  String get familyMathsCategoryAlgebra => 'Algèbre';

  @override
  String get familyMathsCategoryPatterns => 'Suites';

  @override
  String get familyMathsCategoryLogic => 'Logique';

  @override
  String get familyMathsCategorySpatialReasoning => 'Raisonnement spatial';

  @override
  String get familyMathsReassurance1 =>
      'Tu n\'as pas besoin de connaître la réponse tout de suite.';

  @override
  String get familyMathsReassurance2 =>
      'Demande à ton enfant d\'expliquer ce qu\'il remarque.';

  @override
  String get familyMathsReassurance3 =>
      'Une mauvaise réponse peut lancer une conversation utile.';

  @override
  String get familyMathsReassurance4 => 'Cinq minutes concentrées suffisent.';

  @override
  String get familyMathsReassurance5 => 'Laisse ton enfant choisir les objets.';

  @override
  String get familyMathsReassurance6 =>
      'Essayez une autre représentation si la première n\'aide pas.';

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
      'Cartes memo pour parents';

  @override
  String get familyStudioSectionParentRecallCardsSubtitle =>
      'Des astuces chaleureuses et pratiques — pas des questions d\'examen.';

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
  String get familyStudioPinReminderTitle => 'Protéger Family Studio';

  @override
  String get familyStudioPinReminderBody =>
      'Créez un code PIN parent pour protéger les devoirs, les rapports et les paramètres de l\'apprenant.';

  @override
  String get familyStudioPinReminderSetPinButton => 'Définir le code PIN';

  @override
  String get familyStudioPinReminderLaterButton => 'Me le rappeler plus tard';

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
  String get appearanceResetOnboardingButton => 'Reset Onboarding';
}
