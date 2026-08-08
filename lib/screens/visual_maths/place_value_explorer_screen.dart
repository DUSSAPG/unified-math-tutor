import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/theme/app_theme.dart';
import 'visual_maths_placeholder_scaffold.dart';

class _PlaceValueExample {
  const _PlaceValueExample(this.chips, this.captionKey);
  final List<String> chips;
  final String Function(AppLocalizations) captionKey;
}

final _examples = <_PlaceValueExample>[
  _PlaceValueExample(
      ['3,000', '700', '40', '2'], (l10n) => l10n.placeValueCaption1),
  _PlaceValueExample(['6', '0.4'], (l10n) => l10n.placeValueCaption2),
  _PlaceValueExample(['800', '0', '5'], (l10n) => l10n.placeValueCaption3),
];

/// Bounded, non-interactive Visual Maths placeholder for the future Place
/// Value Explorer — a small fixed set of static decomposition examples.
class PlaceValueExplorerScreen extends StatefulWidget {
  const PlaceValueExplorerScreen({super.key});

  @override
  State<PlaceValueExplorerScreen> createState() =>
      _PlaceValueExplorerScreenState();
}

class _PlaceValueExplorerScreenState extends State<PlaceValueExplorerScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final example = _examples[_index];
    return VisualMathsPlaceholderScaffold(
      title: l10n.visualMathsPlaceValueTitle,
      onBack: () => popOrGo(context, '/math-studio/visual-maths'),
      caption: example.captionKey(l10n),
      onTryAnother: () =>
          setState(() => _index = (_index + 1) % _examples.length),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final chip in example.chips)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.cardSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.divider),
              ),
              child: Text(
                chip,
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
