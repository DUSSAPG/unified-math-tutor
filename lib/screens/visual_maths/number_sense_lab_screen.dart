import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/number_sense_example.dart';
import '../../models/number_sense_state.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
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
    setState(() => _state = _state.resetGuided());
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
                    ],
                    const SizedBox(height: AppSpacing.md),
                    NumberSenseLabWorkspace(
                      state: _state,
                      reduceMotion:
                          preferenceReduceMotion || systemReduceMotion,
                      onChanged: (next) => setState(() => _state = next),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_state.isGuidedComplete)
                      Semantics(
                        key: const ValueKey('numberSense.guidedCompletion'),
                        liveRegion: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            l10n.numberSenseComplete,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.primaryText,
                              fontWeight: FontWeight.w600,
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
            Text(
              '${example.primary.numerator}/${example.primary.denominator}  ?  '
              '${example.secondary!.numerator}/${example.secondary!.denominator}',
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
                  label: l10n.numberSenseCompareLessThan,
                  answer: NumberSenseComparison.lessThan,
                ),
                _comparisonChoice(
                  label: l10n.numberSenseCompareEqualTo,
                  answer: NumberSenseComparison.equal,
                ),
                _comparisonChoice(
                  label: l10n.numberSenseCompareGreaterThan,
                  answer: NumberSenseComparison.greaterThan,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _comparisonChoice({
    required String label,
    required NumberSenseComparison answer,
  }) =>
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: OutlinedButton(
          key: ValueKey('numberSense.answer.${answer.name}'),
          onPressed: () => _answerComparison(answer),
          child: Text(label),
        ),
      );

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
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: OutlinedButton(
              key: const ValueKey('numberSense.tryAnotherExample'),
              onPressed: _tryAnotherExample,
              child: Text(l10n.numberSenseTryAnotherExample),
            ),
          ),
        ],
      );
}
