import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/exact_fraction.dart';
import '../../models/number_sense_state.dart';
import '../../services/number_sense_geometry.dart';
import 'fraction_partition_bar.dart';
import 'unit_fraction_number_line.dart';

/// A controlled workspace composing the Number Sense Lab's linked manipulatives.
class NumberSenseLabWorkspace extends StatelessWidget {
  const NumberSenseLabWorkspace({
    super.key,
    required this.state,
    required this.onChanged,
    this.reduceMotion = false,
  });

  final NumberSenseState state;
  final ValueChanged<NumberSenseState> onChanged;
  final bool reduceMotion;

  void _setFromNumberLine(ExactFraction value) {
    final shadedParts =
        NumberSenseGeometry.unitTicks(state.denominator).indexOf(value);
    if (shadedParts < 0) {
      throw StateError(
        '$value is not a tick on denominator ${state.denominator}.',
      );
    }
    onChanged(state.setShadedParts(shadedParts));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fractionLabel =
        state.mode == NumberSenseMode.freeExplore && state.shadedParts == 0
            ? '0'
            : '${state.shadedParts}/${state.denominator}';
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = constraints.maxWidth < 360 ? 12.0 : 20.0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              fractionLabel,
              key: const ValueKey('numberSenseWorkspace.fraction'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: gap),
            FractionPartitionBar(
              denominator: state.denominator,
              shadedParts: state.shadedParts,
              reduceMotion: reduceMotion,
              onChanged: (count) => onChanged(state.setShadedParts(count)),
            ),
            SizedBox(height: gap),
            UnitFractionNumberLine(
              denominator: state.denominator,
              selected: state.value,
              reduceMotion: reduceMotion,
              onChanged: _setFromNumberLine,
            ),
            SizedBox(height: gap),
            Text(
              l10n.numberSenseEqualPartsLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.numberSenseScopeStatement,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: gap),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final denominator
                    in numberSenseV1Denominators.toList()..sort())
                  ChoiceChip(
                    key: ValueKey(
                        'numberSenseWorkspace.denominator-$denominator'),
                    label: Text('$denominator'),
                    selected: denominator == state.denominator,
                    onSelected: denominator == state.denominator
                        ? null
                        : (_) => onChanged(
                              state.selectDenominator(denominator),
                            ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
