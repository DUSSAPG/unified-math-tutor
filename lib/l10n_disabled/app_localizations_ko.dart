// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

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
      '11+ prep, stretch questions & competition maths';

  @override
  String get topicsPremiumComingSoon => 'Premium track coming soon.';

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
      'Unlock deeper explanations with Tutor credits or a paid maths pack.';

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
  String get profileVersion => 'Version 1.0.0 · © 2026 MathTutor';

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
      'Yes. We collect only what is needed to personalise your learning. No data is sold or shared with third parties. All data is deletable at any time.';

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
      'Free for students and parents. By using MathTutor you agree to our terms of service. No payment is required for standard access.';

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
      '11+ prep, advanced challenges & competition maths';

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
  String get onboardingWelcomeTitle => 'Welcome to MathTutor';

  @override
  String get onboardingWelcomeSubtitle =>
      'Personalised maths learning, built for results';

  @override
  String get onboardingWhoLabel => 'WHO IS USING THE APP?';

  @override
  String get onboardingStudentLabel => 'I\'m a student';

  @override
  String get onboardingStudentSub => 'Direct access to practice and tests';

  @override
  String get onboardingParentLabel => 'I\'m a parent/guardian';

  @override
  String get onboardingParentSub => 'Monitor progress and provide support';

  @override
  String get onboardingSelectError => 'Please select an option';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingFooter =>
      'Minimal data. No ads. Parental controls available.';

  @override
  String get onboardingStageTitle => 'What stage is the student at?';

  @override
  String get onboardingStageSub =>
      'We\'ll tailor the content to the right level';

  @override
  String get onboardingStageCount => '4';

  @override
  String get onboardingStage1Label => 'KS2 (Years 3–6)';

  @override
  String get onboardingStage1Sub => 'Primary school maths';

  @override
  String get onboardingStage2Label => 'KS3 (Years 7–9)';

  @override
  String get onboardingStage2Sub => 'Secondary school maths';

  @override
  String get onboardingStage3Label => 'KS4 GCSE (Years 10–11)';

  @override
  String get onboardingStage3Sub => 'GCSE maths preparation';

  @override
  String get onboardingStage4Label => 'KS5 (Years 12–13)';

  @override
  String get onboardingStage4Sub => 'Advanced maths';

  @override
  String get onboardingGoalTitle => 'What\'s the goal?';

  @override
  String get onboardingGoalSub => 'Choose the learning focus';

  @override
  String get onboardingGoal1Label => 'School Support';

  @override
  String get onboardingGoal1Sub => 'Build confidence across Key Stages';

  @override
  String get onboardingGoal2Label => 'Exam Ready';

  @override
  String get onboardingGoal2Sub => 'Targeted GCSE practice & timed sets';

  @override
  String get onboardingGoal3Label => 'Oxford Track';

  @override
  String get onboardingGoal3Sub => '11+ prep and stretch challenges';

  @override
  String get onboardingProfileTitle => 'Choose your level';

  @override
  String get onboardingProfileSub => 'Select the right tier for School Support';

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
  String get upgradeBody => 'Premium subscriptions are coming soon.';

  @override
  String get upgradeViewPacks => 'View Exam Packs';

  @override
  String get upgradeMaybeLater => 'Maybe Later';

  @override
  String get termsTitle => 'Terms of Use';

  @override
  String get termsSub => 'Please read before using this app';

  @override
  String get tutorCreditComingSoon => 'Tutor credits coming soon.';

  @override
  String get upgradeWhatsIncluded => 'What you\'ll get';

  @override
  String get upgradeBenefit1Title => 'Unlimited AI Tutor';

  @override
  String get upgradeBenefit1Sub =>
      'Ask unlimited questions, get step-by-step explanations, and receive personalised hints without credit limits.';

  @override
  String get upgradeBenefit2Title => 'Oxford-Style Track';

  @override
  String get upgradeBenefit2Sub =>
      'Access the structured Oxford curriculum track with curated problem sets and guided progression from KS3 to A-Level.';

  @override
  String get upgradeBenefit3Title => 'Advanced Analytics';

  @override
  String get upgradeBenefit3Sub =>
      'Track your progress with detailed performance charts, weakness detection, and personalised study recommendations.';

  @override
  String get upgradeComingSoonLabel => 'Coming soon';

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
      'Type a maths question or tap a quick action above.';

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
}

