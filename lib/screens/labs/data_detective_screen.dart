import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/interactive_lab_id.dart';
import '../../services/captain_math_service.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/labs/lab_progress_indicator.dart';
import '../../widgets/labs/lab_related_links.dart';
import '../../widgets/labs/lab_result_banner.dart';
import '../../widgets/labs/lab_scaffold.dart';

enum _Prediction { mean, median }

class _Dataset {
  const _Dataset(this.values, this.outlier, this.typicalValueToAdd);
  final List<int> values;
  final int outlier;
  final int typicalValueToAdd;
}

/// Deterministic, fixed dataset set (no procedural generation), each with
/// one clearly designed outlier — some high, some low, so the lab never
/// silently teaches "the outlier is always the biggest number".
const _datasets = <_Dataset>[
  _Dataset([22, 25, 24, 23, 26, 24, 90], 90, 24),
  _Dataset([78, 82, 80, 75, 79, 81, 20], 20, 79),
  _Dataset([18, 19, 17, 18, 20, 19, 2], 2, 18),
  _Dataset([28, 27, 29, 28, 30, 27, 55], 55, 28),
];

double _mean(List<int> values) => values.reduce((a, b) => a + b) / values.length;

double _median(List<int> values) {
  final sorted = [...values]..sort();
  final mid = sorted.length ~/ 2;
  if (sorted.length.isOdd) return sorted[mid].toDouble();
  return (sorted[mid - 1] + sorted[mid]) / 2;
}

String _fmt(double value) => value == value.roundToDouble()
    ? value.round().toString()
    : value.toStringAsFixed(1);

/// Teaches: the mean is pulled toward an outlier much more than the median
/// is — removing one extreme value changes the two averages by very
/// different amounts. Free removal of any value plus a dedicated
/// "remove the outlier" action both update the live statistics instantly.
class DataDetectiveScreen extends StatefulWidget {
  const DataDetectiveScreen({super.key});

  @override
  State<DataDetectiveScreen> createState() => _DataDetectiveScreenState();
}

class _DataDetectiveScreenState extends State<DataDetectiveScreen> {
  int _datasetIndex = 0;
  late List<int> _working;
  _Prediction? _prediction;
  String? _revealSummary;
  bool? _predictionCorrect;
  double? _meanBefore;
  double? _meanAfter;
  double? _medianBefore;
  double? _medianAfter;

  _Dataset get _dataset => _datasets[_datasetIndex];

  @override
  void initState() {
    super.initState();
    _working = [..._dataset.values];
  }

  void _removeAt(int index) {
    setState(() {
      _working.removeAt(index);
      _revealSummary = null;
      _predictionCorrect = null;
    });
  }

  void _addTypicalValue() {
    setState(() {
      _working.add(_dataset.typicalValueToAdd);
      _revealSummary = null;
      _predictionCorrect = null;
    });
  }

  void _selectPrediction(_Prediction prediction) {
    setState(() => _prediction = prediction);
  }

  Future<void> _reveal() async {
    if (_prediction == null) return;
    final before = List<int>.of(_working);
    final meanBefore = _mean(before);
    final medianBefore = _median(before);

    final after = List<int>.of(_working)..remove(_dataset.outlier);
    if (after.length == before.length) return; // outlier already removed

    final meanAfter = _mean(after);
    final medianAfter = _median(after);
    final meanShift = (meanAfter - meanBefore).abs();
    final medianShift = (medianAfter - medianBefore).abs();
    final meanShiftedMore = meanShift > medianShift;
    final correct =
        (_prediction == _Prediction.mean && meanShiftedMore) ||
            (_prediction == _Prediction.median && !meanShiftedMore);

    final l10n = AppLocalizations.of(context);
    setState(() {
      _working = after;
      _predictionCorrect = correct;
      _meanBefore = meanBefore;
      _meanAfter = meanAfter;
      _medianBefore = medianBefore;
      _medianAfter = medianAfter;
      _revealSummary = l10n.labsDataDetectiveShiftSummary(_fmt(meanShift), _fmt(medianShift));
    });

    await InteractiveLabsProgressService.instance.recordAttempt(InteractiveLabId.dataDetective);
    if (correct) {
      await InteractiveLabsProgressService.instance.recordCompletion(InteractiveLabId.dataDetective);
      CaptainMathService.instance.showCompletion();
    } else {
      CaptainMathService.instance.showEncouragement();
    }
  }

  void _reset() {
    setState(() {
      _working = [..._dataset.values];
      _prediction = null;
      _revealSummary = null;
      _predictionCorrect = null;
      _meanBefore = null;
      _meanAfter = null;
      _medianBefore = null;
      _medianAfter = null;
    });
  }

