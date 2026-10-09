import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/exact_fraction.dart';
import '../../models/number_sense_example.dart';
import '../../models/number_sense_comparison_explanation.dart';
import '../../models/number_sense_guided_practice.dart';
import '../../models/number_sense_state.dart';
import '../../services/hundredths_precision_geometry.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/number_sense/fraction_comparison_visual.dart';
import '../../widgets/number_sense/hundredths_precision_line.dart';
import '../../widgets/number_sense/number_sense_lab_workspace.dart';

/// Local, non-persistent guided and free-explore Number Sense Lab.
class NumberSenseLabScreen extends StatefulWidget {
  const NumberSenseLabScreen({super.key});

  @override
  State<NumberSenseLabScreen> createState() => _NumberSenseLabScreenState();
}

class _NumberSenseLabScreenState extends State<NumberSenseLabScreen> {
  NumberSenseExampleId _activeExample = NumberSenseExampleId.placeThreeEighths;
  late NumberSenseState _state = NumberSenseState.guided(_activeExample);

  final NumberSenseGuidedPractice _practice = NumberSenseGuidedPractice();

  NumberSenseExample get _example => NumberSenseExample.of(_activeExample);

  void _loadGuided(NumberSenseExampleId id) {
    setState(() {
      _activeExample = id;
      _state = NumberSenseState.guided(id);
    });
  }

  void _practiseCurrent() => _loadGuided(_practice.practise());

  void _anotherExample() => _loadGuided(_practice.anotherExample());

  String _skillName(AppLocalizations l10n, NumberSenseGuidedSkill skill) =>
      switch (skill) {
        NumberSenseGuidedSkill.placeFraction =>
          l10n.numberSenseSkillPlaceFraction,
        NumberSenseGuidedSkill.makeEquivalent =>
          l10n.numberSenseSkillMakeEquivalent,
        NumberSenseGuidedSkill.compareFractions =>
          l10n.numberSenseSkillCompareFractions,
        NumberSenseGuidedSkill.findOneHundredth =>
          l10n.numberSenseSkillFindOneHundredth,
      };

  String _focusName(AppLocalizations l10n, NumberSenseComparisonFocus focus) =>
      switch (focus) {
        NumberSenseComparisonFocus.sameDenominator =>
          l10n.numberSenseFocusSameDenominator,
        NumberSenseComparisonFocus.sameNumerator =>
          l10n.numberSenseFocusSameNumerator,
        NumberSenseComparisonFocus.equivalentFractions =>
          l10n.numberSenseFocusEquivalent,
        NumberSenseComparisonFocus.compareToHalf =>
          l10n.numberSenseFocusCompareToHalf,
        NumberSenseComparisonFocus.mixed => l10n.numberSenseFocusMixed,
      };