/// The translations for Korean, as used in Republic of Korea (`ko_KR`).
class AppLocalizationsKoKr extends AppLocalizationsKo {
  AppLocalizationsKoKr() : super('ko_KR');

  @override
  String get navHome => '홈';

  @override
  String get navTopics => '주제';

  @override
  String get navPractice => '연습';

  @override
  String get navProfile => '프로필';

  @override
  String get navTutor => '튜터';

  @override
  String get navHelp => '도움말';

  @override
  String get topicsSearchHint => '주제 검색...';

  @override
  String get topicsFilterAll => '전체';

  @override
  String get topicsFilterPractice => '연습';

  @override
  String get topicsFilterRecommended => '추천';

  @override
  String get topicsFilterOxfordTrack => '옥스퍼드 트랙';

  @override
  String get topicsFilterGcse => '시험 대비';

  @override
  String get topicsFilterMore => '더보기';

  @override
  String get topicsSelectTrack => '트랙 선택';

  @override
  String get topicsTrackStandard => '기본 트랙';

  @override
  String get topicsTrackStandardSub => '핵심 수학 커리큘럼';

  @override
  String get topicsTrackGcseFoundation => '기초 수준';

  @override
  String get topicsTrackGcseFoundationSub => '기초 수준 준비';

  @override
  String get topicsTrackGcseHigher => '심화 수준';

  @override
  String get topicsTrackGcseHigherSub => '심화 수준 준비';

  @override
  String get topicsTrackOxford => '옥스퍼드 트랙';

  @override
  String get topicsTrackOxfordSub => '심화 수학 및 경시대회';

  @override
  String get topicsPremiumComingSoon => '프리미엄 구독 출시 예정.';

  @override
  String get topicsPremiumLabel => 'PREMIUM';

  @override
  String get practiceChooseMode => '연습 모드를 선택하세요';

  @override
  String get practiceModeLabel => '모드';

  @override
  String get practiceQuestionsLabel => '문제 수';

  @override
  String get practiceStartButton => '연습 시작';

  @override
  String get practiceModeQuickStart => '빠른 시작';

  @override
  String get practiceModeQuickStartSub => '혼합 복습, 10문제';

  @override
  String get practiceModeTopicDrill => '주제별 연습';

  @override
  String get practiceModeTopicDrillSub => '특정 주제 집중 연습';

  @override
  String get practiceModeTimedChallenge => '시간 제한 도전';

  @override
  String get practiceModeTimedChallengeSub => '시간 내에 풀기';

  @override
  String get practiceModeExamSimulator => '시험 시뮬레이터';

  @override
  String get practiceModeExamSimulatorSub => '실전 시험 형식 모의 연습';

  @override
  String get practiceExit => '종료';

  @override
  String practiceQuestionOf(int current, int total) {
    return '$current/$total 문제';
  }

  @override
  String get practiceMixedReview => '혼합 복습';

  @override
  String get practiceExplanation => '설명';

  @override
  String get practiceCheckAnswer => '정답 확인';

  @override
  String get practiceNextQuestion => '다음 문제 →';

  @override
  String get practiceFinishSession => '세션 종료';

  @override
  String get tutorBotName => '수학 튜터';

  @override
  String get tutorBotSubtitle => '힌트, 설명, 단계별 풀이를 받아보세요.';

  @override
  String tutorFreeTipsLeft(int count) {
    return '오늘 남은 무료 힌트: $count개';
  }

  @override
  String get tutorChipExplain => '설명해줘';

  @override
  String get tutorChipHint => '힌트 줘';

