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

  /// No description provided for @practiceExamEntranceExamPrep.
  ///
  /// In en, this message translates to:
  /// **'Entrance Exam Prep'**
  String get practiceExamEntranceExamPrep;

  /// No description provided for @entranceExamHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Entrance Exam Preparation'**
  String get entranceExamHubTitle;

  /// No description provided for @entranceExamHubIntro.
  ///
  /// In en, this message translates to:
  /// **'Independent-school entrance exam practice, separate from GCSE Exam Simulator — built for the 11+ age group and marked by comparing your own working to a model answer, not typed multiple choice.'**
  String get entranceExamHubIntro;

  /// No description provided for @entranceExamDisclaimerHeading.
  ///
  /// In en, this message translates to:
  /// **'Not affiliated with any school or exam board'**
  String get entranceExamDisclaimerHeading;

  /// No description provided for @entranceExamAgeBandLabel.
  ///
  /// In en, this message translates to:
  /// **'Age band'**
  String get entranceExamAgeBandLabel;

  /// No description provided for @entranceExamDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get entranceExamDurationLabel;

  /// No description provided for @entranceExamCalculatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get entranceExamCalculatorLabel;

  /// No description provided for @entranceExamCalculatorNone.
  ///
  /// In en, this message translates to:
  /// **'Not allowed'**
  String get entranceExamCalculatorNone;

  /// No description provided for @entranceExamCalculatorAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get entranceExamCalculatorAllowed;

  /// No description provided for @entranceExamCalculatorAllowedNonScientific.
  ///
  /// In en, this message translates to:
  /// **'Allowed (non-scientific)'**
  String get entranceExamCalculatorAllowedNonScientific;

  /// No description provided for @entranceExamDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String entranceExamDurationMinutes(int minutes);

  /// No description provided for @entranceExamModePracticeBySkillTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice by Skill'**
  String get entranceExamModePracticeBySkillTitle;

  /// No description provided for @entranceExamModePracticeBySkillSub.
  ///
  /// In en, this message translates to:
  /// **'Work through questions grouped by skill, with worked methods to compare against.'**
  String get entranceExamModePracticeBySkillSub;

  /// No description provided for @entranceExamModeReviewMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Methods'**
  String get entranceExamModeReviewMethodsTitle;

  /// No description provided for @entranceExamModeReviewMethodsSub.
  ///
  /// In en, this message translates to:
  /// **'Revisit every available question\'s full worked method — no timer, no marking.'**
  String get entranceExamModeReviewMethodsSub;

  /// No description provided for @entranceExamModeUntimedPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Untimed Paper'**
  String get entranceExamModeUntimedPaperTitle;

  /// No description provided for @entranceExamModeUntimedPaperSub.
  ///
  /// In en, this message translates to:
  /// **'Sit the complete paper with no time limit.'**
  String get entranceExamModeUntimedPaperSub;

  /// No description provided for @entranceExamModeTimedMockTitle.
  ///
  /// In en, this message translates to:
  /// **'Timed Mock'**
  String get entranceExamModeTimedMockTitle;

  /// No description provided for @entranceExamModeTimedMockSub.
  ///
  /// In en, this message translates to:
  /// **'Sit the complete paper under real exam timing.'**
  String get entranceExamModeTimedMockSub;

  /// No description provided for @entranceExamModeScholarshipChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scholarship Challenge'**
  String get entranceExamModeScholarshipChallengeTitle;

  /// No description provided for @entranceExamModeScholarshipChallengeSub.
  ///
  /// In en, this message translates to:
  /// **'A stretch paper for scholarship-tier candidates.'**
  String get entranceExamModeScholarshipChallengeSub;

  /// No description provided for @entranceExamModeLockedFullPaperReason.
  ///
  /// In en, this message translates to:
  /// **'Unlocks once the full {declared}-question paper is ready — {authored} authored so far.'**
  String entranceExamModeLockedFullPaperReason(int declared, int authored);

  /// No description provided for @entranceExamModeLockedScholarshipReason.
  ///
  /// In en, this message translates to:
  /// **'This pack is Foundation tier — Scholarship Challenge needs a scholarship-tier pack.'**
  String get entranceExamModeLockedScholarshipReason;

  /// No description provided for @entranceExamModeLockedBadge.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get entranceExamModeLockedBadge;

  /// No description provided for @entranceExamSkillPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a Skill'**
  String get entranceExamSkillPickerTitle;

  /// No description provided for @entranceExamSkillQuestionCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} questions available'**
  String entranceExamSkillQuestionCountLabel(int count);

  /// No description provided for @entranceExamSkillNumberFluency.
  ///
  /// In en, this message translates to:
  /// **'Number Fluency'**
  String get entranceExamSkillNumberFluency;

  /// No description provided for @entranceExamSkillFractionsAndPercentages.
  ///
  /// In en, this message translates to:
  /// **'Fractions & Percentages'**
  String get entranceExamSkillFractionsAndPercentages;

  /// No description provided for @entranceExamSkillRatioAndProportion.
  ///
  /// In en, this message translates to:
  /// **'Ratio & Proportion'**
  String get entranceExamSkillRatioAndProportion;

  /// No description provided for @entranceExamSkillAlgebraicReasoning.
  ///
  /// In en, this message translates to:
  /// **'Algebraic Reasoning'**
  String get entranceExamSkillAlgebraicReasoning;

  /// No description provided for @entranceExamSkillShapeAndSpace.
  ///
  /// In en, this message translates to:
  /// **'Shape & Space'**
  String get entranceExamSkillShapeAndSpace;

  /// No description provided for @entranceExamSkillDataAndLogic.
  ///
  /// In en, this message translates to:
  /// **'Data & Logic'**
  String get entranceExamSkillDataAndLogic;

  /// No description provided for @entranceExamQuestionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String entranceExamQuestionOf(int current, int total);

  /// No description provided for @entranceExamRevealMethodButton.
  ///
  /// In en, this message translates to:
  /// **'Reveal worked method'**
  String get entranceExamRevealMethodButton;

  /// No description provided for @entranceExamMethodMarkPrompt.
  ///
  /// In en, this message translates to:
  /// **'Compare this to your own working. Which best matches what you wrote?'**
  String get entranceExamMethodMarkPrompt;

  /// No description provided for @entranceExamMethodMarkCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct — full method shown'**
  String get entranceExamMethodMarkCorrect;

  /// No description provided for @entranceExamMethodMarkSlip.
  ///
  /// In en, this message translates to:
  /// **'Method right, one slip'**
  String get entranceExamMethodMarkSlip;

  /// No description provided for @entranceExamMethodMarkPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial reasoning'**
  String get entranceExamMethodMarkPartial;

  /// No description provided for @entranceExamMethodMarkUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Answer only, no method'**
  String get entranceExamMethodMarkUnsupported;

  /// No description provided for @entranceExamMethodMarkBlank.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t attempt this'**
  String get entranceExamMethodMarkBlank;

  /// No description provided for @entranceExamNextQuestionButton.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get entranceExamNextQuestionButton;

  /// No description provided for @entranceExamSessionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Complete'**
  String get entranceExamSessionCompleteTitle;

  /// No description provided for @entranceExamSessionEstimatedMarks.
  ///
  /// In en, this message translates to:
  /// **'Estimated marks: {marks} / {total}'**
  String entranceExamSessionEstimatedMarks(String marks, int total);

  /// No description provided for @entranceExamSessionEstimatedMarksNote.
  ///
  /// In en, this message translates to:
  /// **'An estimate from your own self-marking, not an official mark scheme — see the guidance under each question.'**
  String get entranceExamSessionEstimatedMarksNote;

  /// No description provided for @entranceExamReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Methods'**
  String get entranceExamReviewTitle;

  /// No description provided for @entranceExamNoHandwritingNote.
  ///
  /// In en, this message translates to:
  /// **'This app never reads or grades your handwritten working — you compare it yourself against the worked method shown.'**
  String get entranceExamNoHandwritingNote;

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

  /// No description provided for @mathStudioMathMagicTitle.
  ///
  /// In en, this message translates to:
  /// **'Math & Magic'**
  String get mathStudioMathMagicTitle;

  /// No description provided for @mathStudioMathMagicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Puzzles, patterns and playful mathematical surprises'**
  String get mathStudioMathMagicSubtitle;

  /// No description provided for @mathStudioMathMagicBody.
  ///
  /// In en, this message translates to:
  /// **'Recreational puzzles, number tricks and mathematical curiosities'**
  String get mathStudioMathMagicBody;

  /// No description provided for @mathStudioMathMagicNumberTricksLabel.
  ///
  /// In en, this message translates to:
  /// **'Visual Number Tricks'**
  String get mathStudioMathMagicNumberTricksLabel;

  /// No description provided for @mathStudioMathMagicNumberTricksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch a number trick unfold, step by step'**
  String get mathStudioMathMagicNumberTricksSubtitle;

  /// No description provided for @mathStudioMathMagicPatternsLabel.
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get mathStudioMathMagicPatternsLabel;

  /// No description provided for @mathStudioMathMagicPatternsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grow a dot pattern and discover the rule behind it'**
  String get mathStudioMathMagicPatternsSubtitle;

  /// No description provided for @mathStudioMathMagicMagicSquaresLabel.
  ///
  /// In en, this message translates to:
  /// **'Magic Squares'**
  String get mathStudioMathMagicMagicSquaresLabel;

  /// No description provided for @mathStudioMathMagicMagicSquaresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arrange numbers so every line adds up the same'**
  String get mathStudioMathMagicMagicSquaresSubtitle;

  /// No description provided for @mathStudioMathMagicParityLabel.
  ///
  /// In en, this message translates to:
  /// **'Parity'**
  String get mathStudioMathMagicParityLabel;

  /// No description provided for @mathStudioMathMagicParitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore what happens when you add odd and even numbers'**
  String get mathStudioMathMagicParitySubtitle;

  /// No description provided for @mathStudioSpatialIntelligenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Spatial Intelligence'**
  String get mathStudioSpatialIntelligenceTitle;

  /// No description provided for @mathStudioSpatialIntelligenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build your sense of shape, space and movement'**
  String get mathStudioSpatialIntelligenceSubtitle;

  /// No description provided for @mathStudioSpatialIntelligenceBody.
  ///
  /// In en, this message translates to:
  /// **'Cube nets, rotations, transformations and spatial puzzles'**
  String get mathStudioSpatialIntelligenceBody;

  /// No description provided for @mathStudioInDevelopmentBadge.
  ///
  /// In en, this message translates to:
  /// **'In development'**
  String get mathStudioInDevelopmentBadge;

  /// No description provided for @mathStudioInDevelopmentNote.
  ///
  /// In en, this message translates to:
  /// **'This area is still being built — check back soon for new content.'**
  String get mathStudioInDevelopmentNote;

  /// No description provided for @mathStudioSpatialCubeActivitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Cube activities'**
  String get mathStudioSpatialCubeActivitiesLabel;

  /// No description provided for @mathStudioSpatialRotationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rotations'**
  String get mathStudioSpatialRotationsLabel;

  /// No description provided for @mathStudioSpatialTransformationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Transformations'**
  String get mathStudioSpatialTransformationsLabel;

  /// No description provided for @mathStudioSpatialPuzzlesLabel.
  ///
  /// In en, this message translates to:
  /// **'Spatial puzzles'**
  String get mathStudioSpatialPuzzlesLabel;

  /// No description provided for @mathStudioSpatialCubeNetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cube Nets'**
  String get mathStudioSpatialCubeNetsLabel;

  /// No description provided for @mathStudioSpatialCubeNetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Decide which nets fold into a closed cube'**
  String get mathStudioSpatialCubeNetsSubtitle;

  /// No description provided for @mathStudioSpatialRotationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn a shape around a fixed point and see what changes'**
  String get mathStudioSpatialRotationsSubtitle;

  /// No description provided for @mathStudioSpatialTransformationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Translate, reflect, rotate and enlarge on a coordinate grid'**
  String get mathStudioSpatialTransformationsSubtitle;

  /// No description provided for @mathStudioSpatialPuzzlesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short puzzles about shape, space and 3D thinking'**
  String get mathStudioSpatialPuzzlesSubtitle;

  /// No description provided for @mathStudioFeaturedFormatsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Featured formats'**
  String get mathStudioFeaturedFormatsSectionLabel;

  /// No description provided for @mathStudioRelatedLabsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Related labs'**
  String get mathStudioRelatedLabsSectionLabel;

  /// No description provided for @mathStudioSpatialLabsEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try Flight Path Lab and other hands-on tools that build spatial reasoning'**
  String get mathStudioSpatialLabsEntrySubtitle;

  /// No description provided for @mathStudioDiscoveryEmptyCategory.
  ///
  /// In en, this message translates to:
  /// **'More cards for this category are coming soon.'**
  String get mathStudioDiscoveryEmptyCategory;

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

  /// No description provided for @mathStudioCategoryArchitectureConstruction.
  ///
  /// In en, this message translates to:
  /// **'Architecture & Construction'**
  String get mathStudioCategoryArchitectureConstruction;

  /// No description provided for @mathStudioCategoryEnvironmentClimate.
  ///
  /// In en, this message translates to:
  /// **'Environment & Climate'**
  String get mathStudioCategoryEnvironmentClimate;

  /// No description provided for @mathStudioCategoryComputingCryptography.
  ///
  /// In en, this message translates to:
  /// **'Computing & Cryptography'**
  String get mathStudioCategoryComputingCryptography;

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

  /// No description provided for @recallCardsTopicFilterGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get recallCardsTopicFilterGroupLabel;

  /// No description provided for @recallCardsTypeFilterGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Card type'**
  String get recallCardsTypeFilterGroupLabel;

  /// No description provided for @recallCardsMoreChipLabel.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get recallCardsMoreChipLabel;

  /// No description provided for @recallCardsMoreTopicsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'More topics'**
  String get recallCardsMoreTopicsSheetTitle;

  /// No description provided for @recallCardsMoreTypesSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'More card types'**
  String get recallCardsMoreTypesSheetTitle;

  /// No description provided for @recallCardsClearFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get recallCardsClearFiltersButton;

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

  /// No description provided for @mathStudioInteractiveLabsTitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Labs'**
  String get mathStudioInteractiveLabsTitle;

  /// No description provided for @mathStudioInteractiveLabsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hands-on maths you can touch, change and test'**
  String get mathStudioInteractiveLabsSubtitle;

  /// No description provided for @labsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Labs'**
  String get labsHubTitle;

  /// No description provided for @labsHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See a concept, touch it, change it, and test your prediction'**
  String get labsHubSubtitle;

  /// No description provided for @labsResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get labsResetButton;

  /// No description provided for @labsCheckButton.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get labsCheckButton;

  /// No description provided for @labsNextChallengeButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get labsNextChallengeButton;

  /// No description provided for @labsFeedbackCorrect.
  ///
  /// In en, this message translates to:
  /// **'Nice work — that\'s right.'**
  String get labsFeedbackCorrect;

  /// No description provided for @labsFeedbackTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Not quite — have another go.'**
  String get labsFeedbackTryAgain;

  /// No description provided for @labsRelatedRecallCardsLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Recall Cards'**
  String get labsRelatedRecallCardsLabel;

  /// No description provided for @labsFractionBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Fraction Builder'**
  String get labsFractionBuilderTitle;

  /// No description provided for @labsFractionBuilderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build a fraction by filling equal parts'**
  String get labsFractionBuilderSubtitle;

  /// No description provided for @labsFractionBuilderConcept.
  ///
  /// In en, this message translates to:
  /// **'A fraction is a count of equal parts out of a whole. Tap segments to fill them and match the target fraction.'**
  String get labsFractionBuilderConcept;

  /// No description provided for @labsFractionBuilderWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Sharing food fairly, reading recipes, and measuring ingredients all rely on fractions of a whole.'**
  String get labsFractionBuilderWhereUsed;

  /// Fraction Builder challenge prompt
  ///
  /// In en, this message translates to:
  /// **'Fill in {numerator} out of {denominator} segments.'**
  String labsFractionBuilderPrompt(int numerator, int denominator);

  /// Fraction Builder live fill count
  ///
  /// In en, this message translates to:
  /// **'{filled} of {denominator} filled'**
  String labsFractionBuilderFilledCount(int filled, int denominator);

  /// No description provided for @labsAlgebraBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Algebra Balance'**
  String get labsAlgebraBalanceTitle;

  /// No description provided for @labsAlgebraBalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep both sides equal to solve for x'**
  String get labsAlgebraBalanceSubtitle;

  /// No description provided for @labsAlgebraBalanceConcept.
  ///
  /// In en, this message translates to:
  /// **'An equation stays true only if you do the same thing to both sides. Simplify step by step until x stands alone.'**
  String get labsAlgebraBalanceConcept;

  /// No description provided for @labsAlgebraBalanceWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Working backwards from a total to find an unknown amount uses exactly this balancing idea.'**
  String get labsAlgebraBalanceWhereUsed;

  /// Screen-reader label for the current algebra equation
  ///
  /// In en, this message translates to:
  /// **'Equation: {equation}'**
  String labsAlgebraBalanceEquationLabel(String equation);

  /// No description provided for @labsAlgebraBalanceStep1Button.
  ///
  /// In en, this message translates to:
  /// **'Remove the constant'**
  String get labsAlgebraBalanceStep1Button;

  /// No description provided for @labsAlgebraBalanceStep2Button.
  ///
  /// In en, this message translates to:
  /// **'Divide to isolate x'**
  String get labsAlgebraBalanceStep2Button;

  /// Shown once the Algebra Balance equation is fully solved
  ///
  /// In en, this message translates to:
  /// **'Solved! x = {x}'**
  String labsAlgebraBalanceSolvedFeedback(int x);

  /// No description provided for @labsNumberLineExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Number Line Explorer'**
  String get labsNumberLineExplorerTitle;

  /// No description provided for @labsNumberLineExplorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drag to match a value on the line'**
  String get labsNumberLineExplorerSubtitle;

  /// No description provided for @labsNumberLineExplorerConcept.
  ///
  /// In en, this message translates to:
  /// **'A number\'s position on a number line matches its value — including negative numbers and decimals.'**
  String get labsNumberLineExplorerConcept;

  /// No description provided for @labsNumberLineExplorerWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Reading thermometers, timelines and measuring scales all rely on position matching value.'**
  String get labsNumberLineExplorerWhereUsed;

  /// Number Line Explorer challenge prompt
  ///
  /// In en, this message translates to:
  /// **'Drag the point to {target}.'**
  String labsNumberLineExplorerPrompt(String target);

  /// No description provided for @labsFlightPathLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Path Lab'**
  String get labsFlightPathLabTitle;

  /// No description provided for @labsFlightPathLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a heading and speed to reach the target'**
  String get labsFlightPathLabSubtitle;

  /// No description provided for @labsFlightPathLabConcept.
  ///
  /// In en, this message translates to:
  /// **'A heading (bearing) and speed, held for a fixed time, fix exactly where you end up — this combines bearings with speed, distance and time.'**
  String get labsFlightPathLabConcept;

  /// No description provided for @labsFlightPathLabWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Pilots and sailors use bearing and speed together to navigate to a destination.'**
  String get labsFlightPathLabWhereUsed;

  /// Flight Path Lab scenario prompt
  ///
  /// In en, this message translates to:
  /// **'Target: bearing {bearing}°, {distance} km away. Flight time is fixed at 2 hours — choose a heading and speed to reach it.'**
  String labsFlightPathLabPrompt(int bearing, int distance);

  /// No description provided for @labsFlightPathLabRadarLabel.
  ///
  /// In en, this message translates to:
  /// **'A radar view showing the target and, after a test flight, where the aircraft landed.'**
  String get labsFlightPathLabRadarLabel;

  /// Flight Path Lab speed slider label
  ///
  /// In en, this message translates to:
  /// **'Speed: {speed} km/h'**
  String labsFlightPathLabSpeedLabel(int speed);

  /// No description provided for @labsFlightPathLabTestButton.
  ///
  /// In en, this message translates to:
  /// **'Test Flight'**
  String get labsFlightPathLabTestButton;

  /// No description provided for @labsFlightPathLabResultSpotOn.
  ///
  /// In en, this message translates to:
  /// **'Spot on!'**
  String get labsFlightPathLabResultSpotOn;

  /// No description provided for @labsFlightPathLabResultClose.
  ///
  /// In en, this message translates to:
  /// **'Close — try a small adjustment.'**
  String get labsFlightPathLabResultClose;

  /// No description provided for @labsFlightPathLabResultTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the heading or speed.'**
  String get labsFlightPathLabResultTryAgain;

  /// Flight Path Lab result distance-from-target message
  ///
  /// In en, this message translates to:
  /// **'You landed {distance} km from the target.'**
  String labsFlightPathLabResultDistance(int distance);

  /// No description provided for @labsDataDetectiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Detective'**
  String get labsDataDetectiveTitle;

  /// No description provided for @labsDataDetectiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how one outlier changes an average'**
  String get labsDataDetectiveSubtitle;

  /// No description provided for @labsDataDetectiveConcept.
  ///
  /// In en, this message translates to:
  /// **'The mean is pulled toward an outlier much more than the median is. Remove values and watch each average update live.'**
  String get labsDataDetectiveConcept;

  /// No description provided for @labsDataDetectiveWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Reporting a \'typical\' salary, price or score fairly means knowing when the mean is misleading and the median is a better summary.'**
  String get labsDataDetectiveWhereUsed;

  /// No description provided for @labsDataDetectiveAddValueButton.
  ///
  /// In en, this message translates to:
  /// **'Add a typical value'**
  String get labsDataDetectiveAddValueButton;

  /// No description provided for @labsDataDetectivePredictionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Which will change more once the outlier is removed?'**
  String get labsDataDetectivePredictionPrompt;

  /// No description provided for @labsDataDetectivePredictMeanButton.
  ///
  /// In en, this message translates to:
  /// **'Mean'**
  String get labsDataDetectivePredictMeanButton;

  /// No description provided for @labsDataDetectivePredictMedianButton.
  ///
  /// In en, this message translates to:
  /// **'Median'**
  String get labsDataDetectivePredictMedianButton;

  /// No description provided for @labsDataDetectiveRevealButton.
  ///
  /// In en, this message translates to:
  /// **'Remove outlier & reveal'**
  String get labsDataDetectiveRevealButton;

  /// No description provided for @labsDataDetectiveCorrectPrediction.
  ///
  /// In en, this message translates to:
  /// **'Correct prediction!'**
  String get labsDataDetectiveCorrectPrediction;

  /// No description provided for @labsDataDetectiveIncorrectPrediction.
  ///
  /// In en, this message translates to:
  /// **'Not quite — look at the shift below.'**
  String get labsDataDetectiveIncorrectPrediction;

  /// Data Detective before/after shift comparison
  ///
  /// In en, this message translates to:
  /// **'Mean moved by {meanShift}, median moved by {medianShift}.'**
  String labsDataDetectiveShiftSummary(String meanShift, String medianShift);

  /// No description provided for @labsDataDetectiveMeanLabel.
  ///
  /// In en, this message translates to:
  /// **'Mean'**
  String get labsDataDetectiveMeanLabel;

  /// No description provided for @labsDataDetectiveMedianLabel.
  ///
  /// In en, this message translates to:
  /// **'Median'**
  String get labsDataDetectiveMedianLabel;

  /// No description provided for @labsDataDetectiveRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get labsDataDetectiveRangeLabel;

  /// No description provided for @labsSpatialCubeLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Spatial Cube Lab'**
  String get labsSpatialCubeLabTitle;

  /// No description provided for @labsSpatialCubeLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rotate, fold and explore a labelled cube'**
  String get labsSpatialCubeLabSubtitle;

  /// No description provided for @labsSpatialCubeLabIntro.
  ///
  /// In en, this message translates to:
  /// **'Drag the cube to turn it. Notice how faces stay in the same place relative to each other, no matter which way you turn.'**
  String get labsSpatialCubeLabIntro;

  /// No description provided for @labsSpatialCubeLabFreePlayCaption.
  ///
  /// In en, this message translates to:
  /// **'Try it: drag the cube, or use the buttons below.'**
  String get labsSpatialCubeLabFreePlayCaption;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeTitle.
  ///
  /// In en, this message translates to:
  /// **'Which Face Is Opposite?'**
  String get labsSpatialCubeWhichFaceOppositeTitle;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Predict the opposite face, then check by rotating'**
  String get labsSpatialCubeWhichFaceOppositeSubtitle;

  /// No description provided for @labsSpatialCubeRotateToMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Rotate to Match'**
  String get labsSpatialCubeRotateToMatchTitle;

  /// No description provided for @labsSpatialCubeRotateToMatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your cube to match the target orientation'**
  String get labsSpatialCubeRotateToMatchSubtitle;

  /// No description provided for @labsSpatialCubeHiddenFaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Hidden Face'**
  String get labsSpatialCubeHiddenFaceTitle;

  /// No description provided for @labsSpatialCubeHiddenFaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Work out which label is on a face you can\'t see'**
  String get labsSpatialCubeHiddenFaceSubtitle;

  /// No description provided for @labsSpatialCubeNetExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Cube Net Explorer'**
  String get labsSpatialCubeNetExplorerTitle;

  /// No description provided for @labsSpatialCubeNetExplorerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Predict opposite faces on a flat net, then fold it'**
  String get labsSpatialCubeNetExplorerSubtitle;

  /// No description provided for @labsEarlyMathsPlaygroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Early Maths Playground'**
  String get labsEarlyMathsPlaygroundTitle;

  /// No description provided for @labsEarlyMathsPlaygroundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calm, playful counting activities for younger learners'**
  String get labsEarlyMathsPlaygroundSubtitle;

  /// No description provided for @earlyMathsPlaygroundIntro.
  ///
  /// In en, this message translates to:
  /// **'A calm, untimed space for younger learners to practise counting — no scores, no timers, no pressure.'**
  String get earlyMathsPlaygroundIntro;

  /// No description provided for @feedTheHungryPandaTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed the Hungry Panda'**
  String get feedTheHungryPandaTitle;

  /// No description provided for @feedTheHungryPandaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Count out apples one at a time to feed Panda'**
  String get feedTheHungryPandaSubtitle;

  /// The quantity instruction at the top of a Feed the Hungry Panda round
  ///
  /// In en, this message translates to:
  /// **'Feed Panda {count, plural, =1{1 apple} other{{count} apples}}.'**
  String feedPandaInstruction(int count);

  /// Shown once the target count is reached
  ///
  /// In en, this message translates to:
  /// **'Well done! Panda ate {count, plural, =1{1 apple} other{{count} apples}}.'**
  String feedPandaWellDone(int count);

  /// No description provided for @feedPandaHowManyLeft.
  ///
  /// In en, this message translates to:
  /// **'How many apples are left?'**
  String get feedPandaHowManyLeft;

  /// Gentle response shown after an attempt to feed Panda beyond the target count
  ///
  /// In en, this message translates to:
  /// **'Panda has enough. Let\'s count together.'**
  String get feedPandaHasEnough;

  /// No description provided for @feedPandaReplayInstructionButton.
  ///
  /// In en, this message translates to:
  /// **'Replay instruction'**
  String get feedPandaReplayInstructionButton;

  /// No description provided for @feedPandaNewRoundButton.
  ///
  /// In en, this message translates to:
  /// **'New Round'**
  String get feedPandaNewRoundButton;

  /// Semantic label for one apple tile in the source matrix
  ///
  /// In en, this message translates to:
  /// **'Apple {position} of {total}. Double tap to select.'**
  String feedPandaFruitSemanticLabel(int position, int total);

  /// No description provided for @feedPandaSelectedSuffix.
  ///
  /// In en, this message translates to:
  /// **'Selected.'**
  String get feedPandaSelectedSuffix;

  /// Semantic label for Panda's drop target while still accepting fruit
  ///
  /// In en, this message translates to:
  /// **'Feed Panda. {remaining, plural, =1{1 more apple needed} other{{remaining} more apples needed}}.'**
  String feedPandaPandaSemanticReady(int remaining);

  /// No description provided for @feedPandaPandaSemanticFull.
  ///
  /// In en, this message translates to:
  /// **'Panda has enough for this round.'**
  String get feedPandaPandaSemanticFull;

  /// Semantic label for one remaining-quantity answer choice
  ///
  /// In en, this message translates to:
  /// **'Answer {value}.'**
  String feedPandaAnswerChoiceSemanticLabel(int value);

  /// No description provided for @feedPandaTryAgainMessage.
  ///
  /// In en, this message translates to:
  /// **'Not quite — let\'s try again!'**
  String get feedPandaTryAgainMessage;

  /// No description provided for @feedPandaRoundCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You counted brilliantly!'**
  String get feedPandaRoundCompleteMessage;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeMission.
  ///
  /// In en, this message translates to:
  /// **'Look at the cube, then decide which face is opposite the one asked about.'**
  String get labsSpatialCubeWhichFaceOppositeMission;

  /// Which Face Is Opposite? question prompt
  ///
  /// In en, this message translates to:
  /// **'Which face is opposite {faceLabel}?'**
  String labsSpatialCubeWhichFaceOppositeQuestion(String faceLabel);

  /// No description provided for @labsSpatialCubeWhichFaceOppositeHintButton.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get labsSpatialCubeWhichFaceOppositeHintButton;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeHintText.
  ///
  /// In en, this message translates to:
  /// **'Opposite faces never share an edge — front/back, top/bottom and left/right are always the three pairs.'**
  String get labsSpatialCubeWhichFaceOppositeHintText;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeCorrect.
  ///
  /// In en, this message translates to:
  /// **'Good thinking. You kept the face relationships in mind.'**
  String get labsSpatialCubeWhichFaceOppositeCorrect;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Nearly there. Try looking at which faces share an edge.'**
  String get labsSpatialCubeWhichFaceOppositeIncorrect;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Packing boxes, reading dice, and working with 3D nets all rely on knowing which faces of a cube are opposite each other.'**
  String get labsSpatialCubeWhichFaceOppositeWhereUsed;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Rotate the cube if you like, then choose the face you think is opposite the one asked about.'**
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToDo;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice that opposite faces are never next to each other, however you turn the cube.'**
  String get labsSpatialCubeWhichFaceOppositeHelpWhatToNotice;

  /// No description provided for @labsSpatialCubeWhichFaceOppositeHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'Every cube has exactly three pairs of opposite faces — front/back, top/bottom, left/right — and rotating the cube never changes which faces are paired.'**
  String get labsSpatialCubeWhichFaceOppositeHelpWhatItMeans;

  /// Reveals the correct opposite-face answer after an attempt
  ///
  /// In en, this message translates to:
  /// **'{correctLabel} is opposite {askedLabel}.'**
  String labsSpatialCubeWhichFaceOppositeReveal(
      String correctLabel, String askedLabel);

  /// No description provided for @labsSpatialCubeRotateToMatchMission.
  ///
  /// In en, this message translates to:
  /// **'Rotate your cube until it matches the target orientation shown.'**
  String get labsSpatialCubeRotateToMatchMission;

  /// No description provided for @labsSpatialCubeRotateToMatchTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Target orientation'**
  String get labsSpatialCubeRotateToMatchTargetLabel;

  /// No description provided for @labsSpatialCubeRotateToMatchYourCubeLabel.
  ///
  /// In en, this message translates to:
  /// **'Your cube'**
  String get labsSpatialCubeRotateToMatchYourCubeLabel;

  /// No description provided for @labsSpatialCubeRotateToMatchTestButton.
  ///
  /// In en, this message translates to:
  /// **'Test my rotation'**
  String get labsSpatialCubeRotateToMatchTestButton;

  /// No description provided for @labsSpatialCubeRotateToMatchCorrect.
  ///
  /// In en, this message translates to:
  /// **'Well done — that\'s a close match.'**
  String get labsSpatialCubeRotateToMatchCorrect;

  /// No description provided for @labsSpatialCubeRotateToMatchIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite yet. Compare which face is at the front and which is on top.'**
  String get labsSpatialCubeRotateToMatchIncorrect;

  /// No description provided for @labsSpatialCubeRotateToMatchWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Matching an object\'s orientation to a diagram is part of reading technical drawings and assembly instructions.'**
  String get labsSpatialCubeRotateToMatchWhereUsed;

  /// No description provided for @labsSpatialCubeRotateToMatchHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Drag your cube so its faces line up with the target shown alongside it, then test your rotation.'**
  String get labsSpatialCubeRotateToMatchHelpWhatToDo;

  /// No description provided for @labsSpatialCubeRotateToMatchHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice you don\'t need a pixel-perfect match — being close enough that the same faces are at the front and top counts.'**
  String get labsSpatialCubeRotateToMatchHelpWhatToNotice;

  /// No description provided for @labsSpatialCubeRotateToMatchHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'An orientation is fully described by which face is at the front and which is on top — those two facts fix everything else.'**
  String get labsSpatialCubeRotateToMatchHelpWhatItMeans;

  /// No description provided for @labsSpatialCubeHiddenFaceMission.
  ///
  /// In en, this message translates to:
  /// **'Look at the three visible faces, then work out what\'s on the hidden one.'**
  String get labsSpatialCubeHiddenFaceMission;

  /// Hidden Face question prompt
  ///
  /// In en, this message translates to:
  /// **'Which label is on the face {direction}?'**
  String labsSpatialCubeHiddenFaceQuestion(String direction);

  /// No description provided for @labsSpatialCubeHiddenFaceHintButton.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get labsSpatialCubeHiddenFaceHintButton;

  /// No description provided for @labsSpatialCubeHiddenFaceHintText.
  ///
  /// In en, this message translates to:
  /// **'Work out which faces you CAN see first — the hidden face is one of the three left over.'**
  String get labsSpatialCubeHiddenFaceHintText;

  /// No description provided for @labsSpatialCubeHiddenFaceCorrect.
  ///
  /// In en, this message translates to:
  /// **'Well done. You predicted the hidden face correctly.'**
  String get labsSpatialCubeHiddenFaceCorrect;

  /// No description provided for @labsSpatialCubeHiddenFaceIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Good attempt. Rotate the cube to check, then try the next one.'**
  String get labsSpatialCubeHiddenFaceIncorrect;

  /// No description provided for @labsSpatialCubeHiddenFaceWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Reading isometric diagrams and technical drawings means reasoning about faces you can\'t directly see.'**
  String get labsSpatialCubeHiddenFaceWhereUsed;

  /// No description provided for @labsSpatialCubeHiddenFaceHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Look at the three faces you can see, then choose the label you think is on the hidden face named.'**
  String get labsSpatialCubeHiddenFaceHelpWhatToDo;

  /// No description provided for @labsSpatialCubeHiddenFaceHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice only three faces are ever visible at once from this angle — the other three are always hidden.'**
  String get labsSpatialCubeHiddenFaceHelpWhatToNotice;

  /// No description provided for @labsSpatialCubeHiddenFaceHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'A cube only ever shows three faces from one viewpoint, so working out a hidden face means reasoning about the whole cube, not just what\'s in view.'**
  String get labsSpatialCubeHiddenFaceHelpWhatItMeans;

  /// No description provided for @labsSpatialCubeNetExplorerMission.
  ///
  /// In en, this message translates to:
  /// **'Look at the flat net, predict which faces will end up opposite each other, then fold it to check.'**
  String get labsSpatialCubeNetExplorerMission;

  /// No description provided for @labsSpatialCubeNetExplorerPredictPrompt.
  ///
  /// In en, this message translates to:
  /// **'Which two squares do you think will end up opposite each other?'**
  String get labsSpatialCubeNetExplorerPredictPrompt;

  /// No description provided for @labsSpatialCubeNetExplorerFoldButton.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get labsSpatialCubeNetExplorerFoldButton;

  /// No description provided for @labsSpatialCubeNetExplorerUnfoldButton.
  ///
  /// In en, this message translates to:
  /// **'Unfold'**
  String get labsSpatialCubeNetExplorerUnfoldButton;

  /// No description provided for @labsSpatialCubeNetExplorerNextNetButton.
  ///
  /// In en, this message translates to:
  /// **'Next net'**
  String get labsSpatialCubeNetExplorerNextNetButton;

  /// No description provided for @labsSpatialCubeNetExplorerStepBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get labsSpatialCubeNetExplorerStepBackButton;

  /// No description provided for @labsSpatialCubeNetExplorerStepForwardButton.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get labsSpatialCubeNetExplorerStepForwardButton;

  /// No description provided for @labsSpatialCubeNetExplorerWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Packaging design and sheet-metal work both start from a flat net that folds into a finished 3D shape.'**
  String get labsSpatialCubeNetExplorerWhereUsed;

  /// No description provided for @labsSpatialCubeNetExplorerHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Study the flat net, then press Fold to see whether it closes into a cube.'**
  String get labsSpatialCubeNetExplorerHelpWhatToDo;

  /// No description provided for @labsSpatialCubeNetExplorerHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice that not every arrangement of six squares folds into a closed cube — some overlap or leave a gap.'**
  String get labsSpatialCubeNetExplorerHelpWhatToNotice;

  /// No description provided for @labsSpatialCubeNetExplorerHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'A net is a 2D shape that folds along its edges into a 3D solid — the same square can end up on very different sides of the cube depending on the net\'s shape.'**
  String get labsSpatialCubeNetExplorerHelpWhatItMeans;

  /// No description provided for @labsAircraftLandingLabTitle.
  ///
  /// In en, this message translates to:
  /// **'Aircraft Landing Lab'**
  String get labsAircraftLandingLabTitle;

  /// No description provided for @labsAircraftLandingLabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fly the descent angle, distance and speed that bring a plane in safely'**
  String get labsAircraftLandingLabSubtitle;

  /// No description provided for @labsAircraftLandingLabIntro.
  ///
  /// In en, this message translates to:
  /// **'Adjust the descent angle and speed, then press Test Approach to watch the aircraft fly the path and see where it touches down.'**
  String get labsAircraftLandingLabIntro;

  /// No description provided for @labsAircraftLandingLabFreePlayCaption.
  ///
  /// In en, this message translates to:
  /// **'Try it: drag the sliders, then press Test Approach.'**
  String get labsAircraftLandingLabFreePlayCaption;

  /// No description provided for @labsAircraftLandingFindTheTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the Time'**
  String get labsAircraftLandingFindTheTimeTitle;

  /// No description provided for @labsAircraftLandingFindTheTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Work out how long the flight to the runway takes'**
  String get labsAircraftLandingFindTheTimeSubtitle;

  /// No description provided for @labsAircraftLandingDescentLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the Descent Line'**
  String get labsAircraftLandingDescentLineTitle;

  /// No description provided for @labsAircraftLandingDescentLineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Match your descent angle to a target glide line'**
  String get labsAircraftLandingDescentLineSubtitle;

  /// No description provided for @labsAircraftLandingGlidePathTitle.
  ///
  /// In en, this message translates to:
  /// **'Land on the Glide Path'**
  String get labsAircraftLandingGlidePathTitle;

  /// No description provided for @labsAircraftLandingGlidePathSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose angle and speed to land safely on the runway'**
  String get labsAircraftLandingGlidePathSubtitle;

  /// No description provided for @labsAircraftLandingVectorApproachTitle.
  ///
  /// In en, this message translates to:
  /// **'Vector Approach'**
  String get labsAircraftLandingVectorApproachTitle;

  /// No description provided for @labsAircraftLandingVectorApproachSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust horizontal and vertical speed to match a target approach'**
  String get labsAircraftLandingVectorApproachSubtitle;

  /// Descent angle slider label
  ///
  /// In en, this message translates to:
  /// **'Descent angle: {degrees}°'**
  String labsAircraftLandingDescentAngleLabel(int degrees);

  /// Airspeed slider label
  ///
  /// In en, this message translates to:
  /// **'Airspeed: {metresPerSecond} m/s'**
  String labsAircraftLandingAirspeedLabel(int metresPerSecond);

  /// No description provided for @labsAircraftLandingTestApproachButton.
  ///
  /// In en, this message translates to:
  /// **'Test Approach'**
  String get labsAircraftLandingTestApproachButton;

  /// Find the Time diagram semantic label
  ///
  /// In en, this message translates to:
  /// **'An aircraft {distanceM} metres from the runway, flying at {speedMps} metres per second.'**
  String labsAircraftLandingFindTheTimeDiagramLabel(
      int distanceM, int speedMps);

  /// Find the Time speed readout
  ///
  /// In en, this message translates to:
  /// **'Speed: {speedMps} m/s'**
  String labsAircraftLandingFindTheTimeSpeedLabel(int speedMps);

  /// No description provided for @labsAircraftLandingFindTheTimeQuestion.
  ///
  /// In en, this message translates to:
  /// **'How long will it take to reach the runway?'**
  String get labsAircraftLandingFindTheTimeQuestion;

  /// No description provided for @labsAircraftLandingFindTheTimeHintButton.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get labsAircraftLandingFindTheTimeHintButton;

  /// No description provided for @labsAircraftLandingFindTheTimeHintText.
  ///
  /// In en, this message translates to:
  /// **'Time = distance ÷ speed.'**
  String get labsAircraftLandingFindTheTimeHintText;

  /// No description provided for @labsAircraftLandingFindTheTimeMission.
  ///
  /// In en, this message translates to:
  /// **'Use the distance and speed shown to work out how long the flight to the runway will take.'**
  String get labsAircraftLandingFindTheTimeMission;

  /// No description provided for @labsAircraftLandingFindTheTimeWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Pilots and air traffic controllers constantly estimate time-to-runway from speed and distance to sequence safe landings.'**
  String get labsAircraftLandingFindTheTimeWhereUsed;

  /// No description provided for @labsAircraftLandingFindTheTimeCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct — you found the time to the runway.'**
  String get labsAircraftLandingFindTheTimeCorrect;

  /// No description provided for @labsAircraftLandingFindTheTimeIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Try dividing the distance by the speed.'**
  String get labsAircraftLandingFindTheTimeIncorrect;

  /// Reveals the correct time-to-runway after an attempt
  ///
  /// In en, this message translates to:
  /// **'The correct time is {seconds} seconds.'**
  String labsAircraftLandingFindTheTimeReveal(int seconds);

  /// No description provided for @labsAircraftLandingFindTheTimeHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Read the distance and speed shown, then choose the matching time from the options.'**
  String get labsAircraftLandingFindTheTimeHelpWhatToDo;

  /// No description provided for @labsAircraftLandingFindTheTimeHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice that a faster speed always means a shorter time for the same distance.'**
  String get labsAircraftLandingFindTheTimeHelpWhatToNotice;

  /// No description provided for @labsAircraftLandingFindTheTimeHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'Time, distance and speed are always connected by time = distance ÷ speed — the same relationship used for any journey, not just flights.'**
  String get labsAircraftLandingFindTheTimeHelpWhatItMeans;

  /// No description provided for @labsAircraftLandingDescentLineTestButton.
  ///
  /// In en, this message translates to:
  /// **'Test my line'**
  String get labsAircraftLandingDescentLineTestButton;

  /// No description provided for @labsAircraftLandingDescentLineMission.
  ///
  /// In en, this message translates to:
  /// **'Adjust your descent angle until your line matches the dashed target line.'**
  String get labsAircraftLandingDescentLineMission;

  /// No description provided for @labsAircraftLandingDescentLineWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Matching a required gradient comes up whenever a path, ramp or pipe has to follow a fixed slope.'**
  String get labsAircraftLandingDescentLineWhereUsed;

  /// No description provided for @labsAircraftLandingDescentLineCorrect.
  ///
  /// In en, this message translates to:
  /// **'Well done — your line matches the target glide path.'**
  String get labsAircraftLandingDescentLineCorrect;

  /// No description provided for @labsAircraftLandingDescentLineIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not yet. Compare how steep your line is against the dashed target.'**
  String get labsAircraftLandingDescentLineIncorrect;

  /// No description provided for @labsAircraftLandingDescentLineHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Move the descent-angle slider until your solid line sits on top of the dashed target line, then test it.'**
  String get labsAircraftLandingDescentLineHelpWhatToDo;

  /// No description provided for @labsAircraftLandingDescentLineHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice that a steeper angle makes the line fall faster — a bigger negative gradient.'**
  String get labsAircraftLandingDescentLineHelpWhatToNotice;

  /// No description provided for @labsAircraftLandingDescentLineHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'The descent angle is the line\'s gradient: altitude change divided by distance travelled, written as y = mx + c with a negative m.'**
  String get labsAircraftLandingDescentLineHelpWhatItMeans;

  /// No description provided for @labsAircraftLandingGlidePathSafe.
  ///
  /// In en, this message translates to:
  /// **'Smooth landing — right on the runway.'**
  String get labsAircraftLandingGlidePathSafe;

  /// No description provided for @labsAircraftLandingGlidePathTooSteep.
  ///
  /// In en, this message translates to:
  /// **'Too steep — the aircraft touched down before the runway.'**
  String get labsAircraftLandingGlidePathTooSteep;

  /// No description provided for @labsAircraftLandingGlidePathTooShallow.
  ///
  /// In en, this message translates to:
  /// **'Too shallow — the aircraft was still airborne past the runway.'**
  String get labsAircraftLandingGlidePathTooShallow;

  /// No description provided for @labsAircraftLandingGlidePathMission.
  ///
  /// In en, this message translates to:
  /// **'Choose an angle and speed, then test your approach to land safely on the runway.'**
  String get labsAircraftLandingGlidePathMission;

  /// No description provided for @labsAircraftLandingGlidePathWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Every real landing balances a safe descent angle against speed and distance to touch down in exactly the right place.'**
  String get labsAircraftLandingGlidePathWhereUsed;

  /// Touchdown error distance shown after a test approach
  ///
  /// In en, this message translates to:
  /// **'{metres} metres from the runway threshold.'**
  String labsAircraftLandingGlidePathTouchdownError(int metres);

  /// No description provided for @labsAircraftLandingGlidePathHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Adjust the angle and speed, then press Test Approach to see where the aircraft actually touches down.'**
  String get labsAircraftLandingGlidePathHelpWhatToDo;

  /// No description provided for @labsAircraftLandingGlidePathHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice how the touchdown point moves as you change the angle, even when the speed stays the same.'**
  String get labsAircraftLandingGlidePathHelpWhatToNotice;

  /// No description provided for @labsAircraftLandingGlidePathHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'tan(angle) = altitude ÷ distance — this exact ratio is what makes a descent land precisely on the runway instead of short or long.'**
  String get labsAircraftLandingGlidePathHelpWhatItMeans;

  /// Vector Approach horizontal speed slider label
  ///
  /// In en, this message translates to:
  /// **'Horizontal speed: {metresPerSecond} m/s'**
  String labsAircraftLandingVectorHorizontalLabel(int metresPerSecond);

  /// Vector Approach vertical speed slider label
  ///
  /// In en, this message translates to:
  /// **'Vertical speed: {metresPerSecond} m/s'**
  String labsAircraftLandingVectorVerticalLabel(int metresPerSecond);

  /// Vector Approach resultant speed readout
  ///
  /// In en, this message translates to:
  /// **'Combined (resultant) speed: {metresPerSecond} m/s'**
  String labsAircraftLandingVectorResultantLabel(int metresPerSecond);

  /// No description provided for @labsAircraftLandingVectorApproachMission.
  ///
  /// In en, this message translates to:
  /// **'Adjust the horizontal and vertical speed components to match the target approach.'**
  String get labsAircraftLandingVectorApproachMission;

  /// No description provided for @labsAircraftLandingVectorApproachWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Combining a horizontal and vertical speed into one resultant vector is exactly how a real flight path, or any 2D motion, is described mathematically.'**
  String get labsAircraftLandingVectorApproachWhereUsed;

  /// No description provided for @labsAircraftLandingVectorApproachCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct — your components match the target approach.'**
  String get labsAircraftLandingVectorApproachCorrect;

  /// No description provided for @labsAircraftLandingVectorApproachIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not yet. Compare your horizontal and vertical speeds to the target.'**
  String get labsAircraftLandingVectorApproachIncorrect;

  /// No description provided for @labsAircraftLandingVectorApproachHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Adjust the horizontal and vertical speed sliders, then test your approach.'**
  String get labsAircraftLandingVectorApproachHelpWhatToDo;

  /// No description provided for @labsAircraftLandingVectorApproachHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice how the resultant speed and the descent path both change as you adjust either component.'**
  String get labsAircraftLandingVectorApproachHelpWhatToNotice;

  /// No description provided for @labsAircraftLandingVectorApproachHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'Any velocity can be split into a horizontal and a vertical component, and recombined using Pythagoras\' theorem to find the resultant speed.'**
  String get labsAircraftLandingVectorApproachHelpWhatItMeans;

  /// No description provided for @labsTryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get labsTryAgainButton;

  /// No description provided for @labsHelpButton.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get labsHelpButton;

  /// No description provided for @labsNarrationReplayButton.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get labsNarrationReplayButton;

  /// No description provided for @labsNarrationSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'CAPTAIN MATH NARRATION'**
  String get labsNarrationSectionLabel;

  /// No description provided for @labsNarrationOnOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get labsNarrationOnOffLabel;

  /// No description provided for @labsNarrationTextOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Text only (no spoken audio)'**
  String get labsNarrationTextOnlyLabel;

  /// No description provided for @labsNarrationSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get labsNarrationSpeedLabel;

  /// No description provided for @labsNarrationSpeedSlower.
  ///
  /// In en, this message translates to:
  /// **'Slower'**
  String get labsNarrationSpeedSlower;

  /// No description provided for @labsNarrationSpeedNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get labsNarrationSpeedNormal;

  /// No description provided for @labsNarrationSpeedFaster.
  ///
  /// In en, this message translates to:
  /// **'Faster'**
  String get labsNarrationSpeedFaster;

  /// No description provided for @labsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get labsHelpTitle;

  /// No description provided for @labsHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'What to do'**
  String get labsHelpWhatToDo;

  /// No description provided for @labsHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'What to notice'**
  String get labsHelpWhatToNotice;

  /// No description provided for @labsHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'What the maths means'**
  String get labsHelpWhatItMeans;

  /// No description provided for @labsHelpWhereUsed.
  ///
  /// In en, this message translates to:
  /// **'Where this is used'**
  String get labsHelpWhereUsed;

  /// No description provided for @labsFirstUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you start'**
  String get labsFirstUseTitle;

  /// No description provided for @labsFirstUseGotItButton.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get labsFirstUseGotItButton;

  /// No description provided for @labsGuidanceLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Guidance level'**
  String get labsGuidanceLevelLabel;

  /// No description provided for @labsGuidanceExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get labsGuidanceExplorer;

  /// No description provided for @labsGuidanceBuilder.
  ///
  /// In en, this message translates to:
  /// **'Builder'**
  String get labsGuidanceBuilder;

  /// No description provided for @labsGuidanceNavigator.
  ///
  /// In en, this message translates to:
  /// **'Navigator'**
  String get labsGuidanceNavigator;

  /// No description provided for @labsDirectionAway.
  ///
  /// In en, this message translates to:
  /// **'Away from you'**
  String get labsDirectionAway;

  /// No description provided for @labsDirectionRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get labsDirectionRight;

  /// No description provided for @labsDirectionToward.
  ///
  /// In en, this message translates to:
  /// **'Toward you'**
  String get labsDirectionToward;

  /// No description provided for @labsDirectionLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get labsDirectionLeft;

  /// No description provided for @labsFlightPathLabMission.
  ///
  /// In en, this message translates to:
  /// **'Point the plane toward the yellow target, then press Test Flight to see where it lands.'**
  String get labsFlightPathLabMission;

  /// Flight Path Lab heading label for Explorer/Builder bands, combining a plain direction word with the formal degree value
  ///
  /// In en, this message translates to:
  /// **'Direction: {direction}  •  Heading: {degrees}°'**
  String labsFlightPathLabHeadingLabel(String direction, int degrees);

  /// Flight Path Lab heading label for the Navigator band — formal three-figure bearing only, already formatted e.g. "090°"
  ///
  /// In en, this message translates to:
  /// **'Heading: {bearing}'**
  String labsFlightPathLabHeadingNavigatorLabel(String bearing);

  /// No description provided for @labsFlightPathLabHeadingHelper.
  ///
  /// In en, this message translates to:
  /// **'Turn this to choose which way the plane points'**
  String get labsFlightPathLabHeadingHelper;

  /// No description provided for @labsFlightPathLabSpeedHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose how far the plane should travel'**
  String get labsFlightPathLabSpeedHelper;

  /// Flight Path Lab explicit target explanation
  ///
  /// In en, this message translates to:
  /// **'The yellow marker is your target. It is {distance} km away, on a bearing of {bearing}.'**
  String labsFlightPathLabTargetExplanation(int distance, String bearing);

  /// No description provided for @labsFlightPathLabPredictionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Before you test: will you land short, on target, or overshoot?'**
  String get labsFlightPathLabPredictionPrompt;

  /// No description provided for @labsFlightPathLabPredictShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get labsFlightPathLabPredictShort;

  /// No description provided for @labsFlightPathLabPredictOnTarget.
  ///
  /// In en, this message translates to:
  /// **'On target'**
  String get labsFlightPathLabPredictOnTarget;

  /// No description provided for @labsFlightPathLabPredictOver.
  ///
  /// In en, this message translates to:
  /// **'Overshoot'**
  String get labsFlightPathLabPredictOver;

  /// No description provided for @labsFlightPathLabHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Set the heading and speed, make a prediction if asked, then press Test Flight.'**
  String get labsFlightPathLabHelpWhatToDo;

  /// No description provided for @labsFlightPathLabHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice how far from the target the plane lands, and which way you need to adjust.'**
  String get labsFlightPathLabHelpWhatToNotice;

  /// No description provided for @labsFlightPathLabHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'A steady heading and speed, held for a fixed time, always lead to exactly one landing point — that\'s speed, distance and time combined with direction.'**
  String get labsFlightPathLabHelpWhatItMeans;

  /// No description provided for @labsFlightPathLabFirstUseStep1.
  ///
  /// In en, this message translates to:
  /// **'Point the plane toward the yellow target.'**
  String get labsFlightPathLabFirstUseStep1;

  /// No description provided for @labsFlightPathLabFirstUseStep2.
  ///
  /// In en, this message translates to:
  /// **'Choose how far the plane should travel.'**
  String get labsFlightPathLabFirstUseStep2;

  /// No description provided for @labsFlightPathLabFirstUseStep3.
  ///
  /// In en, this message translates to:
  /// **'Press Test Flight to see where it lands.'**
  String get labsFlightPathLabFirstUseStep3;

  /// No description provided for @labsDataDetectiveMission.
  ///
  /// In en, this message translates to:
  /// **'Predict what happens to the mean and median, then remove the unusual value to find out.'**
  String get labsDataDetectiveMission;

  /// Data Detective explicit explanation of the unusual value
  ///
  /// In en, this message translates to:
  /// **'One value, {outlier}, stands out from the rest — it\'s much higher or lower than the others. That\'s called an outlier.'**
  String labsDataDetectiveOutlierExplanation(int outlier);

  /// Data Detective before/after mean and median comparison
  ///
  /// In en, this message translates to:
  /// **'Mean: {meanBefore} → {meanAfter}. Median: {medianBefore} → {medianAfter}.'**
  String labsDataDetectiveBeforeAfter(String meanBefore, String meanAfter,
      String medianBefore, String medianAfter);

  /// No description provided for @labsDataDetectiveHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Look at the values, predict whether the mean or median will change more, then remove the outlier to reveal the answer.'**
  String get labsDataDetectiveHelpWhatToDo;

  /// No description provided for @labsDataDetectiveHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice how much the mean moves compared to the median once the outlier is gone.'**
  String get labsDataDetectiveHelpWhatToNotice;

  /// No description provided for @labsDataDetectiveHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'The mean uses every value, so one extreme value can pull it a long way. The median only depends on the middle position, so it barely moves.'**
  String get labsDataDetectiveHelpWhatItMeans;

  /// No description provided for @labsDataDetectiveFirstUseStep1.
  ///
  /// In en, this message translates to:
  /// **'Look at the list of values — one of them stands out.'**
  String get labsDataDetectiveFirstUseStep1;

  /// No description provided for @labsDataDetectiveFirstUseStep2.
  ///
  /// In en, this message translates to:
  /// **'Predict which will change more: the mean or the median.'**
  String get labsDataDetectiveFirstUseStep2;

  /// No description provided for @labsDataDetectiveFirstUseStep3.
  ///
  /// In en, this message translates to:
  /// **'Remove the outlier and reveal the answer.'**
  String get labsDataDetectiveFirstUseStep3;

  /// No description provided for @labsAlgebraBalanceMission.
  ///
  /// In en, this message translates to:
  /// **'Keep both sides balanced until x is on its own.'**
  String get labsAlgebraBalanceMission;

  /// Algebra Balance concrete step-1 button when the constant is positive
  ///
  /// In en, this message translates to:
  /// **'Remove {value} from both sides'**
  String labsAlgebraBalanceStep1RemoveButton(int value);

  /// Algebra Balance concrete step-1 button when the constant is negative
  ///
  /// In en, this message translates to:
  /// **'Add {value} to both sides'**
  String labsAlgebraBalanceStep1AddButton(int value);

  /// Algebra Balance concrete step-2 button once the constant is cleared
  ///
  /// In en, this message translates to:
  /// **'Divide both sides by {value}'**
  String labsAlgebraBalanceStep2DivideButton(int value);

  /// No description provided for @labsAlgebraBalanceHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Clear the number term first, then divide to leave x on its own.'**
  String get labsAlgebraBalanceHelpWhatToDo;

  /// No description provided for @labsAlgebraBalanceHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice that both pans always change together, by the same amount — the equation never stops being true.'**
  String get labsAlgebraBalanceHelpWhatToNotice;

  /// No description provided for @labsAlgebraBalanceHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'Doing the same operation to both sides of an equation keeps it balanced, which is how you can safely simplify down to just x.'**
  String get labsAlgebraBalanceHelpWhatItMeans;

  /// No description provided for @labsAlgebraBalanceFirstUseStep1.
  ///
  /// In en, this message translates to:
  /// **'Look at the equation and the balance below it.'**
  String get labsAlgebraBalanceFirstUseStep1;

  /// No description provided for @labsAlgebraBalanceFirstUseStep2.
  ///
  /// In en, this message translates to:
  /// **'Use the buttons to simplify both sides together.'**
  String get labsAlgebraBalanceFirstUseStep2;

  /// No description provided for @labsAlgebraBalanceFirstUseStep3.
  ///
  /// In en, this message translates to:
  /// **'Keep going until x stands alone.'**
  String get labsAlgebraBalanceFirstUseStep3;

  /// Fraction Builder mission statement
  ///
  /// In en, this message translates to:
  /// **'Fill in {numerator} out of {denominator} equal parts.'**
  String labsFractionBuilderMission(int numerator, int denominator);

  /// No description provided for @labsFractionBuilderTapGuidance.
  ///
  /// In en, this message translates to:
  /// **'Tap a segment to fill it in, or tap again to empty it.'**
  String get labsFractionBuilderTapGuidance;

  /// Fraction Builder symbolic + visual result shown after a correct check
  ///
  /// In en, this message translates to:
  /// **'{numerator}/{denominator} — {numerator} equal part(s) filled out of {denominator}.'**
  String labsFractionBuilderSymbolicResult(int numerator, int denominator);

  /// No description provided for @labsFractionBuilderHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Tap segments until the number filled matches the fraction, then press Check.'**
  String get labsFractionBuilderHelpWhatToDo;

  /// No description provided for @labsFractionBuilderHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice that the denominator is the total number of equal parts, and the numerator is how many are filled.'**
  String get labsFractionBuilderHelpWhatToNotice;

  /// No description provided for @labsFractionBuilderHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'A fraction counts equal parts of a whole — the same idea whether it\'s a bar, a pizza, or a measuring cup.'**
  String get labsFractionBuilderHelpWhatItMeans;

  /// No description provided for @labsFractionBuilderFirstUseStep1.
  ///
  /// In en, this message translates to:
  /// **'Look at how many parts to fill in.'**
  String get labsFractionBuilderFirstUseStep1;

  /// No description provided for @labsFractionBuilderFirstUseStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap segments to fill them in.'**
  String get labsFractionBuilderFirstUseStep2;

  /// No description provided for @labsFractionBuilderFirstUseStep3.
  ///
  /// In en, this message translates to:
  /// **'Press Check to see if you matched the fraction.'**
  String get labsFractionBuilderFirstUseStep3;

  /// Number Line Explorer mission statement
  ///
  /// In en, this message translates to:
  /// **'Move the point to {target}.'**
  String labsNumberLineExplorerMission(String target);

  /// Number Line Explorer explicit start-point instruction
  ///
  /// In en, this message translates to:
  /// **'Start at {min} and move the point to the target.'**
  String labsNumberLineExplorerStartInstruction(String min);

  /// Number Line Explorer direction/distance helper when the target is to the right
  ///
  /// In en, this message translates to:
  /// **'Move {distance} more to the right'**
  String labsNumberLineExplorerMoveRight(String distance);

  /// Number Line Explorer direction/distance helper when the target is to the left
  ///
  /// In en, this message translates to:
  /// **'Move {distance} more to the left'**
  String labsNumberLineExplorerMoveLeft(String distance);

  /// No description provided for @labsNumberLineExplorerIncreaseButton.
  ///
  /// In en, this message translates to:
  /// **'Move right'**
  String get labsNumberLineExplorerIncreaseButton;

  /// No description provided for @labsNumberLineExplorerDecreaseButton.
  ///
  /// In en, this message translates to:
  /// **'Move left'**
  String get labsNumberLineExplorerDecreaseButton;

  /// No description provided for @labsNumberLineExplorerHelpWhatToDo.
  ///
  /// In en, this message translates to:
  /// **'Drag the point, or use the arrow buttons, to reach the target value, then press Check.'**
  String get labsNumberLineExplorerHelpWhatToDo;

  /// No description provided for @labsNumberLineExplorerHelpWhatToNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice how the point\'s position matches its value — further right is a bigger number, further left is smaller.'**
  String get labsNumberLineExplorerHelpWhatToNotice;

  /// No description provided for @labsNumberLineExplorerHelpWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'A number line shows every number in order, in both directions from zero, including negative numbers and decimals.'**
  String get labsNumberLineExplorerHelpWhatItMeans;

  /// No description provided for @labsNumberLineExplorerFirstUseStep1.
  ///
  /// In en, this message translates to:
  /// **'See where the point starts.'**
  String get labsNumberLineExplorerFirstUseStep1;

  /// No description provided for @labsNumberLineExplorerFirstUseStep2.
  ///
  /// In en, this message translates to:
  /// **'Drag the point, or use the arrow buttons, toward the target.'**
  String get labsNumberLineExplorerFirstUseStep2;

  /// No description provided for @labsNumberLineExplorerFirstUseStep3.
  ///
  /// In en, this message translates to:
  /// **'Press Check to see if you reached it.'**
  String get labsNumberLineExplorerFirstUseStep3;

  /// Shared progress indicator label across every Interactive Lab
  ///
  /// In en, this message translates to:
  /// **'Mission {current} of {total}'**
  String labsMissionOf(int current, int total);

  /// No description provided for @labsDirectionUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get labsDirectionUp;

  /// No description provided for @labsDirectionUpRight.
  ///
  /// In en, this message translates to:
  /// **'Up-right'**
  String get labsDirectionUpRight;

  /// No description provided for @labsDirectionDownRight.
  ///
  /// In en, this message translates to:
  /// **'Down-right'**
  String get labsDirectionDownRight;

  /// No description provided for @labsDirectionDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get labsDirectionDown;

  /// No description provided for @labsDirectionDownLeft.
  ///
  /// In en, this message translates to:
  /// **'Down-left'**
  String get labsDirectionDownLeft;

  /// No description provided for @labsDirectionUpLeft.
  ///
  /// In en, this message translates to:
  /// **'Up-left'**
  String get labsDirectionUpLeft;

  /// No description provided for @labsCompassNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get labsCompassNorth;

  /// No description provided for @labsCompassNortheast.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get labsCompassNortheast;

  /// No description provided for @labsCompassEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get labsCompassEast;

  /// No description provided for @labsCompassSoutheast.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get labsCompassSoutheast;

  /// No description provided for @labsCompassSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get labsCompassSouth;

  /// No description provided for @labsCompassSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get labsCompassSouthwest;

  /// No description provided for @labsCompassWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get labsCompassWest;

  /// No description provided for @labsCompassNorthwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get labsCompassNorthwest;

  /// Explorer-band heading label: plain direction word with the degree value visible but not required
  ///
  /// In en, this message translates to:
  /// **'Direction: {direction} ({degrees}°)'**
  String labsFlightPathLabHeadingExplorerLabel(String direction, int degrees);

  /// Builder/Navigator-band heading label: compass direction plus the formal three-figure bearing
  ///
  /// In en, this message translates to:
  /// **'{compass} • Heading: {bearing}'**
  String labsFlightPathLabHeadingCompassLabel(String compass, String bearing);

  /// No description provided for @labsFlightPathLabTapTargetHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: tap the target to aim automatically'**
  String get labsFlightPathLabTapTargetHint;

  /// No description provided for @labsFlightPathLabDragCue.
  ///
  /// In en, this message translates to:
  /// **'Drag the plane to turn it'**
  String get labsFlightPathLabDragCue;

  /// No description provided for @labsFlightPathLabNarrationIntroExplorer.
  ///
  /// In en, this message translates to:
  /// **'Point the plane at the yellow target, then press Test Flight to see where it lands.'**
  String get labsFlightPathLabNarrationIntroExplorer;

  /// No description provided for @labsFlightPathLabNarrationIntroBuilder.
  ///
  /// In en, this message translates to:
  /// **'Set a heading and speed, predict where you\'ll land, then test your prediction.'**
  String get labsFlightPathLabNarrationIntroBuilder;

  /// No description provided for @labsFlightPathLabNarrationIntroNavigator.
  ///
  /// In en, this message translates to:
  /// **'Choose a bearing and speed; the resulting displacement is bearing and speed-time combined into one vector.'**
  String get labsFlightPathLabNarrationIntroNavigator;

  /// No description provided for @labsFlightPathLabNarrationResultNearMissExplorer.
  ///
  /// In en, this message translates to:
  /// **'So close! Try a slightly different speed or direction and test again.'**
  String get labsFlightPathLabNarrationResultNearMissExplorer;

  /// No description provided for @labsFlightPathLabNarrationResultNearMissBuilder.
  ///
  /// In en, this message translates to:
  /// **'You landed close to the target. Check whether you\'re slightly early or late, and adjust speed or heading a little.'**
  String get labsFlightPathLabNarrationResultNearMissBuilder;

  /// No description provided for @labsFlightPathLabNarrationResultNearMissNavigator.
  ///
  /// In en, this message translates to:
  /// **'The resultant displacement is close to the target vector but not exact — refine heading and/or speed and re-test.'**
  String get labsFlightPathLabNarrationResultNearMissNavigator;

  /// No description provided for @labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer.
  ///
  /// In en, this message translates to:
  /// **'Good direction! But the plane flew too far. Try a slower speed.'**
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarExplorer;

  /// No description provided for @labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder.
  ///
  /// In en, this message translates to:
  /// **'The heading is right, but you travelled further than the target distance. Keep the direction and lower the speed.'**
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarBuilder;

  /// No description provided for @labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator.
  ///
  /// In en, this message translates to:
  /// **'Bearing matches the target vector; the magnitude (speed × time) overshoots it — reduce speed to shorten the displacement.'**
  String get labsFlightPathLabNarrationResultCorrectHeadingTooFarNavigator;

  /// No description provided for @labsFlightPathLabNarrationResultCorrectHeadingTooShortExplorer.
  ///
  /// In en, this message translates to:
  /// **'Good direction! But the plane didn\'t fly far enough. Try a faster speed.'**
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortExplorer;

  /// No description provided for @labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder.
  ///
  /// In en, this message translates to:
  /// **'The heading is right, but you didn\'t travel far enough. Keep the direction and raise the speed.'**
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortBuilder;

  /// No description provided for @labsFlightPathLabNarrationResultCorrectHeadingTooShortNavigator.
  ///
  /// In en, this message translates to:
  /// **'Bearing matches the target vector; the magnitude falls short — increase speed to extend the displacement.'**
  String get labsFlightPathLabNarrationResultCorrectHeadingTooShortNavigator;

  /// No description provided for @labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceExplorer.
  ///
  /// In en, this message translates to:
  /// **'The distance is right, but the plane is pointing the wrong way. Turn it toward the yellow target.'**
  String
      get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceExplorer;

  /// No description provided for @labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder.
  ///
  /// In en, this message translates to:
  /// **'You flew the right distance, but the wrong direction. Adjust the heading toward the target bearing and keep the speed.'**
  String get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceBuilder;

  /// No description provided for @labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceNavigator.
  ///
  /// In en, this message translates to:
  /// **'The magnitude is correct but the bearing is off — rotate the heading toward the target bearing without changing speed.'**
  String
      get labsFlightPathLabNarrationResultWrongHeadingCorrectDistanceNavigator;

  /// No description provided for @labsFlightPathLabNarrationResultWrongHeadingAndDistanceExplorer.
  ///
  /// In en, this message translates to:
  /// **'The plane is pointing the wrong way and went the wrong distance. Aim at the target, then choose a speed.'**
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceExplorer;

  /// No description provided for @labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder.
  ///
  /// In en, this message translates to:
  /// **'Both the direction and the distance need adjusting. Re-aim toward the target bearing, then set a speed for the right distance.'**
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceBuilder;

  /// No description provided for @labsFlightPathLabNarrationResultWrongHeadingAndDistanceNavigator.
  ///
  /// In en, this message translates to:
  /// **'Both bearing and magnitude are off the target vector — correct the heading first, then adjust speed for the required distance.'**
  String get labsFlightPathLabNarrationResultWrongHeadingAndDistanceNavigator;

  /// No description provided for @labsFlightPathLabNarrationCompletionExplorer.
  ///
  /// In en, this message translates to:
  /// **'Excellent! You aimed the plane and picked the right speed to land exactly on target.'**
  String get labsFlightPathLabNarrationCompletionExplorer;

  /// No description provided for @labsFlightPathLabNarrationCompletionBuilder.
  ///
  /// In en, this message translates to:
  /// **'Excellent! Matching heading and speed to a target is exactly how real flight plans are built.'**
  String get labsFlightPathLabNarrationCompletionBuilder;

  /// No description provided for @labsFlightPathLabNarrationCompletionNavigator.
  ///
  /// In en, this message translates to:
  /// **'Exact match: the displacement vector (bearing and magnitude) equals the target vector — this is how flight planning and navigation calculations work in practice.'**
  String get labsFlightPathLabNarrationCompletionNavigator;

  /// No description provided for @labsFlightPathLabNarrationHintRepeatedExplorer.
  ///
  /// In en, this message translates to:
  /// **'That\'s the same try as last time. Change the direction or speed before testing again.'**
  String get labsFlightPathLabNarrationHintRepeatedExplorer;

  /// No description provided for @labsFlightPathLabNarrationHintRepeatedBuilder.
  ///
  /// In en, this message translates to:
  /// **'You tested the exact same heading and speed again. Try changing one of them before the next test.'**
  String get labsFlightPathLabNarrationHintRepeatedBuilder;

  /// No description provided for @labsFlightPathLabNarrationHintRepeatedNavigator.
  ///
  /// In en, this message translates to:
  /// **'Heading and speed are unchanged from the previous attempt — vary at least one variable to gather new information.'**
  String get labsFlightPathLabNarrationHintRepeatedNavigator;

  /// No description provided for @labsFlightPathLabNarrationHintInactivityExplorer.
  ///
  /// In en, this message translates to:
  /// **'Still there? Drag the plane or move the speed slider to keep going.'**
  String get labsFlightPathLabNarrationHintInactivityExplorer;

  /// No description provided for @labsFlightPathLabNarrationHintInactivityBuilder.
  ///
  /// In en, this message translates to:
  /// **'Take your time — drag the plane to aim it, or adjust the speed, whenever you\'re ready.'**
  String get labsFlightPathLabNarrationHintInactivityBuilder;

  /// No description provided for @labsFlightPathLabNarrationHintInactivityNavigator.
  ///
  /// In en, this message translates to:
  /// **'No input recorded recently — adjust heading or speed to continue refining the solution.'**
  String get labsFlightPathLabNarrationHintInactivityNavigator;

  /// No description provided for @labsNumberLineExplorerNarrationResultWrongExplorer.
  ///
  /// In en, this message translates to:
  /// **'Not quite — look at whether you need to move left or right, then try again.'**
  String get labsNumberLineExplorerNarrationResultWrongExplorer;

  /// No description provided for @labsNumberLineExplorerNarrationResultWrongBuilder.
  ///
  /// In en, this message translates to:
  /// **'Compare your value to the target: move toward it by the difference, then check again.'**
  String get labsNumberLineExplorerNarrationResultWrongBuilder;

  /// No description provided for @labsNumberLineExplorerNarrationResultWrongNavigator.
  ///
  /// In en, this message translates to:
  /// **'The value differs from the target by more than one step — adjust by the required increment and retest.'**
  String get labsNumberLineExplorerNarrationResultWrongNavigator;

  /// No description provided for @labsNumberLineExplorerNarrationResultCloseExplorer.
  ///
  /// In en, this message translates to:
  /// **'So close! Just one small step away — try nudging it once more.'**
  String get labsNumberLineExplorerNarrationResultCloseExplorer;

  /// No description provided for @labsNumberLineExplorerNarrationResultCloseBuilder.
  ///
  /// In en, this message translates to:
  /// **'You\'re one step away from the target. Adjust by a single increment and check again.'**
  String get labsNumberLineExplorerNarrationResultCloseBuilder;

  /// No description provided for @labsNumberLineExplorerNarrationResultCloseNavigator.
  ///
  /// In en, this message translates to:
  /// **'The value is within one increment of the target — a single adjustment should resolve it.'**
  String get labsNumberLineExplorerNarrationResultCloseNavigator;

  /// No description provided for @labsNumberLineExplorerNarrationCompletionExplorer.
  ///
  /// In en, this message translates to:
  /// **'Exactly right! You found the target\'s exact position on the line.'**
  String get labsNumberLineExplorerNarrationCompletionExplorer;

  /// No description provided for @labsNumberLineExplorerNarrationCompletionBuilder.
  ///
  /// In en, this message translates to:
  /// **'Exactly right! Matching a value to its position is how number lines represent size and order.'**
  String get labsNumberLineExplorerNarrationCompletionBuilder;

  /// No description provided for @labsNumberLineExplorerNarrationCompletionNavigator.
  ///
  /// In en, this message translates to:
  /// **'Exact match: the value\'s position on the line corresponds precisely to its numeric value, including sign and magnitude.'**
  String get labsNumberLineExplorerNarrationCompletionNavigator;

  /// No description provided for @labsNumberLineExplorerNarrationHintRepeatedExplorer.
  ///
  /// In en, this message translates to:
  /// **'That\'s the same spot as last time — move it before checking again.'**
  String get labsNumberLineExplorerNarrationHintRepeatedExplorer;

  /// No description provided for @labsNumberLineExplorerNarrationHintRepeatedBuilder.
  ///
  /// In en, this message translates to:
  /// **'You checked the same value again. Move it by at least one step before the next check.'**
  String get labsNumberLineExplorerNarrationHintRepeatedBuilder;

  /// No description provided for @labsNumberLineExplorerNarrationHintRepeatedNavigator.
  ///
  /// In en, this message translates to:
  /// **'The value is unchanged from the previous check — adjust before retesting.'**
  String get labsNumberLineExplorerNarrationHintRepeatedNavigator;

  /// No description provided for @labsNumberLineExplorerNarrationHintInactivityExplorer.
  ///
  /// In en, this message translates to:
  /// **'Still there? Drag the marker or use the +/- buttons.'**
  String get labsNumberLineExplorerNarrationHintInactivityExplorer;

  /// No description provided for @labsNumberLineExplorerNarrationHintInactivityBuilder.
  ///
  /// In en, this message translates to:
  /// **'Take your time — drag the marker or use the +/- buttons whenever you\'re ready.'**
  String get labsNumberLineExplorerNarrationHintInactivityBuilder;

  /// No description provided for @labsNumberLineExplorerNarrationHintInactivityNavigator.
  ///
  /// In en, this message translates to:
  /// **'No input recorded recently — adjust the value to continue.'**
  String get labsNumberLineExplorerNarrationHintInactivityNavigator;

  /// No description provided for @labsFractionBuilderNarrationResultWrongExplorer.
  ///
  /// In en, this message translates to:
  /// **'Not quite the right number of parts — count the filled segments and compare to the target.'**
  String get labsFractionBuilderNarrationResultWrongExplorer;

  /// No description provided for @labsFractionBuilderNarrationResultWrongBuilder.
  ///
  /// In en, this message translates to:
  /// **'Compare the filled segments to the numerator, then add or remove one to match.'**
  String get labsFractionBuilderNarrationResultWrongBuilder;

  /// No description provided for @labsFractionBuilderNarrationResultWrongNavigator.
  ///
  /// In en, this message translates to:
  /// **'The filled-segment count must equal the numerator exactly — adjust by the difference.'**
  String get labsFractionBuilderNarrationResultWrongNavigator;

  /// No description provided for @labsFractionBuilderNarrationCompletionExplorer.
  ///
  /// In en, this message translates to:
  /// **'That\'s it! You filled exactly the right number of parts.'**
  String get labsFractionBuilderNarrationCompletionExplorer;

  /// No description provided for @labsFractionBuilderNarrationCompletionBuilder.
  ///
  /// In en, this message translates to:
  /// **'That\'s it! Counting filled parts against a numerator is exactly what a fraction represents.'**
  String get labsFractionBuilderNarrationCompletionBuilder;

  /// No description provided for @labsFractionBuilderNarrationCompletionNavigator.
  ///
  /// In en, this message translates to:
  /// **'Exact match: filled segments equal the numerator over the shown denominator, matching the fraction\'s defining ratio.'**
  String get labsFractionBuilderNarrationCompletionNavigator;

  /// No description provided for @labsFractionBuilderNarrationHintRepeatedExplorer.
  ///
  /// In en, this message translates to:
  /// **'Same count as last time — change it before checking again.'**
  String get labsFractionBuilderNarrationHintRepeatedExplorer;

  /// No description provided for @labsFractionBuilderNarrationHintRepeatedBuilder.
  ///
  /// In en, this message translates to:
  /// **'You checked the same filled count again. Change it before the next check.'**
  String get labsFractionBuilderNarrationHintRepeatedBuilder;

  /// No description provided for @labsFractionBuilderNarrationHintRepeatedNavigator.
  ///
  /// In en, this message translates to:
  /// **'The filled count is unchanged from the previous check — adjust before retesting.'**
  String get labsFractionBuilderNarrationHintRepeatedNavigator;

  /// No description provided for @labsFractionBuilderNarrationHintInactivityExplorer.
  ///
  /// In en, this message translates to:
  /// **'Still there? Tap a segment to fill or unfill it.'**
  String get labsFractionBuilderNarrationHintInactivityExplorer;

  /// No description provided for @labsFractionBuilderNarrationHintInactivityBuilder.
  ///
  /// In en, this message translates to:
  /// **'Take your time — tap segments to adjust the count whenever you\'re ready.'**
  String get labsFractionBuilderNarrationHintInactivityBuilder;

  /// No description provided for @labsFractionBuilderNarrationHintInactivityNavigator.
  ///
  /// In en, this message translates to:
  /// **'No input recorded recently — tap a segment to continue.'**
  String get labsFractionBuilderNarrationHintInactivityNavigator;

  /// No description provided for @labsAlgebraBalanceNarrationHintNextStepExplorer.
  ///
  /// In en, this message translates to:
  /// **'Remove the number first, then divide to find x.'**
  String get labsAlgebraBalanceNarrationHintNextStepExplorer;

  /// No description provided for @labsAlgebraBalanceNarrationHintNextStepBuilder.
  ///
  /// In en, this message translates to:
  /// **'First remove the constant from both sides, then divide both sides by the coefficient of x.'**
  String get labsAlgebraBalanceNarrationHintNextStepBuilder;

  /// No description provided for @labsAlgebraBalanceNarrationHintNextStepNavigator.
  ///
  /// In en, this message translates to:
  /// **'Apply the inverse additive operation first, then the inverse multiplicative operation, to isolate x.'**
  String get labsAlgebraBalanceNarrationHintNextStepNavigator;

  /// No description provided for @labsAlgebraBalanceNarrationCompletionExplorer.
  ///
  /// In en, this message translates to:
  /// **'Solved! You found the value of x.'**
  String get labsAlgebraBalanceNarrationCompletionExplorer;

  /// No description provided for @labsAlgebraBalanceNarrationCompletionBuilder.
  ///
  /// In en, this message translates to:
  /// **'Solved! Every equation of this form is solved by removing the constant, then dividing.'**
  String get labsAlgebraBalanceNarrationCompletionBuilder;

  /// No description provided for @labsAlgebraBalanceNarrationCompletionNavigator.
  ///
  /// In en, this message translates to:
  /// **'Solved: x is isolated by inverse operations applied to both sides, preserving equality throughout.'**
  String get labsAlgebraBalanceNarrationCompletionNavigator;

  /// No description provided for @labsAlgebraBalanceNarrationHintInactivityExplorer.
  ///
  /// In en, this message translates to:
  /// **'Still there? Try the first button to remove the number.'**
  String get labsAlgebraBalanceNarrationHintInactivityExplorer;

  /// No description provided for @labsAlgebraBalanceNarrationHintInactivityBuilder.
  ///
  /// In en, this message translates to:
  /// **'Take your time — remove the constant, then divide, whenever you\'re ready.'**
  String get labsAlgebraBalanceNarrationHintInactivityBuilder;

  /// No description provided for @labsAlgebraBalanceNarrationHintInactivityNavigator.
  ///
  /// In en, this message translates to:
  /// **'No input recorded recently — apply the next inverse operation to continue.'**
  String get labsAlgebraBalanceNarrationHintInactivityNavigator;

  /// No description provided for @labsDataDetectiveNarrationResultWrongExplorer.
  ///
  /// In en, this message translates to:
  /// **'Not quite — look at how much each average moved and pick again.'**
  String get labsDataDetectiveNarrationResultWrongExplorer;

  /// No description provided for @labsDataDetectiveNarrationResultWrongBuilder.
  ///
  /// In en, this message translates to:
  /// **'Compare how much the mean and median each changed, then predict again based on which shifted more.'**
  String get labsDataDetectiveNarrationResultWrongBuilder;

  /// No description provided for @labsDataDetectiveNarrationResultWrongNavigator.
  ///
  /// In en, this message translates to:
  /// **'Re-examine the computed shifts: predict again based on which statistic changed by the larger magnitude.'**
  String get labsDataDetectiveNarrationResultWrongNavigator;

  /// No description provided for @labsDataDetectiveNarrationCompletionExplorer.
  ///
  /// In en, this message translates to:
  /// **'Correct! You spotted which average the outlier affects most.'**
  String get labsDataDetectiveNarrationCompletionExplorer;

  /// No description provided for @labsDataDetectiveNarrationCompletionBuilder.
  ///
  /// In en, this message translates to:
  /// **'Correct! Identifying which statistic an outlier distorts most is exactly this lab\'s key idea.'**
  String get labsDataDetectiveNarrationCompletionBuilder;

  /// No description provided for @labsDataDetectiveNarrationCompletionNavigator.
  ///
  /// In en, this message translates to:
  /// **'Correct: the statistic with the larger shift is more sensitive to the outlier, consistent with the mean\'s sensitivity to extreme values relative to the median.'**
  String get labsDataDetectiveNarrationCompletionNavigator;

  /// No description provided for @labsDataDetectiveNarrationHintRepeatedExplorer.
  ///
  /// In en, this message translates to:
  /// **'Same guess as last time — try the other one.'**
  String get labsDataDetectiveNarrationHintRepeatedExplorer;

  /// No description provided for @labsDataDetectiveNarrationHintRepeatedBuilder.
  ///
  /// In en, this message translates to:
  /// **'You predicted the same statistic again. Consider the other option.'**
  String get labsDataDetectiveNarrationHintRepeatedBuilder;

  /// No description provided for @labsDataDetectiveNarrationHintRepeatedNavigator.
  ///
  /// In en, this message translates to:
  /// **'The same prediction was repeated — reconsider using the computed shift values.'**
  String get labsDataDetectiveNarrationHintRepeatedNavigator;

  /// No description provided for @labsDataDetectiveNarrationHintInactivityExplorer.
  ///
  /// In en, this message translates to:
  /// **'Still there? Pick Mean or Median, then tap Reveal.'**
  String get labsDataDetectiveNarrationHintInactivityExplorer;

  /// No description provided for @labsDataDetectiveNarrationHintInactivityBuilder.
  ///
  /// In en, this message translates to:
  /// **'Take your time — pick a prediction and tap Reveal whenever you\'re ready.'**
  String get labsDataDetectiveNarrationHintInactivityBuilder;

  /// No description provided for @labsDataDetectiveNarrationHintInactivityNavigator.
  ///
  /// In en, this message translates to:
  /// **'No input recorded recently — choose a prediction to continue.'**
  String get labsDataDetectiveNarrationHintInactivityNavigator;

  /// No description provided for @labsFractionBuilderNarrationIntro.
  ///
  /// In en, this message translates to:
  /// **'Tap segments to fill the fraction, then check your answer.'**
  String get labsFractionBuilderNarrationIntro;

  /// No description provided for @labsNumberLineExplorerNarrationIntro.
  ///
  /// In en, this message translates to:
  /// **'Move the marker to the target value, then check your answer.'**
  String get labsNumberLineExplorerNarrationIntro;

  /// No description provided for @labsAlgebraBalanceNarrationIntro.
  ///
  /// In en, this message translates to:
  /// **'Use the balance operations to isolate x, one step at a time.'**
  String get labsAlgebraBalanceNarrationIntro;

  /// No description provided for @labsDataDetectiveNarrationIntro.
  ///
  /// In en, this message translates to:
  /// **'Predict which average the outlier affects most, then reveal the answer.'**
  String get labsDataDetectiveNarrationIntro;

  /// No description provided for @allieLabel.
  ///
  /// In en, this message translates to:
  /// **'Allie'**
  String get allieLabel;

  /// No description provided for @familyMathsEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Maths'**
  String get familyMathsEntryTitle;

  /// No description provided for @familyMathsWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get familyMathsWelcomeTitle;

  /// No description provided for @familyMathsWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Helping your child with maths doesn\'t require perfect knowledge. Small conversations. Simple games. Curiosity. Consistency. We\'ll help with the rest.'**
  String get familyMathsWelcomeBody;

  /// No description provided for @familyMathsAllieIntro.
  ///
  /// In en, this message translates to:
  /// **'You don\'t need to remember every school method. Choose one topic. I\'ll suggest a five-minute activity that helps your child think mathematically.'**
  String get familyMathsAllieIntro;

  /// No description provided for @familyMathsPhilosophyTagline.
  ///
  /// In en, this message translates to:
  /// **'Parents don\'t need to become teachers.'**
  String get familyMathsPhilosophyTagline;

  /// No description provided for @familyMathsStartActivityButton.
  ///
  /// In en, this message translates to:
  /// **'Start a Family Activity'**
  String get familyMathsStartActivityButton;

  /// No description provided for @familyMathsBrowseTopicsButton.
  ///
  /// In en, this message translates to:
  /// **'Browse Topics'**
  String get familyMathsBrowseTopicsButton;

  /// No description provided for @familyMathsLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Activities'**
  String get familyMathsLibraryTitle;

  /// No description provided for @familyMathsEmptyCategory.
  ///
  /// In en, this message translates to:
  /// **'No activities yet for this topic. More are on the way.'**
  String get familyMathsEmptyCategory;

  /// No description provided for @familyActivityAgeRange.
  ///
  /// In en, this message translates to:
  /// **'Ages {min}-{max}'**
  String familyActivityAgeRange(int min, int max);

  /// No description provided for @familyActivityTimeRange.
  ///
  /// In en, this message translates to:
  /// **'{min}-{max} min'**
  String familyActivityTimeRange(int min, int max);

  /// No description provided for @familyActivityMaterialsLabel.
  ///
  /// In en, this message translates to:
  /// **'Materials Needed'**
  String get familyActivityMaterialsLabel;

  /// No description provided for @familyActivityWhatYourChildLearnsLabel.
  ///
  /// In en, this message translates to:
  /// **'What Your Child Learns'**
  String get familyActivityWhatYourChildLearnsLabel;

  /// No description provided for @familyActivityLetsExploreLabel.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Explore'**
  String get familyActivityLetsExploreLabel;

  /// No description provided for @familyActivityQuestionsToAskLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions to Ask'**
  String get familyActivityQuestionsToAskLabel;

  /// No description provided for @familyActivityMisconceptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Common Misconceptions'**
  String get familyActivityMisconceptionsLabel;

  /// No description provided for @familyActivityTryTomorrowLabel.
  ///
  /// In en, this message translates to:
  /// **'Try Tomorrow'**
  String get familyActivityTryTomorrowLabel;

  /// No description provided for @familyActivityStudioConnectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Studio Connection'**
  String get familyActivityStudioConnectionLabel;

  /// No description provided for @familyMathsCategoryNumberSense.
  ///
  /// In en, this message translates to:
  /// **'Number Sense'**
  String get familyMathsCategoryNumberSense;

  /// No description provided for @familyMathsCategoryAddition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get familyMathsCategoryAddition;

  /// No description provided for @familyMathsCategorySubtraction.
  ///
  /// In en, this message translates to:
  /// **'Subtraction'**
  String get familyMathsCategorySubtraction;

  /// No description provided for @familyMathsCategoryMultiplication.
  ///
  /// In en, this message translates to:
  /// **'Multiplication'**
  String get familyMathsCategoryMultiplication;

  /// No description provided for @familyMathsCategoryDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get familyMathsCategoryDivision;

  /// No description provided for @familyMathsCategoryFractions.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get familyMathsCategoryFractions;

  /// No description provided for @familyMathsCategoryDecimals.
  ///
  /// In en, this message translates to:
  /// **'Decimals'**
  String get familyMathsCategoryDecimals;

  /// No description provided for @familyMathsCategoryRatio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get familyMathsCategoryRatio;

  /// No description provided for @familyMathsCategoryPercentages.
  ///
  /// In en, this message translates to:
  /// **'Percentages'**
  String get familyMathsCategoryPercentages;

  /// No description provided for @familyMathsCategoryGeometry.
  ///
  /// In en, this message translates to:
  /// **'Geometry'**
  String get familyMathsCategoryGeometry;

  /// No description provided for @familyMathsCategoryMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get familyMathsCategoryMeasurement;

  /// No description provided for @familyMathsCategoryAlgebra.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get familyMathsCategoryAlgebra;

  /// No description provided for @familyMathsCategoryPatterns.
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get familyMathsCategoryPatterns;

  /// No description provided for @familyMathsCategoryLogic.
  ///
  /// In en, this message translates to:
  /// **'Logic'**
  String get familyMathsCategoryLogic;

  /// No description provided for @familyMathsCategorySpatialReasoning.
  ///
  /// In en, this message translates to:
  /// **'Spatial Reasoning'**
  String get familyMathsCategorySpatialReasoning;

  /// No description provided for @familyMathsReassurance1.
  ///
  /// In en, this message translates to:
  /// **'You do not need to know the answer immediately.'**
  String get familyMathsReassurance1;

  /// No description provided for @familyMathsReassurance2.
  ///
  /// In en, this message translates to:
  /// **'Ask your child to explain what they notice.'**
  String get familyMathsReassurance2;

  /// No description provided for @familyMathsReassurance3.
  ///
  /// In en, this message translates to:
  /// **'A wrong answer can start a useful conversation.'**
  String get familyMathsReassurance3;

  /// No description provided for @familyMathsReassurance4.
  ///
  /// In en, this message translates to:
  /// **'Five focused minutes is enough.'**
  String get familyMathsReassurance4;

  /// No description provided for @familyMathsReassurance5.
  ///
  /// In en, this message translates to:
  /// **'Let your child choose the objects.'**
  String get familyMathsReassurance5;

  /// No description provided for @familyMathsReassurance6.
  ///
  /// In en, this message translates to:
  /// **'Try a different representation if the first one does not help.'**
  String get familyMathsReassurance6;

  /// No description provided for @onboardingFamilyRoleDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your family'**
  String get onboardingFamilyRoleDetailTitle;

  /// No description provided for @onboardingFamilyRoleDetailSub.
  ///
  /// In en, this message translates to:
  /// **'A couple of quick questions so we can help the right way.'**
  String get onboardingFamilyRoleDetailSub;

  /// No description provided for @onboardingFamilyLearnerNamesLabel.
  ///
  /// In en, this message translates to:
  /// **'Learner name(s)'**
  String get onboardingFamilyLearnerNamesLabel;

  /// No description provided for @onboardingFamilyLearnerNamesSub.
  ///
  /// In en, this message translates to:
  /// **'Add at least one — you can add more later.'**
  String get onboardingFamilyLearnerNamesSub;

  /// No description provided for @onboardingFamilyAddAnotherLearner.
  ///
  /// In en, this message translates to:
  /// **'Add another learner'**
  String get onboardingFamilyAddAnotherLearner;

  /// No description provided for @onboardingFamilyLearnerContextTitle.
  ///
  /// In en, this message translates to:
  /// **'What stage is your child at?'**
  String get onboardingFamilyLearnerContextTitle;

  /// No description provided for @onboardingFamilyLearnerContextSub.
  ///
  /// In en, this message translates to:
  /// **'This helps us suggest the right activities and topics.'**
  String get onboardingFamilyLearnerContextSub;

  /// No description provided for @onboardingFamilyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you here?'**
  String get onboardingFamilyGoalTitle;

  /// No description provided for @onboardingFamilyGoalSub.
  ///
  /// In en, this message translates to:
  /// **'Choose what matters most right now — you can change this later.'**
  String get onboardingFamilyGoalSub;

  /// No description provided for @onboardingFamilyGoalHomework.
  ///
  /// In en, this message translates to:
  /// **'Help with homework'**
  String get onboardingFamilyGoalHomework;

  /// No description provided for @onboardingFamilyGoalUnderstandMethods.
  ///
  /// In en, this message translates to:
  /// **'Understand modern methods'**
  String get onboardingFamilyGoalUnderstandMethods;

  /// No description provided for @onboardingFamilyGoalBuildConfidence.
  ///
  /// In en, this message translates to:
  /// **'Build confidence'**
  String get onboardingFamilyGoalBuildConfidence;

  /// No description provided for @onboardingFamilyGoalPractiseTogether.
  ///
  /// In en, this message translates to:
  /// **'Practise together'**
  String get onboardingFamilyGoalPractiseTogether;

  /// No description provided for @onboardingFamilyGoalPrepareExam.
  ///
  /// In en, this message translates to:
  /// **'Prepare for an exam'**
  String get onboardingFamilyGoalPrepareExam;

  /// No description provided for @onboardingFamilyGoalMonitorProgress.
  ///
  /// In en, this message translates to:
  /// **'Monitor progress'**
  String get onboardingFamilyGoalMonitorProgress;

  /// No description provided for @onboardingFamilyGoalSupportStruggling.
  ///
  /// In en, this message translates to:
  /// **'Support a learner who finds maths difficult'**
  String get onboardingFamilyGoalSupportStruggling;

  /// No description provided for @onboardingFamilyActivityLengthLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred activity length'**
  String get onboardingFamilyActivityLengthLabel;

  /// No description provided for @onboardingFamilyActivityLengthShort.
  ///
  /// In en, this message translates to:
  /// **'~10 minutes'**
  String get onboardingFamilyActivityLengthShort;

  /// No description provided for @onboardingFamilyActivityLengthMedium.
  ///
  /// In en, this message translates to:
  /// **'~20 minutes'**
  String get onboardingFamilyActivityLengthMedium;

  /// No description provided for @onboardingFamilyActivityLengthLong.
  ///
  /// In en, this message translates to:
  /// **'~30 minutes'**
  String get onboardingFamilyActivityLengthLong;

  /// No description provided for @onboardingFamilyPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost done'**
  String get onboardingFamilyPreferencesTitle;

  /// No description provided for @onboardingFamilyPreferencesSub.
  ///
  /// In en, this message translates to:
  /// **'A couple of optional extras, then you\'re in.'**
  String get onboardingFamilyPreferencesSub;

  /// No description provided for @onboardingFamilyAllieIntro.
  ///
  /// In en, this message translates to:
  /// **'You do not need to explain everything immediately.'**
  String get onboardingFamilyAllieIntro;

  /// No description provided for @onboardingFamilyNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminders'**
  String get onboardingFamilyNotificationsLabel;

  /// No description provided for @onboardingFamilyNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Optional — occasional nudges about your family activity.'**
  String get onboardingFamilyNotificationsSub;

  /// No description provided for @onboardingFamilyPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Set a Parent PIN (optional)'**
  String get onboardingFamilyPinLabel;

  /// No description provided for @onboardingFamilyPinSub.
  ///
  /// In en, this message translates to:
  /// **'Protects Family Maths and parent content on a shared device. You can set this later in Settings instead.'**
  String get onboardingFamilyPinSub;

  /// No description provided for @onboardingFamilyFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Go to Family Studio'**
  String get onboardingFamilyFinishButton;

  /// No description provided for @recallTopicNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get recallTopicNumber;

  /// No description provided for @recallTopicRatioAndProportion.
  ///
  /// In en, this message translates to:
  /// **'Ratio and Proportion'**
  String get recallTopicRatioAndProportion;

  /// No description provided for @recallTopicAlgebra.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get recallTopicAlgebra;

  /// No description provided for @recallTopicGeometryAndMeasures.
  ///
  /// In en, this message translates to:
  /// **'Geometry and Measures'**
  String get recallTopicGeometryAndMeasures;

  /// No description provided for @recallTopicStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get recallTopicStatistics;

  /// No description provided for @recallTopicProbability.
  ///
  /// In en, this message translates to:
  /// **'Probability'**
  String get recallTopicProbability;

  /// No description provided for @familyStudioHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Studio'**
  String get familyStudioHubTitle;

  /// No description provided for @familyStudioHubOpeningPromise.
  ///
  /// In en, this message translates to:
  /// **'Parents do not need to become teachers.'**
  String get familyStudioHubOpeningPromise;

  /// No description provided for @familyStudioHubSupportingCopy.
  ///
  /// In en, this message translates to:
  /// **'Choose a topic, a short activity or a homework goal. Math Intelligence will help you begin.'**
  String get familyStudioHubSupportingCopy;

  /// No description provided for @familyStudioHubAllieMessage.
  ///
  /// In en, this message translates to:
  /// **'Ask what your child notices first.'**
  String get familyStudioHubAllieMessage;

  /// No description provided for @familyStudioProfileEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Activities, homework help and progress for your family.'**
  String get familyStudioProfileEntrySubtitle;

  /// No description provided for @familyStudioPrimaryActionStartActivity.
  ///
  /// In en, this message translates to:
  /// **'Start a Family Activity'**
  String get familyStudioPrimaryActionStartActivity;

  /// No description provided for @familyStudioPrimaryActionHomework.
  ///
  /// In en, this message translates to:
  /// **'Help with Homework'**
  String get familyStudioPrimaryActionHomework;

  /// No description provided for @familyStudioPrimaryActionLearning.
  ///
  /// In en, this message translates to:
  /// **'See What My Child Is Learning'**
  String get familyStudioPrimaryActionLearning;

  /// No description provided for @familyStudioPrimaryActionGuides.
  ///
  /// In en, this message translates to:
  /// **'Browse Parent Guides'**
  String get familyStudioPrimaryActionGuides;

  /// No description provided for @familyStudioSectionTodaysActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Family Activity'**
  String get familyStudioSectionTodaysActivityTitle;

  /// No description provided for @familyStudioSectionTodaysActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'One deterministic pick for today, from Family Maths.'**
  String get familyStudioSectionTodaysActivitySubtitle;

  /// No description provided for @familyStudioSectionHomeworkCompanionTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework Companion'**
  String get familyStudioSectionHomeworkCompanionTitle;

  /// No description provided for @familyStudioSectionHomeworkCompanionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short, deterministic session for tonight\'s homework.'**
  String get familyStudioSectionHomeworkCompanionSubtitle;

  /// No description provided for @familyStudioSectionLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'What Your Child Is Learning'**
  String get familyStudioSectionLearningTitle;

  /// No description provided for @familyStudioSectionLearningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Practice topics.'**
  String get familyStudioSectionLearningSubtitle;

  /// No description provided for @familyStudioSectionExplainTitle.
  ///
  /// In en, this message translates to:
  /// **'Explain This Method'**
  String get familyStudioSectionExplainTitle;

  /// No description provided for @familyStudioSectionExplainSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the Formula Library.'**
  String get familyStudioSectionExplainSubtitle;

  /// No description provided for @familyStudioSectionConversationStartersTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation Starters'**
  String get familyStudioSectionConversationStartersTitle;

  /// No description provided for @familyStudioSectionConversationStartersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Questions to ask while you work together.'**
  String get familyStudioSectionConversationStartersSubtitle;

  /// No description provided for @familyStudioSectionParentRecallCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Recall Cards'**
  String get familyStudioSectionParentRecallCardsTitle;

  /// No description provided for @familyStudioSectionParentRecallCardsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Warm, practical tips — not exam questions.'**
  String get familyStudioSectionParentRecallCardsSubtitle;

  /// No description provided for @familyStudioSectionFractionsRatioTitle.
  ///
  /// In en, this message translates to:
  /// **'Fractions and Ratio'**
  String get familyStudioSectionFractionsRatioTitle;

  /// No description provided for @familyStudioSectionFractionsRatioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Family Maths activities for this topic.'**
  String get familyStudioSectionFractionsRatioSubtitle;

  /// No description provided for @familyStudioSectionMentalMathsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Maths Together'**
  String get familyStudioSectionMentalMathsTitle;

  /// No description provided for @familyStudioSectionMentalMathsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick number challenges for two.'**
  String get familyStudioSectionMentalMathsSubtitle;

  /// No description provided for @familyStudioSectionCubeSpatialTitle.
  ///
  /// In en, this message translates to:
  /// **'Cube and Spatial Activities'**
  String get familyStudioSectionCubeSpatialTitle;

  /// No description provided for @familyStudioSectionCubeSpatialSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build and view together.'**
  String get familyStudioSectionCubeSpatialSubtitle;

  /// No description provided for @familyStudioSectionProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Snapshot'**
  String get familyStudioSectionProgressTitle;

  /// No description provided for @familyStudioSectionProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Topics studied, strengths and areas to revisit.'**
  String get familyStudioSectionProgressSubtitle;

  /// No description provided for @familyStudioSectionTutorToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tutor Tools'**
  String get familyStudioSectionTutorToolsTitle;

  /// No description provided for @familyStudioSectionTutorToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a learner, assign practice, add a note.'**
  String get familyStudioSectionTutorToolsSubtitle;

  /// No description provided for @familyStudioPinReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect Family Studio'**
  String get familyStudioPinReminderTitle;

  /// No description provided for @familyStudioPinReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Create a Parent PIN to protect assignments, reports and learner settings.'**
  String get familyStudioPinReminderBody;

  /// No description provided for @familyStudioPinReminderSetPinButton.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get familyStudioPinReminderSetPinButton;

  /// No description provided for @familyStudioPinReminderLaterButton.
  ///
  /// In en, this message translates to:
  /// **'Remind Me Later'**
  String get familyStudioPinReminderLaterButton;

  /// No description provided for @familyStudioTodayStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start this activity'**
  String get familyStudioTodayStartButton;

  /// No description provided for @familyStudioLearningNoDataYet.
  ///
  /// In en, this message translates to:
  /// **'No Practice sessions yet — recent topics will appear here.'**
  String get familyStudioLearningNoDataYet;

  /// No description provided for @familyStudioLearningTopicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recently studied in Practice.'**
  String get familyStudioLearningTopicSubtitle;

  /// No description provided for @familyStudioConversationAllieMessage.
  ///
  /// In en, this message translates to:
  /// **'A mistake can start a useful conversation.'**
  String get familyStudioConversationAllieMessage;

  /// No description provided for @familyStudioHomeworkTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get familyStudioHomeworkTopicLabel;

  /// No description provided for @familyStudioHomeworkTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time available'**
  String get familyStudioHomeworkTimeLabel;

  /// No description provided for @familyStudioHomeworkMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String familyStudioHomeworkMinutes(int minutes);

  /// No description provided for @familyStudioHomeworkHelpTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type of help needed'**
  String get familyStudioHomeworkHelpTypeLabel;

  /// No description provided for @familyStudioHomeworkHelpUnderstandMethod.
  ///
  /// In en, this message translates to:
  /// **'Understand the method'**
  String get familyStudioHomeworkHelpUnderstandMethod;

  /// No description provided for @familyStudioHomeworkHelpPractiseTogether.
  ///
  /// In en, this message translates to:
  /// **'Practise together'**
  String get familyStudioHomeworkHelpPractiseTogether;

  /// No description provided for @familyStudioHomeworkHelpReviewMistakes.
  ///
  /// In en, this message translates to:
  /// **'Review mistakes'**
  String get familyStudioHomeworkHelpReviewMistakes;

  /// No description provided for @familyStudioHomeworkHelpPrepareTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Prepare for tomorrow'**
  String get familyStudioHomeworkHelpPrepareTomorrow;

  /// No description provided for @familyStudioHomeworkHelpBuildConfidence.
  ///
  /// In en, this message translates to:
  /// **'Build confidence'**
  String get familyStudioHomeworkHelpBuildConfidence;

  /// No description provided for @familyStudioHomeworkGenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Generate session'**
  String get familyStudioHomeworkGenerateButton;

  /// No description provided for @familyStudioHomeworkEmptySession.
  ///
  /// In en, this message translates to:
  /// **'Nothing to suggest yet for this combination — try a different topic or time.'**
  String get familyStudioHomeworkEmptySession;

  /// No description provided for @familyStudioProgressRecentTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics recently studied'**
  String get familyStudioProgressRecentTopics;

  /// No description provided for @familyStudioProgressActivitiesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Activities completed'**
  String get familyStudioProgressActivitiesCompleted;

  /// No description provided for @familyStudioProgressAreasToRevisit.
  ///
  /// In en, this message translates to:
  /// **'Areas to revisit'**
  String get familyStudioProgressAreasToRevisit;

  /// No description provided for @familyStudioProgressSuggestedActivity.
  ///
  /// In en, this message translates to:
  /// **'Suggested family activity'**
  String get familyStudioProgressSuggestedActivity;

  /// No description provided for @familyStudioProgressNoDataYet.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet — this will fill in as your family uses the app.'**
  String get familyStudioProgressNoDataYet;

  /// No description provided for @familyStudioTutorChooseLearnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose a learner'**
  String get familyStudioTutorChooseLearnerLabel;

  /// No description provided for @familyStudioTutorAssignLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get familyStudioTutorAssignLabel;

  /// No description provided for @familyStudioTutorAssignPractice.
  ///
  /// In en, this message translates to:
  /// **'Assign Practice'**
  String get familyStudioTutorAssignPractice;

  /// No description provided for @familyStudioTutorAssignRecallCards.
  ///
  /// In en, this message translates to:
  /// **'Assign Recall Cards'**
  String get familyStudioTutorAssignRecallCards;

  /// No description provided for @familyStudioTutorCompletionLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} interactive lab completions so far'**
  String familyStudioTutorCompletionLabel(int count);

  /// No description provided for @familyStudioTutorNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get familyStudioTutorNotesLabel;

  /// No description provided for @familyStudioTutorNotesHint.
  ///
  /// In en, this message translates to:
  /// **'A short note for next time'**
  String get familyStudioTutorNotesHint;

  /// No description provided for @appearanceThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceThemeTitle;

  /// No description provided for @appearanceThemeSub.
  ///
  /// In en, this message translates to:
  /// **'Choose how Math Intelligence looks — match your device, or pick Dark or Light.'**
  String get appearanceThemeSub;

  /// No description provided for @appearanceThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appearanceThemeSystem;

  /// No description provided for @appearanceThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get appearanceThemeDark;

  /// No description provided for @appearanceThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get appearanceThemeLight;

  /// No description provided for @appearanceAccessibilityHeading.
  ///
  /// In en, this message translates to:
  /// **'ACCESSIBILITY'**
  String get appearanceAccessibilityHeading;

  /// No description provided for @appearanceReadingSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Size'**
  String get appearanceReadingSizeTitle;

  /// No description provided for @appearanceReadingSizeSub.
  ///
  /// In en, this message translates to:
  /// **'Small, Default, or Large text scaling'**
  String get appearanceReadingSizeSub;

  /// No description provided for @appearanceTouchTargetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Touch Targets 44px'**
  String get appearanceTouchTargetsTitle;

  /// No description provided for @appearanceTouchTargetsSub.
  ///
  /// In en, this message translates to:
  /// **'Ergonomic controls'**
  String get appearanceTouchTargetsSub;

  /// No description provided for @appearanceTypographyTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Typography'**
  String get appearanceTypographyTitle;

  /// No description provided for @appearanceTypographySub.
  ///
  /// In en, this message translates to:
  /// **'Readable font at all sizes'**
  String get appearanceTypographySub;

  /// No description provided for @appearanceResetOnboardingHeading.
  ///
  /// In en, this message translates to:
  /// **'RESET ONBOARDING'**
  String get appearanceResetOnboardingHeading;

  /// No description provided for @appearanceResetOnboardingSub.
  ///
  /// In en, this message translates to:
  /// **'Reset the app introduction to go through the initial setup again.'**
  String get appearanceResetOnboardingSub;

  /// No description provided for @appearanceResetOnboardingButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Onboarding'**
  String get appearanceResetOnboardingButton;
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