  Widget _practicePanel(AppLocalizations l10n) {
    Widget button(String key, String label, VoidCallback onPressed) =>
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: OutlinedButton(
            key: ValueKey(key),
            onPressed: onPressed,
            child: Text(label),
          ),
        );
    final progress = l10n.numberSenseSkillProgress(
      _practice.skillNumber,
      _practice.skillCount,
      _skillName(l10n, _practice.skill),
    );
    return Column(
      key: const ValueKey('numberSense.practicePanel'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          container: true,
          header: true,
          label: progress,
          child: ExcludeSemantics(
            child: Text(
              progress,
              key: const ValueKey('numberSense.skillProgress'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            button(
              'numberSense.practiseThis',
              l10n.numberSensePractiseThis,
              _practiseCurrent,
            ),
            button(
              'numberSense.anotherExample',
              l10n.numberSenseAnotherExample,
              _anotherExample,
            ),
            button(
              'numberSense.nextSkill',
              l10n.numberSenseNextSkill,
              () => _loadGuided(_practice.nextSkill()),
            ),
            button(
              'numberSense.chooseSkill',
              l10n.numberSenseChooseSkill,
              _chooseSkill,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _chooseSkill() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => _SkillChooserSheet(
          selectedSkill: _practice.skill,
          selectedFocus: _practice.comparisonFocus,
          skillName: (skill) =>
              _skillName(AppLocalizations.of(sheetContext), skill),
          focusName: (focus) =>
              _focusName(AppLocalizations.of(sheetContext), focus),
          onSkill: (skill) => _loadGuided(_practice.selectSkill(skill)),
          onFocus: (focus) =>
              _loadGuided(_practice.selectComparisonFocus(focus)),
        ),
      );

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
                      _practicePanel(l10n),
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
                      const SizedBox(height: AppSpacing.sm),
                      _exploreModelControls(l10n),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    if (_state.mode == NumberSenseMode.freeExplore &&
                        _state.usesPrecisionLine)
                      _precisionLineContent(l10n, guided: false)
                    else if (_state.mode == NumberSenseMode.freeExplore ||
                        (_example.expectedComparison == null &&
                            !_example.isPrecisionLine))
                      NumberSenseLabWorkspace(
                        state: _state,
                        reduceMotion:
                            preferenceReduceMotion || systemReduceMotion,
                        onChanged: (next) => setState(() => _state = next),
                      ),
                    if (_state.mode == NumberSenseMode.guided &&
                        !_state.usesPrecisionLine &&
                        _example.expectedComparison == null &&
                        _state.wholePartModelTouched &&
                        !_state.isGuidedComplete)
                      _wholePartFeedback(l10n),
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
      case NumberSenseExampleId.equivalenceHalfFourths:
      case NumberSenseExampleId.equivalenceHalfSixths:
      case NumberSenseExampleId.equivalenceHalfEighths:
        title = l10n.numberSenseExampleEquivalenceTitle;
        task = l10n.numberSenseExampleEquivalenceTaskParts(
          example.startDenominator,
        );
      case NumberSenseExampleId.placeThreeEighths:
        title = l10n.numberSenseExamplePlacementTitle;
        task = l10n.numberSenseExamplePlacementTask;
      case NumberSenseExampleId.placeOneHalf:
        title = l10n.numberSenseExamplePlacementTitle;
        task = l10n.numberSenseExamplePlacementTaskHalf;
      case NumberSenseExampleId.placeTwoThirds:
        title = l10n.numberSenseExamplePlacementTitle;
        task = l10n.numberSenseExamplePlacementTaskTwoThirds;
      case NumberSenseExampleId.compareTwoEighthsAndFiveEighths:
      case NumberSenseExampleId.compareThreeQuartersAndThreeEighths:
      case NumberSenseExampleId.compareThreeSixthsAndOneHalf:
      case NumberSenseExampleId.compareFiveEighthsAndOneHalf:
      case NumberSenseExampleId.compareTwoThirdsAndThreeQuarters:
        title = l10n.numberSenseExampleComparisonTitle;
        task = l10n.numberSenseExampleComparisonTask;
      case NumberSenseExampleId.findOneHundredth:
        title = l10n.numberSenseExampleHundredthsTitle;
        task = l10n.numberSenseExampleHundredthsTask;
      case NumberSenseExampleId.findThreeHundredths:
      case NumberSenseExampleId.findSixHundredths:
        title = l10n.numberSenseExampleHundredthsTitleCount(
          example.shownPrimaryNumerator,
        );
        task = l10n.numberSenseExampleHundredthsTaskCount(
          example.shownPrimaryNumerator,
        );
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
          if (example.isPrecisionLine)
            _precisionLineContent(l10n, guided: true)
          else if (example.expectedComparison == null)
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
          ],
        ],
      ),
    );
  }

