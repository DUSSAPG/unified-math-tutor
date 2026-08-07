// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

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
      'Comprende el progreso, identifica lagunas y apoya el siguiente paso.';

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
      'Desarrolla el pensamiento matemático.\nDesbloquea tu potencial.';

  @override
  String get onboardingWelcomeSubtitle =>
      'Aprendizaje personalizado. Progreso medible.';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'Soy estudiante';

  @override
  String get onboardingStudentSub =>
      'Practica matemáticas con un recorrido de aprendizaje diseñado para ti.';

  @override
  String get onboardingParentLabel => 'Apoyo a un estudiante';

  @override
  String get onboardingParentSub =>
      'Apoya cada paso de su desarrollo matemático.';

  @override
  String get onboardingTeacherLabel => 'Soy docente';

  @override
  String get onboardingTeacherSub =>
      'Supervisa el progreso y asigna práctica a tus alumnos.';

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
  String get onboardingAccessibilityTitle => 'Hazlo más cómodo de leer';

  @override
  String get onboardingAccessibilitySub =>
      'Puedes cambiar esto en cualquier momento en Ajustes.';

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
      'Ayudar a ganar confianza matemática';

  @override
  String get onboardingParentGoal1Sub =>
      'Support steady, low-pressure practice at the learner\'s pace.';

  @override
  String get onboardingParentGoal2Label => 'Identificar lagunas de aprendizaje';

  @override
  String get onboardingParentGoal2Sub =>
      'Spot topics that need more attention before they become blockers.';

  @override
  String get onboardingParentGoal3Label => 'Seguir el progreso en el tiempo';

  @override
  String get onboardingParentGoal3Sub =>
      'Follow growth and consistency across completed practice.';

  @override
  String get onboardingParentGoal4Label => 'Apoyar la preparación de exámenes';

  @override
  String get onboardingParentGoal4Sub =>
      'Guide revision and practice for upcoming assessments.';

  @override
  String get onboardingGoalTitleTeacher =>
      '¿Cómo te gustaría usar Math Intelligence?';

  @override
  String get onboardingGoalSubTeacher => 'Elige el enfoque para tu clase.';

  @override
  String get onboardingTeacherGoal1Label =>
      'Supervisar el progreso de la clase';

  @override
  String get onboardingTeacherGoal1Sub =>
      'Observa cómo progresan tus alumnos con el tiempo.';

  @override
  String get onboardingTeacherGoal2Label => 'Asignar práctica';

  @override
  String get onboardingTeacherGoal2Sub =>
      'Configura conjuntos de práctica específicos para tus alumnos.';

  @override
  String get onboardingTeacherGoal3Label => 'Preparar exámenes';

  @override
  String get onboardingTeacherGoal3Sub =>
      'Apoya la preparación de exámenes con práctica específica.';

  @override
  String get onboardingTeacherGoal4Label => 'Explorar el plan de estudios';

  @override
  String get onboardingTeacherGoal4Sub =>
      'Explora los temas y las soluciones resueltas antes de asignarlos.';

  @override
  String get onboardingProfileTitle => 'Guarda tu progreso';

  @override
  String get onboardingProfileSub =>
      'Opcional: siempre puedes cambiarlo más tarde en tu Perfil.';

  @override
  String get onboardingDisplayNameLabel => '¿Cómo te llamamos?';

  @override
  String get onboardingDisplayNameSub =>
      'Un apodo está bien; esto es solo para tu saludo.';

  @override
  String get onboardingDisplayNameHint => 'e.g. Alex';

  @override
  String get onboardingLearnerNameLabel => '¿Cómo llamamos a tu alumno?';

  @override
  String get onboardingLearnerNameSub => 'Personaliza su Maths Journey.';

  @override
  String get onboardingLearnerNameHint => 'e.g. Alex';

  @override
  String get onboardingRelationshipLabel => 'Tu relación con el alumno';

  @override
  String get onboardingRelationshipParent => 'Madre o padre';

  @override
  String get onboardingRelationshipGuardian => 'Tutor legal';

  @override
  String get onboardingRelationshipGrandparent => 'Abuelo/a';

  @override
  String get onboardingRelationshipTutor => 'Profesor particular';

  @override
  String get onboardingRelationshipOther => 'Otro familiar';

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
    return 'A continuación: $topic';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsParentToolsRewards =>
      'Learning Analytics y animaciones de recompensa';

  @override
  String get enableParentTools => 'Activar Learning Analytics';

  @override
  String get parentToolsLocalOnly => 'Permitir Learning Analytics local';

  @override
  String get unlockParentTools => 'Desbloquear Learning Analytics';

  @override
  String get parentToolsPinPrompt =>
      'Create or enter the local 4-digit PIN for Learning Analytics.';

  @override
  String get parentTeacherTools => 'Learning Analytics';

  @override
  String get createParentPin => 'Crear PIN parental';

  @override
  String get parentPinStorageNotice =>
      'El PIN de 4 dígitos se almacena localmente como un hash SHA-256. Ningún dato sale de este dispositivo.';

  @override
  String get fourDigitPin => 'PIN de 4 dígitos';

  @override
  String get openCheatSheet => 'Abrir hoja de ayuda';

  @override
  String get unlockWithPremium => 'Desbloquear con Premium';

  @override
  String get rewardsAnimations => 'Animaciones de recompensa';

  @override
  String get rewardsAnimationsSubtitle =>
      'Mostrar celebraciones tras respuestas correctas e hitos';

  @override
  String get premiumLabel => 'Premium';

  @override
  String get rewardsLabel => 'Recompensas';

  @override
  String get premiumFeature => 'Función Premium';

  @override
  String get includedInPremium => 'Incluido en Premium';

  @override
  String get availableInExamPacks => 'Disponible en paquetes de examen';

  @override
  String get unlockWithSubscription => 'Desbloquear con suscripción';

  @override
  String get enterParentPin => 'Ingresar PIN parental';

  @override
  String get resetParentPin => 'Restablecer PIN parental';

  @override
  String get currentPin => 'PIN actual';

  @override
  String get resetLabel => 'Restablecer';

  @override
  String get vaultLoadError => 'El almacén no se pudo cargar.';

  @override
  String get pinMustBeFourDigits => 'Introduce exactamente 4 dígitos.';

  @override
  String get pinIncorrect => 'PIN incorrecto.';

  @override
  String get pinResetFailed => 'Falló el restablecimiento del PIN.';

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
      'Desarrolla el pensamiento matemático.\nDesbloquea tu potencial.';

  @override
  String get onboardingSupportingStatement =>
      'Aprendizaje personalizado.\nProgreso medible.';

  @override
  String get onboardingRoleClarification =>
      'Para familias, tutores legales, docentes, tutores y educadores en casa.';

  @override
  String get onboardingCreateAccount => 'Crear cuenta';

  @override
  String get onboardingCreateAccountSub =>
      'Save progress, Maths Journey data and achievements on this device.';

  @override
  String get learningAnalyticsTitle => 'Learning Analytics';

  @override
  String get learningAnalyticsSummary =>
      'Comprende el progreso, identifica lagunas y apoya el siguiente paso.';

  @override
  String get learningAnalyticsEmptyState =>
      'Completa una sesión de práctica para empezar a crear Learning Analytics.';

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
      'Tarjetas de repaso para padres';

  @override
  String get familyStudioSectionParentRecallCardsSubtitle =>
      'Consejos calidos y practicos, no preguntas de examen.';

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
  String get familyStudioPinReminderTitle => 'Proteger Family Studio';

  @override
  String get familyStudioPinReminderBody =>
      'Crea un PIN de padres para proteger las tareas, los informes y la configuración del alumno.';

  @override
  String get familyStudioPinReminderSetPinButton => 'Establecer PIN';

  @override
  String get familyStudioPinReminderLaterButton => 'Recordármelo más tarde';

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
