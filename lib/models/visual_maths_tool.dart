import 'package:flutter/material.dart';

enum VisualMathsToolId {
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
    VisualMathsToolId.numberLine: VisualMathsToolMeta(
      id: VisualMathsToolId.numberLine,
      hasInteractiveImplementation: true,
      icon: Icons.timeline,
      routeSuffix: 'number-line',
    ),
    VisualMathsToolId.fractionBars: VisualMathsToolMeta(
      id: VisualMathsToolId.fractionBars,
      hasInteractiveImplementation: false,
      icon: Icons.view_column,
      routeSuffix: 'fraction-bars',
    ),
    VisualMathsToolId.abacus: VisualMathsToolMeta(
      id: VisualMathsToolId.abacus,
      hasInteractiveImplementation: false,
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
