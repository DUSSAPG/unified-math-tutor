import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../../models/aircraft_landing_challenge.dart';
import '../../../models/interactive_lab_id.dart';
import '../../../services/aircraft_landing_lab_progress_service.dart';
import '../../../services/interactive_labs_progress_service.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../widgets/labs/lab_help_sheet.dart';
import '../../../widgets/labs/lab_related_links.dart';
import '../../../widgets/labs/lab_result_banner.dart';
import '../../../widgets/labs/lab_scaffold.dart';

/// Activity 1: given a horizontal speed and ground distance (deliberately
/// no altitude/angle yet — this is the simplest activity, introducing
/// `time = distance / speed` before the other three add descent angle),
/// the learner picks the correct time to the runway from computed
/// multiple-choice options. Uses a lightweight custom diagram rather than
/// the full [FlightApproachView] engine, since altitude/angle aren't part
/// of this activity's concept yet — see the build report for why not
/// every activity forces the shared descent-profile visual.
class AircraftLandingFindTheTimeScreen extends StatefulWidget {
  const AircraftLandingFindTheTimeScreen({super.key});

  @override
  State<AircraftLandingFindTheTimeScreen> createState() =>
      _AircraftLandingFindTheTimeScreenState();
}

class _AircraftLandingFindTheTimeScreenState
    extends State<AircraftLandingFindTheTimeScreen> {
  int _challengeIndex = 0;
  int _attemptsThisChallenge = 0;
  double? _selectedAnswer;
  bool? _wasCorrect;
  bool _hintShown = false;

  FindTheTimeChallenge get _challenge =>
      FindTheTimeChallenge.forIndex(_challengeIndex);

  @override
  void initState() {
    super.initState();
    AircraftLandingLabProgressService.instance
        .setLastActivityId(AircraftLandingActivityId.findTheTime);
  }

  void _selectAnswer(double option) {
    if (_selectedAnswer != null) return;
    final correct = (option - _challenge.correctTimeSeconds).abs() < 0.5;
    setState(() {
      _selectedAnswer = option;
      _attemptsThisChallenge++;
      _wasCorrect = correct;
    });
    InteractiveLabsProgressService.instance
        .recordAttempt(InteractiveLabId.aircraftLandingLab);
    if (correct) {
      InteractiveLabsProgressService.instance
          .recordCompletion(InteractiveLabId.aircraftLandingLab);
      AircraftLandingLabProgressService.instance
          .markCompleted(AircraftLandingActivityId.findTheTime);
      AircraftLandingLabProgressService.instance.recordAttemptCount(
          AircraftLandingActivityId.findTheTime, _attemptsThisChallenge);
    }
  }

  void _retry() {
    setState(() {
      _selectedAnswer = null;
      _wasCorrect = null;
    });
  }

  void _nextChallenge() {
    setState(() {
      _challengeIndex++;
      _selectedAnswer = null;
      _wasCorrect = null;
      _attemptsThisChallenge = 0;
      _hintShown = false;
    });
  }

  void _showHint() {
    setState(() => _hintShown = true);
    AircraftLandingLabProgressService.instance
        .recordHintUsed(AircraftLandingActivityId.findTheTime);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final lab = context.labColors;
    final answered = _selectedAnswer != null;

    final diagram = Semantics(
      label: l10n.labsAircraftLandingFindTheTimeDiagramLabel(
        _challenge.groundDistanceM.round(),
        _challenge.horizontalSpeedMps.round(),
      ),
      image: true,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.flight, color: lab.radarLanding, size: 28),
              Expanded(
                child: Column(
                  children: [
                    Container(height: 2, color: colors.divider),
                    const SizedBox(height: 4),
                    Text(
                      '${_challenge.groundDistanceM.round()} m',
                      style:
                          TextStyle(color: colors.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.flight_land, color: lab.radarTarget, size: 28),
            ],
          ),
        ),
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        diagram,
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.labsAircraftLandingFindTheTimeSpeedLabel(
              _challenge.horizontalSpeedMps.round()),
          style: TextStyle(color: colors.primaryText, fontSize: 14),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.labsAircraftLandingFindTheTimeQuestion,
          style: TextStyle(
              color: colors.primaryText,
              fontWeight: FontWeight.w700,
              fontSize: 15),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in _challenge.options)
              _AnswerChip(
                label: '${option.round()} s',
                selected: _selectedAnswer == option,
                onTap: answered ? null : () => _selectAnswer(option),
              ),
          ],
        ),
        if (!answered) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _hintShown ? null : _showHint,
            icon: const Icon(Icons.lightbulb_outline, size: 18),
            label: Text(l10n.labsAircraftLandingFindTheTimeHintButton),
          ),
          if (_hintShown)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.labsAircraftLandingFindTheTimeHintText,
                style: TextStyle(color: colors.secondaryText, fontSize: 13),
              ),
            ),
        ],
      ],
    );

    return LabScaffold(
      labId: InteractiveLabId.aircraftLandingLab,
      title: l10n.labsAircraftLandingFindTheTimeTitle,
      missionText: l10n.labsAircraftLandingFindTheTimeMission,
      whereYoullUseThis: l10n.labsAircraftLandingFindTheTimeWhereUsed,
      onReset: _retry,
      body: body,
      feedback: answered
          ? LabResultBanner(
              kind: _wasCorrect == true
                  ? LabResultKind.success
                  : LabResultKind.tryAgain,
              notice: _wasCorrect == true
                  ? l10n.labsAircraftLandingFindTheTimeCorrect
                  : l10n.labsAircraftLandingFindTheTimeIncorrect,
              explain: l10n.labsAircraftLandingFindTheTimeReveal(
                  _challenge.correctTimeSeconds.round()),
            )
          : null,
      postResultActions: answered
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _retry,
                    child: Text(l10n.labsTryAgainButton),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _nextChallenge,
                    child: Text(l10n.labsNextChallengeButton),
                  ),
                ),
              ],
            )
          : null,
      helpContent: LabHelpContent(
        whatToDo: l10n.labsAircraftLandingFindTheTimeHelpWhatToDo,
        whatToNotice: l10n.labsAircraftLandingFindTheTimeHelpWhatToNotice,
        whatItMeans: l10n.labsAircraftLandingFindTheTimeHelpWhatItMeans,
        whereUsed: l10n.labsAircraftLandingFindTheTimeWhereUsed,
      ),
      firstUseSteps: [
        l10n.labsAircraftLandingFindTheTimeHelpWhatToDo,
        l10n.labsAircraftLandingFindTheTimeHelpWhatToNotice,
      ],
      relatedLinks: const LabRelatedLinks(
        labId: InteractiveLabId.aircraftLandingLab,
        recallCardIds: ['speed-distance-time-formula'],
        discoveryCardIds: ['aviation-fuel-endurance'],
        practiceTopicIds: ['geometry_measures'],
      ),
    );
  }
}

class _AnswerChip extends StatelessWidget {
  const _AnswerChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: selected
          ? FilledButton(onPressed: onTap, child: Text(label))
          : OutlinedButton(onPressed: onTap, child: Text(label)),
    );
  }
}
