import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/number_sense_example.dart';
import '../../models/number_sense_state.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/labs/lab_help_sheet.dart';
import '../../widgets/number_sense/fraction_comparison_visual.dart';
import '../../widgets/number_sense/number_sense_lab_workspace.dart';

/// Local, non-persistent guided and free-explore Number Sense Lab.
class NumberSenseLabScreen extends StatefulWidget {
  const NumberSenseLabScreen({super.key});

  @override
  State<NumberSenseLabScreen> createState() => _NumberSenseLabScreenState();
}

class _NumberSenseLabScreenState extends State<NumberSenseLabScreen> {
  NumberSenseState _state = NumberSenseState.guided();
  NumberSenseExampleId _activeExample = NumberSenseExampleId.equivalenceHalf;

  NumberSenseExample get _example => NumberSenseExample.of(_activeExample);

  void _setMode(NumberSenseMode mode) {
    if (mode == _state.mode) return;
    setState(() {
      if (mode == NumberSenseMode.freeExplore) {
        _activeExample = _state.activeExample ?? _activeExample;
        _state = _state.switchMode(mode);
      } else {
        _state = NumberSenseState.guided(_activeExample);
      }
    });
  }

  void _reset() {
    setState(() {
      _state = _state.mode == NumberSenseMode.freeExplore
          ? _state.resetFreeExplore()
          : _state.resetGuided();
    });
  }

  void _tryAnotherExample() {
    setState(() {
      final guided = _state.mode == NumberSenseMode.guided
          ? _state
          : NumberSenseState.guided(_activeExample);
      _state = guided.cycleExample();
      _activeExample = _state.activeExample!;
    });
  }

