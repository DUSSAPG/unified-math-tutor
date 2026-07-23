import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('da'),
    Locale('da', 'DK'),
    Locale('de'),
    Locale('de', 'CH'),
    Locale('en'),
    Locale('en', 'GB'),
    Locale('es'),
    Locale('fr'),
    Locale('fr', 'CH'),
    Locale('id'),
    Locale('it'),
    Locale('it', 'CH'),
    Locale('ko'),
    Locale('ko', 'KR'),
    Locale('nb'),
    Locale('nb', 'NO'),
    Locale('pt'),
    Locale('sv'),
    Locale('sv', 'SE')
  ];

  /// Bottom nav label for Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav label for Topics tab
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get navTopics;

  /// Bottom nav label for Practice tab
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// Bottom nav label for Profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Bottom nav label for Tutor tab
  ///
  /// In en, this message translates to:
  /// **'Tutor'**
  String get navTutor;

  /// Bottom nav label for Help tab
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// Placeholder in topics search bar
  ///
  /// In en, this message translates to:
  /// **'Search topics...'**
  String get topicsSearchHint;

  /// No description provided for @topicsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get topicsFilterAll;

  /// No description provided for @topicsFilterPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get topicsFilterPractice;

  /// No description provided for @topicsFilterRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get topicsFilterRecommended;

  /// No description provided for @topicsFilterOxfordTrack.
  ///
  /// In en, this message translates to:
  /// **'Oxford Track'**
  String get topicsFilterOxfordTrack;

  /// No description provided for @topicsFilterGcse.
  ///
  /// In en, this message translates to:
  /// **'GCSE'**
  String get topicsFilterGcse;

  /// No description provided for @topicsFilterMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get topicsFilterMore;

  /// Title of the track selection panel
  ///
  /// In en, this message translates to:
  /// **'Select Track'**
  String get topicsSelectTrack;

  /// No description provided for @topicsTrackStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get topicsTrackStandard;

  /// No description provided for @topicsTrackStandardSub.
  ///
  /// In en, this message translates to:
  /// **'Core curriculum for all Key Stages'**
  String get topicsTrackStandardSub;

  /// No description provided for @topicsTrackGcseFoundation.
  ///
  /// In en, this message translates to:
  /// **'GCSE Foundation'**
  String get topicsTrackGcseFoundation;

  /// No description provided for @topicsTrackGcseFoundationSub.
  ///
  /// In en, this message translates to:
  /// **'Foundation tier GCSE preparation'**
  String get topicsTrackGcseFoundationSub;

  /// No description provided for @topicsTrackGcseHigher.
  ///
  /// In en, this message translates to:
  /// **'GCSE Higher'**
  String get topicsTrackGcseHigher;

  /// No description provided for @topicsTrackGcseHigherSub.
  ///
  /// In en, this message translates to:
  /// **'Higher tier GCSE preparation'**
  String get topicsTrackGcseHigherSub;

  /// No description provided for @topicsTrackOxford.
  ///
  /// In en, this message translates to:
  /// **'Oxford Track'**
  String get topicsTrackOxford;

  /// No description provided for @topicsTrackOxfordSub.
  ///
  /// In en, this message translates to:
  /// **'11+ prep, stretch questions & competition math'**
  String get topicsTrackOxfordSub;

  /// No description provided for @topicsPremiumComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Premium feature'**
  String get topicsPremiumComingSoon;

  /// No description provided for @topicsPremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get topicsPremiumLabel;

  /// No description provided for @practiceChooseMode.
  ///
  /// In en, this message translates to:
  /// **'Choose your practice mode'**
  String get practiceChooseMode;

  /// Section header above practice mode cards
  ///
  /// In en, this message translates to:
  /// **'MODE'**
  String get practiceModeLabel;

  /// Section header above question count selector
  ///
  /// In en, this message translates to:
  /// **'QUESTIONS'**
  String get practiceQuestionsLabel;

  /// No description provided for @practiceStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get practiceStartButton;

  /// No description provided for @practiceModeQuickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get practiceModeQuickStart;

  /// No description provided for @practiceModeQuickStartSub.
  ///
  /// In en, this message translates to:
  /// **'Mixed review, 10 questions'**
  String get practiceModeQuickStartSub;

  /// No description provided for @practiceModeTopicDrill.
  ///
  /// In en, this message translates to:
  /// **'Topic Drill'**
  String get practiceModeTopicDrill;

  /// No description provided for @practiceModeTopicDrillSub.
  ///
  /// In en, this message translates to:
  /// **'Choose a specific topic'**
  String get practiceModeTopicDrillSub;

  /// No description provided for @practiceModeTimedChallenge.
  ///
  /// In en, this message translates to:
  /// **'Timed Challenge'**
  String get practiceModeTimedChallenge;

  /// No description provided for @practiceModeTimedChallengeSub.
  ///
  /// In en, this message translates to:
  /// **'Race against the clock'**
  String get practiceModeTimedChallengeSub;

  /// No description provided for @practiceModeExamSimulator.
  ///
  /// In en, this message translates to:
  /// **'Exam Simulator'**
  String get practiceModeExamSimulator;

  /// No description provided for @practiceModeExamSimulatorSub.
  ///
  /// In en, this message translates to:
  /// **'GCSE-style mock test'**
  String get practiceModeExamSimulatorSub;

  /// Exam Simulator subtitle naming the selected curriculum/exam
  ///
  /// In en, this message translates to:
  /// **'{examLabel}-style mock test'**
  String practiceModeExamSimulatorSubFor(String examLabel);

  /// No description provided for @practiceExamSimulatorSelectPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select an exam to begin'**
  String get practiceExamSimulatorSelectPrompt;

  /// Section header above the exam choice chips in Exam Simulator mode
  ///
  /// In en, this message translates to:
  /// **'SELECT EXAM'**
  String get practiceSelectExamLabel;

  /// No description provided for @practiceExamSwissGymnasium.
  ///
  /// In en, this message translates to:
  /// **'Swiss Gymnasium'**
  String get practiceExamSwissGymnasium;

  /// No description provided for @practiceExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get practiceExit;

  /// Question counter shown during a practice session
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String practiceQuestionOf(int current, int total);

  /// Topic pill label when topic is empty
  ///
  /// In en, this message translates to:
  /// **'Mixed Review'**
  String get practiceMixedReview;

  /// No description provided for @practiceExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get practiceExplanation;

  /// No description provided for @practiceCheckAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get practiceCheckAnswer;

  /// No description provided for @practiceNextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question →'**
  String get practiceNextQuestion;

  /// No description provided for @practiceFinishSession.
  ///
  /// In en, this message translates to:
  /// **'Finish Session'**
  String get practiceFinishSession;

  /// No description provided for @tutorBotName.
  ///
  /// In en, this message translates to:
  /// **'TutorBot'**
  String get tutorBotName;

  /// No description provided for @tutorBotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get hints, explanations and step-by-step support.'**
  String get tutorBotSubtitle;

  /// Usage pill showing remaining free tips
  ///
  /// In en, this message translates to:
  /// **'Free tips left today: {count}'**
  String tutorFreeTipsLeft(int count);

  /// No description provided for @tutorChipExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain this'**
  String get tutorChipExplain;

  /// No description provided for @tutorChipHint.
  ///
  /// In en, this message translates to:
  /// **'Give me a hint'**
  String get tutorChipHint;

  /// No description provided for @tutorChipSteps.
  ///
  /// In en, this message translates to:
  /// **'Show steps'**
  String get tutorChipSteps;

  /// No description provided for @tutorChipCheckMistake.
  ///
  /// In en, this message translates to:
  /// **'Check my mistake'**
  String get tutorChipCheckMistake;

  /// No description provided for @tutorInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask TutorBot a question...'**
  String get tutorInputHint;

  /// No description provided for @tutorNeedMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need more help?'**
  String get tutorNeedMoreHelp;

  /// No description provided for @tutorUnlockDeeper.
  ///
  /// In en, this message translates to:
  /// **'Unlock deeper explanations with Tutor credits or a paid math pack.'**
  String get tutorUnlockDeeper;

  /// No description provided for @tutorBuyCredits.
  ///
  /// In en, this message translates to:
  /// **'Buy Tutor Credits'**
  String get tutorBuyCredits;

  /// No description provided for @tutorViewPacks.
  ///
  /// In en, this message translates to:
  /// **'View Packs'**
  String get tutorViewPacks;

  /// No description provided for @profileSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get profileSettingsLabel;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileAppearanceSub.
  ///
  /// In en, this message translates to:
  /// **'Theme and visual settings'**
  String get profileAppearanceSub;

  /// No description provided for @profileAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get profileAccessibility;

  /// No description provided for @profileAccessibilitySub.
  ///
  /// In en, this message translates to:
  /// **'Text size, contrast & animations'**
  String get profileAccessibilitySub;

  /// No description provided for @profileSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get profileSubscription;

  /// No description provided for @profileSubscriptionSub.
  ///
  /// In en, this message translates to:
  /// **'Manage your plan'**
  String get profileSubscriptionSub;

  /// No description provided for @profileCurriculumSettings.
  ///
  /// In en, this message translates to:
  /// **'Curriculum Settings'**
  String get profileCurriculumSettings;

  /// No description provided for @profileCurriculumSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'KS2 · School Support · ks2'**
  String get profileCurriculumSettingsSub;

  /// No description provided for @profilePrivacyData.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get profilePrivacyData;

  /// No description provided for @profilePrivacyDataSub.
  ///
  /// In en, this message translates to:
  /// **'GDPR compliant · No ads · No third-party sharing'**
  String get profilePrivacyDataSub;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOut;

  /// No description provided for @profileSignOutSub.
  ///
  /// In en, this message translates to:
  /// **'Clear session and return to welcome'**
  String get profileSignOutSub;

  /// No description provided for @profileVersionNumber.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String profileVersionNumber(String version);

  /// No description provided for @profileCopyright.
  ///
  /// In en, this message translates to:
  /// **'© QuantumLab Intelligence'**
  String get profileCopyright;

  /// No description provided for @profileHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileHeaderTitle;

  /// No description provided for @profileHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & preferences'**
  String get profileHeaderSubtitle;

  /// No description provided for @profilePreferredDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Preferred Display Name'**
  String get profilePreferredDisplayName;

  /// No description provided for @profilePreferredDisplayNameNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profilePreferredDisplayNameNotSet;

  /// No description provided for @profileChangeDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Change Display Name'**
  String get profileChangeDisplayName;

  /// No description provided for @profileGreetingPreview.
  ///
  /// In en, this message translates to:
  /// **'Greeting Preview'**
  String get profileGreetingPreview;

  /// No description provided for @profileSwitchLearner.
  ///
  /// In en, this message translates to:
  /// **'Switch Learner'**
  String get profileSwitchLearner;

  /// No description provided for @profileDisplayNameDialogHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sam or a nickname'**
  String get profileDisplayNameDialogHint;

  /// No description provided for @whoIsLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Who\'s learning today?'**
  String get whoIsLearningTitle;

  /// No description provided for @whoIsLearningAddLearner.
  ///
  /// In en, this message translates to:
  /// **'Add Learner'**
  String get whoIsLearningAddLearner;

  /// No description provided for @whoIsLearningAddLearnerHint.
  ///
  /// In en, this message translates to:
  /// **'Learner\'s name'**
  String get whoIsLearningAddLearnerHint;

  /// No description provided for @homeLearningAsLabel.
  ///
  /// In en, this message translates to:
  /// **'Learning as: {name}'**
  String homeLearningAsLabel(String name);

  /// No description provided for @homeSwitchLearnerAction.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get homeSwitchLearnerAction;

  /// No description provided for @helpHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpHeaderTitle;

  /// No description provided for @helpHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support, safety & app information'**
  String get helpHeaderSubtitle;

  /// No description provided for @helpFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get helpFaqTitle;

  /// No description provided for @helpFaq1Q.
  ///
  /// In en, this message translates to:
  /// **'How does the Key Stage selection work?'**
  String get helpFaq1Q;

  /// No description provided for @helpFaq1A.
  ///
  /// In en, this message translates to:
  /// **'During onboarding you choose your Key Stage (KS2–KS5). This tailors topics, difficulty, and exam packs to your curriculum level. You can change it anytime in Curriculum Settings.'**
  String get helpFaq1A;

  /// No description provided for @helpFaq2Q.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get helpFaq2Q;

  /// No description provided for @helpFaq2A.
  ///
  /// In en, this message translates to:
  /// **'Yes. We collect only what is needed to personalize your learning. No data is sold or shared with third parties. All data is deletable at any time.'**
  String get helpFaq2A;

  /// No description provided for @helpFaq3Q.
  ///
  /// In en, this message translates to:
  /// **'Can I add multiple children?'**
  String get helpFaq3Q;

  /// No description provided for @helpFaq3A.
  ///
  /// In en, this message translates to:
  /// **'Currently each installation supports one learner profile. Learning Analytics and progress reports are available from More or Profile.'**
  String get helpFaq3A;

  /// No description provided for @helpFaq4Q.
  ///
  /// In en, this message translates to:
  /// **'How do GCSE exam packs work?'**
  String get helpFaq4Q;

  /// No description provided for @helpFaq4A.
  ///
  /// In en, this message translates to:
  /// **'Exam packs are curated sets of past-paper style questions grouped by topic and difficulty tier. Tap Practice → Exam Simulator to start a GCSE-style timed session.'**
  String get helpFaq4A;

  /// No description provided for @helpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get helpContactTitle;

  /// No description provided for @helpContactIntro.
  ///
  /// In en, this message translates to:
  /// **'For questions or issues, contact us:'**
  String get helpContactIntro;

  /// No description provided for @helpContactEmail.
  ///
  /// In en, this message translates to:
  /// **'support@mathtutor.app'**
  String get helpContactEmail;

  /// No description provided for @helpPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Safety'**
  String get helpPrivacyTitle;

  /// No description provided for @helpPrivacyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Minimal data. No ads. GDPR compliant.'**
  String get helpPrivacyHeadline;

  /// No description provided for @helpPrivacyBullet1.
  ///
  /// In en, this message translates to:
  /// **'We only collect necessary data'**
  String get helpPrivacyBullet1;

  /// No description provided for @helpPrivacyBullet2.
  ///
  /// In en, this message translates to:
  /// **'No sharing with third parties'**
  String get helpPrivacyBullet2;

  /// No description provided for @helpPrivacyBullet3.
  ///
  /// In en, this message translates to:
  /// **'Learning Analytics available'**
  String get helpPrivacyBullet3;

  /// No description provided for @helpPrivacyBullet4.
  ///
  /// In en, this message translates to:
  /// **'Deletable at any time'**
  String get helpPrivacyBullet4;

  /// No description provided for @helpTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get helpTermsTitle;

  /// No description provided for @helpTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Free for students and parents. By using Math Intelligence you agree to our terms of service. No payment is required for standard access.'**
  String get helpTermsBody;

  /// No description provided for @helpParentalTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Analytics'**
  String get helpParentalTitle;

  /// No description provided for @helpParentalHeadline.
  ///
  /// In en, this message translates to:
  /// **'Understand progress, identify learning gaps and support the next step.'**
  String get helpParentalHeadline;

  /// No description provided for @helpParentalBullet1.
  ///
  /// In en, this message translates to:
  /// **'Progress Overview'**
  String get helpParentalBullet1;

  /// No description provided for @helpParentalBullet2.
  ///
  /// In en, this message translates to:
  /// **'Topic Mastery'**
  String get helpParentalBullet2;

  /// No description provided for @helpParentalBullet3.
  ///
  /// In en, this message translates to:
  /// **'Learning Trends'**
  String get helpParentalBullet3;

  /// No description provided for @helpParentalBullet4.
  ///
  /// In en, this message translates to:
  /// **'Recommended Practice'**
  String get helpParentalBullet4;

  /// No description provided for @helpReportButton.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get helpReportButton;

  /// No description provided for @helpFooter.
  ///
  /// In en, this message translates to:
  /// **'Minimal data. No ads. Learning Analytics available.'**
  String get helpFooter;

  /// No description provided for @swissChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switzerland • Choose language'**
  String get swissChooseLanguage;

  /// No description provided for @tutorChipDeepExplanation.
  ///
  /// In en, this message translates to:
  /// **'Deep Explanation'**
  String get tutorChipDeepExplanation;

  /// No description provided for @tutorChipStepByStep.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step'**
  String get tutorChipStepByStep;

  /// No description provided for @tutorChipMistakeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Mistake Analysis'**
  String get tutorChipMistakeAnalysis;

  /// No description provided for @tutorCreditBadge.
  ///
  /// In en, this message translates to:
  /// **'1 credit'**
  String get tutorCreditBadge;

  /// Credit balance displayed in the usage pill
  ///
  /// In en, this message translates to:
  /// **'{count} credits'**
  String tutorCreditBalance(int count);

  /// No description provided for @tutorProLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get tutorProLabel;

  /// No description provided for @tutorExhaustedTitle.
  ///
  /// In en, this message translates to:
  /// **'Free tips used up'**
  String get tutorExhaustedTitle;

  /// No description provided for @tutorExhaustedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all 3 free tips. Buy credits or upgrade to continue.'**
  String get tutorExhaustedBody;

  /// No description provided for @tutorCreditRequired.
  ///
  /// In en, this message translates to:
  /// **'Requires 1 credit'**
  String get tutorCreditRequired;

  /// No description provided for @tutorPracticeContextLabel.
  ///
  /// In en, this message translates to:
  /// **'Practising'**
  String get tutorPracticeContextLabel;

  /// No description provided for @tutorContextHint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get tutorContextHint;

  /// No description provided for @tutorContextExplain.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get tutorContextExplain;

  /// Home screen greeting, 05:00-11:59, with a preferred display name
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String homeGreetingMorningNamed(String name);

  /// Home screen greeting, 05:00-11:59, no name on file
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorningDefault;

  /// Home screen greeting, 12:00-17:59, with a preferred display name
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String homeGreetingAfternoonNamed(String name);

  /// Home screen greeting, 12:00-17:59, no name on file
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoonDefault;

  /// Home screen greeting, 18:00-22:59, with a preferred display name
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String homeGreetingEveningNamed(String name);

  /// Home screen greeting, 18:00-22:59, no name on file
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEveningDefault;

  /// Home screen greeting, 23:00-04:59, with a preferred display name
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String homeGreetingNightNamed(String name);

  /// Home screen greeting, 23:00-04:59, no name on file
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeGreetingNightDefault;

  /// No description provided for @homeStreakGoalMessage.
  ///
  /// In en, this message translates to:
  /// **'· 10 minutes to hit your streak goal'**
  String get homeStreakGoalMessage;

  /// No description provided for @homeSectionContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get homeSectionContinueLearning;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeSectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get homeSectionProgress;

  /// No description provided for @homeStreakHeader.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get homeStreakHeader;

  /// No description provided for @homeStreakFirstDay.
  ///
  /// In en, this message translates to:
  /// **'First day of your streak'**
  String get homeStreakFirstDay;

  /// No description provided for @homeThisWeekHeader.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get homeThisWeekHeader;

  /// No description provided for @homeDaysActive.
  ///
  /// In en, this message translates to:
  /// **'Days active'**
  String get homeDaysActive;

  /// No description provided for @homeSectionAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get homeSectionAchievements;

  /// No description provided for @homeAchievementStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly streak reached!'**
  String get homeAchievementStreakTitle;

  /// No description provided for @homeAchievementStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'7 days of learning in a row'**
  String get homeAchievementStreakSubtitle;

  /// No description provided for @homeAchievementStreakLocked.
  ///
  /// In en, this message translates to:
  /// **'Reach a 7-day streak to unlock this'**
  String get homeAchievementStreakLocked;

  /// No description provided for @homeSectionOxfordTrack.
  ///
  /// In en, this message translates to:
  /// **'Oxford Track'**
  String get homeSectionOxfordTrack;

  /// No description provided for @homePremiumRequired.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM REQUIRED'**
  String get homePremiumRequired;

  /// No description provided for @homeOxfordTrackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'11+ prep, advanced challenges & competition math'**
  String get homeOxfordTrackSubtitle;

  /// No description provided for @homeSectionLearningPaths.
  ///
  /// In en, this message translates to:
  /// **'Learning Paths'**
  String get homeSectionLearningPaths;

  /// No description provided for @homeSectionExamPacks.
  ///
  /// In en, this message translates to:
  /// **'Exam Packs'**
  String get homeSectionExamPacks;

  /// No description provided for @homeExamPacksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Targeted exam preparation'**
  String get homeExamPacksSubtitle;

  /// No description provided for @homeViewExamPacks.
  ///
  /// In en, this message translates to:
  /// **'View Exam Packs'**
  String get homeViewExamPacks;

  /// No description provided for @homeStartPracticeSession.
  ///
  /// In en, this message translates to:
  /// **'Start Practice Session'**
  String get homeStartPracticeSession;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Develop mathematical thinking.\nUnlock your potential.'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalised learning. Measurable progress.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingWhoLabel.
  ///
  /// In en, this message translates to:
  /// **'WHO IS USING THE APP?'**
  String get onboardingWhoLabel;

  /// No description provided for @onboardingStudentLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Learner'**
  String get onboardingStudentLabel;

  /// No description provided for @onboardingStudentSub.
  ///
  /// In en, this message translates to:
  /// **'Practice mathematics with a learning journey designed around you.'**
  String get onboardingStudentSub;

  /// No description provided for @onboardingParentLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'m supporting a learner'**
  String get onboardingParentLabel;

  /// No description provided for @onboardingParentSub.
  ///
  /// In en, this message translates to:
  /// **'Support every step of a learner\'s mathematical development.'**
  String get onboardingParentSub;

  /// No description provided for @onboardingTeacherLabel.
  ///
  /// In en, this message translates to:
  /// **'I\'m a teacher'**
  String get onboardingTeacherLabel;

  /// No description provided for @onboardingTeacherSub.
  ///
  /// In en, this message translates to:
  /// **'Monitor progress and assign practice for your students.'**
  String get onboardingTeacherSub;

  /// No description provided for @onboardingSelectError.
  ///
  /// In en, this message translates to:
  /// **'Please select an option'**
  String get onboardingSelectError;

  /// No description provided for @onboardingSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get onboardingSignInPrompt;

  /// No description provided for @onboardingSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get onboardingSignIn;

  /// No description provided for @onboardingGuestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest Mode'**
  String get onboardingGuestMode;

  /// No description provided for @onboardingGuestModeSub.
  ///
  /// In en, this message translates to:
  /// **'Try a limited practice session.'**
  String get onboardingGuestModeSub;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingFooter.
  ///
  /// In en, this message translates to:
  /// **'Minimal data. No ads. Learning Analytics available.'**
  String get onboardingFooter;

  /// No description provided for @onboardingAccessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Make it comfortable to read'**
  String get onboardingAccessibilityTitle;

  /// No description provided for @onboardingAccessibilitySub.
  ///
  /// In en, this message translates to:
  /// **'You can change these anytime in Settings.'**
  String get onboardingAccessibilitySub;

  /// No description provided for @onboardingStageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your level'**
  String get onboardingStageTitle;

  /// No description provided for @onboardingStageSub.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor the content to the right level'**
  String get onboardingStageSub;

  /// No description provided for @onboardingStageTitleParent.
  ///
  /// In en, this message translates to:
  /// **'Choose the learner\'s level'**
  String get onboardingStageTitleParent;

  /// No description provided for @onboardingStageSubParent.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor content to the learner\'s current level.'**
  String get onboardingStageSubParent;

  /// Number of stage options to display — varies by market
  ///
  /// In en, this message translates to:
  /// **'4'**
  String get onboardingStageCount;

  /// No description provided for @onboardingStage1Label.
  ///
  /// In en, this message translates to:
  /// **'KS2 (Years 3–6)'**
  String get onboardingStage1Label;

  /// No description provided for @onboardingStage1Sub.
  ///
  /// In en, this message translates to:
  /// **'Primary school math'**
  String get onboardingStage1Sub;

  /// No description provided for @onboardingStage2Label.
  ///
  /// In en, this message translates to:
  /// **'KS3 (Years 7–9)'**
  String get onboardingStage2Label;

  /// No description provided for @onboardingStage2Sub.
  ///
  /// In en, this message translates to:
  /// **'Secondary school math'**
  String get onboardingStage2Sub;

  /// No description provided for @onboardingStage3Label.
  ///
  /// In en, this message translates to:
  /// **'KS4 GCSE (Years 10–11)'**
  String get onboardingStage3Label;

  /// No description provided for @onboardingStage3Sub.
  ///
  /// In en, this message translates to:
  /// **'GCSE math preparation'**
  String get onboardingStage3Sub;

  /// No description provided for @onboardingStage4Label.
  ///
  /// In en, this message translates to:
  /// **'KS5 (Years 12–13)'**
  String get onboardingStage4Label;

  /// No description provided for @onboardingStage4Sub.
  ///
  /// In en, this message translates to:
  /// **'Advanced math'**
  String get onboardingStage4Sub;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s the goal?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the learning focus'**
  String get onboardingGoalSub;

  /// No description provided for @onboardingGoalTitleParent.
  ///
  /// In en, this message translates to:
  /// **'How would you like to support them?'**
  String get onboardingGoalTitleParent;

  /// No description provided for @onboardingGoalSubParent.
  ///
  /// In en, this message translates to:
  /// **'Choose the support focus for this learner.'**
  String get onboardingGoalSubParent;

  /// No description provided for @onboardingGoal1Label.
  ///
  /// In en, this message translates to:
  /// **'Build confidence'**
  String get onboardingGoal1Label;

  /// No description provided for @onboardingGoal1Sub.
  ///
  /// In en, this message translates to:
  /// **'Steady, low-pressure practice at your own pace'**
  String get onboardingGoal1Sub;

  /// No description provided for @onboardingGoal2Label.
  ///
  /// In en, this message translates to:
  /// **'Improve school maths'**
  String get onboardingGoal2Label;

  /// No description provided for @onboardingGoal2Sub.
  ///
  /// In en, this message translates to:
  /// **'Strengthen everyday classroom topics'**
  String get onboardingGoal2Sub;

  /// No description provided for @onboardingGoal3Label.
  ///
  /// In en, this message translates to:
  /// **'Prepare for exams'**
  String get onboardingGoal3Label;

  /// No description provided for @onboardingGoal3Sub.
  ///
  /// In en, this message translates to:
  /// **'Targeted GCSE practice & timed sets'**
  String get onboardingGoal3Sub;

  /// No description provided for @onboardingGoal4Label.
  ///
  /// In en, this message translates to:
  /// **'Challenge myself'**
  String get onboardingGoal4Label;

  /// No description provided for @onboardingGoal4Sub.
  ///
  /// In en, this message translates to:
  /// **'Stretch challenges and advanced problems'**
  String get onboardingGoal4Sub;

  /// No description provided for @onboardingParentGoal1Label.
  ///
  /// In en, this message translates to:
  /// **'Help build mathematical confidence'**
  String get onboardingParentGoal1Label;

  /// No description provided for @onboardingParentGoal1Sub.
  ///
  /// In en, this message translates to:
  /// **'Support steady, low-pressure practice at the learner\'s pace.'**
  String get onboardingParentGoal1Sub;

  /// No description provided for @onboardingParentGoal2Label.
  ///
  /// In en, this message translates to:
  /// **'Identify learning gaps'**
  String get onboardingParentGoal2Label;

  /// No description provided for @onboardingParentGoal2Sub.
  ///
  /// In en, this message translates to:
  /// **'Spot topics that need more attention before they become blockers.'**
  String get onboardingParentGoal2Sub;

  /// No description provided for @onboardingParentGoal3Label.
  ///
  /// In en, this message translates to:
  /// **'Track progress over time'**
  String get onboardingParentGoal3Label;

  /// No description provided for @onboardingParentGoal3Sub.
  ///
  /// In en, this message translates to:
  /// **'Follow growth and consistency across completed practice.'**
  String get onboardingParentGoal3Sub;

  /// No description provided for @onboardingParentGoal4Label.
  ///
  /// In en, this message translates to:
  /// **'Support exam preparation'**
  String get onboardingParentGoal4Label;

  /// No description provided for @onboardingParentGoal4Sub.
  ///
  /// In en, this message translates to:
  /// **'Guide revision and practice for upcoming assessments.'**
  String get onboardingParentGoal4Sub;

  /// No description provided for @onboardingGoalTitleTeacher.
  ///
  /// In en, this message translates to:
  /// **'How would you like to use Math Intelligence?'**
  String get onboardingGoalTitleTeacher;

  /// No description provided for @onboardingGoalSubTeacher.
  ///
  /// In en, this message translates to:
  /// **'Choose the focus for your class.'**
  String get onboardingGoalSubTeacher;

  /// No description provided for @onboardingTeacherGoal1Label.
  ///
  /// In en, this message translates to:
  /// **'Monitor class progress'**
  String get onboardingTeacherGoal1Label;

  /// No description provided for @onboardingTeacherGoal1Sub.
  ///
  /// In en, this message translates to:
  /// **'See how your students are progressing over time.'**
  String get onboardingTeacherGoal1Sub;

  /// No description provided for @onboardingTeacherGoal2Label.
  ///
  /// In en, this message translates to:
  /// **'Assign practice'**
  String get onboardingTeacherGoal2Label;

  /// No description provided for @onboardingTeacherGoal2Sub.
  ///
  /// In en, this message translates to:
  /// **'Set targeted practice sets for your students.'**
  String get onboardingTeacherGoal2Sub;

  /// No description provided for @onboardingTeacherGoal3Label.
  ///
  /// In en, this message translates to:
  /// **'Prepare for exams'**
  String get onboardingTeacherGoal3Label;

  /// No description provided for @onboardingTeacherGoal3Sub.
  ///
  /// In en, this message translates to:
  /// **'Support exam readiness with focused practice sets.'**
  String get onboardingTeacherGoal3Sub;

  /// No description provided for @onboardingTeacherGoal4Label.
  ///
  /// In en, this message translates to:
  /// **'Explore the curriculum'**
  String get onboardingTeacherGoal4Label;

  /// No description provided for @onboardingTeacherGoal4Sub.
  ///
  /// In en, this message translates to:
  /// **'Browse topics and worked solutions before assigning them.'**
  String get onboardingTeacherGoal4Sub;

  /// No description provided for @onboardingProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get onboardingProfileTitle;

  /// No description provided for @onboardingProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Optional — you can always change this later in Profile.'**
  String get onboardingProfileSub;

  /// No description provided for @onboardingDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingDisplayNameLabel;

  /// No description provided for @onboardingDisplayNameSub.
  ///
  /// In en, this message translates to:
  /// **'A nickname is fine — this is just for your greeting.'**
  String get onboardingDisplayNameSub;

  /// No description provided for @onboardingDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alex'**
  String get onboardingDisplayNameHint;

  /// No description provided for @onboardingLearnerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'What should we call your learner?'**
  String get onboardingLearnerNameLabel;

  /// No description provided for @onboardingLearnerNameSub.
  ///
  /// In en, this message translates to:
  /// **'Personalise their Maths Journey.'**
  String get onboardingLearnerNameSub;

  /// No description provided for @onboardingLearnerNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alex'**
  String get onboardingLearnerNameHint;

  /// No description provided for @onboardingRelationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Your relationship to the learner'**
  String get onboardingRelationshipLabel;

  /// No description provided for @onboardingRelationshipParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get onboardingRelationshipParent;

  /// No description provided for @onboardingRelationshipGuardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get onboardingRelationshipGuardian;

  /// No description provided for @onboardingRelationshipGrandparent.
  ///
  /// In en, this message translates to:
  /// **'Grandparent'**
  String get onboardingRelationshipGrandparent;

  /// No description provided for @onboardingRelationshipTutor.
  ///
  /// In en, this message translates to:
  /// **'Tutor'**
  String get onboardingRelationshipTutor;

  /// No description provided for @onboardingRelationshipOther.
  ///
  /// In en, this message translates to:
  /// **'Other family member'**
  String get onboardingRelationshipOther;

  /// No description provided for @onboardingParentEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Supporting adult email (optional)'**
  String get onboardingParentEmailLabel;

  /// No description provided for @onboardingParentEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get onboardingParentEmailHint;

  /// No description provided for @onboardingParentEmailSub.
  ///
  /// In en, this message translates to:
  /// **'Stored locally on this device for account clarity.'**
  String get onboardingParentEmailSub;

  /// No description provided for @onboardingPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Local-only profile details. No cloud sync is claimed for this release.'**
  String get onboardingPrivacyNote;

  /// No description provided for @onboardingStartLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get onboardingStartLearning;

  /// No description provided for @onboardingSkipEmail.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkipEmail;

  /// No description provided for @appearanceLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appearanceLanguageTitle;

  /// No description provided for @appearanceLanguageSub.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get appearanceLanguageSub;

  /// No description provided for @upgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get upgradeTitle;

  /// No description provided for @upgradeBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium features with a subscription.'**
  String get upgradeBody;

  /// No description provided for @upgradeViewPacks.
  ///
  /// In en, this message translates to:
  /// **'View Exam Packs'**
  String get upgradeViewPacks;

  /// No description provided for @upgradeMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get upgradeMaybeLater;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsTitle;

  /// No description provided for @termsSub.
  ///
  /// In en, this message translates to:
  /// **'Please read before using this app'**
  String get termsSub;

  /// No description provided for @tutorCreditComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Available in exam packs.'**
  String get tutorCreditComingSoon;

  /// No description provided for @upgradeWhatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What you\'ll get'**
  String get upgradeWhatsIncluded;

  /// No description provided for @upgradeBenefit1Title.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI Tutor'**
  String get upgradeBenefit1Title;

  /// No description provided for @upgradeBenefit1Sub.
  ///
  /// In en, this message translates to:
  /// **'Ask unlimited questions, get step-by-step explanations, and receive personalized hints without credit limits.'**
  String get upgradeBenefit1Sub;

  /// No description provided for @upgradeBenefit2Title.
  ///
  /// In en, this message translates to:
  /// **'Oxford-Style Track'**
  String get upgradeBenefit2Title;

  /// No description provided for @upgradeBenefit2Sub.
  ///
  /// In en, this message translates to:
  /// **'Access the structured Oxford curriculum track with curated problem sets and guided progression from KS3 to A-Level.'**
  String get upgradeBenefit2Sub;

  /// No description provided for @upgradeBenefit3Title.
  ///
  /// In en, this message translates to:
  /// **'Learning Analytics'**
  String get upgradeBenefit3Title;

  /// No description provided for @upgradeBenefit3Sub.
  ///
  /// In en, this message translates to:
  /// **'Track your progress with detailed performance charts, weakness detection, and personalized study recommendations.'**
  String get upgradeBenefit3Sub;

  /// No description provided for @upgradeComingSoonLabel.
  ///
  /// In en, this message translates to:
  /// **'Included in Premium'**
  String get upgradeComingSoonLabel;

  /// No description provided for @upgradeComingSoon1.
  ///
  /// In en, this message translates to:
  /// **'Monthly & annual subscription plans'**
  String get upgradeComingSoon1;

  /// No description provided for @upgradeComingSoon2.
  ///
  /// In en, this message translates to:
  /// **'Multi-profile family accounts'**
  String get upgradeComingSoon2;

  /// No description provided for @upgradeComingSoon3.
  ///
  /// In en, this message translates to:
  /// **'Daily streak reminders & push notifications'**
  String get upgradeComingSoon3;

  /// No description provided for @upgradeComingSoon4.
  ///
  /// In en, this message translates to:
  /// **'Achievements and milestone rewards'**
  String get upgradeComingSoon4;

  /// No description provided for @upgradeJoinEarlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Join Early Access'**
  String get upgradeJoinEarlyAccess;

  /// No description provided for @upgradeEarlyAccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Early access sign-up is coming soon. Stay tuned!'**
  String get upgradeEarlyAccessSnackbar;

  /// No description provided for @profileAboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profileAboutLabel;

  /// No description provided for @profileReleaseNotes.
  ///
  /// In en, this message translates to:
  /// **'Release Notes'**
  String get profileReleaseNotes;

  /// No description provided for @tutorEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get tutorEmptyTitle;

  /// No description provided for @tutorEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a question about any topic and your AI tutor will help you step by step.'**
  String get tutorEmptySubtitle;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'5 Day Streak'**
  String get homeStreakDays;

  /// No description provided for @homeAchievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get homeAchievementUnlocked;

  /// No description provided for @homeBadgeLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get homeBadgeLocked;

  /// No description provided for @homeWhatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s New in v1.0'**
  String get homeWhatsNewTitle;

  /// No description provided for @homeWhatsNewBody.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor, Oxford Track, and GCSE exam packs are now live.'**
  String get homeWhatsNewBody;

  /// No description provided for @homeDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get homeDailyGoalTitle;

  /// No description provided for @homeDailyGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Solve 15 questions today'**
  String get homeDailyGoalSubtitle;

  /// No description provided for @homeDailyGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} / {target} completed'**
  String homeDailyGoalProgress(int completed, int target);

  /// No description provided for @tutorHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How Tutor Works'**
  String get tutorHowItWorksTitle;

  /// No description provided for @tutorHowItWorksStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Ask any question'**
  String get tutorHowItWorksStep1Title;

  /// No description provided for @tutorHowItWorksStep1Sub.
  ///
  /// In en, this message translates to:
  /// **'Type a math question or tap a quick action above.'**
  String get tutorHowItWorksStep1Sub;

  /// No description provided for @tutorHowItWorksStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Get a step-by-step answer'**
  String get tutorHowItWorksStep2Title;

  /// No description provided for @tutorHowItWorksStep2Sub.
  ///
  /// In en, this message translates to:
  /// **'The AI breaks down the solution so you understand every step.'**
  String get tutorHowItWorksStep2Sub;

  /// No description provided for @tutorHowItWorksStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Practice what you learn'**
  String get tutorHowItWorksStep3Title;

  /// No description provided for @tutorHowItWorksStep3Sub.
  ///
  /// In en, this message translates to:
  /// **'Head to Practice to apply what you\'ve just learned.'**
  String get tutorHowItWorksStep3Sub;

  /// No description provided for @practiceSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get practiceSummaryTitle;

  /// No description provided for @practiceSummaryAccuracy.
  ///
  /// In en, this message translates to:
  /// **'{percent}% accuracy'**
  String practiceSummaryAccuracy(int percent);

  /// No description provided for @practiceSummaryCorrect.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total} correct'**
  String practiceSummaryCorrect(int correct, int total);

  /// No description provided for @practiceSummaryEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Great work! Keep practising to improve your score.'**
  String get practiceSummaryEncouragement;

  /// No description provided for @practiceSummaryClose.
  ///
  /// In en, this message translates to:
  /// **'Back to Practice'**
  String get practiceSummaryClose;

  /// No description provided for @helpFeatureRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Request a Feature'**
  String get helpFeatureRequestButton;

  /// No description provided for @helpFeatureRequestSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Feature requests coming soon — thanks for your interest!'**
  String get helpFeatureRequestSnackbar;

  /// No description provided for @helpReportSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your report! We\'ll look into it soon.'**
  String get helpReportSnackbar;

  /// No description provided for @mentalMathVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Math Vault'**
  String get mentalMathVaultTitle;

  /// No description provided for @mentalMathVaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn powerful calculation shortcuts'**
  String get mentalMathVaultSubtitle;

  /// No description provided for @homeFormulaLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Formula Library'**
  String get homeFormulaLibraryTitle;

  /// No description provided for @homeFormulaLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick reference for key maths formulas'**
  String get homeFormulaLibrarySubtitle;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @dailyBrainTeaser.
  ///
  /// In en, this message translates to:
  /// **'Daily Brain Teaser'**
  String get dailyBrainTeaser;

  /// No description provided for @revealAnswer.
  ///
  /// In en, this message translates to:
  /// **'Reveal Answer'**
  String get revealAnswer;

  /// No description provided for @captainNumberFuel.
  ///
  /// In en, this message translates to:
  /// **'Captain Number Fuel'**
  String get captainNumberFuel;

  /// No description provided for @dailyMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Captain Number needs fuel!'**
  String get dailyMissionTitle;

  /// No description provided for @dailyMissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Solve 5 questions to power today\'s mission.'**
  String get dailyMissionSubtitle;

  /// No description provided for @workedExample.
  ///
  /// In en, this message translates to:
  /// **'Worked example'**
  String get workedExample;

  /// No description provided for @practiceExample.
  ///
  /// In en, this message translates to:
  /// **'Practice example'**
  String get practiceExample;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @practiceNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No practice questions are available.'**
  String get practiceNoQuestions;

  /// No description provided for @practiceTopicDrillEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions found for this topic at this stage yet. Try a different topic or stage.'**
  String get practiceTopicDrillEmpty;

  /// No description provided for @mascotGreeting.
  ///
  /// In en, this message translates to:
  /// **'Ready to power up your maths?'**
  String get mascotGreeting;

  /// No description provided for @mascotThinking.
  ///
  /// In en, this message translates to:
  /// **'Take your time. Think it through!'**
  String get mascotThinking;

  /// No description provided for @mascotSuccess.
  ///
  /// In en, this message translates to:
  /// **'Great calculation! Fuel added.'**
  String get mascotSuccess;

  /// No description provided for @mascotEncouragement.
  ///
  /// In en, this message translates to:
  /// **'Good try. The next one is yours!'**
  String get mascotEncouragement;

  /// No description provided for @mascotLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Mission powered! Captain Number is ready!'**
  String get mascotLevelUp;

  /// No description provided for @homeTopicFractionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fractions & Percentages'**
  String get homeTopicFractionsTitle;

  /// No description provided for @homeTopicFractionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basics & conversion'**
  String get homeTopicFractionsSubtitle;

  /// No description provided for @homeTopicAlgebraTitle.
  ///
  /// In en, this message translates to:
  /// **'Algebra Basics'**
  String get homeTopicAlgebraTitle;

  /// No description provided for @homeTopicAlgebraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Equations & variables'**
  String get homeTopicAlgebraSubtitle;

  /// No description provided for @homeTopicStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics & Probability'**
  String get homeTopicStatisticsTitle;

  /// No description provided for @homeTopicStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data handling & chance'**
  String get homeTopicStatisticsSubtitle;

  /// No description provided for @homeLearningFractionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get homeLearningFractionsTitle;

  /// No description provided for @homeLearningFractionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn fractions and conversions'**
  String get homeLearningFractionsSubtitle;

  /// No description provided for @homeLearningStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get homeLearningStatisticsTitle;

  /// No description provided for @homeLearningStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction to data and probability'**
  String get homeLearningStatisticsSubtitle;

  /// No description provided for @topicsStandardSelected.
  ///
  /// In en, this message translates to:
  /// **'Standard track selected.'**
  String get topicsStandardSelected;

  /// No description provided for @topicsNoResults.
  ///
  /// In en, this message translates to:
  /// **'No topics found'**
  String get topicsNoResults;

  /// No description provided for @topicsClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get topicsClearFilters;

  /// No description provided for @examPacksCtaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock GCSE Foundation, GCSE Higher, Oxford Track and Tutor Credits.'**
  String get examPacksCtaSubtitle;

  /// No description provided for @examPacksIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose a pack to unlock focused practice and Tutor support.'**
  String get examPacksIntro;

  /// No description provided for @examPackSelected.
  ///
  /// In en, this message translates to:
  /// **'{stage} selected'**
  String examPackSelected(String stage);

  /// No description provided for @examPackKs2Title.
  ///
  /// In en, this message translates to:
  /// **'KS2 Maths'**
  String get examPackKs2Title;

  /// No description provided for @examPackKs3Title.
  ///
  /// In en, this message translates to:
  /// **'KS3 Maths'**
  String get examPackKs3Title;

  /// No description provided for @examPackKs4Title.
  ///
  /// In en, this message translates to:
  /// **'KS4 GCSE Maths'**
  String get examPackKs4Title;

  /// No description provided for @examPackKs5Title.
  ///
  /// In en, this message translates to:
  /// **'KS5 Maths'**
  String get examPackKs5Title;

  /// No description provided for @examPackPrimarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Primary school practice'**
  String get examPackPrimarySubtitle;

  /// No description provided for @examPackSecondarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secondary school practice'**
  String get examPackSecondarySubtitle;

  /// No description provided for @examPackGcseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GCSE preparation'**
  String get examPackGcseSubtitle;

  /// No description provided for @examPackAdvancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced maths practice'**
  String get examPackAdvancedSubtitle;

  /// No description provided for @examPackTutorCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tutor Credits'**
  String get examPackTutorCreditsTitle;

  /// No description provided for @examPackTutorCreditsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Extra hints, explanations and step-by-step support'**
  String get examPackTutorCreditsSubtitle;

  /// No description provided for @examPackIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get examPackIncluded;

  /// No description provided for @examPackTopUp.
  ///
  /// In en, this message translates to:
  /// **'Top-up'**
  String get examPackTopUp;

  /// No description provided for @homeStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{days} day streak'**
  String homeStreakCount(int days);

  /// No description provided for @homeMilestone.
  ///
  /// In en, this message translates to:
  /// **'{days}-day milestone'**
  String homeMilestone(int days);

  /// No description provided for @homeRewardsOn.
  ///
  /// In en, this message translates to:
  /// **'Rewards on'**
  String get homeRewardsOn;

  /// No description provided for @homeRewardsOff.
  ///
  /// In en, this message translates to:
  /// **'Rewards off'**
  String get homeRewardsOff;

  /// No description provided for @homeBadgeFirstSession.
  ///
  /// In en, this message translates to:
  /// **'First session'**
  String get homeBadgeFirstSession;

  /// No description provided for @homeBadgeTenQuestions.
  ///
  /// In en, this message translates to:
  /// **'10 questions'**
  String get homeBadgeTenQuestions;

  /// No description provided for @homeBadgeAlgebraStarter.
  ///
  /// In en, this message translates to:
  /// **'Algebra starter'**
  String get homeBadgeAlgebraStarter;

  /// No description provided for @homeContinueKs2Topic.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get homeContinueKs2Topic;

  /// No description provided for @homeContinueKs2Subtopic.
  ///
  /// In en, this message translates to:
  /// **'Equivalent fractions'**
  String get homeContinueKs2Subtopic;

  /// No description provided for @homeContinueKs3Topic.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get homeContinueKs3Topic;

  /// No description provided for @homeContinueKs3Subtopic.
  ///
  /// In en, this message translates to:
  /// **'Solving equations'**
  String get homeContinueKs3Subtopic;

  /// No description provided for @homeContinueKs4Topic.
  ///
  /// In en, this message translates to:
  /// **'GCSE Maths'**
  String get homeContinueKs4Topic;

  /// No description provided for @homeContinueKs4Subtopic.
  ///
  /// In en, this message translates to:
  /// **'Quadratics & functions'**
  String get homeContinueKs4Subtopic;

  /// No description provided for @homeContinueKs5Topic.
  ///
  /// In en, this message translates to:
  /// **'Pure Maths'**
  String get homeContinueKs5Topic;

  /// No description provided for @homeContinueKs5Subtopic.
  ///
  /// In en, this message translates to:
  /// **'Differentiation'**
  String get homeContinueKs5Subtopic;

  /// No description provided for @quietStudyModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Quiet Study Mode'**
  String get quietStudyModeLabel;

  /// No description provided for @quietStudyModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Inspired by Nyepi, a Balinese tradition of reflection, stillness and focus.'**
  String get quietStudyModeTooltip;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up: {topic}'**
  String nextUp(String topic);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsParentToolsRewards.
  ///
  /// In en, this message translates to:
  /// **'Learning Analytics and rewards animations'**
  String get settingsParentToolsRewards;

  /// No description provided for @enableParentTools.
  ///
  /// In en, this message translates to:
  /// **'Enable Learning Analytics'**
  String get enableParentTools;

  /// No description provided for @parentToolsLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Allow local-only Learning Analytics'**
  String get parentToolsLocalOnly;

  /// No description provided for @unlockParentTools.
  ///
  /// In en, this message translates to:
  /// **'Unlock Learning Analytics'**
  String get unlockParentTools;

  /// No description provided for @parentToolsPinPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create or enter the local 4-digit PIN for Learning Analytics.'**
  String get parentToolsPinPrompt;

  /// No description provided for @parentTeacherTools.
  ///
  /// In en, this message translates to:
  /// **'Learning Analytics'**
  String get parentTeacherTools;

  /// No description provided for @createParentPin.
  ///
  /// In en, this message translates to:
  /// **'Create Parent PIN'**
  String get createParentPin;

  /// No description provided for @parentPinStorageNotice.
  ///
  /// In en, this message translates to:
  /// **'The 4-digit PIN is stored locally as a SHA-256 hash. No data leaves this device.'**
  String get parentPinStorageNotice;

  /// No description provided for @fourDigitPin.
  ///
  /// In en, this message translates to:
  /// **'4-digit PIN'**
  String get fourDigitPin;

  /// No description provided for @openCheatSheet.
  ///
  /// In en, this message translates to:
  /// **'Open Cheat Sheet'**
  String get openCheatSheet;

  /// No description provided for @unlockWithPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Premium'**
  String get unlockWithPremium;

  /// No description provided for @rewardsAnimations.
  ///
  /// In en, this message translates to:
  /// **'Rewards animations'**
  String get rewardsAnimations;

  /// No description provided for @rewardsAnimationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show celebrations after correct answers and milestones'**
  String get rewardsAnimationsSubtitle;

  /// No description provided for @premiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumLabel;

  /// No description provided for @rewardsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsLabel;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium feature'**
  String get premiumFeature;

  /// No description provided for @includedInPremium.
  ///
  /// In en, this message translates to:
  /// **'Included in Premium'**
  String get includedInPremium;

  /// No description provided for @availableInExamPacks.
  ///
  /// In en, this message translates to:
  /// **'Available in exam packs'**
  String get availableInExamPacks;

  /// No description provided for @unlockWithSubscription.
  ///
  /// In en, this message translates to:
  /// **'Unlock with subscription'**
  String get unlockWithSubscription;

  /// No description provided for @enterParentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter Parent PIN'**
  String get enterParentPin;

  /// No description provided for @resetParentPin.
  ///
  /// In en, this message translates to:
  /// **'Reset Parent PIN'**
  String get resetParentPin;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @resetLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetLabel;

  /// No description provided for @vaultLoadError.
  ///
  /// In en, this message translates to:
  /// **'The vault could not be loaded.'**
  String get vaultLoadError;

  /// No description provided for @pinMustBeFourDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter exactly 4 digits.'**
  String get pinMustBeFourDigits;

  /// No description provided for @pinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN.'**
  String get pinIncorrect;

  /// No description provided for @pinResetFailed.
  ///
  /// In en, this message translates to:
  /// **'PIN reset failed.'**
  String get pinResetFailed;

  /// No description provided for @navJourney.
  ///
  /// In en, this message translates to:
  /// **'Journey'**
  String get navJourney;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @journeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Journey'**
  String get journeyTitle;

  /// No description provided for @journeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks, achievements, and milestones in one place.'**
  String get journeySubtitle;

  /// No description provided for @journeyTeaserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See your streak, achievements, and milestones'**
  String get journeyTeaserSubtitle;

  /// No description provided for @practiceExitSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit session?'**
  String get practiceExitSessionTitle;

  /// No description provided for @practiceExitSessionBody.
  ///
  /// In en, this message translates to:
  /// **'Your current progress may not be saved.'**
  String get practiceExitSessionBody;

  /// No description provided for @onboardingDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard your answers?'**
  String get onboardingDiscardTitle;

  /// No description provided for @onboardingDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Going back will clear what you\'ve entered on this step.'**
  String get onboardingDiscardBody;

  /// Public product name used in onboarding hero.
  ///
  /// In en, this message translates to:
  /// **'Math Intelligence'**
  String get onboardingProductName;

  /// Technology positioning badge in onboarding hero.
  ///
  /// In en, this message translates to:
  /// **'Powered by Adaptive Learning Intelligence'**
  String get onboardingTechBadge;

  /// Primary onboarding hero statement. May contain locale-specific line breaks.
  ///
  /// In en, this message translates to:
  /// **'Develop mathematical thinking.\nUnlock your potential.'**
  String get onboardingHeroStatement;

  /// Secondary onboarding hero statement. May contain locale-specific line breaks.
  ///
  /// In en, this message translates to:
  /// **'Personalised learning.\nMeasurable progress.'**
  String get onboardingSupportingStatement;

  /// Clarifies who the supporting-a-learner role is for.
  ///
  /// In en, this message translates to:
  /// **'For parents, guardians, teachers, tutors and homeschool educators.'**
  String get onboardingRoleClarification;

  /// Create account action label on onboarding.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get onboardingCreateAccount;

  /// Local account benefit explanation.
  ///
  /// In en, this message translates to:
  /// **'Save progress, Maths Journey data and achievements on this device.'**
  String get onboardingCreateAccountSub;

  /// Shared professional progress reporting label.
  ///
  /// In en, this message translates to:
  /// **'Learning Analytics'**
  String get learningAnalyticsTitle;

  /// Learning Analytics supporting copy.
  ///
  /// In en, this message translates to:
  /// **'Understand progress, identify learning gaps and support the next step.'**
  String get learningAnalyticsSummary;

  /// Empty state when no practice data is available yet.
  ///
  /// In en, this message translates to:
  /// **'Complete a practice session to begin building Learning Analytics.'**
  String get learningAnalyticsEmptyState;

  /// Title of the Feature Discovery page and its entry point in the More sheet.
  ///
  /// In en, this message translates to:
  /// **'Explore Math Intelligence'**
  String get exploreMathIntelligenceTitle;

  /// No description provided for @exploreHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What Math Intelligence offers today, and what\'s coming next.'**
  String get exploreHeaderSubtitle;

  /// No description provided for @exploreAvailableTodaySection.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE TODAY'**
  String get exploreAvailableTodaySection;

  /// No description provided for @exploreInAtelierSection.
  ///
  /// In en, this message translates to:
  /// **'IN ATELIER'**
  String get exploreInAtelierSection;

  /// No description provided for @exploreInAtelierBadge.
  ///
  /// In en, this message translates to:
  /// **'In Atelier'**
  String get exploreInAtelierBadge;

  /// No description provided for @exploreInDevelopmentNote.
  ///
  /// In en, this message translates to:
  /// **'This feature is currently in development.'**
  String get exploreInDevelopmentNote;

  /// No description provided for @exploreRoadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'Roadmap Philosophy'**
  String get exploreRoadmapTitle;

  /// No description provided for @exploreRoadmapBody.
  ///
  /// In en, this message translates to:
  /// **'Math Intelligence is designed to grow over time. Some capabilities are available today. Others are currently being developed and tested before release.'**
  String get exploreRoadmapBody;

  /// No description provided for @explorePersonalisedPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalised Practice'**
  String get explorePersonalisedPracticeTitle;

  /// No description provided for @explorePersonalisedPracticeBody.
  ///
  /// In en, this message translates to:
  /// **'Adaptive question sessions based on your selected level and learning goals.'**
  String get explorePersonalisedPracticeBody;

  /// No description provided for @exploreTopicLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Topic Learning'**
  String get exploreTopicLearningTitle;

  /// No description provided for @exploreTopicLearningBody.
  ///
  /// In en, this message translates to:
  /// **'Focus on individual mathematical topics.'**
  String get exploreTopicLearningBody;

  /// No description provided for @exploreTimedChallengesTitle.
  ///
  /// In en, this message translates to:
  /// **'Timed Challenges'**
  String get exploreTimedChallengesTitle;

  /// No description provided for @exploreTimedChallengesBody.
  ///
  /// In en, this message translates to:
  /// **'Develop speed and confidence.'**
  String get exploreTimedChallengesBody;

  /// No description provided for @exploreExamSimulatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Simulator'**
  String get exploreExamSimulatorTitle;

  /// No description provided for @exploreExamSimulatorBody.
  ///
  /// In en, this message translates to:
  /// **'Practise using structured exam sessions.'**
  String get exploreExamSimulatorBody;

  /// No description provided for @exploreMathsJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Maths Journey'**
  String get exploreMathsJourneyTitle;

  /// No description provided for @exploreMathsJourneyBody.
  ///
  /// In en, this message translates to:
  /// **'Track your learning journey over time.'**
  String get exploreMathsJourneyBody;

  /// No description provided for @exploreLearningAnalyticsBody.
  ///
  /// In en, this message translates to:
  /// **'Monitor progress and identify growth opportunities.'**
  String get exploreLearningAnalyticsBody;

  /// No description provided for @exploreFormulaLibraryBody.
  ///
  /// In en, this message translates to:
  /// **'Quick offline reference.'**
  String get exploreFormulaLibraryBody;

  /// No description provided for @explorePhotoUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Question Upload'**
  String get explorePhotoUploadTitle;

  /// No description provided for @explorePhotoUploadBody.
  ///
  /// In en, this message translates to:
  /// **'Upload worksheets, textbook pages or exam questions.'**
  String get explorePhotoUploadBody;

  /// No description provided for @exploreMarkMyPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark My Paper'**
  String get exploreMarkMyPaperTitle;

  /// No description provided for @exploreMarkMyPaperBody.
  ///
  /// In en, this message translates to:
  /// **'Receive structured feedback on completed work.'**
  String get exploreMarkMyPaperBody;

  /// No description provided for @exploreExaminerIntelligenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Examiner Intelligence'**
  String get exploreExaminerIntelligenceTitle;

  /// No description provided for @exploreExaminerIntelligenceBody.
  ///
  /// In en, this message translates to:
  /// **'Learn how examiners award marks and identify common mistakes.'**
  String get exploreExaminerIntelligenceBody;

  /// No description provided for @exploreAdaptiveStudyPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Adaptive Study Plans'**
  String get exploreAdaptiveStudyPlansTitle;

  /// No description provided for @exploreAdaptiveStudyPlansBody.
  ///
  /// In en, this message translates to:
  /// **'Personalised study recommendations based on your learning journey.'**
  String get exploreAdaptiveStudyPlansBody;

  /// No description provided for @exploreTutorConversationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tutor Conversations'**
  String get exploreTutorConversationsTitle;

  /// No description provided for @exploreTutorConversationsBody.
  ///
  /// In en, this message translates to:
  /// **'Natural-language mathematical coaching.'**
  String get exploreTutorConversationsBody;

  /// No description provided for @journeyCardTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'My Maths Journey'**
  String get journeyCardTitleDefault;

  /// No description provided for @journeyCardTitleNamed.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Maths Journey'**
  String journeyCardTitleNamed(String name);

  /// No description provided for @journeyCardCurrentFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Current focus'**
  String get journeyCardCurrentFocusLabel;

  /// No description provided for @journeyCardGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get journeyCardGettingStarted;

  /// No description provided for @journeyCardCurrentStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get journeyCardCurrentStreakLabel;

  /// No description provided for @journeyCardStartStreakToday.
  ///
  /// In en, this message translates to:
  /// **'Start your streak today'**
  String get journeyCardStartStreakToday;

  /// No description provided for @journeyCardStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String journeyCardStreakDays(int days);

  /// No description provided for @journeyCardNextMilestoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Next milestone'**
  String get journeyCardNextMilestoneLabel;

  /// No description provided for @journeyCardDaysToMilestoneOne.
  ///
  /// In en, this message translates to:
  /// **'1 day to your {milestone}-day streak'**
  String journeyCardDaysToMilestoneOne(int milestone);

  /// No description provided for @journeyCardDaysToMilestoneMany.
  ///
  /// In en, this message translates to:
  /// **'{days} days to your {milestone}-day streak'**
  String journeyCardDaysToMilestoneMany(int days, int milestone);

  /// No description provided for @journeyCardAllMilestonesReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached every streak milestone!'**
  String get journeyCardAllMilestonesReached;

  /// No description provided for @journeyCardGoalConfidence.
  ///
  /// In en, this message translates to:
  /// **'You are building confidence'**
  String get journeyCardGoalConfidence;

  /// No description provided for @journeyCardGoalSchool.
  ///
  /// In en, this message translates to:
  /// **'You are improving school maths'**
  String get journeyCardGoalSchool;

  /// No description provided for @journeyCardGoalExams.
  ///
  /// In en, this message translates to:
  /// **'You are preparing for exams'**
  String get journeyCardGoalExams;

  /// No description provided for @journeyCardGoalChallenge.
  ///
  /// In en, this message translates to:
  /// **'You are tackling challenge problems'**
  String get journeyCardGoalChallenge;

  /// No description provided for @journeyCardGoalParentGaps.
  ///
  /// In en, this message translates to:
  /// **'You are finding learning gaps'**
  String get journeyCardGoalParentGaps;

  /// No description provided for @journeyCardGoalParentProgress.
  ///
  /// In en, this message translates to:
  /// **'You are tracking progress over time'**
  String get journeyCardGoalParentProgress;

  /// No description provided for @journeyCardGoalParentGcse.
  ///
  /// In en, this message translates to:
  /// **'You are preparing for GCSE'**
  String get journeyCardGoalParentGcse;

  /// No description provided for @journeyCardGoalTeacherMonitor.
  ///
  /// In en, this message translates to:
  /// **'You are monitoring class progress'**
  String get journeyCardGoalTeacherMonitor;

  /// No description provided for @journeyCardGoalTeacherAssign.
  ///
  /// In en, this message translates to:
  /// **'You are assigning practice'**
  String get journeyCardGoalTeacherAssign;

  /// No description provided for @journeyCardGoalTeacherExplore.
  ///
  /// In en, this message translates to:
  /// **'You are exploring the curriculum'**
  String get journeyCardGoalTeacherExplore;

  /// No description provided for @mathStudioNavCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Math Studio'**
  String get mathStudioNavCardTitle;

  /// No description provided for @mathStudioNavCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover the maths you already use'**
  String get mathStudioNavCardSubtitle;

  /// No description provided for @mathStudioHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Math Studio'**
  String get mathStudioHubTitle;

  /// No description provided for @mathStudioHubTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover the mathematics you\'ve been using all your life.'**
  String get mathStudioHubTagline;

  /// No description provided for @mathStudioBuildConfidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Confidence'**
  String get mathStudioBuildConfidenceTitle;

  /// No description provided for @mathStudioBuildConfidenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle, untimed practice with worked explanations'**
  String get mathStudioBuildConfidenceSubtitle;

  /// No description provided for @mathStudioMentalMathsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Maths'**
  String get mathStudioMentalMathsTitle;

  /// No description provided for @mathStudioMentalMathsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily number strategies, no pressure'**
  String get mathStudioMentalMathsSubtitle;

  /// No description provided for @mathStudioVisualMathsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Maths'**
  String get mathStudioVisualMathsTitle;

  /// No description provided for @mathStudioVisualMathsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See maths through models you can move'**
  String get mathStudioVisualMathsSubtitle;

  /// No description provided for @mathStudioDiscoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Discovery Library'**
  String get mathStudioDiscoveryTitle;

  /// No description provided for @mathStudioDiscoverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-world maths, one card at a time'**
  String get mathStudioDiscoverySubtitle;

  /// No description provided for @mathStudioCategoryEverydayLife.
  ///
  /// In en, this message translates to:
  /// **'Everyday Life'**
  String get mathStudioCategoryEverydayLife;

  /// No description provided for @mathStudioCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get mathStudioCategoryShopping;

  /// No description provided for @mathStudioCategoryCooking.
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get mathStudioCategoryCooking;

  /// No description provided for @mathStudioCategorySports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get mathStudioCategorySports;

  /// No description provided for @mathStudioCategoryAviation.
  ///
  /// In en, this message translates to:
  /// **'Aviation'**
  String get mathStudioCategoryAviation;

  /// No description provided for @mathStudioCategoryTruckingLogistics.
  ///
  /// In en, this message translates to:
  /// **'Trucking & Logistics'**
  String get mathStudioCategoryTruckingLogistics;

  /// No description provided for @mathStudioCategoryHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get mathStudioCategoryHealthcare;

  /// No description provided for @mathStudioCategoryEngineeringConstruction.
  ///
  /// In en, this message translates to:
  /// **'Engineering & Construction'**
  String get mathStudioCategoryEngineeringConstruction;

  /// No description provided for @mathStudioCategoryArtDesign.
  ///
  /// In en, this message translates to:
  /// **'Art & Design'**
  String get mathStudioCategoryArtDesign;

  /// No description provided for @mathStudioCategoryGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get mathStudioCategoryGaming;

  /// No description provided for @mathStudioCategoryBusinessFinance.
  ///
  /// In en, this message translates to:
  /// **'Business & Finance'**
  String get mathStudioCategoryBusinessFinance;

  /// No description provided for @mathStudioCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mathStudioCategoryAll;

  /// No description provided for @mathStudioDifficultyFoundation.
  ///
  /// In en, this message translates to:
  /// **'Foundation'**
  String get mathStudioDifficultyFoundation;

  /// No description provided for @mathStudioDifficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get mathStudioDifficultyIntermediate;

  /// No description provided for @mathStudioDifficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get mathStudioDifficultyAdvanced;

  /// No description provided for @mathStudioThinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Think it through'**
  String get mathStudioThinkLabel;

  /// No description provided for @mathStudioRevealButton.
  ///
  /// In en, this message translates to:
  /// **'Reveal the solution'**
  String get mathStudioRevealButton;

  /// No description provided for @mathStudioRevealedLabel.
  ///
  /// In en, this message translates to:
  /// **'Worked solution'**
  String get mathStudioRevealedLabel;

  /// No description provided for @mathStudioWhereYoullUseThisLabel.
  ///
  /// In en, this message translates to:
  /// **'Where you\'ll use this'**
  String get mathStudioWhereYoullUseThisLabel;

  /// No description provided for @mathStudioFollowUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Try one yourself'**
  String get mathStudioFollowUpLabel;

  /// No description provided for @mathStudioFollowUpCheckButton.
  ///
  /// In en, this message translates to:
  /// **'Check my answer'**
  String get mathStudioFollowUpCheckButton;

  /// No description provided for @mathStudioFollowUpCorrect.
  ///
  /// In en, this message translates to:
  /// **'Nice work — that\'s right.'**
  String get mathStudioFollowUpCorrect;

  /// No description provided for @mathStudioFollowUpTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Not quite — take another look at the steps above.'**
  String get mathStudioFollowUpTryAgain;

  /// No description provided for @mathStudioFollowUpAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get mathStudioFollowUpAnswerLabel;

  /// No description provided for @mathStudioExportButton.
  ///
  /// In en, this message translates to:
  /// **'Print or share'**
  String get mathStudioExportButton;

  /// No description provided for @mathStudioExportChallengeOnly.
  ///
  /// In en, this message translates to:
  /// **'Challenge sheet'**
  String get mathStudioExportChallengeOnly;

  /// No description provided for @mathStudioExportSolutionOnly.
  ///
  /// In en, this message translates to:
  /// **'Worked solution sheet'**
  String get mathStudioExportSolutionOnly;

  /// No description provided for @mathStudioExportCombined.
  ///
  /// In en, this message translates to:
  /// **'Challenge + solution'**
  String get mathStudioExportCombined;

  /// No description provided for @mathStudioExportIncludeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Include my name on this export'**
  String get mathStudioExportIncludeNameLabel;

  /// No description provided for @mathStudioExportShareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get mathStudioExportShareAction;

  /// No description provided for @captainMathCurious.
  ///
  /// In en, this message translates to:
  /// **'There\'s a discovery here — take a look.'**
  String get captainMathCurious;

  /// No description provided for @captainMathEncouraging.
  ///
  /// In en, this message translates to:
  /// **'Nice thinking — keep going.'**
  String get captainMathEncouraging;

  /// No description provided for @captainMathCalm.
  ///
  /// In en, this message translates to:
  /// **'Notice how this connects to something else.'**
  String get captainMathCalm;

  /// No description provided for @captainMathCelebrating.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get captainMathCelebrating;

  /// No description provided for @mentalMathsCategoryNumberBonds.
  ///
  /// In en, this message translates to:
  /// **'Number Bonds'**
  String get mentalMathsCategoryNumberBonds;

  /// No description provided for @mentalMathsCategoryDecomposition.
  ///
  /// In en, this message translates to:
  /// **'Decomposition'**
  String get mentalMathsCategoryDecomposition;

  /// No description provided for @mentalMathsCategoryCompensation.
  ///
  /// In en, this message translates to:
  /// **'Compensation'**
  String get mentalMathsCategoryCompensation;

  /// No description provided for @mentalMathsCategoryEstimation.
  ///
  /// In en, this message translates to:
  /// **'Estimation'**
  String get mentalMathsCategoryEstimation;

  /// No description provided for @mentalMathsCategoryMultiplicationStrategies.
  ///
  /// In en, this message translates to:
  /// **'Multiplication Strategies'**
  String get mentalMathsCategoryMultiplicationStrategies;

  /// No description provided for @mentalMathsCategoryDivisionStrategies.
  ///
  /// In en, this message translates to:
  /// **'Division Strategies'**
  String get mentalMathsCategoryDivisionStrategies;

  /// No description provided for @mentalMathsCategoryPercentages.
  ///
  /// In en, this message translates to:
  /// **'Percentages'**
  String get mentalMathsCategoryPercentages;

  /// No description provided for @mentalMathsCategoryFractions.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get mentalMathsCategoryFractions;

  /// No description provided for @mentalMathsCategoryPlaceValue.
  ///
  /// In en, this message translates to:
  /// **'Place Value'**
  String get mentalMathsCategoryPlaceValue;

  /// No description provided for @mentalMathsCategoryPatternRecognition.
  ///
  /// In en, this message translates to:
  /// **'Pattern Recognition'**
  String get mentalMathsCategoryPatternRecognition;

  /// No description provided for @mentalMathsTodaysChallenge.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Challenge'**
  String get mentalMathsTodaysChallenge;

  /// No description provided for @mentalMathsUntimedNote.
  ///
  /// In en, this message translates to:
  /// **'No timer — take the time you need.'**
  String get mentalMathsUntimedNote;

  /// No description provided for @buildConfidenceProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String buildConfidenceProgress(int current, int total);

  /// No description provided for @buildConfidenceContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buildConfidenceContinueButton;

  /// No description provided for @buildConfidenceCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nicely done'**
  String get buildConfidenceCompletionTitle;

  /// No description provided for @buildConfidenceCompletionBody.
  ///
  /// In en, this message translates to:
  /// **'You worked through today\'s session at your own pace. Come back whenever you\'re ready for another.'**
  String get buildConfidenceCompletionBody;

  /// No description provided for @buildConfidenceDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get buildConfidenceDoneButton;

  /// No description provided for @visualMathsNumberLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Number Line'**
  String get visualMathsNumberLineTitle;

  /// No description provided for @visualMathsNumberLineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drag the point to explore numbers on a line'**
  String get visualMathsNumberLineSubtitle;

  /// No description provided for @visualMathsFractionBarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fraction Bars'**
  String get visualMathsFractionBarsTitle;

  /// No description provided for @visualMathsFractionBarsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compare fractions as bars, side by side'**
  String get visualMathsFractionBarsSubtitle;

  /// No description provided for @visualMathsAbacusTitle.
  ///
  /// In en, this message translates to:
  /// **'Animated Abacus'**
  String get visualMathsAbacusTitle;

  /// No description provided for @visualMathsAbacusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See place value in action, bead by bead'**
  String get visualMathsAbacusSubtitle;

  /// No description provided for @visualMathsPlaceValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Value Explorer'**
  String get visualMathsPlaceValueTitle;

  /// No description provided for @visualMathsPlaceValueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Break numbers apart by their place value'**
  String get visualMathsPlaceValueSubtitle;

  /// No description provided for @visualMathsInteractiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Interactive'**
  String get visualMathsInteractiveBadge;

  /// No description provided for @visualMathsPreviewBadge.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get visualMathsPreviewBadge;

  /// No description provided for @visualMathsComingSoonNote.
  ///
  /// In en, this message translates to:
  /// **'Interactive version coming in a future release.'**
  String get visualMathsComingSoonNote;

  /// No description provided for @visualMathsTryAnotherExample.
  ///
  /// In en, this message translates to:
  /// **'Try another example'**
  String get visualMathsTryAnotherExample;

  /// No description provided for @numberLineExampleBasicWholeNumber.
  ///
  /// In en, this message translates to:
  /// **'A whole number on a 0 to 10 line'**
  String get numberLineExampleBasicWholeNumber;

  /// No description provided for @numberLineExampleNegativeNumber.
  ///
  /// In en, this message translates to:
  /// **'A negative number on a −10 to 10 line'**
  String get numberLineExampleNegativeNumber;

  /// No description provided for @numberLineExampleSimpleFraction.
  ///
  /// In en, this message translates to:
  /// **'A fraction on a 0 to 1 line'**
  String get numberLineExampleSimpleFraction;

  /// No description provided for @numberLineExampleDecimal.
  ///
  /// In en, this message translates to:
  /// **'A decimal on a 0 to 5 line'**
  String get numberLineExampleDecimal;

  /// No description provided for @fractionBarsCaption1.
  ///
  /// In en, this message translates to:
  /// **'1/2 is exactly half of the whole bar.'**
  String get fractionBarsCaption1;

  /// No description provided for @fractionBarsCaption2.
  ///
  /// In en, this message translates to:
  /// **'2/4 covers the same length as 1/2 — equivalent fractions.'**
  String get fractionBarsCaption2;

  /// No description provided for @fractionBarsCaption3.
  ///
  /// In en, this message translates to:
  /// **'3/4 is more than half, less than the whole.'**
  String get fractionBarsCaption3;

  /// No description provided for @fractionBarsCaption4.
  ///
  /// In en, this message translates to:
  /// **'5/8 is just over half of the whole bar.'**
  String get fractionBarsCaption4;

  /// No description provided for @abacusCaption1.
  ///
  /// In en, this message translates to:
  /// **'One bead moved in the ones column represents 1.'**
  String get abacusCaption1;

  /// No description provided for @abacusCaption2.
  ///
  /// In en, this message translates to:
  /// **'Ten ones regroup into a single bead in the tens column.'**
  String get abacusCaption2;

  /// No description provided for @abacusCaption3.
  ///
  /// In en, this message translates to:
  /// **'A bead in the hundreds column is worth 100 ones.'**
  String get abacusCaption3;

  /// No description provided for @placeValueCaption1.
  ///
  /// In en, this message translates to:
  /// **'3,742 breaks into 3 thousands, 7 hundreds, 4 tens, 2 ones.'**
  String get placeValueCaption1;

  /// No description provided for @placeValueCaption2.
  ///
  /// In en, this message translates to:
  /// **'6.4 breaks into 6 ones and 4 tenths.'**
  String get placeValueCaption2;

  /// No description provided for @placeValueCaption3.
  ///
  /// In en, this message translates to:
  /// **'805 breaks into 8 hundreds, 0 tens, 5 ones — the 0 holds the tens place.'**
  String get placeValueCaption3;

  /// No description provided for @abacusColumnHundreds.
  ///
  /// In en, this message translates to:
  /// **'Hundreds'**
  String get abacusColumnHundreds;

  /// No description provided for @abacusColumnTens.
  ///
  /// In en, this message translates to:
  /// **'Tens'**
  String get abacusColumnTens;

  /// No description provided for @abacusColumnOnes.
  ///
  /// In en, this message translates to:
  /// **'Ones'**
  String get abacusColumnOnes;

  /// No description provided for @mathStudioRecallCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recall Cards'**
  String get mathStudioRecallCardsTitle;

  /// No description provided for @mathStudioRecallCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick retrieval practice for the facts you need to keep'**
  String get mathStudioRecallCardsSubtitle;

  /// No description provided for @recallCardsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Recall Cards'**
  String get recallCardsHubTitle;

  /// No description provided for @recallCardsHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short, focused practice for formulas, vocabulary, symbols and the ideas behind them'**
  String get recallCardsHubSubtitle;

  /// No description provided for @recallCardsQuickReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Five-Card Quick Review'**
  String get recallCardsQuickReviewTitle;

  /// No description provided for @recallCardsQuickReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short daily set, chosen for you'**
  String get recallCardsQuickReviewSubtitle;

  /// No description provided for @recallCardsReviewDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Due'**
  String get recallCardsReviewDueTitle;

  /// Count of Recall Cards currently due for review
  ///
  /// In en, this message translates to:
  /// **'{count} due for review'**
  String recallCardsReviewDueCount(int count);

  /// No description provided for @recallCardsReviewDueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing due right now — nice work'**
  String get recallCardsReviewDueEmpty;

  /// No description provided for @recallCardsBrowseByTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse by Topic'**
  String get recallCardsBrowseByTopicTitle;

  /// No description provided for @recallCardsBrowseByTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse by Card Type'**
  String get recallCardsBrowseByTypeTitle;

  /// No description provided for @recallCardsSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get recallCardsSearchTitle;

  /// No description provided for @recallCardsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search formulas, terms and ideas'**
  String get recallCardsSearchHint;

  /// No description provided for @recallCardsBookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get recallCardsBookmarksTitle;

  /// No description provided for @recallCardsEmptyBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet — tap the bookmark icon on any card to save it here'**
  String get recallCardsEmptyBookmarks;

  /// No description provided for @recallCardsNoResults.
  ///
  /// In en, this message translates to:
  /// **'No cards found'**
  String get recallCardsNoResults;

  /// No description provided for @recallCardsRevealButton.
  ///
  /// In en, this message translates to:
  /// **'Reveal the answer'**
  String get recallCardsRevealButton;

  /// No description provided for @recallCardsRevealedLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get recallCardsRevealedLabel;

  /// No description provided for @recallCardsExplainLabel.
  ///
  /// In en, this message translates to:
  /// **'Why this works'**
  String get recallCardsExplainLabel;

  /// No description provided for @recallCardsCommonMistakeLabel.
  ///
  /// In en, this message translates to:
  /// **'Common mistake'**
  String get recallCardsCommonMistakeLabel;

  /// No description provided for @recallCardsConnectLabel.
  ///
  /// In en, this message translates to:
  /// **'Where this is used'**
  String get recallCardsConnectLabel;

  /// No description provided for @recallCardsRelatedDiscoveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Discovery Cards'**
  String get recallCardsRelatedDiscoveryLabel;

  /// No description provided for @recallCardsRelatedPracticeLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Practice'**
  String get recallCardsRelatedPracticeLabel;

  /// No description provided for @recallCardsRelatedLabsLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Interactive Labs'**
  String get recallCardsRelatedLabsLabel;

  /// No description provided for @recallCardsLabComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get recallCardsLabComingSoon;

  /// No description provided for @recallCardsRememberedButton.
  ///
  /// In en, this message translates to:
  /// **'I remembered this'**
  String get recallCardsRememberedButton;

  /// No description provided for @recallCardsNotYetButton.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get recallCardsNotYetButton;

  /// No description provided for @recallCardsAskMeTomorrowButton.
  ///
  /// In en, this message translates to:
  /// **'Ask Me Tomorrow'**
  String get recallCardsAskMeTomorrowButton;

  /// No description provided for @recallCardsBookmarkAdd.
  ///
  /// In en, this message translates to:
  /// **'Bookmark this card'**
  String get recallCardsBookmarkAdd;

  /// No description provided for @recallCardsBookmarkRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get recallCardsBookmarkRemove;

  /// No description provided for @recallCardsExportButton.
  ///
  /// In en, this message translates to:
  /// **'Print or share'**
  String get recallCardsExportButton;

  /// No description provided for @recallCardsExportFiveCardSheet.
  ///
  /// In en, this message translates to:
  /// **'Recall sheet (questions only)'**
  String get recallCardsExportFiveCardSheet;

  /// No description provided for @recallCardsExportAnswerSheet.
  ///
  /// In en, this message translates to:
  /// **'Answer sheet'**
  String get recallCardsExportAnswerSheet;

  /// No description provided for @recallCardsSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get recallCardsSessionComplete;

  /// No description provided for @recallCardsSessionCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Great work — come back tomorrow for more'**
  String get recallCardsSessionCompleteSubtitle;

  /// Progress indicator during a Recall Cards review session
  ///
  /// In en, this message translates to:
  /// **'Card {current} of {total}'**
  String recallCardsCardOf(int current, int total);

  /// No description provided for @recallCardsStateNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get recallCardsStateNew;

  /// No description provided for @recallCardsStateLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get recallCardsStateLearning;

  /// No description provided for @recallCardsStateReviewDue.
  ///
  /// In en, this message translates to:
  /// **'Review due'**
  String get recallCardsStateReviewDue;

  /// No description provided for @recallCardsStateMastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get recallCardsStateMastered;

  /// No description provided for @recallCardsTypeFormula.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get recallCardsTypeFormula;

  /// No description provided for @recallCardsTypeMeaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get recallCardsTypeMeaning;

  /// No description provided for @recallCardsTypeSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get recallCardsTypeSymbol;

  /// No description provided for @recallCardsTypeVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get recallCardsTypeVocabulary;

  /// No description provided for @recallCardsTypeStrategy.
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get recallCardsTypeStrategy;

  /// No description provided for @recallCardsTypeMisconception.
  ///
  /// In en, this message translates to:
  /// **'Common Misconception'**
  String get recallCardsTypeMisconception;

  /// No description provided for @recallCardsTypeVisual.
  ///
  /// In en, this message translates to:
  /// **'Visual'**
  String get recallCardsTypeVisual;

  /// No description provided for @recallCardsTypeRealWorldConnection.
  ///
  /// In en, this message translates to:
  /// **'Real-World Connection'**
  String get recallCardsTypeRealWorldConnection;

  /// No description provided for @recallCardsTopicNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get recallCardsTopicNumber;

  /// No description provided for @recallCardsTopicRatioAndProportion.
  ///
  /// In en, this message translates to:
  /// **'Ratio & Proportion'**
  String get recallCardsTopicRatioAndProportion;

  /// No description provided for @recallCardsTopicAlgebra.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get recallCardsTopicAlgebra;

  /// No description provided for @recallCardsTopicGeometryAndMeasures.
  ///
  /// In en, this message translates to:
  /// **'Geometry & Measures'**
  String get recallCardsTopicGeometryAndMeasures;

  /// No description provided for @recallCardsTopicStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get recallCardsTopicStatistics;

  /// No description provided for @recallCardsTopicProbability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get recallCardsTopicProbability;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'da',
        'de',
        'en',
        'es',
        'fr',
        'id',
        'it',
        'ko',
        'nb',
        'pt',
        'sv'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'da':
      {
        switch (locale.countryCode) {
          case 'DK':
            return AppLocalizationsDaDk();
        }
        break;
      }
    case 'de':
      {
        switch (locale.countryCode) {
          case 'CH':
            return AppLocalizationsDeCh();
        }
        break;
      }
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppLocalizationsEnGb();
        }
        break;
      }
    case 'fr':
      {
        switch (locale.countryCode) {
          case 'CH':
            return AppLocalizationsFrCh();
        }
        break;
      }
    case 'it':
      {
        switch (locale.countryCode) {
          case 'CH':
            return AppLocalizationsItCh();
        }
        break;
      }
    case 'ko':
      {
        switch (locale.countryCode) {
          case 'KR':
            return AppLocalizationsKoKr();
        }
        break;
      }
    case 'nb':
      {
        switch (locale.countryCode) {
          case 'NO':
            return AppLocalizationsNbNo();
        }
        break;
      }
    case 'sv':
      {
        switch (locale.countryCode) {
          case 'SE':
            return AppLocalizationsSvSe();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ko':
      return AppLocalizationsKo();
    case 'nb':
      return AppLocalizationsNb();
    case 'pt':
      return AppLocalizationsPt();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
