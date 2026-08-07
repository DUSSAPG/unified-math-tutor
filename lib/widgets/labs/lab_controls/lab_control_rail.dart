import 'package:flutter/material.dart';

import '../../../shared/theme/app_spacing.dart';
import '../../../shared/theme/app_theme.dart';

/// Where a [LabControlRail] sits relative to a lab's primary visual (pitch,
/// radar, maze grid). [top] and [bottom] rails span the available width;
/// [left] and [right] rails are narrow vertical strips meant to sit beside
/// the primary visual on breakpoints with enough width for a side-by-side
/// layout (see `labControlHasSideRailWidth`).
enum LabControlRailPosition { top, left, right, bottom }

/// A themed control cluster container used for the top/left/right/bottom
/// control-rail primitives. Deliberately one parameterized widget rather
/// than four near-identical classes, since every rail position shares the
/// same visual language (the dark-card tokens already used throughout the
/// Interactive Labs) and only differs in axis/width.
class LabControlRail extends StatelessWidget {
  const LabControlRail({
    super.key,
    required this.position,
    required this.semanticLabel,
    required this.child,
    this.compact = false,
  });

  final LabControlRailPosition position;
  final String semanticLabel;
  final Widget child;

  /// A tighter padding/width variant for narrow phone widths where a side
  /// rail must still fit next to the primary visual.
  final bool compact;

  bool get _isSideRail =>
      position == LabControlRailPosition.left ||
      position == LabControlRailPosition.right;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = Container(
      width: _isSideRail ? (compact ? 84.0 : 108.0) : double.infinity,
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.divider),
      ),
      child: child,
    );
    return Semantics(
      container: true,
      label: semanticLabel,
      child: content,
    );
  }
}