  Widget _exploreModelControls(AppLocalizations l10n) => Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          ChoiceChip(
            key: const ValueKey('numberSense.explore.wholePartModel'),
            label: Text(l10n.numberSenseWholePartModel),
            selected: !_state.usesPrecisionLine,
            onSelected: (_) => setState(
              () => _state = _state.selectPrecisionLine(false),
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          ChoiceChip(
            key: const ValueKey('numberSense.explore.precisionLine'),
            label: Text(l10n.numberSensePrecisionLine),
            selected: _state.usesPrecisionLine,
            onSelected: (_) => setState(
              () => _state = _state.selectPrecisionLine(true),
            ),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
        ],
      );

  Widget _precisionLineContent(
    AppLocalizations l10n, {
    required bool guided,
  }) {
    final hundredths = _state.precisionHundredths;
    final decimal = HundredthsPrecisionGeometry.decimalAt(hundredths);
    final isZero = hundredths == 0;
    final fractionText = isZero ? '0' : '$hundredths/100';
    final target = _example.shownPrimaryNumerator;
    final targetFraction = '$target/100';
    final targetDecimal = HundredthsPrecisionGeometry.decimalAt(target);
    final isOneHundredth = target == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (guided) ...[
          Text(
            l10n.numberSenseTarget(targetFraction),
            key: const ValueKey('numberSense.precisionTarget'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.numberSenseHundredthsTargetEquationDynamic(
              targetFraction,
              targetDecimal,
            ),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ] else
          Text(
            l10n.numberSenseHundredthsExploreInstruction,
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: AppSpacing.sm),
        HundredthsPrecisionLine(
          selectedHundredths: hundredths,
          semanticLabel: l10n.numberSenseHundredthsLineLabel,
          onChanged: (next) => setState(
            () => _state = _state.setPrecisionHundredths(next),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$fractionText = $decimal',
          key: const ValueKey('numberSense.precisionReadout'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          isZero
              ? l10n.numberSenseHundredthsZeroExplanation
              : l10n.numberSenseHundredthsSelectionExplanation(
                  fractionText,
                  decimal,
                  hundredths,
                ),
          key: const ValueKey('numberSense.precisionExplanation'),
          textAlign: TextAlign.center,
        ),
        if (guided &&
            _state.precisionLineTouched &&
            !_state.isGuidedComplete) ...[
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            key: const ValueKey('numberSense.precisionFeedback'),
            container: true,
            liveRegion: true,
            child: Text(
              hundredths == 0
                  ? (isOneHundredth
                      ? l10n.numberSenseHundredthsZeroGuidedFeedback
                      : l10n.numberSenseHundredthsZeroGuidedFeedbackTarget(
                          target,
                          targetDecimal,
                        ))
                  : (isOneHundredth
                      ? l10n.numberSenseHundredthsIncorrectFeedback(decimal)
                      : l10n.numberSenseHundredthsIncorrectFeedbackTarget(
                          decimal,
                          target,
                          targetDecimal,
                        )),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _wholePartFeedback(AppLocalizations l10n) {
    final example = _example;
    final selected = '${_state.shadedParts}/${_state.denominator}';
    final target = example.primary.toString();
    final colors = context.appColors;
    final String message;

    if (example.primary == ExactFraction(1, 2) &&
        _state.value == ExactFraction(1, 1)) {
      message = l10n.numberSenseGuidedWrongEquivalenceWhole(
        selected,
        target,
      );
    } else if (_state.denominator == example.primary.denominator &&
        (_state.shadedParts - example.primary.numerator).abs() == 1) {
      final direction = _state.shadedParts < example.primary.numerator
          ? l10n.numberSenseGuidedDirectionRight
          : l10n.numberSenseGuidedDirectionLeft;
      message = l10n.numberSenseGuidedWrongAdjacent(
        selected,
        direction,
        target,
      );
    } else if (_state.denominator % example.primary.denominator != 0) {
      message = l10n.numberSenseGuidedWrongPartition(
        selected,
        target,
      );
    } else {
      message = l10n.numberSenseGuidedWrongGeneral(
        selected,
        target,
      );
    }

    return Semantics(
      key: const ValueKey('numberSense.guidedPlacementFeedback'),
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
            Icon(Icons.info_outline, color: colors.primaryText),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(message)),
          ],
        ),
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
    final explanation = _comparisonExplanation(
      l10n,
      example: example,
      leftText: leftText,
      rightText: rightText,
      relation: relation,
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
                  Text(explanation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _comparisonExplanation(
    AppLocalizations l10n, {
    required NumberSenseExample example,
    required String leftText,
    required String rightText,
    required String relation,
  }) {
    final strategy = NumberSenseComparisonExplanation.select(
      example.primary,
      example.secondary!,
      leftNumerator: example.shownPrimaryNumerator,
      leftDenominator: example.shownPrimaryDenominator,
      rightNumerator: example.shownSecondaryNumerator,
      rightDenominator: example.shownSecondaryDenominator,
    ).strategy;
    final leftNumerator = example.shownPrimaryNumerator;
    final leftDenominator = example.shownPrimaryDenominator;
    final rightNumerator = example.shownSecondaryNumerator;
    final rightDenominator = example.shownSecondaryDenominator;

    switch (strategy) {
      case NumberSenseComparisonStrategy.equivalentFractions:
        return l10n.numberSenseComparisonExplanationEquivalent(
          leftText,
          rightText,
        );
      case NumberSenseComparisonStrategy.sameDenominator:
        final leftIsLarger = example.primary.compareTo(example.secondary!) > 0;
        return l10n.numberSenseComparisonExplanationSameDenominator(
          _fractionUnit(l10n, leftDenominator),
          leftIsLarger ? leftNumerator : rightNumerator,
          leftIsLarger ? rightNumerator : leftNumerator,
          leftText,
          relation,
          rightText,
        );
      case NumberSenseComparisonStrategy.sameNumerator:
        final leftIsLarger = example.primary.compareTo(example.secondary!) > 0;
        return l10n.numberSenseComparisonExplanationSameNumerator(
          leftNumerator,
          _fractionUnit(
            l10n,
            leftIsLarger ? leftDenominator : rightDenominator,
            capitalize: true,
          ),
          _fractionUnit(
              l10n, leftIsLarger ? rightDenominator : leftDenominator),
          leftIsLarger ? leftText : rightText,
          leftIsLarger ? '>' : '<',
          leftIsLarger ? rightText : leftText,
        );
      case NumberSenseComparisonStrategy.benchmarkHalf:
        final halfIsLeft =
            example.primary.numerator == 1 && example.primary.denominator == 2;
        final halfDenominator = halfIsLeft ? rightDenominator : leftDenominator;
        final otherNumerator = halfIsLeft ? rightNumerator : leftNumerator;
        final halfNumerator = halfDenominator ~/ 2;
        final isOneStepMore = otherNumerator > halfNumerator;
        return l10n.numberSenseComparisonExplanationBenchmarkHalf(
          '$halfNumerator/$halfDenominator',
          halfIsLeft ? rightText : leftText,
          _fractionUnit(l10n, halfDenominator, singular: true),
          isOneStepMore
              ? l10n.numberSenseComparisonMore
              : l10n.numberSenseComparisonLess,
          leftText,
          relation,
          rightText,
        );
      case NumberSenseComparisonStrategy.crossMultiplication:
        final leftProduct = leftNumerator * rightDenominator;
        final rightProduct = rightNumerator * leftDenominator;
        return l10n.numberSenseComparisonProofDynamic(
          leftNumerator,
          rightDenominator,
          leftProduct,
          rightNumerator,
          leftDenominator,
          rightProduct,
          relation,
          leftText,
          rightText,
        );
    }
  }

  String _fractionUnit(
    AppLocalizations l10n,
    int denominator, {
    bool singular = false,
    bool capitalize = false,
  }) =>
      switch ((denominator, singular, capitalize)) {
        (2, false, false) => l10n.numberSenseComparisonHalves,
        (2, false, true) => l10n.numberSenseComparisonCapHalves,
        (2, true, _) => l10n.numberSenseComparisonHalf,
        (3, false, false) => l10n.numberSenseComparisonThirds,
        (3, false, true) => l10n.numberSenseComparisonCapThirds,
        (3, true, _) => l10n.numberSenseComparisonThird,
        (4, false, false) => l10n.numberSenseComparisonFourths,
        (4, false, true) => l10n.numberSenseComparisonCapFourths,
        (4, true, _) => l10n.numberSenseComparisonFourth,
        (6, false, false) => l10n.numberSenseComparisonSixths,
        (6, false, true) => l10n.numberSenseComparisonCapSixths,
        (6, true, _) => l10n.numberSenseComparisonSixth,
        (8, false, false) => l10n.numberSenseComparisonEighths,
        (8, false, true) => l10n.numberSenseComparisonCapEighths,
        (8, true, _) => l10n.numberSenseComparisonEighth,
        _ => throw ArgumentError.value(
            denominator,
            'denominator',
            'No localized fraction unit for this denominator.',
          ),
      };

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
          if (_state.mode == NumberSenseMode.freeExplore)
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

/// Modal chooser for a Guided skill, with an optional comparison-type step.
class _SkillChooserSheet extends StatefulWidget {
  const _SkillChooserSheet({
    required this.selectedSkill,
    required this.selectedFocus,
    required this.skillName,
    required this.focusName,
    required this.onSkill,
    required this.onFocus,
  });

  final NumberSenseGuidedSkill selectedSkill;
  final NumberSenseComparisonFocus selectedFocus;
  final String Function(NumberSenseGuidedSkill) skillName;
  final String Function(NumberSenseComparisonFocus) focusName;
  final ValueChanged<NumberSenseGuidedSkill> onSkill;
  final ValueChanged<NumberSenseComparisonFocus> onFocus;

  @override
  State<_SkillChooserSheet> createState() => _SkillChooserSheetState();
}

class _SkillChooserSheetState extends State<_SkillChooserSheet> {
  late NumberSenseGuidedSkill _skill = widget.selectedSkill;
  late NumberSenseComparisonFocus _focus = widget.selectedFocus;
  bool _choosingFocus = false;

  Widget _option({
    required String key,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) =>
      Semantics(
        container: true,
        button: true,
        selected: selected,
        label: label,
        child: ExcludeSemantics(
          child: ListTile(
            key: ValueKey(key),
            minTileHeight: 48,
            title: Text(label),
            trailing: selected ? const Icon(Icons.check) : null,
            selected: selected,
            onTap: onTap,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final List<Widget> options;
    if (_choosingFocus) {
      options = [
        for (final focus in NumberSenseComparisonFocus.values)
          _option(
            key: 'numberSense.focus.${focus.name}',
            label: widget.focusName(focus),
            selected: focus == _focus,
            onTap: () {
              widget.onFocus(focus);
              Navigator.of(context).pop();
            },
          ),
      ];
    } else {
      options = [
        for (final skill in NumberSenseGuidedSkill.values)
          _option(
            key: 'numberSense.skill.${skill.name}',
            label: widget.skillName(skill),
            selected: skill == _skill,
            onTap: () {
              widget.onSkill(skill);
              if (skill == NumberSenseGuidedSkill.compareFractions) {
                setState(() {
                  _skill = skill;
                  _focus = NumberSenseComparisonFocus.mixed;
                  _choosingFocus = true;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
      ];
    }
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          key: const ValueKey('numberSense.skillSheet'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                _choosingFocus
                    ? l10n.numberSenseChooseComparisonType
                    : l10n.numberSenseChooseSkill,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ...options,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const ValueKey('numberSense.skillSheetClose'),
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.numberSenseSkillSheetClose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
