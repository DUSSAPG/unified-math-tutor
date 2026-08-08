import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_theme.dart';
import 'visual_maths_placeholder_scaffold.dart';

class _FractionExample {
  const _FractionExample(this.numerator, this.denominator, this.captionKey);
  final int numerator;
  final int denominator;
  final String Function(AppLocalizations) captionKey;
}

final _examples = <_FractionExample>[
  _FractionExample(1, 2, (l10n) => l10n.fractionBarsCaption1),
  _FractionExample(2, 4, (l10n) => l10n.fractionBarsCaption2),
  _FractionExample(3, 4, (l10n) => l10n.fractionBarsCaption3),
  _FractionExample(5, 8, (l10n) => l10n.fractionBarsCaption4),
];

/// Bounded, non-interactive Visual Maths placeholder — a small fixed set of
/// static fraction-bar examples with real captions and a working "try
/// another example" cycle. Not a broken button: every control here does
/// something real, it just isn't a drag/drop interaction yet.
class FractionBarsScreen extends StatefulWidget {
  const FractionBarsScreen({super.key});

  @override
  State<FractionBarsScreen> createState() => _FractionBarsScreenState();
}

class _FractionBarsScreenState extends State<FractionBarsScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final example = _examples[_index];
    return VisualMathsPlaceholderScaffold(
      title: l10n.visualMathsFractionBarsTitle,
      onBack: () => popOrGo(context, '/math-studio/visual-maths'),
      caption: example.captionKey(l10n),
      onTryAnother: () =>
          setState(() => _index = (_index + 1) % _examples.length),
      child: _FractionBar(
          numerator: example.numerator, denominator: example.denominator),
    );
  }
}

class _FractionBar extends StatelessWidget {
  final int numerator;
  final int denominator;
  const _FractionBar({required this.numerator, required this.denominator});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      label: '$numerator out of $denominator segments filled',
      child: ExcludeSemantics(
        child: Row(
          children: [
            for (var i = 0; i < denominator; i++)
              Expanded(
                child: Container(
                  height: 56,
                  margin: EdgeInsets.only(right: i == denominator - 1 ? 0 : 2),
                  decoration: BoxDecoration(
                    color: i < numerator ? colors.accent : colors.cardSurface,
                    border: Border.all(color: colors.divider),
                    borderRadius: BorderRadius.horizontal(
                      left: i == 0 ? const Radius.circular(8) : Radius.zero,
                      right: i == denominator - 1
                          ? const Radius.circular(8)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