  void _next() {
    setState(() {
      _datasetIndex = (_datasetIndex + 1) % _datasets.length;
      _working = [..._datasets[_datasetIndex].values];
      _prediction = null;
      _revealSummary = null;
      _predictionCorrect = null;
      _meanBefore = null;
      _meanAfter = null;
      _medianBefore = null;
      _medianAfter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final outlierPresent = _working.contains(_dataset.outlier);
    final mean = _working.isEmpty ? 0.0 : _mean(_working);
    final median = _working.isEmpty ? 0.0 : _median(_working);
    final range = _working.isEmpty
        ? 0
        : (_working.reduce((a, b) => a > b ? a : b) - _working.reduce((a, b) => a < b ? a : b));

    return ListenableBuilder(
      listenable: InteractiveLabsProgressService.instance.updateSerial,
      builder: (context, _) => LabScaffold(
        labId: InteractiveLabId.dataDetective,
        title: l10n.labsDataDetectiveTitle,
        missionText: l10n.labsDataDetectiveMission,
        conceptText: l10n.labsDataDetectiveConcept,
        whereYoullUseThis: l10n.labsDataDetectiveWhereUsed,
        onReset: _reset,
        progressIndicator: LabProgressIndicator(
          label: l10n.recallCardsCardOf(_datasetIndex + 1, _datasets.length),
        ),
        helpContent: LabHelpContent(
          whatToDo: l10n.labsDataDetectiveHelpWhatToDo,
          whatToNotice: l10n.labsDataDetectiveHelpWhatToNotice,
          whatItMeans: l10n.labsDataDetectiveHelpWhatItMeans,
          whereUsed: l10n.labsDataDetectiveWhereUsed,
        ),
        firstUseSteps: [
          l10n.labsDataDetectiveFirstUseStep1,
          l10n.labsDataDetectiveFirstUseStep2,
          l10n.labsDataDetectiveFirstUseStep3,
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (outlierPresent)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  l10n.labsDataDetectiveOutlierExplanation(_dataset.outlier),
                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _working.length; i++)
                  InputChip(
                    // The outlier chip gets an explicit warning icon in
                    // addition to any colour, so it never depends on colour
                    // alone to stand out.
                    avatar: _working[i] == _dataset.outlier
                        ? const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFBD00), size: 18)
                        : null,
                    label: Text('${_working[i]}'),
                    onDeleted: () => _removeAt(i),
                    backgroundColor: const Color(0xFF132040),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(onPressed: _addTypicalValue, child: Text(l10n.labsDataDetectiveAddValueButton)),
            const SizedBox(height: AppSpacing.lg),
            _StatsRow(mean: mean, median: median, range: range, l10n: l10n),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.labsDataDetectivePredictionPrompt,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Text(l10n.labsDataDetectivePredictMeanButton),
                    selected: _prediction == _Prediction.mean,
                    onSelected: (_) => _selectPrediction(_Prediction.mean),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ChoiceChip(
                    label: Text(l10n.labsDataDetectivePredictMedianButton),
                    selected: _prediction == _Prediction.median,
                    onSelected: (_) => _selectPrediction(_Prediction.median),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_prediction != null && outlierPresent) ? _reveal : null,
                    child: Text(l10n.labsDataDetectiveRevealButton),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: Text(l10n.labsTryAgainButton),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: _next,
              child: Text(l10n.labsNextChallengeButton),
            ),
          ],
        ),
        feedback: _revealSummary == null
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabResultBanner(
                    kind: _predictionCorrect! ? LabResultKind.success : LabResultKind.tryAgain,
                    notice: _predictionCorrect!
                        ? l10n.labsDataDetectiveCorrectPrediction
                        : l10n.labsDataDetectiveIncorrectPrediction,
                    explain: _revealSummary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.labsDataDetectiveBeforeAfter(
                      _fmt(_meanBefore!),
                      _fmt(_meanAfter!),
                      _fmt(_medianBefore!),
                      _fmt(_medianAfter!),
                    ),
                    style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 12, height: 1.4),
                  ),
                ],
              ),
        relatedLinks: const LabRelatedLinks(
          labId: InteractiveLabId.dataDetective,
          recallCardIds: ['stats-mean-vs-median-outlier-misconception', 'stats-mean-formula'],
          discoveryCardIds: [],
          practiceTopicIds: ['statistics_probability'],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.mean, required this.median, required this.range, required this.l10n});

  final double mean;
  final double median;
  final int range;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatTile(label: l10n.labsDataDetectiveMeanLabel, value: _fmt(mean))),
        Expanded(child: _StatTile(label: l10n.labsDataDetectiveMedianLabel, value: _fmt(median))),
        Expanded(child: _StatTile(label: l10n.labsDataDetectiveRangeLabel, value: '$range')),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $value',
      child: ExcludeSemantics(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
