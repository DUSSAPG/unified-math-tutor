import 'package:flutter/material.dart';

import 'lab_control_phase.dart';

/// The shared collapse/expand engine behind both "active-play focus mode"
/// (collapsed while a lab's [LabControlPhase] is [LabControlPhase.active])
/// and the collapsible half of [LabBottomControlDrawer]. When [collapsed],
/// the child is not built at all — so it's automatically excluded from the
/// semantics tree and from keyboard/focus traversal, rather than merely
/// hidden. Animates via [AnimatedSize] unless [labReduceMotion] is true, in
/// which case the change is instant.
class LabCollapsibleControls extends StatelessWidget {
  const LabCollapsibleControls({
    super.key,
    required this.collapsed,
    required this.semanticLabel,
    required this.child,
  });

  final bool collapsed;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final content = collapsed
        ? const SizedBox.shrink()
        : Semantics(container: true, label: semanticLabel, child: child);

    if (labReduceMotion(context)) return content;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: content,
    );
  }
}
