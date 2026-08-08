import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_theme.dart';
import 'visual_maths_placeholder_scaffold.dart';

class _AbacusExample {
  const _AbacusExample(
      {required this.ones,
      required this.tens,
      required this.hundreds,
      required this.captionKey});
  final int ones;
  final int tens;
  final int hundreds;
  final String Function(AppLocalizations) captionKey;
}

final _examples = <_AbacusExample>[
  _AbacusExample(
      ones: 1, tens: 0, hundreds: 0, captionKey: (l10n) => l10n.abacusCaption1),
  _AbacusExample(
      ones: 0, tens: 1, hundreds: 0, captionKey: (l10n) => l10n.abacusCaption2),
  _AbacusExample(
      ones: 0, tens: 0, hundreds: 1, captionKey: (l10n) => l10n.abacusCaption3),
];

/// Bounded, non-interactive Visual Maths placeholder for the future
/// Animated Abacus — a small fixed set of static place-value examples.
class AbacusScreen extends StatefulWidget {
  const AbacusScreen({super.key});

  @override
  State<AbacusScreen> createState() => _AbacusScreenState();
}

class _AbacusScreenState extends State<AbacusScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final example = _examples[_index];
    return VisualMathsPlaceholderScaffold(
      title: l10n.visualMathsAbacusTitle,
      onBack: () => popOrGo(context, '/math-studio/visual-maths'),
      caption: example.captionKey(l10n),
      onTryAnother: () =>
          setState(() => _index = (_index + 1) % _examples.length),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AbacusColumn(
              label: l10n.abacusColumnHundreds, active: example.hundreds),
          _AbacusColumn(label: l10n.abacusColumnTens, active: example.tens),
          _AbacusColumn(label: l10n.abacusColumnOnes, active: example.ones),
        ],
      ),
    );
  }
}

class _AbacusColumn extends StatelessWidget {
  final String label;
  final int active;
  const _AbacusColumn({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      label: '$label column: $active of 9 beads active',
      child: ExcludeSemantics(
        child: Column(
          children: [
            for (var i = 0; i < 9; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < active ? colors.accent : Colors.transparent,
                    border: Border.all(color: colors.divider),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(color: colors.secondaryText, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