  @override
  String get tutorChipSteps => '풀이 보여줘';

  @override
  String get tutorChipCheckMistake => '오류 확인해줘';

  @override
  String get tutorInputHint => '수학 튜터에게 질문하세요...';

  @override
  String get tutorNeedMoreHelp => '더 많은 도움이 필요하신가요?';

  @override
  String get tutorUnlockDeeper => '튜터 크레딧 또는 유료 수학 팩으로 심층 설명을 이용하세요.';

  @override
  String get tutorBuyCredits => '튜터 크레딧 구매';

  @override
  String get tutorViewPacks => '팩 보기';

  @override
  String get profileSettingsLabel => '설정';

  @override
  String get profileAppearance => '외관';

  @override
  String get profileAppearanceSub => '테마 및 시각 설정';

  @override
  String get profileAccessibility => '접근성';

  @override
  String get profileAccessibilitySub => '글자 크기, 대비 및 애니메이션';

  @override
  String get profileSubscription => '구독';

  @override
  String get profileSubscriptionSub => '플랜 관리';

  @override
  String get profileCurriculumSettings => '커리큘럼 설정';

  @override
  String get profileCurriculumSettingsSub => '학습 단계 변경';

  @override
  String get profilePrivacyData => '개인정보 및 데이터';

  @override
  String get profilePrivacyDataSub => 'GDPR 준수 · 광고 없음 · 제3자 공유 없음';

  @override
  String get profileSignOut => '로그아웃';

  @override
  String get profileSignOutSub => '세션을 종료하고 환영 화면으로 돌아가기';

  @override
  String get profileVersion => '버전 1.0.0 · © 2026 MathTutor';

  @override
  String get profileHeaderTitle => '프로필';

  @override
  String get profileHeaderSubtitle => '설정 및 환경설정';

  @override
  String get helpHeaderTitle => '도움말 및 지원';

  @override
  String get helpHeaderSubtitle => '지원, 안전 및 앱 정보';

  @override
  String get helpFaqTitle => '자주 묻는 질문';

  @override
  String get helpFaq1Q => '학습 단계 선택은 어떻게 작동하나요?';

  @override
  String get helpFaq1A =>
      '온보딩 중에 학습 단계를 선택합니다. 이를 통해 주제, 난이도, 시험 팩이 맞춤화됩니다. 언제든지 커리큘럼 설정에서 변경할 수 있습니다.';

  @override
  String get helpFaq2Q => '내 데이터는 안전한가요?';

  @override
  String get helpFaq2A =>
      '네. 학습 개인화에 필요한 데이터만 수집합니다. 데이터는 제3자와 공유되지 않으며 언제든지 삭제할 수 있습니다.';

  @override
  String get helpFaq3Q => '여러 자녀를 추가할 수 있나요?';

  @override
  String get helpFaq3A => '다중 프로필 지원은 로드맵에 있습니다. 현재 각 설치는 하나의 학습자 프로필을 지원합니다.';

  @override
  String get helpFaq4Q => '시험 팩은 어떻게 작동하나요?';

  @override
  String get helpFaq4A =>
      '시험 팩은 주제와 난이도 별로 분류된 문제 세트입니다. 연습 → 시험 시뮬레이터를 탭하여 시작하세요.';

  @override
  String get helpContactTitle => '문의';

  @override
  String get helpContactIntro => '질문이나 문제가 있으시면 연락해 주세요:';

  @override
  String get helpContactEmail => 'support@mathtutor.app';

  @override
  String get helpPrivacyTitle => '개인정보 및 안전';

  @override
  String get helpPrivacyHeadline => '최소한의 데이터. 광고 없음. GDPR 준수.';

  @override
  String get helpPrivacyBullet1 => '필요한 데이터만 수집합니다';

  @override
  String get helpPrivacyBullet2 => '제3자와 공유하지 않습니다';

  @override
  String get helpPrivacyBullet3 => '학부모 관리 기능 제공';

  @override
  String get helpPrivacyBullet4 => '언제든지 삭제 가능';