  void _answerComparison(NumberSenseComparison answer) {
    setState(() => _state = _state.answerComparison(answer));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final systemReduceMotion = MediaQuery.disableAnimationsOf(context);

    return ValueListenableBuilder<bool>(
      valueListenable: LocalPreferencesService.instance.reduceMotion,
      builder: (context, preferenceReduceMotion, _) => Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: Text(l10n.numberSenseLabTitle),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _modeControls(l10n),
                    if (_state.mode == NumberSenseMode.guided) ...[
                      const SizedBox(height: AppSpacing.md),
                      _guidedContext(l10n, colors),
                    ] else ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.numberSenseFreeExploreInstruction,
                        key: const ValueKey(
                            'numberSense.freeExploreInstruction'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    if (_state.mode == NumberSenseMode.freeExplore ||
                        _example.expectedComparison == null)
                      NumberSenseLabWorkspace(
                        state: _state,
                        reduceMotion:
                            preferenceReduceMotion || systemReduceMotion,
                        onChanged: (next) => setState(() => _state = next),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    _fractionHelpButtons(l10n),
                    const SizedBox(height: AppSpacing.md),
                    if (_state.isGuidedComplete)
                      Semantics(
                        key: const ValueKey('numberSense.guidedCompletion'),
                        container: true,
                        liveRegion: true,
                        label: l10n.numberSenseComplete,
                        child: ExcludeSemantics(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: colors.success.withValues(alpha: 0.1),
                              border: Border.all(
                                color: colors.success.withValues(alpha: 0.35),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  key: const ValueKey(
                                      'numberSense.guidedCompletion.icon'),
                                  color: _successTextColor(context, colors),
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Flexible(
                                  child: Text(
                                    l10n.numberSenseComplete,
                                    key: const ValueKey(
                                        'numberSense.guidedCompletion.text'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _successTextColor(context, colors),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    _actions(l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _modeControls(AppLocalizations l10n) => Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          ChoiceChip(
            key: const ValueKey('numberSense.modeGuided'),
            label: Text(l10n.numberSenseModeGuided),
            selected: _state.mode == NumberSenseMode.guided,
            onSelected: (_) => _setMode(NumberSenseMode.guided),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          ChoiceChip(
            key: const ValueKey('numberSense.modeFreeExplore'),
            label: Text(l10n.numberSenseModeFreeExplore),
            selected: _state.mode == NumberSenseMode.freeExplore,
            onSelected: (_) => _setMode(NumberSenseMode.freeExplore),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ],
      );

  Widget _guidedContext(AppLocalizations l10n, AppSemanticColors colors) {
    final example = _example;
    final String title;
    final String task;
    switch (example.id) {
      case NumberSenseExampleId.equivalenceHalf:
        title = l10n.numberSenseExampleEquivalenceTitle;
        task = l10n.numberSenseExampleEquivalenceTask;
      case NumberSenseExampleId.placeThreeEighths:
        title = l10n.numberSenseExamplePlacementTitle;
        task = l10n.numberSenseExamplePlacementTask;
      case NumberSenseExampleId.compareTwoEighthsAndFiveEighths:
      case NumberSenseExampleId.compareThreeQuartersAndThreeEighths:
      case NumberSenseExampleId.compareThreeSixthsAndOneHalf:
      case NumberSenseExampleId.compareFiveEighthsAndOneHalf:
      case NumberSenseExampleId.compareTwoThirdsAndThreeQuarters:
        title = l10n.numberSenseExampleComparisonTitle;
        task = l10n.numberSenseExampleComparisonTask;
    }

    return Semantics(
      key: ValueKey('numberSense.example.${example.id.name}'),
      container: true,
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(task, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          if (example.expectedComparison == null)
            Text(
              l10n.numberSenseTarget(
                '${example.primary.numerator}/${example.primary.denominator}',
              ),
              key: const ValueKey('numberSense.guidedTarget'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            )
          else ...[
            FractionComparisonVisual(
              left: example.primary,
              right: example.secondary!,
              leftNumerator: example.shownPrimaryNumerator,
              leftDenominator: example.shownPrimaryDenominator,
              rightNumerator: example.shownSecondaryNumerator,
              rightDenominator: example.shownSecondaryDenominator,
              leftLabel:
                  '${example.shownPrimaryNumerator}/${example.shownPrimaryDenominator}',
              rightLabel:
                  '${example.shownSecondaryNumerator}/${example.shownSecondaryDenominator}',
              numberLineLabel: l10n.numberSenseCompareSharedLineLabel,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${example.shownPrimaryNumerator}/${example.shownPrimaryDenominator}  ?  '
              '${example.shownSecondaryNumerator}/${example.shownSecondaryDenominator}',
              key: const ValueKey('numberSense.comparisonQuestion'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _comparisonChoice(
                  symbol: '<',
                  label: l10n.numberSenseCompareLessThan,
                  answer: NumberSenseComparison.lessThan,
                ),
                _comparisonChoice(
                  symbol: '=',
                  label: l10n.numberSenseCompareEqualTo,
                  answer: NumberSenseComparison.equal,
                ),
                _comparisonChoice(
                  symbol: '>',
                  label: l10n.numberSenseCompareGreaterThan,
                  answer: NumberSenseComparison.greaterThan,
                ),
              ],
            ),
            if (_state.comparisonAnswer case final answer?) ...[
              const SizedBox(height: AppSpacing.sm),
              _comparisonFeedback(l10n, answer),
            ],
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.xs,
              children: [
                _helpButton(
                  key: const ValueKey('numberSense.help.symbol.lessThan'),
                  label: '<',
                  semanticLabel: l10n.numberSenseHelpLessThanLabel,
                  definition: l10n.numberSenseHelpLessThanDescription,
                  l10n: l10n,
                ),
                _helpButton(
                  key: const ValueKey('numberSense.help.symbol.equal'),
                  label: '=',
                  semanticLabel: l10n.numberSenseHelpEqualLabel,
                  definition: l10n.numberSenseHelpEqualDescription,
                  l10n: l10n,
                ),
                _helpButton(
                  key: const ValueKey('numberSense.help.symbol.greaterThan'),
                  label: '>',
                  semanticLabel: l10n.numberSenseHelpGreaterThanLabel,
                  definition: l10n.numberSenseHelpGreaterThanDescription,
                  l10n: l10n,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _comparisonChoice({
    required String symbol,
    required String label,
    required NumberSenseComparison answer,
  }) {
    final selected = _state.comparisonAnswer == answer;
    final colors = context.appColors;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: OutlinedButton(
        key: ValueKey('numberSense.answer.${answer.name}'),
        onPressed: () => _answerComparison(answer),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              selected ? colors.accent.withValues(alpha: 0.18) : null,
          side: BorderSide(
            color: selected ? colors.accent : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              symbol,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 6),
            Text(label),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check, color: colors.primaryText, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fractionHelpButtons(AppLocalizations l10n) => Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          _helpButton(
            key: const ValueKey('numberSense.help.numerator'),
            label: l10n.numberSenseHelpNumeratorLabel,
            semanticLabel: l10n.numberSenseHelpNumeratorLabel,
            definition: l10n.numberSenseHelpNumeratorDescription,
            l10n: l10n,
          ),
          _helpButton(
            key: const ValueKey('numberSense.help.denominator'),
            label: l10n.numberSenseHelpDenominatorLabel,
            semanticLabel: l10n.numberSenseHelpDenominatorLabel,
            definition: l10n.numberSenseHelpDenominatorDescription,
            l10n: l10n,
          ),
          _helpButton(
            key: const ValueKey('numberSense.help.equivalent'),
            label: l10n.numberSenseHelpEquivalentLabel,
            semanticLabel: l10n.numberSenseHelpEquivalentLabel,
            definition: l10n.numberSenseHelpEquivalentDescription,
            l10n: l10n,
          ),
        ],
      );

  Widget _helpButton({
    required Key key,
    required String label,
    required String semanticLabel,
    required String definition,
    required AppLocalizations l10n,
  }) =>
      ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Semantics(
          key: key,
          button: true,
          label: semanticLabel,
          onTap: () => showLabHelpSheet(
            context,
            LabHelpContent(
              whatToDo: l10n.numberSenseHelpWhatToDo,
              whatToNotice: definition,
              whatItMeans: l10n.numberSenseHelpWhatItMeans,
              whereUsed: l10n.numberSenseHelpWhereUsed,
            ),
          ),
          child: ExcludeSemantics(
            child: TextButton(
              onPressed: () => showLabHelpSheet(
                context,
                LabHelpContent(
                  whatToDo: l10n.numberSenseHelpWhatToDo,
                  whatToNotice: definition,
                  whatItMeans: l10n.numberSenseHelpWhatItMeans,
                  whereUsed: l10n.numberSenseHelpWhereUsed,
                ),
              ),
              child: Text(label),
            ),
          ),
        ),
      );

  Widget _comparisonFeedback(
    AppLocalizations l10n,
    NumberSenseComparison answer,
  ) {
    final example = _example;
    final left = example.primary;
    final right = example.secondary!;
    final expected = compareExactFractions(left, right);
    final isCorrect = answer == expected;
    final leftText =
        '${example.shownPrimaryNumerator}/${example.shownPrimaryDenominator}';
    final rightText =
        '${example.shownSecondaryNumerator}/${example.shownSecondaryDenominator}';
    final relation = _comparisonSymbol(expected);
    final relationWords = switch (expected) {
      NumberSenseComparison.lessThan => l10n.numberSenseCompareLessThanWords,
      NumberSenseComparison.equal => l10n.numberSenseCompareEqualWords,
      NumberSenseComparison.greaterThan =>
        l10n.numberSenseCompareGreaterThanWords,
    };
    final feedback = isCorrect
        ? l10n.numberSenseComparisonCorrectResultDynamic(
            leftText,
            relation,
            rightText,
          )
        : l10n.numberSenseComparisonIncorrectResultDynamic(
            leftText,
            relationWords,
            rightText,
          );
    final leftProduct =
        example.shownPrimaryNumerator * example.shownSecondaryDenominator;
    final rightProduct =
        example.shownSecondaryNumerator * example.shownPrimaryDenominator;
    final proof = l10n.numberSenseComparisonProofDynamic(
      example.shownPrimaryNumerator,
      example.shownSecondaryDenominator,
      leftProduct,
      example.shownSecondaryNumerator,
      example.shownPrimaryDenominator,
      rightProduct,
      relation,
      leftText,
      rightText,
    );
    final colors = context.appColors;
    return Semantics(
      key: const ValueKey('numberSense.comparisonFeedback'),
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(color: colors.divider),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isCorrect ? Icons.check_circle_outline : Icons.info_outline,
              color: colors.primaryText,
              semanticLabel: isCorrect
                  ? l10n.numberSenseComparisonCorrectLabel
                  : l10n.numberSenseComparisonReviewLabel,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(proof),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _comparisonSymbol(NumberSenseComparison comparison) =>
      switch (comparison) {
        NumberSenseComparison.lessThan => '<',
        NumberSenseComparison.equal => '=',
        NumberSenseComparison.greaterThan => '>',
      };

  Color _successTextColor(
    BuildContext context,
    AppSemanticColors colors,
  ) =>
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFF176B2C)
          : colors.success;

  Widget _actions(AppLocalizations l10n) => Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          if (_state.mode == NumberSenseMode.guided)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: OutlinedButton(
                key: const ValueKey('numberSense.reset'),
                onPressed: _reset,
                child: Text(l10n.numberSenseReset),
              ),
            ),
          if (_state.mode == NumberSenseMode.guided)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: OutlinedButton(
                key: const ValueKey('numberSense.tryAnotherExample'),
                onPressed: _tryAnotherExample,
                child: Text(l10n.numberSenseTryAnotherExample),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: OutlinedButton(
                key: const ValueKey('numberSense.clearExplore'),
                onPressed: _reset,
                child: Text(l10n.numberSenseClearExplore),
              ),
            ),
        ],
      );
}
