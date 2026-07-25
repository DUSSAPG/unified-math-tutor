import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum MathStudioPillarId {
  buildConfidence,
  mentalMaths,
  visualMaths,
  mathMagic,
  spatialIntelligence,
  discoveryLibrary,
}

/// Single source of truth for the six RC1 Math Studio pillars and their
/// display order. The hub screen reads only structural/behavioural data
/// here — titles/subtitles stay in l10n, chosen via a switch on [id].
class MathStudioPillarMeta {
  const MathStudioPillarMeta({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.routeSuffix,
    required this.isInDevelopment,
  });

  final MathStudioPillarId id;
  final IconData icon;
  final Color iconColor;

  /// Relative to `/math-studio/`.
  final String routeSuffix;

  /// True for pillars that lead to an honest "in development" state rather
  /// than complete content. Still fully navigable — never locked/disabled.
  final bool isInDevelopment;

  static const registry = <MathStudioPillarId, MathStudioPillarMeta>{
    MathStudioPillarId.buildConfidence: MathStudioPillarMeta(
      id: MathStudioPillarId.buildConfidence,
      icon: LucideIcons.heart,
      iconColor: Color(0xFF34C759),
      routeSuffix: 'build-confidence',
      isInDevelopment: false,
    ),
    MathStudioPillarId.mentalMaths: MathStudioPillarMeta(
      id: MathStudioPillarId.mentalMaths,
      icon: LucideIcons.brain,
      iconColor: Color(0xFF5B8EFF),
      routeSuffix: 'mental-maths',
      isInDevelopment: false,
    ),
    MathStudioPillarId.visualMaths: MathStudioPillarMeta(
      id: MathStudioPillarId.visualMaths,
      icon: LucideIcons.eye,
      iconColor: Color(0xFF7C5FFF),
      routeSuffix: 'visual-maths',
      isInDevelopment: false,
    ),
    MathStudioPillarId.mathMagic: MathStudioPillarMeta(
      id: MathStudioPillarId.mathMagic,
      icon: LucideIcons.sparkles,
      iconColor: Color(0xFFE85DAA),
      routeSuffix: 'math-magic',
      isInDevelopment: true,
    ),
    MathStudioPillarId.spatialIntelligence: MathStudioPillarMeta(
      id: MathStudioPillarId.spatialIntelligence,
      icon: LucideIcons.box,
      iconColor: Color(0xFFFF7A45),
      routeSuffix: 'spatial-intelligence',
      isInDevelopment: true,
    ),
    MathStudioPillarId.discoveryLibrary: MathStudioPillarMeta(
      id: MathStudioPillarId.discoveryLibrary,
      icon: LucideIcons.layoutGrid,
      iconColor: Color(0xFFFFBD00),
      routeSuffix: 'discovery',
      isInDevelopment: false,
    ),
  };
}