  @override
  String get helpTermsTitle => '이용약관';

  @override
  String get helpTermsBody =>
      '학생과 학부모에게 무료입니다. MathTutor를 사용하면 서비스 약관에 동의하는 것으로 간주됩니다.';

  @override
  String get helpParentalTitle => '학부모 관리';

  @override
  String get helpParentalHeadline => '자녀의 학습 진도를 확인하세요.';

  @override
  String get helpParentalBullet1 => '일일 학습 보고서';

  @override
  String get helpParentalBullet2 => '취약 영역 개요';

  @override
  String get helpParentalBullet3 => '학습 시간 제한 설정';

  @override
  String get helpParentalBullet4 => '학습 활동 로그 보기';

  @override
  String get helpReportButton => '문제 신고';

  @override
  String get helpFooter => '최소한의 데이터. 광고 없음. 학부모 관리 기능 제공.';

  @override
  String get swissChooseLanguage => '한국어';

  @override
  String get tutorChipDeepExplanation => '심층 설명';

  @override
  String get tutorChipStepByStep => '단계별 풀이';

  @override
  String get tutorChipMistakeAnalysis => '오류 분석';

  @override
  String get tutorCreditBadge => '크레딧 1개';

  @override
  String tutorCreditBalance(int count) {
    return '$count개 크레딧';
  }

  @override
  String get tutorProLabel => 'Premium';

  @override
  String get tutorExhaustedTitle => '무료 힌트 소진';

  @override
  String get tutorExhaustedBody =>
      '무료 힌트 3개를 모두 사용했습니다. 크레딧을 구매하거나 업그레이드하여 계속하세요.';

  @override
  String get tutorCreditRequired => '크레딧 1개 필요';

  @override
  String get tutorPracticeContextLabel => '연습 중';

  @override
  String get tutorContextHint => '힌트';

  @override
  String get tutorContextExplain => '설명';

  @override
  String get homeGreeting => '안녕하세요, Gabriel';

  @override
  String get homeStreakGoalMessage => '· 연속 학습 목표까지 10분 남았어요';

  @override
  String get homeSectionContinueLearning => '이어서 학습하기';

  @override
  String get homeViewAll => '모두 보기';

  @override
  String get homeSectionProgress => '학습 진도';

  @override
  String get homeStreakHeader => '연속 학습';

  @override
  String get homeStreakFirstDay => '연속 학습 첫 번째 날';

  @override
  String get homeThisWeekHeader => '이번 주';

  @override
  String get homeDaysActive => '활성 일수';

  @override
  String get homeSectionAchievements => '성취';

  @override
  String get homeAchievementStreakTitle => '주간 연속 학습 달성!';

  @override
  String get homeAchievementStreakSubtitle => '7일 연속 학습 완료';

  @override
  String get homeSectionOxfordTrack => '옥스퍼드 트랙';

  @override
  String get homePremiumRequired => 'PREMIUM';

  @override
  String get homeOxfordTrackSubtitle => '11+ 준비, 심화 문제 및 경시대회 수학';

  @override
  String get homeSectionLearningPaths => '학습 경로';

  @override
  String get homeSectionExamPacks => '시험 팩';

  @override
  String get homeExamPacksSubtitle => '집중 시험 준비';

  @override
  String get homeViewExamPacks => '시험 팩 보기';

  @override
  String get homeStartPracticeSession => '연습 시작';

  @override
  String get onboardingWelcomeTitle => 'MathTutor Korea';

  @override
  String get onboardingWelcomeSubtitle => '한국 학생을 위한 맞춤형 수학 학습';

  @override
  String get onboardingWhoLabel => '사용자를 선택하세요';

  @override
  String get onboardingStudentLabel => '학생입니다';

  @override
  String get onboardingStudentSub => '연습 문제와 시험 대비에 바로 접속';

  @override
  String get onboardingParentLabel => '학부모입니다';

  @override
  String get onboardingParentSub => '학습 진도 확인 및 지원';

