import 'package:flutter/material.dart';

import '../../models/exact_fraction.dart';
import '../../shared/theme/app_theme.dart';

/// A controlled, equally partitioned bar representing one whole.
class FractionPartitionBar extends StatelessWidget {
  FractionPartitionBar({
    super.key,
    required this.denominator,
    required this.shadedParts,
    required this.onChanged,
    this.reduceMotion = false,
  }) {
    if (!numberSenseV1Denominators.contains(denominator)) {
      throw ArgumentError.value(
        denominator,
        'denominator',
        'must be a Number Sense V1 denominator',
      );
    }
    if (shadedParts < 0 || shadedParts > denominator) {
      throw ArgumentError.value(
        shadedParts,
        'shadedParts',
        'must be between 0 and $denominator',
      );
    }
  }

  final int denominator;
  final int shadedParts;
  final ValueChanged<int> onChanged;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      key: const ValueKey('fractionPartitionBar.semantics'),
      container: true,
      label: 'Fraction bar',
      value: '$shadedParts of $denominator parts shaded',
      increasedValue: shadedParts < denominator
          ? '${shadedParts + 1} of $denominator'
          : null,
      decreasedValue:
          shadedParts > 0 ? '${shadedParts - 1} of $denominator' : null,
      onIncrease:
          shadedParts < denominator ? () => onChanged(shadedParts + 1) : null,
      onDecrease: shadedParts > 0 ? () => onChanged(shadedParts - 1) : null,
      child: ExcludeSemantics(
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              for (var index = 0; index < denominator; index++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index == denominator - 1 ? 0 : 3,
                    ),
                    child: GestureDetector(
                      key: ValueKey('fractionPartitionBar.segment-$index'),
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(
                        index == shadedParts - 1 ? index : index + 1,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: index < shadedParts
                              ? colors.accent
                              : colors.cardSurface,
                          border: Border.all(color: colors.divider),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
