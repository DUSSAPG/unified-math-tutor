import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/abacus_state.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import 'abacus_text.dart';

/// Rod colours, shared so a rod and its Number Board digit cell match.
const abacusRodColors = {
  AbacusRod.hundreds: Color(0xFF3B82F6),
  AbacusRod.tens: Color(0xFFF59E0B),
  AbacusRod.ones: Color(0xFF10B981),
};

/// The Number Board beside (landscape) or below (portrait) the rods: one
/// large current value, Hundreds / Tens / Ones digit cells, a written-out
/// equation, and four controls (+1, −1, +10, −10).
///
/// It is a visual-clarity device for the abacus, not a calculator: it can
/// only move the same beads the rods can, so the two always agree. A control
/// whose result would leave 0..999 is disabled, never silently ignored.
class AbacusNumberBoard extends StatelessWidget {
  const AbacusNumberBoard({
    super.key,
    required this.state,
    required this.onApply,
    this.note,
    this.compact = false,
  });

  final AbacusState state;

  /// Called with +1, −1, +10 or −10; only ever for an enabled control.
  final ValueChanged<int> onApply;

  /// A short sentence about a swap between rods, if the last change had one.
  final String? note;

  /// Compact landscape: drops the heading line and trims type and padding so
  /// the value, digits and all four controls fit beside the rods without
  /// scrolling.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    final controls = <(int, String, String, String)>[
      (1, '+1', l10n.abacusBoardAddOne, 'plus1'),
      (-1, '−1', l10n.abacusBoardSubtractOne, 'minus1'),
      (10, '+10', l10n.abacusBoardAddTen, 'plus10'),
      (-10, '−10', l10n.abacusBoardSubtractTen, 'minus10'),
    ];

    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!compact) ...[
            Text(
              l10n.abacusBoardTitle.toUpperCase(),
              style: TextStyle(
                color: colors.tertiaryText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          // The readout is one live-announced unit: the spoken sentence
          // replaces the separate value, digit and equation fragments.
          Semantics(
            key: const Key('abacusBoardReadout'),
            container: true,
            liveRegion: true,
            label: AbacusText.spoken(l10n, state),
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${state.value}',
                      key: const Key('abacusBoardValue'),
                      style: TextStyle(
                        color: colors.primaryText,
                        fontSize: compact ? 44 : 56,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final rod in AbacusRod.values) ...[
                        if (rod != AbacusRod.hundreds)
                          const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _DigitCell(
                            key: Key('abacusBoardCell-${rod.name}'),
                            label: AbacusText.rodName(l10n, rod),
                            digit: state.count(rod),
                            color: abacusRodColors[rod]!,
                            compact: compact,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // One line that shrinks rather than wraps: the equation is a
                  // readout, and the spoken sentence carries it in full.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AbacusText.equation(l10n, state),
                      key: const Key('abacusBoardEquation'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              liveRegion: true,
              child: Text(
                note!,
                key: const Key('abacusBoardNote'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (delta, text, spoken, id) in controls)
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 72, minHeight: 48),
                  child: FilledButton.tonal(
                    key: Key('abacusBoardControl-$id'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onPressed:
                        state.canApply(delta) ? () => onApply(delta) : null,
                    child: Semantics(
                      label: spoken,
                      excludeSemantics: true,
                      child: Text(
                        text,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitCell extends StatelessWidget {
  const _DigitCell({
    super.key,
    required this.label,
    required this.digit,
    required this.color,
    required this.compact,
  });

  final String label;
  final int digit;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: compact ? 3 : 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            '$digit',
            style: TextStyle(
              color: colors.primaryText,
              fontSize: compact ? 26 : 30,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.secondaryText,
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