  @override
  String get onboardingSelectError => '옵션을 선택해 주세요';

  @override
  String get onboardingContinue => '계속하기';

  @override
  String get onboardingFooter => '최소한의 데이터 수집. 광고 없음. 학부모 관리 기능 제공.';

  @override
  String get onboardingStageTitle => '학생의 나이는 몇 살인가요?';

  @override
  String get onboardingStageSub => '나이에 맞는 학습 내용을 제공합니다';

  @override
  String get onboardingStageCount => '3';

  @override
  String get onboardingStage1Label => '10–12세';

  @override
  String get onboardingStage1Sub => '초등학교 고학년';

  @override
  String get onboardingStage2Label => '13–15세';

  @override
  String get onboardingStage2Sub => '중학교';

  @override
  String get onboardingStage3Label => '16–20세';

  @override
  String get onboardingStage3Sub => '고등학교 / 수능 준비';

  @override
  String get onboardingStage4Label => 'KS5 (Years 12–13)';

  @override
  String get onboardingStage4Sub => 'Advanced maths';

  @override
  String get onboardingGoalTitle => '학습 목표는 무엇인가요?';

  @override
  String get onboardingGoalSub => '학습의 우선순위를 선택하세요';

  @override
  String get onboardingGoal1Label => '학교 학습 지원';

  @override
  String get onboardingGoal1Sub => '숙제 및 학교 과목 이해';

  @override
  String get onboardingGoal2Label => '시험 대비';

  @override
  String get onboardingGoal2Sub => '시험 대비 및 모의고사 마스터';

  @override
  String get onboardingGoal3Label => '옥스퍼드 트랙';

  @override
  String get onboardingGoal3Sub => '심화 수학 및 경시대회';

  @override
  String get onboardingProfileTitle => '거의 다 됐어요!';

  @override
  String get onboardingProfileSub => '학습 보고서를 위한 이메일을 추가하시겠어요?';

  @override
  String get onboardingShowLevelPicker => 'false';

  @override
  String get onboardingLevel1Label => 'KS2';

  @override
  String get onboardingLevel1Sub => '초등학교 과정';

  @override
  String get onboardingLevel2Label => 'KS3';

  @override
  String get onboardingLevel2Sub => '중학교 과정';

  @override
  String get onboardingLevel3Label => 'KS4';

  @override
  String get onboardingLevel3Sub => '고등학교 과정';

  @override
  String get onboardingLanguageLabel => '선택한 언어';

  @override
  String get onboardingLanguageValue => '한국어';

  @override
  String get onboardingParentEmailLabel => '학부모 이메일 (선택)';

  @override
  String get onboardingParentEmailHint => 'parent@example.kr';

  @override
  String get onboardingParentEmailSub => '학습 보고서 및 중요한 업데이트를 위해';

  @override
  String get onboardingPrivacyNote => '데이터는 안전하게 보호됩니다. 학습 보고서 전용. 스팸 없음.';

  @override
  String get onboardingStartLearning => '학습 시작';

  @override
  String get onboardingSkipEmail => '나중에 이메일 추가';

  @override
  String get appearanceLanguageTitle => '언어';

  @override
  String get appearanceLanguageSub => '앱 표시 언어';

  @override
  String get upgradeTitle => '프리미엄 잠금 해제';

  @override
  String get upgradeBody => '프리미엄 구독이 곧 출시됩니다.';

  @override
  String get upgradeViewPacks => '시험 팩 보기';

  @override
  String get upgradeMaybeLater => '나중에';

  @override
  String get termsTitle => '이용 약관';

  @override
  String get termsSub => '사용 전 읽어주세요';

  @override
  String get tutorCreditComingSoon => '튜터 크레딧이 곧 출시됩니다.';

  @override
  String get upgradeWhatsIncluded => '포함된 혜택';

  @override
  String get upgradeBenefit1Title => '무제한 AI 튜터';

