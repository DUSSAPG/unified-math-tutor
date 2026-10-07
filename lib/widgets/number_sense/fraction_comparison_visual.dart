import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/exact_fraction.dart';
import '../../shared/theme/app_theme.dart';

/// Shows two independent fraction bars and exact positions on a shared line.
class FractionComparisonVisual extends StatefulWidget {
  const FractionComparisonVisual({
    super.key,
    required this.left,
    required this.right,
    required this.leftNumerator,
    required this.leftDenominator,
    required this.rightNumerator,
    required this.rightDenominator,
    required this.leftLabel,
    required this.rightLabel,
    required this.numberLineLabel,
  });

  final ExactFraction left;
  final ExactFraction right;
  final int leftNumerator;
  final int leftDenominator;
  final int rightNumerator;
  final int rightDenominator;
  final String leftLabel;
  final String rightLabel;
  final String numberLineLabel;

  @override
  State<FractionComparisonVisual> createState() =>
      _FractionComparisonVisualState();
}

class _FractionComparisonVisualState extends State<FractionComparisonVisual> {
  String? _selectedMarker;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FractionCard(
                keyName: 'left',
                fraction: widget.left,
                numerator: widget.leftNumerator,
                denominator: widget.leftDenominator,
                label: widget.leftLabel,
                fillColor: colors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FractionCard(
                keyName: 'right',
                fraction: widget.right,
                numerator: widget.rightNumerator,
                denominator: widget.rightDenominator,
                label: widget.rightLabel,
                fillColor: colors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Semantics(
          key: const ValueKey('numberSense.comparisonNumberLine.semantics'),
          container: true,
          label: widget.numberLineLabel,
          value: '${widget.leftLabel}; ${widget.rightLabel}',
          child: ExcludeSemantics(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const inset = 18.0;
                final usableWidth = constraints.maxWidth - inset * 2;
                final leftX = inset +
                    usableWidth *
                        widget.left.numerator /
                        widget.left.denominator;
                final rightX = inset +
                    usableWidth *
                        widget.right.numerator /
                        widget.right.denominator;
                return SizedBox(
                  key: const ValueKey('numberSense.comparisonNumberLine'),
                  height: 58,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: inset,
                        right: inset,
                        top: 23,
                        child: ColoredBox(
                          color: colors.divider,
                          child: const SizedBox(height: 3),
                        ),
                      ),
                      Positioned(
                        left: inset - 1,
                        top: 16,
                        child: _Tick(color: colors.secondaryText),
                      ),
                      Positioned(
                        right: inset - 1,
                        top: 16,
                        child: _Tick(color: colors.secondaryText),
                      ),
                      Positioned(
                        left: inset - 4,
                        top: 39,
                        child: Text('0',
                            style: TextStyle(color: colors.secondaryText)),
                      ),
                      Positioned(
                        right: inset - 4,
                        top: 39,
                        child: Text('1',
                            style: TextStyle(color: colors.secondaryText)),
                      ),
                      Positioned(
                        key: const ValueKey(
                            'numberSense.comparisonMarker.left.point'),
                        left: leftX - 7,
                        top: 17,
                        child: _Marker(color: colors.accent, diamond: false),
                      ),
                      Positioned(
                        key: const ValueKey(
                            'numberSense.comparisonMarker.right.point'),
                        left: rightX - 7,
                        top: 17,
                        child:
                            _Marker(color: colors.secondaryText, diamond: true),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _MarkerButton(
                key: const ValueKey('numberSense.comparisonMarker.left'),
                label: '${widget.leftNumerator}/${widget.leftDenominator}',
                semanticLabel: l10n.numberSenseCompareLeftMarkerSemantics,
                selected: _selectedMarker == 'left',
                diamond: false,
                onPressed: () => _selectMarker('left'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MarkerButton(
                key: const ValueKey('numberSense.comparisonMarker.right'),
                label: '${widget.rightNumerator}/${widget.rightDenominator}',
                semanticLabel: l10n.numberSenseCompareRightMarkerSemantics,
                selected: _selectedMarker == 'right',
                diamond: true,
                onPressed: () => _selectMarker('right'),
              ),
            ),
          ],
        ),
        if (_selectedMarker case final selected?) ...[
          const SizedBox(height: 8),
          Semantics(
            key: const ValueKey('numberSense.comparisonMarker.explanation'),
            liveRegion: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.divider),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_markerExplanation(l10n, selected)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _selectMarker(String side) {
    setState(() => _selectedMarker = side);
  }

  String _markerExplanation(AppLocalizations l10n, String side) {
    final isLeft = side == 'left';
    final numerator = isLeft ? widget.leftNumerator : widget.rightNumerator;
    final denominator =
        isLeft ? widget.leftDenominator : widget.rightDenominator;
    final fraction = isLeft ? widget.left : widget.right;
    final label = '$numerator/$denominator';
    final decimal = _exactDecimal(fraction);
    return l10n.numberSenseCompareMarkerExplanation(
      label,
      decimal,
      numerator,
      denominator,
    );
  }
}

String _exactDecimal(ExactFraction fraction) {
  final whole = fraction.numerator ~/ fraction.denominator;
  var remainder = fraction.numerator % fraction.denominator;
  if (remainder == 0) return '$whole';

  final digits = StringBuffer();
  final seenRemainders = <int, int>{};
  var repeatAt = -1;
  while (remainder != 0) {
    final previous = seenRemainders[remainder];
    if (previous != null) {
      repeatAt = previous;
      break;
    }
    seenRemainders[remainder] = digits.length;
    remainder *= 10;
    digits.write(remainder ~/ fraction.denominator);
    remainder %= fraction.denominator;
  }

  final value = digits.toString();
  if (repeatAt < 0) return '$whole.$value';
  final repeating = value.substring(repeatAt);
  final visibleRepeating = List.filled(3, repeating).join();
  return '$whole.${value.substring(0, repeatAt)}'
      '$visibleRepeating…';
}

class _FractionCard extends StatelessWidget {
  const _FractionCard({
    required this.keyName,
    required this.fraction,
    required this.numerator,
    required this.denominator,
    required this.label,
    required this.fillColor,
  });

  final String keyName;
  final ExactFraction fraction;
  final int numerator;
  final int denominator;
  final String label;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      key: ValueKey('numberSense.comparisonBar.$keyName.semantics'),
      container: true,
      label: label,
      value: '$numerator of $denominator equal parts',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: colors.divider),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$numerator/$denominator',
                  key: ValueKey('numberSense.comparisonFraction.$keyName'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  key: ValueKey('numberSense.comparisonBar.$keyName'),
                  height: 32,
                  child: Row(
                    children: [
                      for (var part = 0; part < denominator; part++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: part == denominator - 1 ? 0 : 3,
                            ),
                            child: DecoratedBox(
                              key: ValueKey(
                                'numberSense.comparisonBar.$keyName.part-$part',
                              ),
                              decoration: BoxDecoration(
                                color: part < numerator
                                    ? fillColor
                                    : Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkerButton extends StatelessWidget {
  const _MarkerButton({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.diamond,
    required this.onPressed,
  });

  final String label;
  final String semanticLabel;
  final bool selected;
  final bool diamond;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final markerColor = diamond ? colors.secondaryText : colors.accent;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: selected ? colors.cardSurface : Colors.transparent,
          side: BorderSide(
            color: selected ? markerColor : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Marker(color: markerColor, diamond: diamond),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check, color: markerColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: 2, height: 16, child: ColoredBox(color: color));
}

class _Marker extends StatelessWidget {
  const _Marker({required this.color, required this.diamond});
  final Color color;
  final bool diamond;

  @override
  Widget build(BuildContext context) {
    final marker = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: diamond ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: diamond ? BorderRadius.circular(2) : null,
      ),
      child: SizedBox(
        width: diamond ? 11 : 14,
        height: diamond ? 11 : 14,
      ),
    );
    return diamond ? Transform.rotate(angle: 0.785398, child: marker) : marker;
  }
}
