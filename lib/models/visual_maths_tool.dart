import 'package:flutter/material.dart';

enum VisualMathsToolId {
  numberSenseLab,
  numberLine,
  fractionBars,
  abacus,
  placeValueExplorer,
}

/// Single source of truth for which Visual Maths tools have a real
/// interactive RC1 implementation vs. a bounded static-example placeholder.
/// The hub screen reads only [hasInteractiveImplementation] to choose the
/// "Interactive"/"Preview" badge — never hard-code that distinction per-widget.
class VisualMathsToolMeta {
  const VisualMathsToolMeta({
    required this.id,
    required this.hasInteractiveImplementation,
    required this.icon,
    required this.routeSuffix,
  });

  final VisualMathsToolId id;
  final bool hasInteractiveImplementation;
  final IconData icon;
  final String routeSuffix;

  static const registry = <VisualMathsToolId, VisualMathsToolMeta>{
    VisualMathsToolId.numberSenseLab: VisualMathsToolMeta(
      id: VisualMathsToolId.numberSenseLab,
      hasInteractiveImplementation: true,
      icon: Icons.grid_view_rounded,
      routeSuffix: 'number-sense-lab',
    ),
    VisualMathsToolId.abacus: VisualMathsToolMeta(
      id: VisualMathsToolId.abacus,
      hasInteractiveImplementation: true,
      icon: Icons.grid_view,
      routeSuffix: 'abacus',
    ),
    VisualMathsToolId.placeValueExplorer: VisualMathsToolMeta(
      id: VisualMathsToolId.placeValueExplorer,
      hasInteractiveImplementation: false,
      icon: Icons.pin,
      routeSuffix: 'place-value',
    ),
  };
}