  @override
  String get upgradeBenefit1Sub =>
      '크레딧 제한 없이 무제한으로 질문하고 단계별 설명과 맞춤형 힌트를 받아보세요.';

  @override
  String get upgradeBenefit2Title => '옥스퍼드 트랙 방식';

  @override
  String get upgradeBenefit2Sub =>
      'KS3부터 A-Level까지 체계적인 Oxford 커리큘럼과 엄선된 문제 세트로 단계적으로 학습하세요.';

  @override
  String get upgradeBenefit3Title => '심화 분석';

  @override
  String get upgradeBenefit3Sub =>
      '상세한 성과 차트, 취약 부분 감지, 맞춤형 학습 추천으로 진도를 추적하세요.';

  @override
  String get upgradeComingSoonLabel => '출시 예정';

  @override
  String get upgradeComingSoon1 => '월간 및 연간 구독 플랜';

  @override
  String get upgradeComingSoon2 => '가족 다중 프로필 계정';

  @override
  String get upgradeComingSoon3 => '일일 연속 학습 알림 및 푸시 알림';

  @override
  String get upgradeComingSoon4 => '성취 및 마일스톤 보상';

  @override
  String get upgradeJoinEarlyAccess => '얼리 액세스 참여';

  @override
  String get upgradeEarlyAccessSnackbar => '얼리 액세스 신청이 곧 시작됩니다. 기대해주세요!';

  @override
  String get profileAboutLabel => '앱 정보';

  @override
  String get profileReleaseNotes => '릴리즈 노트';

  @override
  String get tutorEmptyTitle => '아직 메시지가 없습니다';

  @override
  String get tutorEmptySubtitle => '어떤 주제든 질문하시면 AI 튜터가 단계별로 도움을 드립니다.';

  @override
  String get homeStreakDays => '5일 연속 학습';

  @override
  String get homeAchievementUnlocked => '달성';

  @override
  String get homeBadgeLocked => '잠김';

  @override
  String get homeWhatsNewTitle => 'v1.0의 새로운 기능';

  @override
  String get homeWhatsNewBody => 'AI 튜터, 옥스퍼드 트랙, GCSE 시험 팩이 출시되었습니다.';

  @override
  String get homeDailyGoalTitle => '오늘의 목표';

  @override
  String get homeDailyGoalSubtitle => '오늘 15문제 풀기';

  @override
  String get homeDailyGoalProgress => '7 / 15 완료';

  @override
  String get tutorHowItWorksTitle => '튜터 사용 방법';

  @override
  String get tutorHowItWorksStep1Title => '질문하기';

  @override
  String get tutorHowItWorksStep1Sub => '수학 문제를 입력하거나 위의 빠른 동작을 선택하세요.';

  @override
  String get tutorHowItWorksStep2Title => '단계별 답변 받기';

  @override
  String get tutorHowItWorksStep2Sub => 'AI가 모든 단계를 이해할 수 있도록 풀이를 설명해줍니다.';

  @override
  String get tutorHowItWorksStep3Title => '배운 것을 연습하기';

  @override
  String get tutorHowItWorksStep3Sub => '연습 섹션으로 이동하여 방금 배운 것을 적용해보세요.';

  @override
  String get practiceSummaryTitle => '세션 완료';

  @override
  String practiceSummaryAccuracy(int percent) {
    return '$percent% 정확도';
  }

  @override
  String practiceSummaryCorrect(int correct, int total) {
    return '$correct / $total 정답';
  }

  @override
  String get practiceSummaryEncouragement => '잘 했어요! 계속 연습하여 점수를 향상시켜보세요.';

  @override
  String get practiceSummaryClose => '연습으로 돌아가기';

  @override
  String get helpFeatureRequestButton => '기능 요청';

  @override
  String get helpFeatureRequestSnackbar => '기능 요청이 곧 시작됩니다. 관심에 감사드립니다!';

  @override
  String get helpReportSnackbar => '신고해 주셔서 감사합니다! 곧 확인하겠습니다.';
}
